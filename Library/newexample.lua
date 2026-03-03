-- Assuming your library code is either a ModuleScript or ran before this
local Library = loadstring(game:HttpGet("YOUR_LIBRARY_LINK_HERE"))()

-- 1. Create the Main Window
-- Name, Size (Optional), Toggle Key (KeyCode or UserInputType)
local Window = Library.new("Heartkiss Premium", UDim2.fromOffset(500, 550), Enum.KeyCode.RightControl)

-- 2. Create a Tab
local MainTab = Window:Tab("Combat")
local VisualTab = Window:Tab("Visuals")
local SettingsTab = Window:Tab("Settings")

-- 3. Create Sections (These alternate Left/Right automatically)
local KillSection = MainTab:Section("Kill Aura")
local MovementSection = MainTab:Section("Movement")

---------------------------------------------------------
-- COMBAT TAB ELEMENTS
---------------------------------------------------------

-- Toggle Component
KillSection:Toggle("Enabled", function(state)
	print("Kill Aura is now:", state)
end)

-- Slider Component (Text, Min, Max, Default, Callback)
KillSection:Slider("Range", 5, 50, 25, function(value)
	print("Aura Range set to:", value)
end)

-- Keybind Component (Instant press)
KillSection:Bind("Quick Execute", Enum.KeyCode.V, function()
	print("Execute Key Pressed!")
end)

-- Input Component (Text, Placeholder, Callback)
KillSection:Input("Target Priority", "Username...", function(text)
	print("Now targeting priority user:", text)
end)

-- Button Component
MovementSection:Button("Fly Mode (Manual)", function()
	print("Fly Button Clicked")
end)

-- ToggleBind Component (A toggle that can be triggered by a key)
MovementSection:ToggleBind("Auto-Farm", Enum.KeyCode.X, function(state)
	print("Auto-Farm toggled via key/ui to:", state)
end)

-- Text, DefaultState, DefaultKey, Callback
MovementSection:ToggleInput("Auto-Block", false, Enum.KeyCode.F, function(bool)
	if bool then
		print("Blocking enabled")
	else
		print("Blocking disabled")
	end
end)

---------------------------------------------------------
-- VISUALS TAB ELEMENTS
---------------------------------------------------------
local EspSection = VisualTab:Section("ESP Settings")

-- Dropdown Component (Text, List, Callback)
local EspDropdown = EspSection:Dropdown("ESP Type", { "Boxes", "Tracers", "Skeleton", "HeadDots" }, function(selected)
	print("Selected ESP:", selected)
end)

-- Dropdown Refresh Example
EspSection:Button("Refresh List", function()
	EspDropdown:Refresh({ "Updated 1", "Updated 2", "Updated 3" })
end)

-- ColorPicker Component
EspSection:ColorPicker("Box Color", Color3.fromRGB(243, 117, 255), function(color)
	print("New ESP Color:", color)
end)

-- Button Row Component (Two buttons side-by-side)
EspSection:CreateButtonRow(
	"Reset Visuals",
	function()
		print("Resetting...")
	end,
	"Clear Cache",
	function()
		print("Clearing...")
	end
)

---------------------------------------------------------
-- SETTINGS TAB (Config Helper)
---------------------------------------------------------
-- The .Config method is a built-in helper for Save/Load systems
SettingsTab:Config({
	List = { "Default", "Legit", "Rage" },
	Input = function(text)
		print("New Config Name:", text)
	end,
	Dropdown = function(val)
		print("Selected to load:", val)
	end,
	Load = function()
		print("Loading Config...")
	end,
	Save = function()
		print("Saving Config...")
	end,
	Create = function()
		print("Creating Config...")
	end,
	Delete = function()
		print("Deleting Config...")
	end,
})

-- Label Component (Simple text display)
local InfoSection = SettingsTab:Section("Information")
InfoSection:Label("Developer: YourName")
InfoSection:Label("Version: 1.0.4 Beta")
