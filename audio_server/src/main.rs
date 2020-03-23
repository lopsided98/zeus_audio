extern crate log;
#[macro_use]
extern crate serde_derive;

use std::fs::File;
use std::io::Write;
use std::path::Path;

use failure::ResultExt;

use audio_server::audio::AudioRecorderBuilder;
use audio_server::clock::Clock;
use audio_server::server;
use audio_server::audio::MixerEnum;

const SETTINGS_ENV_VAR: &str = "AUDIO_SERVER_SETTINGS";

#[derive(Debug, Deserialize)]
struct MixerEnumConfig {
    control: String,
    value: String,
}

impl Into<MixerEnum> for MixerEnumConfig {
    fn into(self) -> MixerEnum {
        MixerEnum {
            control: self.control,
            value: self.value,
        }
    }
}

#[derive(Debug, Deserialize)]
#[serde(default)]
struct Config {
    systemd_logging: bool,
    file_prefix: String,
    audio_dir: String,
    device: String,
    clock_master: bool,
    mixer_control: String,
    mixer_enums: Vec<MixerEnumConfig>,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            systemd_logging: false,
            file_prefix: hostname::get()
                .expect("Unable to get hostname")
                .to_string_lossy()
                .to_string(),
            audio_dir: "./audio".into(),
            device: "default".into(),
            clock_master: false,
            mixer_control: "Capture".into(),
            mixer_enums: vec![],
        }
    }
}

#[tokio::main(threaded_scheduler)]
async fn main() -> Result<(), failure::Error> {
    let config: Config = std::env::var_os(SETTINGS_ENV_VAR)
        .map(|v| File::open(Path::new(&v))
            .context("Failed to open config file")
            .and_then(|f| serde_yaml::from_reader(f)
                .context("Failed to read config file"))
            .unwrap_or_else(|err| {
                log::warn!("{}", err);
                Config::default()
            }))
        .unwrap_or_else(Config::default);

    if config.systemd_logging {
        env_logger::Builder::from_default_env()
            .format(|buf, record| {
                let level = match record.level() {
                    log::Level::Error => 3,
                    log::Level::Warn => 4,
                    log::Level::Info => 6,
                    log::Level::Debug => 7,
                    log::Level::Trace => 8
                };
                let module_path = record.module_path().unwrap_or("unknown");
                writeln!(buf, "<{}>[{}] {}", level, module_path, record.args())
            }).init();
    } else {
        env_logger::init();
    }

    log::debug!("{:?}", config);

    let (audio, audio_control) = AudioRecorderBuilder::new(config.file_prefix, config.audio_dir)
        .device(config.device)
        .mixer_control(config.mixer_control)
        .mixer_enums(config.mixer_enums.into_iter().map(|c| MixerEnum {
            control: c.control,
            value: c.value,
        }).collect::<Vec<_>>())
        .build()?;

    let clock = Clock::new(config.clock_master);

    // Store result to avoid dropping it
    let _s = server::run(audio_control, clock)?;
    log::info!("Server started");

    tokio::spawn(audio.run()).await??;

    Ok(())
}
