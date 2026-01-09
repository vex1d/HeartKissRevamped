local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local PlayerUtils = require("Utils/PlayerUtils")
local AUTOFARM_CONFIG = require("GameUtils/DevilHunter/Configs/AutofarmConfig")

local Files = ReplicatedStorage:WaitForChild("Files")
local Framework = Files:WaitForChild("Framework")
local RemoteFunction = Framework.Network:WaitForChild("RemoteFunction")
local CleanupDutyFolder = Workspace.World.Missions:WaitForChild("Cleanup Duty")

local Missions = {}
Missions.AutoFarmEnabled = false

local function EnsureSafePart()
    local existing = Workspace:FindFirstChild("SafePart")
    if existing then return existing end

    local safePart = Instance.new("Part")
    safePart.CFrame = AUTOFARM_CONFIG.SafeZonePos
    safePart.Size = Vector3.new(100, 2, 100)
    safePart.Anchored = true
    safePart.Name = "SafePart"
    safePart.Parent = Workspace
    return safePart
end

function Missions.RunCleanup(ID, MissionType)
    EnsureSafePart()
    
    local root = PlayerUtils:GetRoot()
    root.CFrame = CFrame.new(-1075.9, 292.1, -585.9)

    local args = {
        "OverworldMissions",
        {
            Identification = ID,
            Conditions = { "Bloodlust", "Flawless" },
            Directive = "Cleanup Duty",
            Request = "Engage"
        }
    }
    RemoteFunction:InvokeServer(unpack(args))

    local MissionAsset = CleanupDutyFolder:WaitForChild(MissionType, AUTOFARM_CONFIG.Timeout)
    local TeleportPoint = MissionAsset and MissionAsset:WaitForChild("TeleportPoint", AUTOFARM_CONFIG.Timeout)
    
    if not TeleportPoint then 
        warn("Failed to find Mission Assets/Teleport Point") 
        return 
    end

    local arrived = false
    
    local startWait = tick()
    repeat
        if root and (root.Position - TeleportPoint.Position).Magnitude < 20 then
            arrived = true
        end
        task.wait(0.1)
    until arrived or (tick() - startWait > 8)

    if not arrived then
        warn("Game did not teleport character. Forcing teleport.")
    end

    local TomatoDevil = Workspace.World.Effects:WaitForChild("TomatoDevil", 15)
    if not TomatoDevil then warn("TomatoDevil not found") return end
    
    print("Found Target. Engaging.")
    
    PlayerUtils:Float(true)
    PlayerUtils:SetNoclip(true)
    
    root.CFrame = TeleportPoint.CFrame * CFrame.new(0, AUTOFARM_CONFIG.TeleportOffset, 0)
    task.wait(0.2)
    root.CFrame = TomatoDevil:GetPivot() * CFrame.new(0, AUTOFARM_CONFIG.TeleportOffset, 0)
    
    local TPrompt = TomatoDevil:WaitForChild("RootPart"):WaitForChild("Prompt", 5)
    PlayerUtils:SpamPrompt(TPrompt, AUTOFARM_CONFIG.InteractAttempts)

    root.CFrame = AUTOFARM_CONFIG.SafeZonePos * CFrame.new(0, 5, 0)

    task.wait(3)

    local TurnInPoint = MissionAsset:FindFirstChild("TurnIn")
    
    while not TurnInPoint:FindFirstChild("Prompt") do
        task.wait(1)
    end

    if TurnInPoint then
        while PlayerUtils:CheckForClosePlayers(TurnInPoint, AUTOFARM_CONFIG.SafeDistance) do
            warn("Player nearby, waiting...")
            task.wait(1)
        end

        local TurnInPrompt = TurnInPoint:FindFirstChild("Prompt")
        if TurnInPrompt then
            root.CFrame = TurnInPoint.CFrame * CFrame.new(0, -20, 0)
            PlayerUtils:SpamPrompt(TurnInPrompt, 50)
        end
    else
        warn("TurnIn Point not found")
    end

    PlayerUtils:Float(false)
    PlayerUtils:SetNoclip(false)
    local finalRoot = PlayerUtils:GetRoot()
    if finalRoot then
        finalRoot.CanCollide = false
        finalRoot.CFrame = AUTOFARM_CONFIG.EndZonePos
    end
    
    print("Mission Cycle Complete")
end

function Missions.StartLoop(selectedMission)
    Missions.AutoFarmEnabled = true
    print("Starting Autofarm Loop...")
    
    task.spawn(function()
        while Missions.AutoFarmEnabled do
            if selectedMission == "Cleanup Duty" then
                local availableMissions = RemoteFunction:InvokeServer("RequestLocationData", {"Cleanup Duty"})
                    if availableMissions then
                      for Id, MissionType in availableMissions do
                          if not Missions.AutoFarmEnabled then break end 
                          Missions.RunCleanup(Id, MissionType)
                          break 
                      end
                else
                    warn("No missions available")
                end
            end
            
            if not Missions.AutoFarmEnabled then break end
            task.wait(AUTOFARM_CONFIG.Timeout)
        end
    end)
end

function Missions.Stop()
    Missions.AutoFarmEnabled = false
end

return Missions