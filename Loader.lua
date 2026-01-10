local OWNER = "vex1d"
local REPO = "HeartKissRevamped"
local BRANCH = "main"

local originalRequire = require 

local function gitRequire(path)
    if typeof(path) == "Instance" then
        return originalRequire(path)
    end

    local url = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s.lua?t=%d", OWNER, REPO, BRANCH, tostring(path), os.time())
    
    local success, response = pcall(function()
        return game:HttpGet(url, true)
    end)
    
    if not success then
        warn("CRITICAL: Failed to load module: " .. tostring(path))
        warn("URL attempted: " .. url)
        return nil
    end
    
    local func, loadErr = loadstring(response)
    if not func then
        warn("SYNTAX ERROR in module: " .. tostring(path))
        warn(loadErr)
        return nil
    end

    local env = getfenv(func)
    env.script = script
    env.require = gitRequire
    setfenv(func, env)
    
    return func()
end

print("-------------------------------------------------")
print("Loading Fresh Version at: " .. os.date("%X"))
print("-------------------------------------------------")

gitRequire("Main")