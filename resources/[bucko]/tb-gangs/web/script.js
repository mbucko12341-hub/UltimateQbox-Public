const resourceName = window.GetParentResourceName ? window.GetParentResourceName() : 'tb-gangs';

const app = document.getElementById('app');
const spraySelector = document.getElementById('spray-selector');
const turfAlertBanner = document.getElementById('turf-alert-banner');
const repToast = document.getElementById('rep-toast');

const gangLabel = document.getElementById('gang-label');
const statusGangName = document.getElementById('status-gang-name');
const gangRank = document.getElementById('gang-rank');
const leaderNavBtn = document.getElementById('leader-nav-btn');
const homeLeaderApp = document.getElementById('home-leader-app');

const headerRepVal = document.getElementById('header-rep-val');
const leaderRepVal = document.getElementById('leader-rep-val');
const statRepCount = document.getElementById('stat-rep-count');

const currentZoneName = document.getElementById('current-zone-name');
const currentZoneOwner = document.getElementById('current-zone-owner');
const widgetZoneName = document.getElementById('widget-zone-name');
const widgetZoneOwner = document.getElementById('widget-zone-owner');

const sprayBtn = document.getElementById('spray-btn');
const homeSprayBtn = document.getElementById('home-spray-btn');

const territoryGrid = document.getElementById('territory-grid');
const rosterList = document.getElementById('roster-list');

const stashStatusBadge = document.getElementById('stash-status-badge');
const stashGradeSelect = document.getElementById('stash-grade-select');

const statOnlineCount = document.getElementById('stat-online-count');
const statTurfCount = document.getElementById('stat-turf-count');
const statStashState = document.getElementById('stat-stash-state');

let cachedGrades = [];
let bannerTimeout = null;
let repToastTimeout = null;

async function postNUI(endpoint, data = {}) {
    const response = await fetch(`https://${resourceName}/${endpoint}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    });
    return response.json();
}

function updateClock() {
    const timeEl = document.getElementById('os-time');
    const dateEl = document.getElementById('os-date');
    if (!timeEl || !dateEl) return;

    const now = new Date();
    const hours = String(now.getHours()).padStart(2, '0');
    const mins = String(now.getMinutes()).padStart(2, '0');
    timeEl.textContent = `${hours}:${mins}`;

    const days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    dateEl.textContent = `${days[now.getDay()]} ${months[now.getMonth()]} ${now.getDate()}`;
}
setInterval(updateClock, 5000);
updateClock();

function switchTab(tabId) {
    document.querySelectorAll('.dock-item[data-tab]').forEach(b => {
        b.classList.toggle('active', b.dataset.tab === tabId);
    });
    document.querySelectorAll('.os-app-view').forEach(p => {
        p.classList.toggle('active', p.id === tabId);
    });
}

document.querySelectorAll('.dock-item[data-tab]').forEach(btn => {
    btn.addEventListener('click', () => switchTab(btn.dataset.tab));
});

document.querySelectorAll('[data-open-tab]').forEach(el => {
    el.addEventListener('click', () => switchTab(el.dataset.openTab));
});

const homeBar = document.getElementById('home-bar');
if (homeBar) homeBar.addEventListener('click', () => switchTab('home-tab'));

// Show Sleek Compact Territory Entry Pill
function triggerTurfBanner(data) {
    if (!turfAlertBanner) return;

    const tagEl = document.getElementById('turf-alert-tag');
    const titleEl = document.getElementById('turf-alert-title');
    const subEl = document.getElementById('turf-alert-sub');
    const iconEl = document.getElementById('turf-alert-icon-i');

    turfAlertBanner.classList.remove('friendly', 'neutral');

    if (data.isOwn) {
        turfAlertBanner.classList.add('friendly');
        if (iconEl) iconEl.className = 'fa-solid fa-shield-halved';
        if (tagEl) tagEl.textContent = 'FRIENDLY TURF';
        if (titleEl) titleEl.textContent = `${data.ownerGang} TERRITORY`;
        if (subEl) subEl.textContent = `${data.zoneLabel} • ${data.points}% Control`;
    } else if (data.isHostile) {
        if (iconEl) iconEl.className = 'fa-solid fa-skull-crossbones';
        if (tagEl) tagEl.textContent = 'ENTERING RIVAL TURF';
        if (titleEl) titleEl.textContent = `NOW IN ${data.ownerGang} TERRITORY`;
        if (subEl) subEl.textContent = `${data.zoneLabel} • ${data.points}% Control`;
    } else {
        turfAlertBanner.classList.add('neutral');
        if (iconEl) iconEl.className = 'fa-solid fa-location-dot';
        if (tagEl) tagEl.textContent = 'UNCLAIMED ZONE';
        if (titleEl) titleEl.textContent = data.zoneLabel;
        if (subEl) subEl.textContent = 'Tag walls to claim this territory';
    }

    turfAlertBanner.classList.remove('hidden');
    if (bannerTimeout) clearTimeout(bannerTimeout);
    bannerTimeout = setTimeout(() => {
        turfAlertBanner.classList.add('hidden');
    }, 3500);
}

// Show Custom +REP Gained Toast
function triggerRepToast(data) {
    if (!repToast) return;
    const amtEl = document.getElementById('rep-toast-amount');
    const subEl = document.getElementById('rep-toast-sub');

    if (amtEl) amtEl.textContent = `+${data.repGained} REP`;
    if (subEl) subEl.textContent = `${data.subtitle} • Total Gang Rep: ${data.totalRep}`;

    repToast.classList.remove('hidden');
    if (repToastTimeout) clearTimeout(repToastTimeout);
    repToastTimeout = setTimeout(() => {
        repToast.classList.add('hidden');
    }, 5000);
}

// Render Spray PNG Designs in Popup
function renderSprayDesigns(designs) {
    const grid = document.getElementById('spray-designs-grid');
    if (!grid) return;

    grid.innerHTML = '';
    designs.forEach(d => {
        const imgSrc = d.image.startsWith('http') ? d.image : `sprays/${d.image}`;
        const card = document.createElement('div');
        card.className = 'spray-card';
        card.innerHTML = `
            <div class="spray-thumb-box">
                <img src="${imgSrc}" alt="${d.label}" onerror="this.style.display='none'">
            </div>
            <span>${d.label}</span>
        `;
        card.addEventListener('click', () => {
            spraySelector.classList.add('hidden');
            postNUI('selectSprayDesign', { image: d.image });
        });
        grid.appendChild(card);
    });
}

// Render Territories
function renderTerritories(territories, myGangName) {
    if (!territoryGrid) return;
    territoryGrid.innerHTML = '';
    let ownedCount = 0;

    territories.forEach(turf => {
        if (myGangName && turf.owner.toLowerCase() === myGangName.toLowerCase()) {
            ownedCount++;
        }

        const card = document.createElement('div');
        card.className = 'turf-card';
        card.innerHTML = `
            <div class="turf-card-header">
                <h4>${turf.label}</h4>
                <span class="owner-pill">${turf.owner}</span>
            </div>
            <div class="progress-track">
                <div class="progress-fill" style="width: ${turf.points}%"></div>
            </div>
            <div class="turf-meta">
                <span>Turf Control</span>
                <span>${turf.points}%</span>
            </div>
        `;
        territoryGrid.appendChild(card);
    });

    if (statTurfCount) statTurfCount.textContent = ownedCount;
}

// Render Stash Info & Member Access Ranks
function renderStashSettings(stash, grades) {
    if (!stashGradeSelect) return;
    stashGradeSelect.innerHTML = '';
    if (grades && grades.length > 0) {
        grades.forEach(g => {
            const opt = document.createElement('option');
            opt.value = g.level;
            opt.textContent = g.level === 0
                ? `Allow All Gang Members (${g.name}+)`
                : `Rank ${g.level}+ Only (${g.name}+)`;
            stashGradeSelect.appendChild(opt);
        });
    } else {
        const opt = document.createElement('option');
        opt.value = 0;
        opt.textContent = 'Allow All Gang Members';
        stashGradeSelect.appendChild(opt);
    }

    if (stash && stash.coords) {
        if (stashStatusBadge) {
            stashStatusBadge.textContent = 'Active in Compound';
            stashStatusBadge.classList.add('active');
        }
        stashGradeSelect.value = stash.minGrade || 0;
        if (statStashState) statStashState.textContent = 'ACTIVE';
    } else {
        if (stashStatusBadge) {
            stashStatusBadge.textContent = 'Not Placed';
            stashStatusBadge.classList.remove('active');
        }
        stashGradeSelect.value = 0;
        if (statStashState) statStashState.textContent = 'NONE';
    }
}

// Render Online Roster
function renderRoster(members) {
    if (!rosterList) return;
    rosterList.innerHTML = '';
    if (statOnlineCount) statOnlineCount.textContent = members.length;

    members.forEach(m => {
        const row = document.createElement('div');
        row.className = 'member-row';

        let gradeOptionsHtml = '';
        cachedGrades.forEach(g => {
            const selected = g.level === m.gradeLevel ? 'selected' : '';
            gradeOptionsHtml += `<option value="${g.level}" ${selected}>${g.name} (${g.level})</option>`;
        });

        row.innerHTML = `
            <div class="member-info">
                <strong>${m.name} (ID: ${m.source})</strong>
                <span>Rank: ${m.gradeName}</span>
            </div>
            <div class="member-controls">
                <select class="member-rank-select" data-source="${m.source}">
                    ${gradeOptionsHtml}
                </select>
                <button class="kick-btn" data-source="${m.source}">
                    <i class="fa-solid fa-user-slash"></i> Kick
                </button>
            </div>
        `;

        row.querySelector('.member-rank-select').addEventListener('change', async (e) => {
            const updated = await postNUI('setMemberRank', { source: m.source, grade: e.target.value });
            renderRoster(updated);
        });

        row.querySelector('.kick-btn').addEventListener('click', async () => {
            const updated = await postNUI('kickMember', { source: m.source });
            renderRoster(updated);
        });

        rosterList.appendChild(row);
    });
}

// Listen for Lua Messages
window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.action === 'open') {
        updateClock();
        if (spraySelector) spraySelector.classList.add('hidden');
        cachedGrades = data.grades || [];

        const repPoints = data.gang.rep || 0;
        if (gangLabel) gangLabel.textContent = data.gang.label;
        if (statusGangName) statusGangName.textContent = `${data.gang.label} // OS`;
        if (gangRank) gangRank.textContent = data.gang.gradeName;
        if (headerRepVal) headerRepVal.textContent = `${repPoints} REP`;
        if (leaderRepVal) leaderRepVal.textContent = `${repPoints} REP`;
        if (statRepCount) statRepCount.textContent = repPoints;

        if (data.gang.isBoss) {
            if (leaderNavBtn) leaderNavBtn.classList.remove('hidden');
            if (homeLeaderApp) homeLeaderApp.classList.remove('hidden');
        } else {
            if (leaderNavBtn) leaderNavBtn.classList.add('hidden');
            if (homeLeaderApp) homeLeaderApp.classList.add('hidden');
        }

        if (data.currentTurf) {
            const desc = `Controlled by ${data.currentTurf.owner} (${data.currentTurf.points}% Influence)`;
            if (currentZoneName) currentZoneName.textContent = data.currentTurf.label;
            if (currentZoneOwner) currentZoneOwner.textContent = desc;
            if (widgetZoneName) widgetZoneName.textContent = data.currentTurf.label;
            if (widgetZoneOwner) widgetZoneOwner.textContent = desc;
        } else {
            const desc = 'Use a Spray Can inside enemy turf to earn Gang Rep & claim zones.';
            if (currentZoneName) currentZoneName.textContent = 'Outside Gang Territory';
            if (currentZoneOwner) currentZoneOwner.textContent = desc;
            if (widgetZoneName) widgetZoneName.textContent = 'Outside Gang Territory';
            if (widgetZoneOwner) widgetZoneOwner.textContent = desc;
        }

        renderTerritories(data.territories || [], data.gang.name);
        renderStashSettings(data.stash, cachedGrades);
        renderRoster(data.members || []);

        switchTab('home-tab');
        app.classList.remove('hidden');
    } else if (data.action === 'openSpraySelector') {
        app.classList.add('hidden');
        renderSprayDesigns(data.designs || []);
        spraySelector.classList.remove('hidden');
    } else if (data.action === 'showTurfBanner') {
        triggerTurfBanner(data);
    } else if (data.action === 'showRepToast') {
        triggerRepToast(data);
    } else if (data.action === 'close') {
        app.classList.add('hidden');
        if (spraySelector) spraySelector.classList.add('hidden');
    }
});

function closeAllModals() {
    app.classList.add('hidden');
    if (spraySelector) spraySelector.classList.add('hidden');
    postNUI('closeUI');
}

const closeBtn = document.getElementById('close-btn');
if (closeBtn) closeBtn.addEventListener('click', closeAllModals);

const powerBtn = document.getElementById('power-btn');
if (powerBtn) powerBtn.addEventListener('click', closeAllModals);

const homeLockApp = document.getElementById('home-lock-app');
if (homeLockApp) homeLockApp.addEventListener('click', closeAllModals);

const closeSprayModal = document.getElementById('close-spray-modal');
if (closeSprayModal) closeSprayModal.addEventListener('click', closeAllModals);

if (sprayBtn) sprayBtn.addEventListener('click', () => postNUI('tagTurf'));
if (homeSprayBtn) homeSprayBtn.addEventListener('click', () => postNUI('tagTurf'));

const homeQuickSpray = document.getElementById('home-quick-spray');
if (homeQuickSpray) homeQuickSpray.addEventListener('click', () => postNUI('tagTurf'));

const inviteBtn = document.getElementById('invite-btn');
if (inviteBtn) {
    inviteBtn.addEventListener('click', () => {
        const input = document.getElementById('invite-input');
        if (input && input.value) {
            postNUI('invitePlayer', { targetId: input.value });
            input.value = '';
        }
    });
}

const stashBtn = document.getElementById('stash-btn');
if (stashBtn) {
    stashBtn.addEventListener('click', () => {
        postNUI('placeStash', { minGrade: stashGradeSelect ? stashGradeSelect.value : 0 });
    });
}

if (stashGradeSelect) {
    stashGradeSelect.addEventListener('change', () => {
        postNUI('updateStashGrade', { minGrade: stashGradeSelect.value });
    });
}

window.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && (!app.classList.contains('hidden') || (spraySelector && !spraySelector.classList.contains('hidden')))) {
        closeAllModals();
    }
});