local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local lPlayer = Players.LocalPlayer
local PlayerUtils = {}

local FlyState = {
    Active = false,
    BG = nil,
    BV = nil,
    Connection = nil
}

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


function PlayerUtils.Fly(Enabled: boolean, Speed: number)
    FlyState.Active = Enabled
    local Camera = workspace.CurrentCamera
    local Character = lPlayer.Character or lPlayer.CharacterAdded:Wait()
    local Root = Character:WaitForChild("HumanoidRootPart")
    local Hum = Character:WaitForChild("Humanoid")
    
    local function Cleanup()
        if FlyState.BG then FlyState.BG:Destroy() FlyState.BG = nil end
        if FlyState.BV then FlyState.BV:Destroy() FlyState.BV = nil end
        if FlyState.Connection then FlyState.Connection:Disconnect() FlyState.Connection = nil end
        
        local char = lPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
    end

    if not Enabled then
        Cleanup()
        return
    end

    Cleanup()

    FlyState.BG = Instance.new("BodyGyro")
    FlyState.BG.P = 9e4
    FlyState.BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    FlyState.BG.CFrame = Root.CFrame
    FlyState.BG.Parent = Root

    FlyState.BV = Instance.new("BodyVelocity")
    FlyState.BV.Velocity = Vector3.new(0, 0, 0)
    FlyState.BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    FlyState.BV.Parent = Root

    Hum.PlatformStand = true

    FlyState.Connection = RunService.RenderStepped:Connect(function()
        if not FlyState.Active or not Root.Parent then 
            Cleanup()
            return 
        end

        local Movement = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then Movement = Movement + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then Movement = Movement - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then Movement = Movement - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then Movement = Movement + Camera.CFrame.RightVector end
        
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then Movement = Movement + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then Movement = Movement - Vector3.new(0, 1, 0) end

        FlyState.BV.Velocity = (Movement.Magnitude > 0) and (Movement.Unit * Speed) or Vector3.new(0, 0, 0)
        FlyState.BG.CFrame = Camera.CFrame
    end)
end

local OriginalLighting = {
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    GlobalShadows = Lighting.GlobalShadows
}

function PlayerUtils.Fullbright(Enabled: boolean)
    if Enabled then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
    else
        Lighting.Ambient = OriginalLighting.Ambient
        Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
        Lighting.Brightness = OriginalLighting.Brightness
        Lighting.GlobalShadows = OriginalLighting.GlobalShadows
    end
end


local FullbrightConnection = nil
function PlayerUtils.ToggleConstantFullbright(Enabled: boolean)
    if Enabled then
        FullbrightConnection = Lighting:GetPropertyChangedSignal("Ambient"):Connect(function()
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 2
            Lighting.GlobalShadows = false
        end)
        PlayerUtils.Fullbright(true)
    else
        if FullbrightConnection then 
            FullbrightConnection:Disconnect() 
            FullbrightConnection = nil 
        end
        PlayerUtils.Fullbright(false)
    end
end

return PlayerUtils