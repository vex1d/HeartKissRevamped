local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HitboxModule = require(ReplicatedStorage.Modules.HitboxHandler)
local ball = workspace.Temp:FindFirstChild("Ball")

local oldCreate = HitboxModule.Create
HitboxModule.Create = function(p1, p2)
    -- Instead of doing math, just find the ball and return it
    local ball = workspace.Temp:FindFirstChild("Ball")
    if ball then
        return ball -- The script now thinks the ball is ALWAYS inside the hitbox
    end
    return oldCreate(p1, p2) -- Fallback to original to prevent crashes
end