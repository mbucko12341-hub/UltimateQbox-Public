Config = {}

Config.CityHallCoords = vector3(-545.19, -203.85, 38.21)

Config.Employment = {
    enabled = true,
    jobs = {
        { name = 'unemployed', label = 'Unemployed', icon = 'fa-solid fa-user-slash', desc = 'Relinquish current contractual employment to explore alternative careers.', danger = true },
        { name = 'trucker', label = 'Trucker', icon = 'fa-solid fa-truck-fast', desc = 'Transport cargo across state transit networks for steady freight wages.' },
        { name = 'taxi', label = 'Taxi Driver', icon = 'fa-solid fa-taxi', desc = 'Provide professional passenger transportation across the municipality.' },
        { name = 'tow', label = 'Tow Truck Operator', icon = 'fa-solid fa-truck-pickup', desc = 'Recover and impound stranded or illegally parked vehicles.' },
        { name = 'reporter', label = 'News Reporter', icon = 'fa-solid fa-video', desc = 'Broadcast live coverage and investigate breaking state events.' },
        { name = 'garbage', label = 'Garbage Collector', icon = 'fa-solid fa-trash-can', desc = 'Maintain city sanitation routes and manage waste collection.' },
        { name = 'bus', label = 'Bus Driver', icon = 'fa-solid fa-bus', desc = 'Operate municipal public transit lines on scheduled neighborhood routes.' }
    }
}