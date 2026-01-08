local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

-- Corrected Table: We need to look up ID by Name
local RaidData = {
    ["Yakuza Infiltration"] = 136364146980997,
    -- ["Mysterious Hotel"] = 123456789, 
}

local lplayer = Players.LocalPlayer
local AutoRaids = {}
AutoRaids.AutoRaidsEnabled = false

local function AutoYakuzaRaid()
    print("Starting Yakuza Raid...")
    local Character = lplayer.Character or lplayer.CharacterAdded:Wait()
    local Root = Character:WaitForChild("HumanoidRootPart")


    if not Character:FindFirstChild("Hitbox") then 
        local hitbox = Instance.new("Part")
        hitbox.Name = "Hitbox"
        hitbox.Size = Vector3.new(20, 20, 20) 
        hitbox.Transparency = 0.8
        hitbox.CanCollide = false
        hitbox.Anchored = false
        hitbox.Massless = true
        hitbox.Parent = Character
        
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = hitbox
        weld.Part1 = Root
        weld.Parent = hitbox
    end

    task.spawn(function()
        local Entities = workspace.World:WaitForChild("Entities")
        while AutoRaids.AutoRaidsEnabled do
            local targets = Entities:GetChildren()
            
            if #targets > 0 then
                for _, entity in pairs(targets) do
                    if entity ~= Character and entity:FindFirstChild("HumanoidRootPart") then
                        Character:PivotTo(entity:GetPivot() * CFrame.new(0, 0, 3)) 
                    end
                end
            end
            task.wait()
        end
    end)

    task.spawn(function()
        while AutoRaids.AutoRaidsEnabled do
            local hitbox = Character:FindFirstChild("Hitbox")
            if hitbox then
                local hb = workspace:GetPartBoundsInBox(hitbox.CFrame, hitbox.Size)
                
                for _, v in hb do
                    local model = v.Parent
                    local hum = model:FindFirstChild("Humanoid") or (model.Parent and model.Parent:FindFirstChild("Humanoid"))
                    
                    if hum and not Players:GetPlayerFromCharacter(hum.Parent) then
                        hum.Health = 0
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

function AutoRaids.Init()
    AutoRaids.AutoRaidsEnabled = true
    
    local Files = ReplicatedStorage:WaitForChild("Files")
    local RemoteEvent = Files.Framework.Network:WaitForChild("RemoteEvent")
    RemoteEvent:FireServer("Event", {Name = "WeaponInteract"})

    AutoYakuzaRaid() 
end

function AutoRaids.StartRaid(RaidName: string)
    local TargetPlaceId = RaidData[RaidName]
    
    if not TargetPlaceId then 
        warn("Invalid Raid Name or ID missing") 
        return 
    end

    if game.PlaceId == TargetPlaceId then
        print("Already in raid, initializing...")
        AutoRaids.Init()
    else
        print("Teleporting to " .. RaidName .. " (" .. TargetPlaceId .. ")")
        

        if queue_on_teleport then
            queue_on_teleport([[
                repeat task.wait() until game:IsLoaded()
                -- PASTE YOUR LOADSTRING HERE vvv
                loadstring(game:HttpGet("YOUR_SCRIPT_URL_HERE"))()
            ]])
        end
        
        TeleportService:Teleport(TargetPlaceId, lplayer)
    end
end

return AutoRaids