-- Draw 3D Laser Wall Between Two Polygon Points
local function draw3DWall(p1, p2, height, r, g, b, a)
    local t1 = vec3(p1.x, p1.y, p1.z + height)
    local t2 = vec3(p2.x, p2.y, p2.z + height)
    DrawPoly(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z, t2.x, t2.y, t2.z, r, g, b, a)
    DrawPoly(p1.x, p1.y, p1.z, t2.x, t2.y, t2.z, t1.x, t1.y, t1.z, r, g, b, a)
    DrawPoly(t2.x, t2.y, t2.z, p2.x, p2.y, p2.z, p1.x, p1.y, p1.z, r, g, b, a)
    DrawPoly(t1.x, t1.y, t1.z, t2.x, t2.y, t2.z, p1.x, p1.y, p1.z, r, g, b, a)
    DrawLine(p1.x, p1.y, p1.z + 0.1, p2.x, p2.y, p2.z + 0.1, 255, 255, 255, 255)
    DrawLine(t1.x, t1.y, t1.z, t2.x, t2.y, t2.z, 255, 255, 255, 255)
    DrawLine(p1.x, p1.y, p1.z, t1.x, t1.y, t1.z, 255, 255, 255, 255)
end

-- Overhead Mouse-Controlled Point-by-Point Custom Polygon Creator
local function startPolygonZoneCreator(onConfirm)
    if isDrawingPoly then return end
    isDrawingPoly = true

    local points = {}
    local ped = cache.ped
    local startCoords = GetEntityCoords(ped)
    local cursor = vec3(startCoords.x, startCoords.y, startCoords.z)
    local camHeight = 95.0

    local skyCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', cursor.x, cursor.y, cursor.z + camHeight, -89.0, 0.0, 0.0, 70.0, false, 0)
    SetCamActive(skyCam, true)
    RenderScriptCams(true, true, 500, true, true)
    FreezeEntityPosition(ped, true)

    local function updateCreatorUI()
        lib.showTextUI(('[Mouse / WASD] Move  |  [Left Click / E] Add Point (%s)  |  [Right Click / G] Undo  |  [Scroll] Zoom  |  [ENTER] Save  |  [BACKSPACE] Cancel'):format(#points), {
            position = 'top-center',
            icon = 'draw-polygon'
        })
    end

    local function cleanupCam()
        isDrawingPoly = false
        lib.hideTextUI()
        FreezeEntityPosition(ped, false)
        RenderScriptCams(false, true, 500, true, true)
        if DoesCamExist(skyCam) then
            DestroyCam(skyCam, false)
        end
    end

    updateCreatorUI()

    CreateThread(function()
        while isDrawingPoly do
            Wait(0)
            DisableAllControlActions(0)

            local speedMult = IsDisabledControlPressed(0, 21) and 3.0 or 1.0

            -- 1. [Mouse Movement] Glide cursor smoothly with mouse
            local mouseX = GetDisabledControlNormal(0, 1)
            local mouseY = GetDisabledControlNormal(0, 2)
            local mouseSensitivity = (camHeight / 18.0) * speedMult

            if math.abs(mouseX) > 0.001 or math.abs(mouseY) > 0.001 then
                cursor = vec3(
                    cursor.x + (mouseX * mouseSensitivity),
                    cursor.y - (mouseY * mouseSensitivity),
                    cursor.z
                )
            end

            -- 2. [WASD] Optional keyboard movement
            local keyStep = 0.75 * speedMult
            if IsDisabledControlPressed(0, 32) then cursor = vec3(cursor.x, cursor.y + keyStep, cursor.z) end
            if IsDisabledControlPressed(0, 33) then cursor = vec3(cursor.x, cursor.y - keyStep, cursor.z) end
            if IsDisabledControlPressed(0, 34) then cursor = vec3(cursor.x - keyStep, cursor.y, cursor.z) end
            if IsDisabledControlPressed(0, 35) then cursor = vec3(cursor.x + keyStep, cursor.y, cursor.z) end

            -- 3. [Scroll Wheel] Zoom Camera In / Out
            if IsDisabledControlPressed(0, 15) then
                camHeight = math.max(25.0, camHeight - 4.5)
            elseif IsDisabledControlPressed(0, 14) then
                camHeight = math.min(260.0, camHeight + 4.5)
            end

            local foundZ, groundZ = GetGroundZFor_3dCoord(cursor.x, cursor.y, cursor.z + 150.0, false)
            if foundZ then
                cursor = vec3(cursor.x, cursor.y, groundZ)
            end
            SetCamCoord(skyCam, cursor.x, cursor.y, cursor.z + camHeight)

            -- Draw Ground Aiming Cursor
            DrawMarker(28, cursor.x, cursor.y, cursor.z + 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.1, 1.1, 1.1, 168, 85, 247, 230, false, false, 2, false, nil, nil, false)

            -- Draw All Placed Polygon Points & 3D Connecting Walls
            for i = 1, #points do
                local pt = points[i]
                DrawMarker(1, pt.x, pt.y, pt.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.2, 1.2, 10.0, 168, 85, 247, 220, false, false, 2, false, nil, nil, false)

                if i < #points then
                    draw3DWall(points[i], points[i + 1], 10.0, 168, 85, 247, 110)
                end
            end

            if #points >= 1 then
                draw3DWall(points[#points], cursor, 10.0, 56, 189, 248, 95)
            end
            if #points >= 2 then
                draw3DWall(cursor, points[1], 10.0, 34, 197, 94, 75)
            end

            -- [Left Mouse Click] or [E] Drop Custom Corner Point
            if IsDisabledControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 38) then
                points[#points + 1] = { x = cursor.x, y = cursor.y, z = cursor.z }
                PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
                updateCreatorUI()
            end

            -- [Right Mouse Click] or [G] Undo Last Point
            if (IsDisabledControlJustReleased(0, 25) or IsDisabledControlJustReleased(0, 47)) and #points > 0 then
                table.remove(points, #points)
                PlaySoundFrontend(-1, 'BACK', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
                updateCreatorUI()
            end

            -- [ENTER] Confirm & Save Custom Polygon
            if IsDisabledControlJustReleased(0, 191) then
                if #points < 3 then
                    lib.notify({ title = 'Zone Creator', description = 'Place at least 3 corner points to create a custom shape!', type = 'error' })
                else
                    cleanupCam()
                    PlaySoundFrontend(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
                    onConfirm(points)
                end
            end

            -- [BACKSPACE] Cancel
            if IsDisabledControlJustReleased(0, 177) then
                cleanupCam()
                lib.notify({ title = 'Zone Creator', description = 'Zone creation cancelled.', type = 'inform' })
            end
        end
    end)
end

-- ADMIN CREATOR & DELETION MENU (/gangadmin)
RegisterNetEvent('tb-gangs:client:openAdminMenu', function(gangList, turfList)
    local myServerId = GetPlayerServerId(PlayerId())
    local blipColors = {
        { value = 1, label = 'Red (1)' },
        { value = 2, label = 'Green (2)' },
        { value = 3, label = 'Blue (3)' },
        { value = 5, label = 'Yellow (5)' },
        { value = 27, label = 'Purple (27)' },
        { value = 46, label = 'Gold (46)' },
        { value = 47, label = 'Orange (47)' },
        { value = 8, label = 'Pink (8)' },
        { value = 40, label = 'Dark Grey (40)' }
    }

    lib.registerContext({
        id = 'tb_gang_admin_menu',
        title = 'TB-Gangs Admin Management',
        options = {
            {
                title = 'Create Brand New Gang',
                description = 'Register a new gang, ranks, map color, and draw its custom compound zone',
                icon = 'fa-solid fa-plus-circle',
                onSelect = function()
                    local input = lib.inputDialog('Create New Gang', {
                        { type = 'input', label = 'Gang ID (lowercase, no spaces)', placeholder = 'crips', required = true },
                        { type = 'input', label = 'Gang Display Label', placeholder = 'Westside Crips', required = true },
                        { type = 'select', label = 'Map Blip Color', options = blipColors, default = 3, required = true },
                        { type = 'input', label = 'Rank 0 Name', default = 'Recruit', required = true },
                        { type = 'input', label = 'Rank 1 Name', default = 'Enforcer', required = true },
                        { type = 'input', label = 'Rank 2 Name (Co-Leader)', default = 'Underboss', required = true },
                        { type = 'input', label = 'Rank 3 Name (Boss / Leader)', default = 'Shot Caller', required = true },
                        { type = 'checkbox', label = 'Draw Custom Compound Zone With Points Now?', checked = true },
                        { type = 'input', label = 'Compound Label (if checked)', placeholder = 'Westside Compound' },
                        { type = 'number', label = 'Assign Leader Server ID', default = myServerId }
                    })

                    if input then
                        if input[8] then
                            lib.notify({ title = 'Zone Creator', description = 'Use your mouse & Left-Click to place corner points!', type = 'inform' })
                            startPolygonZoneCreator(function(polyPoints)
                                TriggerServerEvent('tb-gangs:server:adminCreateGang', {
                                    gangId = input[1],
                                    gangLabel = input[2],
                                    blipColor = input[3],
                                    grade0 = input[4],
                                    grade1 = input[5],
                                    grade2 = input[6],
                                    grade3 = input[7],
                                    createCompound = true,
                                    compoundLabel = input[9],
                                    polyPoints = polyPoints,
                                    leaderId = input[10]
                                })
                            end)
                        else
                            TriggerServerEvent('tb-gangs:server:adminCreateGang', {
                                gangId = input[1],
                                gangLabel = input[2],
                                blipColor = input[3],
                                grade0 = input[4],
                                grade1 = input[5],
                                grade2 = input[6],
                                grade3 = input[7],
                                createCompound = false,
                                leaderId = input[10]
                            })
                        end
                    end
                end
            },
            {
                title = 'Create New Territory (Draw Custom Points)',
                description = 'Draw a custom polygon turf zone point-by-point and display it on the map',
                icon = 'fa-solid fa-draw-polygon',
                onSelect = function()
                    local ownerOpts = { { value = 'none', label = 'Unclaimed (None)' } }
                    for _, g in ipairs(gangList) do ownerOpts[#ownerOpts + 1] = g end

                    local input = lib.inputDialog('Create Custom Polygon Territory', {
                        { type = 'input', label = 'Zone ID (lowercase)', placeholder = 'docks_turf', required = true },
                        { type = 'input', label = 'Zone Display Name', placeholder = 'Elysian Docks Territory', required = true },
                        { type = 'select', label = 'Initial Gang Owner', options = ownerOpts, default = 'none', required = true }
                    })

                    if input then
                        lib.notify({ title = 'Zone Creator', description = 'Use your mouse & Left-Click to place corner points. Press [ENTER] when done!', type = 'inform' })
                        startPolygonZoneCreator(function(polyPoints)
                            TriggerServerEvent('tb-gangs:server:adminCreateTurf', {
                                zoneId = input[1],
                                label = input[2],
                                owner = input[3],
                                polyPoints = polyPoints
                            })
                        end)
                    end
                end
            },
            {
                title = 'Set Player as Gang Leader',
                description = 'Appoint an online player as the Boss of any gang & give them a Gang Tablet',
                icon = 'fa-solid fa-crown',
                onSelect = function()
                    if #gangList == 0 then
                        return lib.notify({ title = 'Admin', description = 'No gangs available.', type = 'error' })
                    end
                    local input = lib.inputDialog('Appoint Gang Leader', {
                        { type = 'number', label = 'Player Server ID', default = myServerId, required = true, min = 1 },
                        { type = 'select', label = 'Select Gang', options = gangList, required = true }
                    })
                    if input then
                        TriggerServerEvent('tb-gangs:server:adminSetLeader', input[1], input[2])
                    end
                end
            },
            {
                title = 'Remove Nearest Wall Spray',
                description = 'Deletes the closest sprayed PNG tag within 10 meters',
                icon = 'fa-solid fa-eraser',
                iconColor = '#38bdf8',
                onSelect = function()
                    TriggerServerEvent('tb-gangs:server:adminClearNearestSpray')
                end
            },
            {
                title = 'Delete a Gang (& Stash / Markers)',
                description = 'Disband a gang, remove all members, delete its stash, sprays, and map blips',
                icon = 'fa-solid fa-trash-can',
                iconColor = '#ef4444',
                onSelect = function()
                    if #gangList == 0 then
                        return lib.notify({ title = 'Admin', description = 'No gangs available to delete.', type = 'error' })
                    end
                    local input = lib.inputDialog('Delete Gang', {
                        { type = 'select', label = 'Select Gang to Delete', options = gangList, required = true },
                        { type = 'checkbox', label = 'Also Delete All Map Markers / Territories Owned by This Gang?', checked = true }
                    })
                    if input and input[1] then
                        local confirm = lib.alertDialog({
                            header = 'Confirm Gang Deletion',
                            content = ('Are you sure you want to permanently delete **%s** and its stash?'):format(string.upper(input[1])),
                            centered = true,
                            cancel = true
                        })
                        if confirm == 'confirm' then
                            TriggerServerEvent('tb-gangs:server:adminDeleteGang', input[1], input[2])
                        end
                    end
                end
            },
            {
                title = 'Delete a Territory / Map Marker',
                description = 'Remove any specific gang territory zone and its map blip',
                icon = 'fa-solid fa-location-slash',
                iconColor = '#f97316',
                onSelect = function()
                    if not turfList or #turfList == 0 then
                        return lib.notify({ title = 'Admin', description = 'No territory markers exist on the map.', type = 'error' })
                    end
                    local input = lib.inputDialog('Delete Territory Marker', {
                        { type = 'select', label = 'Select Territory Zone to Delete', options = turfList, required = true }
                    })
                    if input and input[1] then
                        local confirm = lib.alertDialog({
                            header = 'Delete Map Marker',
                            content = ('Are you sure you want to remove **%s** from the map?'):format(input[1]),
                            centered = true,
                            cancel = true
                        })
                        if confirm == 'confirm' then
                            TriggerServerEvent('tb-gangs:server:adminDeleteTurf', input[1])
                        end
                    end
                end
            }
        }
    })
    lib.showContext('tb_gang_admin_menu')
end)