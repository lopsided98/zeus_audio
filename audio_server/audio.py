import alsaaudio
import math
import os.path
import re
import select
import sys
import threading
import typing
import wave
import queue

import numpy as np

_FORMAT = alsaaudio.PCM_FORMAT_S16_LE
_NP_DTYPE = np.int16
_FULL_SCALE = 2 ** 15
_WAVE_SAMPLE_WIDTH = 2
_CHANNELS: int = 2
_SAMPLE_RATE: int = 44100
_FRAMES_PER_BUFFER = 2000
_FILE_NAME_FORMAT: str = 'audio_{0:04d}.wav'
_FILE_NAME_REGEX = re.compile(r'audio_(?P<index>\d{4}).wav$')

_MAX_FILE_SIZE = (2 ** 31) - 1


class AudioRecorder:

    def __init__(self, audio_dir, device='default', card_index=0, control='Capture') -> None:
        self._running = False

        self._recording_lock = threading.Lock()
        self._recording = False

        self._new_file_lock = threading.Lock()
        self._new_file = False

        self._audio_dir = audio_dir

        # Determine where to start numbering files
        existing_files = sorted([f for f in os.listdir(audio_dir) if _FILE_NAME_REGEX.match(f)], reverse=True)
        if len(existing_files) > 0:
            latest_file_search = _FILE_NAME_REGEX.search(existing_files[0])
            self._file_index = int(latest_file_search.group('index')) + 1
        else:
            self._file_index = 0

        self._levels_event = threading.Event()
        self._levels: typing.Tuple[float, float] = (0, 0)

        self._pcm = alsaaudio.PCM(type=alsaaudio.PCM_CAPTURE, mode=alsaaudio.PCM_NORMAL, device=device,
                                  cardindex=card_index)
        self._pcm.setformat(_FORMAT)
        self._pcm.setchannels(_CHANNELS)
        self._pcm.setrate(_SAMPLE_RATE)
        self._pcm.setperiodsize(_FRAMES_PER_BUFFER)

        self._mixer = alsaaudio.Mixer(control=control, device=device, cardindex=card_index)
        self._mixer.setrec(1)

        self._sample_buffer = queue.Queue(maxsize=100)

    @property
    def recording(self):
        return self._recording

    @recording.setter
    def recording(self, value):
        with self._recording_lock:
            if value:
                if not self._recording:
                    with self._new_file_lock:
                        self._new_file = True
            self._recording = value

    @property
    def levels(self) -> typing.Tuple[float, float]:
        self._levels_event.wait()
        levels = self._levels
        self._levels_event.clear()
        return levels

    @property
    def mixer(self) -> typing.List[int]:
        return self._mixer.getvolume(alsaaudio.PCM_CAPTURE)

    @mixer.setter
    def mixer(self, values) -> None:
        for i, vol in enumerate(values):
            self._mixer.setvolume(int(vol), i, alsaaudio.PCM_CAPTURE)

    def run(self) -> None:
        def db(arr):
            rms = np.sqrt(np.mean(arr * arr))
            if rms > 0:
                return 20 * math.log10(np.max(np.abs(arr)) / _FULL_SCALE)
            else:
                return -1000

        self._running = True
        writer_thread = threading.Thread(target=self._writer)
        writer_thread.start()

        try:
            while self._running:
                length, data = self._pcm.read()
                if length == 0:
                    continue
                elif length < 0:
                    print("ALSA buffer overrun", file=sys.stderr)
                    continue

                if not self._levels_event.is_set():
                    np_data = np.frombuffer(data, dtype=_NP_DTYPE).astype(np.float)
                    left_data = np_data[::2]
                    left_db = db(left_data)
                    right_data = np_data[1::2]
                    right_db = db(right_data)
                    self._levels = (left_db, right_db)
                    self._levels_event.set()

                if self.recording:
                    try:
                        self._sample_buffer.put(data, block=False)
                    except queue.Full:
                        print("Internal buffer overrun", file=sys.stderr)

        finally:
            self.recording = False
            self._running = False
            writer_thread.join()

    def _next_file_name(self) -> str:
        name = os.path.join(self._audio_dir, _FILE_NAME_FORMAT.format(self._file_index))
        self._file_index += 1
        return name

    def _writer(self):
        wave_file = None

        try:
            while self._running:
                try:
                    data = self._sample_buffer.get(block=True, timeout=0.5)

                    with self._new_file_lock:
                        new_file = self._new_file
                        self._new_file = False

                    if wave_file is None or wave_file.getsampwidth() * wave_file.getnchannels() * wave_file.tell() \
                            + len(data) > _MAX_FILE_SIZE or new_file:
                        if wave_file is not None:
                            wave_file.close()
                        wave_file = wave.open(self._next_file_name(), mode='wb')
                        wave_file.setnchannels(_CHANNELS)
                        wave_file.setsampwidth(_WAVE_SAMPLE_WIDTH)
                        wave_file.setframerate(_SAMPLE_RATE)

                    wave_file.writeframes(data)
                except queue.Empty:
                    pass
        finally:
            if wave_file is not None:
                wave_file.close()
