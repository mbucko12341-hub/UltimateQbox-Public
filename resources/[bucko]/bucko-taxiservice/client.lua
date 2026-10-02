local QBCore = exports['qb-core']:GetCoreObject()
local taxiActive = false
local taxiVehicle = nil
local taxiPed = nil
local taxiBlip = nil

-- ==========================================
-- CONFIGURATION
-- ==========================================

local dispatcherLocations = {
    { 
        model = `a_m_y_business_02`, 
        coords = vector4(-1039.27, -2730.87, 20.21, 224.27), 
        taxiSpawn = vector4(-1056.46, -2545.9, 19.07, 150.52), 
        pickupCoords = vector4(-1034.38, -2729.65, 19.08, 239.66) 
    }
}

local taxiDestinations = {
    {
        title = 'Pink Cage',
        description = 'Pink Cage motels',
        image = 'images/pinkcage.png', 
        coords = vector3(299.96, -234.95, 52.96)
    }
}

-- ==========================================
-- NUI CALLBACKS
-- ==========================================

RegisterNUICallback('closeMenu', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('selectDestination', function(data, cb)
    SetNuiFocus(false, false)
    if data.type == 'waypoint' then
        DriveToWaypoint()
    elseif data.type == 'preset' then
        local dest = taxiDestinations[data.index]
        if dest then
            StartTaxiDrive(dest.coords, dest.title)
        end
    end
    cb('ok')
end)

function ShowDestinationMenu()
    -- Create a safe table without vector3 coords to send to JS
    local uiDestinations = {}
    for i, dest in ipairs(taxiDestinations) do
        table.insert(uiDestinations, {
            title = dest.title,
            description = dest.description,
            image = dest.image
        })
    end

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openTaxiMenu',
        destinations = uiDestinations
    })
end

-- ==========================================
-- MAIN LOGIC
-- ==========================================

local spawnedPeds = {}

Citizen.CreateThread(function()
    for i, data in ipairs(dispatcherLocations) do
        lib.requestModel(data.model, 5000)
        
        local ped = CreatePed(0, data.model, data.coords.x, data.coords.y, data.coords.z - 1.0, data.coords.w, false, false)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        table.insert(spawnedPeds, ped)

        exports.ox_target:addLocalEntity(ped, {
            {
                name = 'call_ai_taxi_' .. i,
                icon = 'fas fa-taxi',
                label = 'Request a Taxi',
                distance = 2.0,
                onSelect = function()
                    if taxiActive then
                        lib.notify({ title = 'Taxi', description = 'You already have a taxi on the way!', type = 'error' })
                        return
                    end
                    
                    TaskTurnPedToFaceEntity(cache.ped, ped, 1000)
                    Wait(1000)
                    lib.requestAnimDict('misscarsteal4@actor', 1000)
                    TaskPlayAnim(cache.ped, 'misscarsteal4@actor', 'actor_berating_loop', 8.0, 2.0, -1, 49, 0, false, false, false)
                    
                    lib.progressBar({
                        duration = 5000,
                        label = 'Talking to Dispatcher...',
                        useWhileDead = false,
                        canCancel = true,
                        disable = { car = true, move = true, combat = true }
                    })
                    ClearPedTasks(cache.ped)

                    lib.callback('bucko_taxi:server:requestCab', false, function(useAI)
                        if useAI then
                            DispatchAITaxi(data.taxiSpawn, data.pickupCoords)
                        else
                            lib.notify({ title = 'Taxi', description = 'A real driver has been dispatched to your location!', type = 'success' })
                        end
                    end)
                end
            }
        })
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for _, ped in ipairs(spawnedPeds) do
            if DoesEntityExist(ped) then
                DeleteEntity(ped)
            end
        end
        if taxiBlip and DoesBlipExist(taxiBlip) then
            RemoveBlip(taxiBlip)
        end
    end
end)

function DispatchAITaxi(spawnCoords, pickupCoords)
    taxiActive = true
    
    lib.notify({ title = 'Downtown Cab Co.', description = 'A cab is pulling around now. Track it on your GPS.', type = 'info' })

    local vehicleModel = `taxi`
    local pedModel = `a_m_y_stbla_02`
    lib.requestModel(vehicleModel, 5000)
    lib.requestModel(pedModel, 5000)

    taxiVehicle = CreateVehicle(vehicleModel, spawnCoords.x, spawnCoords.y, spawnCoords.z, spawnCoords.w, true, false)
    taxiPed = CreatePedInsideVehicle(taxiVehicle, 26, pedModel, -1, true, false)
    
    SetEntityAsMissionEntity(taxiVehicle, true, true)
    SetEntityAsMissionEntity(taxiPed, true, true)
    SetDriverAbility(taxiPed, 1.0)
    SetDriverAggressiveness(taxiPed, 0.0)

    SetPedCanBeDraggedOut(taxiPed, false)
    SetPedStayInVehicleWhenJacked(taxiPed, true)
    
    SetVehicleDoorsLocked(taxiVehicle, 0)
    SetVehicleDoorsLockedForAllPlayers(taxiVehicle, false)

-- Target to get into the back of the taxi
    exports.ox_target:addLocalEntity(taxiVehicle, {
        {
            name = 'enter_taxi_ride',
            icon = 'fas fa-door-open',
            label = 'Get in Taxi',
            distance = 2.5,
            onSelect = function()
                ClearPedTasks(cache.ped)
                
                -- ** FIX: Force the doors completely unlocked just in case Qbox locked them **
                SetVehicleDoorsLocked(taxiVehicle, 1) 
                SetVehicleDoorsLockedForAllPlayers(taxiVehicle, false)
                
                -- Tell the ped to enter the back seat
                TaskEnterVehicle(cache.ped, taxiVehicle, 10000, 1, 2.0, 1, 0)
            end,
            canInteract = function()
                return taxiActive and not IsPedInVehicle(cache.ped, taxiVehicle, false)
            end
        }
    })

    exports.ox_target:addLocalEntity(taxiPed, {
        {
            name = 'tell_taxi_driver',
            icon = 'fas fa-map-location-dot',
            label = 'Change Destination',
            distance = 2.0,
            onSelect = function()
                ShowDestinationMenu()
            end,
            canInteract = function()
                return taxiActive and IsPedInVehicle(cache.ped, taxiVehicle, false)
            end
        }
    })

    taxiBlip = AddBlipForEntity(taxiVehicle)
    SetBlipSprite(taxiBlip, 56)
    SetBlipColour(taxiBlip, 5) 
    SetBlipScale(taxiBlip, 0.8)
    SetBlipAsShortRange(taxiBlip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Your Taxi")
    EndTextCommandSetBlipName(taxiBlip)

    TaskVehicleDriveToCoordLongrange(taxiPed, taxiVehicle, pickupCoords.x, pickupCoords.y, pickupCoords.z, 12.0, 1074528293, 2.0)

    Citizen.CreateThread(function()
        while taxiActive do
            Citizen.Wait(1000)
            local cabCoords = GetEntityCoords(taxiVehicle)
            local dist = #(cabCoords - vector3(pickupCoords.x, pickupCoords.y, pickupCoords.z))

            if dist < 10.0 then
                BringVehicleToHalt(taxiVehicle, 5.0, 1, false)
                SoundVehicleHornThisFrame(taxiVehicle)
                lib.notify({ title = 'Taxi', description = 'Your ride is here! Use your target eye to get in.', type = 'success' })
                WaitForPlayerToEnter()
                break
            end
        end
    end)
end

function WaitForPlayerToEnter()
    Citizen.CreateThread(function()
        local entered = false
        while taxiActive and not entered do
            Citizen.Wait(500)
            if IsPedInVehicle(cache.ped, taxiVehicle, false) then
                entered = true
                ShowDestinationMenu()
            end
        end
    end)
end

function DriveToWaypoint()
    local waypoint = GetFirstBlipInfoId(8)
    if not DoesBlipExist(waypoint) then
        lib.notify({ title = 'Taxi', description = 'Please set a GPS waypoint first!', type = 'error' })
        
        Citizen.CreateThread(function()
            while taxiActive and not DoesBlipExist(GetFirstBlipInfoId(8)) do
                Citizen.Wait(1000)
            end
            if taxiActive then
                local wp = GetFirstBlipInfoId(8)
                local destCoords = GetBlipInfoIdCoord(wp)
                StartTaxiDrive(destCoords, "Custom Waypoint")
            end
        end)
        return
    end

    local destCoords = GetBlipInfoIdCoord(waypoint)
    StartTaxiDrive(destCoords, "Custom Waypoint")
end

function StartTaxiDrive(destCoords, destName)
    local startCoords = GetEntityCoords(cache.ped)
    local travelDistance = #(startCoords - vector3(destCoords.x, destCoords.y, destCoords.z))
    
    lib.notify({ title = 'Taxi', description = 'Heading to: ' .. destName, type = 'info' })
    
    TaskVehicleDriveToCoordLongrange(taxiPed, taxiVehicle, destCoords.x, destCoords.y, destCoords.z, 25.0, 1074528293, 3.0)

    Citizen.CreateThread(function()
        while taxiActive do
            Citizen.Wait(1000)
            local currentCoords = GetEntityCoords(taxiVehicle)
            local distToDest = #(currentCoords - vector3(destCoords.x, destCoords.y, destCoords.z))

            if distToDest < 15.0 then
                BringVehicleToHalt(taxiVehicle, 4.0, 1, false)
                lib.notify({ title = 'Taxi', description = 'You have arrived!', type = 'success' })
                
                local fare = math.floor(travelDistance * 0.05) 
                if fare < 10 then fare = 10 end
                
                TriggerServerEvent('bucko_taxi:server:payFare', fare)
                
                TaskLeaveVehicle(cache.ped, taxiVehicle, 0)
                Citizen.Wait(3000)
                TaskVehicleDriveWander(taxiPed, taxiVehicle, 15.0, 1074528293)
                
                if DoesBlipExist(taxiBlip) then RemoveBlip(taxiBlip) end
                exports.ox_target:removeLocalEntity(taxiVehicle, 'enter_taxi_ride')
                exports.ox_target:removeLocalEntity(taxiPed, 'tell_taxi_driver')
                
                taxiBlip = nil
                SetEntityAsNoLongerNeeded(taxiVehicle)
                SetEntityAsNoLongerNeeded(taxiPed)
                
                taxiActive = false
                taxiVehicle = nil
                taxiPed = nil
                break
            end
        end
    end)
end