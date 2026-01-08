local lib = require(game.ReplicatedStorage.UILibrary2)

local window = lib.new("Heartkiss", UDim2.fromScale(488, 518), Enum.KeyCode.RightControl)

local Tab = window:Tab("Main")
local SettingsTab = window:Tab("Settings")

local FunSection = Tab:Section("Fun Features")
local aimbotTab = Tab:Section("Players")
local SettingsSection = Tab:Section("UI Settings")

local ConfigSection = SettingsTab:Section("Config")

SettingsTab:CreateConfig({
    List = {"Legit", "Rage", "HvH"},
    Input = function(text)
        print("User typed:", text)
    end,
    Dropdown = function(selected)
        print("User selected:", selected)
    end,
    Load = function()
        print("Load clicked!")
    end,
    Save = function()
        print("Save clicked!")
    end,
    Create = function()
        print("Create clicked!")
    end,
    Delete = function()
        print("Delete clicked!")
    end
})

aimbotTab:Button("Kill All", function() end)
aimbotTab:Dropdown("Target-Part", {"Head", "Torso", "Left Arm", "Right Arm"}, function(option: string)
    print(option)
end)

aimbotTab:Toggle("Auto Aim", function(state: boolean)
    print(state)
end)

aimbotTab:ToggleBind("Rapid Fire", Enum.KeyCode.R, function(enabled)
    print(enabled)
end)

aimbotTab:Button("Anti-Flash", function() end)
aimbotTab:Slider("FOV", 1, 100, 10, function(value: number)
    print(value)
end)

aimbotTab:ColorPicker("ESP Color", Color3.fromRGB(255, 0, 0), function(color: Color3)
    print(color)
end)

aimbotTab:Button("Anti-Gravity", function() end)

FunSection:Label("Fun Features!!!")
FunSection:Input("Input", "Placeholder", function(value: string)
    print(value)
end)
FunSection:Button("Explode All", function() end)
FunSection:Dropdown("Explosion Part", {"Head", "Torso", "Left Arm", "Right Arm"}, function(option: string)

end)
FunSection:Button("Rainbow Character", function() end)
FunSection:Slider("Walkspeed", 1, 10, 0, function(value: number)
    
end)

FunSection:Bind("Bind", Enum.KeyCode.E, function()
    print("pressed")
end)

FunSection:Toggle("Infinite Jump", function(state: boolean)
    print(state)
end)
FunSection:Button("Giant Character", function() end)
FunSection:Button("Tiny Character", function() end)
