--[[
    bucko-vitals: floating vitals UI

    Purely a "consumer" of the 'vitalsDowned' state bag published by
    server/main.lua on each downed player's ped whenever it hears
    qb-ambulancejob's death/laststand network events. This file never
    touches qb-ambulancejob directly.
]]

local headBone = 0x796E601F -- SKEL_HEAD (anchor point for the floating card)
local visible = {}
local DEBUG = false -- set true to print diagnostics to F8 console

local function getVitalsEntry(playerId, ped, myCoords)
    local state = Entity(ped).state.vitalsDowned
    if not state then return nil end

    local coords = GetEntityCoords(ped)
    local distance = #(myCoords - coords)
    if distance > Config.Radius then return nil end

    local boneIndex = GetPedBoneIndex(ped, headBone)
    local anchor = (boneIndex and boneIndex ~= -1) and GetWorldPositionOfEntityBone(ped, boneIndex) or (coords + vector3(0.0, 0.0, 0.6))
    anchor = anchor + vector3(0.0, 0.0, 0.3)

    local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(anchor.x, anchor.y, anchor.z)
    if DEBUG then
        print(('[bucko-vitals] status=%s onScreen=%s x=%s y=%s'):format(tostring(state.status), tostring(onScreen), tostring(screenX), tostring(screenY)))
    end
    if not onScreen then return nil end

    local health = 0
    local timeLeft = 0
    if state.status == 'laststand' then
        local max = state.max or Config.ReviveInterval
        timeLeft = math.max(0, math.floor(state.time or 0))
        health = math.max(0, math.min(100, math.ceil((timeLeft / max) * 100)))
    end

    return {
        id = GetPlayerServerId(playerId),
        name = state.name or GetPlayerName(playerId),
        status = state.status,
        health = health,
        time = timeLeft,
        x = screenX,
        y = screenY,
    }
end

CreateThread(function()
    while true do
        local wait = Config.IdleInterval
        local myPed = PlayerPedId()
        local myCoords = GetEntityCoords(myPed)
        local entries = {}

        for _, playerId in ipairs(GetActivePlayers()) do
            local ped = GetPlayerPed(playerId)
            if ped and ped ~= 0 then
                local ok, entry = pcall(getVitalsEntry, playerId, ped, myCoords)
                if ok and entry then
                    entries[#entries + 1] = entry
                elseif not ok and DEBUG then
                    print('[bucko-vitals] error in getVitalsEntry: ' .. tostring(entry))
                end
            end
        end

        if #entries > 0 or next(visible) ~= nil then
            SendNUIMessage({ action = 'vitals:update', entries = entries })

            visible = {}
            for _, entry in ipairs(entries) do
                visible[entry.id] = true
            end

            wait = Config.UpdateInterval
        end

        Wait(wait)
    end
end)
