local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local lPlayer = Players.LocalPlayer
local Combat = {}

local Timings = require("GameUtils/DevilHunter/Timings/Timings")

Combat.ParryDistance = 10
Combat.ParryEnabled = false

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
                -- if wep == "Katana" then table.insert(Combat.KatanaSkills, skillName)
                -- elseif wep == "Fist" then table.insert(Combat.FistSkills, skillName)
                -- elseif wep == "Dagger" then table.insert(Combat.DaggerSkills, skillName)
                -- elseif wep == "FireArm" then table.insert(Combat.FireArmSkills, skillName)
                -- end
                if not table.find(Combat.KatanaSkills, skillName) then
                    table.insert(Combat.KatanaSkills, skillName)
                end

                if not table.find(Combat.FistSkills, skillName) then
                    table.insert(Combat.FistSkills, skillName)
                end

                if not table.find(Combat.DaggerSkills, skillName) then
                    table.insert(Combat.DaggerSkills, skillName)
                end

                if not table.find(Combat.FireArmSkills, skillName) then
                    table.insert(Combat.FireArmSkills, skillName)
                end

                if not table.find(Combat.MiscSkills, skillName) then
                    table.insert(Combat.MiscSkills, skillName)
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

local DashCon = nil
function Combat.NoDashCD(Toggle: boolean)
    local Files = ReplicatedStorage:WaitForChild("Files")
    local Framework = require(Files:WaitForChild("Framework"))
    local TagHandler = Framework:GetModule("TagHandler")
    local SkillLib = Framework:GetModule("SkillLibrary")
    local MovementHandler = Framework:GetModule("MovementHandler")

    local Character = lPlayer.Character
    if Toggle then
        DashCon = RunService.RenderStepped:Connect(function()
            
            if TagHandler.Get(Character, "DashCD") then
                TagHandler.Remove(Character, "DashCD")
            elseif TagHandler.Get(Character, "SuperDashCD") then
                TagHandler.Remove(Character, "SuperDashCD")
            end
        end)
    else
        if DashCon then
            DashCon:Disconnect()
            DashCon = nil
        end
    end
end

local WallJumpCon = nil
function Combat.NoWallJumpCD(Toggle: boolean)
    local RunService = game:GetService("RunService")
    local Framework = require(ReplicatedStorage.Files.Framework)
    local MovementHandler = Framework:GetModule("MovementHandler")

    if Toggle then
        WallJumpCon = RunService.RenderStepped:Connect(function()
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

local Connections = {}
local AnimationCache = {} 
local ParsedTimings = {}

local function GetInfo(id)
    if AnimationCache[id] then
        return AnimationCache[id]
    end

    local success, info = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(id, Enum.InfoType.Asset)
    end)

    if success and info then
        AnimationCache[id] = info.Name
        return info.Name
    else
        return "Unknown"
    end
end

local function Flatten(tbl)
    for key, value in tbl do
        if type(value) == "table" then
            if value.ID and value.Delay then
                ParsedTimings[value.ID] = value.Delay
            else
                Flatten(value)
            end
        end
    end
end

Flatten(Timings)

function Combat.AutoParry(Enabled: boolean)
    Combat.ParryEnabled = Enabled

    local Character = lPlayer.Character
    local Entities = workspace.World.Entities
    
    local Skills = ReplicatedStorage.Files.Modules.Shared.Encyclopedia.Skills
    local WeaponLibrary = require(ReplicatedStorage.Files.Modules.Libraries.WeaponLibrary)
    local DefaultData = WeaponLibrary.DefaultData

    local function ConnectEntity(entity)
        if entity == Character or Connections[entity] then return end

        local humanoid = entity:WaitForChild("Humanoid", 5)
        local animator = humanoid and humanoid:WaitForChild("Animator", 5)
        local rootPart = entity:WaitForChild("HumanoidRootPart", 5)
        
        if not humanoid or not animator or not rootPart then return end

        local connection = animator.AnimationPlayed:Connect(function(track)
            if not Combat.ParryEnabled then return end
            
            if humanoid.Health <= 0 then return end
            local distance = (rootPart.Position - Character.HumanoidRootPart.Position).Magnitude

            if distance > Combat.ParryDistance then return end

            local Info = entity:FindFirstChild("Info")
            -- local WeaponType = Info and Info:FindFirstChild("WeaponType")
            
            -- if not WeaponType then return end
            
            -- local WeaponInfo = DefaultData[WeaponType.Value]
            -- if not WeaponInfo then return end

            local id = tonumber(track.Animation.AnimationId:match("%d+"))
            if not id then return end

            local manualDelay = ParsedTimings[id]
            
            if manualDelay then
                task.delay(manualDelay, function()
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                    task.wait()
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                end)
            else

            end
        end)

        Connections[entity] = connection
        humanoid.Died:Connect(function()
            if Connections[entity] then
                Connections[entity]:Disconnect()
                Connections[entity] = nil
            end
        end)
    end

    if Enabled then
        for _, entity in Entities:GetChildren() do
            task.spawn(ConnectEntity, entity)
        end
        
        Connections["ChildAdded"] = Entities.ChildAdded:Connect(ConnectEntity)
    else
        for _, conn in Connections do
            conn:Disconnect()
        end
        table.clear(Connections)
    end
end


return Combat