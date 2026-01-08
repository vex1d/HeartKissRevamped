local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/vex1d/40db7f0824aa3b8c54a8dc311fe8bdd1/raw/b5a53d827bb5df0a3e7293b5299bec20a793fc90/HeartKissUILib"))()

-- 1. Create Window
local Window = Library.new("Heartkiss", UDim2.fromScale(488, 518), Enum.KeyCode.RightControl)

-- 2. Create Tabs
local MainTab = Window:Tab("Main")
local SettingsTab = Window:Tab("Settings")

-- 3. Create Sections (The Groups)
local MainSection = MainTab:Section("Showcase")
local ConfigSection = SettingsTab:Section("Configuration")

-- [[ EXAMPLES OF EVERY ELEMENT ]] --

MainSection:Label("Interactable Elements")

MainSection:Button("Button Example", function()
    print("Button Clicked!")
end)

MainSection:Toggle("Toggle Example", function(state)
    print("Toggle State:", state)
end)

MainSection:Slider("Slider Example", 1, 100, 50, function(value)
    print("Slider Value:", value)
end)

MainSection:Dropdown("Dropdown Example", {"Option A", "Option B", "Option C"}, function(selected)
    print("Dropdown Selected:", selected)
end)

MainSection:ColorPicker("Color Picker", Color3.fromRGB(170, 0, 255), function(color)
    print("New Color:", color)
end)

MainSection:Bind("Keybind Example", Enum.KeyCode.E, function()
    print("Keybind Pressed!")
end)

MainSection:ToggleBind("Toggle bind", Enum.KeyCode.R, function(state)
    print(state)
end)

MainSection:Input("Input Box", "Type something...", function(text)
    print("User Typed:", text)
end)