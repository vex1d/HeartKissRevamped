local Players = game:GetService("Players")
local lPlayer = Players.LocalPlayer
local PlayerUtils = {}

function PlayerUtils:SpamPrompt(prompt: ProximityPrompt, attempts: number, delay: number)
    if not prompt then return end
    
    for i = 1, attempts do
        fireproximityprompt(prompt)
        task.wait(delay)
    end
end

function PlayerUtils:GetRoot()
    local char = lPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

function PlayerUtils:Float(active: boolean)
    local root = PlayerUtils:GetRoot()

    if not root then return end
    local float = root:FindFirstChild("Float")
    
    if active and not float then
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.zero
        bv.Name = "Float"
        bv.Parent = root
    elseif not active and float then
        float:Destroy()
    end
end

function PlayerUtils:SetNoclip(active: boolean)
    local char = lPlayer.Character
    if not char then return end
    
    for _, v in char:GetChildren() do
        if v:IsA("BasePart") then
            v.CanCollide = not active
        end 
    end
end

function PlayerUtils:CheckForClosePlayers(TargetPart: any, Distance: number)
    if not TargetPart then return false end

    for _, player in Players:GetPlayers() do
        if player ~= lPlayer and player.Character then
            local pRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if pRoot and (pRoot.Position - TargetPart.Position).Magnitude < Distance then
                return true
            end
        end
    end
    
    return false
end

return PlayerUtils