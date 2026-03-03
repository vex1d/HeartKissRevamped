local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local target = workspace:FindFirstChild("Stand Arrow", true)

if character and target then
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if rootPart and target:IsA("BasePart") then
		-- Teleporting to the arrow's position
		rootPart.CFrame = target.CFrame * CFrame.new(0, 3, 0)
	else
		warn("Target found, but it doesn't have a physical position (CFrame).")
	end
else
	warn("Could not find 'Stand Arrow' in the Workspace.")
end
