local resourceName = GetCurrentResourceName()
local framework = 'standalone'
local open = false
local selectedIndex = 1
local lastChange = 0

local function detectFramework()
    if GetResourceState('qbx_core') == 'started' then
        framework = 'qbox'
    elseif GetResourceState('qb-core') == 'started' then
        framework = 'qbcore'
    elseif GetResourceState('es_extended') == 'started' then
        framework = 'esx'
    else
        framework = 'standalone'
    end
end

local function currentVehicle()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)

    if vehicle == 0 then
        return 0
    end

    if not Config.AllowPassengers and GetPedInVehicleSeat(vehicle, -1) ~= ped then
        return 0
    end

    return vehicle
end

local function findCurrentStation()
    local current = GetPlayerRadioStationName()

    if not current or current == '' then
        return 1
    end

    for index, station in ipairs(Config.Stations) do
        if station.name == current then
            return index
        end
    end

    return 1
end

local function displayStations()
    local result = {}

    for index, station in ipairs(Config.Stations) do
        result[index] = {
            name = station.name,
            label = station.label,
            short = station.short,
            genre = station.genre,
            color = station.color
        }
    end

    return result
end

local function applyStation()
    local vehicle = currentVehicle()

    if vehicle == 0 then
        return
    end

    local station = Config.Stations[selectedIndex]

    if station.name == 'OFF' then
        SetVehicleRadioEnabled(vehicle, false)
        SetVehRadioStation(vehicle, 'OFF')
    else
        SetVehicleRadioEnabled(vehicle, true)
        SetVehRadioStation(vehicle, station.name)
    end

    SendNUIMessage({ action = 'selected', index = selectedIndex })
end

local function cycleStation(direction)
    local now = GetGameTimer()

    if now - lastChange < Config.ChangeDelay then
        return
    end

    lastChange = now
    local nextIndex = selectedIndex + direction

    if Config.WrapStations then
        if nextIndex < 1 then
            nextIndex = #Config.Stations
        elseif nextIndex > #Config.Stations then
            nextIndex = 1
        end
    else
        nextIndex = math.max(1, math.min(#Config.Stations, nextIndex))
    end

    selectedIndex = nextIndex
    applyStation()
end

local function openRadio()
    if open or IsPauseMenuActive() or IsEntityDead(PlayerPedId()) then
        return
    end

    if Config.RequireVehicle and currentVehicle() == 0 then
        return
    end

    selectedIndex = findCurrentStation()
    open = true
    lastChange = 0
    TriggerScreenblurFadeIn(Config.BlurDuration)
    SetNuiFocus(true, false)
    SetNuiFocusKeepInput(true)
    SendNUIMessage({
        action = 'open',
        stations = displayStations(),
        selectedIndex = selectedIndex,
        colors = Config.Colors,
        showStationCount = Config.ShowStationCount,
        framework = framework,
        resource = resourceName
    })
end

local function closeRadio()
    if not open then
        return
    end

    open = false
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    TriggerScreenblurFadeOut(Config.BlurDuration)
    SendNUIMessage({ action = 'close' })
end

RegisterCommand('+' .. Config.Command, openRadio, false)
RegisterCommand('-' .. Config.Command, closeRadio, false)
RegisterKeyMapping('+' .. Config.Command, 'Open vehicle radio selector', 'keyboard', Config.Keybind)

RegisterNUICallback('cycle', function(data, callback)
    cycleStation(tonumber(data.direction) or 1)
    callback({ ok = true })
end)

CreateThread(function()
    detectFramework()

    while true do
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

        if vehicle ~= 0 then
            DisableControlAction(0, 81, true)
            DisableControlAction(0, 82, true)
            DisableControlAction(0, 85, true)
            HideHudComponentThisFrame(16)

            if open then
                DisableControlAction(0, 44, true)
                DisableControlAction(0, 174, true)
                DisableControlAction(0, 175, true)
                DisableControlAction(0, 241, true)
                DisableControlAction(0, 242, true)

                if IsDisabledControlJustPressed(0, 174) or IsDisabledControlJustPressed(0, 242) then
                    cycleStation(-1)
                elseif IsDisabledControlJustPressed(0, 175) or IsDisabledControlJustPressed(0, 241) then
                    cycleStation(1)
                end

                if Config.RequireVehicle and currentVehicle() == 0 then
                    closeRadio()
                end
            end

            Wait(0)
        elseif open then
            DisableControlAction(0, 44, true)
            closeRadio()
            Wait(0)
        else
            Wait(200)
        end
    end
end)

AddEventHandler('onClientResourceStart', function(resource)
    if resource == 'qbx_core' or resource == 'qb-core' or resource == 'es_extended' then
        detectFramework()
    end
end)

AddEventHandler('onClientResourceStop', function(resource)
    if resource == resourceName then
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
        TriggerScreenblurFadeOut(0)
    end
end)

exports('Open', openRadio)
exports('Close', closeRadio)
exports('IsOpen', function()
    return open
end)
exports('GetFramework', function()
    return framework
end)
