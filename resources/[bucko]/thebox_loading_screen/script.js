/* THEBOX LOADING SCREEN - change the values below to customise the server. */
const CONFIG = {
    discordInvite: 'https://discord.gg/YOURINVITE',
    serverName: 'THEBOX RP',

    // Add your MP3 files to the /music folder and list them here.
    // Example: { name: 'TheBox Theme', file: 'music/thebox-theme.mp3' }
    tracks: [
        { name: 'TheBox Theme', file: 'music/thebox.mp3' }
    ],

    // Starting volume: 35%. Players can change it with the slider.
    defaultVolume: 0.35
};

const tabs = document.querySelectorAll('.tab');
const panels = document.querySelectorAll('.panel');
const progressBar = document.getElementById('progressBar');
const percent = document.getElementById('percent');
const statusText = document.getElementById('statusText');
const tipText = document.getElementById('tipText');
const music = document.getElementById('music');
const musicBtn = document.getElementById('musicBtn');

const tips = [
    'Tip: Read the rules before starting your first shift.',
    'Tip: Build relationships — not every story needs to end in a gunfight.',
    'Tip: Your reputation can open doors that money cannot.',
    'Tip: Use Discord for support, announcements and server updates.',
    'Tip: Explore the city. You never know what you will find.'
];
let tipIndex = 0;
setInterval(() => { tipIndex = (tipIndex + 1) % tips.length; tipText.textContent = tips[tipIndex]; }, 5000);

// Clickable information tabs.
tabs.forEach(tab => tab.addEventListener('click', () => {
    const target = tab.dataset.tab;
    tabs.forEach(t => t.classList.toggle('active', t === tab));
    panels.forEach(panel => panel.classList.toggle('active-panel', panel.id === target));
}));

// FiveM loadscreen progress events. Falls back to a slow visual progress if no event is received.
let receivedFiveMProgress = false;
window.addEventListener('message', (event) => {
    const data = event.data || {};
    if (data.eventName === 'loadProgress') {
        receivedFiveMProgress = true;
        const value = Math.max(0, Math.min(100, Math.round((Number(data.loadFraction) || 0) * 100)));
        setProgress(value);
    }
});

function setProgress(value) {
    progressBar.style.width = value + '%';
    percent.textContent = value + '%';
    if (value < 25) statusText.textContent = 'Initialising city systems...';
    else if (value < 55) statusText.textContent = 'Loading vehicles and world data...';
    else if (value < 80) statusText.textContent = 'Preparing your character...';
    else if (value < 100) statusText.textContent = 'Finalising connection...';
    else statusText.textContent = 'Connected. Welcome to TheBox.';
}

let fallback = 0;
const fallbackTimer = setInterval(() => {
    if (receivedFiveMProgress || fallback >= 94) return;
    fallback += Math.random() * 2.5;
    setProgress(Math.floor(fallback));
}, 900);

let currentTrack = 0;
let musicStarted = false;

const volumeSlider = document.getElementById('volumeSlider');
const trackName = document.getElementById('trackName');
const prevTrackBtn = document.getElementById('prevTrackBtn');
const nextTrackBtn = document.getElementById('nextTrackBtn');

music.volume = Math.max(0, Math.min(1, CONFIG.defaultVolume));
volumeSlider.value = Math.round(music.volume * 100);

function updateMusicUI() {
    const track = CONFIG.tracks[currentTrack];
    trackName.textContent = music.paused
        ? (track ? track.name + ' · Off' : 'Music Off')
        : (track ? track.name : 'Music On');
    musicBtn.innerHTML = music.paused ? '♫ <span>Music Off</span>' : '♫ <span>Music On</span>';
}

function loadTrack(index, autoplay = false) {
    if (!CONFIG.tracks.length) {
        trackName.textContent = 'No MP3 tracks configured';
        return;
    }

    currentTrack = (index + CONFIG.tracks.length) % CONFIG.tracks.length;
    const track = CONFIG.tracks[currentTrack];
    music.src = track.file;
    music.load();
    trackName.textContent = track.name + ' · Loading';

    if (autoplay) {
        music.play().then(() => {
            musicStarted = true;
            updateMusicUI();
        }).catch(() => {
            musicStarted = false;
            trackName.textContent = track.name + ' · Click Music';
            updateMusicUI();
        });
    } else {
        updateMusicUI();
    }
}

async function toggleMusic() {
    if (!CONFIG.tracks.length) {
        trackName.textContent = 'Add MP3 files to /music';
        return;
    }

    try {
        if (music.paused) {
            if (!music.src || music.src.endsWith('/')) loadTrack(currentTrack);
            await music.play();
            musicStarted = true;
        } else {
            music.pause();
            musicStarted = false;
        }
        updateMusicUI();
    } catch (e) {
        trackName.textContent = 'Could not play this MP3';
    }
}

function nextTrack() {
    if (!CONFIG.tracks.length) return;
    loadTrack(currentTrack + 1, !music.paused || musicStarted);
}

function previousTrack() {
    if (!CONFIG.tracks.length) return;
    loadTrack(currentTrack - 1, !music.paused || musicStarted);
}

musicBtn.addEventListener('click', toggleMusic);
nextTrackBtn.addEventListener('click', nextTrack);
prevTrackBtn.addEventListener('click', previousTrack);

volumeSlider.addEventListener('input', () => {
    music.volume = Number(volumeSlider.value) / 100;
});

music.addEventListener('ended', nextTrack);
music.addEventListener('error', () => {
    const track = CONFIG.tracks[currentTrack];
    if (track) trackName.textContent = 'Missing MP3: ' + track.name;
});

loadTrack(0, false);

document.getElementById('fullscreenBtn').addEventListener('click', async () => {
    try { if (!document.fullscreenElement) await document.documentElement.requestFullscreen(); else await document.exitFullscreen(); } catch(e) {}
});

document.getElementById('copyDiscord').addEventListener('click', async () => {
    const status = document.getElementById('copyStatus');
    if (CONFIG.discordInvite.includes('YOURINVITE')) {
        status.textContent = 'Set your Discord invite in script.js first.';
        return;
    }
    try {
        await navigator.clipboard.writeText(CONFIG.discordInvite);
        status.textContent = 'Discord invite copied to clipboard.';
    } catch(e) {
        status.textContent = CONFIG.discordInvite;
    }
});

function updateClock(){ document.getElementById('clock').textContent = new Date().toLocaleTimeString([], {hour12:false}); }
updateClock(); setInterval(updateClock,1000);
