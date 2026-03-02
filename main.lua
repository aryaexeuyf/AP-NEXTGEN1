--[[
    AP-NEXTGEN HUB PREMIUM v3.0
    Ultra Modern UI | Mobile Optimized | Feature Rich
    Created for: aryaexeuyf
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Config
local Config = {
    Speed = 16,
    FlySpeed = 100,
    GodMode = false,
    AutoExecute = false,
    Theme = "Dark",
    UIScale = 1
}

-- State
local States = {
    GUIVisible = true,
    Minimized = false,
    Noclip = false,
    Flying = false,
    ESP = false,
    AutoFollow = false,
    FollowingPlayer = nil,
    MobileButtons = false,
    CurrentTab = "Main"
}

-- Modern Color Palettes
local Themes = {
    Dark = {
        Background = Color3.fromRGB(10, 10, 15),
        Surface = Color3.fromRGB(20, 20, 28),
        SurfaceLight = Color3.fromRGB(30, 30, 40),
        Primary = Color3.fromRGB(0, 170, 255),
        PrimaryDark = Color3.fromRGB(0, 120, 200),
        Secondary = Color3.fromRGB(140, 80, 255),
        Success = Color3.fromRGB(0, 230, 120),
        Warning = Color3.fromRGB(255, 180, 0),
        Error = Color3.fromRGB(255, 60, 80),
        Text = Color3.fromRGB(255, 255, 255),
        TextMuted = Color3.fromRGB(150, 150, 170),
        Glow = Color3.fromRGB(0, 170, 255)
    },
    Neon = {
        Background = Color3.fromRGB(5, 5, 10),
        Surface = Color3.fromRGB(15, 15, 25),
        SurfaceLight = Color3.fromRGB(25, 25, 40),
        Primary = Color3.fromRGB(255, 0, 128),
        PrimaryDark = Color3.fromRGB(200, 0, 100),
        Secondary = Color3.fromRGB(0, 255, 255),
        Success = Color3.fromRGB(0, 255, 150),
        Warning = Color3.fromRGB(255, 200, 0),
        Error = Color3.fromRGB(255, 50, 100),
        Text = Color3.fromRGB(255, 255, 255),
        TextMuted = Color3.fromRGB(180, 180, 200),
        Glow = Color3.fromRGB(255, 0, 128)
    }
}

local Theme = Themes.Dark

-- Utility Functions
local function Tween(obj, props, dur, style, dir)
    return TweenService:Create(obj, TweenInfo.new(dur or 0.3, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props)
end

local function Round(parent, rad)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, rad or 8)
    c.Parent = parent
    return c
end

local function Stroke(parent, col, thick)
    local s = Instance.new("UIStroke")
    s.Color = col or Theme.Primary
    s.Thickness = thick or 1
    s.Parent = parent
    return s
end

local function Glow(parent, col, size)
    local g = Instance.new("ImageLabel")
    g.Name = "Glow"
    g.BackgroundTransparency = 1
    g.Position = UDim2.new(0.5, 0, 0.5, 0)
    g.AnchorPoint = Vector2.new(0.5, 0.5)
    g.Size = UDim2.new(1, size or 30, 1, size or 30)
    g.ZIndex = parent.ZIndex - 1
    g.Image = "rbxassetid://6015897843"
    g.ImageColor3 = col or Theme.Primary
    g.ImageTransparency = 0.7
    g.ScaleType = Enum.ScaleType.Slice
    g.SliceCenter = Rect.new(49, 49, 450, 450)
    g.Parent = parent
    return g
end

local function Ripple(btn)
    local ripple = Instance.new("Frame")
    ripple.BackgroundColor3 = Color3.new(1, 1, 1)
    ripple.BackgroundTransparency = 0.6
    ripple.BorderSizePixel = 0
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    Round(ripple, 100)
    ripple.Parent = btn
    
    Tween(ripple, {Size = UDim2.new(2, 0, 2, 0), BackgroundTransparency = 1}, 0.5):Play()
    game:GetService("Debris"):AddItem(ripple, 0.5)
end

-- Main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "APNEXTGEN_PREMIUM"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Minimized Orb Button (Floating)
local OrbButton = Instance.new("ImageButton")
OrbButton.Name = "OrbButton"
OrbButton.Size = UDim2.new(0, 55, 0, 55)
OrbButton.Position = UDim2.new(0, 20, 0.5, -27)
OrbButton.BackgroundColor3 = Theme.Surface
OrbButton.Image = ""
OrbButton.Visible = false
OrbButton.ZIndex = 100
Round(OrbButton, 28)
Stroke(OrbButton, Theme.Primary, 2)
Glow(OrbButton, Theme.Primary, 40)
OrbButton.Parent = ScreenGui

-- Logo Text on Orb
local OrbLogo = Instance.new("TextLabel")
OrbLogo.Size = UDim2.new(1, 0, 1, 0)
OrbLogo.BackgroundTransparency = 1
OrbLogo.Text = "G"
OrbLogo.TextColor3 = Theme.Primary
OrbLogo.TextSize = 24
OrbLogo.Font = Enum.Font.GothamBlack
OrbLogo.Parent = OrbButton

-- Notification Badge
local Badge = Instance.new("Frame")
Badge.Name = "Badge"
Badge.Size = UDim2.new(0, 18, 0, 18)
Badge.Position = UDim2.new(1, -10, 0, -5)
Badge.BackgroundColor3 = Theme.Error
Badge.Visible = false
Round(Badge, 9)
Badge.Parent = OrbButton

local BadgeText = Instance.new("TextLabel")
BadgeText.Size = UDim2.new(1, 0, 1, 0)
BadgeText.BackgroundTransparency = 1
BadgeText.Text = "!"
BadgeText.TextColor3 = Color3.new(1, 1, 1)
BadgeText.TextSize = 12
BadgeText.Font = Enum.Font.GothamBold
BadgeText.Parent = Badge

-- Main Container (Compact & Elegant)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 380, 0, 480)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -240)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Round(MainFrame, 16)
Glow(MainFrame, Theme.Primary, 60)
MainFrame.Parent = ScreenGui

-- Gradient Background
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.Background),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
})
Gradient.Rotation = 45
Gradient.Parent = MainFrame

-- Top Bar (Glassmorphism)
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Theme.Surface
TopBar.BackgroundTransparency = 0.3
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
Round(TopBar, 16)

local TopBarFix = Instance.new("Frame")
TopBarFix.Size = UDim2.new(1, 0, 0, 20)
TopBarFix.Position = UDim2.new(0, 0, 1, -20)
TopBarFix.BackgroundColor3 = Theme.Surface
TopBarFix.BackgroundTransparency = 0.3
TopBarFix.BorderSizePixel = 0
TopBarFix.Parent = TopBar

-- Logo Icon
local LogoIcon = Instance.new("Frame")
LogoIcon.Size = UDim2.new(0, 28, 0, 28)
LogoIcon.Position = UDim2.new(0, 12, 0.5, -14)
LogoIcon.BackgroundColor3 = Theme.Primary
Round(LogoIcon, 6)
LogoIcon.Parent = TopBar

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(1, 0, 1, 0)
LogoText.BackgroundTransparency = 1
LogoText.Text = "G1"
LogoText.TextColor3 = Color3.new(1, 1, 1)
LogoText.TextSize = 14
LogoText.Font = Enum.Font.GothamBlack
LogoText.Parent = LogoIcon

-- Title Group
local TitleGroup = Instance.new("Frame")
TitleGroup.Size = UDim2.new(0, 150, 1, 0)
TitleGroup.Position = UDim2.new(0, 48, 0, 0)
TitleGroup.BackgroundTransparency = 1
TitleGroup.Parent = TopBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, 0, 0.6, 0)
TitleText.Position = UDim2.new(0, 0, 0.1, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "GEN1"
TitleText.TextColor3 = Theme.Text
TitleText.TextSize = 16
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleGroup

local SubTitleText = Instance.new("TextLabel")
SubTitleText.Size = UDim2.new(1, 0, 0.4, 0)
SubTitleText.Position = UDim2.new(0, 0, 0.55, 0)
SubTitleText.BackgroundTransparency = 1
SubTitleText.Text = "PREMIUM"
SubTitleText.TextColor3 = Theme.Primary
SubTitleText.TextSize = 10
SubTitleText.Font = Enum.Font.Gotham
SubTitleText.TextXAlignment = Enum.TextXAlignment.Left
SubTitleText.Parent = TitleGroup

-- Window Controls
local Controls = Instance.new("Frame")
Controls.Size = UDim2.new(0, 70, 0, 30)
Controls.Position = UDim2.new(1, -75, 0.5, -15)
Controls.BackgroundTransparency = 1
Controls.Parent = TopBar

local MinimizeBtn = Instance.new("ImageButton")
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(0, 0, 0.5, -14)
MinimizeBtn.BackgroundColor3 = Theme.SurfaceLight
MinimizeBtn.Image = "rbxassetid://3926307971"
MinimizeBtn.ImageColor3 = Theme.TextMuted
MinimizeBtn.ImageRectOffset = Vector2.new(884, 284)
MinimizeBtn.ImageRectSize = Vector2.new(36, 36)
Round(MinimizeBtn, 6)
MinimizeBtn.Parent = Controls

local CloseBtn = Instance.new("ImageButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(0, 36, 0.5, -14)
CloseBtn.BackgroundColor3 = Theme.Error
CloseBtn.Image = "rbxassetid://3926307971"
CloseBtn.ImageColor3 = Color3.new(1, 1, 1)
CloseBtn.ImageRectOffset = Vector2.new(924, 724)
CloseBtn.ImageRectSize = Vector2.new(36, 36)
Round(CloseBtn, 6)
CloseBtn.Parent = Controls

-- Tab Navigation (Modern Pills)
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, -20, 0, 35)
TabBar.Position = UDim2.new(0, 10, 0, 50)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame

local TabList = Instance.new("UIListLayout")
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.Padding = UDim.new(0, 8)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabList.Parent = TabBar

local Tabs = {}
local TabContents = {}

local function CreateTab(name, icon)
    local Tab = Instance.new("TextButton")
    Tab.Name = name .. "Tab"
    Tab.Size = UDim2.new(0, 0, 1, 0)
    Tab.AutomaticSize = Enum.AutomaticSize.X
    Tab.BackgroundColor3 = States.CurrentTab == name and Theme.Primary or Theme.Surface
    Tab.Text = "  " .. icon .. "  " .. name .. "  "
    Tab.TextColor3 = States.CurrentTab == name and Color3.new(1, 1, 1) or Theme.TextMuted
    Tab.TextSize = 11
    Tab.Font = Enum.Font.GothamBold
    Tab.AutoButtonColor = false
    Round(Tab, 17)
    Tab.Parent = TabBar
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 12)
    Padding.PaddingRight = UDim.new(0, 12)
    Padding.Parent = Tab
    
    Tabs[name] = Tab
    
    -- Content
    local Content = Instance.new("ScrollingFrame")
    Content.Name = name .. "Content"
    Content.Size = UDim2.new(1, -20, 1, -100)
    Content.Position = UDim2.new(0, 10, 0, 90)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.ScrollBarThickness = 3
    Content.ScrollBarImageColor3 = Theme.Primary
    Content.CanvasSize = UDim2.new(0, 0, 0, 600)
    Content.Visible = States.CurrentTab == name
    Content.Parent = MainFrame
    
    local List = Instance.new("UIListLayout")
    List.Padding = UDim.new(0, 10)
    List.Parent = Content
    
    TabContents[name] = Content
    
    Tab.MouseButton1Click:Connect(function()
        if States.CurrentTab == name then return end
        
        -- Animate old tab
        local oldTab = Tabs[States.CurrentTab]
        Tween(oldTab, {BackgroundColor3 = Theme.Surface, TextColor3 = Theme.TextMuted}, 0.2)
        TabContents[States.CurrentTab].Visible = false
        
        -- Animate new tab
        States.CurrentTab = name
        Tween(Tab, {BackgroundColor3 = Theme.Primary, TextColor3 = Color3.new(1, 1, 1)}, 0.2)
        Content.Visible = true
        
        -- Slide animation
        Content.Position = UDim2.new(0.05, 0, 0, 90)
        Tween(Content, {Position = UDim2.new(0, 10, 0, 90)}, 0.3, Enum.EasingStyle.Back)
    end)
    
    return Content
end

-- Create Tabs
local MainTab = CreateTab("Main", "⚡")
local PlayerTab = CreateTab("Player", "👤")
local VisualTab = CreateTab("Visual", "👁️")
local TeleportTab = CreateTab("Teleport", "🎯")
local SettingsTab = CreateTab("Settings", "⚙️")

-- Component: Modern Card
local function CreateCard(parent, title)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 0)
    Card.AutomaticSize = Enum.AutomaticSize.Y
    Card.BackgroundColor3 = Theme.Surface
    Card.BackgroundTransparency = 0.5
    Card.BorderSizePixel = 0
    Round(Card, 12)
    Card.Parent = parent
    
    local CardStroke = Stroke(Card, Color3.fromRGB(40, 40, 50), 1)
    
    local CardTitle = Instance.new("TextLabel")
    CardTitle.Size = UDim2.new(1, -20, 0, 30)
    CardTitle.Position = UDim2.new(0, 15, 0, 10)
    CardTitle.BackgroundTransparency = 1
    CardTitle.Text = title
    CardTitle.TextColor3 = Theme.Text
    CardTitle.TextSize = 13
    CardTitle.Font = Enum.Font.GothamBold
    CardTitle.TextXAlignment = Enum.TextXAlignment.Left
    CardTitle.Parent = Card
    
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, -30, 0, 1)
    Divider.Position = UDim2.new(0, 15, 0, 38)
    Divider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Divider.BorderSizePixel = 0
    Divider.Parent = Card
    
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -30, 0, 0)
    Container.Position = UDim2.new(0, 15, 0, 45)
    Container.AutomaticSize = Enum.AutomaticSize.Y
    Container.BackgroundTransparency = 1
    Container.Parent = Card
    
    local List = Instance.new("UIListLayout")
    List.Padding = UDim.new(0, 8)
    List.Parent = Container
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingBottom = UDim.new(0, 15)
    Padding.Parent = Card
    
    return Card, Container
end

-- Component: Modern Toggle
local function CreateModernToggle(parent, text, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.TextSize = 12
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    local ToggleBg = Instance.new("Frame")
    ToggleBg.Size = UDim2.new(0, 50, 0, 26)
    ToggleBg.Position = UDim2.new(1, -50, 0.5, -13)
    ToggleBg.BackgroundColor3 = default and Theme.Success or Color3.fromRGB(60, 60, 70)
    Round(ToggleBg, 13)
    ToggleBg.Parent = ToggleFrame
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 22, 0, 22)
    ToggleCircle.Position = default and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
    ToggleCircle.BackgroundColor3 = Color3.new(1, 1, 1)
    Round(ToggleCircle, 11)
    ToggleCircle.Parent = ToggleBg
    
    local enabled = default
    
    local function Toggle()
        enabled = not enabled
        Tween(ToggleBg, {BackgroundColor3 = enabled and Theme.Success or Color3.fromRGB(60, 60, 70)}, 0.2)
        Tween(ToggleCircle, {Position = enabled and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)}, 0.2)
        if callback then callback(enabled) end
    end
    
    ToggleBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Toggle()
        end
    end)
    
    return ToggleFrame, Toggle
end

-- Component: Modern Slider
local function CreateModernSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 55)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.TextSize = 12
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame
    
    local ValueBox = Instance.new("TextBox")
    ValueBox.Size = UDim2.new(0, 50, 0, 24)
    ValueBox.Position = UDim2.new(1, -50, 0, 0)
    ValueBox.BackgroundColor3 = Theme.SurfaceLight
    ValueBox.Text = tostring(default)
    ValueBox.TextColor3 = Theme.Primary
    ValueBox.TextSize = 12
    ValueBox.Font = Enum.Font.GothamBold
    ValueBox.ClearTextOnFocus = false
    Round(ValueBox, 6)
    ValueBox.Parent = SliderFrame
    
    local SliderTrack = Instance.new("Frame")
    SliderTrack.Size = UDim2.new(1, 0, 0, 6)
    SliderTrack.Position = UDim2.new(0, 0, 0, 38)
    SliderTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    SliderTrack.BorderSizePixel = 0
    Round(SliderTrack, 3)
    SliderTrack.Parent = SliderFrame
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Theme.Primary
    SliderFill.BorderSizePixel = 0
    Round(SliderFill, 3)
    SliderFill.Parent = SliderTrack
    
    local SliderKnob = Instance.new("Frame")
    SliderKnob.Size = UDim2.new(0, 16, 0, 16)
    SliderKnob.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    SliderKnob.BackgroundColor3 = Color3.new(1, 1, 1)
    Round(SliderKnob, 8)
    SliderKnob.Parent = SliderTrack
    
    local Glow = Instance.new("ImageLabel")
    Glow.Size = UDim2.new(1.5, 0, 1.5, 0)
    Glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Glow.AnchorPoint = Vector2.new(0.5, 0.5)
    Glow.BackgroundTransparency = 1
    Glow.Image = "rbxassetid://6015897843"
    Glow.ImageColor3 = Theme.Primary
    Glow.ImageTransparency = 0.8
    Glow.ScaleType = Enum.ScaleType.Slice
    Glow.SliceCenter = Rect.new(49, 49, 450, 450)
    Glow.Parent = SliderKnob
    
    local dragging = false
    
    local function update(input)
        local pos = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        
        ValueBox.Text = tostring(val)
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        SliderKnob.Position = UDim2.new(pos, -8, 0.5, -8)
        
        if callback then callback(val) end
        return val
    end
    
    SliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    ValueBox.FocusLost:Connect(function()
        local val = math.clamp(tonumber(ValueBox.Text) or default, min, max)
        ValueBox.Text = tostring(val)
        local pos = (val - min) / (max - min)
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        SliderKnob.Position = UDim2.new(pos, -8, 0.5, -8)
        if callback then callback(val) end
    end)
    
    return SliderFrame
end

-- Component: Modern Button
local function CreateModernButton(parent, text, style, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = style == "primary" and Theme.Primary or (style == "danger" and Theme.Error or Theme.SurfaceLight)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    Round(btn, 8)
    btn.Parent = parent
    
    local stroke = style == "primary" and Stroke(btn, Theme.Primary, 0) or Stroke(btn, Color3.fromRGB(60, 60, 70), 1)
    
    btn.MouseEnter:Connect(function()
        Tween(btn, {BackgroundColor3 = btn.BackgroundColor3:Lerp(Color3.new(1,1,1), 0.1)}, 0.2)
    end)
    
    btn.MouseLeave:Connect(function()
        Tween(btn, {BackgroundColor3 = style == "primary" and Theme.Primary or (style == "danger" and Theme.Error or Theme.SurfaceLight)}, 0.2)
    end)
    
    btn.MouseButton1Down:Connect(function()
        Tween(btn, {Size = UDim2.new(0.98, 0, 0, 36)}, 0.1)
        Ripple(btn)
    end)
    
    btn.MouseButton1Up:Connect(function()
        Tween(btn, {Size = UDim2.new(1, 0, 0, 38)}, 0.1)
    end)
    
    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    return btn
end

-- ============== FEATURES ==============

-- MAIN TAB FEATURES
local SpeedCard, SpeedCont = CreateCard(MainTab, "MOVEMENT SPEED")
CreateModernSlider(SpeedCont, "WalkSpeed", 16, 500, 50, function(val)
    Config.Speed = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)

CreateModernButton(SpeedCont, "Reset to Default", "normal", function()
    Config.Speed = 16
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- Fly Controls
local FlyCard, FlyCont = CreateCard(MainTab, "FLY CONTROL")
CreateModernSlider(FlyCont, "Fly Speed", 10, 300, 100, function(val)
    Config.FlySpeed = val
end)

local FlyToggle, FlyToggleFunc = CreateModernToggle(FlyCont, "Enable Fly", false, function(enabled)
    States.Flying = enabled
    -- Fly logic handled below
end)

-- Mobile Fly Controls
local MobileFlyFrame = Instance.new("Frame")
MobileFlyFrame.Size = UDim2.new(0, 200, 0, 200)
MobileFlyFrame.Position = UDim2.new(0.5, -100, 0.7, -100)
MobileFlyFrame.BackgroundColor3 = Theme.Surface
MobileFlyFrame.BackgroundTransparency = 0.3
MobileFlyFrame.Visible = false
MobileFlyFrame.ZIndex = 50
Round(MobileFlyFrame, 20)
Stroke(MobileFlyFrame, Theme.Primary, 2)
MobileFlyFrame.Parent = ScreenGui

local MobileTitle = Instance.new("TextLabel")
MobileTitle.Size = UDim2.new(1, 0, 0, 30)
MobileTitle.BackgroundTransparency = 1
MobileTitle.Text = "FLY CONTROLS"
MobileTitle.TextColor3 = Theme.Primary
MobileTitle.TextSize = 14
MobileTitle.Font = Enum.Font.GothamBold
MobileTitle.Parent = MobileFlyFrame

local CloseMobile = Instance.new("TextButton")
CloseMobile.Size = UDim2.new(0, 30, 0, 30)
CloseMobile.Position = UDim2.new(1, -35, 0, 5)
CloseMobile.BackgroundColor3 = Theme.Error
CloseMobile.Text = "×"
CloseMobile.TextColor3 = Color3.new(1, 1, 1)
CloseMobile.TextSize = 20
CloseMobile.Font = Enum.Font.GothamBold
Round(CloseMobile, 6)
CloseMobile.Parent = MobileFlyFrame

CloseMobile.MouseButton1Click:Connect(function()
    MobileFlyFrame.Visible = false
    States.MobileButtons = false
end)

-- D-Pad Controls
local function CreateFlyButton(name, pos, dir)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.Position = pos
    btn.BackgroundColor3 = Theme.SurfaceLight
    btn.Text = dir
    btn.TextColor3 = Theme.Text
    btn.TextSize = 20
    btn.Font = Enum.Font.GothamBold
    Round(btn, 10)
    btn.Parent = MobileFlyFrame
    
    btn.MouseButton1Down:Connect(function()
        Tween(btn, {BackgroundColor3 = Theme.Primary}, 0.1)
    end)
    
    btn.MouseButton1Up:Connect(function()
        Tween(btn, {BackgroundColor3 = Theme.SurfaceLight}, 0.1)
    end)
    
    return btn
end

CreateFlyButton("Up", UDim2.new(0.5, -25, 0, 40), "↑")
CreateFlyButton("Down", UDim2.new(0.5, -25, 1, -90), "↓")
CreateFlyButton("Forward", UDim2.new(0.5, -25, 0.5, -25), "W")
CreateFlyButton("Left", UDim2.new(0, 10, 0.5, -25), "←")
CreateFlyButton("Right", UDim2.new(1, -60, 0.5, -25), "→")
CreateFlyButton("Back", UDim2.new(0.5, -25, 0.5, 35), "S")

CreateModernButton(FlyCont, "Show Mobile Controls", "primary", function()
    MobileFlyFrame.Visible = not MobileFlyFrame.Visible
    States.MobileButtons = MobileFlyFrame.Visible
end)

-- PLAYER TAB
local GodCard, GodCont = CreateCard(PlayerTab, "GOD MODE")
CreateModernToggle(GodCont, "Enable God Mode", false, function(enabled)
    Config.GodMode = enabled
    spawn(function()
        while Config.GodMode and wait(0.1) do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.MaxHealth = math.huge
                LocalPlayer.Character.Humanoid.Health = math.huge
            end
        end
    end)
end)

CreateModernButton(GodCont, "Full Heal Instantly", "primary", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
    end
end)

local NoclipCard, NoclipCont = CreateCard(PlayerTab, "NOCLIP")
local NoclipConn = nil
CreateModernToggle(NoclipCont, "Enable Noclip (Tembus Dinding)", false, function(enabled)
    States.Noclip = enabled
    if enabled then
        NoclipConn = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        if NoclipConn then NoclipConn:Disconnect() end
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
end)

-- VISUAL TAB
local ESPCard, ESPCont = CreateCard(VisualTab, "PLAYER ESP")
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESP"
ESPFolder.Parent = CoreGui

local function CreateESP(player)
    if player == LocalPlayer then return end
    local esp = Instance.new("BillboardGui")
    esp.AlwaysOnTop = true
    esp.Size = UDim2.new(0, 200, 0, 60)
    esp.StudsOffset = Vector3.new(0, 2.5, 0)
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Theme.Primary
    frame.BackgroundTransparency = 0.8
    frame.BorderSizePixel = 0
    Round(frame, 8)
    frame.Parent = esp
    
    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1, 0, 0.5, 0)
    name.BackgroundTransparency = 1
    name.Text = player.Name
    name.TextColor3 = Color3.new(1, 1, 1)
    name.TextSize = 14
    name.Font = Enum.Font.GothamBold
    name.Parent = frame
    
    local dist = Instance.new("TextLabel")
    dist.Size = UDim2.new(1, 0, 0.5, 0)
    dist.Position = UDim2.new(0, 0, 0.5, 0)
    dist.BackgroundTransparency = 1
    dist.Text = "0m"
    dist.TextColor3 = Color3.fromRGB(200, 200, 200)
    dist.TextSize = 12
    dist.Font = Enum.Font.Gotham
    dist.Parent = frame
    
    esp.Parent = ESPFolder
    
    local conn = RunService.RenderStepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            esp.Adornee = player.Character.HumanoidRootPart
            local d = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            dist.Text = math.floor(d) .. "m"
            esp.Enabled = States.ESP
        else
            esp.Enabled = false
        end
    end)
    
    return conn
end

local ESPConns = {}
CreateModernToggle(ESPCont, "Enable Player ESP", false, function(enabled)
    States.ESP = enabled
    if enabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                ESPConns[p] = CreateESP(p)
            end
        end
        Players.PlayerAdded:Connect(function(p)
            if States.ESP then ESPConns[p] = CreateESP(p) end
        end)
    else
        ESPFolder:ClearAllChildren()
        for _, c in pairs(ESPConns) do c:Disconnect() end
        ESPConns = {}
    end
end)

-- TELEPORT TAB
local TPCard, TPCont = CreateCard(TeleportTab, "TELEPORT SYSTEM")

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(1, 0, 0, 150)
PlayerList.BackgroundColor3 = Theme.SurfaceLight
PlayerList.BackgroundTransparency = 0.5
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 4
PlayerList.ScrollBarImageColor3 = Theme.Primary
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
Round(PlayerList, 8)
PlayerList.Parent = TPCont

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 5)
ListLayout.Parent = PlayerList

local SelectedPlayer = nil

local function UpdatePlayerList()
    for _, c in pairs(PlayerList:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 35)
            btn.Position = UDim2.new(0, 5, 0, 0)
            btn.BackgroundColor3 = SelectedPlayer == p and Theme.Primary or Theme.Surface
            btn.Text = p.Name .. " [" .. math.floor((p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude or 0) .. "m]"
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.TextSize = 12
            btn.Font = Enum.Font.Gotham
            Round(btn, 6)
            btn.Parent = PlayerList
            
            btn.MouseButton1Click:Connect(function()
                SelectedPlayer = p
                UpdatePlayerList()
            end)
        end
    end
    
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 40)
end

UpdatePlayerList()
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)
spawn(function() while wait(1) do UpdatePlayerList() end end)

CreateModernButton(TPCont, "TELEPORT TO SELECTED", "primary", function()
    if SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
    end
end)

CreateModernButton(TPCont, "FOLLOW PLAYER", "normal", function()
    States.AutoFollow = not States.AutoFollow
    if States.AutoFollow then
        spawn(function()
            while States.AutoFollow and SelectedPlayer do
                if SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.Humanoid:MoveTo(SelectedPlayer.Character.HumanoidRootPart.Position)
                end
                wait(0.1)
            end
        end)
    end
end)

-- SETTINGS TAB
local AutoExecCard, AutoExecCont = CreateCard(SettingsTab, "AUTO EXECUTE")
CreateModernToggle(AutoExecCont, "Auto Execute on Spawn", false, function(enabled)
    Config.AutoExecute = enabled
end)

CreateModernButton(AutoExecCont, "Execute Now", "primary", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/aryaexeuyf/AP-NEXTGEN1/refs/heads/main/main.lua"))()
end)

local ThemeCard, ThemeCont = CreateCard(SettingsTab, "THEME")
CreateModernButton(ThemeCont, "Switch to Neon Theme", "normal", function()
    -- Theme switching logic would go here
end)

-- Drag Functionality
local dragging, dragStart, startPos = false, nil, nil

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Minimize/Maximize
local function Minimize()
    States.Minimized = true
    Tween(MainFrame, {Size = UDim2.new(0, 380, 0, 0), Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset + 240)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In):Play()
    wait(0.4)
    MainFrame.Visible = false
    OrbButton.Visible = true
    Tween(OrbButton, {Size = UDim2.new(0, 55, 0, 55)}, 0.3, Enum.EasingStyle.Back):Play()
end

local function Maximize()
    States.Minimized = false
    OrbButton.Visible = false
    MainFrame.Visible = true
    Tween(MainFrame, {Size = UDim2.new(0, 380, 0, 480), Position = UDim2.new(0.5, -190, 0.5, -240)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
end

MinimizeBtn.MouseButton1Click:Connect(Minimize)
OrbButton.MouseButton1Click:Connect(Maximize)
CloseBtn.MouseButton1Click:Connect(function()
    Tween(MainFrame, {Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, 1.5, 0)}, 0.3):Play()
    wait(0.3)
    ScreenGui:Destroy()
end)

-- Intro Animation
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
Tween(MainFrame, {Size = UDim2.new(0, 380, 0, 480), Position = UDim2.new(0.5, -190, 0.5, -240)}, 0.6, Enum.EasingStyle.Back):Play()

print("✅ AP-NEXTGEN PREMIUM v3.0 Loaded Successfully!")
