'use strict';

import * as audioServer from './audio-server.js';

class VuMeter {
    constructor(element) {
        this.ctx = element.getContext('2d');
        const gradient = this.ctx.createLinearGradient(0, this.height, 0, 0);
        gradient.addColorStop(0, '#00ff00');
        gradient.addColorStop(0.7, '#00ff00');
        gradient.addColorStop(0.8, '#ffff00');
        gradient.addColorStop(0.9, '#ff0000');
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

    draw(leftDb, rightDb, timestamp) {
        const width = this.width;
        const height = this.height;
        const leftHeight = height * (1 + leftDb / 70.0);
        const rightHeight = height * (1 + rightDb / 70.0);
        this.ctx.clearRect(0, 0, width, height);
        this.ctx.fillRect(0, height - leftHeight, 0.4 * width, leftHeight);
        this.ctx.fillRect(0.6 * width, height - rightHeight, 0.4 * width, rightHeight);
    }

    update(leftDb, rightDb) {
        window.requestAnimationFrame(this.draw.bind(this, leftDb, rightDb));
    }
}


window.onload = () => {
    const recordingStatus = document.getElementById('recording-status');
    const vuMeter = new VuMeter(document.getElementById('vu-meter'));
    const leftDb = document.getElementById('left-db');
    const rightDb = document.getElementById('right-db');
    const leftVolumeSlider = document.getElementById('left-volume');
    const rightVolumeSlider = document.getElementById('right-volume');

    audioServer.getStatus().then(status => {
        if (status['recording'] === true) {
            recordingStatus.innerText = "Recording"
        } else {
            recordingStatus.innerText = "Not Recording"
        }
    });

    audioServer.getLevelsEventSource().onmessage = event => {
        const levels = JSON.parse(event.data);
        leftDb.innerText = levels[0].toPrecision(4);
        rightDb.innerText = levels[1].toPrecision(4);
        vuMeter.update(levels[0], levels[1]);
    };

    audioServer.getVolumes().then((volumes) => {
        leftVolumeSlider.value = volumes[0];
        rightVolumeSlider.value = volumes[1];
    });

    leftVolumeSlider.onchange = rightVolumeSlider.onchange = () => {
        audioServer.setVolumes([
            parseFloat(leftVolumeSlider.value),
            parseFloat(rightVolumeSlider.value)
        ]);
    };
};