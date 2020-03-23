// This file is generated. Do not edit
// @generated

// https://github.com/Manishearth/rust-clippy/issues/702
#![allow(unknown_lints)]
#![allow(clippy::all)]

#![cfg_attr(rustfmt, rustfmt_skip)]

#![allow(box_pointers)]
#![allow(dead_code)]
#![allow(missing_docs)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]
#![allow(non_upper_case_globals)]
#![allow(trivial_casts)]
#![allow(unsafe_code)]
#![allow(unused_imports)]
#![allow(unused_results)]

const METHOD_AUDIO_SERVER_START_RECORDING: ::grpcio::Method<super::audio_server::StartRecordingRequest, super::audio_server::StartRecordingResponse> = ::grpcio::Method {
    ty: ::grpcio::MethodType::Unary,
    name: "/audio_recorder.protos.AudioServer/StartRecording",
    req_mar: ::grpcio::Marshaller { ser: ::grpcio::pb_ser, de: ::grpcio::pb_de },
    resp_mar: ::grpcio::Marshaller { ser: ::grpcio::pb_ser, de: ::grpcio::pb_de },
};

const METHOD_AUDIO_SERVER_STOP_RECORDING: ::grpcio::Method<super::empty::Empty, super::empty::Empty> = ::grpcio::Method {
    ty: ::grpcio::MethodType::Unary,
    name: "/audio_recorder.protos.AudioServer/StopRecording",
    req_mar: ::grpcio::Marshaller { ser: ::grpcio::pb_ser, de: ::grpcio::pb_de },
    resp_mar: ::grpcio::Marshaller { ser: ::grpcio::pb_ser, de: ::grpcio::pb_de },
};

const METHOD_AUDIO_SERVER_GET_STATUS: ::grpcio::Method<super::empty::Empty, super::audio_server::Status> = ::grpcio::Method {
    ty: ::grpcio::MethodType::Unary,
    name: "/audio_recorder.protos.AudioServer/GetStatus",
    req_mar: ::grpcio::Marshaller { ser: ::grpcio::pb_ser, de: ::grpcio::pb_de },
    resp_mar: ::grpcio::Marshaller { ser: ::grpcio::pb_ser, de: ::grpcio::pb_de },
};

const METHOD_AUDIO_SERVER_GET_LEVELS: ::grpcio::Method<super::audio_server::LevelsRequest, super::audio_server::AudioLevels> = ::grpcio::Method {
    ty: ::grpcio::MethodType::ServerStreaming,
    name: "/audio_recorder.protos.AudioServer/GetLevels",
    req_mar: ::grpcio::Marshaller { ser: ::grpcio::pb_ser, de: ::grpcio::pb_de },
    resp_mar: ::grpcio::Marshaller { ser: ::grpcio::pb_ser, de: ::grpcio::pb_de },
};

const METHOD_AUDIO_SERVER_SET_MIXER: ::grpcio::Method<super::audio_server::AudioLevels, super::empty::Empty> = ::grpcio::Method {
    ty: ::grpcio::MethodType::Unary,
    name: "/audio_recorder.protos.AudioServer/SetMixer",
    req_mar: ::grpcio::Marshaller { ser: ::grpcio::pb_ser, de: ::grpcio::pb_de },
    resp_mar: ::grpcio::Marshaller { ser: ::grpcio::pb_ser, de: ::grpcio::pb_de },
};

const METHOD_AUDIO_SERVER_GET_MIXER: ::grpcio::Method<super::empty::Empty, super::audio_server::AudioLevels> = ::grpcio::Method {
    ty: ::grpcio::MethodType::Unary,
    name: "/audio_recorder.protos.AudioServer/GetMixer",
    req_mar: ::grpcio::Marshaller { ser: ::grpcio::pb_ser, de: ::grpcio::pb_de },
    resp_mar: ::grpcio::Marshaller { ser: ::grpcio::pb_ser, de: ::grpcio::pb_de },
};

const METHOD_AUDIO_SERVER_SET_TIME: ::grpcio::Method<super::timestamp::Timestamp, super::empty::Empty> = ::grpcio::Method {
    ty: ::grpcio::MethodType::Unary,
    name: "/audio_recorder.protos.AudioServer/SetTime",
    req_mar: ::grpcio::Marshaller { ser: ::grpcio::pb_ser, de: ::grpcio::pb_de },
    resp_mar: ::grpcio::Marshaller { ser: ::grpcio::pb_ser, de: ::grpcio::pb_de },
};

const METHOD_AUDIO_SERVER_START_TIME_SYNC: ::grpcio::Method<super::empty::Empty, super::empty::Empty> = ::grpcio::Method {
    ty: ::grpcio::MethodType::Unary,
    name: "/audio_recorder.protos.AudioServer/StartTimeSync",
    req_mar: ::grpcio::Marshaller { ser: ::grpcio::pb_ser, de: ::grpcio::pb_de },
    resp_mar: ::grpcio::Marshaller { ser: ::grpcio::pb_ser, de: ::grpcio::pb_de },
};

#[derive(Clone)]
pub struct AudioServerClient {
    client: ::grpcio::Client,
}

impl AudioServerClient {
    pub fn new(channel: ::grpcio::Channel) -> Self {
        AudioServerClient {
            client: ::grpcio::Client::new(channel),
        }
    }

    pub fn start_recording_opt(&self, req: &super::audio_server::StartRecordingRequest, opt: ::grpcio::CallOption) -> ::grpcio::Result<super::audio_server::StartRecordingResponse> {
        self.client.unary_call(&METHOD_AUDIO_SERVER_START_RECORDING, req, opt)
    }

    pub fn start_recording(&self, req: &super::audio_server::StartRecordingRequest) -> ::grpcio::Result<super::audio_server::StartRecordingResponse> {
        self.start_recording_opt(req, ::grpcio::CallOption::default())
    }

    pub fn start_recording_async_opt(&self, req: &super::audio_server::StartRecordingRequest, opt: ::grpcio::CallOption) -> ::grpcio::Result<::grpcio::ClientUnaryReceiver<super::audio_server::StartRecordingResponse>> {
        self.client.unary_call_async(&METHOD_AUDIO_SERVER_START_RECORDING, req, opt)
    }

    pub fn start_recording_async(&self, req: &super::audio_server::StartRecordingRequest) -> ::grpcio::Result<::grpcio::ClientUnaryReceiver<super::audio_server::StartRecordingResponse>> {
        self.start_recording_async_opt(req, ::grpcio::CallOption::default())
    }

    pub fn stop_recording_opt(&self, req: &super::empty::Empty, opt: ::grpcio::CallOption) -> ::grpcio::Result<super::empty::Empty> {
        self.client.unary_call(&METHOD_AUDIO_SERVER_STOP_RECORDING, req, opt)
    }

    pub fn stop_recording(&self, req: &super::empty::Empty) -> ::grpcio::Result<super::empty::Empty> {
        self.stop_recording_opt(req, ::grpcio::CallOption::default())
    }

    pub fn stop_recording_async_opt(&self, req: &super::empty::Empty, opt: ::grpcio::CallOption) -> ::grpcio::Result<::grpcio::ClientUnaryReceiver<super::empty::Empty>> {
        self.client.unary_call_async(&METHOD_AUDIO_SERVER_STOP_RECORDING, req, opt)
    }

    pub fn stop_recording_async(&self, req: &super::empty::Empty) -> ::grpcio::Result<::grpcio::ClientUnaryReceiver<super::empty::Empty>> {
        self.stop_recording_async_opt(req, ::grpcio::CallOption::default())
    }

    pub fn get_status_opt(&self, req: &super::empty::Empty, opt: ::grpcio::CallOption) -> ::grpcio::Result<super::audio_server::Status> {
        self.client.unary_call(&METHOD_AUDIO_SERVER_GET_STATUS, req, opt)
    }

    pub fn get_status(&self, req: &super::empty::Empty) -> ::grpcio::Result<super::audio_server::Status> {
        self.get_status_opt(req, ::grpcio::CallOption::default())
    }

    pub fn get_status_async_opt(&self, req: &super::empty::Empty, opt: ::grpcio::CallOption) -> ::grpcio::Result<::grpcio::ClientUnaryReceiver<super::audio_server::Status>> {
        self.client.unary_call_async(&METHOD_AUDIO_SERVER_GET_STATUS, req, opt)
    }

    pub fn get_status_async(&self, req: &super::empty::Empty) -> ::grpcio::Result<::grpcio::ClientUnaryReceiver<super::audio_server::Status>> {
        self.get_status_async_opt(req, ::grpcio::CallOption::default())
    }

    pub fn get_levels_opt(&self, req: &super::audio_server::LevelsRequest, opt: ::grpcio::CallOption) -> ::grpcio::Result<::grpcio::ClientSStreamReceiver<super::audio_server::AudioLevels>> {
        self.client.server_streaming(&METHOD_AUDIO_SERVER_GET_LEVELS, req, opt)
    }

    pub fn get_levels(&self, req: &super::audio_server::LevelsRequest) -> ::grpcio::Result<::grpcio::ClientSStreamReceiver<super::audio_server::AudioLevels>> {
        self.get_levels_opt(req, ::grpcio::CallOption::default())
    }

    pub fn set_mixer_opt(&self, req: &super::audio_server::AudioLevels, opt: ::grpcio::CallOption) -> ::grpcio::Result<super::empty::Empty> {
        self.client.unary_call(&METHOD_AUDIO_SERVER_SET_MIXER, req, opt)
    }

    pub fn set_mixer(&self, req: &super::audio_server::AudioLevels) -> ::grpcio::Result<super::empty::Empty> {
        self.set_mixer_opt(req, ::grpcio::CallOption::default())
    }

    pub fn set_mixer_async_opt(&self, req: &super::audio_server::AudioLevels, opt: ::grpcio::CallOption) -> ::grpcio::Result<::grpcio::ClientUnaryReceiver<super::empty::Empty>> {
        self.client.unary_call_async(&METHOD_AUDIO_SERVER_SET_MIXER, req, opt)
    }

    pub fn set_mixer_async(&self, req: &super::audio_server::AudioLevels) -> ::grpcio::Result<::grpcio::ClientUnaryReceiver<super::empty::Empty>> {
        self.set_mixer_async_opt(req, ::grpcio::CallOption::default())
    }

    pub fn get_mixer_opt(&self, req: &super::empty::Empty, opt: ::grpcio::CallOption) -> ::grpcio::Result<super::audio_server::AudioLevels> {
        self.client.unary_call(&METHOD_AUDIO_SERVER_GET_MIXER, req, opt)
    }

    pub fn get_mixer(&self, req: &super::empty::Empty) -> ::grpcio::Result<super::audio_server::AudioLevels> {
        self.get_mixer_opt(req, ::grpcio::CallOption::default())
    }

    pub fn get_mixer_async_opt(&self, req: &super::empty::Empty, opt: ::grpcio::CallOption) -> ::grpcio::Result<::grpcio::ClientUnaryReceiver<super::audio_server::AudioLevels>> {
        self.client.unary_call_async(&METHOD_AUDIO_SERVER_GET_MIXER, req, opt)
    }

    pub fn get_mixer_async(&self, req: &super::empty::Empty) -> ::grpcio::Result<::grpcio::ClientUnaryReceiver<super::audio_server::AudioLevels>> {
        self.get_mixer_async_opt(req, ::grpcio::CallOption::default())
    }

    pub fn set_time_opt(&self, req: &super::timestamp::Timestamp, opt: ::grpcio::CallOption) -> ::grpcio::Result<super::empty::Empty> {
        self.client.unary_call(&METHOD_AUDIO_SERVER_SET_TIME, req, opt)
    }

    pub fn set_time(&self, req: &super::timestamp::Timestamp) -> ::grpcio::Result<super::empty::Empty> {
        self.set_time_opt(req, ::grpcio::CallOption::default())
    }

    pub fn set_time_async_opt(&self, req: &super::timestamp::Timestamp, opt: ::grpcio::CallOption) -> ::grpcio::Result<::grpcio::ClientUnaryReceiver<super::empty::Empty>> {
        self.client.unary_call_async(&METHOD_AUDIO_SERVER_SET_TIME, req, opt)
    }

    pub fn set_time_async(&self, req: &super::timestamp::Timestamp) -> ::grpcio::Result<::grpcio::ClientUnaryReceiver<super::empty::Empty>> {
        self.set_time_async_opt(req, ::grpcio::CallOption::default())
    }

    pub fn start_time_sync_opt(&self, req: &super::empty::Empty, opt: ::grpcio::CallOption) -> ::grpcio::Result<super::empty::Empty> {
        self.client.unary_call(&METHOD_AUDIO_SERVER_START_TIME_SYNC, req, opt)
    }

    pub fn start_time_sync(&self, req: &super::empty::Empty) -> ::grpcio::Result<super::empty::Empty> {
        self.start_time_sync_opt(req, ::grpcio::CallOption::default())
    }

    pub fn start_time_sync_async_opt(&self, req: &super::empty::Empty, opt: ::grpcio::CallOption) -> ::grpcio::Result<::grpcio::ClientUnaryReceiver<super::empty::Empty>> {
        self.client.unary_call_async(&METHOD_AUDIO_SERVER_START_TIME_SYNC, req, opt)
    }

    pub fn start_time_sync_async(&self, req: &super::empty::Empty) -> ::grpcio::Result<::grpcio::ClientUnaryReceiver<super::empty::Empty>> {
        self.start_time_sync_async_opt(req, ::grpcio::CallOption::default())
    }
    pub fn spawn<F>(&self, f: F) where F: ::futures::Future<Item = (), Error = ()> + Send + 'static {
        self.client.spawn(f)
    }
}

pub trait AudioServer {
    fn start_recording(&mut self, ctx: ::grpcio::RpcContext, req: super::audio_server::StartRecordingRequest, sink: ::grpcio::UnarySink<super::audio_server::StartRecordingResponse>);
    fn stop_recording(&mut self, ctx: ::grpcio::RpcContext, req: super::empty::Empty, sink: ::grpcio::UnarySink<super::empty::Empty>);
    fn get_status(&mut self, ctx: ::grpcio::RpcContext, req: super::empty::Empty, sink: ::grpcio::UnarySink<super::audio_server::Status>);
    fn get_levels(&mut self, ctx: ::grpcio::RpcContext, req: super::audio_server::LevelsRequest, sink: ::grpcio::ServerStreamingSink<super::audio_server::AudioLevels>);
    fn set_mixer(&mut self, ctx: ::grpcio::RpcContext, req: super::audio_server::AudioLevels, sink: ::grpcio::UnarySink<super::empty::Empty>);
    fn get_mixer(&mut self, ctx: ::grpcio::RpcContext, req: super::empty::Empty, sink: ::grpcio::UnarySink<super::audio_server::AudioLevels>);
    fn set_time(&mut self, ctx: ::grpcio::RpcContext, req: super::timestamp::Timestamp, sink: ::grpcio::UnarySink<super::empty::Empty>);
    fn start_time_sync(&mut self, ctx: ::grpcio::RpcContext, req: super::empty::Empty, sink: ::grpcio::UnarySink<super::empty::Empty>);
}

pub fn create_audio_server<S: AudioServer + Send + Clone + 'static>(s: S) -> ::grpcio::Service {
    let mut builder = ::grpcio::ServiceBuilder::new();
    let mut instance = s.clone();
    builder = builder.add_unary_handler(&METHOD_AUDIO_SERVER_START_RECORDING, move |ctx, req, resp| {
        instance.start_recording(ctx, req, resp)
    });
    let mut instance = s.clone();
    builder = builder.add_unary_handler(&METHOD_AUDIO_SERVER_STOP_RECORDING, move |ctx, req, resp| {
        instance.stop_recording(ctx, req, resp)
    });
    let mut instance = s.clone();
    builder = builder.add_unary_handler(&METHOD_AUDIO_SERVER_GET_STATUS, move |ctx, req, resp| {
        instance.get_status(ctx, req, resp)
    });
    let mut instance = s.clone();
    builder = builder.add_server_streaming_handler(&METHOD_AUDIO_SERVER_GET_LEVELS, move |ctx, req, resp| {
        instance.get_levels(ctx, req, resp)
    });
    let mut instance = s.clone();
    builder = builder.add_unary_handler(&METHOD_AUDIO_SERVER_SET_MIXER, move |ctx, req, resp| {
        instance.set_mixer(ctx, req, resp)
    });
    let mut instance = s.clone();
    builder = builder.add_unary_handler(&METHOD_AUDIO_SERVER_GET_MIXER, move |ctx, req, resp| {
        instance.get_mixer(ctx, req, resp)
    });
    let mut instance = s.clone();
    builder = builder.add_unary_handler(&METHOD_AUDIO_SERVER_SET_TIME, move |ctx, req, resp| {
        instance.set_time(ctx, req, resp)
    });
    let mut instance = s;
    builder = builder.add_unary_handler(&METHOD_AUDIO_SERVER_START_TIME_SYNC, move |ctx, req, resp| {
        instance.start_time_sync(ctx, req, resp)
    });
    builder.build()
}
