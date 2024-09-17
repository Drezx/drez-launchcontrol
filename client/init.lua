function Init()
    if GetResourceState("drez-keybinds") ~= "started" then
        for i=1, 10 do
            Wait(500)
            print("^1[WARNING]^0 Resource is missing required script to run, download keybinds here: ^5https://github.com/Drezx/drez-keybinds^0")
        end

        return
    end

    load(exports['drez-keybinds']:Init(), "keybinds")()

    Main()
end
