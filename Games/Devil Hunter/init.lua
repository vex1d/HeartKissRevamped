local Players = game:GetService("Players")
local Lib = require("Utils/Lib")
local maid = require("Utils/Maid")
local ParryList = require("Games/Devil Hunter/ParryList")

local window = Lib.new("Heartkiss", UDim2.fromScale(488, 518), Enum.KeyCode.RightControl)

local MainTab = window:Tab("Main")
local MiscTab = window:Tab("Misc")
local SettingsTab = window:Tab("Settings")
local ConfigsTab = window:Tab("Configs")

local PlayerSection = MainTab:Section("Main")
local CombatSection = MainTab:Section("Combat")


local function  AutoParry()

end


for _, player in Players:GetPlayers() do
    
end