local tabletProp = nil
local garages = {}
local activePoints = {}

-- ==========================================
-- VEHICLE SPAWNING & STORING
-- ==========================================

local function SpawnVehicle(vehicleData, spawnCoords)
    local model = type(vehicleData.hash) == 'number' and vehicleData.hash or joaat(vehicleData.vehicle)
    
    lib.requestModel(model)
    local veh = CreateVehicle(model, spawnCoords.x, spawnCoords.y, spawnCoords.z, spawnCoords.h, true, false)
    
    local props = json.decode(vehicleData.mods)
    if props then
        lib.setVehicleProperties(veh, props)
    end
    
    SetEntityAsMissionEntity(veh, true, true)
    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
    SetVehicleEngineOn(veh, true, true, false)
    
    -- Give Keys (Qbox)
    exports.qbx_core:GiveKeys(vehicleData.plate, true)
    
    -- Tell server it's out
    TriggerServerEvent('bucko_garages:server:setVehicleOut', vehicleData.plate)
end

-- ==========================================
-- MARKER SYSTEM
-- ==========================================

local function refreshGaragePoints()
    for _, point in pairs(activePoints) do point:remove() end
    activePoints = {}

    for name, data in pairs(garages) do
        local point = lib.points.new({
            coords = vec3(data.coords.x, data.coords.y, data.coords.z),
            distance = 25,
            garageData = data
        })

        function point:nearby()
            local ped = PlayerPedId()
            local inVehicle = IsPedInAnyVehicle(ped, false)
            
            if inVehicle then
                DrawMarker(1, self.coords.x, self.coords.y, self.coords.z - 1.0, 0,0,0, 0,0,0, 3.0, 3.0, 0.5, 255, 50, 50, 100, false, false, 2, false, nil, nil, false)
            else
                DrawMarker(1, self.coords.x, self.coords.y, self.coords.z - 1.0, 0,0,0, 0,0,0, 1.5, 1.5, 0.5, 0, 255, 170, 150, false, false, 2, false, nil, nil, false)
            end

            if self.currentDistance < 2.0 then
                if not self.isInside then
                    self.isInside = true
                    if inVehicle then lib.showTextUI('[E] - Store Vehicle', {icon = 'square-parking'})
                    else lib.showTextUI('[E] - Open Garage', {icon = 'car'}) end
                end

                if IsControlJustReleased(0, 38) then
                    if inVehicle then
                        local veh = GetVehiclePedIsIn(ped, false)
                        local plate = GetVehicleNumberPlateText(veh):match("^%s*(.-)%s*$") -- Trim spaces
                        local props = lib.getVehicleProperties(veh)
                        
                        local success, msg = lib.callback.await('bucko_garages:server:storeVehicle', false, plate, self.garageData.name, props)
                        if success then
                            DeleteEntity(veh)
                            lib.notify({title = 'Stored', description = msg, type = 'success'})
                        else
                            lib.notify({title = 'Error', description = msg, type = 'error'})
                        end
                    else
                        -- Fetch vehicles and open UI
                        local myVehicles = lib.callback.await('bucko_garages:server:getPlayerVehicles', false, self.garageData.name)
                        SetNuiFocus(true, true)
                        SendNUIMessage({
                            action = "openPlayerGarage",
                            vehicles = myVehicles,
                            garageInfo = self.garageData
                        })
                    end
                end
            else
                if self.isInside then
                    self.isInside = false
                    lib.hideTextUI()
                end
            end
        end
        activePoints[name] = point
    end
end

CreateThread(function()
    garages = lib.callback.await('bucko_garages:server:getGarages', false)
    refreshGaragePoints()
end)

RegisterNetEvent('bucko_garages:client:syncGarages', function(newGarages)
    garages = newGarages
    refreshGaragePoints()
end)

-- ==========================================
-- ADMIN TABLET
-- ==========================================
local function doTabletAnimation()
    local ped = PlayerPedId()
    lib.requestAnimDict("amb@code_human_in_bus_passenger_idles@female@tablet@base")
    lib.requestModel("prop_cs_tablet")
    tabletProp = CreateObject(`prop_cs_tablet`, 0, 0, 0, true, true, true)
    AttachEntityToEntity(tabletProp, ped, GetPedBoneIndex(ped, 60309), 0.03, 0.002, -0.0, 10.0, 160.0, 0.0, true, true, false, true, 1, true)
    TaskPlayAnim(ped, "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
end

local function stopTabletAnimation()
    ClearPedTasks(PlayerPedId())
    if tabletProp then DeleteEntity(tabletProp); tabletProp = nil end
end

RegisterNetEvent('bucko_garages:client:openTablet', function()
    doTabletAnimation()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = "openAdminTablet" })
end)

RegisterNUICallback('submitNewGarage', function(data, cb)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local garageData = {
        name = data.name, label = data.label, type = data.type,
        coords = { x = pos.x, y = pos.y, z = pos.z, h = GetEntityHeading(ped) }
    }
    local success = lib.callback.await('bucko_garages:server:createGarage', false, garageData)
    if success then lib.notify({title = 'Success', description = 'Garage created!', type = 'success'}) end
    cb('ok')
end)

-- Handle NUI Spawning
RegisterNUICallback('spawnVehicle', function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeAll" })
    SpawnVehicle(data.vehicle, data.garageCoords)
    cb('ok')
end)

RegisterNUICallback('closeUI', function(_, cb)
    SetNuiFocus(false, false)
    stopTabletAnimation()
    cb('ok')
end)