use std::fs;
use std::fs::File;
use std::io::BufWriter;
use std::path::Path;
use std::path::PathBuf;
use std::pin::Pin;

use failure::Fail;
use futures::channel::mpsc;
use futures::channel::oneshot;
use futures::future;
use futures::Future;
use futures::FutureExt;
use futures::SinkExt;
use futures::StreamExt;
use futures::TryFutureExt;
use futures::TryStreamExt;
use hound::SampleFormat;
use hound::WavSpec;
use regex::Regex;

use crate::audio::tee::Endpoint;
use crate::audio::tee::EndpointRegistration;
use crate::audio::tee::TeeMap;
use crate::audio::timestamp::AudioTimestamp;
use crate::audio::tokio::PCMStream;
use crate::audio::wav::WavSink;
use crate::manager::Manager;
use crate::manager::ManagerSink;

pub mod mio;
pub mod tee;
pub mod timestamp;
pub mod tokio;
pub mod wav;

const FORMAT: alsa::pcm::Format = alsa::pcm::Format::S16LE;
const CHANNELS: u32 = 2;
const SAMPLE_RATE: u32 = 44100;
const PERIOD_SIZE: alsa::pcm::Frames = 1024;
const PERIODS: u32 = 16;
const FULL_SCALE: f32 = std::i16::MAX as f32;

const BUFFER_LEN: usize = 2048;

/// Maximum amount of time to wait to start recording
const MAX_START_WAIT: AudioTimestamp = AudioTimestamp(10_000_000_000);

#[derive(Fail, Debug)]
pub enum Error {
    #[fail(display = "Invalid file prefix: {}: {}", prefix, cause)]
    InvalidFilePrefix {
        prefix: String,
        #[fail(cause)] cause: regex::Error,
    },
    #[fail(display = "{}", _0)]
    SetupError(#[fail(cause)] failure::Error),
    #[fail(display = "{}", _0)]
    CaptureError(#[fail(cause)] failure::Error),
    #[fail(display = "{}", _0)]
    MixerError(#[fail(cause)] failure::Error),
    #[fail(display = "{}", _0)]
    WriteError(#[fail(cause)] failure::Error),
    #[fail(display = "Unknown error")]
    Unknown,
}

#[derive(Fail, Debug)]
pub enum ControlError {
    #[fail(display = "Control was cancelled")]
    Cancelled,
    #[fail(display = "Control failed: {}", _0)]
    Failed(#[fail(cause)] failure::Error),
}

type ControlResult<T> = Result<T, ControlError>;
type ControlSender<T> = oneshot::Sender<ControlResult<T>>;
type ControlReceiver<T> = oneshot::Receiver<ControlResult<T>>;

#[derive(Debug)]
enum MixerControl {
    GetMixer(ControlSender<Vec<f32>>),
    SetMixer(Vec<f32>, ControlSender<()>),
}

#[derive(Clone, Debug)]
pub enum StartRecordingResponse {
    Synced,
    NotSynced {
        requested_time: AudioTimestamp,
        processed_time: AudioTimestamp,
    },
}

#[derive(Clone, Debug)]
pub enum RecorderState {
    Stopped,
    Waiting {
        timestamp: AudioTimestamp,
        recording: bool, // Whether we were already recording
    },
    Recording(bool),
}

#[derive(Debug)]
enum RecorderControl {
    StartRecording(AudioTimestamp, ControlSender<StartRecordingResponse>),
    StopRecording(ControlSender<()>),
    Data(Vec<i16>, AudioTimestamp),
    GetState(ControlSender<RecorderState>),
}

pub type LevelsStream = Endpoint<Vec<f32>>;

pub struct Recorder {
    mixer_future: Pin<Box<dyn Future<Output=()> + Send>>,
    recording_future: Pin<Box<dyn Future<Output=Result<(), Error>> + Send>>,
}

#[derive(Debug)]
pub struct MixerEnum {
    pub control: String,
    pub value: String,
}

struct MixerManager {
    control: String,
    mixer: alsa::mixer::Mixer,
}

impl MixerManager {
    pub fn new(control: String, enums: &[MixerEnum], mixer: alsa::mixer::Mixer) -> Self {
        let m = Self {
            control,
            mixer,
        };
        for e in enums {
            m.set_enum(e).unwrap_or_else(|e| {
                log::warn!("Failed to set enum: {}", e)
            });
        }
        m
    }

    fn get_selem(&self, name: &str) -> Result<alsa::mixer::Selem, Error> {
        self.mixer.find_selem(&alsa::mixer::SelemId::new(name, 0))
            .ok_or(Error::MixerError(failure::format_err!(
                "Mixer control '{}' does not exist",
                &name
            )))
    }

    fn set_enum(&self, e: &MixerEnum) -> Result<(), Error> {
        self.get_selem(&e.control)
            .and_then(|s| if s.is_enumerated() {
                Ok(s)
            } else {
                Err(Error::MixerError(failure::format_err!(
                    "Mixer control '{}' is not enumerated",
                    &e.control
                )))
            })
            .and_then(|s| {
                let vals = s.iter_enum()
                    .map_err(|err| Error::MixerError(err.into()))?;
                for (i, val) in vals.enumerate() {
                    let val = val.map_err(|err| Error::MixerError(err.into()))?;
                    if val == e.value {
                        alsa::mixer::SelemChannelId::all().iter()
                            .filter(|c| s.has_capture_channel((*c).clone()) ||
                                s.has_playback_channel((*c).clone()))
                            .map(|c| s.set_enum_item((*c).clone(), i as u32))
                            .collect::<Result<_, _>>()
                            .map_err(|e| Error::MixerError(e.into()))?;
                        log::debug!("Set enum control '{}' to '{}'", &e.control, &e.value);
                        return Ok(());
                    }
                }
                Err(Error::MixerError(failure::format_err!("Enum value '{}' for control '{}' does not exist",
                    &e.value, &e.control)))
            })
    }

    fn set_mixer(&self, values: &[f32]) -> Result<(), Error> {
        self.get_selem(&self.control).and_then(|s| {
            let (range_min, range_max) = s.get_capture_volume_range();
            alsa::mixer::SelemChannelId::all().iter()
                .filter(|c| s.has_capture_channel((*c).clone()))
                .zip(values.iter())
                .map(|(c, v)| s.set_capture_volume(
                    (*c).clone(),
                    (v * (range_max - range_min) as f32) as i64 + range_min,
                ))
                .map(|r| r.map_err(|e| Error::MixerError(e.into())))
                .collect()
        })
    }

    fn get_mixer(&self) -> Result<Vec<f32>, Error> {
        self.get_selem(&self.control).and_then(|s| {
            let (range_min, range_max) = s.get_capture_volume_range();
            alsa::mixer::SelemChannelId::all().iter()
                .filter(|c| s.has_capture_channel((*c).clone()))
                .map(|c| s.get_capture_volume((*c).clone()))
                .map(|r| r.map(|unscaled_volume| (if range_max > range_min {
                    (unscaled_volume - range_min) as f32 / (range_max - range_min) as f32
                } else { 0f32 }) * 100f32))
                .map(|r| r.map_err(|e| Error::CaptureError(e.into())))
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

    fn next_future(self, control: MixerControl) -> Pin<Box<dyn Future<Output=Result<Self, ()>> + Send>> {
        self.process_control(control);
        Box::pin(future::ready(Ok(self)))
    }
}

struct WriteManager {
    audio_dir: PathBuf,
    file_prefix: String,
    wav_spec: hound::WavSpec,
    index: u64,
    file: Option<wav::WavSink<BufWriter<File>>>,
    state: RecorderState,
    waiting_tx: Vec<ControlSender<StartRecordingResponse>>,
}

impl WriteManager {
    fn new(audio_dir: PathBuf,
           file_prefix: String,
           wav_spec: hound::WavSpec) -> Result<WriteManager, Error> {
        let index = Self::get_starting_index(
            &audio_dir,
            &file_prefix,
        )?;
        log::debug!("Starting file index: {}", index);

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
            .map_err(|e| Error::WriteError(e
                .context(format!("Failed to read audio dir: {}", audio_dir.display())).into()))?
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

    async fn new_file(&mut self) -> Result<(), Error> {
        self.close_file().await?;
        self.file = Some(::tokio::task::block_in_place(|| {
            let path = self.audio_dir.join(format!("{}_{:04}.wav", self.file_prefix, self.index));
            log::info!("Creating new file: {}", path.display());
            Ok(WavSink::from_hound(hound::WavWriter::create(path, self.wav_spec)?))
        }).map_err(Error::WriteError)?);
        self.index += 1;
        Ok(())
    }

    async fn close_file(&mut self) -> Result<(), Error> {
        let file = std::mem::replace(&mut self.file, None);
        if let Some(mut file) = file {
            file.close().await.map_err(|e| Error::WriteError(e.into()))
        } else {
            Ok(())
        }
    }

    async fn write_data(&mut self, buf: Vec<i16>) -> Result<Option<Vec<i16>>, Error> {
        if let Some(file) = &mut self.file {
            match file.send(buf).await {
                Ok(()) => Ok(None),
                Err(wav::Error::FileFull(b)) => Ok(Some(b)),
                Err(e) => Err(Error::WriteError(e.into()))
            }
        } else {
            Ok(None)
        }
    }

    async fn write_data_split(&mut self, buf: Vec<i16>) -> Result<(), Error> {
        if let Some(leftover_buf) = self.write_data(buf).await? {
            self.new_file().await?;
            // Assume that a new file will not have a leftover buffer
            self.write_data(leftover_buf).await?;
        }
        Ok(())
    }

    async fn write_data_sync(&mut self, mut buf: Vec<i16>, start_timestamp: AudioTimestamp) -> Result<(), Error> {
        let mut new_file = false;
        let mut start_recording_response: Option<StartRecordingResponse> = None;
        let mut old_buf: Vec<i16> = vec![];

        if let RecorderState::Waiting { timestamp: start_time, .. } = &self.state {
            let period = 1_000_000_000 / self.wav_spec.sample_rate as u64;
            let buf_time = period * (buf.len() / self.wav_spec.channels as usize) as u64;
            let end_timestamp = &start_timestamp + buf_time;

            if **start_time >= *start_timestamp && **start_time < *end_timestamp {
                let start_index = (((**start_time - *start_timestamp) / period) * self.wav_spec.channels as u64) as usize;
                log::debug!("Started synchronized recording: time: {}, split point: {}", start_time, start_index);
                new_file = true;
                start_recording_response = Some(StartRecordingResponse::Synced);
                // Buffer that will be written to the already open file
                old_buf = buf.drain(..start_index).collect::<Vec<i16>>();
            } else if **start_time < *start_timestamp {
                log::warn!("Missed start time: {}, buffer start time: {}", start_time, start_timestamp);
                new_file = true;
                start_recording_response = Some(StartRecordingResponse::NotSynced {
                    requested_time: start_time.clone(),
                    processed_time: start_timestamp,
                });
            } else if *(start_time - &end_timestamp) > *MAX_START_WAIT {
                log::warn!("Start time ({}) too far into future, starting now", start_time);
                new_file = true;
                start_recording_response = Some(StartRecordingResponse::NotSynced {
                    requested_time: start_time.clone(),
                    processed_time: end_timestamp,
                });
            }
        }
        self.write_data_split(old_buf).await?;
        if new_file {
            self.new_file().await?;
        }
        if let Some(start_recording_response) = start_recording_response {
            self.state = RecorderState::Recording(match start_recording_response {
                StartRecordingResponse::Synced => true,
                StartRecordingResponse::NotSynced { .. } => false
            });
            self.waiting_tx.drain(..).for_each(|tx| {
                tx.send(Ok(start_recording_response.clone())).ok();
            });
        }
        self.write_data_split(buf).await?;
        Ok(())
    }

    fn set_state_and_respond<T>(&mut self, res: Result<(), Error>, state: RecorderState,
                                tx: ControlSender<T>, data: T) -> Result<(), Error> {
        match res {
            Ok(_) => {
                self.state = state;
                // We don't care if the listener disappeared
                tx.send(Ok(data)).ok();
                Ok(())
            }
            Err(e) => {
                // We don't care if the listener disappeared
                tx.send(Err(ControlError::Failed(failure::format_err!("{:?}", e)))).ok();
                Err(e)
            }
        }
    }

    fn start_recording(&mut self, timestamp: AudioTimestamp, tx: ControlSender<StartRecordingResponse>)
                       -> Result<(), Error> {
        self.waiting_tx.drain(..).for_each(|tx| {
            tx.send(Err(ControlError::Cancelled)).ok();
        });

        self.state = RecorderState::Waiting {
            timestamp,
            recording: match self.state {
                RecorderState::Recording(_) => true,
                _ => false
            },
        };
        self.waiting_tx.push(tx);
        Ok(())
    }

    async fn stop_recording(&mut self, tx: ControlSender<()>) -> Result<(), Error> {
        self.waiting_tx.drain(..).for_each(|tx| {
            tx.send(Err(ControlError::Cancelled)).ok();
        });
        let res = self.close_file().await;
        self.set_state_and_respond(res, RecorderState::Stopped, tx, ())
    }
}

impl Manager for WriteManager {
    type Item = RecorderControl;
    type Error = Error;

    fn next_future(mut self, control: RecorderControl) -> Pin<Box<dyn Future<Output=Result<Self, Error>> + Send>> {
        Box::pin(async {
            match control {
                RecorderControl::StartRecording(timestamp, tx) => self.start_recording(timestamp, tx)?,
                RecorderControl::StopRecording(tx) => self.stop_recording(tx).await?,
                RecorderControl::Data(buf, status) => self.write_data_sync(buf, status).await?,
                RecorderControl::GetState(tx) => {
                    tx.send(Ok(self.state.clone())).ok();
                    ()
                }
            };
            Ok(self)
        })
    }
}

impl Recorder {
    pub async fn run(self) -> Result<(), Error> {
        let (_, recording_res) = futures::join!(self.mixer_future, self.recording_future);
        recording_res
    }
}

pub struct AudioRecorderBuilder {
    file_prefix: String,
    audio_dir: PathBuf,
    device: String,
    mixer_control: String,
    mixer_enums: Vec<MixerEnum>,
}

impl AudioRecorderBuilder {
    pub fn new<F: Into<String>, A: Into<PathBuf>>(file_prefix: F, audio_dir: A) -> Self {
        AudioRecorderBuilder {
            file_prefix: file_prefix.into(),
            audio_dir: audio_dir.into(),
            device: "default".into(),
            mixer_control: "Capture".into(),
            mixer_enums: vec![],
        }
    }

    pub fn device<D: Into<String>>(mut self, device: D) -> Self {
        self.device = device.into();
        self
    }

    pub fn mixer_control<C: Into<String>>(mut self, control: C) -> Self {
        self.mixer_control = control.into();
        self
    }

    pub fn mixer_enums<V: Into<Vec<MixerEnum>>>(mut self, enums: V) -> Self {
        self.mixer_enums = enums.into();
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
            log::warn!("Hardware does not support {} channels, using {} channels",
                  CHANNELS, channels);
        }

        let sample_rate = hw_params.get_rate()?;
        if sample_rate != SAMPLE_RATE {
            log::warn!("Hardware does not support desired sample rate ({} Hz), using {} Hz instead",
                  SAMPLE_RATE, sample_rate);
        }

        let period_size = hw_params.get_period_size()?;
        if period_size != PERIOD_SIZE {
            log::warn!("Hardware does not support desired period size ({}), using {} instead",
                  PERIOD_SIZE, period_size);
        }

        let periods = hw_params.get_periods()?;
        if periods != PERIODS {
            log::warn!("Hardware does not support desired periods ({}), using {} instead",
                  PERIODS, periods);
        }

        let sw_params = pcm.sw_params_current()?;

        sw_params.set_period_event(false)?;

        // Enable timestamps
        sw_params.set_tstamp_mode(true)?;
        sw_params.set_tstamp_type(alsa::pcm::TstampType::GetTimeOfDay)?;

        pcm.sw_params(&sw_params)?;

        log::debug!("Using hardware parameters: {:?}", hw_params);
        log::debug!("Using software parameters: {:?}", sw_params);

        Ok((hw_params, sw_params))
    }

    pub fn build(self) -> Result<(Recorder, RecorderController), Error> {
        // Recording

        let pcm = alsa::PCM::new(
            &self.device,
            alsa::Direction::Capture,
            true,
        ).map_err(|e| Error::CaptureError(e.into()))?;

        let wav_spec = {
            let (hw_params, _sw_params) =
                Self::setup_pcm(&pcm).map_err(|e| Error::CaptureError(e.into()))?;
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

        pcm.start().map_err(|e| Error::CaptureError(e.into()))?;


        // Map set of samples to decibel levels for each channel
        let levels_map = {
            let channels = wav_spec.channels as usize;
            move |(buf, _): &(Vec<i16>, AudioTimestamp)| {
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

        let (recorder_tx, recorder_rx) = futures::channel::mpsc::unbounded();

        let recording_stream = PCMStream::from_alsa_pcm(pcm)
            .map_err(|e| Error::CaptureError(e.into()))?
            .map_err(|e| Error::CaptureError(e.into()));

        let (recording_stream, levels_endpoint_reg) =
            TeeMap::new(recording_stream, levels_map);

        let recording_stream = recording_stream
            .map_ok(|(buf, timestamp)| RecorderControl::Data(buf, timestamp));

        let recording_stream = futures::stream::select(recording_stream, recorder_rx.map(Ok));

        let write_manager = WriteManager::new(
            self.audio_dir,
            self.file_prefix,
            wav_spec,
        )?;

        let recording_sink = ManagerSink::new(write_manager)
            .buffer(BUFFER_LEN);

        let recording_future = Box::pin(recording_stream.forward(recording_sink)
            .map_ok(|_| ()));

        // Mixer
        let (mixer_tx, mixer_rx) = mpsc::unbounded();

        let mixer = alsa::Mixer::new(&self.device, false)
            .map_err(|e| Error::CaptureError(e.into()))?;

        let mixer_manager = MixerManager::new(
            self.mixer_control,
            &self.mixer_enums,
            mixer,
        );

        let mixer_sink = ManagerSink::new(mixer_manager);
        let mixer_future = Box::pin(mixer_rx
            .map(Ok)
            .forward(mixer_sink)
            .map(|_| ()));

        Ok((Recorder {
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
    fn send_mixer_control<T>(&mut self, rx: ControlReceiver<T>, control: MixerControl) -> impl Future<Output=ControlResult<T>> {
        self.mixer_tx.unbounded_send(control)
            .expect("Mixer shutdown");
        // If the sending end of the oneshot is dropped automatically respond with a cancelled error
        rx.unwrap_or_else(|_| Err(ControlError::Cancelled))
    }

    fn send_recorder_control<T>(&mut self, rx: ControlReceiver<T>, control: RecorderControl) -> impl Future<Output=ControlResult<T>> {
        self.recorder_tx.unbounded_send(control)
            .expect("Audio stream shutdown");
        // If the sending end of the oneshot is dropped automatically respond with a cancelled error
        rx.unwrap_or_else(|_| Err(ControlError::Cancelled))
    }

    pub fn levels_stream(&self) -> Result<LevelsStream, ControlError> {
        self.levels_endpoint_reg.add_endpoint()
            .map_err(|e| ControlError::Failed(e.into()))
    }

    pub fn get_state(&mut self) -> impl Future<Output=ControlResult<RecorderState>> {
        let (tx, rx) = oneshot::channel();
        self.send_recorder_control(rx, RecorderControl::GetState(tx))
    }

    pub fn start_recording(&mut self, time: AudioTimestamp) -> impl Future<Output=ControlResult<StartRecordingResponse>> {
        let (tx, rx) = oneshot::channel();
        self.send_recorder_control(rx, RecorderControl::StartRecording(time, tx))
    }

    pub fn stop_recording(&mut self) -> impl Future<Output=ControlResult<()>> {
        let (tx, rx) = oneshot::channel();
        self.send_recorder_control(rx, RecorderControl::StopRecording(tx))
    }

    pub fn set_mixer(&mut self, values: Vec<f32>) -> impl Future<Output=ControlResult<()>> {
        let (tx, rx) = oneshot::channel();
        self.send_mixer_control(rx, MixerControl::SetMixer(values, tx))
    }

    pub fn get_mixer(&mut self) -> impl Future<Output=ControlResult<Vec<f32>>> {
        let (tx, rx) = oneshot::channel();
        self.send_mixer_control(rx, MixerControl::GetMixer(tx))
    }
}