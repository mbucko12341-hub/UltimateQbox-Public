-- Render Any Custom Multi-Point Shape Smoothly on the Map
function refreshTurfBlips(turfData, colorData)
    for _, blips in pairs(TurfBlips) do
        if blips.areas then
            for _, b in ipairs(blips.areas) do
                if DoesBlipExist(b) then RemoveBlip(b) end
            end
        end
        if blips.radius and DoesBlipExist(blips.radius) then RemoveBlip(blips.radius) end
        if blips.center and DoesBlipExist(blips.center) then RemoveBlip(blips.center) end
    end
    TurfBlips = {}

    local turfs = turfData or GlobalState.tb_gang_turfs or {}
    local colors = colorData or GlobalState.tb_gang_colors or Config.GangColors

    for zoneId, turf in pairs(turfs) do
        if turf.coords then
            local owner = turf.owner or turf.defaultOwner or 'none'
            local color = tonumber(colors[owner] or Config.GangColors[owner] or 0) or 0

            local cx = tonumber(turf.coords.x) + 0.0
            local cy = tonumber(turf.coords.y) + 0.0
            local cz = tonumber(turf.coords.z) + 0.0

            local areaBlips = {}
            local pts = turf.polyPoints

            if pts and #pts >= 3 then
                -- 1. Find the longest edge of your custom shape
                local bestDx, bestDy, maxLen = 1.0, 0.0, 0.0
                for i = 1, #pts do
                    local p1 = pts[i]
                    local p2 = pts[(i % #pts) + 1]
                    local dx = tonumber(p2.x) - tonumber(p1.x)
                    local dy = tonumber(p2.y) - tonumber(p1.y)
                    local len = math.sqrt(dx * dx + dy * dy)
                    if len > maxLen then
                        maxLen = len
                        bestDx = dx
                        bestDy = dy
                    end
                end

                -- Lock axes to the EXACT integer degree used by SetBlipRotation (eliminates dotted seam lines)
                local rotDeg = math.floor(((math.deg(math.atan2(bestDy, bestDx)) + 360.0) % 360.0) + 0.5)
                local snappedRad = math.rad(rotDeg)
                local ux, uy = math.cos(snappedRad), math.sin(snappedRad)
                local vx, vy = -uy, ux

                local localPts = {}
                local minT, maxT = math.huge, -math.huge
                for i = 1, #pts do
                    local px = tonumber(pts[i].x) + 0.0
                    local py = tonumber(pts[i].y) + 0.0
                    local s = px * ux + py * uy
                    local t = px * vx + py * vy
                    localPts[i] = { s = s, t = t }
                    if t < minT then minT = t end
                    if t > maxT then maxT = t end
                end

                -- 2. High-resolution interior fill of the custom polygon
                local totalSpan = math.max(1.0, maxT - minT)
                local numSlices = math.min(65, math.max(1, math.floor(totalSpan / 2.2)))
                local sliceThickness = totalSpan / numSlices

                for slice = 0, numSlices - 1 do
                    local tMid = minT + (slice + 0.5) * sliceThickness
                    local nodes = {}
                    local j = #localPts

                    for i = 1, #localPts do
                        local ti, tj = localPts[i].t, localPts[j].t
                        local si, sj = localPts[i].s, localPts[j].s
                        if (ti < tMid and tj >= tMid) or (tj < tMid and ti >= tMid) then
                            nodes[#nodes + 1] = si + (tMid - ti) / (tj - ti) * (sj - si)
                        end
                        j = i
                    end

                    table.sort(nodes)

                    for k = 1, #nodes - 1, 2 do
                        local s1, s2 = nodes[k], nodes[k + 1]
                        local segLen = s2 - s1
                        if segLen > 0.5 then
                            local sMid = (s1 + s2) * 0.5
                            local wx = sMid * ux + tMid * vx
                            local wy = sMid * uy + tMid * vy

                            local fillBlip = AddBlipForArea(wx + 0.0, wy + 0.0, cz, segLen + 0.0, sliceThickness + 0.08)
                            SetBlipRotation(fillBlip, rotDeg)
                            SetBlipColour(fillBlip, color)
                            SetBlipAlpha(fillBlip, 125)
                            SetBlipAsShortRange(fillBlip, false)
                            areaBlips[#areaBlips + 1] = fillBlip
                        end
                    end
                end

                -- 3. Smooth Point-to-Point Outer Border
                for i = 1, #pts do
                    local p1 = pts[i]
                    local p2 = pts[(i % #pts) + 1]
                    local x1, y1 = tonumber(p1.x) + 0.0, tonumber(p1.y) + 0.0
                    local x2, y2 = tonumber(p2.x) + 0.0, tonumber(p2.y) + 0.0

                    local dx = x2 - x1
                    local dy = y2 - y1
                    local edgeLen = math.sqrt(dx * dx + dy * dy)

                    if edgeLen > 1.0 then
                        local midX = (x1 + x2) * 0.5
                        local midY = (y1 + y2) * 0.5
                        local edgeRot = math.floor(((math.deg(math.atan2(dy, dx)) + 360.0) % 360.0) + 0.5)

                        local borderBlip = AddBlipForArea(midX + 0.0, midY + 0.0, cz, edgeLen + 1.5, 3.2)
                        SetBlipRotation(borderBlip, edgeRot)
                        SetBlipColour(borderBlip, color)
                        SetBlipAlpha(borderBlip, 215)
                        SetBlipAsShortRange(borderBlip, false)
                        areaBlips[#areaBlips + 1] = borderBlip
                    end
                end
            else
                local radius = (tonumber(turf.radius) or 110.0) + 0.0
                local radiusBlip = AddBlipForRadius(cx, cy, cz, radius)
                SetBlipHighDetail(radiusBlip, true)
                SetBlipColour(radiusBlip, color)
                SetBlipAlpha(radiusBlip, 130)
                areaBlips[#areaBlips + 1] = radiusBlip
            end

            -- Center Gang Icon Blip
            local centerBlip = AddBlipForCoord(cx, cy, cz)
            SetBlipSprite(centerBlip, 378)
            SetBlipDisplay(centerBlip, 4)
            SetBlipScale(centerBlip, 0.85)
            SetBlipColour(centerBlip, color)
            SetBlipAsShortRange(centerBlip, false)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(('%s (%s)'):format(turf.label or zoneId, string.upper(owner)))
            EndTextCommandSetBlipName(centerBlip)

            TurfBlips[zoneId] = { areas = areaBlips, center = centerBlip }
        end
    end
end

-- Create Custom Polygon Zone (or Fallback Sphere) for a Territory
function registerZoneSphere(zoneId, turf)
    if not turf or not turf.coords then return end
    if ActivePolyZones[zoneId] then
        ActivePolyZones[zoneId]:remove()
    end

    local function handleEnter()
        currentZone = zoneId
        local turfs = GlobalState.tb_gang_turfs or {}
        local owner = (turfs[zoneId] and turfs[zoneId].owner) or turf.owner or 'none'
        local points = (turfs[zoneId] and turfs[zoneId].points) or 100

        local pData = QBX.PlayerData
        local myGang = pData and pData.gang and pData.gang.name or 'none'

        if myGang ~= 'none' then
            local isHostile = (owner ~= myGang and owner ~= 'none')
            SendNUIMessage({
                action = 'showTurfBanner',
                zoneLabel = turf.label,
                ownerGang = string.upper(owner),
                points = points,
                isHostile = isHostile,
                isOwn = (owner == myGang)
            })
            PlaySoundFrontend(-1, 'Boss_Message_Orange', 'GTAO_Boss_Goons_FM_Soundset', false)
        end
    end

    local function handleExit()
        if currentZone == zoneId then
            currentZone = nil
        end
    end

    if turf.polyPoints and #turf.polyPoints >= 3 then
        local formattedPoints = {}
        for i = 1, #turf.polyPoints do
            local p = turf.polyPoints[i]
            formattedPoints[#formattedPoints + 1] = vec3(p.x + 0.0, p.y + 0.0, p.z + 0.0)
        end

        ActivePolyZones[zoneId] = lib.zones.poly({
            points = formattedPoints,
            thickness = 80.0,
            debug = false,
            onEnter = handleEnter,
            onExit = handleExit
        })
    else
        ActivePolyZones[zoneId] = lib.zones.sphere({
            coords = vec3(turf.coords.x + 0.0, turf.coords.y + 0.0, turf.coords.z + 0.0),
            radius = (tonumber(turf.radius) or 110.0) + 0.0,
            debug = false,
            onEnter = handleEnter,
            onExit = handleExit
        })
    end
end

-- Helper: Compile Territory Data for NUI
function getFormattedTurfs()
    local turfs = GlobalState.tb_gang_turfs or {}
    local list = {}
    for zoneId, tData in pairs(turfs) do
        list[#list + 1] = {
            id = zoneId,
            label = tData.label,
            owner = string.upper(tData.owner or tData.defaultOwner or 'none'),
            points = tData.points or 100,
            isCurrent = (currentZone == zoneId)
        }
    end
    return list
end

RegisterNetEvent('tb-gangs:client:registerNewZone', function(zoneId, turf)
    registerZoneSphere(zoneId, turf)
end)

RegisterNetEvent('tb-gangs:client:removeZone', function(zoneId)
    if ActivePolyZones[zoneId] then
        ActivePolyZones[zoneId]:remove()
        ActivePolyZones[zoneId] = nil
    end
    if currentZone == zoneId then
        currentZone = nil
    end
    if TurfBlips[zoneId] then
        if TurfBlips[zoneId].areas then
            for _, b in ipairs(TurfBlips[zoneId].areas) do
                if DoesBlipExist(b) then RemoveBlip(b) end
            end
        end
        if TurfBlips[zoneId].radius and DoesBlipExist(TurfBlips[zoneId].radius) then
            RemoveBlip(TurfBlips[zoneId].radius)
        end
        if TurfBlips[zoneId].center and DoesBlipExist(TurfBlips[zoneId].center) then
            RemoveBlip(TurfBlips[zoneId].center)
        end
        TurfBlips[zoneId] = nil
    end
end)

RegisterNetEvent('tb-gangs:client:updateBlips', function(turfs, colors)
    refreshTurfBlips(turfs, colors)
end)