local Lib = require("Library/UILib")
local Services = require("Utils/Services")
local PlaceIds = require("PlaceIds")

print(PlaceIds)

local currentGame = PlaceIds[game.PlaceId]
if currentGame then
    require("Games/" .. currentGame)
else
    warn("Unrecognized PlaceId: " .. tostring(game.PlaceId))
end

