extern crate audio_server;
extern crate env_logger;
extern crate hostname;
#[macro_use]
extern crate log;
extern crate serde;
#[macro_use]
extern crate serde_derive;

use std::fmt;
use std::sync::Arc;
use std::thread;

use audio_server::audio::AudioRecorderBuilder;
use audio_server::server;

const SETTINGS_ENV_VAR: &str = "AUDIO_SERVER_SETTINGS";

#[derive(Debug)]
enum ConfigError {
    InvalidEnvVar(std::env::VarError),
    InvalidConfig(serde_yaml::Error),
}

impl fmt::Display for ConfigError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            ConfigError::InvalidEnvVar(e) => write!(f, "Invalid environment variable: {}", e),
            ConfigError::InvalidConfig(e) => write!(f, "Invalid config: {}", e),
        }
    }
}

#[derive(Debug, Deserialize)]
#[serde(default)]
struct Config {
    file_prefix: String,
    audio_dir: String,
    device: String,
    control: String,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            file_prefix: hostname::get_hostname().expect("Unable to get hostname"),
            audio_dir: "./audio".into(),
            device: "default".into(),
            control: "Capture".into(),
        }
    }
}

fn main() {
    env_logger::init().expect("Failed to initialize logging");

    let config: Config = std::env::var(SETTINGS_ENV_VAR)
        .map_err(ConfigError::InvalidEnvVar)
        .and_then(|s| serde_yaml::from_str(&s).map_err(ConfigError::InvalidConfig))
        .unwrap_or_else(|err| {
            if let ConfigError::InvalidConfig(_v) = &err {
                warn!("{}", err);
            }
            Config::default()
        });

    debug!("{:?}", config);

    let audio = Arc::new(AudioRecorderBuilder::new(config.file_prefix, config.audio_dir)
        .device(config.device)
        .control(config.control)
        .build()
        .expect("Failed to setup audio recorder"));

    let _s = server::run(audio.clone()).expect("Failed to start server");
    info!("Server started");

    audio.run().expect("Audio error");

    loop { thread::park(); }
}
