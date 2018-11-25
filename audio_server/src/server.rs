use std::fmt::Debug;
use std::sync::Arc;

use futures::Future;
use futures::Sink;
use futures::Stream;
use grpcio;
use grpcio::Environment;
use grpcio::RpcContext;
use grpcio::Server;
use grpcio::ServerBuilder;
use grpcio::ServerStreamingSink;
use grpcio::UnarySink;

use clock;

use super::audio::AudioRecorder;
use super::protos::audio_server::{AudioLevels, LevelsRequest, Status};
use super::protos::audio_server_grpc;
use super::protos::empty::Empty;
use super::protos::timestamp::Timestamp;

#[derive(Clone)]
pub struct AudioServer {
    audio: Arc<AudioRecorder>,
    // This is not shared between server clones, because only the set_time method needs it
    time_set: bool,
}

impl AudioServer {
    pub fn new(audio: Arc<AudioRecorder>) -> Self {
        AudioServer {
            audio,
            time_set: false,
        }
    }

    pub fn audio(&self) -> Arc<AudioRecorder> {
        Arc::clone(&self.audio)
    }

    fn spawn_success<R: 'static + Debug + Send, S>(msg: S, ctx: RpcContext, req: R, sink: UnarySink<S>) {
        ctx.spawn(sink
            .success(msg)
            .map_err(move |e| error!("failed to reply to {:?}: {:?}", req, e)));
    }
}

impl audio_server_grpc::AudioServer for AudioServer {
    fn start_recording(&mut self, ctx: RpcContext, req: Empty, sink: UnarySink<Empty>) {
        self.audio.set_recording(true);
        Self::spawn_success(Empty::new(), ctx, req, sink);
    }

    fn stop_recording(&mut self, ctx: RpcContext, req: Empty, sink: UnarySink<Empty>) {
        self.audio.set_recording(false);
        Self::spawn_success(Empty::new(), ctx, req, sink);
    }

    fn get_status(&mut self, ctx: RpcContext, req: Empty, sink: UnarySink<Status>) {
        let mut status = Status::new();
        status.recording = self.audio.is_recording();
        Self::spawn_success(status, ctx, req, sink);
    }

    fn get_levels(&mut self, ctx: RpcContext, req: LevelsRequest, sink: ServerStreamingSink<AudioLevels>) {
        let audio = Arc::clone(&self.audio);
        ctx.spawn(sink.send_all(audio.levels_stream()
            // Levels stream never returns an error, so the error mapping doesn't matter
            .map_err(|_| grpcio::Error::ShutdownFailed)
            .map(move |l| {
                let mut audio_levels = AudioLevels::new();
                audio_levels.channels = if req.average {
                    vec![l.iter().sum::<f32>() / l.len() as f32]
                } else { l };
                (audio_levels, grpcio::WriteFlags::default())
            }))
            .map(|_| ())
            .map_err(|e| match e {
                grpcio::Error::RemoteStopped => debug!("Remote stopped levels request"),
                _ => error!("failed to handle audio levels request: {:?}", e)
            }));
    }

    fn set_mixer(&mut self, ctx: RpcContext, req: AudioLevels, sink: UnarySink<Empty>) {
        let res = self.audio.set_mixer(&req.channels);
        ctx.spawn((if res.is_ok() { sink.success(Empty::new()) } else {
            let err = res.unwrap_err();
            warn!("Unable to set res volume: {:?}", err);
            sink.fail(grpcio::RpcStatus::new(
                grpcio::RpcStatusCode::Internal,
                Some(format!("{:?}", err)),
            ))
        }).map(|_| ()).map_err(move |e| error!("failed to reply to {:?}: {:?}", req, e)))
    }

    fn get_mixer(&mut self, ctx: RpcContext, req: Empty, sink: UnarySink<AudioLevels>) {
        let mut levels = AudioLevels::new();
        let mixer = self.audio.get_mixer();
        ctx.spawn((if mixer.is_ok() {
            levels.channels = mixer.unwrap();
            sink.success(levels)
        } else {
            let err = mixer.unwrap_err();
            warn!("Unable to get mixer volume: {:?}", err);
            sink.fail(grpcio::RpcStatus::new(
                grpcio::RpcStatusCode::Internal,
                Some(format!("{:?}", err)),
            ))
        }).map(|_| ()).map_err(move |e| error!("failed to reply to {:?}: {:?}", req, e)))
    }

    fn set_time(&mut self, ctx: RpcContext, req: Timestamp, sink: UnarySink<Empty>) {
        if !self.time_set {
            let r = clock::set_time(req.seconds as u64, req.nanos as u32);
            match r {
                Ok(_) => {
                    self.time_set = true;
                    info!("System time set to: {:?}", std::time::Instant::now());
                }
                Err(e) => warn!("Failed to set system time: {}", e)
            }
        } else {
            debug!("System time is already set, ignoring request");
        }

        Self::spawn_success(Empty::new(), ctx, req, sink);
    }
}

pub fn run(audio: Arc<AudioRecorder>) -> grpcio::Result<Server> {
    let env = Arc::new(Environment::new(1));
    let service = audio_server_grpc::create_audio_server(AudioServer::new(audio));
    let mut server = ServerBuilder::new(env)
        .register_service(service)
        .bind("[::1]", 34876)
        .bind("127.0.0.1", 34876)
        .build()?;
    server.start();

    Ok(server)
}