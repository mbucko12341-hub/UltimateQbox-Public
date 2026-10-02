-- Spawn Physical Stash Safe & Setup Access for All Gang Members
function refreshStashZones(stashData)
    for _, zoneId in pairs(StashZones) do
        exports.ox_target:removeZone(zoneId)
    end
    StashZones = {}

    for _, point in pairs(StashPoints) do
        point:remove()
    end
    StashPoints = {}

    for _, obj in pairs(StashObjects) do
        if DoesEntityExist(obj) then DeleteEntity(obj) end
    end
    StashObjects = {}

    local stashes = stashData or GlobalState.tb_gang_stashes or {}
    local model = Config.StashSettings.propModel

    for gang, info in pairs(stashes) do
        local coords = info.coords
        local heading = (tonumber(info.heading) or 0.0) + 0.0
        local minGrade = tonumber(info.minGrade) or 0

        if model and coords then
            lib.requestModel(model)
            local obj = CreateObject(model, coords.x + 0.0, coords.y + 0.0, coords.z + 0.0, false, false, false)
            SetEntityHeading(obj, heading)
            PlaceObjectOnGroundProperly(obj)
            FreezeEntityPosition(obj, true)
            SetEntityInvincible(obj, true)
            StashObjects[gang] = obj
        end

        StashZones[gang] = exports.ox_target:addSphereZone({
            coords = vec3(coords.x + 0.0, coords.y + 0.0, coords.z + 0.5),
            radius = 1.6,
            debug = false,
            options = {
                {
                    name = 'open_gang_stash_' .. gang,
                    icon = 'fa-solid fa-vault',
                    label = ('Open %s Stash'):format(string.upper(gang)),
                    canInteract = function()
                        local pData = QBX.PlayerData
                        return pData and pData.gang and pData.gang.name == gang and (pData.gang.grade.level or 0) >= minGrade
                    end,
                    onSelect = function()
                        TriggerServerEvent('tb-gangs:server:openGangStash', gang)
                    end
                }
            }
        })

        if Config.StashSettings.allowKeybindOpen then
            StashPoints[gang] = lib.points.new({
                coords = vec3(coords.x + 0.0, coords.y + 0.0, coords.z + 0.5),
                distance = 2.0,
                onEnter = function()
                    local pData = QBX.PlayerData
                    if pData and pData.gang and pData.gang.name == gang and (pData.gang.grade.level or 0) >= minGrade then
                        lib.showTextUI(('[E] - Open %s Stash'):format(string.upper(gang)), {
                            position = 'right-center',
                            icon = 'vault'
                        })
                    end
                end,
                onExit = function()
                    lib.hideTextUI()
                end,
                nearby = function()
                    if IsControlJustReleased(0, 38) then
                        local pData = QBX.PlayerData
                        if pData and pData.gang and pData.gang.name == gang and (pData.gang.grade.level or 0) >= minGrade then
                            TriggerServerEvent('tb-gangs:server:openGangStash', gang)
                        end
                    end
                end
            })
        end
    end
end

-- Interactive 3D Raycast Placement for Leader inside Compound
function startStashPlacement(minGrade)
    if isPlacingStash then return end

    local serverData = lib.callback.await('tb-gangs:server:getGangData', false)
    local gang = serverData and serverData.gang and serverData.gang.name
    if not gang or gang == 'none' or not serverData.gang.isboss then return end

    if Config.StashSettings.requireOwnedCompound then
        local turfs = GlobalState.tb_gang_turfs or {}
        local owner = currentZone and turfs[currentZone] and turfs[currentZone].owner
        if not currentZone or owner ~= gang then
            return lib.notify({
                title = 'Compound Required',
                description = 'You must be inside a compound/turf controlled by your gang to place your stash!',
                type = 'error'
            })
        end
    end

    isPlacingStash = true
    local model = Config.StashSettings.propModel or `prop_ld_int_safe_01`
    lib.requestModel(model)

    local ped = cache.ped
    local offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, 0.0)
    local previewObj = CreateObject(model, offset.x, offset.y, offset.z, false, false, false)
    SetEntityAlpha(previewObj, 170, false)
    SetEntityCollision(previewObj, false, false)

    local heading = GetEntityHeading(ped)

    lib.showTextUI('[E] Place Stash  |  [Scroll] Rotate  |  [Backspace] Cancel', {
        position = 'top-center',
        icon = 'vault'
    })

    CreateThread(function()
        while isPlacingStash do
            Wait(0)
            local hit, _, endCoords = lib.raycast.cam(1, 7, 10.0)
            if hit then
                SetEntityCoords(previewObj, endCoords.x, endCoords.y, endCoords.z, false, false, false, false)
                PlaceObjectOnGroundProperly(previewObj)
            end

            if IsControlPressed(0, 15) then
                heading = (heading + 3.5) % 360.0
            elseif IsControlPressed(0, 14) then
                heading = (heading - 3.5) % 360.0
            end
            SetEntityHeading(previewObj, heading)

            if IsControlJustReleased(0, 38) then
                local finalCoords = GetEntityCoords(previewObj)
                isPlacingStash = false
                lib.hideTextUI()
                DeleteEntity(previewObj)
                TriggerServerEvent('tb-gangs:server:saveStash', finalCoords, heading, minGrade)
            end

            if IsControlJustReleased(0, 177) then
                isPlacingStash = false
                lib.hideTextUI()
                DeleteEntity(previewObj)
                lib.notify({ title = 'Gang Stash', description = 'Stash placement cancelled.', type = 'inform' })
            end
        end
    end)
end

RegisterNetEvent('tb-gangs:client:refreshStashes', function(stashes)
    refreshStashZones(stashes)
end)