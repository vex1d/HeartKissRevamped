local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local Character = localPlayer.Character
local rootPart = Character:FindFirstChild("HumanoidRootPart")

local LiveFolder = workspace.Live
local Npcs = {}

local M1Remote = Character:FindFirstChild("client_character_controller"):FindFirstChild("M1")
local SkillRemote = Character:FindFirstChild("client_character_controller"):FindFirstChild("Skill")

local Autofarm = {}
Autofarm.Enabled = false
Autofarm.Distance = 100

local function GetClosestTarget()
	local currentTarget = nil
	local closestDistance = math.huge

	for _, npc in LiveFolder:GetChildren() do
		if npc == Character or not npc:FindFirstChild("HumanoidRootPart") then
			continue
		end

		if Players:GetPlayerFromCharacter(npc) then
			continue
		end

		local humanoid = npc:FindFirstChild("Humanoid")

		if humanoid and humanoid.Health > 0 then
			local npcRootPart = npc.HumanoidRootPart
			local distance = (rootPart.Position - npcRootPart.Position).Magnitude

			if distance < closestDistance then
				closestDistance = distance
				currentTarget = npc
			end
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

local autofarmCon = nil
function Autofarm.StartFarm(Enabled: boolean)
	if autofarmCon then
		autofarmCon:Disconnect()
		autofarmCon = nil
	end

	if Enabled then
		autofarmCon = RunService.Heartbeat:Connect(function()
			local npc = GetClosestTarget()

			if not npc or npc:GetAttribute("DisplayName") == "Hostage" then
				return
			end

			local npcRootPart = npc.HumanoidRootPart
			local targetPosition = (npcRootPart.CFrame * Options.Under).Position

			rootPart.CFrame = CFrame.lookAt(targetPosition, npcRootPart.Position)

			if M1Remote then
				M1Remote:FireServer(true, true)

				SkillRemote:FireServer(keys[math.random(1, #keys)], true)
			end
		end)
	else
		if autofarmCon then
			autofarmCon:Disconnect()
			autofarmCon = nil
		end
	end
end

return Autofarm
