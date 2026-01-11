local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Misc = {}

function  Misc.Testing()
    local Files = ReplicatedStorage:WaitForChild("Files")
    local Modules = Files.Modules

    local Framework = require(Files.Framework)
    local TagHandler = require(Files.Modules.Shared.TagHandler)
    local ClientController = require(Modules.Client.ClientController)
    local MovementHandler = require(Modules.Client.ClientController.Handlers.MovementHandler)
    
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character
    local Listeners = nil

    -- MovementHandler.Dash(_, Framework, "Forward")

    print(Framework:GetModule("AI"))
end


return Misc