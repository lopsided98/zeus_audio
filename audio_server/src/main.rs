extern crate audio_server;
extern crate env_logger;
#[macro_use]
extern crate failure;
extern crate hostname;
#[macro_use]
extern crate log;
extern crate serde;
#[macro_use]
extern crate serde_derive;

use audio_server::audio::AudioRecorderBuilder;
use audio_server::server;

const SETTINGS_ENV_VAR: &str = "AUDIO_SERVER_SETTINGS";

#[derive(Fail, Debug)]
enum ConfigError {
    #[fail(display = "Invalid environment variable: {}", _0)]
    InvalidEnvVar(std::env::VarError),
    #[fail(display = "Invalid config: {}", _0)]
    InvalidConfig(serde_yaml::Error),
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
    env_logger::init();

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

    let (audio, audio_control) = AudioRecorderBuilder::new(config.file_prefix, config.audio_dir)
        .device(config.device)
        .control(config.control)
        .build()
        .expect("Failed to setup audio recorder");

    let _s = server::run(audio_control.clone()).expect("Failed to start server");
    info!("Server started");

    audio.run();
}
