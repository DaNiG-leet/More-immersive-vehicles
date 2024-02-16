local function checkVehicle(vehicle)
	return vehicle and not vehicle:isGoodCar() and not vehicle:isAlarmed()
end

local function doorCanBeOpened(part)
	return part:getInventoryItem() and checkVehicle(part:getVehicle()) and part:getDoor() and not part:getDoor():isOpen() and not part:getDoor():isLocked() and not part:getDoor():isLockBroken()
end

local function windowCanBeOpened(part)
	return part:getInventoryItem() and checkVehicle(part:getVehicle()) and part:getWindow() and part:getWindow():isOpenable() and not part:getWindow():isOpen() and part:getParent() and part:getParent():getDoor() and not part:getParent():getDoor():isLocked()
end

local function open(chance)
	return ZombRand(0,100) < chance
end

local old_Vehicles_Create_Door = Vehicles.Create.Door
function Vehicles.Create.Door(vehicle, part)
	old_Vehicles_Create_Door(vehicle, part)
	if doorCanBeOpened(part) and open(SandboxVars.DoorsReality.OpenedDoorChance) then
		part:getDoor():setOpen(true)
		vehicle:transmitPartDoor(part)
	end
end

local old_Vehicles_Create_TrunkDoor = Vehicles.Create.TrunkDoor
function Vehicles.Create.TrunkDoor(vehicle, part)
	old_Vehicles_Create_TrunkDoor(vehicle, part)
	if doorCanBeOpened(part) and open(SandboxVars.DoorsReality.OpenedTrunkDoorChance) then
		part:getDoor():setOpen(true)
		vehicle:transmitPartDoor(part)
	end
end

local old_Vehicles_Create_Window = Vehicles.Create.Window
function Vehicles.Create.Window(vehicle, part)
	old_Vehicles_Create_Window(vehicle, part)
	if windowCanBeOpened(part) and open(SandboxVars.DoorsReality.OpenedWindowChance) then
		part:getWindow():setOpen(true)
		vehicle:transmitPartWindow(part)
	end
end

--[[ I consider this functionality to be unnecessary

local old_Vehicles_Create_Default = Vehicles.Create.Default 
function Vehicles.Create.Default(vehicle, part)
	old_Vehicles_Create_Default(vehicle, part)
	if part:getId():contains('EngineDoor') and doorCanBeOpened(part) and open(SandboxVars.DoorsReality.OpenedEngineDoorChance) then
		local doorFrontLeft = vehicle:getPartById("DoorFrontLeft")
		if doorFrontLeft and doorFrontLeft:getDoor() and not doorFrontLeft:getDoor():isLocked() then
			print(vehicle:getScriptName() .. tostring(doorFrontLeft:getDoor():isLocked()))
			part:getDoor():setOpen(true)
			vehicle:transmitPartDoor(part)
		end
	end

	option DoorsReality.OpenedEngineDoorChance
	{
		type = integer, min = 0, max = 100, default = 25,
		page = DoorsReality, translation = OpenedEngineDoorChance,
	}


end]]