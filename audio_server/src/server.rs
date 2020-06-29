use std::fmt::Display;

use futures::channel::mpsc;
use futures::StreamExt;
use prost_types::Timestamp;
use tonic::{Request, Response};
use tonic::transport::Server;

use crate::audio;
use crate::audio::RecorderController;
use crate::audio::RecorderState;
use crate::audio::timestamp::AudioTimestamp;
use crate::clock;
use crate::clock::Clock;
use crate::proto::audio_server;
use crate::proto::audio_server::{AudioLevels, LevelsRequest, StartRecordingRequest, StartRecordingResponse, Status, status};
use crate::proto::audio_server::audio_server_server::AudioServerServer;

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

    fn map_status<E: Display>(err: E) -> tonic::Status {
        log::error!("{}", err);
        tonic::Status::new(tonic::Code::Internal, format!("{}", err))
    }
}

#[tonic::async_trait]
impl audio_server::audio_server_server::AudioServer for AudioServer {
    async fn start_recording(&self, req: Request<StartRecordingRequest>) -> Result<Response<StartRecordingResponse>, tonic::Status> {
        let time = AudioTimestamp(req.get_ref().time);
        Ok(Response::new(StartRecordingResponse {
            synced: match self.audio.start_recording(time).await
                .map_err(Self::map_status)? {
                audio::StartRecordingResponse::Synced => true,
                audio::StartRecordingResponse::NotSynced { .. } => false
            }
        }))
    }

    async fn stop_recording(&self, _request: Request<()>) -> Result<Response<()>, tonic::Status> {
        self.audio.stop_recording().await.map_err(Self::map_status)?;
        Ok(Response::new(()))
    }

    async fn get_status(&self, _request: Request<()>) -> Result<Response<Status>, tonic::Status> {
        // Translate between internal state and API state
        Ok(Response::new(Status {
            recorder_state: match self.audio.get_state().await
                .map_err(Self::map_status)? {
                RecorderState::Recording(false) => status::RecorderState::Recording,
                RecorderState::Recording(true) => status::RecorderState::RecordingSynced,
                RecorderState::Waiting { recording: true, .. } => status::RecorderState::RecordingWaiting,
                RecorderState::Waiting { recording: false, .. } => status::RecorderState::StoppedWaiting,
                RecorderState::Stopped => status::RecorderState::Stopped,
            }.into()
        }))
    }

    type GetLevelsStream = mpsc::Receiver<Result<AudioLevels, tonic::Status>>;

    async fn get_levels(&self, req: Request<LevelsRequest>) -> Result<Response<Self::GetLevelsStream>, tonic::Status> {
        // channel is needed because stream is not Sync
        let (tx, rx) = mpsc::channel(0);
        tokio::spawn(self.audio.levels_stream()
            .map_err(Self::map_status)?
            .map(move |l| {
                Ok(AudioLevels {
                    channels: if req.get_ref().average {
                        vec![l.iter().sum::<f32>() / l.len() as f32]
                    } else { l }
                })
            })
            .map(Ok)
            .forward(tx));
        Ok(Response::new(rx))
    }

    async fn set_mixer(&self, request: Request<AudioLevels>) -> Result<Response<()>, tonic::Status> {
        self.audio.set_mixer(request.into_inner().channels).await
            .map_err(Self::map_status)?;
        Ok(Response::new(()))
    }

    async fn get_mixer(&self, _request: Request<()>) -> Result<Response<AudioLevels>, tonic::Status> {
        Ok(Response::new(AudioLevels {
            channels: self.audio.get_mixer().await.map_err(Self::map_status)?
        }))
    }

    async fn set_time(&self, req: Request<Timestamp>) -> Result<Response<()>, tonic::Status> {
        let seconds = req.get_ref().seconds as i64;
        let nanos = req.get_ref().nanos as i32;
        match self.clock.set_time(seconds, nanos) {
            Err(e @ clock::Error::TimeAlreadySet) => {
                log::debug!("{}", e);
                Ok(())
            }
            Err(e) => Err(e),
            Ok(_) => Ok(())
        }.map_err(|e| {
            log::warn!("{}", e);
            tonic::Status::new(tonic::Code::FailedPrecondition, format!("{}", e))
        })?;
        Ok(Response::new(()))
    }

    async fn start_time_sync(&self, _request: Request<()>) -> Result<Response<()>, tonic::Status> {
        match self.clock.start_sync().await {
            Err(e @ clock::Error::TimeAlreadySet) => {
                log::debug!("{}", e);
                Ok(())
            }
            Err(e) => Err(e),
            Ok(_) => Ok(())
        }.map_err(|e| {
            log::warn!("{}", e);
            tonic::Status::new(tonic::Code::FailedPrecondition, format!("{}", e))
        })?;
        Ok(Response::new(()))
    }
}

pub async fn run(audio: RecorderController, clock: Clock) -> Result<(), failure::Error> {
    let service = AudioServer::new(audio, clock);
    let server = AudioServerServer::new(service);
    let ipv4_server = Server::builder()
        .add_service(server.clone())
        .serve("127.0.0.1:34876".parse()?);
    let ipv6_server = Server::builder()
        .add_service(server)
        .serve("[::1]:34876".parse()?);
    futures::future::try_join(
        ipv4_server,
        ipv6_server
    ).await?;
    Ok(())
}