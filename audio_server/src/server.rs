use std::fmt::Debug;
use std::fmt::Display;
use std::sync::Arc;

use audio_server_proto::audio_server::{AudioLevels, LevelsRequest, Status};
use audio_server_proto::audio_server::StartRecordingRequest;
use audio_server_proto::audio_server::StartRecordingResponse;
use audio_server_proto::audio_server::Status_RecorderState;
use audio_server_proto::audio_server_grpc;
use audio_server_proto::empty::Empty;
use audio_server_proto::timestamp::Timestamp;
use futures::{FutureExt, StreamExt, TryFutureExt, TryStreamExt};
use futures01::sink::Sink;
use futures::compat::Future01CompatExt;
use grpcio;
use grpcio::Environment;
use grpcio::RpcContext;
use grpcio::Server;
use grpcio::ServerBuilder;
use grpcio::ServerStreamingSink;
use grpcio::UnarySink;

use crate::audio;
use crate::audio::{ControlError, RecorderController};
use crate::audio::RecorderState;
use crate::audio::timestamp::AudioTimestamp;
use crate::clock;
use crate::clock::Clock;
use tokio::runtime::Handle;

#[derive(Clone)]
pub struct AudioServer {
    audio: RecorderController,
    clock: Clock,
}

impl AudioServer {
    pub fn new(audio: RecorderController, clock: Clock) -> Self {
        AudioServer {
            audio,
            clock,
        }
    }

    pub fn audio_control(&self) -> RecorderController {
        self.audio.clone()
    }

    async fn handle_errors<F, R, S, E>(future: F, req: R, sink: UnarySink<S>)
        where F: futures::Future<Output=Result<S, E>>,
              R: 'static + Debug + Send,
              E: Display {
        match future.await {
            Ok(item) => sink.success(item),
            Err(e) => {
                log::error!("{}", e);
                sink.fail(grpcio::RpcStatus::new(
                    grpcio::RpcStatusCode::INTERNAL,
                    Some(format!("{}", e)),
                ))
            }
        }.compat()
            .await
            .map_err(move |e| log::error!("failed to reply to {:?}: {:?}", req, e))
            .ok();
    }
}

impl audio_server_grpc::AudioServer for AudioServer {
    fn start_recording(&mut self, ctx: RpcContext, req: StartRecordingRequest, sink: UnarySink<StartRecordingResponse>) {
        let time = AudioTimestamp(req.time);
        let f = self.audio.start_recording(time);
        ctx.spawn(Box::pin(Self::handle_errors::<_, _, _, ControlError>(async {
            let mut response = StartRecordingResponse::new();
            response.synced = match f.await? {
                audio::StartRecordingResponse::Synced => true,
                audio::StartRecordingResponse::NotSynced { .. } => false
            };
            Ok(response)
        }, req, sink).unit_error()).compat());
    }

    fn stop_recording(&mut self, ctx: RpcContext, req: Empty, sink: UnarySink<Empty>) {
        let f = self.audio.stop_recording();
        ctx.spawn(Box::pin(Self::handle_errors::<_, _, _, ControlError>(async {
            f.await?;
            Ok(Empty::new())
        }, req, sink).unit_error()).compat());
    }

    fn get_status(&mut self, ctx: RpcContext, req: Empty, sink: UnarySink<Status>) {
        let f = self.audio.get_state();
        ctx.spawn(Box::pin(Self::handle_errors::<_, _, _, ControlError>(f.map_ok(|state| {
            let mut status = Status::new();
            // Translate between internal state and API state
            status.recorder_state = match state {
                RecorderState::Recording(false) => Status_RecorderState::RECORDING,
                RecorderState::Recording(true) => Status_RecorderState::RECORDING_SYNCED,
                RecorderState::Waiting { recording: true, .. } => Status_RecorderState::RECORDING_WAITING,
                RecorderState::Waiting { recording: false, .. } => Status_RecorderState::STOPPED_WAITING,
                RecorderState::Stopped => Status_RecorderState::STOPPED,
            };
            status
        }), req, sink).unit_error()).compat());
    }

    fn get_levels(&mut self, ctx: RpcContext, req: LevelsRequest, sink: ServerStreamingSink<AudioLevels>) {
        match self.audio.levels_stream() {
            Ok(levels_stream) => {
                ctx.spawn(Box::pin(async {
                    match sink.send_all(levels_stream
                        .map::<Result<_, grpcio::Error>, _>(move |l| {
                            let mut audio_levels = AudioLevels::new();
                            audio_levels.channels = if req.average {
                                vec![l.iter().sum::<f32>() / l.len() as f32]
                            } else { l };
                            Ok((audio_levels, grpcio::WriteFlags::default()))
                        })
                        // Send an arbitrary grpc error because the stream never sends one
                        .map_err(|_| grpcio::Error::ShutdownFailed)
                        .compat()).compat().await {
                        Err(grpcio::Error::RemoteStopped) => log::debug!("Remote stopped levels request"),
                        Err(e) => log::error!("failed to handle audio levels request: {:?}", e),
                        _ => ()
                    };
                    Ok(())
                }).compat());
            }
            Err(err) => {
                log::error!("Unable to start levels stream: {:?}", err);
                ctx.spawn(Box::pin(async move {
                    if let Err(e) = sink.fail(grpcio::RpcStatus::new(
                        grpcio::RpcStatusCode::INTERNAL,
                        Some(format!("{:?}", err)),
                    )).compat().await {
                        log::error!("Failed to send levels stream failure: {:?}", e)
                    };
                    Ok(())
                }).compat());
            }
        };
    }

    fn set_mixer(&mut self, ctx: RpcContext, req: AudioLevels, sink: UnarySink<Empty>) {
        let mixer_fut = self.audio.set_mixer(req.channels.clone());
        ctx.spawn(Box::pin(Self::handle_errors::<_, _, _, ControlError>(async {
            mixer_fut.await?;
            Ok(Empty::new())
        }, req, sink).unit_error()).compat());
    }

    fn get_mixer(&mut self, ctx: RpcContext, req: Empty, sink: UnarySink<AudioLevels>) {
        let mixer_fut = self.audio.get_mixer();
        ctx.spawn(Box::pin(Self::handle_errors::<_, _, _, ControlError>(async {
            let mut levels = AudioLevels::new();
            levels.channels = mixer_fut.await?;
            Ok(levels)
        }, req, sink).unit_error()).compat());
    }

    fn set_time(&mut self, ctx: RpcContext, req: Timestamp, sink: UnarySink<Empty>) {
        let seconds = req.seconds as i64;
        let nanos = req.nanos as i32;
        ctx.spawn(Box::pin(Self::handle_errors::<_, _, _, clock::Error>(
            futures::future::ready(match self.clock.set_time(seconds, nanos) {
                Err(e @ clock::Error::TimeAlreadySet) => {
                    log::debug!("{}", e);
                    Ok(Empty::new())
                }
                Err(e) => Err(e),
                Ok(_) => Ok(Empty::new())
            }), req, sink).unit_error()).compat());
    }

    fn start_time_sync(&mut self, _ctx: RpcContext, req: Empty, sink: UnarySink<Empty>) {
        let start_fut = self.clock.start_sync();
        // Uses tokio::process so must be on the tokio runtime
        Handle::current().spawn(Self::handle_errors(async {
            match start_fut.await {
                Err(e @ clock::Error::TimeAlreadySet) => {
                    log::debug!("{}", e);
                    Ok(Empty::new())
                }
                Err(e) => Err(e),
                Ok(_) => Ok(Empty::new())
            }
        }, req, sink));
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