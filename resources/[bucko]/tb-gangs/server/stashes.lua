-- Helper: Register a Gang's Stash with ox_inventory
function registerGangStash(gang, coords, minGrade)
    local stashId = 'gang_stash_' .. gang
    exports.ox_inventory:RegisterStash(
        stashId,
        string.upper(gang) .. ' Compound Stash',
        Config.StashSettings.slots,
        Config.StashSettings.weight,
        false,
        { [gang] = tonumber(minGrade) or 0 },
        coords
    )
end

-- Event: Place or Move Gang Stash inside Compound
RegisterNetEvent('tb-gangs:server:saveStash', function(targetCoords, heading, minGrade)
    local src = source
    local player = exports.qbx_core:GetPlayer(src)
    if not player or player.PlayerData.gang.name == 'none' or not player.PlayerData.gang.isboss then
        return exports.qbx_core:Notify(src, 'Only the gang leader can place the gang stash.', 'error')
    end

    local gang = player.PlayerData.gang.name
    local pedCoords = GetEntityCoords(GetPlayerPed(src))
    local placementCoords = vec3(targetCoords.x + 0.0, targetCoords.y + 0.0, targetCoords.z + 0.0)

    if #(pedCoords - placementCoords) > 15.0 then
        return exports.qbx_core:Notify(src, 'Stash location is too far away from you.', 'error')
    end

    if Config.StashSettings.requireOwnedCompound then
        local insideOwnCompound = false
        for _, turf in pairs(Turfs) do
            if turf.owner == gang and isPointInsideTurf(placementCoords, turf) then
                insideOwnCompound = true
                break
            end
        end

        if not insideOwnCompound then
            return exports.qbx_core:Notify(src, 'You can only place your stash inside a compound/turf your gang controls!', 'error')
        end
    end

    local gradeReq = tonumber(minGrade) or (Stashes[gang] and Stashes[gang].minGrade) or 0
    local safeHeading = (tonumber(heading) or 0.0) + 0.0
    local encoded = json.encode({ x = placementCoords.x, y = placementCoords.y, z = placementCoords.z })

    MySQL.prepare.await([[
        INSERT INTO `tb_gang_stashes` (gang, coords, heading, min_grade)
        VALUES (?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE coords = VALUES(coords), heading = VALUES(heading), min_grade = VALUES(min_grade)
    ]], { gang, encoded, safeHeading, gradeReq })

    Stashes[gang] = {
        coords = placementCoords,
        heading = safeHeading,
        minGrade = gradeReq
    }
    GlobalState.tb_gang_stashes = Stashes

    registerGangStash(gang, placementCoords, gradeReq)
    TriggerClientEvent('tb-gangs:client:refreshStashes', -1, Stashes)
    exports.qbx_core:Notify(src, 'Gang compound stash placed! All authorized gang members can now access it.', 'success')
end)

-- Event: Update Minimum Rank Required to Use Gang Stash
RegisterNetEvent('tb-gangs:server:updateStashGrade', function(minGrade)
    local src = source
    local player = exports.qbx_core:GetPlayer(src)
    if not player or player.PlayerData.gang.name == 'none' or not player.PlayerData.gang.isboss then return end

    local gang = player.PlayerData.gang.name
    if not Stashes[gang] then
        return exports.qbx_core:Notify(src, 'Place your gang stash inside your compound first!', 'error')
    end

    local gradeReq = tonumber(minGrade) or 0
    Stashes[gang].minGrade = gradeReq
    GlobalState.tb_gang_stashes = Stashes

    MySQL.update.await('UPDATE `tb_gang_stashes` SET min_grade = ? WHERE gang = ?', { gradeReq, gang })
    registerGangStash(gang, Stashes[gang].coords, gradeReq)
    TriggerClientEvent('tb-gangs:client:refreshStashes', -1, Stashes)
    exports.qbx_core:Notify(src, 'Stash rank permissions updated!', 'success')
end)

-- Event: Open Gang Stash
RegisterNetEvent('tb-gangs:server:openGangStash', function(stashGang)
    local src = source
    local player = exports.qbx_core:GetPlayer(src)
    if not player then return end

    local playerGang = player.PlayerData.gang.name
    local playerGrade = player.PlayerData.gang.grade.level or 0

    if playerGang == 'none' or playerGang ~= stashGang then
        return exports.qbx_core:Notify(src, 'This stash belongs to another gang!', 'error')
    end

    local stashData = Stashes[stashGang]
    if not stashData then return end

    if playerGrade < (stashData.minGrade or 0) then
        return exports.qbx_core:Notify(src, 'Your gang rank is not high enough to access this stash.', 'error')
    end

    local pedCoords = GetEntityCoords(GetPlayerPed(src))
    if #(pedCoords - stashData.coords) > 5.0 then
        return exports.qbx_core:Notify(src, 'You are too far from the stash.', 'error')
    end

    exports.ox_inventory:forceOpenInventory(src, 'stash', 'gang_stash_' .. stashGang)
end)