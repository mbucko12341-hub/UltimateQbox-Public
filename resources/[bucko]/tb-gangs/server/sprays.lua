-- Event: Spray PNG on Wall & Process 1% Turf Drain / Destruction at 0%
RegisterNetEvent('tb-gangs:server:placeWallSpray', function(sprayData)
    local src = source
    local player = exports.qbx_core:GetPlayer(src)
    if not player or not player.PlayerData.gang or player.PlayerData.gang.name == 'none' then
        return exports.qbx_core:Notify(src, 'Only affiliated gang members can spray gang tags!', 'error')
    end

    local gang = player.PlayerData.gang.name

    local allowedDesign = false
    for _, d in ipairs(Config.SprayDesigns or {}) do
        if d.image == sprayData.image and (d.gang == gang or d.gang == nil) then
            allowedDesign = true
            break
        end
    end
    if not allowedDesign and sprayData.image ~= 'skull.png' and sprayData.image ~= (gang .. '.png') then
        return exports.qbx_core:Notify(src, 'You can only spray your own gang logo!', 'error')
    end

    local pedCoords = GetEntityCoords(GetPlayerPed(src))
    local wallCoords = vec3(sprayData.coords.x + 0.0, sprayData.coords.y + 0.0, sprayData.coords.z + 0.0)
    local wallNormal = vec3(sprayData.normal.x + 0.0, sprayData.normal.y + 0.0, sprayData.normal.z + 0.0)
    local size = math.min(3.5, math.max(0.8, (tonumber(sprayData.size) or 1.8) + 0.0))

    if #(pedCoords - wallCoords) > 8.0 then
        return exports.qbx_core:Notify(src, 'You are too far from that wall.', 'error')
    end

    if Config.SprayItem then
        local count = exports.ox_inventory:GetItemCount(src, Config.SprayItem)
        if count < 1 then
            return exports.qbx_core:Notify(src, 'You need a ' .. Config.SprayItem .. ' to spray a tag!', 'error')
        end
        exports.ox_inventory:RemoveItem(src, Config.SprayItem, 1)
    end

    -- Check if inside a Territory Zone (Polygon OR Radius)
    local matchedZone = nil
    for zId, tData in pairs(Turfs) do
        if isPointInsideTurf(wallCoords, tData) then
            matchedZone = zId
            break
        end
    end

    if not matchedZone and not Config.AllowSprayOutsideTurf then
        return exports.qbx_core:Notify(src, 'You can only spray inside gang territories!', 'error')
    end

    local encodedCoords = json.encode({ x = wallCoords.x, y = wallCoords.y, z = wallCoords.z })
    local encodedNormal = json.encode({ x = wallNormal.x, y = wallNormal.y, z = wallNormal.z })

    local insertId = MySQL.insert.await([[
        INSERT INTO `tb_gang_sprays` (gang, image, coords, normal, size, zone_id)
        VALUES (?, ?, ?, ?, ?, ?)
    ]], { gang, sprayData.image, encodedCoords, encodedNormal, size, matchedZone })

    local newSpray = {
        id = insertId,
        gang = gang,
        image = sprayData.image,
        coords = wallCoords,
        normal = wallNormal,
        size = size,
        zoneId = matchedZone
    }

    Sprays[#Sprays + 1] = newSpray
    GlobalState.tb_gang_sprays = Sprays
    TriggerClientEvent('tb-gangs:client:addSpray', -1, newSpray)

    if matchedZone and Turfs[matchedZone] then
        local turf = Turfs[matchedZone]
        local now = os.time()

        if (Config.TagCooldown or 0) > 0 and ZoneCooldowns[matchedZone] and (now - ZoneCooldowns[matchedZone]) < Config.TagCooldown then
            local remaining = Config.TagCooldown - (now - ZoneCooldowns[matchedZone])
            return exports.qbx_core:Notify(src, ('Wall tagged! (Turf drain on cooldown for %ss)'):format(remaining), 'inform')
        end

        ZoneCooldowns[matchedZone] = now

        local drainAmount = Config.TagRewards.pointsPerTag or 1
        local reward = math.random(Config.TagRewards.minReward, Config.TagRewards.maxReward)

        if Config.TagRewards.moneyType == 'black_money' then
            exports.ox_inventory:AddItem(src, 'black_money', reward)
        else
            player.Functions.AddMoney(Config.TagRewards.moneyType, reward, 'turf-tagging')
        end

        if turf.owner == gang then
            turf.points = math.min(100, turf.points + drainAmount)
            MySQL.update.await('UPDATE `tb_gang_turfs` SET points = ? WHERE zone_id = ?', {
                turf.points, matchedZone
            })
            Turfs[matchedZone] = turf
            syncTurfsToClients()
            exports.qbx_core:Notify(src, ('Own turf reinforced! (+%s%% Control | Now at %s%%) Earned $%s'):format(drainAmount, turf.points, reward), 'success')
        else
            local enemyOwner = string.upper(turf.owner or 'ENEMY')
            local repGain = Config.TagRewards.repPerEnemyTag or 15
            turf.points = math.max(0, turf.points - drainAmount)

            if turf.points <= 0 then
                local destroyedLabel = turf.label
                repGain = repGain + (Config.TagRewards.repTakeoverBonus or 100)
                local totalRep = addGangRep(gang, repGain)

                Turfs[matchedZone] = nil
                MySQL.prepare.await('DELETE FROM `tb_gang_turfs` WHERE `zone_id` = ?', { matchedZone })

                TriggerClientEvent('tb-gangs:client:removeZone', -1, matchedZone)
                syncTurfsToClients()

                TriggerClientEvent('tb-gangs:client:repNotification', src, repGain, totalRep, ('WIPED OUT %s (%s)!'):format(destroyedLabel, enemyOwner))
                TriggerClientEvent('ox_lib:notify', -1, {
                    title = 'Territory Destroyed',
                    description = ('%s has completely wiped out %s (%s)!'):format(string.upper(gang), destroyedLabel, enemyOwner),
                    type = 'error',
                    duration = 8000
                })
            else
                local totalRep = addGangRep(gang, repGain)
                MySQL.update.await('UPDATE `tb_gang_turfs` SET points = ? WHERE zone_id = ?', {
                    turf.points, matchedZone
                })
                Turfs[matchedZone] = turf
                syncTurfsToClients()

                TriggerClientEvent('tb-gangs:client:repNotification', src, repGain, totalRep, ('%s Turf: -%s%% (%s%% Left)'):format(enemyOwner, drainAmount, turf.points))
            end
        end
    else
        exports.qbx_core:Notify(src, 'Graffiti tag sprayed onto wall!', 'success')
    end
end)

-- Event: Gang Member Scrubs Off a Wall Spray
RegisterNetEvent('tb-gangs:server:playerRemoveSpray', function(sprayId)
    local src = source
    local player = exports.qbx_core:GetPlayer(src)
    if not player or not player.PlayerData.gang or player.PlayerData.gang.name == 'none' then return end

    local myGang = player.PlayerData.gang.name
    local pedCoords = GetEntityCoords(GetPlayerPed(src))

    local targetIndex = nil
    local targetSpray = nil

    for i, s in ipairs(Sprays) do
        if s.id == sprayId or #(pedCoords - s.coords) <= 4.5 then
            if #(pedCoords - s.coords) <= 4.5 then
                targetIndex = i
                targetSpray = s
                break
            end
        end
    end

    if not targetIndex or not targetSpray then
        return exports.qbx_core:Notify(src, 'No graffiti found nearby to remove.', 'error')
    end

    local removerItem = Config.SprayRemoverItem or 'sprayremover'
    local count = exports.ox_inventory:GetItemCount(src, removerItem)
    if count < 1 then
        return exports.qbx_core:Notify(src, 'You need a Spray Remover to scrub this wall!', 'error')
    end

    if Config.ConsumeRemover ~= false then
        exports.ox_inventory:RemoveItem(src, removerItem, 1)
    end

    local sprayOwner = targetSpray.gang
    table.remove(Sprays, targetIndex)
    if targetSpray.id then
        MySQL.prepare.await('DELETE FROM `tb_gang_sprays` WHERE `id` = ?', { targetSpray.id })
    end

    GlobalState.tb_gang_sprays = Sprays
    TriggerClientEvent('tb-gangs:client:syncSprays', -1, Sprays)

    if sprayOwner and sprayOwner ~= myGang then
        local repGain = Config.RepPerEnemySprayRemoved or 10
        local totalRep = addGangRep(myGang, repGain)

        if targetSpray.zoneId and Turfs[targetSpray.zoneId] and Turfs[targetSpray.zoneId].owner == myGang then
            local turf = Turfs[targetSpray.zoneId]
            turf.points = math.min(100, (turf.points or 100) + (Config.TagRewards.pointsPerTag or 1))
            MySQL.update.await('UPDATE `tb_gang_turfs` SET points = ? WHERE zone_id = ?', { turf.points, targetSpray.zoneId })
            Turfs[targetSpray.zoneId] = turf
            syncTurfsToClients()
        end

        TriggerClientEvent('tb-gangs:client:repNotification', src, repGain, totalRep, ('Scrubbed %s Graffiti!'):format(string.upper(sprayOwner)))
    else
        exports.qbx_core:Notify(src, 'Wall scrubbed clean!', 'success')
    end
end)