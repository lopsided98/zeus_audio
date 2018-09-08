import serial
import threading
import enum


class XosWestwaterRemote:
    class Button(enum.IntFlag):
        REV = 0b1
        PLAY = 0b10
        FF = 0b100
        START = 0b1000
        PAUSE = 0b10000
        SLOW = 0b100000
        REW = 0b1000000
        END = 0b10000000

    def __init__(self, port='/dev/ttyUSB0'):
        self._serial = serial.Serial(port=port, baudrate=2400, timeout=0.25)
        self._thread = threading.Thread(target=self._run)
        self._running = True

        # Buttons
        self.rev = False
        self.play = False
        self.ff = False
        self.start = False
        self.pause = False
        self.slow = False
        self.rew = False
        self.end = False

        self._thread.start()

    def close(self):
        self._running = False
        self._thread.join()
        self._serial.close()

    def _run(self):
        while self._running:
            button_bytes = self._serial.read()
            if len(button_bytes) > 0:
                buttons = button_bytes[0]
                self.rev = buttons & XosWestwaterRemote.Button.REV != 0
                self.play = buttons & XosWestwaterRemote.Button.PLAY != 0
                self.ff = buttons & XosWestwaterRemote.Button.FF != 0
                self.start = buttons & XosWestwaterRemote.Button.START != 0
                self.pause = buttons & XosWestwaterRemote.Button.PAUSE != 0
                self.slow = buttons & XosWestwaterRemote.Button.SLOW != 0
                self.rew = buttons & XosWestwaterRemote.Button.REW != 0
                self.end = buttons & XosWestwaterRemote.Button.END != 0
