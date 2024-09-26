function Init()
    Wait(2500)
    
    if (GetResourceState("drez-keybinds") == "missing") then
        for i=1, 10 do
            Wait(500)
            print("^1[WARNING]^0 Resource is missing required script to run, download keybinds here: ^5https://github.com/Drezx/drez-keybinds^0")
        end

        return
    end

    while (GetResourceState("drez-keybinds") ~= "started") do
        Wait(500)
    end

    load(exports['drez-keybinds']:Init(), "keybinds")()

    Main()
end
