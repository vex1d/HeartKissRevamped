local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local lplayer = Players.LocalPlayer
local Character = lplayer.Character or lplayer.CharacterAdded:Wait()
local root = Character:WaitForChild("HumanoidRootPart")

local mouse = UserInputService:GetMouseLocation()
local camera = workspace.CurrentCamera

local direction = camera:ViewportPointToRay(mouse.X, mouse.Y).Direction

--ds hitbox = 20,100, 20
--idk hitbox= 50, 50, 50

if not Character:FindFirstChild("Hitbox") then
    local hitbox = Instance.new("Part")
    hitbox.Name = "Hitbox"
    hitbox.Size = Vector3.new(20, 30, 20)
    hitbox.CFrame = root.CFrame --* CFrame.new(0, 0, -hitbox.Size.Z / 2)
    hitbox.Transparency = 0.5
    hitbox.CanCollide = false
    hitbox.Material = Enum.Material.ForceField
    hitbox.CastShadow = false
    hitbox.Color = Color3.fromRGB(255, 0, 0)
    hitbox.Anchored = false
    hitbox.Massless = true
    hitbox.Parent = Character
   
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = hitbox
    weld.Part1 = root
    weld.Parent = hitbox
end


local lastDash = 0
local MIN_SIZE = 10
local MAX_SIZE = 70
local SPEED_SENSITIVITY = 5

while Character:FindFirstChild("Hitbox") do
    local hitbox = Character:FindFirstChild("Hitbox")
    
    local ballContainer = workspace:FindFirstChild("Balls")
    local ball = ballContainer and ballContainer:FindFirstChild("Ball")
    
    if ball and ball:IsA("BasePart") then
        local speed = ball.AssemblyLinearVelocity.Magnitude

        local dynamicSize = MIN_SIZE + (speed / SPEED_SENSITIVITY)
        local finalSize = math.clamp(dynamicSize, MIN_SIZE, MAX_SIZE)
        
        hitbox.Size = Vector3.new(finalSize, finalSize, finalSize)
    end

    local hb = workspace:GetPartBoundsInBox(hitbox.CFrame, hitbox.Size)
    for _, v in hb do
        if v.Name == "Ball" then
            if v:GetAttribute("LastPlayer") == lplayer.Name then
                break
            end

            
            if not root:FindFirstChild("Dash") then
                if os.clock() - lastDash > 1 then
                    lastDash = os.clock()
                    
                    local ballPos = v.Position
                    local horizontalDist = (Vector3.new(ballPos.X, 0, ballPos.Z) - Vector3.new(root.Position.X, 0, root.Position.Z)).Magnitude

                    local verticalAdjustment = 1
                    if v.Position.Y > root.Position.Y + 2 then
                        targetPosition = ballPos + Vector3.new(0, verticalAdjustment, 0)
                    else
                        targetPosition = ballPos
                    end
                    
                    local direction = (targetPosition - root.Position).Unit
                    
                    local dash = Instance.new("BodyVelocity")
                    dash.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                    dash.Velocity = direction * 60 
                    dash.Name = "Dash"
                    dash.Parent = root
                    
                    task.delay(0.1, function()
                        dash:Destroy()
                    end)
                end

                VirtualInputManager:SendMouseButtonEvent(mouse.X, mouse.Y, 1, false, game, 1)
            end
        end
    end

    task.wait()
end