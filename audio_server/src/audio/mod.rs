use core::fmt::Debug;
use std::fmt;
use std::fs;
use std::fs::File;
use std::io;
use std::io::BufWriter;
use std::path::Path;
use std::path::PathBuf;
use std::time::Duration;
use std::time::SystemTime;

use futures::Async;
use futures::AsyncSink;
use futures::future;
use futures::future::Either;
use futures::future::Future;
use futures::Poll;
use futures::Sink;
use futures::Stream;
use futures::sync::mpsc;
use futures::sync::oneshot;
use hound::SampleFormat;
use hound::WavSpec;
use libc::timespec;
use regex::Regex;

use crate::audio::tee::Endpoint;
use crate::audio::tee::EndpointRegistration;
use crate::audio::tee::TeeMap;
use crate::audio::tokio::PCMStream;
use crate::audio::wav::WavSink;

pub mod mio;
pub mod tokio;
pub mod tee;
pub mod wav;

const FORMAT: alsa::pcm::Format = alsa::pcm::Format::S16LE;
const CHANNELS: u32 = 2;
const SAMPLE_RATE: u32 = 44100;
const PERIOD_SIZE: alsa::pcm::Frames = 1024;
const PERIODS: u32 = 16;
const FULL_SCALE: f32 = std::i16::MAX as f32;

const BUFFER_LEN: usize = 2048;

#[derive(Fail, Debug)]
pub enum Error {
    #[fail(display = "Invalid file prefix: {}: {}", prefix, cause)]
    InvalidFilePrefix {
        prefix: String,
        #[fail(cause)] cause: regex::Error,
    },
    #[fail(display = "{}", _0)]
    IOError(#[fail(cause)] io::Error),
    #[fail(display = "{}", _0)]
    CaptureError(#[fail(cause)] alsa::Error),
    #[fail(display = "{}", _0)]
    MixerError(String),
    #[fail(display = "{}", _0)]
    WriteError(#[fail(cause)] wav::Error),
    #[fail(display = "Unknown error")]
    Unknown,
}

/// Future used to communicate back to a caller that an audio control request
/// has completed, possibly signalling an error.
pub struct ControlFuture<T> {
    rx: oneshot::Receiver<Result<T, ControlError>>
}

impl<T> ControlFuture<T> {
    pub fn channel() -> (ControlSender<T>, ControlFuture<T>) {
        let (tx, rx) = oneshot::channel();
        (tx, ControlFuture { rx })
    }
}

impl<T> Future for ControlFuture<T> {
    type Item = T;
    type Error = ControlError;

    fn poll(&mut self) -> Poll<T, ControlError> {
        match self.rx.poll() {
            Ok(Async::Ready(Ok(r))) => Ok(Async::Ready(r)),
            Ok(Async::Ready(Err(e))) => Err(e),
            Ok(Async::NotReady) => Ok(Async::NotReady),
            // The audio stream should never drop a sender before completion
            Err(_) => panic!("Audio stream has been shutdown")
        }
    }
}

type ControlSender<T> = oneshot::Sender<Result<T, ControlError>>;

#[derive(Fail, Debug)]
pub enum ControlError {
    #[fail(display = "Control was scheduled for {} but not processed until {}", scheduled_time, processed_time)]
    DeadlineMissed {
        scheduled_time: AudioTimestamp,
        processed_time: AudioTimestamp,
    },
    #[fail(display = "Control was cancelled")]
    Cancelled,
    #[fail(display = "Control failed: {}", _0)]
    Failed(#[fail(cause)] failure::Error),
}

#[derive(Debug)]
enum MixerControl {
    GetMixer(ControlSender<Vec<f32>>),
    SetMixer(Vec<f32>, ControlSender<()>),
}

#[derive(Debug)]
enum RecorderControl {
    StartRecording(AudioTimestamp, ControlSender<()>),
    StopRecording(ControlSender<()>),
    Data(Vec<i16>, alsa::pcm::Status),
    GetState(ControlSender<RecorderState>),
}

pub type LevelsStream = Endpoint<Vec<f32>>;

pub struct AudioRecorder {
    mixer_future: Box<dyn Future<Item=(), Error=()> + Send>,
    recording_future: Box<dyn Future<Item=(), Error=Error> + Send>,
}

#[derive(Clone, Debug)]
pub enum RecorderState {
    Stopped,
    Waiting(AudioTimestamp),
    Recording,
}

struct ContextPollFn<C, F> {
    ctx: Option<C>,
    inner: F,
}

impl<C, T, E, F> ContextPollFn<C, F>
    where F: FnMut(&mut C) -> Poll<T, E> {
    pub fn new(ctx: C, inner: F) -> ContextPollFn<C, F> {
        ContextPollFn { ctx: Some(ctx), inner }
    }
}

impl<C, T, E, F> Future for ContextPollFn<C, F>
    where F: FnMut(&mut C) -> Poll<T, E> {
    type Item = (C, T);
    type Error = E;

    fn poll(&mut self) -> Poll<(C, T), E> {
        match (self.inner)(&mut self.ctx.as_mut().unwrap()) {
            Ok(Async::Ready(t)) => {
                let ctx = std::mem::replace(&mut self.ctx, None).unwrap();
                Ok(Async::Ready((ctx, t)))
            }
            Ok(Async::NotReady) => Ok(Async::NotReady),
            Err(e) => Err(e)
        }
    }
}


struct MixerManager {
    control: String,
    mixer: alsa::mixer::Mixer,
}

impl MixerManager {
    pub fn new(control: String, mixer: alsa::mixer::Mixer) -> Self {
        Self {
            control,
            mixer,
        }
    }

    fn set_mixer(&self, values: &[f32]) -> Result<(), Error> {
        self.mixer.find_selem(&alsa::mixer::SelemId::new(&self.control, 0))
            .ok_or(Error::MixerError(format!(
                "Mixer control {} does not exist",
                &self.control
            ).to_owned()))
            .and_then(|s| {
                let (range_min, range_max) = s.get_capture_volume_range();
                alsa::mixer::SelemChannelId::iter()
                    .filter(|c| s.has_capture_channel((*c).clone()))
                    .zip(values.iter())
                    .map(|(c, v)| s.set_capture_volume(
                        (*c).clone(),
                        (v * (range_max - range_min) as f32) as i64 + range_min,
                    ))
                    .map(|r| r.map_err(Error::CaptureError))
                    .collect()
            })
    }

    fn get_mixer(&self) -> Result<Vec<f32>, Error> {
        self.mixer.find_selem(&alsa::mixer::SelemId::new(&self.control, 0))
            .ok_or(Error::MixerError(format!(
                "Mixer control {} does not exist",
                &self.control
            ).to_owned()))
            .and_then(|s| {
                let (range_min, range_max) = s.get_capture_volume_range();
                alsa::mixer::SelemChannelId::iter()
                    .filter(|c| s.has_capture_channel((*c).clone()))
                    .map(|c| s.get_capture_volume((*c).clone()))
                    .map(|r| r.map(|unscaled_volume| (if range_max > range_min {
                        (unscaled_volume - range_min) as f32 / (range_max - range_min) as f32
                    } else { 0f32 }) * 100f32))
                    .map(|r| r.map_err(Error::CaptureError))
                    .collect()
            })
    }

    pub fn process_control(&self, control: MixerControl) {
        // Ignore errors (we don't care if the caller stopped listening)
        match control {
            MixerControl::GetMixer(tx) => tx.send(self.get_mixer()
                .map_err(|e| ControlError::Failed(e.into()))).ok(),
            MixerControl::SetMixer(vals, tx) => tx.send(self.set_mixer(&vals)
                .map_err(|e| ControlError::Failed(e.into()))).ok()
        };
    }
}

impl Manager for MixerManager {
    type Item = MixerControl;
    type Error = ();

    fn next_future(self, control: MixerControl) -> Box<dyn Future<Item=Self, Error=()> + Send> {
        self.process_control(control);
        Box::new(future::finished(self))
    }
}

#[derive(Debug, Clone)]
pub struct AudioTimestamp {
    pub seconds: i64,
    pub nanos: i64,
}

impl AudioTimestamp {
    pub fn now() -> Self {
        SystemTime::now().into()
    }

    pub fn from_millis(millis: i64) -> Self {
        Self {
            seconds: millis / 1000,
            nanos: (millis % 1000) * 1_000_000,
        }
    }
}

impl From<libc::timespec> for AudioTimestamp {
    fn from(t: timespec) -> Self {
        Self {
            seconds: t.tv_sec as i64,
            nanos: t.tv_sec as i64,
        }
    }
}

impl From<SystemTime> for AudioTimestamp {
    fn from(t: SystemTime) -> Self {
        let since_epoch = t.duration_since(std::time::UNIX_EPOCH)
            // If we get a timestamp before the epoch, something is very wrong
            // and we should probably crash
            .expect("Timestamp earlier than epoch");
        Self {
            seconds: since_epoch.as_secs() as i64,
            nanos: since_epoch.subsec_nanos() as i64,
        }
    }
}

impl Into<SystemTime> for AudioTimestamp {
    fn into(self) -> SystemTime {
        std::time::UNIX_EPOCH + Duration::new(self.seconds as u64, self.nanos as u32)
    }
}

impl fmt::Display for AudioTimestamp {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        let system_time: SystemTime = self.clone().into();
        system_time.fmt(f)
    }
}

struct WriteManager {
    audio_dir: PathBuf,
    file_prefix: String,
    wav_spec: hound::WavSpec,
    index: u64,
    file: Option<wav::WavSink<BufWriter<File>>>,
    state: RecorderState,
    waiting_tx: Vec<ControlSender<()>>,
}

impl WriteManager {
    fn new(audio_dir: PathBuf,
           file_prefix: String,
           wav_spec: hound::WavSpec) -> Result<WriteManager, Error> {
        let index = Self::get_starting_index(
            &audio_dir,
            &file_prefix,
        )?;
        debug!("Starting file index: {}", index);

        Ok(Self {
            audio_dir,
            file_prefix,
            wav_spec,
            index,
            file: None,
            state: RecorderState::Stopped,
            waiting_tx: vec![],
        })
    }

    fn get_starting_index(audio_dir: &Path, file_prefix: &str) -> Result<u64, Error> {
        let file_name_regex = Regex::new(&format!(
            r"{}_(?P<index>\d{{4}}).wav$",
            regex::escape(&file_prefix)
        )).map_err(|e| Error::InvalidFilePrefix {
            prefix: file_prefix.to_owned(),
            cause: e,
        })?;

        Ok(fs::read_dir(&audio_dir)
            .map_err(Error::IOError)?
            // Skip over unreadable files (it is hard to get errors out of an iterator anyway, so
            // there is not much we can do about this
            .filter_map(Result::ok)
            // Assume the path is UTF-8, if it isn't the regex probably wouldn't have matched
            // anyway
            .map(|f| (*f.path().to_string_lossy()).to_owned())
            .filter_map(|f| {
                file_name_regex.captures(&f)
                    .map(|c| c.get(1).unwrap().as_str().parse::<u64>().unwrap())
            })
            // Find maximum existing file index
            .max()
            // Add one for the next index
            .map(|m| m + 1)
            // If no files match, return 0
            .unwrap_or(0))
    }

    fn new_file(self) -> impl Future<Item=Self, Error=Error> {
        self.close_file()
            .and_then(|mgr| {
                ContextPollFn::new(mgr, |mgr| {
                    match tokio_threadpool::blocking(|| {
                        let path = mgr.audio_dir.join(format!("{}_{:04}.wav", mgr.file_prefix, mgr.index));
                        info!("Created new file: {}", path.display());
                        Ok(WavSink::from_hound(hound::WavWriter::create(path, mgr.wav_spec)?))
                    }) {
                        Ok(Async::Ready(Ok(file))) => Ok(Async::Ready(file)),
                        Ok(Async::Ready(Err(e))) => Err(Error::WriteError(e)),
                        Ok(Async::NotReady) => Ok(Async::NotReady),
                        Err(_) => panic!("Called from outside Tokio thread pool")
                    }
                }).map(|(mut mgr, file)| {
                    mgr.file = Some(file);
                    mgr.index += 1;
                    mgr
                })
            })
    }

    fn close_file(mut self) -> impl Future<Item=Self, Error=Error> {
        let file = std::mem::replace(&mut self.file, None);
        if let Some(file) = file {
            Either::A(ContextPollFn::new(file, |file| file.close())
                .map_err(Error::WriteError).map(|_| self))
        } else {
            Either::B(future::finished(self))
        }
    }

    fn write_data(self, buf: Vec<i16>) -> impl Future<Item=(WriteManager, Option<Vec<i16>>), Error=wav::Error> {
        ContextPollFn::new((self, Some(buf)), |(mgr, buf)| {
            if let Some(file) = &mut mgr.file {
                match file.start_send(std::mem::replace(buf, None).unwrap()) {
                    Ok(AsyncSink::NotReady(b)) => {
                        // Buffer was not accepted, so put it back
                        std::mem::replace(buf, Some(b));
                        Ok(Async::NotReady)
                    }
                    Ok(AsyncSink::Ready) => Ok(Async::Ready(None)),
                    Err(wav::Error::FileFull(b)) => Ok(Async::Ready(Some(b))),
                    Err(e) => Err(e)
                }
            } else {
                Ok(Async::Ready(None))
            }
        }).map(|((mgr, _), buf)| (mgr, buf))
    }

    fn write_data_split(self, buf: Vec<i16>) -> impl Future<Item=Self, Error=Error> {
        self.write_data(buf).then(|res| {
            match res {
                Ok((mgr, Some(buf))) => Either::A(mgr.new_file()
                    .and_then(|mgr| mgr.write_data(buf)
                        .map_err(Error::WriteError))),
                r => Either::B(future::done(r.map_err(Error::WriteError)))
            }
        }).map(|(mgr, _)| mgr)
    }

    fn set_state_and_respond<T>(res: Result<WriteManager, Error>,
                                state: RecorderState,
                                tx: ControlSender<T>,
                                data: T) -> Result<WriteManager, Error> {
        match res {
            Ok(mut mgr) => {
                mgr.state = state;
                // We don't care if the listener disappeared
                tx.send(Ok(data)).ok();
                Ok(mgr)
            }
            Err(e) => {
                // We don't care if the listener disappeared
                tx.send(Err(ControlError::Failed(format_err!("{:?}", e)))).ok();
                Err(e)
            }
        }
    }

    fn start_recording(self, timestamp: AudioTimestamp, tx: ControlSender<()>) -> impl Future<Item=Self, Error=Error> {
        self.new_file().then(|res|
            Self::set_state_and_respond(res, RecorderState::Recording, tx, ()))
    }

    fn stop_recording(mut self, tx: ControlSender<()>) -> impl Future<Item=Self, Error=Error> {
        self.waiting_tx.drain(..).for_each(|tx| {
            tx.send(Err(ControlError::Cancelled)).ok();
        });
        self.close_file().then(|res|
            Self::set_state_and_respond(res, RecorderState::Stopped, tx, ()))
    }
}

impl Manager for WriteManager {
    type Item = RecorderControl;
    type Error = Error;

    fn next_future(self, control: RecorderControl) -> Box<dyn Future<Item=Self, Error=Error> + Send> {
        match control {
            RecorderControl::StartRecording(timestamp, tx) => Box::new(self.start_recording(timestamp, tx)),
            RecorderControl::StopRecording(tx) => Box::new(self.stop_recording(tx)),
            RecorderControl::Data(buf, _) => Box::new(self.write_data_split(buf)),
            RecorderControl::GetState(tx) => {
                tx.send(Ok(self.state.clone())).ok();
                Box::new(future::finished(self))
            }
        }
    }
}

trait Manager {
    type Item;
    type Error;

    fn next_future(self, item: Self::Item) -> Box<dyn Future<Item=Self, Error=Self::Error> + Send>;
}

struct ManagerSink<M: Manager> {
    mgr: Option<M>,
    future: Option<Box<dyn Future<Item=M, Error=M::Error> + Send>>,
}

impl<M: Manager> ManagerSink<M> {
    pub fn new(mgr: M) -> Self {
        Self {
            mgr: Some(mgr),
            future: None,
        }
    }
}

impl<M: Manager> Sink for ManagerSink<M> {
    type SinkItem = M::Item;
    type SinkError = M::Error;

    fn start_send(&mut self, item: M::Item) -> Result<AsyncSink<M::Item>, M::Error> {
        if self.future.is_none() {
            let mgr = std::mem::replace(&mut self.mgr, None).unwrap();
            self.future = Some(mgr.next_future(item));
            return Ok(AsyncSink::Ready);
        }

        match self.future.as_mut().unwrap().poll() {
            Ok(Async::Ready(mgr)) => {
                self.future = Some(mgr.next_future(item));
                Ok(AsyncSink::Ready)
            }
            Err(e) => Err(e),
            Ok(Async::NotReady) => Ok(AsyncSink::NotReady(item))
        }
    }

    fn poll_complete(&mut self) -> Poll<(), M::Error> {
        if self.future.is_some() {
            match self.future.as_mut().unwrap().poll() {
                Ok(Async::Ready(mgr)) => {
                    self.mgr = Some(mgr);
                    self.future = None;
                    Ok(Async::Ready(()))
                }
                Err(e) => Err(e),
                Ok(Async::NotReady) => Ok(Async::NotReady)
            }
        } else {
            Ok(Async::Ready(()))
        }
    }

    fn close(&mut self) -> Poll<(), M::Error> {
        self.poll_complete()
    }
}

impl AudioRecorder {
    pub fn run(self) {
        let mut runtime = ::tokio::runtime::Runtime::new().unwrap();

        runtime.spawn(self.mixer_future
            .map_err(|e| error!("Mixer error: {:?}", e)));

        runtime.spawn(self.recording_future
            .map_err(|e| error!("Audio error: {:?}", e)));

        runtime.block_on_all(future::finished::<_, ()>(()))
            .unwrap();
    }
}

pub struct AudioRecorderBuilder {
    file_prefix: String,
    audio_dir: PathBuf,
    device: String,
    control: String,
}

impl AudioRecorderBuilder {
    pub fn new<F: Into<String>, A: Into<PathBuf>>(file_prefix: F, audio_dir: A) -> Self {
        AudioRecorderBuilder {
            file_prefix: file_prefix.into(),
            audio_dir: audio_dir.into(),
            device: "default".into(),
            control: "Capture".into(),
        }
    }

    pub fn device<D: Into<String>>(mut self, device: D) -> Self {
        self.device = device.into();
        self
    }

    pub fn control<C: Into<String>>(mut self, control: C) -> Self {
        self.control = control.into();
        self
    }

    fn setup_pcm(pcm: &alsa::PCM) -> Result<(alsa::pcm::HwParams, alsa::pcm::SwParams), alsa::Error> {
        let hw_params = alsa::pcm::HwParams::any(&pcm).unwrap();

        // Data format
        hw_params.set_format(FORMAT)?;

        // Channels
        hw_params.set_channels_near(CHANNELS)?;

        // Sample rate
        // Only allow rates supported by the hardware (no resampling)
        hw_params.set_rate_resample(false)?;
        // Try to set rate to closest rate supported by the hardware
        hw_params.set_rate_near(SAMPLE_RATE, alsa::ValueOr::Nearest)?;

        // Period/buffer size
        hw_params.set_period_size_near(PERIOD_SIZE, alsa::ValueOr::Nearest)?;
        hw_params.set_periods_near(PERIODS, alsa::ValueOr::Nearest)?;

        hw_params.set_access(alsa::pcm::Access::RWInterleaved)?;

        pcm.hw_params(&hw_params)?;

        let channels = hw_params.get_channels()?;
        if channels != CHANNELS {
            warn!("Hardware does not support {} channels, using {} channels",
                  CHANNELS, channels);
        }

        let sample_rate = hw_params.get_rate()?;
        if sample_rate != SAMPLE_RATE {
            warn!("Hardware does not support desired sample rate ({} Hz), using {} Hz instead",
                  SAMPLE_RATE, sample_rate);
        }

        let period_size = hw_params.get_period_size()?;
        if period_size != PERIOD_SIZE {
            warn!("Hardware does not support desired period size ({}), using {} instead",
                  PERIOD_SIZE, period_size);
        }

        let periods = hw_params.get_periods()?;
        if periods != PERIODS {
            warn!("Hardware does not support desired periods ({}), using {} instead",
                  PERIODS, periods);
        }

        let sw_params = pcm.sw_params_current()?;

        sw_params.set_period_event(false)?;

        // Enable timestamps
        sw_params.set_tstamp_mode(true)?;

        pcm.sw_params(&sw_params)?;

        debug!("Using hardware parameters: {:?}", hw_params);
        debug!("Using software parameters: {:?}", sw_params);

        Ok((hw_params, sw_params))
    }

    pub fn build(self) -> Result<(AudioRecorder, RecorderController), Error> {
        // Recording

        let pcm = alsa::PCM::new(
            &self.device,
            alsa::Direction::Capture,
            true,
        ).map_err(Error::CaptureError)?;

        let wav_spec = {
            let (hw_params, _sw_params) =
                Self::setup_pcm(&pcm).map_err(Error::CaptureError)?;
            // These shouldn't fail once a configuration has been chosen
            let channels = hw_params.get_channels().unwrap() as u16;
            let sample_rate = hw_params.get_rate().unwrap();
            WavSpec {
                channels,
                sample_rate,
                bits_per_sample: 16,
                sample_format: SampleFormat::Int,
            }
        };

        pcm.start().map_err(Error::CaptureError)?;


        // Map set of samples to decibel levels for each channel
        let levels_map = {
            let channels = wav_spec.channels as usize;
            move |(buf, _): &(Vec<i16>, alsa::pcm::Status)| {
                let frames: usize = buf.len() / channels;
                let mut sum_squares = vec![0f32; channels];
                let mut levels = vec![0f32; channels];

                for (i, b) in buf.iter().enumerate() {
                    let b = (*b as f32).abs();
                    let channel = i % channels;
                    sum_squares[channel] += b * b;
                    if b > levels[channel] {
                        levels[channel] = b;
                    }
                }
                for i in 0..channels {
                    let rms = (sum_squares[i] / frames as f32).sqrt();
                    levels[i] = if rms > 0f32 {
                        20f32 * (levels[i] / FULL_SCALE).log10()
                    } else {
                        -1000f32
                    }
                }
                levels
            }
        };

        let (recorder_tx, recorder_rx) = futures::sync::mpsc::unbounded();

        let tstamp_config = alsa::pcm::AudioTstampConfig::new(2, true);

        let recording_stream = PCMStream::from_alsa_pcm(pcm, tstamp_config)
            .map_err(Error::CaptureError)?
            .map_err(Error::CaptureError);

        let (recording_stream, levels_endpoint_reg) =
            TeeMap::new(recording_stream, levels_map);

        let recording_stream = recording_stream
            .map(|(buf, status)| RecorderControl::Data(buf, status));

        let recording_stream = recording_stream.select(recorder_rx
            // Channels don't have errors, but we need one for the types to match
            .map_err(|_| Error::Unknown));

        let write_manager = WriteManager::new(
            self.audio_dir,
            self.file_prefix,
            wav_spec,
        )?;

        let recording_sink = ManagerSink::new(write_manager)
            .buffer(BUFFER_LEN);

        let recording_future = Box::new(recording_stream.forward(recording_sink)
            .map(|_| ()));

        // Mixer
        let (mixer_tx, mixer_rx) = futures::sync::mpsc::unbounded();

        let mixer = alsa::Mixer::new(&self.device, false)
            .map_err(Error::CaptureError)?;

        let mixer_manager = MixerManager::new(
            self.control,
            mixer,
        );

        let mixer_sink = ManagerSink::new(mixer_manager);
        let mixer_future = Box::new(mixer_rx.forward(mixer_sink)
            .map(|_| ()));

        Ok((AudioRecorder {
            mixer_future,
            recording_future,
        }, RecorderController {
            mixer_tx,
            recorder_tx,
            levels_endpoint_reg,
        }))
    }
}

#[derive(Clone)]
pub struct RecorderController {
    mixer_tx: mpsc::UnboundedSender<MixerControl>,
    recorder_tx: mpsc::UnboundedSender<RecorderControl>,
    levels_endpoint_reg: EndpointRegistration<Vec<f32>>,
}

impl RecorderController {
    fn send_mixer_control(&self, control: MixerControl) {
        self.mixer_tx.unbounded_send(control)
            .expect("Mixer shutdown");
    }

    fn send_recorder_control(&self, control: RecorderControl) {
        self.recorder_tx.unbounded_send(control)
            .expect("Audio stream shutdown");
    }

    pub fn levels_stream(&self) -> Result<LevelsStream, ControlError> {
        self.levels_endpoint_reg.add_endpoint()
            .map_err(|e| ControlError::Failed(e.into()))
    }

    pub fn get_state(&self) -> impl Future<Item=RecorderState, Error=ControlError> {
        let (tx, rx) = ControlFuture::channel();
        self.send_recorder_control(RecorderControl::GetState(tx));
        rx
    }

    pub fn start_recording(&self, time: AudioTimestamp) -> impl Future<Item=(), Error=ControlError> {
        let (tx, rx) = ControlFuture::channel();
        self.send_recorder_control(RecorderControl::StartRecording(time, tx));
        rx
    }

    pub fn stop_recording(&self) -> impl Future<Item=(), Error=ControlError> {
        let (tx, rx) = ControlFuture::channel();
        self.send_recorder_control(RecorderControl::StopRecording(tx));
        rx
    }

    pub fn set_mixer(&self, values: Vec<f32>) -> impl Future<Item=(), Error=ControlError> {
        let (tx, rx) = ControlFuture::channel();
        self.send_mixer_control(MixerControl::SetMixer(values, tx));
        rx
    }

    pub fn get_mixer(&self) -> impl Future<Item=Vec<f32>, Error=ControlError> {
        let (tx, rx) = ControlFuture::channel();
        self.send_mixer_control(MixerControl::GetMixer(tx));
        rx
    }
}