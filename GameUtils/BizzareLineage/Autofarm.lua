local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local Character = localPlayer.Character
local rootPart = Character:FindFirstChild("HumanoidRootPart")

local LiveFolder = workspace.Live
local Npcs = {}

local M1Remote = Character:FindFirstChild("client_character_controller"):FindFirstChild("M1")
local SkillRemote = Character:FindFirstChild("client_character_controller"):FindFirstChild("Skill")

local enabled = false

UserInputService.InputBegan:Connect(function(Input, GPE)
	if GPE then
		return
	end

	if Input.KeyCode == Enum.KeyCode.Two then
		enabled = not enabled
	end
end)

local function GetClosestTarget()
	local currentTarget = nil
	local closestDistance = math.huge

	for _, npc in LiveFolder:GetChildren() do
		if npc == Character then
			continue
		end

		local Player = Players:GetPlayerFromCharacter(v)
		if Player then
			continue
		end

		local npcRootPart = npc:FindFirstChild("HumanoidRootPart")
		local distance = (rootPart.Position - npcRootPart.Position).Magnitude
		if distance < closestDistance then
			closestDistance = distance
			currentTarget = npc
		end
	end

	return currentTarget
end

local Options = {
	["Behind"] = CFrame.new(0, 0, 7),
	["Front"] = CFrame.new(0, 0, -7),
	["Under"] = CFrame.new(0, -7, 0),
	["Above"] = CFrame.new(0, 7, 0),
}

local keys = {
	"E",
	"R",
	"Z",
	"X",
	"C",
}

while task.wait() do
	if not enabled then
		continue
	end

	local npc = GetClosestTarget()
	if npc == Character then
		continue
	end

	if
		not npc
		or not npc:FindFirstChild("HumanoidRootPart")
		or npc.Name == "Server"
		or npc:GetAttribute("DisplayName") == "Hostage"
	then
		continue
	end

	local npcRootPart = npc:FindFirstChild("HumanoidRootPart")
	local humanoid = npc:FindFirstChild("Humanoid")

	local offset = Options.Under

	local distance = (rootPart.Position - npcRootPart.Position).Magnitude

	if distance > 150 or humanoid.Health <= 0 then
		continue
	end

	local targetPosition = (npcRootPart.CFrame * offset).Position

	rootPart.CFrame = CFrame.lookAt(targetPosition, npcRootPart.Position)

	if M1Remote then
		-- humanoid.Health = 0
		M1Remote:FireServer(true, true)
		SkillRemote:FireServer(keys[math.random(1, #keys)], true)
	end
end
