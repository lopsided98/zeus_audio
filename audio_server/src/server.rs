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

use crate::audio::RecorderController;
use crate::audio::RecorderState;
use crate::clock;

use super::protos::audio_server::{AudioLevels, LevelsRequest, Status};
use super::protos::audio_server_grpc;
use super::protos::empty::Empty;
use super::protos::timestamp::Timestamp;
use crate::audio::timestamp::AudioTimestamp;
use crate::clock::Clock;
use std::fmt::Display;
use crate::protos::audio_server::Status_RecorderState;
use crate::protos::audio_server::StartRecordingResponse;
use crate::audio;
use crate::protos::audio_server::StartRecordingRequest;

#[derive(Clone)]
pub struct AudioServer {
    audio: RecorderController,
    clock: Clock,
    runtime: Arc<tokio::runtime::Runtime>,
}

impl AudioServer {
    pub fn new(audio: RecorderController, clock: Clock) -> Self {
        AudioServer {
            audio,
            clock,
            runtime: Arc::new(tokio::runtime::Runtime::new().unwrap()),
        }
    }

    pub fn audio_control(&self) -> RecorderController {
        self.audio.clone()
    }

    fn handle_errors<F, R: 'static + Debug + Send, S, E>(future: F, req: R, sink: UnarySink<S>) -> impl Future<Item=(), Error=()>
        where F: futures::IntoFuture<Item=S, Error=E>,
              F::Error: Debug,
              R: 'static + Debug + Send,
              E: Display {
        future.into_future().then(|res| {
            match res {
                Ok(item) => sink.success(item),
                Err(e) => {
                    error!("{}", e);
                    sink.fail(grpcio::RpcStatus::new(
                        grpcio::RpcStatusCode::Internal,
                        Some(format!("{}", e)),
                    ))
                }
            }
        }).map_err(move |e| error!("failed to reply to {:?}: {:?}", req, e))
    }
}

impl audio_server_grpc::AudioServer for AudioServer {
    fn start_recording(&mut self, ctx: RpcContext, req: StartRecordingRequest, sink: UnarySink<StartRecordingResponse>) {
        let time = AudioTimestamp(req.time);
        ctx.spawn(Self::handle_errors(self.audio.start_recording(time)
                                          .and_then(|res| {
                                              let mut response = StartRecordingResponse::new();
                                              response.synced = match res {
                                                  audio::StartRecordingResponse::Synced => true,
                                                  audio::StartRecordingResponse::NotSynced { .. } => false
                                              };
                                              Ok(response)
                                          }), req, sink));
    }

    fn stop_recording(&mut self, ctx: RpcContext, req: Empty, sink: UnarySink<Empty>) {
        ctx.spawn(Self::handle_errors(self.audio.stop_recording()
                                          .map(|_| Empty::new()), req, sink));
    }

    fn get_status(&mut self, ctx: RpcContext, req: Empty, sink: UnarySink<Status>) {
        ctx.spawn(Self::handle_errors(self.audio.get_state()
                                          .map(|state| {
                                              let mut status = Status::new();
                                              status.recorder_state = match state {
                                                  RecorderState::Recording => Status_RecorderState::RECORDING,
                                                  RecorderState::Waiting(_) => Status_RecorderState::WAITING,
                                                  RecorderState::Stopped => Status_RecorderState::STOPPED,
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
        let seconds = req.seconds as i64;
        let nanos = req.nanos as i32;
        ctx.spawn(Self::handle_errors(self.clock.set_time(seconds, nanos)
                                          .or_else(|e| match e {
                                              clock::Error::TimeAlreadySet => {
                                                  debug!("{}", e);
                                                  Ok(())
                                              }
                                              _ => Err(e)
                                          })
                                          .map(|_| Empty::new()), req, sink));
    }

    fn start_time_sync(&mut self, _ctx: RpcContext, req: Empty, sink: UnarySink<Empty>) {
        self.runtime.executor().clone()
            .spawn(Self::handle_errors(self.clock.start_sync()
                                           .map(|_| Empty::new()), req, sink));
    }
}

pub fn run(audio: RecorderController, clock: Clock) -> grpcio::Result<Server> {
    let env = Arc::new(Environment::new(1));
    let service = audio_server_grpc::create_audio_server(AudioServer::new(audio, clock));
    let mut server = ServerBuilder::new(env)
        .register_service(service)
        .bind("[::1]", 34876)
        .bind("127.0.0.1", 34876)
        .build()?;
    server.start();

    Ok(server)
}