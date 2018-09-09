'use strict';

import AudioServer from './audio-server.js';

class VuMeter {
    constructor(element) {
        this.ctx = element.getContext('2d');
        const gradient = this.ctx.createLinearGradient(0, this.height, 0, 0);
        gradient.addColorStop(0, '#00ff00');
        gradient.addColorStop(0.8, '#00ff00');
        gradient.addColorStop(0.95, '#ffff00');
        gradient.addColorStop(1, '#ff0000');

        this.ctx.fillStyle = "black";
        this.ctx.fillStyle = gradient;
    }

    get width() {
        return this.ctx.canvas.clientWidth;
    }

    get height() {
        return this.ctx.canvas.clientHeight;
    }

    draw(db, timestamp) {
        const width = this.width;
        const height = this.height;
        const barHeight = height * (1 + db / 60.0);
        this.ctx.clearRect(0, 0, width, height);
        this.ctx.fillRect(0, height - barHeight, width, barHeight);
    }

    update(db) {
        window.requestAnimationFrame(this.draw.bind(this, db));
    }
}

class Device {
    constructor(container, baseUrl = '') {
        this.container = container;
        this.recordButton = container.querySelector('.record-button');
        this.vuMeter = new VuMeter(container.querySelector('.vu-meter'));
        this.shutdownButton = container.querySelector('.shutdown-button');

        this.recording = false;
        this.connected = false;

        this.audioServer = new AudioServer(baseUrl);
        // Set device time asynchronously
        this.audioServer.setTime();

        this.audioServer.getStatus()
            .then(res => res.ok && res.json()['recording'])
            .then(this.setRecordingStatus.bind(this))
            .then(this.setConnected.bind(this, true))
            .catch(this.setConnected.bind(this, false));

        let levelsSource = this.audioServer.getLevelsEventSource(true);
        levelsSource.onopen = this.setConnected.bind(this, true);
        levelsSource.onerror = this.setConnected.bind(this, false);
        levelsSource.onmessage = event => {
            const levels = JSON.parse(event.data);
            this.vuMeter.update(levels[0]);
        };

        this.recordButton.onclick = () => this.setRecording(!this.recording);
        this.shutdownButton.onclick = this.shutdown.bind(this);
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
        this.audioServer.shutdown().then(res => {
            if (res.ok) {
                this.setConnected(false);
            }
        });
    }
}

class ConfirmDialog {
    constructor(element) {
        this.element = element;
        this.confirmButton = element.querySelector('.confirm-button');
        this.cancelButton = element.querySelector('.cancel-button');

        this.onconfirm = null;
        this.oncancel = null;

        dialogPolyfill.registerDialog(element);

        this.confirmButton.onclick = () => {
            let event = new Event('confirm');
            if (this.onconfirm != null) {
                this.onconfirm(event);
            }
            this.element.dispatchEvent(event);
            this.close();
        };

        this.cancelButton.onclick = () => {
            let event = new Event('cancel');
            if (this.oncancel != null) {
                this.oncancel(event);
            }
            this.element.dispatchEvent(event);
            this.close();
        };
    }

    show() {
        this.element.showModal();
    }

    close() {
        this.element.close();
    }
}

window.onload = () => {
    let devices = Array.from(document.getElementsByClassName('device')).map(container =>
        new Device(container, container.dataset.baseUrl));

    let recordAllButton = document.getElementById("record-all-button");
    let stopAllButton = document.getElementById("stop-all-button");
    let shutdownAllButton = document.getElementById("shutdown-all-button");
    let shutdownAllConfirmDialog = new ConfirmDialog(document.getElementById("shutdown-all-confirm-dialog"));

    recordAllButton.onclick = () => devices.forEach(d => d.setRecording(true));
    stopAllButton.onclick = () => devices.forEach(d => d.setRecording(false));
    shutdownAllButton.onclick = () => shutdownAllConfirmDialog.show();

    shutdownAllConfirmDialog.onconfirm = () => devices.forEach(d => d.shutdown());
};