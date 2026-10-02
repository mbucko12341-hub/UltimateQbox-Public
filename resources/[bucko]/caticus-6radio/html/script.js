const menu = document.getElementById('radio-menu')
const stationList = document.getElementById('station-list')
const stationName = document.getElementById('station-name')
const stationGenre = document.getElementById('station-genre')
const stationCount = document.getElementById('station-count')
let resourceName = 'caticus-6radio'
let stations = []
let selectedIndex = 0
let showStationCount = true

const post = (endpoint, data = {}) => fetch(`https://${resourceName}/${endpoint}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data)
})

const nearbyIndexes = () => {
    const indexes = []

    for (let offset = -2; offset <= 2; offset += 1) {
        indexes.push((selectedIndex + offset + stations.length) % stations.length)
    }

    return indexes
}

const logoMarkup = station => {
    if (station.name === 'OFF') {
        return '<div class="station-logo off-logo"><i></i><b>OFF</b></div>'
    }

    return `<div class="station-logo"><i></i><span></span><b>${station.short}</b></div>`
}

const render = () => {
    if (!stations.length) {
        return
    }

    stationList.innerHTML = ''

    nearbyIndexes().forEach((index, position) => {
        const station = stations[index]
        const card = document.createElement('div')
        card.className = `station-card${position === 2 ? ' selected' : ' side'}`
        card.style.setProperty('--station-color', station.color)
        card.innerHTML = logoMarkup(station)
        stationList.appendChild(card)
    })

    const station = stations[selectedIndex]
    stationName.textContent = station.label.toUpperCase()
    stationGenre.textContent = station.genre.toUpperCase()
    stationCount.textContent = `${selectedIndex + 1} / ${stations.length}`
    stationCount.style.display = showStationCount ? 'block' : 'none'
}

document.getElementById('previous').addEventListener('click', () => post('cycle', { direction: -1 }))
document.getElementById('next').addEventListener('click', () => post('cycle', { direction: 1 }))

window.addEventListener('wheel', event => {
    if (menu.classList.contains('open')) {
        event.preventDefault()
        post('cycle', { direction: event.deltaY > 0 ? 1 : -1 })
    }
}, { passive: false })

window.addEventListener('message', event => {
    const data = event.data

    if (data.action === 'open') {
        resourceName = data.resource || resourceName
        stations = Array.isArray(data.stations) ? data.stations : []
        selectedIndex = Math.max(0, (Number(data.selectedIndex) || 1) - 1)
        showStationCount = data.showStationCount !== false

        Object.entries(data.colors || {}).forEach(([name, color]) => {
            document.documentElement.style.setProperty(`--${name.replace(/[A-Z]/g, letter => `-${letter.toLowerCase()}`)}`, color)
        })

        menu.classList.add('open')
        render()
    }

    if (data.action === 'selected') {
        selectedIndex = Math.max(0, (Number(data.index) || 1) - 1)
        render()
    }

    if (data.action === 'close') {
        menu.classList.remove('open')
    }
})
