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

local MainSection = MainTab:Section("Main")
local CombatSection = MainTab:Section("Combat")
local PlayerSection = MainTab:Section("Player")

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
local WalkSpeedEnabled = false
PlayerSection:Toggle("Toggle Walk Speed", function(state)
    WalkSpeedEnabled = state
end)

PlayerSection:Slider("Speed", 16, 350, 16, function(value)
    if not WalkSpeedEnabled then return end
    lPlayer.Character.Humanoid.WalkSpeed = value
end)

local FlyEnabled = false
local FlySpeed = 16

PlayerSection:ToggleBind("Toggle Fly", Enum.KeyCode.T, function(state)
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

local WeaponType = CombatModule.GetWeaponType()
local currentWeaponName = "None"
if WeaponType then
    currentWeaponName = WeaponType.Value
end
local activeSkills = CombatModule.GetCurrentSkillList()

local Slot1Dropdown = CombatSection:Dropdown("Skill Slot 1", KatanaSkills, function(selected)
    SelectedSkills.Slot1 = selected
end)

local Slot2Dropdown = CombatSection:Dropdown("Skill Slot 2", KatanaSkills, function(selected)
    SelectedSkills.Slot2 = selected
end)

local Slot3Dropdown = CombatSection:Dropdown("Skill Slot 2", KatanaSkills, function(selected)
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
AutofarmMissions:Dropdown("Mission", {"Cleanup Duty", "Hold the Line", "Aftermath Detail"}, function(selected: string)
    SelectedMission = selected
end)

AutofarmMissions:Toggle("Toggle Auto Farm", function(state)
    MissionsModule.AutoFarmEnabled = state
    
    if state and SelectedMission then
        MissionsModule.StartLoop(SelectedMission)
    end
end)

local SelectedRaid = nil
Raidfarm:Dropdown("Raids", {"Mysterious Hotel", "Zombie Devil Warehouse", "Yakuza Infiltration"}, function(selected: string)
    SelectedRaid = selected
end)

Raidfarm:Button("Start Raid", function()
    if SelectedRaid then
        RaidsModule.StartRaid(SelectedRaid)
    end
end)