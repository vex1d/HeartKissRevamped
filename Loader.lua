local OWNER = "vex1d"
local REPO = "HeartKissRevamped"
local BRANCH = "main"

local function gitRequire(path)
    local url = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s.lua", OWNER, REPO, BRANCH, path)

    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        warn("CRITICAL: Failed to load module: " .. path)
        print("URL Attempted: " .. url)
        return nil
    end
    
    local func, loadErr = loadstring(response)
    if not func then
        warn("SYNTAX ERROR in module: " .. path)
        warn(loadErr)
        return nil
    end

    local env = getfenv(func)
    env.script = script
    env.require = gitRequire
    setfenv(func, env)
    return func()
end

gitRequire("Main")