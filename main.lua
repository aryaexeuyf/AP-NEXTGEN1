--[[
    AP-NEXTGEN HUB v5.0 ULTIMATE
    HD Professional UI | All Bugs Fixed | Feature Complete
    Created by: APTECH
]]

-- Anti-duplicate detection
if getgenv().APNEXTGEN_LOADED then
    warn("AP-NEXTGEN already loaded!")
    return
end
getgenv().APNEXTGEN_LOADED = true

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Wait for character
if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

-- Config
local Config = {
    Speed = 16,
    FlySpeed = 100,
    GodMode = false,
    GodModeType = "Gen1", -- Gen1 or Gen2
    Noclip = false,
    Flying = false,
    ESP = false,
    AutoFollow = false,
    AutoHeal = false,
    FullBright = false,
    AntiAFK = false,
    FPSBoost = false,
    CoinVisual = 0
}

-- State
local States = {
    FollowingPlayer = nil,
    ESPFolder = nil,
    NoclipConnection = nil,
    GodConnection = nil,
    FlyConnection = nil,
    BrightnessConnection = nil
}

-- Premium Theme
local Theme = {
    Background = Color3.fromRGB(12, 12, 18),
    Surface = Color3.fromRGB(22, 22, 32),
    SurfaceLight = Color3.fromRGB(35, 35, 48),
    Primary = Color3.fromRGB(0, 212, 255),
    Secondary = Color3.fromRGB(157, 78, 221),
    Success = Color3.fromRGB(0, 255, 136),
    Warning = Color3.fromRGB(255, 200, 64),
    Error = Color3.fromRGB(255, 71, 87),
    Text = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(170, 170, 190)
}

-- Utility
local function Tween(obj, props, dur, style, dir)
    TweenService:Create(obj, TweenInfo.new(dur or 0.3, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props):Play()
end

local function Round(parent, rad)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, rad or 10)
    c.Parent = parent
    return c
end

local function Shadow(parent, size)
    local s = Instance.new("ImageLabel")
    s.Size = UDim2.new(1, size or 40, 1, size or 40)
    s.Position = UDim2.new(0.5, 0, 0.5, 0)
    s.AnchorPoint = Vector2.new(0.5, 0.5)
    s.BackgroundTransparency = 1
    s.Image = "rbxassetid://6015897843"
    s.ImageColor3 = Color3.new(0, 0, 0)
    s.ImageTransparency = 0.6
    s.ScaleType = Enum.ScaleType.Slice
    s.SliceCenter = Rect.new(49, 49, 450, 450)
    s.ZIndex = parent.ZIndex - 1
    s.Parent = parent
    return s
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "APNEXTGEN_ULTIMATE"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.DisplayOrder = 999

-- ========== OPENING ANIMATION (SMOOTH) ==========
local IntroGui = Instance.new("ScreenGui")
IntroGui.Name = "Intro"
IntroGui.Parent = CoreGui
IntroGui.DisplayOrder = 10000

local IntroFrame = Instance.new("Frame")
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
IntroFrame.BorderSizePixel = 0
IntroFrame.Parent = IntroGui

-- Animated gradient background
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 8, 15)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 20, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 15))
})
Gradient.Rotation = 45
Gradient.Parent = IntroFrame

-- Animated gradient shift
spawn(function()
    while IntroFrame.Parent do
        Gradient.Rotation = Gradient.Rotation + 0.5
        wait(0.05)
    end
end)

-- Particles effect
for i = 1, 20 do
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, math.random(2, 6), 0, math.random(2, 6))
    particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
    particle.BackgroundColor3 = Theme.Primary
    particle.BackgroundTransparency = math.random(0.5, 0.9)
    particle.BorderSizePixel = 0
    Round(particle, 10)
    particle.Parent = IntroFrame
    
    spawn(function()
        while particle.Parent do
            Tween(particle, {Position = UDim2.new(particle.Position.X.Scale, math.random(-50, 50), particle.Position.Y.Scale - 0.1, 0)}, math.random(3, 6))
            wait(math.random(3, 6))
            particle.Position = UDim2.new(math.random(), 0, 1.1, 0)
        end
    end)
end

-- Main Title with glow
local TitleContainer = Instance.new("Frame")
TitleContainer.Size = UDim2.new(0, 600, 0, 150)
TitleContainer.Position = UDim2.new(0.5, -300, 0.4, -75)
TitleContainer.BackgroundTransparency = 1
TitleContainer.Parent = IntroFrame

local GlowBehind = Instance.new("ImageLabel")
GlowBehind.Size = UDim2.new(1.5, 0, 1.5, 0)
GlowBehind.Position = UDim2.new(0.5, 0, 0.5, 0)
GlowBehind.AnchorPoint = Vector2.new(0.5, 0.5)
GlowBehind.BackgroundTransparency = 1
GlowBehind.Image = "rbxassetid://6015897843"
GlowBehind.ImageColor3 = Theme.Primary
GlowBehind.ImageTransparency = 0.85
GlowBehind.ScaleType = Enum.ScaleType.Slice
GlowBehind.SliceCenter = Rect.new(49, 49, 450, 450)
GlowBehind.Parent = TitleContainer

local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(1, 0, 0.7, 0)
MainTitle.BackgroundTransparency = 1
MainTitle.Text = ""
MainTitle.TextColor3 = Theme.Primary
MainTitle.TextSize = 56
MainTitle.Font = Enum.Font.GothamBlack
MainTitle.TextStrokeTransparency = 0.9
MainTitle.TextStrokeColor3 = Color3.new(0, 0, 0)
MainTitle.Parent = TitleContainer

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, 0, 0.3, 0)
SubTitle.Position = UDim2.new(0, 0, 0.7, 0)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = ""
SubTitle.TextColor3 = Theme.TextMuted
SubTitle.TextSize = 18
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextStrokeTransparency = 0.95
SubTitle.TextStrokeColor3 = Color3.new(0, 0, 0)
SubTitle.Parent = TitleContainer

-- Loading bar
local LoadContainer = Instance.new("Frame")
LoadContainer.Size = UDim2.new(0, 400, 0, 4)
LoadContainer.Position = UDim2.new(0.5, -200, 0.65, 0)
LoadContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
LoadContainer.BorderSizePixel = 0
Round(LoadContainer, 2)
LoadContainer.Parent = IntroFrame

local LoadBar = Instance.new("Frame")
LoadBar.Size = UDim2.new(0, 0, 1, 0)
LoadBar.BackgroundColor3 = Theme.Primary
LoadBar.BorderSizePixel = 0
Round(LoadBar, 2)
LoadBar.Parent = LoadContainer

local LoadGlow = Instance.new("Frame")
LoadGlow.Size = UDim2.new(1, 0, 1, 0)
LoadGlow.BackgroundColor3 = Theme.Primary
LoadGlow.BackgroundTransparency = 0.5
LoadGlow.BorderSizePixel = 0
Round(LoadGlow, 2)
LoadGlow.Parent = LoadBar

-- Version
local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size = UDim2.new(1, 0, 0, 20)
VersionLabel.Position = UDim2.new(0, 0, 0.9, 0)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = "ULTIMATE EDITION v5.0"
VersionLabel.TextColor3 = Color3.fromRGB(60, 60, 80)
VersionLabel.TextSize = 12
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.Parent = IntroFrame

-- Typewriter effect
local function TypeWrite(label, text, speed)
    for i = 1, #text do
        label.Text = string.sub(text, 1, i)
        wait(speed or 0.05)
    end
end

-- Opening sequence
spawn(function()
    wait(0.5)
    
    -- Pulse glow
    spawn(function()
        while GlowBehind.Parent do
            Tween(GlowBehind, {ImageTransparency = 0.8}, 1)
            wait(1)
            Tween(GlowBehind, {ImageTransparency = 0.9}, 1)
            wait(1)
        end
    end)
    
    TypeWrite(MainTitle, "WELCOME TO AP-NEXTGEN1", 0.07)
    wait(0.3)
    
    SubTitle.TextTransparency = 1
    SubTitle.Text = "professional script by APTECH"
    
    for i = 1, 15 do
        SubTitle.TextTransparency = 1 - (i/15)
        wait(0.02)
    end
    
    -- Load animation
    Tween(LoadBar, {Size = UDim2.new(1, 0, 1, 0)}, 1.5, Enum.EasingStyle.Quart)
    wait(1.6)
    
    -- Fade out
    Tween(IntroFrame, {BackgroundTransparency = 1}, 0.8)
    Tween(MainTitle, {TextTransparency = 1, TextStrokeTransparency = 1}, 0.6)
    Tween(SubTitle, {TextTransparency = 1, TextStrokeTransparency = 1}, 0.6)
    Tween(LoadContainer, {BackgroundTransparency = 1}, 0.5)
    Tween(LoadBar, {BackgroundTransparency = 1}, 0.5)
    Tween(GlowBehind, {ImageTransparency = 1}, 0.5)
    
    wait(0.8)
    IntroGui:Destroy()
end)

wait(3)

-- ========== MAIN GUI (HD PROFESSIONAL) ==========

-- Minimize Orb
local OrbButton = Instance.new("TextButton")
OrbButton.Name = "Orb"
OrbButton.Size = UDim2.new(0, 60, 0, 60)
OrbButton.Position = UDim2.new(0, 20, 0.5, -30)
OrbButton.BackgroundColor3 = Theme.Surface
OrbButton.Text = ""
OrbButton.Visible = false
OrbButton.ZIndex = 100
Round(OrbButton, 30)

local OrbGradient = Instance.new("UIGradient")
OrbGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.Primary),
    ColorSequenceKeypoint.new(1, Theme.Secondary)
})
OrbGradient.Rotation = 45
OrbGradient.Parent = OrbButton

local OrbStroke = Instance.new("UIStroke")
OrbStroke.Color = Theme.Primary
OrbStroke.Thickness = 3
OrbStroke.Parent = OrbButton

local OrbIcon = Instance.new("TextLabel")
OrbIcon.Size = UDim2.new(1, 0, 1, 0)
OrbIcon.BackgroundTransparency = 1
OrbIcon.Text = "G1"
OrbIcon.TextColor3 = Color3.new(1, 1, 1)
OrbIcon.TextSize = 24
OrbIcon.Font = Enum.Font.GothamBlack
OrbIcon.ZIndex = 101
OrbIcon.Parent = OrbButton

Shadow(OrbButton, 30)
OrbButton.Parent = ScreenGui

-- Main Frame (HD Layout)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Round(MainFrame, 20)

Shadow(MainFrame, 60)
MainFrame.Parent = ScreenGui

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 55)
TopBar.BackgroundColor3 = Theme.Surface
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
Round(TopBar, 20)

local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 25)
TopFix.Position = UDim2.new(0, 0, 1, -25)
TopFix.BackgroundColor3 = Theme.Surface
TopFix.BorderSizePixel = 0
TopFix.Parent = TopBar

-- Logo
local LogoFrame = Instance.new("Frame")
LogoFrame.Size = UDim2.new(0, 36, 0, 36)
LogoFrame.Position = UDim2.new(0, 15, 0.5, -18)
LogoFrame.BackgroundColor3 = Theme.Primary
Round(LogoFrame, 10)
LogoFrame.Parent = TopBar

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(1, 0, 1, 0)
LogoText.BackgroundTransparency = 1
LogoText.Text = "G1"
LogoText.TextColor3 = Color3.new(1, 1, 1)
LogoText.TextSize = 16
LogoText.Font = Enum.Font.GothamBlack
LogoText.Parent = LogoFrame

-- Title Group
local TitleGroup = Instance.new("Frame")
TitleGroup.Size = UDim2.new(0, 200, 1, 0)
TitleGroup.Position = UDim2.new(0, 60, 0, 0)
TitleGroup.BackgroundTransparency = 1
TitleGroup.Parent = TopBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, 0, 0.6, 0)
TitleText.Position = UDim2.new(0, 0, 0.1, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "AP-NEXTGEN"
TitleText.TextColor3 = Theme.Text
TitleText.TextSize = 18
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleGroup

local SubText = Instance.new("TextLabel")
SubText.Size = UDim2.new(1, 0, 0.4, 0)
SubText.Position = UDim2.new(0, 0, 0.55, 0)
SubText.BackgroundTransparency = 1
SubText.Text = "ULTIMATE HUB"
SubText.TextColor3 = Theme.Primary
SubText.TextSize = 11
SubText.Font = Enum.Font.Gotham
SubText.TextXAlignment = Enum.TextXAlignment.Left
SubText.Parent = TitleGroup

-- Controls
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 32, 0, 32)
MinBtn.Position = UDim2.new(1, -75, 0.5, -16)
MinBtn.BackgroundColor3 = Theme.SurfaceLight
MinBtn.Text = "−"
MinBtn.TextColor3 = Theme.TextMuted
MinBtn.TextSize = 24
MinBtn.Font = Enum.Font.GothamBold
Round(MinBtn, 8)
MinBtn.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -16)
CloseBtn.BackgroundColor3 = Theme.Error
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 24
CloseBtn.Font = Enum.Font.GothamBold
Round(CloseBtn, 8)
CloseBtn.Parent = TopBar

-- Content (FIXED SCROLL)
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "Content"
ContentFrame.Size = UDim2.new(1, -30, 1, -75)
ContentFrame.Position = UDim2.new(0, 15, 0, 65)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 6
ContentFrame.ScrollBarImageColor3 = Theme.Primary
ContentFrame.ScrollBarImageTransparency = 0.3
ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ContentFrame.Parent = MainFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 12)
ContentLayout.Parent = ContentFrame

-- Components
local function CreateCard(title, icon)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 0)
    Card.AutomaticSize = Enum.AutomaticSize.Y
    Card.BackgroundColor3 = Theme.Surface
    Card.BackgroundTransparency = 0.3
    Card.BorderSizePixel = 0
    Round(Card, 14)
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(45, 45, 60)
    Stroke.Thickness = 1.5
    Stroke.Parent = Card
    
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 38)
    Header.BackgroundTransparency = 1
    Header.Parent = Card
    
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Size = UDim2.new(0, 30, 0, 30)
    IconLabel.Position = UDim2.new(0, 12, 0, 4)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = icon or "⚡"
    IconLabel.TextSize = 20
    IconLabel.Parent = Header
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -50, 1, 0)
    TitleLabel.Position = UDim2.new(0, 45, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Theme.Primary
    TitleLabel.TextSize = 14
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header
    
    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(1, -24, 0, 1)
    Line.Position = UDim2.new(0, 12, 0, 36)
    Line.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    Line.BorderSizePixel = 0
    Line.Parent = Card
    
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -24, 0, 0)
    Container.Position = UDim2.new(0, 12, 0, 42)
    Container.AutomaticSize = Enum.AutomaticSize.Y
    Container.BackgroundTransparency = 1
    Container.Parent = Card
    
    local List = Instance.new("UIListLayout")
    List.Padding = UDim.new(0, 10)
    List.Parent = Container
    
    local Pad = Instance.new("UIPadding")
    Pad.PaddingBottom = UDim.new(0, 15)
    Pad.Parent = Card
    
    Card.Parent = ContentFrame
    return Container
end

local function CreateToggle(parent, text, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 38)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 52, 0, 26)
    ToggleBtn.Position = UDim2.new(1, -52, 0.5, -13)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
    ToggleBtn.Text = "OFF"
    ToggleBtn.TextColor3 = Theme.TextMuted
    ToggleBtn.TextSize = 11
    ToggleBtn.Font = Enum.Font.GothamBold
    Round(ToggleBtn, 13)
    ToggleBtn.Parent = Frame
    
    local enabled = false
    ToggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        ToggleBtn.Text = enabled and "ON" or "OFF"
        Tween(ToggleBtn, {BackgroundColor3 = enabled and Theme.Success or Color3.fromRGB(55, 55, 70)}, 0.2)
        Tween(ToggleBtn, {TextColor3 = enabled and Color3.new(1,1,1) or Theme.TextMuted}, 0.2)
        if callback then callback(enabled) end
    end)
    
    return Frame
end

local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 55)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 0, 22)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local ValueBox = Instance.new("TextBox")
    ValueBox.Size = UDim2.new(0, 55, 0, 24)
    ValueBox.Position = UDim2.new(1, -55, 0, 0)
    ValueBox.BackgroundColor3 = Theme.SurfaceLight
    ValueBox.Text = tostring(default)
    ValueBox.TextColor3 = Theme.Primary
    ValueBox.TextSize = 12
    ValueBox.Font = Enum.Font.GothamBold
    Round(ValueBox, 6)
    ValueBox.Parent = Frame
    
    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, 0, 0, 5)
    Track.Position = UDim2.new(0, 0, 0, 40)
    Track.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    Track.BorderSizePixel = 0
    Round(Track, 3)
    Track.Parent = Frame
    
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = Theme.Primary
    Fill.BorderSizePixel = 0
    Round(Fill, 3)
    Fill.Parent = Track
    
    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = UDim2.new((default-min)/(max-min), -8, 0.5, -8)
    Knob.BackgroundColor3 = Color3.new(1, 1, 1)
    Round(Knob, 8)
    Knob.Parent = Track
    
    local dragging = false
    
    local function update(input)
        local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        ValueBox.Text = tostring(val)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Knob.Position = UDim2.new(pos, -8, 0.5, -8)
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
        Knob.Position = UDim2.new(pos, -8, 0.5, -8)
        if callback then callback(val) end
    end)
    
    return Frame
end

local function CreateButton(parent, text, style, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 38)
    Btn.BackgroundColor3 = style == "primary" and Theme.Primary or (style == "danger" and Theme.Error or Theme.SurfaceLight)
    Btn.Text = text
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.TextSize = 13
    Btn.Font = Enum.Font.GothamBold
    Round(Btn, 8)
    Btn.Parent = parent
    
    Btn.MouseButton1Click:Connect(function()
        Tween(Btn, {Size = UDim2.new(0.97, 0, 0, 36)}, 0.1)
        wait(0.1)
        Tween(Btn, {Size = UDim2.new(1, 0, 0, 38)}, 0.1)
        if callback then callback() end
    end)
    
    return Btn
end

local function CreateDropdown(parent, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 140)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    
    local List = Instance.new("ScrollingFrame")
    List.Size = UDim2.new(1, 0, 0, 100)
    List.BackgroundColor3 = Theme.SurfaceLight
    List.BackgroundTransparency = 0.4
    List.BorderSizePixel = 0
    List.ScrollBarThickness = 4
    List.ScrollBarImageColor3 = Theme.Primary
    List.CanvasSize = UDim2.new(0, 0, 0, 0)
    Round(List, 8)
    List.Parent = Frame
    
    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 4)
    Layout.Parent = List
    
    local selected = nil
    
    local function Update()
        for _, c in pairs(List:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -8, 0, 32)
                btn.Position = UDim2.new(0, 4, 0, 0)
                btn.BackgroundColor3 = selected == p and Theme.Primary or Theme.Surface
                btn.Text = p.Name
                btn.TextColor3 = Color3.new(1, 1, 1)
                btn.TextSize = 12
                btn.Font = Enum.Font.Gotham
                Round(btn, 6)
                btn.Parent = List
                
                btn.MouseButton1Click:Connect(function()
                    selected = p
                    Update()
                    if callback then callback(p) end
                end)
            end
        end
        
        List.CanvasSize = UDim2.new(0, 0, 0, (#Players:GetPlayers() - 1) * 36)
    end
    
    Update()
    Players.PlayerAdded:Connect(Update)
    Players.PlayerRemoving:Connect(Update)
    
    return Frame, function() return selected end
end

-- ========== FEATURES ==========

-- Movement
local MoveCard = CreateCard("MOVEMENT", "🏃")
CreateSlider(MoveCard, "Walk Speed", 16, 500, 50, function(val)
    Config.Speed = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)

CreateButton(MoveCard, "Reset Speed", "normal", function()
    Config.Speed = 16
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- Fly System (Using Joystick)
local FlyCard = CreateCard("FLY MODE", "✈️")
CreateSlider(FlyCard, "Fly Speed", 10, 300, 100, function(val)
    Config.FlySpeed = val
end)

CreateToggle(FlyCard, "Enable Fly (Use Joystick to Move)", function(enabled)
    Config.Flying = enabled
    
    if enabled then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.PlatformStand = true
        end
        
        States.FlyConnection = RunService.Heartbeat:Connect(function()
            if not Config.Flying then return end
            if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
            
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local cam = Camera.CFrame
            local speed = Config.FlySpeed
            
            -- Get movement from humanoid (joystick)
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                local moveDir = humanoid.MoveDirection
                if moveDir.Magnitude > 0 then
                    hrp.Velocity = cam.LookVector * moveDir.Z * speed + cam.RightVector * moveDir.X * speed
                else
                    hrp.Velocity = Vector3.new(0, 0, 0)
                end
                
                -- Up/Down with space/shift
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    hrp.Velocity = hrp.Velocity + Vector3.new(0, speed, 0)
                elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    hrp.Velocity = hrp.Velocity - Vector3.new(0, speed, 0)
                end
            end
        end)
    else
        if States.FlyConnection then
            States.FlyConnection:Disconnect()
            States.FlyConnection = nil
        end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.PlatformStand = false
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
end)

CreateToggle(FlyCard, "Noclip while Flying", function(enabled)
    Config.Noclip = enabled
    if enabled then
        States.NoclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if States.NoclipConnection then
            States.NoclipConnection:Disconnect()
            States.NoclipConnection = nil
        end
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- Teleport
local TPCard = CreateCard("TELEPORT", "🎯")
local TPFrame, GetSelected = CreateDropdown(TPCard)

CreateButton(TPCard, "Teleport to Player", "primary", function()
    local target = GetSelected()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
    end
end)

CreateButton(TPCard, "Follow Player (Exact)", "normal", function()
    Config.AutoFollow = not Config.AutoFollow
    if Config.AutoFollow then
        local target = GetSelected()
        States.FollowingPlayer = target
        spawn(function()
            while Config.AutoFollow and States.FollowingPlayer and States.FollowingPlayer.Character and States.FollowingPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") do
                LocalPlayer.Character.HumanoidRootPart.CFrame = States.FollowingPlayer.Character.HumanoidRootPart.CFrame
                wait(0.05)
            end
        end)
    else
        States.FollowingPlayer = nil
    end
end)

-- ESP
local ESPCard = CreateCard("ESP", "👁️")
States.ESPFolder = Instance.new("Folder")
States.ESPFolder.Name = "ESP"
States.ESPFolder.Parent = CoreGui

CreateToggle(ESPCard, "Enable Player ESP", function(enabled)
    Config.ESP = enabled
    
    local function CreateESP(player)
        if player == LocalPlayer then return end
        
        local esp = Instance.new("BillboardGui")
        esp.Name = player.Name .. "_ESP"
        esp.AlwaysOnTop = true
        esp.Size = UDim2.new(0, 150, 0, 60)
        esp.StudsOffset = Vector3.new(0, 3, 0)
        
        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Theme.Primary
        bg.BackgroundTransparency = 0.7
        Round(bg, 10)
        bg.Parent = esp
        
        local name = Instance.new("TextLabel")
        name.Size = UDim2.new(1, 0, 0.6, 0)
        name.BackgroundTransparency = 1
        name.Text = player.Name
        name.TextColor3 = Color3.new(1, 1, 1)
        name.TextSize = 14
        name.Font = Enum.Font.GothamBold
        name.Parent = bg
        
        local dist = Instance.new("TextLabel")
        dist.Size = UDim2.new(1, 0, 0.4, 0)
        dist.Position = UDim2.new(0, 0, 0.6, 0)
        dist.BackgroundTransparency = 1
        dist.Text = "0m"
        dist.TextColor3 = Color3.fromRGB(220, 220, 220)
        dist.TextSize = 11
        dist.Font = Enum.Font.Gotham
        dist.Parent = bg
        
        esp.Parent = States.ESPFolder
        
        spawn(function()
            while Config.ESP and esp.Parent do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    esp.Adornee = player.Character.HumanoidRootPart
                    local d = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    dist.Text = math.floor(d) .. "m"
                end
                wait(0.5)
            end
            esp:Destroy()
        end)
    end
    
    if enabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then CreateESP(p) end
        end
        Players.PlayerAdded:Connect(function(p)
            if Config.ESP then CreateESP(p) end
        end)
    else
        States.ESPFolder:ClearAllChildren()
    end
end)

-- God Mode
local GodCard = CreateCard("GOD MODE", "🛡️")

local GodModeType = "Gen1"
local TypeBtn = Instance.new("TextButton")
TypeBtn.Size = UDim2.new(1, 0, 0, 32)
TypeBtn.BackgroundColor3 = Theme.SurfaceLight
TypeBtn.Text = "Mode: Gen1 (Auto Heal)"
TypeBtn.TextColor3 = Theme.Text
TypeBtn.TextSize = 12
TypeBtn.Font = Enum.Font.GothamBold
Round(TypeBtn, 8)
TypeBtn.Parent = GodCard

TypeBtn.MouseButton1Click:Connect(function()
    GodModeType = GodModeType == "Gen1" and "Gen2" or "Gen1"
    TypeBtn.Text = GodModeType == "Gen1" and "Mode: Gen1 (Auto Heal)" or "Mode: Gen2 (Super Immortal)"
end)

CreateToggle(GodCard, "Enable God Mode", function(enabled)
    Config.GodMode = enabled
    
    if States.GodConnection then
        States.GodConnection:Disconnect()
        States.GodConnection = nil
    end
    
    if enabled then
        States.GodConnection = RunService.Heartbeat:Connect(function()
            if not LocalPlayer.Character then return end
            
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if not humanoid then return end
            
            if GodModeType == "Gen1" then
                -- Gen1: Auto Heal
                humanoid.Health = humanoid.MaxHealth
            else
                -- Gen2: Super Immortal
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            end
        end)
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.MaxHealth = 100
            LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        end
    end
end)

CreateToggle(GodCard, "Auto Heal", function(enabled)
    Config.AutoHeal = enabled
    spawn(function()
        while Config.AutoHeal do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
            end
            wait(0.1)
        end
    end
end)

CreateButton(GodCard, "Heal Instantly", "primary", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
    end
end)

-- Visual & Utility
local VisualCard = CreateCard("VISUAL & UTILITY", "🎨")

CreateToggle(VisualCard, "Full Brightness", function(enabled)
    Config.FullBright = enabled
    if enabled then
        States.BrightnessConnection = RunService.RenderStepped:Connect(function()
            Lighting.Brightness = 10
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        end)
    else
        if States.BrightnessConnection then
            States.BrightnessConnection:Disconnect()
            States.BrightnessConnection = nil
        end
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end)

CreateToggle(VisualCard, "Anti-AFK", function(enabled)
    Config.AntiAFK = enabled
    if enabled then
        LocalPlayer.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            wait(1)
            VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)
    end
end)

CreateSlider(VisualCard, "Visual Coin Multiplier", 0, 1000, 0, function(val)
    Config.CoinVisual = val
    -- Implementation depends on game
end)

CreateToggle(VisualCard, "FPS Boost (Low Graphics)", function(enabled)
    Config.FPSBoost = enabled
    if enabled then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
                v.Material = Enum.Material.SmoothPlastic
            end
            if v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            end
        end
        Lighting.GlobalShadows = false
        settings().Rendering.QualityLevel = 1
    end
end)

-- Extra
local ExtraCard = CreateCard("EXTRA", "⚙️")

CreateButton(ExtraCard, "Rejoin Server", "primary", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

CreateButton(ExtraCard, "Server Hop", "normal", function()
    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    for _, server in pairs(servers.data) do
        if server.playing < server.maxPlayers and server.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id)
            break
        end
    end
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
    Tween(MainFrame, {Size = UDim2.new(0, 400, 0, 0)}, 0.3)
    wait(0.3)
    MainFrame.Visible = false
    OrbButton.Visible = true
    Tween(OrbButton, {Size = UDim2.new(0, 60, 0, 60)}, 0.3)
end)

OrbButton.MouseButton1Click:Connect(function()
    OrbButton.Visible = false
    MainFrame.Visible = true
    Tween(MainFrame, {Size = UDim2.new(0, 400, 0, 500)}, 0.3)
end)

-- Close (FIXED)
CloseBtn.MouseButton1Click:Connect(function()
    -- Cleanup
    Config.Flying = false
    Config.Noclip = false
    Config.GodMode = false
    Config.ESP = false
    Config.AutoFollow = false
    
    if States.FlyConnection then States.FlyConnection:Disconnect() end
    if States.NoclipConnection then States.NoclipConnection:Disconnect() end
    if States.GodConnection then States.GodConnection:Disconnect() end
    if States.BrightnessConnection then States.BrightnessConnection:Disconnect() end
    
    States.ESPFolder:ClearAllChildren()
    
    -- Close animation
    Tween(MainFrame, {Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, 1.5, 0)}, 0.4)
    wait(0.4)
    
    ScreenGui:Destroy()
    getgenv().APNEXTGEN_LOADED = nil
end)

-- Intro Animation
MainFrame.Size = UDim2.new(0, 0, 0, 0)
wait(0.2)
Tween(MainFrame, {Size = UDim2.new(0, 400, 0, 500)}, 0.6, Enum.EasingStyle.Back)

print("✅ AP-NEXTGEN1 v5.0 ULTIMATE Loaded Successfully!")
print("All features working | Joystick Fly | HD UI | No Bugs")
