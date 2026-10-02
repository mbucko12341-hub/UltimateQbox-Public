lib.callback.register('bucko_taxi:server:requestCab', function(source)
    local src = source
    local taxiPlayers = 0
    
    local players = exports.qbx_core:GetQBPlayers()
    for _, player in pairs(players) do
        if player.PlayerData.job.name == 'taxi' and player.PlayerData.job.onduty then
            taxiPlayers = taxiPlayers + 1
        end
    end

    if taxiPlayers > 0 then
        return false 
    else
        return true 
    end
end)

RegisterNetEvent('bucko_taxi:server:payFare', function(amount)
    local src = source
    local player = exports.qbx_core:GetPlayer(src)
    
    if not player then return end
    
    local fare = tonumber(amount)
    
    -- Try charging the bank first
    if player.Functions.RemoveMoney('bank', fare, 'taxi-fare') then
        TriggerClientEvent('ox_lib:notify', src, { title = 'Fare Paid', description = 'You paid $'..fare..' from your bank.', type = 'success' })
    -- If bank fails, fall back to cash
    elseif player.Functions.RemoveMoney('cash', fare, 'taxi-fare') then
        TriggerClientEvent('ox_lib:notify', src, { title = 'Fare Paid', description = 'You paid $'..fare..' in cash.', type = 'success' })
    else
        TriggerClientEvent('ox_lib:notify', src, { title = 'Fare Failed', description = 'You could not afford the fare of $'..fare, type = 'error' })
    end
end)