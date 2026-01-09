local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Combat = {}

function  Combat.NoDashCD()
    local Files = ReplicatedStorage:WaitForChild("Files")
    local Framework = require(Files:WaitForChild("Framework"))
    local TagHandler = Framework:GetModule("TagHandler")

    local IgnoredTags = {
        ["DashCD"] = true,
        ["NoSprint"] = true,
        ["SuperDashCD"] = true,
        ["Stunned"] = true
    }

    local OldAdd = TagHandler.Add

    TagHandler.Add = function(Character, TagName)
        if IgnoredTags[TagName] then
            warn("Blocked Cooldown: " .. tostring(TagName)) 
            return nil 
        end

        return OldAdd(Character, TagName)
    end

    repeat task.wait() until Framework.Modules.TagHandler
    local TagHandler = Framework.Modules.TagHandler

    local OldAdd = TagHandler.Add
    TagHandler.Add = function(Character, TagName)
        if TagName == "Stunned" or TagName == "Ragdolled" then
            warn("Blocked Stun!")
            return nil -- Do nothing
        end
        
        return OldAdd(Character, TagName)
    end

end

--[[ --- NO STUN
local Files = game:GetService("ReplicatedStorage"):WaitForChild("Files")
local Framework = require(Files:WaitForChild("Framework"))

-- Wait for the TagHandler to load
repeat task.wait() until Framework.Modules.TagHandler
local TagHandler = Framework.Modules.TagHandler

-- Save the original function
local OldAdd = TagHandler.Add

-- Overwrite it
TagHandler.Add = function(Character, TagName)
    if TagName == "Stunned" or TagName == "Ragdolled" then
        warn("Blocked Stun!")
        return nil -- Do nothing
    end
    
    return OldAdd(Character, TagName)
end

]]

--[[
-- 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Files = ReplicatedStorage:WaitForChild("Files")
local Framework = require(Files:WaitForChild("Framework"))
local TagHandler = Framework:GetModule("TagHandler")

-- 1. Save the original function so we don't break the whole game
local OldGet = TagHandler.Get

-- 2. Create the hook
local NewGet = hookfunction(TagHandler.Get, function(Character, TagList)
    
    -- Check if the game is checking for Dash-blocking tags
    -- We know from the script that DashStunList contains "DashCD"
    if type(TagList) == "table" and table.find(TagList, "DashCD") then
        
        -- Return false (meaning: We have NO tags, we are free to move!)
        return false 
    end

    -- For everything else (Health, Damage, etc.), run the original function
    return OldGet(Character, TagList)
end)
]]

--[[ -- NO WALL CD

local RunService = game:GetService("RunService")
local Framework = require(game:GetService("ReplicatedStorage").Files.Framework)
local MovementHandler = Framework:GetModule("MovementHandler")

-- Simple loop to clear memory of which walls you've climbed
RunService.Stepped:Connect(function()
    -- This table stores [Part] = os.clock()
    -- If we empty it, the game forgets you just climbed that wall
    if MovementHandler.WallJumpCooldowns then
        table.clear(MovementHandler.WallJumpCooldowns)
    end
end)
]]

return Combat