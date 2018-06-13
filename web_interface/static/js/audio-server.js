export function getStatus() {
    return fetch('/status').then(response => response.json())
}

export function getLevelsEventSource() {
    return new EventSource('/levels');
}

export function setVolumes(volumes) {
    return fetch('/mixer', {
        body: JSON.stringify(volumes),
        headers: {
            'content-type': 'application/json'
        },
        method: 'POST'
    })
}

export function getVolumes() {
    return fetch('/mixer').then(response => response.json())
}