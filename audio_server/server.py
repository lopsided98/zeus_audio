#!/usr/bin/env python3

import concurrent.futures
import os

import grpc
import yaml
from google.protobuf.empty_pb2 import Empty

import audio_server.audio
import audio_server.audio_server_pb2
import audio_server.audio_server_pb2_grpc

_SETTINGS_ENV_VAR = 'AUDIO_SERVER_SETTINGS'


class AudioServer(audio_server.audio_server_pb2_grpc.AudioServerServicer):

    def __init__(self, audio_recorder: audio_server.audio.AudioRecorder):
        self._audio = audio_recorder

    def StartRecording(self, request, context) -> Empty:
        self._audio.recording = True
        return Empty()

    def StopRecording(self, request, context) -> Empty:
        self._audio.recording = False
        return Empty()

    def GetStatus(self, request, context) -> audio_server.audio_server_pb2.Status:
        status = audio_server.audio_server_pb2.Status()
        status.recording = self._audio.recording
        return status

    def GetLevels(self, request, context) -> audio_server.audio_server_pb2.AudioLevels:
        while context.is_active():
            audio_levels = audio_server.audio_server_pb2.AudioLevels()
            audio_levels.channels.extend(self._audio.levels)
            yield audio_levels

    def GetMixer(self, request, context) -> audio_server.audio_server_pb2.AudioLevels:
        audio_levels = audio_server.audio_server_pb2.AudioLevels()
        audio_levels.channels.extend(self._audio.mixer)
        return audio_levels

    def SetMixer(self, request, context) -> Empty:
        self._audio.mixer = request.channels
        return Empty()


def main():
    config = {
        'audio_dir': './audio',
        'device': 'default',
        'card_index': 0,
        'control': 'Capture'
    }
    if _SETTINGS_ENV_VAR in os.environ:
        with open(os.environ[_SETTINGS_ENV_VAR], mode='r') as config_file:
            config.update(yaml.load(config_file))

    audio_recorder = audio_server.audio.AudioRecorder(audio_dir=config['audio_dir'], device=config['device'],
                                                      card_index=config['card_index'], control=config['control'])

    server = grpc.server(concurrent.futures.ThreadPoolExecutor(max_workers=5))
    audio_server.audio_server_pb2_grpc.add_AudioServerServicer_to_server(AudioServer(audio_recorder), server)
    server.add_insecure_port('[::]:34876')

    server.start()
    print("Server started.")

    try:
        audio_recorder.run()
    except KeyboardInterrupt:
        pass
    finally:
        server.stop(0)


if __name__ == '__main__':
    main()
