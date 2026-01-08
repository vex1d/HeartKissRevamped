--// Threading Utility
local m_thread = task
do
    setreadonly(m_thread, false)
    function m_thread.spawn_loop(p_time, p_callback)
        m_thread.spawn(function()
            while true do
                p_callback()
                m_thread.wait(p_time)
            end
        end)
    end
    setreadonly(m_thread, true)
end

--// Services & Globals
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

--// Feature Variables
local AutoParryEnabled = false
local MaxParryDistance = 20
local AutoCleanupEnabled = false

--// Auto Parry Data
local parryAnimations = {
    human = {{ID = "114393492422894", Delay = 0.1}, {ID = "72716101431005", Delay = 0.1}, {ID = "102225002431566", Delay = 0.1}, {ID = "91695353081923", Delay = 0.1}, {ID = "91841671178746", Delay = 1}, {ID = "98961744431023", Delay = 0.1}},
    pistol = {{ID = "121073263747297", Delay = 0.1}, {ID = "93431132327822", Delay = 0.1}, {ID = "116937962567393", Delay = 0.1}, {ID = "98375305489054", Delay = 0.5}, {ID = "133853808650941", Delay = 0.1}},
    fists = {{ID = "75114926121591", Delay = 0.05}, {ID = "84882180540900", Delay = 0.4}, {ID = "99785834052081", Delay = 0.05}, {ID = "129319150158146", Delay = 0.05}, {ID = "82402970804238", Delay = 0.1}, {ID = "83170627744442", Delay = 0.05}},
    katana = {{ID = "139174098471434", Delay = 0.1}, {ID = "134137542280552", Delay = 0.4}, {ID = "118176169991277", Delay = 0.1}, {ID = "125571123165138", Delay = 0.1}, {ID = "89332566098222", Delay = 0.1}},
    fiends = {
        base = {{ID = "114370481620131", Delay = 0.5}, {ID = "106191095787074", Delay = 0.3}},
        blood = {{ID = "90303043747701", Delay = 0.05}, {ID = "73033593102525", Delay = 0.05}},
        shark = {{ID = "107049572669140", Delay = 0.2}, {ID = "116781362921741", Delay = 0.2}},
        angel = {{ID = "76827947490912", Delay = 0.1}, {ID = "126621054776220", Delay = 0.1}, {ID = "134212846921544", Delay = 1}},
        nail = {{ID = "75114926121591", Delay = 0.07}}
    }
}

--// Helper Functions
local function pressF()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
end

local function setupParry(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or char == LocalPlayer.Character then return end
    hum.AnimationPlayed:Connect(function(track)
        if not AutoParryEnabled then return end
        local id = track.Animation.AnimationId:match("%d+")
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local enemyRoot = char:FindFirstChild("HumanoidRootPart")
        if myRoot and enemyRoot and (myRoot.Position - enemyRoot.Position).Magnitude <= MaxParryDistance then
            for _, cat in pairs(parryAnimations) do
                for _, anim in pairs(cat) do
                    if anim.ID and id == anim.ID then task.delay(anim.Delay, pressF) return end
                    if type(anim) == "table" then
                        for _, nested in pairs(anim) do
                            if nested.ID and id == nested.ID then task.delay(nested.Delay, pressF) return end
                        end
                    end
                end
            end
        end
    end)
end

--// Auto Cleanup Farm Logic
local function RunCleanupDuty()
    local RemoteFunction = ReplicatedStorage.Files.Framework.Network.RemoteFunction
    local CleanupFolder = workspace.World.Missions["Cleanup Duty"]
    local missions = RemoteFunction:InvokeServer("RequestLocationData", {"Cleanup Duty"})
    if not missions then return end

    if not workspace:FindFirstChild("SafePart") then
        local p = Instance.new("Part", workspace)
        p.CFrame, p.Size, p.Anchored, p.Name = CFrame.new(194.8, -56.0, -740), Vector3.new(100, 2, 100), true, "SafePart"
    end

    for Id, MType in pairs(missions) do
        if not AutoCleanupEnabled then break end
        RemoteFunction:InvokeServer("OverworldMissions", {Identification = Id, Conditions = {"Bloodlust", "Flawless"}, Directive = "Cleanup Duty", Request = "Engage"})
        
        local char = LocalPlayer.Character
        local root = char.HumanoidRootPart
        local asset = CleanupFolder:FindFirstChild(MType)
        if not asset then continue end

        local tomato = workspace.World.Effects:WaitForChild("TomatoDevil", 10)
        if not tomato then continue end

        root.CFrame = asset.TeleportPoint.CFrame * CFrame.new(0, -13, 0)
        local bv = Instance.new("BodyVelocity", root)
        bv.MaxForce, bv.Velocity, bv.Name = Vector3.new(1e5, 1e5, 1e5), Vector3.zero, "Float"

        root.CFrame = tomato:GetPivot() * CFrame.new(0, -13, 0)
        task.wait(0.4)
        for i=1,60 do fireproximityprompt(tomato.RootPart.Prompt) task.wait(0.02) end
        
        root.CFrame = workspace.SafePart.CFrame * CFrame.new(0, 3, 0)
        task.wait(3.5)
        
        root.CFrame = asset.TurnIn.CFrame * CFrame.new(0, -20, 0)
        if asset.TurnIn:FindFirstChild("Prompt") then
            for i=1,50 do fireproximityprompt(asset.TurnIn.Prompt) task.wait(0.05) end
        end

        if root:FindFirstChild("Float") then root.Float:Destroy() end
        root.CFrame = CFrame.new(-1075.9, 292.1, -585.9)
        break
    end
end

--// Initialize Parry
for _, p in pairs(Players:GetPlayers()) do if p.Character then setupParry(p.Character) end p.CharacterAdded:Connect(setupParry) end
Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(setupParry) end)

--// UI Setup
local library, pointers = loadstring(game:HttpGet("https://pastebin.com/raw/Q43KL2RS"))()
local window = library:New({name = "discord.gg/heartkiss" , size = Vector2.new(555, 610), Accent = Color3.fromRGB(192, 118, 227)})

--// MAIN TAB
local legitbot = window:Page({name = "Main", size = 80})
do
    local combat = legitbot:Section({name = "Combat"})
    combat:Toggle({name = "Auto Parry", callback = function(s) AutoParryEnabled = s end})
    combat:Slider({name = "Parry Distance", minimum = 5, maximum = 50, default = 20, callback = function(v) MaxParryDistance = v end})
end

--// FARMING TAB
local farm_page = window:Page({name = "Farming", size = 80})
do
    local farm_sec = farm_page:Section({name = "Auto Farm"})
    farm_sec:Toggle({name = "Auto Cleanup Duty", callback = function(s) AutoCleanupEnabled = s end})
end

--// CONFIG TAB
local settings_page = window:Page({name = "Configuration", side = "Left", size = 110})
do
    local config_section = settings_page:Section({name = "Configuration", side = "Left"})
    local current_list = {}
    local function update_config_list()
        if not isfolder("Linux/configs") then makefolder("Linux/configs") end
        local list = {}
        for _, file in ipairs(listfiles("Linux/configs")) do
            table.insert(list, file:gsub("Linux/configs\\", ""):gsub(".txt", ""))
        end
        if #list ~= #current_list then
            current_list = list
            pointers["settings/configuration/list"]:UpdateList(list, false, true)
        end
    end

    config_section:Listbox({pointer = "settings/configuration/list"})
    config_section:Textbox({pointer = "settings/configuration/name", placeholder = "Config Name", middle = true})
    config_section:ButtonHolder({Buttons = {
        {"Create", function() 
            local n = pointers["settings/configuration/name"]:get()
            if n ~= "" then writefile("Linux/configs/"..n..".txt", "") update_config_list() end 
        end},
        {"Delete", function()
            local s = pointers["settings/configuration/list"]:get()[1][1]
            if s then delfile("Linux/configs/"..s..".txt") update_config_list() end
        end}
    }})
    config_section:ButtonHolder({Buttons = {
        {"Load", function()
            local s = pointers["settings/configuration/list"]:get()[1][1]
            if s then window:LoadConfig(readfile("Linux/configs/"..s..".txt")) end
        end},
        {"Save", function()
            local s = pointers["settings/configuration/list"]:get()[1][1]
            if s then writefile("Linux/configs/"..s..".txt", window:GetConfig()) end
        end}
    }})
    m_thread.spawn_loop(3, update_config_list)
end

--// Menu Utils Section
local menu_sec = settings_page:Section({name = "Menu"})
menu_sec:Keybind({name = "Bind", default = Enum.KeyCode.End, callback = function(s) window.uibind = s end})
menu_sec:Button({name = "Unload", confirmation = true, callback = function() window:Unload() end})

--// Farming Loop
task.spawn(function()
    while true do
        if AutoCleanupEnabled then
            pcall(RunCleanupDuty)
            task.wait(7)
        end
        task.wait(1)
    end
end)

window.uibind = Enum.KeyCode.End
window:Initialize()