#[macro_use]
extern crate log;
#[macro_use]
extern crate serde_derive;

use std::fs::File;
use std::path::Path;

use failure::ResultExt;

use audio_server::audio::AudioRecorderBuilder;
use audio_server::server;
use audio_server::clock::Clock;

const SETTINGS_ENV_VAR: &str = "AUDIO_SERVER_SETTINGS";

#[derive(Debug, Deserialize)]
#[serde(default)]
struct Config {
    file_prefix: String,
    audio_dir: String,
    device: String,
    control: String,
    clock_master: bool,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            file_prefix: hostname::get_hostname().expect("Unable to get hostname"),
            audio_dir: "./audio".into(),
            device: "default".into(),
            control: "Capture".into(),
            clock_master: false,
        }
    }
}

fn main() -> Result<(), failure::Error> {
    env_logger::init();

    let config: Config = std::env::var_os(SETTINGS_ENV_VAR)
        .map(|v| File::open(Path::new(&v))
            .context("Failed to open config file")
            .and_then(|f| serde_yaml::from_reader(f)
                .context("Failed to read config file"))
            .unwrap_or_else(|err| {
                warn!("{}", err);
                Config::default()
            }))
        .unwrap_or_else(Config::default);


    debug!("{:?}", config);

    let (audio, audio_control) = AudioRecorderBuilder::new(config.file_prefix, config.audio_dir)
        .device(config.device)
        .control(config.control)
        .build()?;

    let clock = Clock::new(config.clock_master);

    let _s = server::run(audio_control, clock)?;
    info!("Server started");

    audio.run();

    Ok(())
}
