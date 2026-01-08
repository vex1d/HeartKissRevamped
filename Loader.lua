local repo = "https://raw.githubusercontent.com/StupidProAArsenal/AztubHub_OpenSource/main/"

getgenv().sharedRequire = function()
    if not path:find("%.lua") then path = path .. ".lua" end

    getgenv()._MODULES = getgenv()._MODULES or {}

   local success, content = pcall(game.HttpGet, game, repo .. path)
    if success then
        local func, err = loadstring(content)
        if func then
            local module = func()
            getgenv()._MODULES[path] = module
            return module
        else
            warn("Syntax error in " .. path .. ": " .. err)
        end
    else
        warn("Failed to download " .. path)
    end
end

sharedRequire("Main")