local PunchRemote = game:GetService("ReplicatedStorage"):WaitForChild("Punch")

for _, Entity in workspace:GetChildren() do
    if Entity:FindFirstChild("Humanoid") then
        local humanoid = Entity:FindFirstChild("Humanoid")

        humanoid.Health = 0
    end
end