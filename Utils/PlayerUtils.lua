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

function PlayerUtils:SetNoclip(Enabled: boolean, Speed: number)
    local char = lPlayer.Character
    if not char then return end
    
    for _, v in char:GetChildren() do
        if v:IsA("BasePart") then
            v.CanCollide = Enabled
        end 
    end
    PlayerUtils.Fly(Enabled, Speed)
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

local ESP_Folder = nil
local ESP_Connection = nil
function PlayerUtils.ToggleESP(Enabled: boolean)
    if not Enabled then
        if ESP_Connection then ESP_Connection:Disconnect() ESP_Connection = nil end
        if ESP_Folder then ESP_Folder:Destroy() ESP_Folder = nil end
        return
    end

    ESP_Folder = Instance.new("Folder")
    ESP_Folder.Name = "HeartKiss_ESP"
    ESP_Folder.Parent = game:GetService("CoreGui")

    local function CreateESP(player)
        if player == lPlayer then return end

        local function Setup(character)
            local root = character:WaitForChild("HumanoidRootPart", 10)
            local hum = character:WaitForChild("Humanoid", 10)
            if not root or not hum then return end

            -- 1. Setup Billboard
            local bb = Instance.new("BillboardGui")
            bb.Name = player.Name
            bb.Adornee = root
            bb.Size = UDim2.new(0, 150, 0, 80)
            bb.StudsOffset = Vector3.new(0, 4, 0)
            bb.AlwaysOnTop = true
            bb.Parent = ESP_Folder

            local list = Instance.new("UIListLayout")
            list.Parent = bb
            list.SortOrder = Enum.SortOrder.LayoutOrder
            list.HorizontalAlignment = Enum.HorizontalAlignment.Center
            list.Padding = UDim.new(0, 0)

            local function createLabel(order, size, color)
                local lab = Instance.new("TextLabel")
                lab.Size = UDim2.new(1, 0, 0.3, 0)
                lab.BackgroundTransparency = 1
                lab.TextColor3 = color
                lab.Font = Enum.Font.GothamBold
                lab.TextSize = size
                lab.TextStrokeTransparency = 0
                lab.LayoutOrder = order
                lab.Parent = bb
                return lab
            end

            local nameLabel = createLabel(1, 14, Color3.new(1, 1, 1))
            local healthLabel = createLabel(2, 13, Color3.fromRGB(200, 200, 200)) 
            local distLabel = createLabel(3, 12, Color3.fromRGB(200, 200, 200))

            local conn
            conn = RunService.RenderStepped:Connect(function()
                if not Enabled or not player.Parent or not character.Parent then
                    bb:Destroy()
                    conn:Disconnect()
                    return
                end

                nameLabel.Text = player.Name

                local health = math.floor(hum.Health)
                local maxHealth = math.floor(hum.MaxHealth)
                healthLabel.Text = string.format("[:%d / %d]", health, maxHealth)

                local dist = math.floor((root.Position - lPlayer.Character.HumanoidRootPart.Position).Magnitude)
                distLabel.Text = string.format("[%d m]", dist)
            end)
        end

        player.CharacterAdded:Connect(Setup)
        if player.Character then
            task.spawn(Setup, player.Character)
        end
    end

    for _, player in Players:GetPlayers() do CreateESP(player) end
    ESP_Connection = Players.PlayerAdded:Connect(CreateESP)
end


return PlayerUtils