local Players = game:GetService("Players")
local Services = require("Utils/Services")
local PlaceIds = require("PlaceIds")

repeat task.wait() until Players.LocalPlayer ~= nil

local Version = "0.0.1"
warn("[HeartKiss Revamped] Loading... ", Version)

local function LoadGame()
    local found = false
    for gameName, ids in PlaceIds do
        if table.find(ids, game.PlaceId) then
            found = true
            local success, err = pcall(function()
                require("Games/" .. gameName)
            end)
            if not success then 
                warn("Error in Game Module: " .. err)
            end
            break 
        end
    end
    if not found then
        warn("Place ID " .. game.PlaceId .. " not supported.")
    end
end

local success, info = pcall(LoadGame)
if not success then
    warn("CRITICAL: Failed to load game module.")
    warn(info)
end

