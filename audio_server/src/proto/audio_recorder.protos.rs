#[derive(Clone, PartialEq, ::prost::Message)]
pub struct StartRecordingRequest {
    #[prost(uint64, tag = "1")]
    pub time: u64,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct StartRecordingResponse {
    #[prost(bool, tag = "1")]
    pub synced: bool,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct Status {
    #[prost(enumeration = "status::RecorderState", tag = "1")]
    pub recorder_state: i32,
}
pub mod status {
    #[derive(Clone, Copy, Debug, PartialEq, Eq, Hash, PartialOrd, Ord, ::prost::Enumeration)]
    #[repr(i32)]
    pub enum RecorderState {
        Stopped = 0,
        StoppedWaiting = 1,
        Recording = 2,
        RecordingSynced = 3,
        RecordingWaiting = 4,
    }
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct LevelsRequest {
    #[prost(bool, tag = "1")]
    pub average: bool,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct AudioLevels {
    #[prost(float, repeated, tag = "1")]
    pub channels: ::std::vec::Vec<f32>,
}
#[doc = r" Generated server implementations."]
pub mod audio_server_server {
    #![allow(unused_variables, dead_code, missing_docs)]
    use tonic::codegen::*;
    #[doc = "Generated trait containing gRPC methods that should be implemented for use with AudioServerServer."]
    #[async_trait]
    pub trait AudioServer: Send + Sync + 'static {
        async fn start_recording(
            &self,
            request: tonic::Request<super::StartRecordingRequest>,
        ) -> Result<tonic::Response<super::StartRecordingResponse>, tonic::Status>;
        async fn stop_recording(
            &self,
            request: tonic::Request<()>,
        ) -> Result<tonic::Response<()>, tonic::Status>;
        async fn get_status(
            &self,
            request: tonic::Request<()>,
        ) -> Result<tonic::Response<super::Status>, tonic::Status>;
        #[doc = "Server streaming response type for the GetLevels method."]
        type GetLevelsStream: Stream<Item = Result<super::AudioLevels, tonic::Status>>
            + Send
            + Sync
            + 'static;
        async fn get_levels(
            &self,
            request: tonic::Request<super::LevelsRequest>,
        ) -> Result<tonic::Response<Self::GetLevelsStream>, tonic::Status>;
        async fn set_mixer(
            &self,
            request: tonic::Request<super::AudioLevels>,
        ) -> Result<tonic::Response<()>, tonic::Status>;
        async fn get_mixer(
            &self,
            request: tonic::Request<()>,
        ) -> Result<tonic::Response<super::AudioLevels>, tonic::Status>;
        async fn set_time(
            &self,
            request: tonic::Request<::prost_types::Timestamp>,
        ) -> Result<tonic::Response<()>, tonic::Status>;
        async fn start_time_sync(
            &self,
            request: tonic::Request<()>,
        ) -> Result<tonic::Response<()>, tonic::Status>;
    }
    #[derive(Debug)]
    #[doc(hidden)]
    pub struct AudioServerServer<T: AudioServer> {
        inner: _Inner<T>,
    }
    struct _Inner<T>(Arc<T>, Option<tonic::Interceptor>);
    impl<T: AudioServer> AudioServerServer<T> {
        pub fn new(inner: T) -> Self {
            let inner = Arc::new(inner);
            let inner = _Inner(inner, None);
            Self { inner }
        }
        pub fn with_interceptor(inner: T, interceptor: impl Into<tonic::Interceptor>) -> Self {
            let inner = Arc::new(inner);
            let inner = _Inner(inner, Some(interceptor.into()));
            Self { inner }
        }
    }
    impl<T: AudioServer> Service<http::Request<HyperBody>> for AudioServerServer<T> {
        type Response = http::Response<tonic::body::BoxBody>;
        type Error = Never;
        type Future = BoxFuture<Self::Response, Self::Error>;
        fn poll_ready(&mut self, _cx: &mut Context<'_>) -> Poll<Result<(), Self::Error>> {
            Poll::Ready(Ok(()))
        }
        fn call(&mut self, req: http::Request<HyperBody>) -> Self::Future {
            let inner = self.inner.clone();
            match req.uri().path() {
                "/audio_recorder.protos.AudioServer/StartRecording" => {
                    struct StartRecordingSvc<T: AudioServer>(pub Arc<T>);
                    impl<T: AudioServer> tonic::server::UnaryService<super::StartRecordingRequest>
                        for StartRecordingSvc<T>
                    {
                        type Response = super::StartRecordingResponse;
                        type Future = BoxFuture<tonic::Response<Self::Response>, tonic::Status>;
                        fn call(
                            &mut self,
                            request: tonic::Request<super::StartRecordingRequest>,
                        ) -> Self::Future {
                            let inner = self.0.clone();
                            let fut = async move { inner.start_recording(request).await };
                            Box::pin(fut)
                        }
                    }
                    let inner = self.inner.clone();
                    let fut = async move {
                        let interceptor = inner.1.clone();
                        let inner = inner.0;
                        let method = StartRecordingSvc(inner);
                        let codec = tonic::codec::ProstCodec::default();
                        let mut grpc = if let Some(interceptor) = interceptor {
                            tonic::server::Grpc::with_interceptor(codec, interceptor)
                        } else {
                            tonic::server::Grpc::new(codec)
                        };
                        let res = grpc.unary(method, req).await;
                        Ok(res)
                    };
                    Box::pin(fut)
                }
                "/audio_recorder.protos.AudioServer/StopRecording" => {
                    struct StopRecordingSvc<T: AudioServer>(pub Arc<T>);
                    impl<T: AudioServer> tonic::server::UnaryService<()> for StopRecordingSvc<T> {
                        type Response = ();
                        type Future = BoxFuture<tonic::Response<Self::Response>, tonic::Status>;
                        fn call(&mut self, request: tonic::Request<()>) -> Self::Future {
                            let inner = self.0.clone();
                            let fut = async move { inner.stop_recording(request).await };
                            Box::pin(fut)
                        }
                    }
                    let inner = self.inner.clone();
                    let fut = async move {
                        let interceptor = inner.1.clone();
                        let inner = inner.0;
                        let method = StopRecordingSvc(inner);
                        let codec = tonic::codec::ProstCodec::default();
                        let mut grpc = if let Some(interceptor) = interceptor {
                            tonic::server::Grpc::with_interceptor(codec, interceptor)
                        } else {
                            tonic::server::Grpc::new(codec)
                        };
                        let res = grpc.unary(method, req).await;
                        Ok(res)
                    };
                    Box::pin(fut)
                }
                "/audio_recorder.protos.AudioServer/GetStatus" => {
                    struct GetStatusSvc<T: AudioServer>(pub Arc<T>);
                    impl<T: AudioServer> tonic::server::UnaryService<()> for GetStatusSvc<T> {
                        type Response = super::Status;
                        type Future = BoxFuture<tonic::Response<Self::Response>, tonic::Status>;
                        fn call(&mut self, request: tonic::Request<()>) -> Self::Future {
                            let inner = self.0.clone();
                            let fut = async move { inner.get_status(request).await };
                            Box::pin(fut)
                        }
                    }
                    let inner = self.inner.clone();
                    let fut = async move {
                        let interceptor = inner.1.clone();
                        let inner = inner.0;
                        let method = GetStatusSvc(inner);
                        let codec = tonic::codec::ProstCodec::default();
                        let mut grpc = if let Some(interceptor) = interceptor {
                            tonic::server::Grpc::with_interceptor(codec, interceptor)
                        } else {
                            tonic::server::Grpc::new(codec)
                        };
                        let res = grpc.unary(method, req).await;
                        Ok(res)
                    };
                    Box::pin(fut)
                }
                "/audio_recorder.protos.AudioServer/GetLevels" => {
                    struct GetLevelsSvc<T: AudioServer>(pub Arc<T>);
                    impl<T: AudioServer> tonic::server::ServerStreamingService<super::LevelsRequest>
                        for GetLevelsSvc<T>
                    {
                        type Response = super::AudioLevels;
                        type ResponseStream = T::GetLevelsStream;
                        type Future =
                            BoxFuture<tonic::Response<Self::ResponseStream>, tonic::Status>;
                        fn call(
                            &mut self,
                            request: tonic::Request<super::LevelsRequest>,
                        ) -> Self::Future {
                            let inner = self.0.clone();
                            let fut = async move { inner.get_levels(request).await };
                            Box::pin(fut)
                        }
                    }
                    let inner = self.inner.clone();
                    let fut = async move {
                        let interceptor = inner.1;
                        let inner = inner.0;
                        let method = GetLevelsSvc(inner);
                        let codec = tonic::codec::ProstCodec::default();
                        let mut grpc = if let Some(interceptor) = interceptor {
                            tonic::server::Grpc::with_interceptor(codec, interceptor)
                        } else {
                            tonic::server::Grpc::new(codec)
                        };
                        let res = grpc.server_streaming(method, req).await;
                        Ok(res)
                    };
                    Box::pin(fut)
                }
                "/audio_recorder.protos.AudioServer/SetMixer" => {
                    struct SetMixerSvc<T: AudioServer>(pub Arc<T>);
                    impl<T: AudioServer> tonic::server::UnaryService<super::AudioLevels> for SetMixerSvc<T> {
                        type Response = ();
                        type Future = BoxFuture<tonic::Response<Self::Response>, tonic::Status>;
                        fn call(
                            &mut self,
                            request: tonic::Request<super::AudioLevels>,
                        ) -> Self::Future {
                            let inner = self.0.clone();
                            let fut = async move { inner.set_mixer(request).await };
                            Box::pin(fut)
                        }
                    }
                    let inner = self.inner.clone();
                    let fut = async move {
                        let interceptor = inner.1.clone();
                        let inner = inner.0;
                        let method = SetMixerSvc(inner);
                        let codec = tonic::codec::ProstCodec::default();
                        let mut grpc = if let Some(interceptor) = interceptor {
                            tonic::server::Grpc::with_interceptor(codec, interceptor)
                        } else {
                            tonic::server::Grpc::new(codec)
                        };
                        let res = grpc.unary(method, req).await;
                        Ok(res)
                    };
                    Box::pin(fut)
                }
                "/audio_recorder.protos.AudioServer/GetMixer" => {
                    struct GetMixerSvc<T: AudioServer>(pub Arc<T>);
                    impl<T: AudioServer> tonic::server::UnaryService<()> for GetMixerSvc<T> {
                        type Response = super::AudioLevels;
                        type Future = BoxFuture<tonic::Response<Self::Response>, tonic::Status>;
                        fn call(&mut self, request: tonic::Request<()>) -> Self::Future {
                            let inner = self.0.clone();
                            let fut = async move { inner.get_mixer(request).await };
                            Box::pin(fut)
                        }
                    }
                    let inner = self.inner.clone();
                    let fut = async move {
                        let interceptor = inner.1.clone();
                        let inner = inner.0;
                        let method = GetMixerSvc(inner);
                        let codec = tonic::codec::ProstCodec::default();
                        let mut grpc = if let Some(interceptor) = interceptor {
                            tonic::server::Grpc::with_interceptor(codec, interceptor)
                        } else {
                            tonic::server::Grpc::new(codec)
                        };
                        let res = grpc.unary(method, req).await;
                        Ok(res)
                    };
                    Box::pin(fut)
                }
                "/audio_recorder.protos.AudioServer/SetTime" => {
                    struct SetTimeSvc<T: AudioServer>(pub Arc<T>);
                    impl<T: AudioServer> tonic::server::UnaryService<::prost_types::Timestamp> for SetTimeSvc<T> {
                        type Response = ();
                        type Future = BoxFuture<tonic::Response<Self::Response>, tonic::Status>;
                        fn call(
                            &mut self,
                            request: tonic::Request<::prost_types::Timestamp>,
                        ) -> Self::Future {
                            let inner = self.0.clone();
                            let fut = async move { inner.set_time(request).await };
                            Box::pin(fut)
                        }
                    }
                    let inner = self.inner.clone();
                    let fut = async move {
                        let interceptor = inner.1.clone();
                        let inner = inner.0;
                        let method = SetTimeSvc(inner);
                        let codec = tonic::codec::ProstCodec::default();
                        let mut grpc = if let Some(interceptor) = interceptor {
                            tonic::server::Grpc::with_interceptor(codec, interceptor)
                        } else {
                            tonic::server::Grpc::new(codec)
                        };
                        let res = grpc.unary(method, req).await;
                        Ok(res)
                    };
                    Box::pin(fut)
                }
                "/audio_recorder.protos.AudioServer/StartTimeSync" => {
                    struct StartTimeSyncSvc<T: AudioServer>(pub Arc<T>);
                    impl<T: AudioServer> tonic::server::UnaryService<()> for StartTimeSyncSvc<T> {
                        type Response = ();
                        type Future = BoxFuture<tonic::Response<Self::Response>, tonic::Status>;
                        fn call(&mut self, request: tonic::Request<()>) -> Self::Future {
                            let inner = self.0.clone();
                            let fut = async move { inner.start_time_sync(request).await };
                            Box::pin(fut)
                        }
                    }
                    let inner = self.inner.clone();
                    let fut = async move {
                        let interceptor = inner.1.clone();
                        let inner = inner.0;
                        let method = StartTimeSyncSvc(inner);
                        let codec = tonic::codec::ProstCodec::default();
                        let mut grpc = if let Some(interceptor) = interceptor {
                            tonic::server::Grpc::with_interceptor(codec, interceptor)
                        } else {
                            tonic::server::Grpc::new(codec)
                        };
                        let res = grpc.unary(method, req).await;
                        Ok(res)
                    };
                    Box::pin(fut)
                }
                _ => Box::pin(async move {
                    Ok(http::Response::builder()
                        .status(200)
                        .header("grpc-status", "12")
                        .body(tonic::body::BoxBody::empty())
                        .unwrap())
                }),
            }
        }
    }
    impl<T: AudioServer> Clone for AudioServerServer<T> {
        fn clone(&self) -> Self {
            let inner = self.inner.clone();
            Self { inner }
        }
    }
    impl<T: AudioServer> Clone for _Inner<T> {
        fn clone(&self) -> Self {
            Self(self.0.clone(), self.1.clone())
        }
    }
    impl<T: std::fmt::Debug> std::fmt::Debug for _Inner<T> {
        fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
            write!(f, "{:?}", self.0)
        }
    }
    impl<T: AudioServer> tonic::transport::NamedService for AudioServerServer<T> {
        const NAME: &'static str = "audio_recorder.protos.AudioServer";
    }
}
