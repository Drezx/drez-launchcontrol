local LC_CACHE = {}

---@param vehicle integer
---@param state boolean
function SetLaunchControlActive(vehicle, state)
    if state then
        LC_CACHE.turbo = GetVehicleTurboPressure(vehicle)
        LC_CACHE.gravity = GetVehicleGravityAmount(vehicle)
    else
        if not next(LC_CACHE) then
            return
        end
    end

    SetVehicleGravityAmount(vehicle, state and (LC_CACHE.gravity + Config.BoostPower) or LC_CACHE.gravity)
    SetVehicleTurboPressure(vehicle, state and 100.0 or LC_CACHE.turbo)

    if state then
        AnimpostfxPlay('RaceTurbo')
        AnimpostfxPlay('RaceTurbo', 0, false)
        ShakeGameplayCam('SKY_DIVING_SHAKE', 0.15)
    else
        StopGameplayCamShaking(true)
        table.wipe(LC_CACHE)
    end

end

---@return boolean
function IsVehicleBoostActive()
    return next(LC_CACHE)
end

---@param ped integer
---@param vehicle integer
---@return boolean
function IsDriver(ped,  vehicle)
    return GetPedInVehicleSeat(vehicle, -1) == ped
end

---@return boolean, integer
---@diagnostic disable: missing-return-value
function CanStartLaunchControl()
    local ped <const> = PlayerPedId()

    if (not IsPedInAnyVehicle(ped, false)) then
        return false -- Not in vehicle
    end

    local vehicle <const> = GetVehiclePedIsIn(ped, false)
    
    if (not IsDriver(ped, vehicle)) then

        return false -- Player is not a driver
    end

    local class <const> = GetVehicleClass(vehicle)
    if (not Config.AllowVehicleClass[class]) then
        return false -- Vehicle class should not have launch control
    end

    local speed = GetEntitySpeed(vehicle)
    if (speed > 0) then
        return false -- Vehicle is moving
    end

    return true, vehicle
end