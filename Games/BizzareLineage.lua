local Players = game:GetService("Players")

local Autofarm = require("GameUtils/BizzareLineage/Autofarm")

local Lib = require("GUI/Library")
local window = Lib.new("HeartKiss", UDim2.fromScale(488, 518), Enum.KeyCode.RightControl)

local localPlayer = Players.LocalPlayer
local Character = localPlayer.Character
local rootPart = Character:FindFirstChild("HumanoidRootPart")

local MainTab = window:Tab("Main")
local AutoFarmTab = window:Tab("AutoFarm")

local AutoFarm = AutoFarmTab:Section("AutoFarm")
local MainSection = MainTab:Section("Main")

AutoFarm:ToggleInput("Auto farm nearest", Enum.KeyCode.Three, function(Enabled)
	Autofarm.StartFarm(Enabled)
end)

MainSection:ToggleInput("Tp to quest", Enum.KeyCode.Two, function()
	local EffectsFolder = workspace.Effects
	local questbrick = EffectsFolder:WaitForChild("questbrick", 10)
	local hasInteracted = questbrick:GetAttribute("hasInteracted")
	if questbrick and not hasInteracted then
		rootPart.CFrame = questbrick:GetPivot()
		questbrick:SetAttribute("hasInteracted", true)
	end
end)
