local Players = game:GetService("Players")

local AutofarmModule = require("GameUtils/BizzareLineage/Autofarm")

local Lib = require("GUI/Library")
local window = Lib.new("HeartKiss", UDim2.fromScale(488, 518), Enum.KeyCode.RightControl)

local localPlayer = Players.LocalPlayer
local Character = localPlayer.Character
local rootPart = Character:FindFirstChild("HumanoidRootPart")

local MainTab = window:Tab("Main")
local AutoFarmTab = window:Tab("AutoFarm")

local AutoFarmSection = AutoFarmTab:Section("AutoFarm")
local MainSection = MainTab:Section("Main")

AutoFarmSection:ToggleInput("Auto farm nearest", false, Enum.KeyCode.Two, function(Enabled)
	AutofarmModule.StartFarm(Enabled)
end)

AutoFarmSection:Bind("Tp to quest", Enum.KeyCode.Three, function()
	local char = localPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")

	if not root then
		return
	end

	local EffectsFolder = workspace.Effects
	local questbrick = EffectsFolder:FindFirstChild("questbrick")

	if questbrick then
		local hasInteracted = questbrick:GetAttribute("hasInteracted") or false
		if not hasInteracted then
			root.CFrame = questbrick:GetPivot()
			questbrick:SetAttribute("hasInteracted", true)
		end
	end
end)
