'use strict';

import {ConfirmDialog} from './common.js'
import AudioServer from './audio-server.js';

class VuMeter {
    constructor(element) {
        this.ctx = element.getContext('2d');
        const gradient = this.ctx.createLinearGradient(0, this.ctx.canvas.height, 0, 0);
        gradient.addColorStop(0, '#00ff00');
        gradient.addColorStop(0.8, '#00ff00');
        gradient.addColorStop(0.95, '#ffff00');
        gradient.addColorStop(1, '#ff0000');

        this.ctx.fillStyle = "black";
        this.ctx.fillStyle = gradient;
    }

    draw(db, timestamp) {
        const width = this.ctx.canvas.width;
        const height = this.ctx.canvas.height;
        const barHeight = height * (1 + db / 70.0);
        this.ctx.clearRect(0, 0, width, height);
        this.ctx.fillRect(0, height - barHeight, width, barHeight);
    }

    update(db) {
        window.requestAnimationFrame(this.draw.bind(this, db));
    }
}

const RecordingState = Object.freeze({
    STOPPED: 1,
    WAITING: 2,
    RECORDING: 3,
    RECORDING_SYNCED: 4,
});

const TimeState = Object.freeze({
    NOT_SYNCED: 1,
    SYNCED: 2
});

class Device {
    constructor(container, shutdownConfirmDialog, baseUrl = '') {
        this.container = container;
        this.shutdownConfirmDialog = shutdownConfirmDialog;
        this.baseUrl = baseUrl;
        this.recordButton = container.querySelector('.record-button');
        this.timeStateText = container.querySelector('.time-state-text');
        this.vuMeter = new VuMeter(container.querySelector('.vu-meter'));
        this.shutdownButton = container.querySelector('.shutdown-button');

        this.recordingState = RecordingState.STOPPED;
        this.timeState = TimeState.NOT_SYNCED;
        this.connected = false;
        this.updateState();

        this.audioServer = new AudioServer(baseUrl);

        this.audioServer.getStatus()
            .then(res => res.json().then(j => res.ok && RecordingState[j['recorder_state']]))
            .then(this.setRecordingState.bind(this))
            .then(this.setConnected.bind(this, true), this.setConnected.bind(this, false));

        let levelsSource = this.audioServer.getLevelsEventSource(true);
        levelsSource.onopen = this.setConnected.bind(this, true);
        levelsSource.onerror = this.setConnected.bind(this, false);
        levelsSource.onmessage = event => {
            const levels = JSON.parse(event.data);
            this.vuMeter.update(levels[0]);
        };

        this.recordButton.onclick = () => {
            let recording;
            switch (this.recordingState) {
                case RecordingState.STOPPED:
                    recording = true;
                    break;
                case RecordingState.RECORDING:
                case RecordingState.RECORDING_SYNCED:
                case RecordingState.WAITING:
                    recording = false;
            }
            this.setRecording(recording);
        };
        this.shutdownButton.onclick = () => shutdownConfirmDialog.show().then(this.shutdown.bind(this));
    }

    setRecording(recording, time = new Date()) {
        let func;
        if (recording) {
            func = this.audioServer.startRecording(time);
            this.setRecordingState(RecordingState.WAITING);
        } else {
            func = this.audioServer.stopRecording();
        }
        func.then(res => {
            if (res.ok) {
                if (recording) {
                    const body = res.json();
                    if (body['synced']) {
                        this.setRecordingState(RecordingState.RECORDING_SYNCED);
                    } else {
                        this.setRecordingState(RecordingState.RECORDING);
                    }
                } else {
                    this.setRecordingState(RecordingState.STOPPED);
                }
            }
        }).catch(this.setConnected.bind(this, false));
    }

    setRecordingState(recording) {
        this.recordingState = recording;
        this.updateState();
    }

    setTimeState(time_state) {
        this.timeState = time_state;
        this.updateState();
    }

    updateState() {
        switch (this.timeState) {
            case TimeState.NOT_SYNCED:
                this.timeStateText.innerHTML = "NS";
                break;
            case TimeState.SYNCED:
                switch (this.recordingState) {
                    case RecordingState.STOPPED:
                        this.timeStateText.innerHTML = "R";
                        break;
                    case RecordingState.WAITING:
                        this.timeStateText.innerHTML = "W";
                        break;
                    case RecordingState.RECORDING:
                        this.timeStateText.innerHTML = "NS";
                        break;
                    case RecordingState.RECORDING_SYNCED:
                        this.timeStateText.innerHTML = "S";
                        break;
                }
        }

        switch (this.recordingState) {
            case RecordingState.RECORDING:
            case RecordingState.RECORDING_SYNCED:
                this.recordButton.classList.remove('typcn-media-record-outline', 'light-red');
                this.recordButton.classList.add('typcn-media-record', 'red');
                break;
            case RecordingState.STOPPED:
            case RecordingState.WAITING:
                this.recordButton.classList.add('typcn-media-record-outline', 'light-red');
                this.recordButton.classList.remove('typcn-media-record', 'red');
        }
    }

    setConnected(connected) {
        this.connected = connected;
        this.shutdownButton.disabled = !connected;
    }

    setTime(date = new Date()) {
        return this.audioServer.setTime(date).then(res => {
            if (res.ok) {
                this.setTimeState(TimeState.SYNCED);
            }
            return res;
        });
    }

    startTimeSync() {
        return this.audioServer.startTimeSync().then(res => {
            if (res.ok) {
                this.setTimeState(TimeState.SYNCED);
            }
            return res;
        });
    }

    shutdown() {
        const p = this.audioServer.shutdown();
        p.then(res => {
            if (res.ok) {
                this.setConnected(false);
            }
        });
        return p;
    }
}

window.onload = () => {
    const shutdownConfirmDialog = new ConfirmDialog(document.getElementById("shutdown-confirm-dialog"));
    const devices = Array.from(document.getElementsByClassName('device')).map(container =>
        new Device(container, shutdownConfirmDialog, container.dataset.baseUrl));

    // Assume the first device is the clock master
    const masterDevice = devices[0];
    const syncDevices = devices.slice(1);

    const recordAllButton = document.getElementById("record-all-button");
    const stopAllButton = document.getElementById("stop-all-button");
    const shutdownAllButton = document.getElementById("shutdown-all-button");
    const shutdownAllConfirmDialog = new ConfirmDialog(document.getElementById("shutdown-all-confirm-dialog"));

    recordAllButton.onclick = () => {
        let time = new Date();
        // Try to start in 1 second
        time.setMilliseconds(time.getMilliseconds() + 1000);
        devices.forEach(d => d.setRecording(true, time));
    };
    stopAllButton.onclick = () => devices.forEach(d => d.setRecording(false));

    // Wait for all recorders to shutdown except for #1 (which broadcasts the network), then shut it down
    shutdownAllButton.onclick = () => shutdownAllConfirmDialog.show().then(() => Promise.all(syncDevices
        .map(d => d.shutdown().catch(() => {
        }))).then(() => masterDevice.shutdown()));

    // Perform time synchronization
    masterDevice.setTime().then(res => {
        if (res.ok) syncDevices.forEach(device => device.startTimeSync())
    })
};