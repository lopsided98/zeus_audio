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
        headers: {
            'content-type': 'application/json'
        },
        method: 'POST'
    })
}

export function getMixer() {
    return fetch('/mixer').then(response => response.json())
}