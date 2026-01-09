local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Workspace = game:GetService("Workspace")
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

local PlayerSection = MainTab:Section("Main")
local CombatSection = MainTab:Section("Combat")

local AutofarmMissions = AutoFarm:Section("Missions")
local Raidfarm = AutoFarm:Section("Raids")

local WeaponType = CombatModule.GetWeaponType()
local KatanaSkills, FistSkills, DaggerSkills, FireArmSkills, MiscSkills = CombatModule.GetSkills()

local SelectedSkills = {
    Slot1 = nil,
    Slot2 = nil,
    Slot3 = nil
}

local currentWeaponName = (WeaponType and WeaponType.Value) or "Loading..."
local weaponTypeLabel = CombatSection:Label("Current Weapon: " .. tostring(currentWeaponName))

WeaponType:GetPropertyChangedSignal("Value"):Connect(function()
    weaponTypeLabel:SetText("Current Weapon: " .. tostring(WeaponType.Value))
end)

CombatSection:Bind("ForceSkill1", Enum.KeyCode.C, function()
    if SelectedSkills.Slot1 then
        CombatModule.ForceSkill1(SelectedSkills.Slot1)
    end
end)

CombatSection:Bind("ForceSkill2", Enum.KeyCode.V, function()
    if SelectedSkills.Slot2 then
        CombatModule.ForceSkill1(SelectedSkills.Slot1)
    end
end)

CombatSection:Bind("ForceSkill3", Enum.KeyCode.B, function()
    if SelectedSkills.Slot3 then
        CombatModule.ForceSkill1(SelectedSkills.Slot1)
    end
end)

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