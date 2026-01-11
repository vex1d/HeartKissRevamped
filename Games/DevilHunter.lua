local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local lPlayer = Players.LocalPlayer

local Lib = require("GUI/Library")
local PlayerUtils = require("Utils/PlayerUtils")

local ParryTimings = require("GameUtils/DevilHunter/Timings/Timings")
local AUTOFARM_CONFIG = require("GameUtils/DevilHunter/Configs/AutofarmConfig")
local MissionsModule = require("GameUtils/DevilHunter/Features/AutoMissions")
local RaidsModule = require("GameUtils/DevilHunter/Features/AutoRaids")
local CombatModule = require("GameUtils/DevilHunter/Features/Combat")

local window = Lib.new("HeartKiss", UDim2.fromScale(488, 518), Enum.KeyCode.RightControl)

local MainTab = window:Tab("Main")
local AutoFarm = window:Tab("AutoFarm")
local MiscTab = window:Tab("Misc")
local SettingsTab = window:Tab("Settings")
local ConfigsTab = window:Tab("Configs")

local AutofarmMissions = AutoFarm:Section("Missions")
local Raidfarm = AutoFarm:Section("Raids")

local AllSkills = CombatModule.GetSkills()
local KatanaSkills = AllSkills.Katana
local FistSkills = AllSkills.Fist
local DaggerSkills = AllSkills.Dagger
local FireArmSkills = AllSkills.FireArm
local MiscSkills = AllSkills.Misc

local SelectedSkills = {
    Slot1 = nil,
    Slot2 = nil,
    Slot3 = nil
}

--------------------------Player Tab--------------------------
local MainSection = MainTab:Section("Main")
local CombatSection = MainTab:Section("Combat")
local PlayerSection = MainTab:Section("Player")

local WalkSpeedEnabled = false
PlayerSection:ToggleInput("Toggle Walk Speed", false, Enum.KeyCode.Unknown, function(state)
    WalkSpeedEnabled = state
end)

local WalkSpeedCon
PlayerSection:Slider("Speed", 16, 150, 16, function(value)
    if not WalkSpeedEnabled then
        if WalkSpeedCon then
            WalkSpeedCon:Disconnect()
            WalkSpeedCon = nil
        end
        return
    end

    local humanoid = lPlayer.Character:WaitForChild("Humanoid")

    WalkSpeedCon = RunService.RenderStepped:Connect(function()
        humanoid.WalkSpeed = value
    end)
end)

local FlyEnabled = false
local FlySpeed = 16

PlayerSection:ToggleInput("Toggle Fly", false, Enum.KeyCode.Unknown, function(state)
    FlyEnabled = state
    PlayerUtils.Fly(state, FlySpeed)
end)

PlayerSection:Slider("Fly Speed", 16, 350, 16, function(value)
    FlySpeed = value
    
    if FlyEnabled then
        PlayerUtils.Fly(true, FlySpeed)
    end
end)

--------------------------Combat Tab--------------------------
CombatSection:Toggle("Auto Parry", function(state)
    CombatModule.AutoParry(state)
end)

CombatSection:Slider("Distance", 1, 150, 0, function(value)
    CombatModule.ParryDistance = value
end)

CombatSection:Toggle("No Dash CD", function(state)
    CombatModule.NoDashCD(state)
end)

CombatSection:Toggle("No WallJump CD", function(state)
    CombatModule.NoWallJumpCD(state)
end)

-- CombatSection:Toggle("Bypass Skill Requirements (buggy)", function(state)
--     CombatModule.BypassSkillRequirements(state)
-- end)

CombatSection:Toggle("Anti Grip Fling", function(state)
    CombatModule.AntiFling(state)
end)

CombatSection:Slider("Fling Power", 1, 500, 1, function(value)
    CombatModule.FlingPower = value
end)

local WeaponType = CombatModule.GetWeaponType()
local currentWeaponName = "None"
if WeaponType then
    currentWeaponName = WeaponType.Value
end
local activeSkills = CombatModule.GetCurrentSkillList()

local Slot1Dropdown = CombatSection:Dropdown("Skill Slot 1", MiscSkills, function(selected)
    SelectedSkills.Slot1 = selected
end)

local Slot2Dropdown = CombatSection:Dropdown("Skill Slot 2", MiscSkills, function(selected)
    SelectedSkills.Slot2 = selected
end)

local Slot3Dropdown = CombatSection:Dropdown("Skill Slot 3", MiscSkills, function(selected)
    SelectedSkills.Slot3 = selected
end)

local function UpdateSkillDropdowns()
    local wep = WeaponType and WeaponType.Value or "None"
    local newList = MiscSkills
    
    if wep == "Katana" then newList = KatanaSkills
    elseif wep == "Fist" then newList = FistSkills
    elseif wep == "Dagger" then newList = DaggerSkills
    elseif wep == "FireArm" then newList = FireArmSkills
end

Slot1Dropdown:Refresh(newList)
Slot2Dropdown:Refresh(newList)
Slot3Dropdown:Refresh(newList)
end

local weaponTypeLabel = CombatSection:Label("Current Weapon: " .. tostring(currentWeaponName))
if WeaponType then
    WeaponType:GetPropertyChangedSignal("Value"):Connect(function()
        weaponTypeLabel.Text = "Current Weapon: " .. tostring(WeaponType.Value)
        UpdateSkillDropdowns()
    end)
end
UpdateSkillDropdowns()

CombatSection:Bind("ForceSkill1", Enum.KeyCode.C, function()
    if SelectedSkills.Slot1 then
        CombatModule.ForceUseSkill(SelectedSkills.Slot1)
    end
end)

CombatSection:Bind("ForceSkill2", Enum.KeyCode.V, function()
    if SelectedSkills.Slot2 then
        CombatModule.ForceUseSkill(SelectedSkills.Slot2)
    end
end)

CombatSection:Bind("ForceSkill3", Enum.KeyCode.B, function()
    if SelectedSkills.Slot3 then
        CombatModule.ForceUseSkill(SelectedSkills.Slot3) 
    end
end)


--------------AutoFarm Tab ----------------

local SelectedMission = nil
AutofarmMissions:Dropdown("Mission", {"Cleanup Duty"}, function(selected: string)
    SelectedMission = selected
end)

AutofarmMissions:Toggle("Toggle Auto Farm", function(state)
    MissionsModule.AutoFarmEnabled = state
    
    if state and SelectedMission then
        MissionsModule.StartLoop(SelectedMission)
    end
end)

-- local SelectedRaid = nil
-- Raidfarm:Dropdown("Raids", {"Mysterious Hotel", "Zombie Devil Warehouse", "Yakuza Infiltration"}, function(selected: string)
--     SelectedRaid = selected
-- end)

-- Raidfarm:Button("Start Raid", function()
--     if SelectedRaid then
--         RaidsModule.StartRaid(SelectedRaid)
--     end
-- end)


-------------------MISC TAB-------------------
local MiscSection = MiscTab:Section("Misc")
MiscSection:Toggle("Toggle ESP", function(state)
    PlayerUtils.ToggleESP(state)
end)


local Npcs = {}
for _, entity in workspace.World.Dialog:GetChildren() do
    if entity:IsA("Model") then
        if entity.Name == "VaultDoor" or entity.Name == "Surgery Kit" or entity.Name == "" then
            continue
        end
        
        table.insert(Npcs, entity)
    end
end

local selectedNpc = nil
local NpcDropdown = MiscSection:Dropdown("Npcs", Npcs, function(selected)
    selectedNpc = selected
end)

MiscSection:Button("Tp to Npc", function()
    local npc = selectedNpc
    if npc then
        local npcModel = Npcs[npc]
        if npcModel then
            lPlayer.Character:PivotTo(npcModel:GetPivot() * CFrame.new(0, 3, 0))
        end
    end
end)

MiscSection:Button("Open Blackmarket", function(state)
    lPlayer.PlayerGui.Blackmarket.Enabled = state
end)



-------------------SETTINGS TAB-------------------
local SettingsSection = SettingsTab:Section("Settings")
SettingsSection:Toggle("No Blur", function(state)
    for _, v in Lighting:GetChildren() do
        if v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") then
            if v.Name == "InventoryBlur" then
                continue
            end

            v.Enabled = not state
        end
    end
end)

SettingsSection:Toggle("Fullbright", function(state)
    PlayerUtils.Fullbright(state)
end)