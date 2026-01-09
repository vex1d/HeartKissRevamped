local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lPlayer = Players.LocalPlayer

local Combat = {}

Combat.KatanaSkills = {}
Combat.FistSkills = {}
Combat.DaggerSkills = {}
Combat.FireArmSkills = {}
Combat.MiscSkills = {}

function Combat.GetWeaponType()
    local Character = lPlayer.Character or lPlayer.CharacterAdded:Wait()
    local Info = Character:WaitForChild("Info", 10)
    if Info then
        return Info:WaitForChild("WeaponType", 10)
    end
    return nil
end

function Combat.GetSkills()
    Combat.KatanaSkills = {}
    Combat.FistSkills = {}
    Combat.DaggerSkills = {}
    Combat.FireArmSkills = {}
    Combat.MiscSkills = {}

    local Skills = ReplicatedStorage.Files.Modules.Shared.Encyclopedia.Skills
    for _, v in Skills:GetChildren() do
        if v.Name == "Template" then continue end
        
        local skillName = string.split(v.Name, "_")[1]
        local skillData = require(v)
        local skillRequirements = skillData.skillRequirements
        local requiredWeapon = skillRequirements and skillRequirements.RequiredWeapon
        
        if requiredWeapon then
            local function sortSkill(wep)
                if wep == "Katana" then table.insert(Combat.KatanaSkills, skillName)
                elseif wep == "Fist" then table.insert(Combat.FistSkills, skillName)
                elseif wep == "Dagger" then table.insert(Combat.DaggerSkills, skillName)
                elseif wep == "FireArm" then table.insert(Combat.FireArmSkills, skillName)
                end
            end

            if typeof(requiredWeapon) == "table" then
                for _, weapon in ipairs(requiredWeapon) do
                    sortSkill(weapon)
                end
            else
                sortSkill(requiredWeapon)
            end
        else
            table.insert(Combat.MiscSkills, skillName)
        end
    end

    return {
        Katana = Combat.KatanaSkills,
        Fist = Combat.FistSkills,
        Dagger = Combat.DaggerSkills,
        FireArm = Combat.FireArmSkills,
        Misc = Combat.MiscSkills
    }
end

function Combat.GetCurrentSkillList(weponType: string)
    if weponType == "Katana" then return Combat.KatanaSkills
    elseif weponType == "Fist" then return Combat.FistSkills
    elseif weponType == "Dagger" then return Combat.DaggerSkills
    elseif weponType == "FireArm" then return Combat.FireArmSkills
    else return Combat.MiscSkills end
end

local OldTagHandlerAdd = nil
function Combat.NoDashCD(Toggle: boolean)
    local Files = ReplicatedStorage:WaitForChild("Files")
    local Framework = require(Files:WaitForChild("Framework"))
    local TagHandler = Framework:GetModule("TagHandler")
    local SkillLib = Framework:GetModule("SkillLibrary")
    local MovementHandler = Framework:GetModule("MovementHandler")

    if not OldTagHandlerAdd then
        OldTagHandlerAdd = TagHandler.Add
    end

    local IgnoredTags = {
        ["DashCD"] = true,
        ["NoSprint"] = true,
        ["SuperDashCD"] = true,
        ["Stunned"] = true,
        ["Knocked"] = true,
        ["ParryStunned"] = true,
        ["Ragdolled"] = true,
        ["Carried"] = true,
        ["PostureBroken"] = true,
        ["Mounted"] = true,
        ["Grabbed"] = true,
        ["Action"] = true,
        ["Skateboard"] = true
    }
    

    OldTagHandlerAdd = TagHandler.Add
   if Toggle then
        TagHandler.Add = function(Character, TagName)
            if IgnoredTags[TagName] then
                -- print("Blocked Tag: " .. tostring(TagName))
                return nil
            end

            return OldTagHandlerAdd(Character, TagName)
        end
    else
        if OldTagHandlerAdd then
            TagHandler.Add = OldTagHandlerAdd
        end
    end
end

function Combat.NoDashStun()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Files = ReplicatedStorage:WaitForChild("Files")
    local Framework = require(Files:WaitForChild("Framework"))
    local TagHandler = Framework:GetModule("TagHandler")

    local OldGet = TagHandler.Get

    local NewGet = hookfunction(TagHandler.Get, function(Character, TagList)
        if type(TagList) == "table" and table.find(TagList, "DashCD") then
            print("Blocked Dash!")
            return false 
        end

        -- print(TagList)

        return OldGet(Character, TagList)
    end)
end

function Combat.NoStun()
    local Files = game:GetService("ReplicatedStorage"):WaitForChild("Files")
    local Framework = require(Files:WaitForChild("Framework"))

    repeat task.wait() until Framework.Modules.TagHandler
    local TagHandler = Framework.Modules.TagHandler

    local OldAdd = TagHandler.Add

    TagHandler.Add = function(Character, TagName)
        if TagName == "Stunned" or TagName == "Ragdolled" then
            warn("Blocked Stun!")
            return nil
        end
        
        return OldAdd(Character, TagName)
    end
end

function  Combat.ForceUseSkill(SkillName: string)
    local Files = ReplicatedStorage:WaitForChild("Files")
    local Framework = require(Files:WaitForChild("Framework"))
    local TagHandler = Framework:GetModule("TagHandler")
    local SkillLib = Framework:GetModule("SkillLibrary")

    -- print("Attempting to force skill: " .. SkillName)
    SkillLib.FireSkill(Framework, game.Players.LocalPlayer, SkillName, "Start", "Z")
end

    -- local IgnoredTags = {
    --     ["DashCD"] = true,
    --     ["NoSprint"] = true,
    --     ["SuperDashCD"] = true,
    --     ["Stunned"] = true
    -- }

    -- local OldAdd = TagHandler.Add

    -- TagHandler.Add = function(Character, TagName)
    --     if IgnoredTags[TagName] then
    --         warn("Blocked Cooldown: " .. tostring(TagName)) 
    --         return nil 
    --     end

    --     return OldAdd(Character, TagName)
    -- end

    -- repeat task.wait() until Framework.Modules.TagHandler
    -- local TagHandler = Framework.Modules.TagHandler

    -- local OldAdd = TagHandler.Add
    -- TagHandler.Add = function(Character, TagName)
    --     if TagName == "Stunned" or TagName == "Ragdolled" then
    --         warn("Blocked Stun!")
    --         return nil -- Do nothing
    --     end
        
    --     return OldAdd(Character, TagName)
    -- end

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