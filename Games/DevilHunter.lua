local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lib = require("GUI/Library")
local maid = require("Utils/Maid")
local PlayerUtils = require("Utils/PlayerUtils")

local ParryTimings = require("GameUtils/DevilHunter/Timings/Timings")
local AUTOFARM_CONFIG = require("GameUtils/DevilHunter/Configs/AutofarmConfig")

local window = Lib.new("HeartKiss", UDim2.fromScale(488, 518), Enum.KeyCode.RightControl)

local MainTab = window:Tab("Main")
local AutoFarm = window:Tab("AutoFarm")
local MiscTab = window:Tab("Misc")
local SettingsTab = window:Tab("Settings")
local ConfigsTab = window:Tab("Configs")

local PlayerSection = MainTab:Section("Main")
local CombatSection = MainTab:Section("Combat")

local AutofarmMissions = AutoFarm:Section("Autofarm")

local lPlayer = Players.LocalPlayer
local Files = ReplicatedStorage:WaitForChild("Files")
local Framework = Files:WaitForChild("Framework")
local RemoteFunction = Framework.Network:WaitForChild("RemoteFunction")
local CleanupDutyFolder = Workspace.World.Missions:WaitForChild("Cleanup Duty")

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
EnsureSafePart()

local function RunCleanupMission(ID, MissionType)
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

    local root = PlayerUtils:GetRoot()
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
    task.wait(1.5)

    local TurnInPoint = MissionAsset:FindFirstChild("TurnIn")
    
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

local AutoFarmEnabled = false 
local function ToggleAutoFarm(MissionType: string)
    if MissionType == "Cleanup Duty" then
        task.spawn(function()
            while AutoFarmEnabled do
                local availableMissions = RemoteFunction:InvokeServer("RequestLocationData", {"Cleanup Duty"})

                if availableMissions then
                    for Id, MissionType in availableMissions do
                        if not AutoFarmEnabled then break end 
                        
                        RunCleanupMission(Id, MissionType)
                        break 
                    end
                else
                    warn("No missions available")
                end
            
                if not AutoFarmEnabled then break end
                
                task.wait(AUTOFARM_CONFIG.Timeout)
                warn("Starting Next Mission...")
            end
        end)
    end
end


local SelectedMission = nil
local missionType = AutofarmMissions:Dropdown("Mission", {"Cleanup Duty", "Hold the Line", "Aftermath Detail"}, function(selected: string)
    SelectedMission = selected
end)

AutofarmMissions:Toggle("Toggle Auto Farm", function(state)
    AutoFarmEnabled = state 
    
    if state and SelectedMission then
        ToggleAutoFarm(SelectedMission)
    end
end)


local function  AutoParry()

end


-- local function  AutofarmCleanup()
    
-- end

-- for _, player in Players:GetPlayers() do
    
-- end