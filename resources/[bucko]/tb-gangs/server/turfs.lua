-- Helper: Calculate Center Point & Bounding Radius from Custom Polygon Points
function calculatePolygonCenterAndRadius(polyPoints)
    local sumX, sumY, sumZ = 0.0, 0.0, 0.0
    local count = #polyPoints
    for i = 1, count do
        sumX = sumX + tonumber(polyPoints[i].x)
        sumY = sumY + tonumber(polyPoints[i].y)
        sumZ = sumZ + tonumber(polyPoints[i].z)
    end
    local center = vec3((sumX / count) + 0.0, (sumY / count) + 0.0, (sumZ / count) + 0.0)
    local maxDist = 30.0
    for i = 1, count do
        local pt = vec3(tonumber(polyPoints[i].x) + 0.0, tonumber(polyPoints[i].y) + 0.0, tonumber(polyPoints[i].z) + 0.0)
        local d = #(center - pt)
        if d > maxDist then maxDist = d end
    end
    return center, (maxDist + 0.0)
end

-- Helper: Check if 3D Coords are inside a Territory (Supports Custom Polygon OR Radius)
function isPointInsideTurf(coords, turf)
    if turf.polyPoints and #turf.polyPoints >= 3 then
        local x, y = coords.x, coords.y
        local inside = false
        local pts = turf.polyPoints
        local j = #pts
        for i = 1, #pts do
            local xi, yi = tonumber(pts[i].x), tonumber(pts[i].y)
            local xj, yj = tonumber(pts[j].x), tonumber(pts[j].y)
            if ((yi > y) ~= (yj > y)) and (x < (xj - xi) * (y - yi) / ((yj - yi) + 0.00001) + xi) then
                inside = not inside
            end
            j = i
        end
        return inside
    end
    return #(coords - turf.coords) <= (turf.radius or 110.0)
end

-- Helper: Sync all Turf & Color states to clients
function syncTurfsToClients()
    GlobalState.tb_gang_turfs = Turfs
    GlobalState.tb_gang_colors = GangColors
    TriggerClientEvent('tb-gangs:client:updateBlips', -1, Turfs, GangColors)
end