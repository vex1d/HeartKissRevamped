local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer

local LiveFolder = workspace.Live
local Npcs = {}

local Autofarm = {}
Autofarm.Enabled = false
Autofarm.Distance = 100

local isnetworkowner = function(BasePart)
	if not BasePart or not BasePart:IsA("BasePart") then
		return false
	end
	if not gethiddenproperty then
		return false
	end

	local function GetID(Instance)
		return gethiddenproperty(Instance, "NetworkOwnerV3")
	end

	local myID = GetID(localPlayer.Character:FindFirstChild("HumanoidRootPart"))
	return myID == GetID(BasePart)
end

local function GetClosestTarget()
	local Character = localPlayer.Character
	local rootPart = Character:FindFirstChild("HumanoidRootPart")

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
			local char = localPlayer.Character
			if not char then
				return
			end

			local rootPart = char:FindFirstChild("HumanoidRootPart")
			local controller = char:FindFirstChild("client_character_controller")
			if not rootPart or not controller then
				return
			end

			local npc = GetClosestTarget()
			if not npc or npc.Name == "Server" then
				return
			end

			local humanoid = npc:FindFirstChild("Humanoid")
			local npcRoot = npc:FindFirstChild("HumanoidRootPart")
			if not humanoid or not npcRoot then
				return
			end

			if isnetworkowner(npcRoot) then
				humanoid.Health = 0
			else
				local targetPos = (npcRoot.CFrame * Options.Under).Position
				rootPart.CFrame = CFrame.lookAt(targetPos, npcRoot.Position)

				local m1 = controller:FindFirstChild("M1")
				local skill = controller:FindFirstChild("Skill")

				if m1 then
					m1:FireServer(true, true)
					if math.random(1, 5) == 1 then
						skill:FireServer(keys[math.random(1, #keys)], true)
					end
				end
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
