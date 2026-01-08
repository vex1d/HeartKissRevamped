local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Workspace = game:GetService("Workspace")
local Lib = require("GUI/Library")
local maid = require("Utils/Maid")
local PlayerUtils = require("Utils/PlayerUtils")

local ParryTimings = require("GameUtils/DevilHunter/Timings/Timings")
local AUTOFARM_CONFIG = require("GameUtils/DevilHunter/Configs/AutofarmConfig")
local MissionsModule = require("GameUtils/DevilHunter/Features/AutoMissions")

local window = Lib.new("HeartKiss", UDim2.fromScale(488, 518), Enum.KeyCode.RightControl)

local MainTab = window:Tab("Main")
local AutoFarm = window:Tab("AutoFarm")
local MiscTab = window:Tab("Misc")
local SettingsTab = window:Tab("Settings")
local ConfigsTab = window:Tab("Configs")

local PlayerSection = MainTab:Section("Main")
local CombatSection = MainTab:Section("Combat")

local AutofarmMissions = AutoFarm:Section("Autofarm")

local lPlayer = Players.LocalPlayer
local Files = ReplicatedStorage:WaitForChild("Files")
local Framework = Files:WaitForChild("Framework")
local RemoteFunction = Framework.Network:WaitForChild("RemoteFunction")
local CleanupDutyFolder = Workspace.World.Missions:WaitForChild("Cleanup Duty")


local SelectedMission = nil
local missionType = AutofarmMissions:Dropdown("Mission", {"Cleanup Duty", "Hold the Line", "Aftermath Detail"}, function(selected: string)
    SelectedMission = selected
end)

AutofarmMissions:Toggle("Toggle Auto Farm", function(state)
    MissionsModule.AutoFarmEnabled = state
    
    if state and SelectedMission then
        MissionsModule.StartLoop(SelectedMission)
    end
end)
