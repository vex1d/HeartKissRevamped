local Players = game:GetService("Players")

local localPlayer = Players.LocalPlayer
local Character = localPlayer.Character
local rootPart = Character:FindFirstChild("HumanoidRootPart")

local LiveFolder = workspace.Live
local Npcs = {}

for _, v in LiveFolder:GetChildren() do
	local notPlayer = not Players:GetPlayerFromCharacter(v)
	if notPlayer then
		table.insert(Npcs, v)
	end
end

while true do
	for _, npc in Npcs do
		local humanoid = npc:FindFirstChild("Humanoid")
		local npcRootPart = npc:FindFirstChild("HumanoidRootPart")
		local distance = (rootPart.Position - npcRootPart.Position).Magnitude

		if distance > 150 then
			continue
		end

		if humanoid then
			humanoid:TakeDamage(math.huge)
			humanoid.Health = 0
			humanoid:ChangeState(Enum.HumanoidStateType.Dead)
			-- print(`Set {npc.Name} to dead`)
		end
	end

	task.wait()
end
