function PlayerObject(data)
    local player = {}

    player.source     = data.source
    player.identifier = data.identifier
    player.skin       = data.skin or {}
    player.metadata   = data.metadata or {}
    player.job        = nil
    player.activeJob  = (Config.JobSettings.KeepActiveJob and data.activeJob or nil)
    player.jobs       = data.jobs or {}
    player.licenses   = data.licenses or {}
    player.groups     = data.groups or {}
    player.accounts   = data.accounts or {}
    player.inventory  = data.inventory or {}
    player.firstJoin  = data.firstJoin

    -- Identifier
    
    player.GetIdentifier = function(key)
        return RPX.GetPlayerIdentifier(player.source, key)
    end

    -- Skin

    player.SetSkin = function(skin)
        player.skin = skin
    end

    -- Metadata
    
    player.SetMetadata = function(key, value)
        player.metadata[key] = value
    end 

    -- Jobs

    player.HasJob = function(name)
        for k,v in pairs(player.jobs) do 
            if k == name then 
                return true
            end
        end 
        return false
    end
    
    player.SetJobActive = function(name) 
        player.activeJob = name or "unemployed"
        if player.activeJob ~= "unemployed" then 
            local cfg = registeredJobs[player.activeJob]
            if not cfg then 
                return false 
            end
            local rankCfg = cfg.ranks[player.jobs[player.activeJob].rank]
            if not rankCfg then 
                return false
            end
            player.job = {
                name = player.activeJob,
                label = cfg.label,
                rank = player.jobs[player.activeJob].rank,
                rank_label = rankCfg.label,
                metadata = player.jobs[player.activeJob].metadata
            }
        else
            local cfg = registeredJobs["unemployed"]
            local rankCfg = cfg.ranks[1]
            player.job = {
                name = "unemployed",
                label = cfg.label,
                rank = 1,
                rank_label = rankCfg.label,
                metadata = {}
            }
        end
        return true 
    end

    player.SetJob = function(name, rank, metadata, onduty)
        if not name then return end
        local cfg = registeredJobs[name]
        if not cfg then 
            PrintConsole("You do not have the job \"" .. name .. "\" in the config.")
            return 
        end
        local newRank = nil
        if rank then 
            local rankCfg = cfg.ranks[rank]
            if not rankCfg then 
                PrintConsole("You do not have the rank \"" .. rank .. "\" in the job \"" .. name .. "\" in the config.")
            elseif not player.jobs[name] then
                newRank = rank
            else
                player.jobs[name].rank = rank
            end 
        end
        if not player.jobs[name] and newRank then 
            player.jobs[name] = {
                rank = newRank,
                metadata = {}
            }
        end
        if metadata then 
            player.jobs[name].metadata = metadata
        end
        if not onduty then return end
        player.SetJobActive(name)
    end
    
    player.RemoveJob = function(name)
        player.SetJobActive(nil)
        player.jobs[name] = nil
    end

    player.SetJobActive(player.activeJob)

    -- Licenses

    player.HasLicense = function(name) 
        for i=1, #player.licenses do 
            if name == player.licenses[i] then 
                return true 
            end
        end
        return false
    end
    
    player.SetLicense = function(name, bool)
        if bool and not player.HasLicense(name) then
            table.insert(player.licenses, name)
        elseif not bool then
            local licenses = {}
            for i=1, #player.licenses do
                if name ~= player.licenses[i] then 
                    table.insert(licenses, player.licenses[i])
                end
            end
            player.licenses = licenses
        end
    end

    -- Groups

    player.HasGroup = function(name) 
        for i=1, #player.groups do 
            if name == player.groups[i] then 
                return true 
            end
        end
        return false
    end
    
    player.SetGroup = function(name, bool)
        if bool and not player.HasGroup(name) then
            table.insert(player.groups, name)
        elseif not bool then
            local groups = {}
            for i=1, #player.groups do
                if name ~= player.groups[i] then 
                    table.insert(groups, player.groups[i])
                end
            end
            player.groups = groups
        end
    end
    
    -- Accounts

    player.GetMoney = function(name)
        if name == nil then return end
        return player.accounts[name] or 0
    end

    player.AddMoney = function(name, amount)
        if name == nil or amount == nil or amount < 0 then return end
        local money = player.GetMoney(name)
        player.accounts[name] = math.floor(money + amount)
        return player.accounts[name]
    end

    player.RemoveMoney = function(name, amount)
        if name == nil or amount == nil or amount < 0 then return end
        local money = player.GetMoney(name)
        player.accounts[name] = math.floor(money - amount)
        return player.accounts[name]
    end

    player.SetMoney = function(name, amount)    
        if name == nil or amount == nil then return end
        local money = player.GetMoney(name)
        player.accounts[name] = math.floor(amount)
        return player.accounts[name]
    end

    -- Inventory 

    player.SetPlayerInventory = function(inventory)
        player.inventory = inventory
    end

    player.AddItem = Inventory.AddItem
    player.RemoveItem = Inventory.RemoveItem
    player.Search = Inventory.Search

    return player
end