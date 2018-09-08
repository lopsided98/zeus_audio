'use strict';

export function startRecording() {
    return fetch('/start', {
        method: 'POST'
    })
}

export function stopRecording() {
    return fetch('/stop', {
        method: 'POST'
    })
}

export function getStatus() {
    return fetch('/status').then(response => response.json())
}

export function getLevelsEventSource() {
    return new EventSource('/levels');
}

export function setMixer(volumes) {
    return fetch('/mixer', {
        body: JSON.stringify(volumes),
        headers: {'content-type': 'application/json'},
        method: 'POST'
    })
}

export function getMixer() {
    return fetch('/mixer').then(response => response.json())
}

export function setTime(date = new Date()) {
    const time = date.getTime();
    const seconds = Math.floor(time / 1000);
    const nanos = (time - seconds * 1000) * 1e6;
    return fetch('/time', {
        body: JSON.stringify({
            'seconds': seconds,
            'nanos': nanos
        }),
        headers: {'content-type': 'application/json'},
        method: 'POST'
    })
}