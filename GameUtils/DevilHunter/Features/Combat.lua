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
                if wep == "Katana" or wep == "Sword" or wep == "KatanaHybrid" then table.insert(Combat.KatanaSkills, skillName)
                elseif wep == "Fist" then table.insert(Combat.FistSkills, skillName)
                elseif wep == "Dagger" then table.insert(Combat.DaggerSkills, skillName)
                elseif wep == "FireArm" then table.insert(Combat.FireArmSkills, skillName)
                -- else 
                --     if not table.find(Combat.MiscSkills, skillName) then
                --         table.insert(Combat.MiscSkills, skillName)
                --     end

                --     if not table.find(Combat.KatanaSkills, skillName) then
                --         table.insert(Combat.KatanaSkills, skillName)
                --     end

                --     if not table.find(Combat.FistSkills, skillName) then
                --         table.insert(Combat.FistSkills, skillName)
                --     end

                --     if not table.find(Combat.DaggerSkills, skillName) then
                --         table.insert(Combat.DaggerSkills, skillName)
                --     end

                --     if not table.find(Combat.FireArmSkills, skillName) then
                --         table.insert(Combat.FireArmSkills, skillName)
                --     end
                end
            end

            if typeof(requiredWeapon) == "table" then
                for _, weapon in requiredWeapon do
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

local WallJumpCon = nil
function Combat.NoWallJumpCD(Toggle: boolean)
    local RunService = game:GetService("RunService")
    local Framework = require(ReplicatedStorage.Files.Framework)
    local MovementHandler = Framework:GetModule("MovementHandler")

    if Toggle then
        WallJumpCon =  RunService.Stepped:Connect(function()
            if MovementHandler.WallJumpCooldowns then
                table.clear(MovementHandler.WallJumpCooldowns)
            end
        end)
    else
        if WallJumpCon then
            WallJumpCon:Disconnect()
            WallJumpCon = nil
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

function Combat.ForceUseSkill(SkillName: string)
    local Files = ReplicatedStorage:WaitForChild("Files")
    local Framework = require(Files:WaitForChild("Framework"))
    local TagHandler = Framework:GetModule("TagHandler")
    local SkillLib = Framework:GetModule("SkillLibrary")

    -- print("Attempting to force skill: " .. SkillName)
    SkillLib.FireSkill(Framework, game.Players.LocalPlayer, SkillName, "Start", "Z")
end


local OldVerify = nil 
function Combat.BypassSkillRequirements(Toggle: boolean)
    local Files = ReplicatedStorage:WaitForChild("Files")
    local Framework = require(Files:WaitForChild("Framework"))
    local SkillLib = Framework:GetModule("SkillLibrary")

    if not OldVerify then
        OldVerify = SkillLib.VerifySkill
    end

    if Toggle then
        SkillLib.VerifySkill = function(...)
            local Args = {...}
            local ActionType = Args[4]
            
            if ActionType == "Start" then
                return true
            end
            
            return OldVerify(...)
        end
        print("Skill Requirements Bypassed: Active")
    else
        if OldVerify then
            SkillLib.VerifySkill = OldVerify
            print("Skill Requirements Bypassed: Disabled")
        end
    end
end

return Combat