local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Workspace = game:GetService("Workspace")
local Lib = require("GUI/Library")
local maid = require("Utils/Maid")
local PlayerUtils = require("Utils/PlayerUtils")

local ParryTimings = require("GameUtils/DevilHunter/Timings/Timings")
local AUTOFARM_CONFIG = require("GameUtils/DevilHunter/Configs/AutofarmConfig")
local MissionsModule = require("GameUtils/DevilHunter/Features/AutoMissions")
local RaidsModule = require("GameUtils/DevilHunter/Features/AutoRaids")

local window = Lib.new("HeartKiss", UDim2.fromScale(488, 518), Enum.KeyCode.RightControl)

local MainTab = window:Tab("Main")
local AutoFarm = window:Tab("AutoFarm")
local MiscTab = window:Tab("Misc")
local SettingsTab = window:Tab("Settings")
local ConfigsTab = window:Tab("Configs")

local PlayerSection = MainTab:Section("Main")
local CombatSection = MainTab:Section("Combat")

local AutofarmMissions = AutoFarm:Section("Autofarm")

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
AutofarmMissions:Dropdown("Raids", {"Mysterious Hotel", "Zombie Devil Warehouse", "Yakuza Infiltration"}, function(selected: string)
    SelectedRaid = selected
end)

AutofarmMissions:Button("Start Raid", function()
    if SelectedRaid then
        RaidsModule.StartRaid(SelectedRaid)
    end
end)