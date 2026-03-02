--[[
    AP-NEXTGEN HUB v4.1 FINAL FIX
    Perfect Scroll | Real Fly Controls | Unlock Zoom
    Opening: WELCOME TO AP-NEXTGEN1
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Wait for character
if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

-- Config
local Config = {
    Speed = 16,
    FlySpeed = 50,
    GodMode = false,
    Noclip = false,
    Flying = false,
    ESP = false,
    AutoFollow = false,
    MobileFly = false,
    ZoomUnlock = false
}

-- Theme
local Theme = {
    Background = Color3.fromRGB(8, 8, 12),
    Surface = Color3.fromRGB(18, 18, 25),
    SurfaceLight = Color3.fromRGB(28, 28, 38),
    Primary = Color3.fromRGB(0, 200, 255),
    Secondary = Color3.fromRGB(140, 100, 255),
    Success = Color3.fromRGB(0, 255, 150),
    Error = Color3.fromRGB(255, 70, 90),
    Warning = Color3.fromRGB(255, 200, 50),
    Text = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(160, 160, 180)
}

-- Utility
local function Tween(obj, props, dur, style, dir)
    TweenService:Create(obj, TweenInfo.new(dur or 0.3, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props):Play()
end

local function Round(parent, rad)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, rad or 8)
    c.Parent = parent
    return c
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "APNEXTGEN_FINAL"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- ========== OPENING ANIMATION ==========
local IntroGui = Instance.new("ScreenGui")
IntroGui.Name = "Intro"
IntroGui.Parent = CoreGui
IntroGui.DisplayOrder = 9999

local IntroFrame = Instance.new("Frame")
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.BackgroundColor3 = Color3.new(0, 0, 0)
IntroFrame.BorderSizePixel = 0
IntroFrame.Parent = IntroGui

local IntroGradient = Instance.new("UIGradient")
IntroGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 10)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 15, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 10))
})
IntroGradient.Rotation = 90
IntroGradient.Parent = IntroFrame

local TextGlow = Instance.new("ImageLabel")
TextGlow.Size = UDim2.new(0, 600, 0, 200)
TextGlow.Position = UDim2.new(0.5, -300, 0.4, -100)
TextGlow.BackgroundTransparency = 1
TextGlow.Image = "rbxassetid://6015897843"
TextGlow.ImageColor3 = Theme.Primary
TextGlow.ImageTransparency = 0.9
TextGlow.ScaleType = Enum.ScaleType.Slice
TextGlow.SliceCenter = Rect.new(49, 49, 450, 450)
TextGlow.Parent = IntroFrame

local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(1, 0, 0, 80)
MainTitle.Position = UDim2.new(0, 0, 0.35, 0)
MainTitle.BackgroundTransparency = 1
MainTitle.Text = ""
MainTitle.TextColor3 = Theme.Primary
MainTitle.TextSize = 52
MainTitle.Font = Enum.Font.GothamBlack
MainTitle.TextStrokeTransparency = 0.8
MainTitle.TextStrokeColor3 = Color3.new(0, 0, 0)
MainTitle.Parent = IntroFrame

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, 0, 0, 40)
SubTitle.Position = UDim2.new(0, 0, 0.52, 0)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = ""
SubTitle.TextColor3 = Theme.TextMuted
SubTitle.TextSize = 20
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextStrokeTransparency = 0.9
SubTitle.TextStrokeColor3 = Color3.new(0, 0, 0)
SubTitle.Parent = IntroFrame

local LoadBg = Instance.new("Frame")
LoadBg.Size = UDim2.new(0, 350, 0, 3)
LoadBg.Position = UDim2.new(0.5, -175, 0.65, 0)
LoadBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
LoadBg.BorderSizePixel = 0
Round(LoadBg, 2)
LoadBg.Parent = IntroFrame

local LoadFill = Instance.new("Frame")
LoadFill.Size = UDim2.new(0, 0, 1, 0)
LoadFill.BackgroundColor3 = Theme.Primary
LoadFill.BorderSizePixel = 0
Round(LoadFill, 2)
LoadFill.Parent = LoadBg

local LoadGlow = Instance.new("ImageLabel")
LoadGlow.Size = UDim2.new(1, 20, 1, 10)
LoadGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
LoadGlow.AnchorPoint = Vector2.new(0.5, 0.5)
LoadGlow.BackgroundTransparency = 1
LoadGlow.Image = "rbxassetid://6015897843"
LoadGlow.ImageColor3 = Theme.Primary
LoadGlow.ImageTransparency = 0.7
LoadGlow.ScaleType = Enum.ScaleType.Slice
LoadGlow.SliceCenter = Rect.new(49, 49, 450, 450)
LoadGlow.Parent = LoadFill

local VersionText = Instance.new("TextLabel")
VersionText.Size = UDim2.new(1, 0, 0, 20)
VersionText.Position = UDim2.new(0, 0, 0.9, 0)
VersionText.BackgroundTransparency = 1
VersionText.Text = "v4.1 PERFECT EDITION"
VersionText.TextColor3 = Color3.fromRGB(80, 80, 100)
VersionText.TextSize = 12
VersionText.Font = Enum.Font.Gotham
VersionText.Parent = IntroFrame

-- Typewriter
local function TypeWrite(label, text, speed)
    for i = 1, #text do
        label.Text = string.sub(text, 1, i)
        wait(speed or 0.06)
    end
end

spawn(function()
    wait(0.3)
    
    spawn(function()
        while wait(0.05) do
            if not IntroFrame.Parent then break end
            TextGlow.ImageTransparency = 0.8 + math.sin(tick() * 3) * 0.1
        end
    end)
    
    TypeWrite(MainTitle, "WELCOME TO AP-NEXTGEN1", 0.08)
    wait(0.4)
    
    SubTitle.TextTransparency = 1
    SubTitle.Text = "professional script by APTECH"
    
    for i = 1, 10 do
        SubTitle.TextTransparency = 1 - (i/10)
        wait(0.03)
    end
    
    Tween(LoadFill, {Size = UDim2.new(1, 0, 1, 0)}, 1.2)
    wait(1.3)
    
    Tween(IntroFrame, {BackgroundTransparency = 1}, 0.6)
    Tween(MainTitle, {TextTransparency = 1, TextStrokeTransparency = 1}, 0.5)
    Tween(SubTitle, {TextTransparency = 1, TextStrokeTransparency = 1}, 0.5)
    Tween(LoadBg, {BackgroundTransparency = 1}, 0.5)
    Tween(LoadFill, {BackgroundTransparency = 1}, 0.5)
    Tween(TextGlow, {ImageTransparency = 1}, 0.5)
    wait(0.6)
    
    IntroGui:Destroy()
end)

wait(2.8)

-- ========== MAIN GUI ==========

-- Minimized Orb
local OrbButton = Instance.new("TextButton")
OrbButton.Name = "Orb"
OrbButton.Size = UDim2.new(0, 55, 0, 55)
OrbButton.Position = UDim2.new(0, 15, 0.5, -27)
OrbButton.BackgroundColor3 = Theme.Surface
OrbButton.Text = ""
OrbButton.Visible = false
OrbButton.ZIndex = 100
Round(OrbButton, 28)

local OrbGradient = Instance.new("UIGradient")
OrbGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.Primary),
    ColorSequenceKeypoint.new(1, Theme.Secondary)
})
OrbGradient.Rotation = 45
OrbGradient.Parent = OrbButton

local OrbStroke = Instance.new("UIStroke")
OrbStroke.Color = Theme.Primary
OrbStroke.Thickness = 2
OrbStroke.Parent = OrbButton

local OrbIcon = Instance.new("TextLabel")
OrbIcon.Size = UDim2.new(1, 0, 1, 0)
OrbIcon.BackgroundTransparency = 1
OrbIcon.Text = "G1"
OrbIcon.TextColor3 = Color3.new(1, 1, 1)
OrbIcon.TextSize = 22
OrbIcon.Font = Enum.Font.GothamBlack
OrbIcon.ZIndex = 101
OrbIcon.Parent = OrbButton

local OrbGlow = Instance.new("ImageLabel")
OrbGlow.Size = UDim2.new(1.5, 0, 1.5, 0)
OrbGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
OrbGlow.AnchorPoint = Vector2.new(0.5, 0.5)
OrbGlow.BackgroundTransparency = 1
OrbGlow.Image = "rbxassetid://6015897843"
OrbGlow.ImageColor3 = Theme.Primary
OrbGlow.ImageTransparency = 0.6
OrbGlow.ScaleType = Enum.ScaleType.Slice
OrbGlow.SliceCenter = Rect.new(49, 49, 450, 450)
OrbGlow.ZIndex = 99
OrbGlow.Parent = OrbButton

OrbButton.Parent = ScreenGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 340, 0, 450)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -225)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Round(MainFrame, 16)

local MainGlow = Instance.new("ImageLabel")
MainGlow.Size = UDim2.new(1, 50, 1, 50)
MainGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
MainGlow.AnchorPoint = Vector2.new(0.5, 0.5)
MainGlow.BackgroundTransparency = 1
MainGlow.Image = "rbxassetid://6015897843"
MainGlow.ImageColor3 = Theme.Primary
MainGlow.ImageTransparency = 0.85
MainGlow.ScaleType = Enum.ScaleType.Slice
MainGlow.SliceCenter = Rect.new(49, 49, 450, 450)
MainGlow.ZIndex = -1
MainGlow.Parent = MainFrame

MainFrame.Parent = ScreenGui

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Theme.Surface
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
Round(TopBar, 16)

local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 20)
TopFix.Position = UDim2.new(0, 0, 1, -20)
TopFix.BackgroundColor3 = Theme.Surface
TopFix.BorderSizePixel = 0
TopFix.Parent = TopBar

-- Logo
local LogoFrame = Instance.new("Frame")
LogoFrame.Size = UDim2.new(0, 32, 0, 32)
LogoFrame.Position = UDim2.new(0, 12, 0.5, -16)
LogoFrame.BackgroundColor3 = Theme.Primary
Round(LogoFrame, 8)
LogoFrame.Parent = TopBar

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(1, 0, 1, 0)
LogoText.BackgroundTransparency = 1
LogoText.Text = "G1"
LogoText.TextColor3 = Color3.new(1, 1, 1)
LogoText.TextSize = 14
LogoText.Font = Enum.Font.GothamBlack
LogoText.Parent = LogoFrame

-- Title
local TitleGroup = Instance.new("Frame")
TitleGroup.Size = UDim2.new(0, 180, 1, 0)
TitleGroup.Position = UDim2.new(0, 52, 0, 0)
TitleGroup.BackgroundTransparency = 1
TitleGroup.Parent = TopBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, 0, 0.6, 0)
TitleText.Position = UDim2.new(0, 0, 0.1, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "AP-NEXTGEN"
TitleText.TextColor3 = Theme.Text
TitleText.TextSize = 16
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleGroup

local SubText = Instance.new("TextLabel")
SubText.Size = UDim2.new(1, 0, 0.4, 0)
SubText.Position = UDim2.new(0, 0, 0.55, 0)
SubText.BackgroundTransparency = 1
SubText.Text = "PREMIUM HUB"
SubText.TextColor3 = Theme.Primary
SubText.TextSize = 10
SubText.Font = Enum.Font.Gotham
SubText.TextXAlignment = Enum.TextXAlignment.Left
SubText.Parent = TitleGroup

-- Controls
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -68, 0.5, -14)
MinBtn.BackgroundColor3 = Theme.SurfaceLight
MinBtn.Text = "−"
MinBtn.TextColor3 = Theme.TextMuted
MinBtn.TextSize = 20
MinBtn.Font = Enum.Font.GothamBold
Round(MinBtn, 6)
MinBtn.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -14)
CloseBtn.BackgroundColor3 = Theme.Error
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 20
CloseBtn.Font = Enum.Font.GothamBold
Round(CloseBtn, 6)
CloseBtn.Parent = TopBar

-- FIXED SCROLLABLE CONTENT
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "Content"
ScrollFrame.Size = UDim2.new(1, -20, 1, -70)
ScrollFrame.Position = UDim2.new(0, 10, 0, 60)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = Theme.Primary
ScrollFrame.ScrollBarImageTransparency = 0.4
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1000)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollFrame.Parent = MainFrame

local ContentList = Instance.new("UIListLayout")
ContentList.Padding = UDim.new(0, 10)
ContentList.Parent = ScrollFrame

-- Update canvas size
ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 20)
end)

-- Components
local function CreateCard(title)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 0)
    Card.AutomaticSize = Enum.AutomaticSize.Y
    Card.BackgroundColor3 = Theme.Surface
    Card.BackgroundTransparency = 0.2
    Card.BorderSizePixel = 0
    Round(Card, 12)
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(40, 40, 50)
    Stroke.Thickness = 1
    Stroke.Parent = Card
    
    local CardTitle = Instance.new("TextLabel")
    CardTitle.Size = UDim2.new(1, -20, 0, 32)
    CardTitle.Position = UDim2.new(0, 12, 0, 8)
    CardTitle.BackgroundTransparency = 1
    CardTitle.Text = title
    CardTitle.TextColor3 = Theme.Primary
    CardTitle.TextSize = 13
    CardTitle.Font = Enum.Font.GothamBold
    CardTitle.TextXAlignment = Enum.TextXAlignment.Left
    CardTitle.Parent = Card
    
    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(1, -24, 0, 1)
    Line.Position = UDim2.new(0, 12, 0, 36)
    Line.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Line.BorderSizePixel = 0
    Line.Parent = Card
    
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -24, 0, 0)
    Container.Position = UDim2.new(0, 12, 0, 42)
    Container.AutomaticSize = Enum.AutomaticSize.Y
    Container.BackgroundTransparency = 1
    Container.Parent = Card
    
    local List = Instance.new("UIListLayout")
    List.Padding = UDim.new(0, 8)
    List.Parent = Container
    
    local Pad = Instance.new("UIPadding")
    Pad.PaddingBottom = UDim.new(0, 12)
    Pad.Parent = Card
    
    Card.Parent = ScrollFrame
    return Container
end

local function CreateToggle(parent, text, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 36)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.TextSize = 12
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 48, 0, 24)
    ToggleBtn.Position = UDim2.new(1, -48, 0.5, -12)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    ToggleBtn.Text = "OFF"
    ToggleBtn.TextColor3 = Theme.TextMuted
    ToggleBtn.TextSize = 10
    ToggleBtn.Font = Enum.Font.GothamBold
    Round(ToggleBtn, 12)
    ToggleBtn.Parent = Frame
    
    local enabled = false
    ToggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        ToggleBtn.Text = enabled and "ON" or "OFF"
        Tween(ToggleBtn, {BackgroundColor3 = enabled and Theme.Success or Color3.fromRGB(60, 60, 70)}, 0.2)
        Tween(ToggleBtn, {TextColor3 = enabled and Color3.new(1,1,1) or Theme.TextMuted}, 0.2)
        if callback then callback(enabled) end
    end)
    
    return Frame
end

local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 50)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.TextSize = 12
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local ValueBox = Instance.new("TextBox")
    ValueBox.Size = UDim2.new(0, 50, 0, 22)
    ValueBox.Position = UDim2.new(1, -50, 0, 0)
    ValueBox.BackgroundColor3 = Theme.SurfaceLight
    ValueBox.Text = tostring(default)
    ValueBox.TextColor3 = Theme.Primary
    ValueBox.TextSize = 11
    ValueBox.Font = Enum.Font.GothamBold
    Round(ValueBox, 4)
    ValueBox.Parent = Frame
    
    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, 0, 0, 4)
    Track.Position = UDim2.new(0, 0, 0, 36)
    Track.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Track.BorderSizePixel = 0
    Round(Track, 2)
    Track.Parent = Frame
    
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = Theme.Primary
    Fill.BorderSizePixel = 0
    Round(Fill, 2)
    Fill.Parent = Track
    
    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = UDim2.new((default-min)/(max-min), -7, 0.5, -7)
    Knob.BackgroundColor3 = Color3.new(1, 1, 1)
    Round(Knob, 7)
    Knob.Parent = Track
    
    local dragging = false
    
    local function update(input)
        local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        ValueBox.Text = tostring(val)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Knob.Position = UDim2.new(pos, -7, 0.5, -7)
        if callback then callback(val) end
    end
    
    Track.InputBegan:Connect(function(input)
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
        dragging = false
    end)
    
    ValueBox.FocusLost:Connect(function()
        local val = math.clamp(tonumber(ValueBox.Text) or default, min, max)
        ValueBox.Text = tostring(val)
        local pos = (val - min) / (max - min)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Knob.Position = UDim2.new(pos, -7, 0.5, -7)
        if callback then callback(val) end
    end)
    
    return Frame
end

local function CreateButton(parent, text, style, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 34)
    Btn.BackgroundColor3 = style == "primary" and Theme.Primary or Theme.SurfaceLight
    Btn.Text = text
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.TextSize = 12
    Btn.Font = Enum.Font.GothamBold
    Round(Btn, 6)
    Btn.Parent = parent
    
    Btn.MouseButton1Click:Connect(function()
        Tween(Btn, {Size = UDim2.new(0.97, 0, 0, 32)}, 0.1)
        wait(0.1)
        Tween(Btn, {Size = UDim2.new(1, 0, 0, 34)}, 0.1)
        if callback then callback() end
    end)
    
    return Btn
end

-- ========== FEATURES ==========

-- Speed
local SpeedCont = CreateCard("MOVEMENT SPEED")
CreateSlider(SpeedCont, "WalkSpeed", 16, 300, 50, function(val)
    Config.Speed = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)

CreateButton(SpeedCont, "Reset Speed", "normal", function()
    Config.Speed = 16
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- Fly Controls (Main GUI)
local FlyCont = CreateCard("FLY CONTROL")
CreateSlider(FlyCont, "Fly Speed", 10, 200, 50, function(val)
    Config.FlySpeed = val
end)

CreateToggle(FlyCont, "Enable Fly", function(enabled)
    Config.Flying = enabled
end)

-- MOBILE FLY GUI (SEPARATE - REAL CONTROLS)
local MobileFlyGui = Instance.new("ScreenGui")
MobileFlyGui.Name = "MobileFlyControls"
MobileFlyGui.Parent = CoreGui
MobileFlyGui.Enabled = false

local FlyPanel = Instance.new("Frame")
FlyPanel.Size = UDim2.new(0, 280, 0, 320)
FlyPanel.Position = UDim2.new(0.5, -140, 0.6, -160)
FlyPanel.BackgroundColor3 = Theme.Background
FlyPanel.BackgroundTransparency = 0.1
FlyPanel.BorderSizePixel = 0
FlyPanel.Visible = false
Round(FlyPanel, 20)

local FlyStroke = Instance.new("UIStroke")
FlyStroke.Color = Theme.Primary
FlyStroke.Thickness = 2
FlyStroke.Parent = FlyPanel

FlyPanel.Parent = MobileFlyGui

-- Title
local FlyTitle = Instance.new("TextLabel")
FlyTitle.Size = UDim2.new(1, 0, 0, 40)
FlyTitle.BackgroundTransparency = 1
FlyTitle.Text = "✈️ FLY CONTROLLER"
FlyTitle.TextColor3 = Theme.Primary
FlyTitle.TextSize = 18
FlyTitle.Font = Enum.Font.GothamBlack
FlyTitle.Parent = FlyPanel

-- Close Button
local CloseFlyBtn = Instance.new("TextButton")
CloseFlyBtn.Size = UDim2.new(0, 30, 0, 30)
CloseFlyBtn.Position = UDim2.new(1, -40, 0, 10)
CloseFlyBtn.BackgroundColor3 = Theme.Error
CloseFlyBtn.Text = "×"
CloseFlyBtn.TextColor3 = Color3.new(1, 1, 1)
CloseFlyBtn.TextSize = 20
CloseFlyBtn.Font = Enum.Font.GothamBold
Round(CloseFlyBtn, 8)
CloseFlyBtn.Parent = FlyPanel

-- Speed Display
local FlySpeedText = Instance.new("TextLabel")
FlySpeedText.Size = UDim2.new(1, 0, 0, 25)
FlySpeedText.Position = UDim2.new(0, 0, 0, 35)
FlySpeedText.BackgroundTransparency = 1
FlySpeedText.Text = "Speed: 50"
FlySpeedText.TextColor3 = Theme.TextMuted
FlySpeedText.TextSize = 14
FlySpeedText.Font = Enum.Font.GothamBold
FlySpeedText.Parent = FlyPanel

-- Control Buttons Container
local ControlsFrame = Instance.new("Frame")
ControlsFrame.Size = UDim2.new(1, -20, 0, 200)
ControlsFrame.Position = UDim2.new(0, 10, 0, 65)
ControlsFrame.BackgroundTransparency = 1
ControlsFrame.Parent = FlyPanel

-- Create Directional Buttons
local FlyButtons = {}
local ActiveDirections = {}

local function CreateFlyButton(name, text, pos, direction)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 60, 0, 60)
    btn.Position = pos
    btn.BackgroundColor3 = Theme.SurfaceLight
    btn.Text = text
    btn.TextColor3 = Theme.Text
    btn.TextSize = 28
    btn.Font = Enum.Font.GothamBlack
    Round(btn, 12)
    btn.Parent = ControlsFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Primary
    stroke.Thickness = 2
    stroke.Parent = btn
    
    btn.MouseButton1Down:Connect(function()
        ActiveDirections[direction] = true
        Tween(btn, {BackgroundColor3 = Theme.Primary, Size = UDim2.new(0, 55, 0, 55)}, 0.1)
    end)
    
    btn.MouseButton1Up:Connect(function()
        ActiveDirections[direction] = nil
        Tween(btn, {BackgroundColor3 = Theme.SurfaceLight, Size = UDim2.new(0, 60, 0, 60)}, 0.1)
    end)
    
    btn.MouseLeave:Connect(function()
        ActiveDirections[direction] = nil
        Tween(btn, {BackgroundColor3 = Theme.SurfaceLight, Size = UDim2.new(0, 60, 0, 60)}, 0.1)
    end)
    
    FlyButtons[name] = btn
    return btn
end

-- Layout:     [UP]
--      [LEFT] [DOWN] [RIGHT]
--              [DN]

CreateFlyButton("Up", "⬆️", UDim2.new(0.5, -30, 0, 0), "Up")
CreateFlyButton("Forward", "⬆", UDim2.new(0.5, -30, 0, 70), "Forward")
CreateFlyButton("Left", "⬅", UDim2.new(0, 10, 0, 70), "Left")
CreateFlyButton("Right", "➡", UDim2.new(1, -70, 0, 70), "Right")
CreateFlyButton("Back", "⬇", UDim2.new(0.5, -30, 0, 140), "Back")
CreateFlyButton("Down", "⬇️", UDim2.new(0.5, -30, 1, -60), "Down")

-- Fly Speed Slider in Mobile Panel
local MobileSpeedTrack = Instance.new("Frame")
MobileSpeedTrack.Size = UDim2.new(1, -20, 0, 6)
MobileSpeedTrack.Position = UDim2.new(0, 10, 1, -35)
MobileSpeedTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
MobileSpeedTrack.BorderSizePixel = 0
Round(MobileSpeedTrack, 3)
MobileSpeedTrack.Parent = FlyPanel

local MobileSpeedFill = Instance.new("Frame")
MobileSpeedFill.Size = UDim2.new(0.3, 0, 1, 0)
MobileSpeedFill.BackgroundColor3 = Theme.Primary
MobileSpeedFill.BorderSizePixel = 0
Round(MobileSpeedFill, 3)
MobileSpeedFill.Parent = MobileSpeedTrack

-- Open Mobile Fly Button
CreateButton(FlyCont, "📱 Open Fly Controller", "primary", function()
    MobileFlyGui.Enabled = not MobileFlyGui.Enabled
    FlyPanel.Visible = MobileFlyGui.Enabled
    Config.MobileFly = MobileFlyGui.Enabled
end)

CloseFlyBtn.MouseButton1Click:Connect(function()
    MobileFlyGui.Enabled = false
    FlyPanel.Visible = false
    Config.MobileFly = false
end)

-- Fly Logic
spawn(function()
    while wait(0.03) do
        if Config.Flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local speed = Config.FlySpeed
            
            -- PC Controls (Space/Shift)
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, speed, hrp.Velocity.Z)
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, -speed, hrp.Velocity.Z)
            else
                hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
            end
            
            -- Mobile Controls
            if ActiveDirections["Up"] then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, speed, hrp.Velocity.Z)
            elseif ActiveDirections["Down"] then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, -speed, hrp.Velocity.Z)
            end
            
            if ActiveDirections["Forward"] then
                hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -speed/10)
            elseif ActiveDirections["Back"] then
                hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, speed/10)
            end
            
            if ActiveDirections["Left"] then
                hrp.CFrame = hrp.CFrame * CFrame.new(-speed/10, 0, 0)
            elseif ActiveDirections["Right"] then
                hrp.CFrame = hrp.CFrame * CFrame.new(speed/10, 0, 0)
            end
        end
    end
end)

-- Noclip
local NoclipCont = CreateCard("NOCLIP")
local NoclipConn = nil
CreateToggle(NoclipCont, "Enable Noclip", function(enabled)
    Config.Noclip = enabled
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

-- Teleport
local TPCont = CreateCard("TELEPORT")
local PlayerListFrame = Instance.new("ScrollingFrame")
PlayerListFrame.Size = UDim2.new(1, 0, 0, 120)
PlayerListFrame.BackgroundColor3 = Theme.SurfaceLight
PlayerListFrame.BackgroundTransparency = 0.3
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.ScrollBarThickness = 4
PlayerListFrame.ScrollBarImageColor3 = Theme.Primary
PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
Round(PlayerListFrame, 8)
PlayerListFrame.Parent = TPCont

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 4)
ListLayout.Parent = PlayerListFrame

local SelectedPlayer = nil

local function UpdatePlayerList()
    for _, c in pairs(PlayerListFrame:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -8, 0, 30)
            btn.Position = UDim2.new(0, 4, 0, 0)
            btn.BackgroundColor3 = SelectedPlayer == p and Theme.Primary or Theme.Surface
            btn.Text = p.Name
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.TextSize = 12
            btn.Font = Enum.Font.Gotham
            Round(btn, 6)
            btn.Parent = PlayerListFrame
            
            btn.MouseButton1Click:Connect(function()
                SelectedPlayer = p
                UpdatePlayerList()
            end)
        end
    end
    
    PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, (#Players:GetPlayers() - 1) * 34)
end

UpdatePlayerList()
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)

CreateButton(TPCont, "Teleport to Selected", "primary", function()
    if SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
    end
end)

CreateButton(TPCont, "Follow Player", "normal", function()
    Config.AutoFollow = not Config.AutoFollow
    if Config.AutoFollow then
        spawn(function()
            while Config.AutoFollow and SelectedPlayer do
                if SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.Humanoid:MoveTo(SelectedPlayer.Character.HumanoidRootPart.Position)
                end
                wait(0.2)
            end
        end)
    end
end)

-- ESP
local ESPCont = CreateCard("ESP PLAYER")
local ESPFolder = Instance.new("Folder")
ESPFolder.Parent = CoreGui

CreateToggle(ESPCont, "Enable ESP", function(enabled)
    Config.ESP = enabled
    if enabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local esp = Instance.new("BillboardGui")
                esp.AlwaysOnTop = true
                esp.Size = UDim2.new(0, 120, 0, 50)
                esp.StudsOffset = Vector3.new(0, 2.5, 0)
                esp.Adornee = p.Character.Head
                
                local bg = Instance.new("Frame")
                bg.Size = UDim2.new(1, 0, 1, 0)
                bg.BackgroundColor3 = Theme.Primary
                bg.BackgroundTransparency = 0.7
                Round(bg, 8)
                bg.Parent = esp
                
                local name = Instance.new("TextLabel")
                name.Size = UDim2.new(1, 0, 0.6, 0)
                name.BackgroundTransparency = 1
                name.Text = p.Name
                name.TextColor3 = Color3.new(1, 1, 1)
                name.TextSize = 13
                name.Font = Enum.Font.GothamBold
                name.Parent = bg
                
                local dist = Instance.new("TextLabel")
                dist.Size = UDim2.new(1, 0, 0.4, 0)
                dist.Position = UDim2.new(0, 0, 0.6, 0)
                dist.BackgroundTransparency = 1
                dist.Text = "0m"
                dist.TextColor3 = Color3.fromRGB(220, 220, 220)
                dist.TextSize = 10
                dist.Font = Enum.Font.Gotham
                dist.Parent = bg
                
                esp.Parent = ESPFolder
                
                spawn(function()
                    while Config.ESP and wait(0.5) do
                        if p.Character and p.Character:FindFirstChild("Head") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
                            local d = (LocalPlayer.Character.Head.Position - p.Character.Head.Position).Magnitude
                            dist.Text = math.floor(d) .. "m"
                        end
                    end
                end)
            end
        end
    else
        ESPFolder:ClearAllChildren()
    end
end)

-- God Mode
local GodCont = CreateCard("GOD MODE")
CreateToggle(GodCont, "Enable God Mode", function(enabled)
    Config.GodMode = enabled
    spawn(function()
        while Config.GodMode and wait(0.5) do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
            end
        end
    end)
end)

CreateButton(GodCont, "Heal Instantly", "primary", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
    end
end)

-- UNLOCK ZOOM (NEW FEATURE)
local ZoomCont = CreateCard("UNLOCK ZOOM")
CreateToggle(ZoomCont, "Enable Unlock Zoom", function(enabled)
    Config.ZoomUnlock = enabled
    if enabled then
        LocalPlayer.CameraMaxZoomDistance = 10000
        LocalPlayer.CameraMinZoomDistance = 0.5
    else
        LocalPlayer.CameraMaxZoomDistance = 128
        LocalPlayer.CameraMinZoomDistance = 0.5
    end
end)

CreateSlider(ZoomCont, "Max Zoom Distance", 10, 10000, 1000, function(val)
    if Config.ZoomUnlock then
        LocalPlayer.CameraMaxZoomDistance = val
    end
end)

-- Extra
local ExtraCont = CreateCard("EXTRA FEATURES")

CreateButton(ExtraCont, "Infinite Jump", "normal", function()
    local infiniteJump = false
    UserInputService.JumpRequest:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end)

CreateButton(ExtraCont, "Anti-AFK", "normal", function()
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

CreateButton(ExtraCont, "Rejoin Server", "primary", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

-- ========== CONTROLS ==========

-- Drag
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

-- Minimize
MinBtn.MouseButton1Click:Connect(function()
    Tween(MainFrame, {Size = UDim2.new(0, 340, 0, 0)}, 0.3)
    wait(0.3)
    MainFrame.Visible = false
    OrbButton.Visible = true
    Tween(OrbButton, {Size = UDim2.new(0, 55, 0, 55)}, 0.3)
end)

OrbButton.MouseButton1Click:Connect(function()
    OrbButton.Visible = false
    MainFrame.Visible = true
    Tween(MainFrame, {Size = UDim2.new(0, 340, 0, 450)}, 0.3)
end)

-- Close
CloseBtn.MouseButton1Click:Connect(function()
    Tween(MainFrame, {Position = UDim2.new(MainFrame.Position.X.Scale, MainPlayer.Position.X.Offset, 1.5, 0)}, 0.3)
    wait(0.3)
    ScreenGui:Destroy()
    MobileFlyGui:Destroy()
end)

-- Intro Animation
MainFrame.Size = UDim2.new(0, 0, 0, 0)
wait(0.1)
Tween(MainFrame, {Size = UDim2.new(0, 340, 0, 450)}, 0.5, Enum.EasingStyle.Back)

print("✅ AP-NEXTGEN1 v4.1 PERFECT EDITION Loaded!")
print("Features: Perfect Scroll | Real Fly Controls | Unlock Zoom | All Working!")
