local Players = game:GetService("Players")
local Services = require("Utils/Services")
local PlaceIds = require("PlaceIds")

repeat task.wait() until Players.LocalPlayer ~= nil

local Version = "0.0.1"
warn("[HeartKiss Revamped] Loading... ", Version)

local function LoadGame()
    for gameName, ids in PlaceIds do
        for _, id in ids do
            if game.PlaceId == id then
                require("Games/" .. gameName)
                -- print(gameName)
            else
                warn("Game not loaded: " .. gameName)    
            end
        end
    end
end

local success, info = pcall(LoadGame)
if not success then
    warn("CRITICAL: Failed to load game module.")
    warn(info)
end

