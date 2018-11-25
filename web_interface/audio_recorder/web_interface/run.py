#!/usr/bin/env python3

from audio_recorder.web_interface import app

if __name__ == '__main__':
    app.run(threaded=True)
