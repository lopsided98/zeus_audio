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

class Device {
    constructor(container, shutdownConfirmDialog, baseUrl = '') {
        this.container = container;
        this.shutdownConfirmDialog = shutdownConfirmDialog;
        this.baseUrl = baseUrl;
        this.recordButton = container.querySelector('.record-button');
        this.vuMeter = new VuMeter(container.querySelector('.vu-meter'));
        this.shutdownButton = container.querySelector('.shutdown-button');

        this.recording = false;
        this.connected = false;

        this.audioServer = new AudioServer(baseUrl);
        // Set device time asynchronously
        this.audioServer.setTime();

        this.audioServer.getStatus()
            .then(res => res.json().then(j => res.ok && j['recording']))
            .then(this.setRecordingStatus.bind(this))
            .then(this.setConnected.bind(this, true), this.setConnected.bind(this, false));

        let levelsSource = this.audioServer.getLevelsEventSource(true);
        levelsSource.onopen = this.setConnected.bind(this, true);
        levelsSource.onerror = this.setConnected.bind(this, false);
        levelsSource.onmessage = event => {
            const levels = JSON.parse(event.data);
            this.vuMeter.update(levels[0]);
        };

        this.recordButton.onclick = () => this.setRecording(!this.recording);
        this.shutdownButton.onclick = () => shutdownConfirmDialog.show().then(this.shutdown.bind(this));
    }

    setRecording(recording) {
        let func;
        if (recording) {
            func = this.audioServer.startRecording();
        } else {
            func = this.audioServer.stopRecording();
        }
        func.then(res => {
            if (res.ok) {
                this.setRecordingStatus(recording)
            }
        }).catch(this.setConnected.bind(this, false));
    }

    setRecordingStatus(recording) {
        this.recording = recording;
        if (recording) {
            this.recordButton.classList.remove('typcn-media-record-outline', 'light-red');
            this.recordButton.classList.add('typcn-media-record', 'red');
        } else {
            this.recordButton.classList.add('typcn-media-record-outline', 'light-red');
            this.recordButton.classList.remove('typcn-media-record', 'red');
        }
    }

    setConnected(connected) {
        this.connected = connected;
        this.shutdownButton.disabled = !connected;
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

    const recordAllButton = document.getElementById("record-all-button");
    const stopAllButton = document.getElementById("stop-all-button");
    const shutdownAllButton = document.getElementById("shutdown-all-button");
    const shutdownAllConfirmDialog = new ConfirmDialog(document.getElementById("shutdown-all-confirm-dialog"));

    recordAllButton.onclick = () => devices.forEach(d => d.setRecording(true));
    stopAllButton.onclick = () => devices.forEach(d => d.setRecording(false));

    // Wait for all recorders to shutdown except for #1 (which broadcasts the network), then shut it down
    shutdownAllButton.onclick = () => shutdownAllConfirmDialog.show().then(() => Promise.all(devices.slice(1)
        .map(d => d.shutdown().catch(() => {
        }))).then(() => devices[0].shutdown()));
};