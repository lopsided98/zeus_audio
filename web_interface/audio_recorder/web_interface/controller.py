import json
import logging
import subprocess
import threading
import time

import flask
import flask_cors
import grpc
from flask import request
from google.protobuf.empty_pb2 import Empty
from google.protobuf.timestamp_pb2 import Timestamp

import audio_recorder.protos.audio_server_pb2 as audio_server_pb2
import audio_recorder.protos.audio_server_pb2_grpc as audio_server_pb2_grpc

_log = logging.getLogger(__name__)

app = flask.Flask(__name__)
app.config.update({
    'AUDIO_SERVER_HOST': 'localhost:34876',
    'DEVICES': ['']
})
app.config.from_envvar('AUDIO_RECORDER_SETTINGS', silent=True)

# Don't cache in debug mode
if app.config['DEBUG']:
    app.config['SEND_FILE_MAX_AGE_DEFAULT'] = 0

# Allow cross-origin requests
flask_cors.CORS(app)

_channel = grpc.insecure_channel(app.config['AUDIO_SERVER_HOST'])
_audio_server = audio_server_pb2_grpc.AudioServerStub(_channel)


def _levels_stream(average=False):
    req = audio_server_pb2.LevelsRequest(average=average)
    for audio_levels in _audio_server.GetLevels(req):
        yield 'data: {}\n\n'.format(json.dumps(tuple(audio_levels.channels)))


@app.route('/')
def root():
    return flask.render_template('index.html')


@app.route('/start', methods=('POST',))
def start():
    body = request.get_json()
    req = audio_server_pb2.StartRecordingRequest(time=int(body['time'] * 1_000_000_000))
    response = _audio_server.StartRecording(req)
    return flask.jsonify({
        'synced': response.synced
    })


@app.route('/stop', methods=('POST',))
def stop():
    _audio_server.StopRecording(Empty())
    return '', 204


@app.route('/status')
def status():
    status = _audio_server.GetStatus(Empty())
    return flask.jsonify({
        'recorder_state': audio_server_pb2.Status.RecorderState.Name(status.recorder_state)
    })


@app.route('/levels')
def get_levels():
    average = request.args.get('average', 'false') == 'true'
    res = flask.Response(_levels_stream(average), mimetype="text/event-stream")
    # Disable NGINX response buffering
    res.headers['X-Accel-Buffering'] = 'no'
    return res


@app.route('/mixer')
def get_mixer():
    levels = _audio_server.GetMixer(Empty())
    return flask.jsonify(tuple(levels.channels))


@app.route('/mixer', methods=('POST',))
def set_mixer():
    levels = audio_server_pb2.AudioLevels()
    levels.channels.extend(request.get_json())
    _audio_server.SetMixer(levels)
    return '', 204


@app.route('/time', methods=('POST',))
def set_time():
    time = request.get_json()
    _audio_server.SetTime(Timestamp(seconds=time['seconds'], nanos=time['nanos']))
    return '', 204


@app.route('/start_time_sync', methods=('POST',))
def start_time_sync():
    _audio_server.StartTimeSync(Empty())
    return '', 204


@app.route('/shutdown', methods=('POST',))
def shutdown():
    def shutdown_thread():
        _log.info('Shutting down system')
        time.sleep(3)
        try:
            subprocess.run(("/usr/bin/env", "sudo", "-n", "poweroff"), stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                           check=True)
        except subprocess.CalledProcessError as e:
            _log.error("Failed to shutdown system: %s", e.stderr.decode('utf-8').strip())

    _log.info('Shutting down system in 3 seconds')
    threading.Thread(target=shutdown_thread).start()
    return '', 204
