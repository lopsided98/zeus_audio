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

use audio::RecorderController;
use audio::RecorderState;
use clock;

use super::protos::audio_server::{AudioLevels, LevelsRequest, Status};
use super::protos::audio_server_grpc;
use super::protos::empty::Empty;
use super::protos::timestamp::Timestamp;
use audio::AudioTimestamp;

#[derive(Clone)]
pub struct AudioServer {
    audio: RecorderController,
    // This is not shared between server clones, because only the set_time method needs it
    time_set: bool,
}

impl AudioServer {
    pub fn new(audio: RecorderController) -> Self {
        AudioServer {
            audio,
            time_set: false,
        }
    }

    pub fn audio_control(&self) -> RecorderController {
        self.audio.clone()
    }

    fn handle_errors<F, R: 'static + Debug + Send, S>(future: F, req: R, sink: UnarySink<S>) -> impl Future<Item=(), Error=()>
        where F: futures::IntoFuture<Item=S>,
              F::Error: Debug,
              R: 'static + Debug + Send {
        future.into_future().then(|res| {
            match res {
                Ok(item) => sink.success(item),
                Err(e) => sink.fail(grpcio::RpcStatus::new(
                    grpcio::RpcStatusCode::Internal,
                    Some(format!("{:?}", e)),
                ))
            }
        }).map_err(move |e| error!("failed to reply to {:?}: {:?}", req, e))
    }

    fn spawn_success<R: 'static + Debug + Send, S>(msg: S, ctx: RpcContext, req: R, sink: UnarySink<S>) {
        ctx.spawn(sink
            .success(msg)
            .map_err(move |e| error!("failed to reply to {:?}: {:?}", req, e)));
    }
}

impl audio_server_grpc::AudioServer for AudioServer {
    fn start_recording(&mut self, ctx: RpcContext, req: Empty, sink: UnarySink<Empty>) {
        ctx.spawn(Self::handle_errors(self.audio.start_recording(AudioTimestamp::now())
                                          .map(|_| Empty::new()), req, sink));
    }

    fn stop_recording(&mut self, ctx: RpcContext, req: Empty, sink: UnarySink<Empty>) {
        ctx.spawn(Self::handle_errors(self.audio.stop_recording()
                                          .map(|_| Empty::new()), req, sink));
    }

    fn get_status(&mut self, ctx: RpcContext, req: Empty, sink: UnarySink<Status>) {
        ctx.spawn(Self::handle_errors(self.audio.get_state()
                                          .map(|state| {
                                              let mut status = Status::new();
                                              status.recording = match state {
                                                  RecorderState::Recording => true,
                                                  _ => false
                                              };
                                              status
                                          }), req, sink));
    }

    fn get_levels(&mut self, ctx: RpcContext, req: LevelsRequest, sink: ServerStreamingSink<AudioLevels>) {
        match self.audio.levels_stream() {
            Ok(levels_stream) => {
                ctx.spawn(sink.send_all(levels_stream
                    .map(move |l| {
                        let mut audio_levels = AudioLevels::new();
                        audio_levels.channels = if req.average {
                            vec![l.iter().sum::<f32>() / l.len() as f32]
                        } else { l };
                        (audio_levels, grpcio::WriteFlags::default())
                    })
                    // Send an arbitrary grpc error because the stream never sends one
                    .map_err(|_| grpcio::Error::ShutdownFailed))
                    .map(|_| ())
                    .map_err(|e| match e {
                        grpcio::Error::RemoteStopped => debug!("Remote stopped levels request"),
                        _ => error!("failed to handle audio levels request: {:?}", e)
                    }));
            }
            Err(err) => {
                error!("Unable to start levels stream: {:?}", err);
                ctx.spawn(sink.fail(grpcio::RpcStatus::new(
                    grpcio::RpcStatusCode::Internal,
                    Some(format!("{:?}", err)),
                )).map(|_| ()).map_err(|e| error!("Failed to send levels stream failure: {:?}", e)));
            }
        };
    }

    fn set_mixer(&mut self, ctx: RpcContext, req: AudioLevels, sink: UnarySink<Empty>) {
        ctx.spawn(Self::handle_errors(self.audio.set_mixer(req.channels.clone())
                                          .map(|_| Empty::new()), req, sink));
    }

    fn get_mixer(&mut self, ctx: RpcContext, req: Empty, sink: UnarySink<AudioLevels>) {
        ctx.spawn(Self::handle_errors(self.audio.get_mixer()
                                          .map(|mixer| {
                                              let mut levels = AudioLevels::new();
                                              levels.channels = mixer;
                                              levels
                                          }), req, sink));
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

pub fn run(audio: RecorderController) -> grpcio::Result<Server> {
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