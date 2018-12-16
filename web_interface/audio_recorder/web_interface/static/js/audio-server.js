'use strict';


export default class AudioServer {
    constructor(baseUrl = '') {
        this.baseUrl = baseUrl;
    }

    startRecording(date = new Date()) {
        return this.fetch('/start', {
            body: JSON.stringify({
                time: date.getTime() / 1000
            }),
            headers: {'content-type': 'application/json'},
            method: 'POST'
        });
    }

    stopRecording() {
        return this.fetch('/stop', {
            method: 'POST'
        });
    }

    getStatus() {
        return this.fetch('/status')
    }

    getLevelsEventSource(average = false) {
        return new EventSource(this.baseUrl + `/levels?average=${average}`);
    }

    setMixer(volumes) {
        return this.fetch('/mixer', {
            body: JSON.stringify(volumes),
            headers: {'content-type': 'application/json'},
            method: 'POST'
        });
    }

    getMixer() {
        return this.fetch('/mixer').then(response => response.json());
    }

    setTime(date = new Date()) {
        const time = date.getTime();
        const seconds = Math.floor(time / 1000);
        const nanos = (time - seconds * 1000) * 1e6;
        return this.fetch('/time', {
            body: JSON.stringify({
                'seconds': seconds,
                'nanos': nanos
            }),
            headers: {'content-type': 'application/json'},
            method: 'POST'
        });
    }

    startTimeSync() {
        return this.fetch('/start_time_sync', {
            method: 'POST'
        });
    }

    shutdown() {
        return this.fetch('/shutdown', {
            method: 'POST'
        });
    }

    fetch(url, args) {
        return fetch(this.baseUrl + url, args);
    }
}