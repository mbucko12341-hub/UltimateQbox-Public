const app = document.getElementById('app');
const adminTablet = document.getElementById('adminTablet');
const playerGarage = document.getElementById('playerGarage');
const closeBtns = document.querySelectorAll('.closeBtn');

let currentGarageCoords = null;
let selectedVehicle = null;

window.addEventListener('message', (event) => {
    const data = event.data;
    
    if (data.action === "closeAll") {
        closeUI();
    }
    
    if (data.action === "openAdminTablet") {
        app.classList.remove('hidden');
        adminTablet.classList.remove('hidden');
        playerGarage.classList.add('hidden');
        adminTablet.classList.add('animate-slide-up');
    }

    if (data.action === "openPlayerGarage") {
        app.classList.remove('hidden');
        playerGarage.classList.remove('hidden');
        adminTablet.classList.add('hidden');
        playerGarage.classList.add('animate-slide-up');
        
        currentGarageCoords = data.garageInfo.coords;
        document.getElementById('garageTitle').innerText = data.garageInfo.label;
        loadVehicles(data.vehicles);
    }
});

const closeUI = () => {
    app.classList.add('hidden');
    fetch(`https://${GetParentResourceName()}/closeUI`, { method: 'POST' });
};

closeBtns.forEach(btn => btn.addEventListener('click', closeUI));
window.addEventListener('keydown', (e) => { if (e.key === "Escape") closeUI(); });

// Handle Admin Submit
document.getElementById('garageForm').addEventListener('submit', (e) => {
    e.preventDefault();
    fetch(`https://${GetParentResourceName()}/submitNewGarage`, {
        method: 'POST',
        body: JSON.stringify({
            name: document.getElementById('gName').value,
            label: document.getElementById('gLabel').value,
            type: document.getElementById('gType').value,
        })
    });
    closeUI();
});

// Load Vehicles into UI
function loadVehicles(vehicles) {
    const list = document.getElementById('vehicleList');
    list.innerHTML = '';
    document.getElementById('emptyState').classList.remove('hidden');
    document.getElementById('vehicleDetails').classList.add('hidden');

    if (vehicles.length === 0) {
        list.innerHTML = `<div class="text-center text-[#8b92a5] mt-10 text-sm font-bold uppercase">No vehicles stored here</div>`;
        return;
    }

    vehicles.forEach(veh => {
        const div = document.createElement('div');
        div.className = 'veh-card p-3 rounded flex justify-between items-center';
        div.innerHTML = `
            <div>
                <div class="text-white font-bold uppercase tracking-wider text-sm">${veh.vehicle || 'Vehicle'}</div>
                <div class="text-[#8b92a5] text-xs font-bold mt-1">${veh.plate}</div>
            </div>
            <div class="w-3 h-3 rounded-full bg-[#00ffaa]"></div>
        `;
        
        div.onclick = () => {
            document.querySelectorAll('.veh-card').forEach(c => c.classList.remove('selected'));
            div.classList.add('selected');
            selectVehicle(veh);
        };
        list.appendChild(div);
    });
}

function selectVehicle(veh) {
    selectedVehicle = veh;
    document.getElementById('emptyState').classList.add('hidden');
    document.getElementById('vehicleDetails').classList.remove('hidden');

    document.getElementById('vehName').innerText = veh.vehicle || 'Unknown Vehicle';
    document.getElementById('vehPlate').innerText = veh.plate;

    // Default Qbox/QBCore stats
    const engine = veh.engine || 1000;
    const body = veh.body || 1000;
    const fuel = veh.fuel || 100;

    const engPct = Math.max(0, (engine / 1000) * 100).toFixed(0);
    const bodyPct = Math.max(0, (body / 1000) * 100).toFixed(0);
    const fuelPct = Math.max(0, fuel).toFixed(0);

    document.getElementById('statEngine').innerText = engPct + '%';
    document.getElementById('barEngine').style.width = engPct + '%';
    document.getElementById('barEngine').style.backgroundColor = engPct < 40 ? '#ff5050' : '#00ffaa';

    document.getElementById('statBody').innerText = bodyPct + '%';
    document.getElementById('barBody').style.width = bodyPct + '%';
    document.getElementById('barBody').style.backgroundColor = bodyPct < 40 ? '#ff5050' : '#00ffaa';

    document.getElementById('statFuel').innerText = fuelPct + '%';
    document.getElementById('barFuel').style.width = fuelPct + '%';
}

document.getElementById('spawnBtn').addEventListener('click', () => {
    if (!selectedVehicle) return;
    fetch(`https://${GetParentResourceName()}/spawnVehicle`, {
        method: 'POST',
        body: JSON.stringify({ vehicle: selectedVehicle, garageCoords: currentGarageCoords })
    });
});