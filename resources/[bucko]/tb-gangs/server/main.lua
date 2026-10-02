Stashes = {}
Turfs = {}
Sprays = {}
GangRep = {}
DeletedGangs = {}
GangColors = table.clone(Config.GangColors)
ZoneCooldowns = {}
AuthorizedAdmins = {}

-- Register Gang Tablet, Spray Can & Spray Remover as Useable Items in Qbox
CreateThread(function()
    Wait(200)
    pcall(function()
        exports.qbx_core:CreateUseableItem(Config.TabletItem or 'gangtablet', function(source)
            TriggerClientEvent('tb-gangs:client:openTablet', source)
        end)
        if Config.SprayItem then
            exports.qbx_core:CreateUseableItem(Config.SprayItem, function(source)
                TriggerClientEvent('tb-gangs:client:useSprayCan', source)
            end)
        end
        if Config.SprayRemoverItem then
            exports.qbx_core:CreateUseableItem(Config.SprayRemoverItem, function(source)
                TriggerClientEvent('tb-gangs:client:useSprayRemover', source)
            end)
        end
    end)
end)

-- Helper: Add Reputation Points to a Gang
function addGangRep(gang, amount)
    if not gang or gang == 'none' then return 0 end
    local current = GangRep[gang] or 0
    local updated = math.max(0, current + amount)
    GangRep[gang] = updated
    GlobalState.tb_gang_rep = GangRep

    MySQL.prepare.await([[
        INSERT INTO `tb_gang_rep` (gang, rep) VALUES (?, ?)
        ON DUPLICATE KEY UPDATE rep = VALUES(rep)
    ]], { gang, updated })

    return updated
end

-- Initialize Custom Gangs, Stashes, Turfs, Sprays, and Gang Rep on Startup
CreateThread(function()
    Wait(500)

    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `tb_gang_rep` (
            `gang` VARCHAR(50) NOT NULL PRIMARY KEY,
            `rep` INT(11) NOT NULL DEFAULT 0
        )
    ]])

    pcall(function()
        MySQL.query.await('ALTER TABLE `tb_gang_turfs` ADD COLUMN `poly_points` LONGTEXT DEFAULT NULL')
    end)

    -- 1. Load Custom Admin-Created Gangs
    local customGangs = MySQL.query.await('SELECT * FROM `tb_gang_custom`')
    if customGangs and #customGangs > 0 then
        local gangsToRegister = {}
        for _, row in ipairs(customGangs) do
            local decodedGrades = json.decode(row.grades) or {}
            local formattedGrades = {}
            for k, v in pairs(decodedGrades) do
                formattedGrades[tonumber(k)] = v
            end

            gangsToRegister[row.gang] = {
                label = row.label,
                grades = formattedGrades
            }
            GangColors[row.gang] = tonumber(row.color) or 1
        end
        pcall(function()
            exports.qbx_core:CreateGangs(gangsToRegister)
        end)
    end

    -- 2. Load Gang Rep
    local repRows = MySQL.query.await('SELECT * FROM `tb_gang_rep`')
    if repRows then
        for _, row in ipairs(repRows) do
            GangRep[row.gang] = tonumber(row.rep) or 0
        end
    end

    -- 3. Load Stashes
    local stashRows = MySQL.query.await('SELECT * FROM `tb_gang_stashes`')
    if stashRows then
        for _, row in ipairs(stashRows) do
            local c = json.decode(row.coords)
            if c then
                local vecCoords = vec3(c.x + 0.0, c.y + 0.0, c.z + 0.0)
                Stashes[row.gang] = {
                    coords = vecCoords,
                    heading = (tonumber(row.heading) or 0.0) + 0.0,
                    minGrade = tonumber(row.min_grade) or 0
                }
                registerGangStash(row.gang, vecCoords, Stashes[row.gang].minGrade)
            end
        end
    end

    -- 4. Load Turfs (With Custom Polygon Support)
    local turfRows = MySQL.query.await('SELECT * FROM `tb_gang_turfs`')
    if turfRows and #turfRows > 0 then
        for _, row in ipairs(turfRows) do
            local c = row.coords and json.decode(row.coords)
            local poly = row.poly_points and json.decode(row.poly_points) or nil
            if c and c.x then
                Turfs[row.zone_id] = {
                    label = row.label or row.zone_id,
                    coords = vec3(c.x + 0.0, c.y + 0.0, c.z + 0.0),
                    radius = (tonumber(row.radius) or 110.0) + 0.0,
                    polyPoints = poly,
                    owner = row.owner or 'none',
                    points = tonumber(row.points) or 100
                }
            end
        end
    else
        for zoneId, data in pairs(Config.Territories) do
            local owner = data.defaultOwner or 'none'
            local encodedCoords = json.encode({ x = data.coords.x, y = data.coords.y, z = data.coords.z })
            local radius = (tonumber(data.radius) or 110.0) + 0.0

            Turfs[zoneId] = {
                label = data.label,
                coords = vec3(data.coords.x + 0.0, data.coords.y + 0.0, data.coords.z + 0.0),
                radius = radius,
                polyPoints = nil,
                owner = owner,
                points = 100
            }

            MySQL.prepare.await([[
                INSERT INTO `tb_gang_turfs` (zone_id, label, coords, radius, owner, points)
                VALUES (?, ?, ?, ?, ?, 100)
            ]], { zoneId, data.label, encodedCoords, radius, owner })
        end
    end

    -- 5. Load Wall Sprays
    local sprayRows = MySQL.query.await('SELECT * FROM `tb_gang_sprays`')
    if sprayRows then
        for _, row in ipairs(sprayRows) do
            local c = json.decode(row.coords)
            local n = json.decode(row.normal)
            if c and n then
                Sprays[#Sprays + 1] = {
                    id = row.id,
                    gang = row.gang,
                    image = row.image,
                    coords = vec3(c.x + 0.0, c.y + 0.0, c.z + 0.0),
                    normal = vec3(n.x + 0.0, n.y + 0.0, n.z + 0.0),
                    size = (tonumber(row.size) or 1.8) + 0.0,
                    zoneId = row.zone_id
                }
            end
        end
    end

    GlobalState.tb_gang_stashes = Stashes
    GlobalState.tb_gang_turfs = Turfs
    GlobalState.tb_gang_colors = GangColors
    GlobalState.tb_gang_sprays = Sprays
    GlobalState.tb_gang_rep = GangRep
    TriggerClientEvent('tb-gangs:client:initAll', -1, Turfs, GangColors, Stashes, Sprays)
end)

-- Callback: Fetch Gang Members, Grades, Stash & Rep for NUI Tablet
lib.callback.register('tb-gangs:server:getGangData', function(source)
    local player = exports.qbx_core:GetPlayer(source)
    if not player or player.PlayerData.gang.name == 'none' then return nil end

    local gangName = player.PlayerData.gang.name
    local members = {}
    local players = exports.qbx_core:GetQBPlayers()

    for _, p in pairs(players) do
        if p.PlayerData.gang.name == gangName then
            members[#members + 1] = {
                source = p.PlayerData.source,
                citizenid = p.PlayerData.citizenid,
                name = p.PlayerData.charinfo.firstname .. ' ' .. p.PlayerData.charinfo.lastname,
                gradeName = p.PlayerData.gang.grade.name,
                gradeLevel = p.PlayerData.gang.grade.level
            }
        end
    end

    local gangs = exports.qbx_core:GetGangs()
    local grades = {}
    if gangs[gangName] and gangs[gangName].grades then
        for k, v in pairs(gangs[gangName].grades) do
            grades[#grades + 1] = {
                level = tonumber(k) or k,
                name = v.name
            }
        end
        table.sort(grades, function(a, b) return a.level < b.level end)
    end

    return {
        gang = player.PlayerData.gang,
        rep = GangRep[gangName] or 0,
        members = members,
        grades = grades,
        stash = Stashes[gangName] or nil
    }
end)

-- Event: Invite Player to Gang
RegisterNetEvent('tb-gangs:server:invitePlayer', function(targetId)
    local src = source
    local leader = exports.qbx_core:GetPlayer(src)
    local target = exports.qbx_core:GetPlayer(tonumber(targetId))

    if not leader or not leader.PlayerData.gang.isboss then return end
    if not target then
        return exports.qbx_core:Notify(src, 'Player not found.', 'error')
    end

    local leaderCoords = GetEntityCoords(GetPlayerPed(src))
    local targetCoords = GetEntityCoords(GetPlayerPed(tonumber(targetId)))
    if #(leaderCoords - targetCoords) > Config.MaxInviteDistance then
        return exports.qbx_core:Notify(src, 'Player is too far away.', 'error')
    end

    if target.PlayerData.gang.name ~= 'none' then
        return exports.qbx_core:Notify(src, 'Player is already in a gang.', 'error')
    end

    local accepted = lib.callback.await('tb-gangs:client:receiveInvite', tonumber(targetId), leader.PlayerData.gang.label)
    if accepted then
        target.Functions.SetGang(leader.PlayerData.gang.name, 0)
        exports.qbx_core:Notify(src, 'Player joined your gang!', 'success')
        exports.qbx_core:Notify(tonumber(targetId), 'You joined ' .. leader.PlayerData.gang.label, 'success')
    else
        exports.qbx_core:Notify(src, 'Player declined your gang invite.', 'error')
    end
end)

-- Event: Change Member Rank
RegisterNetEvent('tb-gangs:server:setMemberRank', function(targetSource, newGrade)
    local src = source
    local leader = exports.qbx_core:GetPlayer(src)
    local target = exports.qbx_core:GetPlayer(tonumber(targetSource))

    if not leader or not leader.PlayerData.gang.isboss then return end
    if not target or target.PlayerData.gang.name ~= leader.PlayerData.gang.name then return end

    target.Functions.SetGang(leader.PlayerData.gang.name, tonumber(newGrade) or 0)
    exports.qbx_core:Notify(src, 'Updated member rank.', 'success')
    exports.qbx_core:Notify(tonumber(targetSource), 'Your gang rank was updated to ' .. target.PlayerData.gang.grade.name, 'inform')
end)

-- Event: Kick Member from Gang
RegisterNetEvent('tb-gangs:server:kickMember', function(targetSource)
    local src = source
    local leader = exports.qbx_core:GetPlayer(src)
    local target = exports.qbx_core:GetPlayer(tonumber(targetSource))

    if not leader or not leader.PlayerData.gang.isboss then return end
    if not target or target.PlayerData.gang.name ~= leader.PlayerData.gang.name then return end
    if src == tonumber(targetSource) then
        return exports.qbx_core:Notify(src, 'You cannot kick yourself.', 'error')
    end

    target.Functions.SetGang('none', 0)
    exports.qbx_core:Notify(src, 'Member kicked from gang.', 'success')
    exports.qbx_core:Notify(tonumber(targetSource), 'You have been kicked from the gang.', 'error')
end)