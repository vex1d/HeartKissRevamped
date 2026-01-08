local Players = game:GetService("Players")
local Lib = require("GUI/Library")
local maid = require("Utils/Maid")
local ParryTimings = require("GameUtils/Timings/DevilHunterParryTimings")

local window = Lib.new("HeartKiss", UDim2.fromScale(488, 518), Enum.KeyCode.RightControl)

local MainTab = window:Tab("Main")
local AutoFarm = window:Tab("AutoFarm")
local MiscTab = window:Tab("Misc")
local SettingsTab = window:Tab("Settings")
local ConfigsTab = window:Tab("Configs")

local PlayerSection = MainTab:Section("Main")
local CombatSection = MainTab:Section("Combat")

local AutofarmMissions = AutoFarm:Section("Autofarm")
local missionType = AutofarmMissions:Dropdown("Mission Type", {"Cleanup Duty", "Hold the Line", "Aftermath Detail"})

print("Devil hunter game loaded")


local function  AutoParry()

end


-- local function  AutofarmCleanup()
    
-- end

-- for _, player in Players:GetPlayers() do
    
-- end