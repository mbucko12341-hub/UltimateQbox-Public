const app = document.getElementById('app');
const destinationsList = document.getElementById('destinations-list');
const closeBtn = document.getElementById('close-btn');
const waypointBtn = document.getElementById('btn-waypoint');

// Listen for messages from Lua
window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.action === 'openTaxiMenu') {
        app.style.display = 'flex';
        renderDestinations(data.destinations);
    }
});

// Close UI
function closeUI() {
    app.style.display = 'none';
    fetch(`https://${GetParentResourceName()}/closeMenu`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

closeBtn.addEventListener('click', closeUI);

// Close on ESC key
document.addEventListener('keydown', function(event) {
    if (event.key === "Escape") {
        closeUI();
    }
});

// Select Waypoint
waypointBtn.addEventListener('click', function() {
    app.style.display = 'none';
    fetch(`https://${GetParentResourceName()}/selectDestination`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ type: 'waypoint' })
    });
});

// Render Preset Destinations
function renderDestinations(destinations) {
    destinationsList.innerHTML = '';
    
    destinations.forEach((dest, index) => {
        const card = document.createElement('div');
        card.className = 'dest-card';
        card.innerHTML = `
            <img src="${dest.image}" alt="${dest.title}">
            <div class="dest-info">
                <h3>${dest.title}</h3>
                <p>${dest.description}</p>
            </div>
        `;
        
        card.addEventListener('click', () => {
            app.style.display = 'none';
            fetch(`https://${GetParentResourceName()}/selectDestination`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ type: 'preset', index: index + 1 }) // +1 because Lua tables start at 1
            });
        });
        
        destinationsList.appendChild(card);
    });
}