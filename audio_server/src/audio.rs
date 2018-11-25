use std::fs;
use std::fs::File;
use std::io;
use std::io::BufWriter;
use std::path::PathBuf;
use std::sync::Arc;
use std::sync::atomic::AtomicBool;
use std::sync::atomic::Ordering;
use std::sync::Condvar;
use std::sync::mpsc;
use std::sync::Mutex;

use futures::Async;
use futures::Poll;
use futures::Stream;
use futures::task;
use hound::SampleFormat;
use hound::WavSpec;
use hound::WavWriter;
use regex::Regex;

const FORMAT: alsa::pcm::Format = alsa::pcm::Format::S16LE;
const CHANNELS: u32 = 2;
const SAMPLE_RATE: u32 = 44100;
const PERIOD_SIZE: alsa::pcm::Frames = 1024;
const PERIODS: u32 = 16;
const FULL_SCALE: f32 = std::i16::MAX as f32;

const BYTES_PER_SAMPLE: usize = 2;
// Max number of samples to request per poll
const SAMPLES_BUF_SIZE: usize = PERIOD_SIZE as usize * PERIODS as usize;
// 2GB (many programs read WAV using a signed 32 bit integer)
const MAX_FILE_SAMPLES: usize = std::i32::MAX as usize / BYTES_PER_SAMPLE;


#[derive(Debug)]
pub enum Error {
    InvalidFilePrefix(regex::Error),
    IOError(io::Error),
    CaptureError(alsa::Error),
    MixerError(String),
    WriteError(hound::Error),
    UnknownError,
}

#[derive(Debug)]
enum Event {
    Recording(bool),
}

#[derive(Debug)]
enum WriterEvent {
    NewFile,
    CloseFile,
    Data(Vec<i16>),
}

pub type Levels = (Condvar, Mutex<Option<Vec<f32>>>);

pub struct LevelsStream {
    levels: Arc<Levels>,
    levels_task_tx: mpsc::Sender<task::Task>,
}

impl LevelsStream {
    fn new(audio: &AudioRecorder) -> Self {
        let levels = Arc::clone(&audio.levels);
        let levels_task_tx = mpsc::Sender::clone(
            &audio.levels_task_tx.lock().unwrap());
        Self { levels, levels_task_tx }
    }
}

impl Stream for LevelsStream {
    type Item = Vec<f32>;
    type Error = ();

    fn poll(&mut self) -> Poll<Option<Self::Item>, Self::Error> {
        let mut levels = None;
        {
            let mut levels_guard = self.levels.1.lock().unwrap();
            std::mem::swap(&mut levels, &mut levels_guard);
        }
        if let Some(levels) = levels {
            Ok(Async::Ready(Some(levels)))
        } else {
            // Should never fail because AudioRecorder owns receiver
            self.levels_task_tx.send(task::current()).unwrap();
            Ok(Async::NotReady)
        }
    }
}

pub struct AudioRecorder {
    control: String,
    recording: AtomicBool,
    audio_dir: PathBuf,
    file_prefix: String,
    event_tx: Mutex<mpsc::Sender<Event>>,
    event_rx: Mutex<mpsc::Receiver<Event>>,
    levels_task_tx: Mutex<mpsc::Sender<task::Task>>,
    levels_task_rx: Mutex<mpsc::Receiver<task::Task>>,
    levels: Arc<Levels>,
    wav_spec: WavSpec,
    pcm: Mutex<alsa::PCM>,
    mixer: Mutex<alsa::Mixer>,
}

impl AudioRecorder {
    pub fn is_recording(&self) -> bool {
        return self.recording.load(Ordering::Relaxed);
    }

    pub fn set_recording(&self, recording: bool) {
        let was_recording = self.recording.swap(recording, Ordering::Relaxed);
        if was_recording != recording {
            let event_tx = mpsc::Sender::clone(&self.event_tx.lock().unwrap());
            // Should never fail because AudioRecorder owns receiver
            event_tx.send(Event::Recording(recording)).unwrap();
        }
    }

    pub fn set_mixer(&self, values: &Vec<f32>) -> Result<(), Error> {
        self.mixer.lock().unwrap()
            .find_selem(&alsa::mixer::SelemId::new(&self.control, 0))
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

    pub fn get_mixer(&self) -> Result<Vec<f32>, Error> {
        self.mixer.lock().unwrap()
            .find_selem(&alsa::mixer::SelemId::new(&self.control, 0))
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

    pub fn levels_stream(&self) -> LevelsStream {
        LevelsStream::new(self)
    }

    /// Calculate max decibel levels for each channel of a set of samples
    fn db(&self, buf: &[i16]) -> Vec<f32> {
        let channels = self.wav_spec.channels as usize;
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

    fn get_starting_index(&self) -> Result<u64, Error> {
        let file_name_regex = Regex::new(&format!(
            r"{}_(?P<index>\d{{4}}).wav$",
            regex::escape(&self.file_prefix)
        )).map_err(Error::InvalidFilePrefix)?;

        Ok(fs::read_dir(&self.audio_dir)
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

    fn new_file(&self, index: u64) -> Result<WavWriter<BufWriter<File>>, hound::Error> {
        let path = self.audio_dir.join(format!("{}_{:04}.wav", self.file_prefix, index));
        info!("Created new file: {}", path.display());
        WavWriter::create(path, self.wav_spec)
    }

    fn writer_thread(&self, starting_index: u64, rx: mpsc::Receiver<WriterEvent>) -> Result<(), Error> {
        let mut file_index = starting_index;
        let mut file: Option<WavWriter<BufWriter<File>>> = None;

        loop {
            match rx.recv() {
                Ok(WriterEvent::NewFile) => {
                    if let Some(ref mut old_file) = &mut file {
                        old_file.flush().map_err(Error::WriteError)?;
                    }
                    file = Some(self.new_file(file_index).map_err(Error::WriteError)?);
                    file_index += 1;
                }
                Ok(WriterEvent::CloseFile) => {
                    if let Some(ref mut old_file) = &mut file {
                        old_file.flush().map_err(Error::WriteError)?;
                    } else {
                        warn!("Attempt to close file, but no open file");
                    }
                    file = None;
                }
                Ok(WriterEvent::Data(ref buf)) => {
                    let mut new_file;
                    if let Some(ref mut file) = &mut file {
                        new_file = buf.len() + file.len() as usize > MAX_FILE_SAMPLES;
                    } else {
                        panic!("Attempted to write data, but no file open");
                    }
                    if new_file {
                        file = Some(self.new_file(file_index).map_err(Error::WriteError)?);
                        file_index += 1;
                    }
                    if let Some(ref mut cur_file) = &mut file {
                        for b in buf {
                            cur_file.write_sample(*b).map_err(Error::WriteError)?;
                        }
                    }
                }
                Err(_) => break
            }
        }
        Ok(())
    }

    pub fn run(&self) -> Result<(), Error> {
        // Only one thread should ever call this at a time, so if the lock fails, panic
        let pcm = self.pcm.try_lock()
            .expect("Only one thread may run an AudioRecorder");
        // The format is guaranteed to be correct, so this should never fail
        let io = pcm.io_i16().unwrap();

        let event_rx = self.event_rx.try_lock().unwrap();
        let levels_task_rx = self.levels_task_rx.try_lock().unwrap();
        let (writer_tx, writer_rx) = mpsc::channel();

        pcm.start().map_err(Error::CaptureError)?;

        let starting_index = self.get_starting_index()?;
        debug!("Starting file index: {}", starting_index);

        let mut recording = false;

        // Result of the writer thread
        let mut writer_result = Ok(());
        // Result of the audio loop
        let audio_result = {
            crossbeam::scope(|scope| -> Result<(), Error> {
                scope.spawn(|_| writer_result = self.writer_thread(starting_index, writer_rx));

                loop {
                    match event_rx.try_recv() {
                        Ok(Event::Recording(event_recording)) => {
                            assert_ne!(recording, event_recording);
                            recording = event_recording;
                            if recording {
                                info!("Started recording");
                                writer_tx.send(WriterEvent::NewFile)
                                    .map_err(|_| Error::UnknownError)?;
                            } else {
                                info!("Stopped recording");
                                writer_tx.send(WriterEvent::CloseFile)
                                    .map_err(|_| Error::UnknownError)?;
                            }
                        }
                        Err(mpsc::TryRecvError::Empty) => (),
                        // Should never happen because AudioRecorder owns a Sender
                        Err(mpsc::TryRecvError::Disconnected) =>
                            panic!("Event transmitter disconnected")
                    }

                    'poll: loop {
                        let poll_fds = alsa::poll::poll_all(&[&*pcm], 1000)
                            .map_err(Error::CaptureError)?;

                        for (_, flags) in poll_fds {
                            if flags.contains(alsa::poll::POLLIN) {
                                break 'poll;
                            }
                        }
                    }

                    pcm.avail_update().map_err(Error::CaptureError)?;

                    {
                        let mut mmap_result: Result<(), Error> = Ok(());
                        io.mmap(SAMPLES_BUF_SIZE, |buf| {
                            let (ref levels_cvar, ref levels_lock) = *self.levels;
                            {
                                let mut levels = levels_lock.lock().unwrap();
                                if let None = *levels {
                                    let db = self.db(buf);
                                    *levels = Some(db);
                                }
                                levels_cvar.notify_all();
                            }

                            if recording {
                                mmap_result = writer_tx.send(WriterEvent::Data(buf.into()))
                                    .map_err(|_| Error::UnknownError);
                            }

                            buf.len() / self.wav_spec.channels as usize
                        }).map(|_| ())
                            .or_else(|err| pcm.try_recover(err, false))
                            .map_err(Error::CaptureError)?;
                        mmap_result
                    }?;

                    loop {
                        match levels_task_rx.try_recv() {
                            Ok(task) => task.notify(),
                            Err(mpsc::TryRecvError::Empty) => break,
                            // Should never happen because AudioRecorder owns a Sender
                            Err(mpsc::TryRecvError::Disconnected) =>
                                panic!("Levels task transmitter disconnected")
                        }
                    }
                }
            }).unwrap()
        };
        // Report writer error and then audio error if writer did not fail
        writer_result.and(audio_result)
    }
}

unsafe impl Send for AudioRecorder {}

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

    fn set_params(pcm: &alsa::PCM) -> Result<(alsa::pcm::HwParams, alsa::pcm::SwParams), alsa::Error> {
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

        hw_params.set_access(alsa::pcm::Access::MMapInterleaved)?;

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

        sw_params.set_period_event(true)?;

        pcm.sw_params(&sw_params)?;

        debug!("Using hardware parameters: {:?}", hw_params);
        debug!("Using software parameters: {:?}", sw_params);

        Ok((hw_params, sw_params))
    }

    pub fn build(self) -> Result<AudioRecorder, Error> {
        let (event_tx, event_rx) = mpsc::channel();
        let (levels_task_tx, levels_task_rx) = mpsc::channel();

        let pcm = alsa::PCM::new(
            &self.device,
            alsa::Direction::Capture,
            false,
        ).map_err(Error::CaptureError)?;

        let wav_spec = {
            let (hw_params, _sw_params) =
                Self::set_params(&pcm).map_err(Error::CaptureError)?;
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

        let mixer = alsa::Mixer::new(&self.device, false)
            .map_err(Error::CaptureError)?;


        Ok(AudioRecorder {
            control: self.control,
            recording: AtomicBool::new(false),
            audio_dir: self.audio_dir,
            file_prefix: self.file_prefix,
            event_tx: Mutex::new(event_tx),
            event_rx: Mutex::new(event_rx),
            levels_task_tx: Mutex::new(levels_task_tx),
            levels_task_rx: Mutex::new(levels_task_rx),
            levels: Arc::new((Condvar::new(), Mutex::new(None))),
            wav_spec,
            pcm: Mutex::new(pcm),
            mixer: Mutex::new(mixer),
        })
    }
}

