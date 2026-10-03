(function () {
    const root = document.getElementById('vitals-root');
    const cards = new Map(); // serverId -> card refs

    // One heartbeat "unit" of the ECG waveform (a proper PQRST complex),
    // repeated twice back-to-back so a continuous CSS translateX(-50%) loop
    // reads as an endless scroll.
    const BEAT_UNIT = [
        '0,13', '6,13', // baseline
        '9,12', '12,9', '15,11', '18,13', // P wave (small rounded bump)
        '22,13', // PR segment (flat)
        '25,14.5', '27,15.5', // Q (small dip)
        '29,1', // R (sharp tall spike)
        '31,23', // S (sharp deep dip)
        '34,13.5', '37,13', // back to baseline
        '40,13', // ST segment (flat)
        '46,13', '50,7', '54,8.5', '58,13', // T wave (broad rounded bump)
        '100,13', // baseline to next beat
    ].join(' ');
    const FLAT_UNIT = '0,13 100,13';

    function buildEcgPoints(unit) {
        const offsetPoints = unit.split(' ').map((pair) => {
            const [x, y] = pair.split(',').map(Number);
            return `${x + 100},${y}`;
        }).join(' ');
        return `${unit} ${offsetPoints}`;
    }

    function formatTime(seconds) {
        const s = Math.max(0, Math.floor(seconds));
        const m = Math.floor(s / 60);
        const rem = s % 60;
        return `${m}:${rem < 10 ? '0' : ''}${rem}`;
    }

    function createCard() {
        const el = document.createElement('div');
        el.className = 'vitals-card';
        el.innerHTML = `
            <div class="vitals-head">
                <div class="vitals-name"></div>
                <div class="vitals-status"></div>
            </div>
            <div class="vitals-monitor">
                <svg class="vitals-ecg" viewBox="0 0 200 26" preserveAspectRatio="none">
                    <polyline points=""></polyline>
                </svg>
            </div>
            <div class="vitals-footer">
                <div class="vitals-bar-track"><div class="vitals-bar-fill"></div></div>
                <div class="vitals-timer"></div>
            </div>
        `;
        root.appendChild(el);
        return {
            el,
            nameEl: el.querySelector('.vitals-name'),
            statusEl: el.querySelector('.vitals-status'),
            monitorEl: el.querySelector('.vitals-monitor'),
            polylineEl: el.querySelector('polyline'),
            fillEl: el.querySelector('.vitals-bar-fill'),
            timerEl: el.querySelector('.vitals-timer'),
            lastStatus: null,
        };
    }

    function updateCard(card, entry) {
        card.nameEl.textContent = entry.name || 'Unknown';

        if (entry.status !== card.lastStatus) {
            card.lastStatus = entry.status;
            const isDead = entry.status === 'dead';
            card.polylineEl.setAttribute('points', buildEcgPoints(isDead ? FLAT_UNIT : BEAT_UNIT));
            card.monitorEl.classList.toggle('scrolling', !isDead);
        }

        if (entry.status === 'dead') {
            card.statusEl.textContent = 'Deceased';
            card.statusEl.className = 'vitals-status dead';
            card.fillEl.style.width = '0%';
            card.timerEl.style.display = 'none';
            card.el.classList.add('dead-card');
            card.el.classList.remove('laststand-card');
            card.monitorEl.style.removeProperty('--beat-speed');
        } else {
            const health = Math.max(0, Math.min(100, entry.health));
            card.statusEl.textContent = 'Bleeding Out';
            card.statusEl.className = 'vitals-status laststand';
            card.fillEl.style.width = `${health}%`;
            card.fillEl.style.background = health > 40
                ? 'linear-gradient(90deg, #ffce54, #57e58b)'
                : 'linear-gradient(90deg, #ff3b3b, #ff9a3b)';
            card.timerEl.style.display = '';
            card.timerEl.textContent = formatTime(entry.time);
            card.el.classList.add('laststand-card');
            card.el.classList.remove('dead-card');

            // Heartbeat quickens as health drops: ~1.3s/beat at full health,
            // down to ~0.55s/beat as they're about to flatline.
            const speed = 1.3 - (1 - health / 100) * 0.75;
            card.monitorEl.style.setProperty('--beat-speed', `${speed.toFixed(2)}s`);
        }

        card.el.style.left = `${entry.x * 100}%`;
        card.el.style.top = `${entry.y * 100}%`;
        card.el.classList.add('visible');
    }

    window.addEventListener('message', (event) => {
        const data = event.data;
        if (!data || data.action !== 'vitals:update') return;

        const seen = new Set();

        for (const entry of data.entries || []) {
            seen.add(entry.id);
            let card = cards.get(entry.id);
            if (!card) {
                card = createCard();
                cards.set(entry.id, card);
            }
            updateCard(card, entry);
        }

        for (const [id, card] of cards) {
            if (!seen.has(id)) {
                card.el.remove();
                cards.delete(id);
            }
        }
    });
})();
