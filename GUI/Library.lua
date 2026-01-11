local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")


local Library = {}
Library.__index = Library

if not getgenv().connections then
    getgenv().connections = {}
end

local connections = getgenv().connections

local THEMES = {
    MainColor = Color3.fromRGB(30, 30, 30),
    FrameColor = Color3.fromRGB(25, 25, 25),
    TabColor = Color3.fromRGB(24, 24, 24),
    LineColor = Color3.fromRGB(243, 117, 255),
    BorderColor = Color3.fromRGB(70, 70, 70),
    DarkColor = Color3.fromRGB(0, 0, 0),
    SelectedTab = Color3.fromRGB(252, 175, 248),
    TextColor = Color3.fromRGB(255, 255, 255),
    ButtonBorderColor = Color3.fromRGB(27, 27, 27)
}

local function  CreateGradient(Parent: any, Rotation)
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(0.19, Color3.fromRGB(203, 203, 203)), ColorSequenceKeypoint.new(0.52, Color3.fromRGB(175, 175, 175)), ColorSequenceKeypoint.new(0.84, Color3.fromRGB(197, 197, 197)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))}
    UIGradient.Rotation = Rotation or 90
    UIGradient.Parent = Parent
end

local function  CreateButton()
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 15)
    Btn.BackgroundColor3 = THEMES.FrameColor
    Btn.BorderColor3 = THEMES.ButtonBorderColor
    Btn.TextColor3 = THEMES.TextColor
    Btn.Font = Enum.Font.Code
    Btn.TextSize = 12
    CreateGradient(Btn)

    return Btn
end

function Library.new(Name: string, Size: UDim2, KeyBind: Enum.UserInputType | Enum.KeyCode)
    local self = setmetatable({}, Library)

    self.Name = Name or "Heartkiss"
    self.Size = Size or UDim2.fromScale(488, 518)
    self.Tabs = {}
    self.KeyBind = KeyBind or Enum.KeyCode.RightControl

    if game.CoreGui:FindFirstChild(Name) then
        game.CoreGui:FindFirstChild(Name):Destroy()
        for _, con in connections do
            if con and con.Disconnect then
                con:Disconnect()
                con = nil
                -- print(con)
            end
        end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = Name
    
    if syn and syn.protect_gui then 
        syn.protect_gui(ScreenGui) 
    elseif protectgui then
        protectgui(ScreenGui)
    end
    
    ScreenGui.Parent = game.CoreGui

    local MainFrame = Instance.new("Frame")
    local Frame = Instance.new("Frame")
    local Line = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local Tabs = Instance.new("Frame")
    local ScrollingFrame = Instance.new("ScrollingFrame")
    local Tab = Instance.new("TextButton")
    local UIListLayout = Instance.new("UIListLayout")
    local FrameHolder = Instance.new("Frame")

    local UIDragDetector = Instance.new("UIDragDetector")
    UIDragDetector.Parent = MainFrame

    MainFrame.Name = "MainFrame"
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = THEMES.MainColor
    MainFrame.BorderColor3 = THEMES.LineColor
    MainFrame.Position = UDim2.new(0.5, 0, 0.463210702, 0)
    MainFrame.Size = UDim2.new(0, 488, 0, 518)
    MainFrame.Parent = ScreenGui
    CreateGradient(MainFrame)

    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundColor3 = THEMES.FrameColor
    Frame.BorderColor3 = Color3.fromRGB(98, 98, 98)
    Frame.Position = UDim2.new(0.498770535, 0, 0.508301139, 0)
    Frame.Size = UDim2.new(0.959016383, 0, 0.943243206, 0)
    Frame.ZIndex = 1
    Frame.Parent = MainFrame
    CreateGradient(Frame)

    Line.Name = "Line"
    Line.AnchorPoint = Vector2.new(0.5, 0.5)
    Line.BackgroundColor3 = THEMES.LineColor
    Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Line.BorderSizePixel = 0
    Line.Position = UDim2.new(0.5, 0, 0, 0)
    Line.Size = UDim2.new(1, 0, 0.00249999994, 0)
    Line.Parent = Frame

    Title.Name = "Title"
    Title.AnchorPoint = Vector2.new(0.5, 0.5)
    Title.Position = UDim2.new(0.498770535, 0, 0.0202702694, 0)
    Title.Size = UDim2.new(0, 468, 0, 17)
    Title.Font = Enum.Font.SourceSans
    Title.Text = Name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.TextScaled = true
    Title.TextWrapped = true
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = MainFrame

    Tabs.Name = "Tabs"
    Tabs.AnchorPoint = Vector2.new(0.5, 0.5)
    Tabs.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    Tabs.BorderColor3 = THEMES.BorderColor
    Tabs.Position = UDim2.new(0.498, 0,0.095, 0)
    Tabs.Size = UDim2.new(0.917, 0,0.058, 0)
    Tabs.Parent = MainFrame

    ScrollingFrame.Active = true
    ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ScrollingFrame.BackgroundTransparency = 1.000
    ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    ScrollingFrame.Size = UDim2.new(1, 0,0.952, 0)
    ScrollingFrame.HorizontalScrollBarInset = Enum.ScrollBarInset.Always
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X 
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
    ScrollingFrame.ScrollBarThickness = 0
    ScrollingFrame.Parent = Tabs

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ScrollingFrame
    
    FrameHolder.Name = "FrameHolder"
    FrameHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    FrameHolder.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    FrameHolder.BorderColor3 = THEMES.BorderColor
    FrameHolder.Position = UDim2.new(0.498, 0,0.533, 0)
    FrameHolder.Size = UDim2.new(0.917, 0,0.859, 0)
    FrameHolder.Parent = MainFrame
    CreateGradient(FrameHolder)

    self.Frames = {
        MainFrame = MainFrame,
        Frame = Frame,
        Title = Title,
        Tabs = Tabs,
        FrameHolder = FrameHolder
    }

    UserInputService.InputBegan:Connect(function(Input, GPE)
        if GPE then return end
        if Input.KeyCode == KeyBind or Input.UserInputType == KeyBind then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    return self
end

-----------------TABS

function  Library:Tab(text: string)
    local ScrollingFrame = self.Frames.Tabs.ScrollingFrame
   
    local Tab = Instance.new("TextButton")
    Tab.Name = text
    Tab.BackgroundColor3 = THEMES.TabColor 
    Tab.BorderColor3 = Color3.fromRGB(112, 112, 112)
    Tab.Size = UDim2.new(0, 47,0, 19)
    Tab.Font = Enum.Font.Code
    Tab.Text = " " .. text .. " "
    Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
    Tab.TextScaled = true
    Tab.TextSize = 14.000
    Tab.TextStrokeTransparency = 0.000
    Tab.TextWrapped = true
    Tab.Parent = ScrollingFrame
    CreateGradient(Tab, -90)

    local Page = Instance.new("ScrollingFrame")
    Page.AnchorPoint = Vector2.new(0.5, 0.5)
    Page.Size = UDim2.fromScale(0.97, 0.97)
    Page.Position = UDim2.fromScale(0.5, 0.5)
    Page.BackgroundColor3 = THEMES.FrameColor
    Page.BackgroundTransparency = 0
    Page.BorderColor3 = THEMES.BorderColor
    Page.ScrollBarThickness = 0
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X 
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
    Page.ScrollBarThickness = 0
    Page.Visible = false
    Page.Parent = self.Frames.FrameHolder
    CreateGradient(Page)

    local LeftColumn = Instance.new("Frame")
    LeftColumn.Name = "LeftColumn"
    LeftColumn.Size = UDim2.new(0.5, -5, 1, 0)
    LeftColumn.Position = UDim2.new(0, 0, 0, 12)
    LeftColumn.BackgroundTransparency = 1
    LeftColumn.Parent = Page
    
    local LeftList = Instance.new("UIListLayout")
    LeftList.Padding = UDim.new(0, 8)
    LeftList.SortOrder = Enum.SortOrder.LayoutOrder
    LeftList.Parent = LeftColumn

    local RightColumn = Instance.new("Frame")
    RightColumn.Name = "RightColumn"
    RightColumn.Size = UDim2.new(0.5, -5, 1, 0)
    RightColumn.Position = UDim2.new(0.5, 5, 0, 12)
    RightColumn.BackgroundTransparency = 1
    RightColumn.Parent = Page

    local RightList = Instance.new("UIListLayout")
    RightList.Padding = UDim.new(0, 8)
    RightList.SortOrder = Enum.SortOrder.LayoutOrder
    RightList.Parent = RightColumn

    local function UpdateCanvas()
        local leftH = LeftList.AbsoluteContentSize.Y
        local rightH = RightList.AbsoluteContentSize.Y
        Page.CanvasSize = UDim2.new(0, 0, 0, math.max(leftH, rightH) + 20)
    end
    LeftList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)
    RightList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)

    
    local con = Tab.MouseButton1Click:Connect(function()
        for _, tab in self.Tabs do
            tab.Page.Visible = false
            tab.Button.BackgroundColor3 = THEMES.TabColor
        end

        Page.Visible = true
        Tab.BackgroundColor3 = THEMES.SelectedTab
    end)
    table.insert(connections, con)

    if #self.Tabs == 0 then
        Page.Visible = true
    end

    table.insert(self.Tabs, {Button = Tab, Page = Page})

    local TabFunctions = {}

    local SectionCount = 0

    function TabFunctions:Section(title: string)
        SectionCount = SectionCount + 1
        
        local ParentFrame = (SectionCount % 2 == 1) and LeftColumn or RightColumn

        local Section = Instance.new("Frame")
        Section.Name = title
        Section.Size = UDim2.new(1, 0, 0, 100)
        Section.BackgroundColor3 = THEMES.MainColor
        Section.BackgroundTransparency = 0.4
        Section.BorderColor3 = THEMES.BorderColor
        Section.BorderMode = Enum.BorderMode.Inset
        Section.Parent = ParentFrame
        CreateGradient(Section)

        local Label = Instance.new("TextLabel")
        Label.Text = " " .. title .. " "
        Label.TextColor3 = THEMES.TextColor
        Label.BackgroundColor3 = THEMES.FrameColor 
        Label.BorderSizePixel = 0
        Label.Position = UDim2.new(0, 10, 0, -8)
        Label.AutomaticSize = Enum.AutomaticSize.XY
        Label.Font = Enum.Font.Code
        Label.TextSize = 12
        Label.ZIndex = 2
        Label.Parent = Section

        local Container = Instance.new("Frame")
        Container.Size = UDim2.new(1, -10, 1, -15)
        Container.Position = UDim2.new(0, 5, 0, 15)
        Container.BackgroundTransparency = 1
        Container.Parent = Section

        local List = Instance.new("UIListLayout")
        List.Padding = UDim.new(0, 5)
        List.SortOrder = Enum.SortOrder.LayoutOrder
        List.Parent = Container

        List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Section.Size = UDim2.new(1, 0, 0, List.AbsoluteContentSize.Y + 25)
        end)

        local SectionFunctions = {}
        local ElementCount = 0

        function SectionFunctions:Button(text, callback)
            ElementCount = ElementCount + 1
            
            callback = callback or function() end
            local Btn = CreateButton()
            Btn.Text = text
            Btn.LayoutOrder = ElementCount
            Btn.Parent = Container

            local con = Btn.MouseButton1Click:Connect(function()
                callback()
                local old = Btn.BorderColor3
                task.wait(0.1)
            end)
            table.insert(connections, con)
        end

        function SectionFunctions:Toggle(text: string, callback: () -> ())
            ElementCount = ElementCount + 1
            
            callback = callback or function() end
            local enabled = false

            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Size = UDim2.new(1, 0, 0, 20)
            ToggleBtn.BackgroundTransparency = 1
            ToggleBtn.Text = ""
            ToggleBtn.LayoutOrder = ElementCount
            ToggleBtn.Parent = Container

            local CheckMark = Instance.new("Frame")
            CheckMark.Size = UDim2.new(0, 12, 0, 12)
            CheckMark.Position = UDim2.new(0, 0, 0.5, -6) 
            CheckMark.BackgroundColor3 = THEMES.FrameColor
            CheckMark.BorderColor3 = THEMES.BorderColor
            CheckMark.Parent = ToggleBtn
            CreateGradient(CheckMark) 

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -20, 1, 0)
            Label.Position = UDim2.new(0, 18, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = THEMES.TextColor
            Label.TextXAlignment = Enum.TextXAlignment.Left 
            Label.Font = Enum.Font.Code
            Label.TextSize = 12
            Label.Parent = ToggleBtn

            local con = ToggleBtn.MouseButton1Click:Connect(function()
                enabled = not enabled
                callback(enabled)
                if enabled then
                    TweenService:Create(CheckMark, TweenInfo.new(0.2), {BackgroundColor3 = THEMES.LineColor}):Play()
                else
                    TweenService:Create(CheckMark, TweenInfo.new(0.2), {BackgroundColor3 = THEMES.FrameColor}):Play()
                end
            end)
            table.insert(connections, con)
        end
        
        function SectionFunctions:Dropdown(text: string, options: table, callback: () -> ())
            ElementCount = ElementCount + 1 
            callback = callback or function() end
            local isDropped = false
            local dropdownOptions = options

            local DropFrame = Instance.new("Frame")
            DropFrame.Size = UDim2.new(1, 0, 0, 30)
            DropFrame.BackgroundTransparency = 1
            DropFrame.ClipsDescendants = true
            DropFrame.LayoutOrder = ElementCount
            DropFrame.Parent = Container
            
            local Header = CreateButton()
            Header.Text = ""
            Header.Parent = DropFrame
            CreateGradient(Header)

            local Title = Instance.new("TextLabel")
            Title.Size = UDim2.new(1, -20, 1, 0)
            Title.Position = UDim2.new(0, 5, 0, 0)
            Title.BackgroundTransparency = 1
            Title.Text = text .. " : Select..."
            Title.TextColor3 = THEMES.TextColor
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Font = Enum.Font.Code
            Title.TextSize = 12
            Title.Parent = Header
            
            local Icon = Instance.new("TextLabel")
            Icon.Size = UDim2.new(0, 20, 1, 0)
            Icon.Position = UDim2.new(1, -20, 0, 0)
            Icon.BackgroundTransparency = 1
            Icon.Text = "+"
            Icon.TextColor3 = THEMES.LineColor
            Icon.Font = Enum.Font.Code
            Icon.Parent = Header
            
            local OptionContainer = Instance.new("Frame")
            OptionContainer.Size = UDim2.new(1, 0, 0, 0)
            OptionContainer.Position = UDim2.new(0, 0, 0, 30)
            OptionContainer.BackgroundTransparency = 1
            OptionContainer.Parent = DropFrame

            local OptionLayout = Instance.new("UIListLayout")
            OptionLayout.Padding = UDim.new(0, 2)
            OptionLayout.Parent = OptionContainer

            local function BuildOptions(newOptions)
                for _, child in OptionContainer:GetChildren() do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end

                dropdownOptions = newOptions 
                
                for _, opt in dropdownOptions do
                    local OptBtn = CreateButton()
                    OptBtn.Text = opt
                    OptBtn.Parent = OptionContainer
                    CreateGradient(OptBtn)
                    
                    table.insert(connections, OptBtn.MouseButton1Click:Connect(function()
                        Title.Text = text .. " : " .. opt
                        isDropped = false
                        Icon.Text = "+"
                        TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 30)}):Play()
                        callback(opt)
                    end))
                end
            end

            BuildOptions(options)

            table.insert(connections, Header.MouseButton1Click:Connect(function()
                isDropped = not isDropped
                if isDropped then
                    Icon.Text = "-"
                    local openHeight = 30 + (#dropdownOptions * 22) + 5
                    TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, openHeight)}):Play()
                else
                    Icon.Text = "+"
                    TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 30)}):Play()
                end
            end))

            local DropdownObject = {}
            function DropdownObject:Refresh(newList)
                BuildOptions(newList)
            end
            
            return DropdownObject
        end

        function SectionFunctions:Label(text: string)
            ElementCount = ElementCount + 1 

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, 20)
            Label.Position = UDim2.fromScale(0.5, 1)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = THEMES.TextColor
            Label.TextXAlignment = Enum.TextXAlignment.Center
            Label.Font = Enum.Font.Code
            Label.TextSize = 12
            Label.LayoutOrder = ElementCount 
            Label.Parent = Container

            return Label
        end

       function SectionFunctions:Slider(text: string, min: number, max: number, default: number, callback: () -> ())
            ElementCount = ElementCount + 1 
            
            default = default or min
            callback = callback or function() end
            local Value = default

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, 0, 0, 35)
            SliderFrame.BackgroundTransparency = 1
            SliderFrame.LayoutOrder = ElementCount
            SliderFrame.Parent = Container

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, 15)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = THEMES.TextColor
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Font = Enum.Font.Code
            Label.TextSize = 12
            Label.Parent = SliderFrame

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(1, 0, 0, 15)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(default)
            ValueLabel.TextColor3 = THEMES.TextColor
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Font = Enum.Font.Code
            ValueLabel.TextSize = 12
            ValueLabel.Parent = SliderFrame

            local SlideBar = Instance.new("TextButton")
            SlideBar.Size = UDim2.new(1, 0, 0, 10)
            SlideBar.Position = UDim2.new(0, 0, 0, 20)
            SlideBar.BackgroundColor3 = THEMES.FrameColor
            SlideBar.BorderColor3 = THEMES.BorderColor
            SlideBar.Text = ""
            SlideBar.AutoButtonColor = false
            SlideBar.Parent = SliderFrame
            CreateGradient(SlideBar)

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            Fill.BackgroundColor3 = THEMES.LineColor
            Fill.BorderSizePixel = 0
            Fill.Parent = SlideBar
            
            local dragging = false

            local function Update(input)
                local SizeX = math.clamp((input.Position.X - SlideBar.AbsolutePosition.X) / SlideBar.AbsoluteSize.X, 0, 1)
                local NewValue = math.floor(min + ((max - min) * SizeX))
                
                Fill.Size = UDim2.new(SizeX, 0, 1, 0)
                ValueLabel.Text = tostring(NewValue)
                
                callback(NewValue)
            end

            local con = SlideBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    Update(input)
                end
            end)
            table.insert(connections, con)
            
           local con = UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
            
            local con =UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Update(input)
                end
            end)
            table.insert(connections, con)
        end

        function SectionFunctions:Bind(text: string, defaultKey: Enum.KeyCode, callback: () -> ())
            ElementCount = ElementCount + 1
            
            callback = callback or function() end
            local CurrentKey = defaultKey or nil
            local isBinding = false

            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Size = UDim2.new(1, 0, 0, 15)
            KeybindFrame.BackgroundTransparency = 1
            KeybindFrame.LayoutOrder = ElementCount
            KeybindFrame.Parent = Container

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -65, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = THEMES.TextColor
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Font = Enum.Font.Code
            Label.TextSize = 12
            Label.Parent = KeybindFrame

            local BindBtn = Instance.new("TextButton")
            BindBtn.Size = UDim2.new(0, 60, 1, 0)
            BindBtn.Position = UDim2.new(1, -60, 0, 0)
            BindBtn.BackgroundColor3 = THEMES.FrameColor
            BindBtn.BorderColor3 = THEMES.BorderColor
            BindBtn.Text = "[" .. (CurrentKey.Name) .. "]"
            BindBtn.TextColor3 = THEMES.TextColor
            BindBtn.Font = Enum.Font.Code
            BindBtn.TextSize = 12
            BindBtn.Parent = KeybindFrame
            CreateGradient(BindBtn)

            local con = BindBtn.MouseButton1Click:Connect(function()
                isBinding = true
                BindBtn.Text = "[...]"
                BindBtn.BorderColor3 = THEMES.LineColor
            end)
            table.insert(connections, con)

            local con = UserInputService.InputBegan:Connect(function(input, processed)
                if isBinding then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        isBinding = false
                        BindBtn.BorderColor3 = THEMES.BorderColor
                        
                        if input.KeyCode == Enum.KeyCode.Backspace then
                            CurrentKey = nil
                            BindBtn.Text = "[None]"
                        else
                            CurrentKey = input.KeyCode
                            BindBtn.Text = "[" .. input.KeyCode.Name .. "]"
                        end
                    end
                elseif not processed and CurrentKey ~= nil and (input.KeyCode == CurrentKey) then
                     callback()
                end
            end)
            table.insert(connections, con)
        end

        function SectionFunctions:ToggleBind(text: string, defaultKey: Enum.KeyCode, callback: () -> ())
            ElementCount = ElementCount + 1
            
            local enabled = false

            callback = callback or function() end
            local CurrentKey = defaultKey or nil
            local isBinding = false

            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Size = UDim2.new(1, 0, 0, 15)
            KeybindFrame.BackgroundTransparency = 1
            KeybindFrame.LayoutOrder = ElementCount
            KeybindFrame.Parent = Container

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -65, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = THEMES.TextColor
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Font = Enum.Font.Code
            Label.TextSize = 12
            Label.Parent = KeybindFrame

            local BindBtn = Instance.new("TextButton")
            BindBtn.Size = UDim2.new(0, 60, 1, 0)
            BindBtn.Position = UDim2.new(1, -60, 0, 0)
            BindBtn.BackgroundColor3 = THEMES.FrameColor
            BindBtn.BorderColor3 = THEMES.BorderColor
            BindBtn.Text = "[" .. (CurrentKey.Name) .. "]"
            BindBtn.TextColor3 = THEMES.TextColor
            BindBtn.Font = Enum.Font.Code
            BindBtn.TextSize = 12
            BindBtn.Parent = KeybindFrame
            CreateGradient(BindBtn)

            local con = BindBtn.MouseButton1Click:Connect(function()
                isBinding = true
                BindBtn.Text = "[...]"
                BindBtn.BorderColor3 = THEMES.LineColor
            end)
            table.insert(connections, con)

            local con = UserInputService.InputBegan:Connect(function(input, processed)
                if isBinding then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        isBinding = false
                        BindBtn.BorderColor3 = THEMES.BorderColor
                        
                        if input.KeyCode == Enum.KeyCode.Backspace then
                            CurrentKey = nil
                            BindBtn.Text = "[None]"
                        else
                            CurrentKey = input.KeyCode
                            BindBtn.Text = "[" .. input.KeyCode.Name .. "]"
                        end
                    end
                elseif not processed and CurrentKey ~= nil and (input.KeyCode == CurrentKey) then
                    enabled = not enabled
                    callback(enabled)

                    if enabled then
                        TweenService:Create(BindBtn, TweenInfo.new(0.2), {BackgroundColor3 = THEMES.LineColor}):Play()
                    else
                        TweenService:Create(BindBtn, TweenInfo.new(0.2), {BackgroundColor3 = THEMES.FrameColor}):Play()
                    end
                end
            end)
            table.insert(connections, con)
        end

        function SectionFunctions:Input(text: string, placeholder: string, callback: () -> ())
            ElementCount = ElementCount + 1
            callback = callback or function() end

            local InputFrame = Instance.new("Frame")
            InputFrame.Size = UDim2.new(1, 0, 0, 40)
            InputFrame.BackgroundTransparency = 1
            InputFrame.LayoutOrder = ElementCount
            InputFrame.Parent = Container

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, 15)
            Label.Position = UDim2.new(0, 0, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = THEMES.TextColor
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Font = Enum.Font.Code
            Label.TextSize = 12
            Label.Parent = InputFrame

            local InputBox = Instance.new("TextBox")
            InputBox.Size = UDim2.new(1, 0, 0, 20)
            InputBox.Position = UDim2.new(0, 0, 0, 18)
            InputBox.BackgroundColor3 = THEMES.FrameColor
            InputBox.BorderColor3 = THEMES.BorderColor
            InputBox.Text = ""
            InputBox.PlaceholderText = placeholder or "..."
            InputBox.TextColor3 = THEMES.TextColor
            InputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
            InputBox.Font = Enum.Font.Code
            InputBox.TextSize = 12
            InputBox.Parent = InputFrame
            CreateGradient(InputBox)

            local con = InputBox.FocusLost:Connect(function()
                callback(InputBox.Text)
                local old = InputBox.BorderColor3
                InputBox.BorderColor3 = THEMES.LineColor
                task.wait(0.1)
                InputBox.BorderColor3 = old
            end)
            table.insert(connections, con)
        end

        function SectionFunctions:CreateButtonRow(text1: string, callback1: () -> (), text2: string, callback2: () -> ())
            ElementCount = ElementCount + 1
            callback1 = callback1 or function() end
            callback2 = callback2 or function() end

            local RowFrame = Instance.new("Frame")
            RowFrame.Size = UDim2.new(1, 0, 0, 22)
            RowFrame.BackgroundTransparency = 1
            RowFrame.LayoutOrder = ElementCount
            RowFrame.Parent = Container

            local Btn1 = CreateButton()
            Btn1.Size = UDim2.new(0.5, -3, 1, 0)
            Btn1.Position = UDim2.new(0, 0, 0, 0)
            Btn1.Text = text1
            Btn1.Parent = RowFrame
            CreateGradient(Btn1)

            local Btn2 = CreateButton()
            Btn2.Size = UDim2.new(0.5, -3, 1, 0)
            Btn2.Position = UDim2.new(0.5, 3, 0, 0)
            Btn2.Text = text2
            Btn2.Parent = RowFrame
            CreateGradient(Btn2)

            local con1 = Btn1.MouseButton1Click:Connect(function()
                callback1()
                local old = Btn1.BorderColor3
            end)
            table.insert(connections, con1)

            local con2 = Btn2.MouseButton1Click:Connect(function()
                callback2()
            end)
            table.insert(connections, con2)
        end

        function SectionFunctions:ColorPicker(text, defaultColor, callback)
            ElementCount = ElementCount + 1
            callback = callback or function() end
            defaultColor = defaultColor or Color3.fromRGB(255, 255, 255)
            
            local h, s, v = Color3.toHSV(defaultColor)
            local isOpen = false

            local PickerFrame = Instance.new("Frame")
            PickerFrame.Size = UDim2.new(1, 0, 0, 30)
            PickerFrame.BackgroundTransparency = 1
            PickerFrame.ClipsDescendants = true
            PickerFrame.LayoutOrder = ElementCount
            PickerFrame.Parent = Container

            local Header = CreateButton()
            Header.Text = ""
            Header.Parent = PickerFrame
            CreateGradient(Header)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -40, 1, 0)
            Label.Position = UDim2.new(0, 5, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = THEMES.TextColor
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Font = Enum.Font.Code
            Label.TextSize = 12
            Label.Parent = Header

            local CurrentColorFrame = Instance.new("Frame")
            CurrentColorFrame.Size = UDim2.new(0, 20, 0, 12)
            CurrentColorFrame.Position = UDim2.new(1, -25, 0.5, -6)
            CurrentColorFrame.BackgroundColor3 = defaultColor
            CurrentColorFrame.BorderColor3 = THEMES.BorderColor
            CurrentColorFrame.Parent = Header
            
            local Body = Instance.new("Frame")
            Body.Size = UDim2.new(1, 0, 0, 150)
            Body.Position = UDim2.new(0, 0, 0, 30)
            Body.BackgroundTransparency = 1
            Body.Parent = PickerFrame

            local SVBox = Instance.new("TextButton")
            SVBox.Size = UDim2.new(0, 130, 0, 130)
            SVBox.Position = UDim2.new(0, 10, 0, 10)
            SVBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            SVBox.BorderColor3 = THEMES.BorderColor
            SVBox.Text = ""
            SVBox.AutoButtonColor = false
            SVBox.Parent = Body

            local SatGradient = Instance.new("UIGradient")
            SatGradient.Color = ColorSequence.new(Color3.new(1,1,1), Color3.new(1,1,1))
            SatGradient.Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1)
            }
            SatGradient.Parent = SVBox
            
            local ValOverlay = Instance.new("Frame")
            ValOverlay.Size = UDim2.new(1, 0, 1, 0)
            ValOverlay.BackgroundColor3 = Color3.new(0,0,0)
            ValOverlay.BackgroundTransparency = 0 
            ValOverlay.BorderSizePixel = 0
            ValOverlay.ZIndex = 2
            ValOverlay.Parent = SVBox
            
            local ValGradient = Instance.new("UIGradient")
            ValGradient.Rotation = 90
            ValGradient.Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(1, 0)
            }
            ValGradient.Parent = ValOverlay

            local SVCursor = Instance.new("Frame")
            SVCursor.Size = UDim2.new(0, 4, 0, 4)
            SVCursor.BackgroundColor3 = Color3.new(1,1,1)
            SVCursor.BorderColor3 = Color3.new(0,0,0)
            SVCursor.Rotation = 45
            SVCursor.ZIndex = 3
            SVCursor.Parent = SVBox

            local HueBar = Instance.new("TextButton")
            HueBar.Size = UDim2.new(0, 15, 0, 130)
            HueBar.Position = UDim2.new(0, 150, 0, 10)
            HueBar.BackgroundColor3 = Color3.new(1,1,1)
            HueBar.BorderColor3 = THEMES.BorderColor
            HueBar.Text = ""
            HueBar.AutoButtonColor = false
            HueBar.Parent = Body

            local HueGradient = Instance.new("UIGradient")
            HueGradient.Rotation = 90
            HueGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0.00, Color3.fromHSV(1,1,1)),
                ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.83,1,1)),
                ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.66,1,1)),
                ColorSequenceKeypoint.new(0.50, Color3.fromHSV(0.5,1,1)),
                ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.33,1,1)),
                ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.16,1,1)),
                ColorSequenceKeypoint.new(1.00, Color3.fromHSV(0,1,1))
            }
            HueGradient.Parent = HueBar
            
            local HueCursor = Instance.new("Frame")
            HueCursor.Size = UDim2.new(1, 0, 0, 2)
            HueCursor.BackgroundColor3 = Color3.new(1,1,1)
            HueCursor.BorderColor3 = Color3.new(0,0,0)
            HueCursor.Parent = HueBar

            local function UpdateColor()
                local newColor = Color3.fromHSV(h, s, v)
                CurrentColorFrame.BackgroundColor3 = newColor
                SVBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1) 
                callback(newColor)
            end

            local draggingSV, draggingHue = false, false

            local function UpdateSV(input)
                local size = SVBox.AbsoluteSize
                local pos = SVBox.AbsolutePosition
                
                local x = math.clamp((input.Position.X - pos.X) / size.X, 0, 1)
                local y = math.clamp((input.Position.Y - pos.Y) / size.Y, 0, 1)
                
                s = 1 - x 
                v = 1 - y
                
                SVCursor.Position = UDim2.new(x, -2, y, -2)
                UpdateColor()
            end

            local function UpdateHue(input)
                local size = HueBar.AbsoluteSize
                local pos = HueBar.AbsolutePosition
                
                local y = math.clamp((input.Position.Y - pos.Y) / size.Y, 0, 1)
                h = 1 - y
                
                HueCursor.Position = UDim2.new(0, 0, y, 0)
                UpdateColor()
            end

            SVCursor.Position = UDim2.new(1-s, -2, 1-v, -2)
            HueCursor.Position = UDim2.new(0, 0, 1-h, 0)

            local con1 = SVBox.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSV = true
                    UpdateSV(input)
                end
            end)
            table.insert(connections, con1)
            
            local con2 = HueBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingHue = true
                    UpdateHue(input)
                end
            end)
            table.insert(connections, con2)

            local con3 = UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    if draggingSV then UpdateSV(input) end
                    if draggingHue then UpdateHue(input) end
                end
            end)
            table.insert(connections, con3)

            local con4 = UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSV = false
                    draggingHue = false
                end
            end)
            table.insert(connections, con4)

            local con = Header.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    TweenService:Create(PickerFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 180)}):Play()
                else
                    TweenService:Create(PickerFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 30)}):Play()
                end
            end)
            table.insert(connections, con)
        end

	    function SectionFunctions:ToggleInput(text, defaultState, defaultKey, callback)
			ElementCount = ElementCount + 1
			callback = callback or function() end
			defaultState = defaultState or false
			defaultKey = defaultKey or Enum.KeyCode.Unknown

			local enabled = defaultState
			local CurrentKey = defaultKey
			local isBinding = false

			local MainFrame = Instance.new("Frame")
			MainFrame.Size = UDim2.new(1, 0, 0, 20)
			MainFrame.BackgroundTransparency = 1
			MainFrame.LayoutOrder = ElementCount
			MainFrame.Parent = Container

			local ToggleBtn = Instance.new("TextButton")
			ToggleBtn.Size = UDim2.new(1, -70, 1, 0) 
			ToggleBtn.BackgroundTransparency = 1
			ToggleBtn.Text = ""
			ToggleBtn.Parent = MainFrame

			local CheckMark = Instance.new("Frame")
			CheckMark.Size = UDim2.new(0, 12, 0, 12)
			CheckMark.Position = UDim2.new(0, 0, 0.5, -6)
			CheckMark.BackgroundColor3 = enabled and THEMES.LineColor or THEMES.FrameColor
			CheckMark.BorderColor3 = THEMES.BorderColor
			CheckMark.Parent = ToggleBtn
			CreateGradient(CheckMark)

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(1, -20, 1, 0)
			Label.Position = UDim2.new(0, 18, 0, 0)
			Label.BackgroundTransparency = 1
			Label.Text = text
			Label.TextColor3 = THEMES.TextColor
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Font = Enum.Font.Code
			Label.TextSize = 12
			Label.Parent = ToggleBtn

			local BindBtn = Instance.new("TextButton")
			BindBtn.Size = UDim2.new(0, 60, 1, 0)
			BindBtn.Position = UDim2.new(1, -60, 0, 0)
			BindBtn.BackgroundColor3 = THEMES.FrameColor
			BindBtn.BorderColor3 = THEMES.BorderColor
			BindBtn.Text = (CurrentKey.Name == "None") and "[None]" or "[" .. CurrentKey.Name .. "]"
			BindBtn.TextColor3 = THEMES.TextColor
			BindBtn.Font = Enum.Font.Code
			BindBtn.TextSize = 12
			BindBtn.Parent = MainFrame
			CreateGradient(BindBtn)

			local function UpdateToggle()
				enabled = not enabled
				callback(enabled)

				if enabled then
					TweenService:Create(CheckMark, TweenInfo.new(0.2), {BackgroundColor3 = THEMES.LineColor}):Play()
				else
					TweenService:Create(CheckMark, TweenInfo.new(0.2), {BackgroundColor3 = THEMES.FrameColor}):Play()
				end
			end

			ToggleBtn.MouseButton1Click:Connect(UpdateToggle)

			BindBtn.MouseButton1Click:Connect(function()
				isBinding = true
				BindBtn.Text = "[...]"
				BindBtn.BorderColor3 = THEMES.LineColor
			end)

			local InputConnection
			InputConnection = UserInputService.InputBegan:Connect(function(input, processed)
				if isBinding then
					if input.UserInputType == Enum.UserInputType.Keyboard then
						isBinding = false
						BindBtn.BorderColor3 = THEMES.BorderColor

						if input.KeyCode == Enum.KeyCode.Backspace then
							CurrentKey = Enum.KeyCode.Unknown
							BindBtn.Text = "[...]"
						else
							CurrentKey = input.KeyCode
							BindBtn.Text = "[" .. input.KeyCode.Name .. "]"
						end
					end
				elseif not processed and input.KeyCode == CurrentKey and CurrentKey ~= Enum.KeyCode.Unknown then
					UpdateToggle()
				end
			end)

			MainFrame.Destroying:Connect(function()
				if InputConnection then InputConnection:Disconnect() end
			end)
		end

        return SectionFunctions
    end

    function TabFunctions:Config(callbacks)
        callbacks = callbacks or {} 
        
        local Section = TabFunctions:Section("Config")
        
        Section:Input("Config Name", "Type name...", function(text)
            if callbacks.Input then callbacks.Input(text) end
        end)

        Section:Dropdown("Select Config", callbacks.List or {}, function(val)
            if callbacks.Dropdown then callbacks.Dropdown(val) end
        end)

        Section:CreateButtonRow("Load", function()
            if callbacks.Load then callbacks.Load() end
        end, "Save", function()
            if callbacks.Save then callbacks.Save() end
        end)
        
        Section:CreateButtonRow("Create", function()
            if callbacks.Create then callbacks.Create() end
        end, "Delete", function()
            if callbacks.Delete then callbacks.Delete() end
        end)
    end

    return TabFunctions
end


return Library