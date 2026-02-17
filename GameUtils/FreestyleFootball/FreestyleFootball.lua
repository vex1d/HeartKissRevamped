local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local KeyHandlerService = Knit.GetService("KeyHandlerService")

local lPlayer = Players.LocalPlayer
local Character = lPlayer.Character or lPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local KickRemote = KeyHandlerService:GetKey("Kick")
local BicycleRemote = KeyHandlerService:GetKey("Bicycle")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Knit = require(ReplicatedStorage.Packages.Knit)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PowerLabel"
screenGui.Parent = game.CoreGui

local powerLabel = Instance.new("TextBox")
powerLabel.Name = "PowerValueLabel"
powerLabel.Size = UDim2.new(0, 200, 0, 50)
powerLabel.Position = UDim2.new(0, 10, 0, 10)
powerLabel.BackgroundTransparency = 0.5
powerLabel.Parent = screenGui

local Power = 0

powerLabel.FocusLost:Connect(function()
	Power = tonumber(powerLabel.Text) or 921.895190871320665
	powerLabel.Text = tostring(Power)
end)


local function GetMouseDir()
    local mouse = UserInputService:GetMouseLocation()
    local camera = workspace.CurrentCamera
    local unitRay = camera:ScreenPointToRay(mouse.X, mouse.Y)
    return unitRay.Direction
end

-- local target = workspace.CharacterContainer.yunoinverted
UserInputService.InputBegan:Connect(function(Input, GPE)
    if GPE then
        return
    end
    

    if Input.KeyCode == Enum.KeyCode.C then
		print(Power)
        local args = {
            GetMouseDir(), -- target position
            workspace:WaitForChild("Temp"):WaitForChild("Ball"), -- ball
            true,
            true,
            Power, -- power from label
            "Left",
            GetMouseDir(),
            {
                Enum.KeyCode.W
            },
            true,
            true
        }
        
        KickRemote:FireServer(unpack(args))
    end
end)


-- local power = GetPowerFromLabel()
-- local args = {
--     GetMouseDir(), -- target position
--     workspace:WaitForChild("Temp"):WaitForChild("Ball"), -- ball
--     true,
--     true,
--     power, -- power from label
--     "Left",
--     GetMouseDir(),
--     {
--         Enum.KeyCode.W
--     },
--     true,
--     true
-- }

-- KickRemote:FireServer(unpack(args))