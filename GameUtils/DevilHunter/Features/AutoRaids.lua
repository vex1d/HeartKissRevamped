local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local PlaceIds = {
    [136364146980997] = "Yakuza Infiltration",
}

local lplayer = Players.LocalPlayer
local Entities = workspace.World.Entities
local Map = workspace.Map


local AutoRaids = {}
AutoRaids.AutoRaidsEnabled = false

local function AutoYakuzaRaid()
    local Character = lplayer.Character

    if not Character:FindFirstChild("Hitbox") then 
        local hitbox = Instance.new("Part")
        hitbox.Name = "Hitbox"
        hitbox.Size = Vector3.new(10, 10, 10)
        hitbox.Transparency = 0
        hitbox.Material = Enum.Material.ForceField
        hitbox.CFrame = Character.HumanoidRootPart.CFrame
        hitbox.Color = Color3.fromRGB(255, 0, 0)
        hitbox.Massless = true
        hitbox.CanCollide = false
        hitbox.Anchored = false
        hitbox.Parent = Character
    
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = hitbox
        weld.Part1 = Character.HumanoidRootPart
        weld.Parent = hitbox
    end

    while true do
        if #Entities:GetChildren() > 1 then
            local hitbox = Character:FindFirstChild("Hitbox")
            local hb = workspace:GetPartBoundsInBox(hitbox.CFrame, hitbox.Size)
            for _, v in hb do
                if v.Parent:FindFirstChild("Humanoid") or v.Parent.Parent:FindFirstChild("Humanoid") then
                    local isPlayer = Players:GetPlayerFromCharacter(v.Parent)
                    if isPlayer then
                        continue
                    end
    
                    local entity = v.Parent
                    local humanoid = entity:FindFirstChild("Humanoid")
    
                    if entity == Character then
                        continue
                    end
    
                    if humanoid then
                        humanoid.Health = 0
                    end
                end
            end
        else
            break
        end

        task.wait()
    end
end

function AutoRaids.StartRaid(RaidType: string)
    local PlaceId = PlaceIds[RaidType]
    
    if not game.PlaceId == PlaceId then 
        local raidPlace = PlaceIds[game.PlaceId]
        TeleportService:Teleport(raidPlace, Players.LocalPlayer)

        queue_on_teleport(function()
            AutoRaids.Init()
        end)
    else
        AutoRaids.Init()
    end
end

function AutoRaids.Init()
    local PlaceId = PlaceIds[game.PlaceId]
    AutoRaids.AutoRaidsEnabled = true

    if PlaceId == "Yakuza Infiltration" then
        AutoYakuzaRaid()
    end
end



return AutoRaids