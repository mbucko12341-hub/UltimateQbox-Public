-- Load a PNG directly with True Alpha Transparency (No White Background)
function getOrLoadSprayTexture(imageFile)
    if not imageFile then return nil end
    if LoadedSprayTextures[imageFile] then
        return LoadedSprayTextures[imageFile]
    end

    local texName = 'spray_tex_' .. string.gsub(imageFile, '[^%w]', '_')

    if not string.find(imageFile, '^https?://') then
        CreateRuntimeTextureFromImage(runtimeTxd, texName, 'web/sprays/' .. imageFile)
    else
        local html = ('data:text/html,<html><body style="margin:0;background:transparent;overflow:hidden;"><img src="%s" style="width:100%%;height:100%%;object-fit:contain;"/></body></html>'):format(imageFile)
        local duiObj = CreateDui(html, 512, 512)
        DuiHandles[#DuiHandles + 1] = duiObj
        local duiHandle = GetDuiHandle(duiObj)
        CreateRuntimeTextureFromDuiHandle(runtimeTxd, texName, duiHandle)
    end

    LoadedSprayTextures[imageFile] = texName
    return texName
end

-- Draw a 3D Textured PNG Quad Flat Against Any Wall
function drawWallSprayQuad(coords, normal, size, imageFile, alpha)
    local texName = getOrLoadSprayTexture(imageFile)
    if not texName then return end

    local center = coords + (normal * 0.025)

    local right = vec3(-normal.y, normal.x, 0.0)
    local rightLen = #right
    if rightLen < 0.001 then
        right = vec3(1.0, 0.0, 0.0)
    else
        right = right / rightLen
    end

    local up = vec3(
        normal.y * right.z - normal.z * right.y,
        normal.z * right.x - normal.x * right.z,
        normal.x * right.y - normal.y * right.x
    )
    local upLen = #up
    if upLen > 0.001 then
        up = up / upLen
    end

    local half = (size or 1.8) * 0.5
    local tl = center - (right * half) + (up * half)
    local tr = center + (right * half) + (up * half)
    local bl = center - (right * half) - (up * half)
    local br = center + (right * half) - (up * half)

    local a = alpha or 255

    DrawSpritePoly(
        bl.x, bl.y, bl.z,
        tl.x, tl.y, tl.z,
        tr.x, tr.y, tr.z,
        255, 255, 255, a,
        'tb_gang_sprays_txd', texName,
        0.0, 1.0, 0.0,
        0.0, 0.0, 0.0,
        1.0, 0.0, 0.0
    )
    DrawSpritePoly(
        bl.x, bl.y, bl.z,
        tr.x, tr.y, tr.z,
        br.x, br.y, br.z,
        255, 255, 255, a,
        'tb_gang_sprays_txd', texName,
        0.0, 1.0, 0.0,
        1.0, 0.0, 0.0,
        1.0, 1.0, 0.0
    )

    DrawSpritePoly(
        tr.x, tr.y, tr.z,
        tl.x, tl.y, tl.z,
        bl.x, bl.y, bl.z,
        255, 255, 255, a,
        'tb_gang_sprays_txd', texName,
        1.0, 0.0, 0.0,
        0.0, 0.0, 0.0,
        0.0, 1.0, 0.0
    )
    DrawSpritePoly(
        br.x, br.y, br.z,
        tr.x, tr.y, tr.z,
        bl.x, bl.y, bl.z,
        255, 255, 255, a,
        'tb_gang_sprays_txd', texName,
        1.0, 1.0, 0.0,
        1.0, 0.0, 0.0,
        0.0, 1.0, 0.0
    )
end

-- Render Loop for Nearby Wall Sprays
CreateThread(function()
    while true do
        local sleep = 750
        local ped = cache.ped
        if ped and #ActiveSprays > 0 then
            local pCoords = GetEntityCoords(ped)
            local maxDist = Config.SprayRenderDistance or 60.0

            for i = 1, #ActiveSprays do
                local s = ActiveSprays[i]
                if s and s.coords then
                    local dist = #(pCoords - s.coords)
                    if dist <= maxDist then
                        sleep = 0
                        drawWallSprayQuad(s.coords, s.normal, s.size, s.image, 245)
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

-- Step 2 of Spraying: Aim Selected PNG on a Wall & Spray It
function startWallSprayPlacement(selectedImage)
    if isAimingSpray then return end

    local pData = QBX.PlayerData
    if not pData or not pData.gang or pData.gang.name == 'none' then
        return lib.notify({ title = 'Spray Can', description = 'Only gang members can spray gang logos!', type = 'error' })
    end

    isAimingSpray = true
    local spraySize = 1.8
    getOrLoadSprayTexture(selectedImage)

    lib.showTextUI('[E] Spray Wall  |  [Scroll] Resize Tag  |  [Backspace] Cancel', {
        position = 'top-center',
        icon = 'spray-can-sparkles'
    })

    CreateThread(function()
        while isAimingSpray do
            Wait(0)
            local hit, _, endCoords, surfaceNormal = lib.raycast.cam(1, 4, 7.5)
            local isVerticalWall = hit and math.abs(surfaceNormal.z) < 0.35

            if IsControlPressed(0, 15) then
                spraySize = math.min(3.5, spraySize + 0.04)
            elseif IsControlPressed(0, 14) then
                spraySize = math.max(0.8, spraySize - 0.04)
            end

            if isVerticalWall then
                drawWallSprayQuad(endCoords, surfaceNormal, spraySize, selectedImage, 195)

                if IsControlJustReleased(0, 38) then
                    local pedCoords = GetEntityCoords(cache.ped)
                    if #(pedCoords - endCoords) > 4.5 then
                        lib.notify({ title = 'Spray Can', description = 'Move closer to the wall to spray!', type = 'error' })
                    else
                        isAimingSpray = false
                        lib.hideTextUI()

                        TaskTurnPedToFaceCoord(cache.ped, endCoords.x, endCoords.y, endCoords.z, 600)
                        Wait(600)

                        local canModel = `prop_cs_spray_can`
                        lib.requestModel(canModel)
                        local canObj = CreateObject(canModel, 0.0, 0.0, 0.0, true, true, false)
                        AttachEntityToEntity(
                            canObj, cache.ped, GetPedBoneIndex(cache.ped, 57005),
                            0.11, 0.02, -0.02, -80.0, 0.0, 0.0,
                            true, true, false, true, 1, true
                        )

                        local completed = lib.progressBar({
                            duration = Config.TagDuration or 8000,
                            label = 'Spraying Gang Tag...',
                            useWhileDead = false,
                            canCancel = true,
                            disable = { move = true, car = true, combat = true },
                            anim = {
                                dict = 'switch@franklin@lamar_tagging_wall',
                                clip = 'lamar_tagging_wall_loop_lamar'
                            }
                        })

                        if DoesEntityExist(canObj) then DeleteEntity(canObj) end

                        if completed then
                            TriggerServerEvent('tb-gangs:server:placeWallSpray', {
                                image = selectedImage,
                                coords = { x = endCoords.x, y = endCoords.y, z = endCoords.z },
                                normal = { x = surfaceNormal.x, y = surfaceNormal.y, z = surfaceNormal.z },
                                size = spraySize
                            })
                        else
                            lib.notify({ title = 'Spray Can', description = 'Stopped spraying.', type = 'error' })
                        end
                    end
                end
            end

            if IsControlJustReleased(0, 177) then
                isAimingSpray = false
                lib.hideTextUI()
                lib.notify({ title = 'Spray Can', description = 'Cancelled wall tagging.', type = 'inform' })
            end
        end
    end)
end

-- Step 1 of Spraying: Automatically Load ONLY the Player's Gang Logo (<gang_id>.png)
function openSpraySelectorMenu()
    if isUiOpen or isPlacingStash or isAimingSpray or isDrawingPoly then return end

    local serverData = lib.callback.await('tb-gangs:server:getGangData', false)
    if not serverData or not serverData.gang or serverData.gang.name == 'none' then
        return lib.notify({ title = 'Spray Can', description = 'Only affiliated gang members can spray gang tags!', type = 'error' })
    end

    if not currentZone and not Config.AllowSprayOutsideTurf then
        return lib.notify({ title = 'Gang Turf', description = 'You are not inside any gang territory.', type = 'error' })
    end

    if Config.SprayItem and not hasItemClient(Config.SprayItem) then
        return lib.notify({ title = 'Spray Can', description = 'You need a ' .. Config.SprayItem .. ' in your inventory!', type = 'error' })
    end

    local myGang = string.lower(serverData.gang.name)
    local myGangLabel = serverData.gang.label
    local designs = {}

    for _, d in ipairs(Config.SprayDesigns or {}) do
        if d.gang == myGang then
            designs[#designs + 1] = {
                id = d.id,
                label = d.label,
                image = d.image
            }
            getOrLoadSprayTexture(d.image)
        end
    end

    if #designs == 0 then
        local autoImage = myGang .. '.png'
        designs[#designs + 1] = {
            id = myGang .. '_tag',
            label = myGangLabel,
            image = autoImage
        }
        getOrLoadSprayTexture(autoImage)
    end

    isUiOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openSpraySelector',
        designs = designs
    })
end

-- Find Nearest Wall Spray & Scrub It Off
function removeNearestWallSpray()
    if isUiOpen or isPlacingStash or isAimingSpray or isDrawingPoly then return end

    local pData = QBX.PlayerData
    if not pData or not pData.gang or pData.gang.name == 'none' then
        return lib.notify({ title = 'Spray Remover', description = 'Only gang members can scrub gang tags!', type = 'error' })
    end

    local removerItem = Config.SprayRemoverItem or 'sprayremover'
    if not hasItemClient(removerItem) then
        return lib.notify({ title = 'Spray Remover', description = 'You need a Spray Remover kit!', type = 'error' })
    end

    local ped = cache.ped
    local pedCoords = GetEntityCoords(ped)
    local closestSpray = nil
    local closestDist = 3.5

    for i = 1, #ActiveSprays do
        local s = ActiveSprays[i]
        if s and s.coords then
            local dist = #(pedCoords - s.coords)
            if dist < closestDist then
                closestDist = dist
                closestSpray = s
            end
        end
    end

    if not closestSpray then
        return lib.notify({ title = 'Spray Remover', description = 'Stand closer to a wall spray to scrub it off.', type = 'error' })
    end

    TaskTurnPedToFaceCoord(ped, closestSpray.coords.x, closestSpray.coords.y, closestSpray.coords.z, 600)
    Wait(600)

    local completed = lib.progressBar({
        duration = Config.RemoveDuration or 6000,
        label = 'Scrubbing Off Graffiti...',
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true, combat = true },
        anim = {
            dict = 'timetable@floyd@clean_kitchen@base',
            clip = 'base'
        },
        prop = {
            model = `prop_sponge_01`,
            bone = 28422,
            pos = vec3(0.0, 0.0, -0.01),
            rot = vec3(90.0, 0.0, 0.0)
        }
    })

    if completed then
        TriggerServerEvent('tb-gangs:server:playerRemoveSpray', closestSpray.id)
    else
        lib.notify({ title = 'Spray Remover', description = 'Stopped scrubbing.', type = 'error' })
    end
end

exports('useSprayCan', function()
    openSpraySelectorMenu()
end)

exports('useSprayRemover', function()
    removeNearestWallSpray()
end)

RegisterNetEvent('tb-gangs:client:useSprayCan', function()
    openSpraySelectorMenu()
end)

RegisterNetEvent('tb-gangs:client:useSprayRemover', function()
    removeNearestWallSpray()
end)

RegisterNetEvent('tb-gangs:client:addSpray', function(newSpray)
    ActiveSprays[#ActiveSprays + 1] = newSpray
end)

RegisterNetEvent('tb-gangs:client:syncSprays', function(sprays)
    ActiveSprays = sprays or {}
end)