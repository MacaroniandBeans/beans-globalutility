local Cooldown = false
local Duration = 0

lib.callback.register("beans-globalutility:server:GlobalCooldown", function(source)
    return Duration == 0 or (os.time() - Duration) > 0
end)

lib.callback.register("beans-globalutility:server:CheckOnCooldown", function(source)
    return Cooldown
end)

RegisterNetEvent("beans-globalutility:server:GlobalCooldown", function()
    Cooldown = true
    Duration = os.time() + (Config.CooldownTime * 60)

    if Config.BeansScoreboard then
        local listenLabels = {}
        for _, entry in ipairs(Config.PoliceRequirements) do
            if entry.listen then
                table.insert(listenLabels, entry.label)
            end
        end

        if #listenLabels > 0 then
            TriggerClientEvent("beans-scoreboard:client:setRed", -1, listenLabels)

            -- Start cooldown timer
            CreateThread(function()
                Wait(Config.CooldownTime * 60 * 1000)
                Cooldown = false
                TriggerClientEvent("beans-scoreboard:client:clearRed", -1, listenLabels)
            end)
        end
    end
end)

RegisterNetEvent("beans-globalutility:server:OnCooldown", function(bool)
    Cooldown = bool
end)


exports('TriggerCooldown', function()
    TriggerEvent("beans-globalutility:server:GlobalCooldown")
end)