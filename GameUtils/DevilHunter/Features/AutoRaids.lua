local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

local PlaceIds = {
    [136364146980997] = "Yakuza Infiltration",
}

local lplayer = Players.LocalPlayer
local Entities = workspace.World.Entities
local Map = workspace.Map

local Files = ReplicatedStorage.Files
local Framework = Files.Framework
local Network = Framework.Network
local RemoteEvent = Network.RemoteEvent

local AutoRaids = {}
AutoRaids.AutoRaidsEnabled = false

local function AutoYakuzaRaid()
    print("Starting Yakuza Raid...")
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
    if #Entities:GetChildren() <= 1 then
        for _, entity in Entities:GetChildren() do
                if entity == Character then
                    continue
                end      

                Character:PivotTo(entity:GetPivot() * CFrame.new(0, 0, -2))
                print("Teleporting to " .. entity.Name)
            end
        end


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
        print("Teleporting to " .. raidPlace)
    else
        AutoRaids.Init()
        print("Raiding " .. PlaceId)
    end
end

function AutoRaids.Init()
    local PlaceId = PlaceIds[game.PlaceId]
    AutoRaids.AutoRaidsEnabled = true

    RemoteEvent:FireServer("Event", {Name = "WeaponInteract"})

    if PlaceId == "Yakuza Infiltration" then
        AutoYakuzaRaid()
    end
end



return AutoRaids