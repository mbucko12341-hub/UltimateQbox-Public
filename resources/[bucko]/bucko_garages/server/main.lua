local garages = {}

CreateThread(function()
    local result = MySQL.query.await('SELECT * FROM bucko_garages')
    if result then
        for i = 1, #result do
            result[i].coords = json.decode(result[i].coords)
            garages[result[i].name] = result[i]
        end
        print('^2[Bucko Garages]^7 Successfully loaded ' .. #result .. ' garages.')
    end
end)

lib.callback.register('bucko_garages:server:getGarages', function(source) return garages end)

lib.addCommand('garagetablet', {
    help = 'Open the Bucko Garages Admin Tablet',
    restricted = 'group.admin'
}, function(source, args, raw)
    TriggerClientEvent('bucko_garages:client:openTablet', source)
end)

lib.callback.register('bucko_garages:server:createGarage', function(source, garageData)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player or not IsPlayerAceAllowed(src, 'command') then return false end

    local id = MySQL.insert.await('INSERT INTO bucko_garages (name, label, type, coords) VALUES (?, ?, ?, ?)', {
        garageData.name, garageData.label, garageData.type, json.encode(garageData.coords)
    })

    if id then
        garages[garageData.name] = garageData
        TriggerClientEvent('bucko_garages:client:syncGarages', -1, garages)
        return true
    end
    return false
end)

-- ==========================================
-- PLAYER GARAGE LOGIC (JAM PACKED)
-- ==========================================

-- Fetch player's vehicles for this specific garage
lib.callback.register('bucko_garages:server:getPlayerVehicles', function(source, garageName)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return {} end

    -- state 1 = In Garage, state 0 = Out, state 2 = Impounded
    local vehicles = MySQL.query.await('SELECT * FROM player_vehicles WHERE citizenid = ? AND garage = ? AND state = 1', {
        Player.PlayerData.citizenid, garageName
    })
    
    return vehicles or {}
end)

-- Store Vehicle
lib.callback.register('bucko_garages:server:storeVehicle', function(source, plate, garageName, props)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return false, "Not logged in" end

    -- Check if they actually own the car
    local owned = MySQL.scalar.await('SELECT id FROM player_vehicles WHERE plate = ? AND citizenid = ?', { plate, Player.PlayerData.citizenid })
    
    if not owned then return false, "You do not own this vehicle!" end

    -- Update DB to save state, garage, and vehicle mods/health
    MySQL.update.await('UPDATE player_vehicles SET state = 1, garage = ?, mods = ? WHERE plate = ?', {
        garageName, json.encode(props), plate
    })

    return true, "Vehicle Stored"
end)

-- Update state when taking a vehicle out
RegisterNetEvent('bucko_garages:server:setVehicleOut', function(plate)
    MySQL.update('UPDATE player_vehicles SET state = 0 WHERE plate = ?', { plate })
end)