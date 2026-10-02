-- Helper: Check if player is an Admin in Qbox / OX
function isAdmin(src)
    if AuthorizedAdmins[src] then return true end
    if IsPlayerAceAllowed(src, 'command') or IsPlayerAceAllowed(src, 'admin') or IsPlayerAceAllowed(src, 'command.gangadmin') then
        return true
    end
    return false
end

-- Helper: Set a Player as Gang Leader & Give Gang Tablet
function setPlayerGangLeader(adminSrc, targetId, gangName)
    local targetNum = tonumber(targetId)
    local targetPlayer = exports.qbx_core:GetPlayer(targetNum)
    if not targetPlayer then
        if adminSrc then exports.qbx_core:Notify(adminSrc, 'Target player (ID: ' .. tostring(targetId) .. ') is not online.', 'error') end
        return false
    end

    local gangs = exports.qbx_core:GetGangs()
    local gangData = gangs[gangName]
    if not gangData or DeletedGangs[gangName] then
        if adminSrc then exports.qbx_core:Notify(adminSrc, 'Gang "' .. tostring(gangName) .. '" does not exist.', 'error') end
        return false
    end

    local highestGrade = 0
    for grade, _ in pairs(gangData.grades) do
        local numGrade = tonumber(grade) or 0
        if numGrade > highestGrade then
            highestGrade = numGrade
        end
    end

    targetPlayer.Functions.SetGang(gangName, highestGrade)
    pcall(function()
        exports.qbx_core:SetPlayerGang(targetNum, gangName, highestGrade)
    end)

    local tabletItem = Config.TabletItem or 'gangtablet'
    if Config.GiveTabletOnLeaderSet then
        local count = exports.ox_inventory:GetItemCount(targetNum, tabletItem)
        if count < 1 then
            exports.ox_inventory:AddItem(targetNum, tabletItem, 1)
        end
    end

    if adminSrc then
        exports.qbx_core:Notify(adminSrc, ('Assigned %s as Leader of %s (Rank %s)'):format(targetPlayer.PlayerData.charinfo.firstname, gangData.label, highestGrade), 'success')
    end
    exports.qbx_core:Notify(targetNum, ('You have been appointed Leader of %s! Use your Gang Tablet to manage your gang.'):format(gangData.label), 'success')
    return true
end

-- Helper: Build Gang & Turf Lists for Admin Menu
local function getAdminMenuLists()
    local gangs = exports.qbx_core:GetGangs()
    local gangList = {}
    for k, v in pairs(gangs) do
        if k ~= 'none' and not DeletedGangs[k] then
            gangList[#gangList + 1] = { value = k, label = ('%s (%s) - %s Rep'):format(v.label, k, GangRep[k] or 0) }
        end
    end

    local turfList = {}
    for zoneId, tData in pairs(Turfs) do
        turfList[#turfList + 1] = {
            value = zoneId,
            label = ('%s [%s] - Owner: %s'):format(tData.label, zoneId, string.upper(tData.owner or 'none'))
        }
    end

    return gangList, turfList
end

-- ADMIN COMMAND 1: /gangadmin
lib.addCommand('gangadmin', {
    help = 'Open Gang Admin Creator & Management Menu (Admin Only)',
    restricted = 'group.admin'
}, function(source)
    AuthorizedAdmins[source] = true
    local gangList, turfList = getAdminMenuLists()
    TriggerClientEvent('tb-gangs:client:openAdminMenu', source, gangList, turfList)
end)

-- ADMIN COMMAND 2: /setgangleader [target] [gang]
lib.addCommand('setgangleader', {
    help = 'Set a player as the Boss/Leader of a gang (Admin Only)',
    params = {
        { name = 'target', type = 'number', help = 'Player Server ID' },
        { name = 'gang', type = 'string', help = 'Gang ID (e.g., ballas, vagos, families)' }
    },
    restricted = 'group.admin'
}, function(source, args)
    AuthorizedAdmins[source] = true
    setPlayerGangLeader(source, args.target, string.lower(args.gang))
end)

-- ADMIN EVENT: Create Brand New Gang In-Game
RegisterNetEvent('tb-gangs:server:adminCreateGang', function(data)
    local src = source
    if not isAdmin(src) then
        return exports.qbx_core:Notify(src, 'No permission.', 'error')
    end

    local gangId = string.lower(string.gsub(data.gangId or '', '%s+', '_'))
    local gangLabel = data.gangLabel
    local blipColor = tonumber(data.blipColor) or 1

    if gangId == '' or gangId == 'none' or not gangLabel or gangLabel == '' then
        return exports.qbx_core:Notify(src, 'Invalid gang ID or label provided.', 'error')
    end

    DeletedGangs[gangId] = nil
    GangRep[gangId] = GangRep[gangId] or 0
    GlobalState.tb_gang_rep = GangRep

    local gradesForQbx = {
        [0] = { name = (data.grade0 and data.grade0 ~= '') and data.grade0 or 'Recruit' },
        [1] = { name = (data.grade1 and data.grade1 ~= '') and data.grade1 or 'Enforcer' },
        [2] = { name = (data.grade2 and data.grade2 ~= '') and data.grade2 or 'Underboss', isboss = true },
        [3] = { name = (data.grade3 and data.grade3 ~= '') and data.grade3 or 'Shot Caller', isboss = true }
    }

    local gradesForSql = {
        ['0'] = gradesForQbx[0],
        ['1'] = gradesForQbx[1],
        ['2'] = gradesForQbx[2],
        ['3'] = gradesForQbx[3]
    }

    MySQL.prepare.await([[
        INSERT INTO `tb_gang_custom` (gang, label, color, grades)
        VALUES (?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE label = VALUES(label), color = VALUES(color), grades = VALUES(grades)
    ]], { gangId, gangLabel, blipColor, json.encode(gradesForSql) })

    pcall(function()
        exports.qbx_core:CreateGangs({
            [gangId] = {
                label = gangLabel,
                grades = gradesForQbx
            }
        })
    end)

    GangColors[gangId] = blipColor

    if data.createCompound then
        local polyPoints = data.polyPoints
        local centerCoords = GetEntityCoords(GetPlayerPed(src))
        local radius = (tonumber(data.compoundRadius) or 110.0) + 0.0

        if polyPoints and #polyPoints >= 3 then
            centerCoords, radius = calculatePolygonCenterAndRadius(polyPoints)
        end

        local zoneId = gangId .. '_compound'
        local zoneLabel = (data.compoundLabel and data.compoundLabel ~= '') and data.compoundLabel or (gangLabel .. ' Compound')
        local encodedCoords = json.encode({ x = centerCoords.x, y = centerCoords.y, z = centerCoords.z })
        local encodedPoly = polyPoints and json.encode(polyPoints) or nil

        Turfs[zoneId] = {
            label = zoneLabel,
            coords = vec3(centerCoords.x + 0.0, centerCoords.y + 0.0, centerCoords.z + 0.0),
            radius = radius,
            polyPoints = polyPoints,
            owner = gangId,
            points = 100
        }

        MySQL.prepare.await([[
            INSERT INTO `tb_gang_turfs` (zone_id, label, coords, radius, poly_points, owner, points)
            VALUES (?, ?, ?, ?, ?, ?, 100)
            ON DUPLICATE KEY UPDATE label = VALUES(label), coords = VALUES(coords), radius = VALUES(radius), poly_points = VALUES(poly_points), owner = VALUES(owner), points = 100
        ]], { zoneId, zoneLabel, encodedCoords, radius, encodedPoly, gangId })

        TriggerClientEvent('tb-gangs:client:registerNewZone', -1, zoneId, Turfs[zoneId])
    end

    syncTurfsToClients()
    exports.qbx_core:Notify(src, ('Created gang "%s" (%s) and added map blip!'):format(gangLabel, gangId), 'success')

    Wait(200)
    local leaderTarget = tonumber(data.leaderId) or src
    setPlayerGangLeader(src, leaderTarget, gangId)
end)

-- ADMIN EVENT: Delete a Gang, its Stash, Sprays, Rep, and Map Markers
RegisterNetEvent('tb-gangs:server:adminDeleteGang', function(gangId, deleteMarkers)
    local src = source
    if not isAdmin(src) then return end
    if not gangId or gangId == 'none' then return end

    DeletedGangs[gangId] = true
    GangColors[gangId] = nil
    GangRep[gangId] = nil
    GlobalState.tb_gang_rep = GangRep

    local players = exports.qbx_core:GetQBPlayers()
    for _, p in pairs(players) do
        if p.PlayerData.gang and p.PlayerData.gang.name == gangId then
            p.Functions.SetGang('none', 0)
            exports.qbx_core:Notify(p.PlayerData.source, 'Your gang has been disbanded by an administrator.', 'error')
        end
    end

    local noneGangJson = json.encode({
        name = 'none',
        label = 'No Gang Affiliaton',
        isboss = false,
        grade = { name = 'none', level = 0 }
    })
    pcall(function()
        MySQL.update.await("UPDATE `players` SET `gang` = ? WHERE JSON_EXTRACT(`gang`, '$.name') = ?", { noneGangJson, gangId })
    end)

    MySQL.prepare.await('DELETE FROM `tb_gang_custom` WHERE `gang` = ?', { gangId })
    MySQL.prepare.await('DELETE FROM `tb_gang_rep` WHERE `gang` = ?', { gangId })

    if Stashes[gangId] then
        Stashes[gangId] = nil
        GlobalState.tb_gang_stashes = Stashes
        MySQL.prepare.await('DELETE FROM `tb_gang_stashes` WHERE `gang` = ?', { gangId })
        TriggerClientEvent('tb-gangs:client:refreshStashes', -1, Stashes)
    end

    MySQL.prepare.await('DELETE FROM `tb_gang_sprays` WHERE `gang` = ?', { gangId })
    local filteredSprays = {}
    for _, s in ipairs(Sprays) do
        if s.gang ~= gangId then
            filteredSprays[#filteredSprays + 1] = s
        end
    end
    Sprays = filteredSprays
    GlobalState.tb_gang_sprays = Sprays
    TriggerClientEvent('tb-gangs:client:syncSprays', -1, Sprays)

    for zoneId, turf in pairs(Turfs) do
        if turf.owner == gangId or zoneId == (gangId .. '_compound') then
            if deleteMarkers then
                Turfs[zoneId] = nil
                MySQL.prepare.await('DELETE FROM `tb_gang_turfs` WHERE `zone_id` = ?', { zoneId })
                TriggerClientEvent('tb-gangs:client:removeZone', -1, zoneId)
            else
                Turfs[zoneId].owner = 'none'
                Turfs[zoneId].points = 0
                MySQL.update.await('UPDATE `tb_gang_turfs` SET `owner` = ?, `points` = 0 WHERE `zone_id` = ?', { 'none', zoneId })
            end
        end
    end

    syncTurfsToClients()
    exports.qbx_core:Notify(src, ('Deleted gang "%s", its stash, wall sprays, and map markers!'):format(gangId), 'success')
end)

-- ADMIN EVENT: Delete Nearest Wall Spray
RegisterNetEvent('tb-gangs:server:adminClearNearestSpray', function()
    local src = source
    if not isAdmin(src) then return end

    local pedCoords = GetEntityCoords(GetPlayerPed(src))
    local closestIndex, closestDist = nil, 10.0

    for i, s in ipairs(Sprays) do
        local dist = #(pedCoords - s.coords)
        if dist < closestDist then
            closestDist = dist
            closestIndex = i
        end
    end

    if not closestIndex then
        return exports.qbx_core:Notify(src, 'No wall spray found within 10 meters.', 'error')
    end

    local removed = table.remove(Sprays, closestIndex)
    if removed and removed.id then
        MySQL.prepare.await('DELETE FROM `tb_gang_sprays` WHERE `id` = ?', { removed.id })
    end

    GlobalState.tb_gang_sprays = Sprays
    TriggerClientEvent('tb-gangs:client:syncSprays', -1, Sprays)
    exports.qbx_core:Notify(src, 'Removed nearest wall spray!', 'success')
end)

-- ADMIN EVENT: Delete a Specific Territory / Map Marker
RegisterNetEvent('tb-gangs:server:adminDeleteTurf', function(zoneId)
    local src = source
    if not isAdmin(src) then return end
    if not zoneId or not Turfs[zoneId] then
        return exports.qbx_core:Notify(src, 'Territory zone not found.', 'error')
    end

    local label = Turfs[zoneId].label
    Turfs[zoneId] = nil

    MySQL.prepare.await('DELETE FROM `tb_gang_turfs` WHERE `zone_id` = ?', { zoneId })
    TriggerClientEvent('tb-gangs:client:removeZone', -1, zoneId)
    syncTurfsToClients()

    exports.qbx_core:Notify(src, ('Deleted territory marker "%s" (%s) from the map!'):format(label, zoneId), 'success')
end)

-- ADMIN EVENT: Create New Custom Polygon Territory Zone
RegisterNetEvent('tb-gangs:server:adminCreateTurf', function(data)
    local src = source
    if not isAdmin(src) then return end

    local zoneId = string.lower(string.gsub(data.zoneId or '', '%s+', '_'))
    local label = data.label
    local owner = data.owner or 'none'
    local polyPoints = data.polyPoints

    if zoneId == '' or not label or label == '' then
        return exports.qbx_core:Notify(src, 'Invalid Zone ID or Label.', 'error')
    end

    local centerCoords = GetEntityCoords(GetPlayerPed(src))
    local radius = (tonumber(data.radius) or 110.0) + 0.0

    if polyPoints and #polyPoints >= 3 then
        centerCoords, radius = calculatePolygonCenterAndRadius(polyPoints)
    end

    local encodedCoords = json.encode({ x = centerCoords.x, y = centerCoords.y, z = centerCoords.z })
    local encodedPoly = polyPoints and json.encode(polyPoints) or nil

    Turfs[zoneId] = {
        label = label,
        coords = vec3(centerCoords.x + 0.0, centerCoords.y + 0.0, centerCoords.z + 0.0),
        radius = radius,
        polyPoints = polyPoints,
        owner = owner,
        points = 100
    }

    MySQL.prepare.await([[
        INSERT INTO `tb_gang_turfs` (zone_id, label, coords, radius, poly_points, owner, points)
        VALUES (?, ?, ?, ?, ?, ?, 100)
        ON DUPLICATE KEY UPDATE label = VALUES(label), coords = VALUES(coords), radius = VALUES(radius), poly_points = VALUES(poly_points), owner = VALUES(owner), points = 100
    ]], { zoneId, label, encodedCoords, radius, encodedPoly, owner })

    TriggerClientEvent('tb-gangs:client:registerNewZone', -1, zoneId, Turfs[zoneId])
    syncTurfsToClients()
    exports.qbx_core:Notify(src, ('Created custom territory "%s" owned by %s!'):format(label, string.upper(owner)), 'success')
end)

-- ADMIN EVENT: Assign Leader from Admin Menu
RegisterNetEvent('tb-gangs:server:adminSetLeader', function(targetId, gangName)
    local src = source
    if not isAdmin(src) then return end
    setPlayerGangLeader(src, targetId, gangName)
end)