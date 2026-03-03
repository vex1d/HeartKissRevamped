local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local EffectsFolder = workspace.Effects

local localPlayer = Players.LocalPlayer
local Character = localPlayer.Character
local rootPart = Character:FindFirstChild("HumanoidRootPart")

UserInputService.InputBegan:Connect(function(Input, GPE)
	if GPE then
		return
	end

	if Input.KeyCode == Enum.KeyCode.Three then
		local questbrick = EffectsFolder:WaitForChild("questbrick", 10)
		local hasInteracted = questbrick:GetAttribute("hasInteracted")
		if questbrick and not hasInteracted then
			rootPart.CFrame = questbrick:GetPivot()
			questbrick:SetAttribute("hasInteracted", true)
		end
	end
end)

--[[
local args = {
	workspace:WaitForChild("Npcs"):WaitForChild("Chumbo"),
	"Raid."
}
game:GetService("ReplicatedStorage"):WaitForChild("requests"):WaitForChild("character"):WaitForChild("dialogue"):FireServer(unpack(args))
]]
