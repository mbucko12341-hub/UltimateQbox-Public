local cityHallCoords = Config.CityHallCoords
local cityHallPed = nil

CreateThread(function()
    -- Create Blip
    local blip = AddBlipForCoord(cityHallCoords)
    SetBlipSprite(blip, 419)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("City Hall")
    EndTextCommandSetBlipName(blip)

    -- Spawn Receptionist Ped
    local pedModel = `a_m_y_business_01` -- Clean suited business model
    lib.requestModel(pedModel, 5000)
    
    if HasModelLoaded(pedModel) then
        -- Note: Adjust heading (last parameter, e.g., 180.0) to rotate the ped to face the right direction
        cityHallPed = CreatePed(4, pedModel, cityHallCoords.x, cityHallCoords.y, cityHallCoords.z - 1.0, 180.0, false, true)
        SetEntityHeading(cityHallPed, 180.0)
        FreezeEntityPosition(cityHallPed, true)
        SetEntityInvincible(cityHallPed, true)
        SetBlockingOfNonTemporaryEvents(cityHallPed, true)
        SetModelAsNoLongerNeeded(pedModel)
    end

    -- Add ox_target interaction (attached to coords or the ped itself)
    exports.ox_target:addBoxZone({
        coords = cityHallCoords,
        size = vector3(1.5, 1.5, 2.0),
        rotation = 20.0,
        debug = false,
        options = {
            {
                name = 'open_cityhall',
                icon = 'fas fa-landmark',
                label = 'Access City Hall',
                onSelect = function()
                    OpenCityHallUI()
                end
            }
        }
    })
end)

function OpenCityHallUI()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'open',
        jobs = Config.Employment.jobs
    })
end

-- NUI Callbacks
RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'close'
    })
    cb('ok')
end)

RegisterNUICallback('requestDocument', function(data, cb)
    TriggerServerEvent('bucko_cityhall:server:getIdentity', data.docType)
    cb('ok')
end)

RegisterNUICallback('setJob', function(data, cb)
    TriggerServerEvent('bucko_cityhall:server:setJob', data.jobName)
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'close'
    })
    cb('ok')
end)