local QXCore = exports['qbx_core']

-- Request Identification Card
RegisterNetEvent('bucko_cityhall:server:getIdentity', function(docType)
    local src = source
    local player = exports.qbx_core:GetPlayer(src)
    if not player then return end

    if docType == 'id_card' then
        if exports.ox_inventory:CanCarryItem(src, 'id_card', 1) then
            exports.ox_inventory:AddItem(src, 'id_card', 1, {
                firstname = player.PlayerData.charinfo.firstname,
                lastname = player.PlayerData.charinfo.lastname,
                birthdate = player.PlayerData.charinfo.birthdate,
                gender = player.PlayerData.charinfo.gender,
                nationality = player.PlayerData.charinfo.nationality
            })
            TriggerClientEvent('ox_lib:notify', src, { type = 'success', description = 'You received your ID Card!' })
        else
            TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'You do not have enough inventory space!' })
        end
    elseif docrypto == 'drivers_license' then
        -- Add license logic or integration here if needed
        TriggerClientEvent('ox_lib:notify', src, { type = 'success', description = 'Driver license requested.' })
    end
end)

-- Set Starter Job
RegisterNetEvent('bucko_cityhall:server:setJob', function(jobName)
    local src = source
    local player = exports.qbx_core:GetPlayer(src)
    if not player then return end

    player.Functions.SetJob(jobName, 0)
    TriggerClientEvent('ox_lib:notify', src, { type = 'success', description = 'Successfully signed up for your new job!' })
    TriggerClientEvent('bucko_cityhall:client:closeUI', src)
end)