local Services = require("Utils/Services")
local PlaceIds = require("PlaceIds")

if not game.Loaded then
    game.Loaded:Wait()
end

local function LoadGame()
    for gameName, ids in PlaceIds do
        for _, id in ids do
            if game.PlaceId == id then
                require("Games/" .. gameName)
            end
        end
    end
end

local success, info = pcall(LoadGame)
if not success then
    warn("CRITICAL: Failed to load game module.")
    warn(info)
end

