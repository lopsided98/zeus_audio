#!/usr/bin/env python3

import concurrent.futures
import logging
import logging.config
import os
import platform
import time
from datetime import datetime

import grpc
import yaml
from google.protobuf.empty_pb2 import Empty
from google.protobuf.timestamp_pb2 import Timestamp

import audio_recorder.audio_server.audio as audio
import audio_recorder.protos.audio_server_pb2 as audio_server_pb2
import audio_recorder.protos.audio_server_pb2_grpc as audio_server_pb2_grpc

_SETTINGS_ENV_VAR = 'AUDIO_SERVER_SETTINGS'

_log = logging.getLogger(__name__)


class AudioServer(audio_server_pb2_grpc.AudioServerServicer):

    def __init__(self, audio_recorder: audio.AudioRecorder):
        self._log = logging.getLogger(AudioServer.__qualname__)
        self._audio = audio_recorder
        self._time_set = False

    def StartRecording(self, request, context) -> Empty:
        self._audio.recording = True
        return Empty()

    def StopRecording(self, request, context) -> Empty:
        self._audio.recording = False
        return Empty()

    def GetStatus(self, request, context) -> audio_server_pb2.Status:
        status = audio_server_pb2.Status()
        status.recording = self._audio.recording
        return status

    def GetLevels(self, request, context) -> audio_server_pb2.AudioLevels:
        while context.is_active():
            response = audio_server_pb2.AudioLevels()
            levels = self._audio.levels
            if request.average:
                response.channels.extend(levels)
            else:
                response.channels.append(sum(levels) / len(levels))
            yield response

    def GetMixer(self, request, context) -> audio_server_pb2.AudioLevels:
        response = audio_server_pb2.AudioLevels()
        response.channels.extend(self._audio.mixer)
        return response

    def SetMixer(self, request: audio_server_pb2.AudioLevels, context) -> Empty:
        self._audio.mixer = request.channels
        return Empty()

    def SetTime(self, request: Timestamp, context) -> Empty:
        if not self._time_set:
            try:
                time.clock_settime(time.CLOCK_REALTIME, request.seconds + request.nanos / 1.0e9)
                self._time_set = True
                self._log.info("System time set to: %s", datetime.now())
            except PermissionError as e:
                self._log.warning("Failed to set system time: %s", e)
        else:
            self._log.debug("System time is already set, ignoring request")
        return Empty()


def main():
    config = {
        'file_prefix': platform.node(),
        'audio_dir': './audio',
        'device': 'default',
        'card_index': 0,
        'control': 'Capture',
        'logging': {
            'version': 1,
            'formatters': {
                'standard': {
                    'format': '[%(levelname)s] %(name)s: %(message)s'
                },
            },
            'handlers': {
                'stderr': {
                    'level': 'DEBUG',
                    'formatter': 'standard',
                    'class': 'logging.StreamHandler',
                },
            },
            'loggers': {
                '': {
                    'handlers': ['stderr'],
                    'level': 'DEBUG',
                }
            }
        }
    }
    if _SETTINGS_ENV_VAR in os.environ:
        with open(os.environ[_SETTINGS_ENV_VAR], mode='r') as config_file:
            config.update(yaml.load(config_file))

    logging.config.dictConfig(config['logging'])

    audio_recorder = audio.AudioRecorder(file_prefix=config['file_prefix'], audio_dir=config['audio_dir'],
                                         device=config['device'], card_index=config['card_index'],
                                         control=config['control'])

    server = grpc.server(concurrent.futures.ThreadPoolExecutor(max_workers=5))
    audio_server_pb2_grpc.add_AudioServerServicer_to_server(AudioServer(audio_recorder), server)
    server.add_insecure_port('[::]:34876')

    server.start()
    logging.info("Server started")

    try:
        audio_recorder.run()
    except KeyboardInterrupt:
        pass
    finally:
        server.stop(0)


if __name__ == '__main__':
    main()