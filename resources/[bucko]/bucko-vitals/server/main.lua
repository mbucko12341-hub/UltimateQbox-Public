-- Tracks an active bleed-out countdown loop per player so it can be cancelled cleanly
local activeLoops = {}

-- Player-level state bags don't reliably replicate in this setup; entity state
-- bags on the player's own ped are the standard, well-tested approach.
local function getPedState(src)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return nil end
    return Entity(ped).state
end

-- Prefer the QBCore character name (what other players call them in-game)
-- over the Rockstar/Steam display name, falling back if qb-core isn't ready.
local function getCharName(src)
    local QBPlayer = exports['qb-core']:GetPlayer(src)
    local charinfo = QBPlayer and QBPlayer.PlayerData and QBPlayer.PlayerData.charinfo
    if charinfo and charinfo.firstname then
        return ('%s %s'):format(charinfo.firstname, charinfo.lastname or ''):gsub('%s+$', '')
    end
    return GetPlayerName(src) or 'Unknown'
end

local function clearVitals(src)
    activeLoops[src] = nil
    local state = getPedState(src)
    if state then
        state:set('vitalsDowned', nil, true)
    end
end

local function startLaststandLoop(src)
    activeLoops[src] = true
    local timeLeft = Config.ReviveInterval

    CreateThread(function()
        while activeLoops[src] do
            local state = getPedState(src)
            if not state then
                activeLoops[src] = nil
                return
            end

            state:set('vitalsDowned', {
                status = 'laststand',
                time = timeLeft,
                max = Config.ReviveInterval,
                name = getCharName(src),
            }, true)

            Wait(1000)

            if not activeLoops[src] then return end
            timeLeft = math.max(0, timeLeft - 1)
        end
    end)
end

RegisterNetEvent('hospital:server:SetLaststandStatus', function(bool)
    local src = source
    if bool then
        startLaststandLoop(src)
    else
        activeLoops[src] = nil
        -- Delay the clear slightly: if the player bled out, 'hospital:server:SetDeathStatus'
        -- fires right after this and will overwrite the state bag with the 'dead' status.
        SetTimeout(250, function()
            local QBPlayer = exports['qb-core']:GetPlayer(src)
            local isDead = QBPlayer and QBPlayer.PlayerData.metadata and QBPlayer.PlayerData.metadata['isdead']
            if not isDead then
                clearVitals(src)
            end
        end)
    end
end)

RegisterNetEvent('hospital:server:SetDeathStatus', function(bool)
    local src = source
    activeLoops[src] = nil

    if bool then
        local state = getPedState(src)
        if state then
            state:set('vitalsDowned', { status = 'dead', name = getCharName(src) }, true)
        end
    else
        clearVitals(src)
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    activeLoops[src] = nil
end)
