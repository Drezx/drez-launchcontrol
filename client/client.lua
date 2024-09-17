function Main()
    local CAN_START_LC = false
    local CAN_BOOST = false
    AddBind("SPACE", function(IsPressed)
        local canStart, vehicle <const> = CanStartLaunchControl()
        if not canStart then
            return
        end

        CAN_START_LC = true
        local startOn <const> = GetGameTimer()

        while IsPressed() do
            Wait(0)

            if ((math.floor((GetGameTimer() - startOn) / 10) == (Config.LaunchTime / 10)) and not CAN_BOOST) then
                CAN_BOOST = true
            end

            if CAN_BOOST then
                SetVehicleCurrentRpm(vehicle, 0.65)
                SetVehicleBrakeLights(vehicle, true)
            end
        end

        SetVehicleBrakeLights(vehicle, false)

        CAN_START_LC = false
    end)

    AddBind("W", function(IsPressed)
        if not CAN_START_LC then
            return
        end

        local ped <const> = PlayerPedId()
        local vehicle <const> = GetVehiclePedIsIn(ped, false)

        while IsPressed() do
            Wait(100)

            if CAN_BOOST and not CAN_START_LC then
                SetLaunchControlActive(vehicle, true)

                CAN_BOOST = false
                CAN_START_LC = false

                Citizen.SetTimeout(Config.BoostDuration, function ()
                    if IsVehicleBoostActive() then
                        SetLaunchControlActive(vehicle, false)
                    end
                end)

            elseif not IsVehicleBoostActive() and not CAN_START_LC then
                break
            end
        end

        if IsVehicleBoostActive() then
            SetLaunchControlActive(vehicle, false)
        end
    end)
end


CreateThread(Init)