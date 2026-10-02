TurfBlips = {}
ActivePolyZones = {}
StashObjects = {}
StashZones = {}
StashPoints = {}
ActiveSprays = {}
LoadedSprayTextures = {}
DuiHandles = {}

currentZone = nil
isUiOpen = false
isPlacingStash = false
isAimingSpray = false
isDrawingPoly = false
tabletObj = nil

runtimeTxd = CreateRuntimeTxd('tb_gang_sprays_txd')

-- Safe item count check (prevents ox_inventory error after live restarts)
function hasItemClient(itemName)
    local ok, count = pcall(function()
        return exports.ox_inventory:Search('count', itemName)
    end)
    if not ok then
        return true
    end
    return (count or 0) >= 1
end

-- Tablet Animation & Prop Helpers
function startTabletAnimation()
    local ped = cache.ped
    local dict = 'amb@code_human_in_bus_passenger_idles@female@tablet@base'
    local model = `prop_cs_tablet`

    lib.requestAnimDict(dict)
    lib.requestModel(model)

    if DoesEntityExist(tabletObj) then DeleteEntity(tabletObj) end
    tabletObj = CreateObject(model, 0.0, 0.0, 0.0, true, true, false)
    AttachEntityToEntity(
        tabletObj,
        ped,
        GetPedBoneIndex(ped, 60309),
        0.03, 0.002, -0.0,
        10.0, 160.0, 0.0,
        true, false, false, false, 2, true
    )
    TaskPlayAnim(ped, dict, 'base', 3.0, 3.0, -1, 49, 0, false, false, false)
end

function stopTabletAnimation()
    local ped = cache.ped
    StopAnimTask(ped, 'amb@code_human_in_bus_passenger_idles@female@tablet@base', 'base', 1.0)
    if DoesEntityExist(tabletObj) then
        DeleteEntity(tabletObj)
        tabletObj = nil
    end
end

-- Custom NUI Rep Gained Notification
RegisterNetEvent('tb-gangs:client:repNotification', function(repGained, totalRep, subtitle)
    SendNUIMessage({
        action = 'showRepToast',
        repGained = repGained,
        totalRep = totalRep,
        subtitle = subtitle
    })
    PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
end)

-- Invite Alert Dialog for Target Player
lib.callback.register('tb-gangs:client:receiveInvite', function(gangLabel)
    local alert = lib.alertDialog({
        header = 'Gang Invitation',
        content = ('You have been invited to join **%s**. Do you accept?'):format(gangLabel),
        centered = true,
        cancel = true
    })
    return alert == 'confirm'
end)

-- Open Custom NUI Dashboard via Gang Tablet Item
function openGangTablet()
    if isUiOpen or isPlacingStash or isAimingSpray or isDrawingPoly then return end

    local tabletItem = Config.TabletItem or 'gangtablet'
    if not hasItemClient(tabletItem) then
        return lib.notify({ title = 'Gang Tablet', description = 'You need a Gang Tablet to open this.', type = 'error' })
    end

    local serverData = lib.callback.await('tb-gangs:server:getGangData', false)
    if not serverData or not serverData.gang or serverData.gang.name == 'none' then
        return lib.notify({ title = 'Gang Tablet', description = 'Encrypted Device: You are not affiliated with any gang.', type = 'error' })
    end

    local gang = serverData.gang
    local turfs = GlobalState.tb_gang_turfs or {}

    local currentTurfInfo = nil
    if currentZone and turfs[currentZone] then
        local zData = turfs[currentZone]
        currentTurfInfo = {
            id = currentZone,
            label = zData.label,
            owner = string.upper(zData.owner or zData.defaultOwner or 'none'),
            points = zData.points or 100
        }
    end

    startTabletAnimation()
    isUiOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'open',
        gang = {
            name = gang.name,
            label = gang.label,
            gradeName = gang.grade.name,
            isBoss = gang.isboss,
            rep = serverData.rep or 0
        },
        currentTurf = currentTurfInfo,
        territories = getFormattedTurfs(),
        members = serverData.members or {},
        grades = serverData.grades or {},
        stash = serverData.stash
    })
end

exports('useGangTablet', function()
    openGangTablet()
end)

RegisterNetEvent('tb-gangs:client:openTablet', function()
    openGangTablet()
end)

-- NUI Callbacks
RegisterNUICallback('closeUI', function(_, cb)
    isUiOpen = false
    SetNuiFocus(false, false)
    stopTabletAnimation()
    cb('ok')
end)

RegisterNUICallback('tagTurf', function(_, cb)
    isUiOpen = false
    SetNuiFocus(false, false)
    stopTabletAnimation()
    SendNUIMessage({ action = 'close' })
    cb('ok')
    Wait(150)
    openSpraySelectorMenu()
end)

RegisterNUICallback('selectSprayDesign', function(data, cb)
    isUiOpen = false
    SetNuiFocus(false, false)
    stopTabletAnimation()
    cb('ok')
    if data and data.image then
        startWallSprayPlacement(data.image)
    end
end)

RegisterNUICallback('invitePlayer', function(data, cb)
    local targetId = tonumber(data.targetId)
    if targetId then
        TriggerServerEvent('tb-gangs:server:invitePlayer', targetId)
    end
    cb('ok')
end)

RegisterNUICallback('setMemberRank', function(data, cb)
    local targetSource = tonumber(data.source)
    local newGrade = tonumber(data.grade)
    if targetSource and newGrade then
        TriggerServerEvent('tb-gangs:server:setMemberRank', targetSource, newGrade)
        Wait(250)
        local updated = lib.callback.await('tb-gangs:server:getGangData', false)
        cb(updated and updated.members or {})
        return
    end
    cb({})
end)

RegisterNUICallback('kickMember', function(data, cb)
    local targetSource = tonumber(data.source)
    if targetSource then
        TriggerServerEvent('tb-gangs:server:kickMember', targetSource)
        Wait(250)
        local updated = lib.callback.await('tb-gangs:server:getGangData', false)
        cb(updated and updated.members or {})
        return
    end
    cb({})
end)

RegisterNUICallback('placeStash', function(data, cb)
    isUiOpen = false
    SetNuiFocus(false, false)
    stopTabletAnimation()
    SendNUIMessage({ action = 'close' })
    cb('ok')
    startStashPlacement(tonumber(data.minGrade) or 0)
end)

RegisterNUICallback('updateStashGrade', function(data, cb)
    TriggerServerEvent('tb-gangs:server:updateStashGrade', tonumber(data.minGrade) or 0)
    cb('ok')
end)

-- Initialize All Zones, Blips & Sprays
function initializeClient(turfs, colors, stashes, sprays)
    local activeTurfs = turfs or GlobalState.tb_gang_turfs or {}
    ActiveSprays = sprays or GlobalState.tb_gang_sprays or {}

    refreshTurfBlips(activeTurfs, colors)
    refreshStashZones(stashes)

    for zoneId, turf in pairs(activeTurfs) do
        registerZoneSphere(zoneId, turf)
    end
end

CreateThread(function()
    Wait(1500)
    initializeClient()
end)

RegisterNetEvent('tb-gangs:client:initAll', function(turfs, colors, stashes, sprays)
    initializeClient(turfs, colors, stashes, sprays)
end)

-- Cleanup Props, Blips & DUIs on Resource Stop
AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    stopTabletAnimation()
    for _, obj in pairs(StashObjects) do
        if DoesEntityExist(obj) then DeleteEntity(obj) end
    end
    for _, blips in pairs(TurfBlips) do
        if blips.areas then
            for _, b in ipairs(blips.areas) do
                if DoesBlipExist(b) then RemoveBlip(b) end
            end
        end
        if blips.radius and DoesBlipExist(blips.radius) then RemoveBlip(blips.radius) end
        if blips.center and DoesBlipExist(blips.center) then RemoveBlip(blips.center) end
    end
    for _, dui in ipairs(DuiHandles) do
        DestroyDui(dui)
    end
end)