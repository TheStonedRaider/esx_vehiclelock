ESX               = nil
local playerCars = {}

Citizen.CreateThread(function()

		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
end)
--Citizen.CreateThread(function()
--    while ESX == nil do
--        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
--       Citizen.Wait(2000)
--    end
--
--    while ESX.GetPlayerData().job == nil do
--       Citizen.Wait(100)
--    end
--
--    PlayerLoaded = true
--    PlayerData = ESX.GetPlayerData()
--
--end)
-- 
function OpenCloseVehicle()

        local _source = source
        local PlayerData = ESX.GetPlayerData(_source)

	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)
                local pos = GetEntityCoords(PlayerPedId(), true)
                local targetPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.0, 6.0, -4.0)
                local rayCast = StartShapeTestCapsule(pos.x, pos.y, pos.z, targetPos.x, targetPos.y, targetPos.z, 2, 10, PlayerPedId(), 7)
                local _,hit,_,_,vehicle = GetShapeTestResult(rayCast)
                if hit and DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
                    currentSelection = vehicle
end

	ESX.TriggerServerCallback('esx_vehiclelock:requestPlayerCars', function(isOwnedVehicle, job)
		if isOwnedVehicle or PlayerData.job ~= nil and PlayerData.job.name == 'police' then
			local locked = GetVehicleDoorLockStatus(vehicle)
			if locked == 1 then -- if unlocked
				SetVehicleDoorsLocked(vehicle, 2)
				PlayVehicleDoorCloseSound(vehicle, 1)
				ESX.ShowNotification("You have ~r~Locked~s~ the Vehicle.")
                  sendNotification('You have Locked the Vehicle', 'error', 2000)
			elseif locked == 2 then -- if locked
				SetVehicleDoorsLocked(vehicle, 1)
				PlayVehicleDoorOpenSound(vehicle, 0)
				ESX.ShowNotification("You Have ~g~opened~s~ the Vehicle.")
             	  sendNotification('You Have opened the Vehicle', 'success', 2000)
			end

		else

			ESX.ShowNotification("~r~You do not own this vehicle.")
		end
	end, GetVehicleNumberPlateText(vehicle))
end


function OpenCloseVehicle2()
        local _source = source
        local PlayerData = ESX.GetPlayerData(_source)

	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)
	local vehicle = GetVehiclePedIsIn(playerPed, false)
                if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
                    currentSelection = vehicle
end

	ESX.TriggerServerCallback('esx_vehiclelock:requestPlayerCars', function(isOwnedVehicle, job)
		if isOwnedVehicle or PlayerData.job ~= nil and PlayerData.job.name == 'police' then

			local locked = GetVehicleDoorLockStatus(vehicle)
			if locked == 1 then -- if unlocked
				SetVehicleDoorsLocked(vehicle, 2)
				PlayVehicleDoorCloseSound(vehicle, 1)
				ESX.ShowNotification("You have ~r~Locked~s~ the Vehicle.")
              	sendNotification('You have Locked the Vehicle', 'error', 2000)
			elseif locked == 2 then -- if locked
				SetVehicleDoorsLocked(vehicle, 1)
				PlayVehicleDoorOpenSound(vehicle, 0)
				ESX.ShowNotification("You Have ~g~opened~s~ the Vehicle.")
           	sendNotification('You Have opened the Vehicle', 'success', 2000)
			end

		else

			ESX.ShowNotification("~r~You do not own this vehicle.")
		end
	end, GetVehicleNumberPlateText(vehicle))
end

Citizen.CreateThread(function()
	while true do
		Wait(10)
		if IsControlJustReleased(1, 175) then
			OpenCloseVehicle()
			OpenCloseVehicle2()
		end
	end
end)

--notification
function sendNotification(message, messageType, messageTimeout)
	TriggerEvent("pNotify:SendNotification", {
		text = message,
		type = messageType,
		queue = "lock",
		theme = "gta",
		timeout = messageTimeout,
		layout = "bottomCenter"
	})
end
