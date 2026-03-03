--[[
    AP-NEXTGEN HUB v8.0 FINAL STABLE
    Perfect UI | All Features Working | Mobile Optimized
    Created by: APTECH
]]

-- Anti-duplicate
if getgenv().APNEXTGEN_LOADED then return end
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
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
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
    FlySpeed = 100,
    GodMode = false,
    GodModeType = "Gen1",
    Noclip = false,
    Flying = false,
    ESPPlayers = false,
    ESPItems = false,
    ESPBlocks = false,
    AutoFollow = false,
    AutoHeal = false,
    FullBright = false,
    AntiAFK = false,
    FPSBoost = false,
    InfiniteJump = false,
    CoinVisual = 0,
    IsAdmin = false,
    ZoomUnlock = false
}

-- State
local States = {
    FollowingPlayer = nil,
    ESPPlayerFolder = nil,
    ESPItemFolder = nil,
    ESPBlockFolder = nil,
    AdminESPFolder = nil,
    NoclipConnection = nil,
    GodConnection = nil,
    FlyConnection = nil,
    BrightnessConnection = nil,
    JumpConnection = nil,
    PlayerESPConnection = nil,
    ItemESPConnection = nil,
    BlockESPConnection = nil,
    AFKConnection = nil,
    ZoomConnection = nil,
    Connections = {}
}

-- Cleanup
local function Cleanup()
    for _, conn in pairs(States.Connections) do
        if conn then conn:Disconnect() end
    end
    if States.NoclipConnection then States.NoclipConnection:Disconnect() end
    if States.GodConnection then States.GodConnection:Disconnect() end
    if States.FlyConnection then States.FlyConnection:Disconnect() end
    if States.BrightnessConnection then States.BrightnessConnection:Disconnect() end
    if States.JumpConnection then States.JumpConnection:Disconnect() end
    if States.ZoomConnection then States.ZoomConnection:Disconnect() end
    if States.PlayerESPConnection then States.PlayerESPConnection:Disconnect() end
    if States.ItemESPConnection then States.ItemESPConnection:Disconnect() end
    if States.BlockESPConnection then States.BlockESPConnection:Disconnect() end
    if States.ESPPlayerFolder then States.ESPPlayerFolder:Destroy() end
    if States.ESPItemFolder then States.ESPItemFolder:Destroy() end
    if States.ESPBlockFolder then States.ESPBlockFolder:Destroy() end
    getgenv().APNEXTGEN_LOADED = nil
end

-- Theme
local Theme = {
    Background = Color3.fromRGB(15, 15, 20),
    Surface = Color3.fromRGB(25, 25, 35),
    SurfaceLight = Color3.fromRGB(40, 40, 55),
    Primary = Color3.fromRGB(0, 200, 255),
    Secondary = Color3.fromRGB(150, 80, 255),
    Success = Color3.fromRGB(0, 255, 130),
    Warning = Color3.fromRGB(255, 200, 50),
    Error = Color3.fromRGB(255, 70, 90),
    Admin = Color3.fromRGB(255, 215, 0),
    Text = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(180, 180, 200)
}

-- Utility
local function Tween(obj, props, dur)
    TweenService:Create(obj, TweenInfo.new(dur or 0.3, Enum.EasingStyle.Quart), props):Play()
end

local function Round(parent, rad)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, rad or 10)
    c.Parent = parent
    return c
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "APNEXTGEN_FINAL"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ========== OPENING (SIMPLE & STABLE) ==========
local IntroGui = Instance.new("ScreenGui")
IntroGui.Name = "Intro"
IntroGui.Parent = CoreGui
IntroGui.DisplayOrder = 9999

local IntroFrame = Instance.new("Frame")
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
IntroFrame.BorderSizePixel = 0
IntroFrame.Parent = IntroGui

local IntroGradient = Instance.new("UIGradient")
IntroGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 35)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(45, 45, 55)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 35))
})
IntroGradient.Rotation = 45
IntroGradient.Parent = IntroFrame

-- Simple particles
for i = 1, 10 do
    local p = Instance.new("Frame")
    p.Size = UDim2.new(0, 4, 0, 4)
    p.Position = UDim2.new(math.random(), 0, 1.2, 0)
    p.BackgroundColor3 = Theme.Primary
    p.BackgroundTransparency = 0.6
    p.BorderSizePixel = 0
    Round(p, 2)
    p.Parent = IntroFrame
    
    spawn(function()
        while p.Parent do
            Tween(p, {Position = UDim2.new(p.Position.X.Scale, 0, -0.2, 0)}, math.random(5, 10))
            wait(math.random(5, 10))
            p.Position = UDim2.new(math.random(), 0, 1.2, 0)
        end
    end)
end

-- Title (Scaled for mobile)
local TitleFrame = Instance.new("Frame")
TitleFrame.Size = UDim2.new(0.9, 0, 0, 150)
TitleFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
TitleFrame.BackgroundTransparency = 1
TitleFrame.Parent = IntroFrame

local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(1, 0, 0.6, 0)
MainTitle.BackgroundTransparency = 1
MainTitle.Text = "AP-NEXTGEN1"
MainTitle.TextColor3 = Theme.Primary
MainTitle.TextSize = 40
MainTitle.Font = Enum.Font.GothamBlack
MainTitle.TextScaled = true
MainTitle.Parent = TitleFrame

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, 0, 0.3, 0)
SubTitle.Position = UDim2.new(0, 0, 0.65, 0)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "by APTECH"
SubTitle.TextColor3 = Theme.TextMuted
SubTitle.TextSize = 20
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextScaled = true
SubTitle.Parent = TitleFrame

-- Loading bar
local LoadBg = Instance.new("Frame")
LoadBg.Size = UDim2.new(0.7, 0, 0, 4)
LoadBg.Position = UDim2.new(0.15, 0, 0.7, 0)
LoadBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
LoadBg.BorderSizePixel = 0
Round(LoadBg, 2)
LoadBg.Parent = IntroFrame

local LoadBar = Instance.new("Frame")
LoadBar.Size = UDim2.new(0, 0, 1, 0)
LoadBar.BackgroundColor3 = Theme.Primary
LoadBar.BorderSizePixel = 0
Round(LoadBar, 2)
LoadBar.Parent = LoadBg

-- Version
local VersionText = Instance.new("TextLabel")
VersionText.Size = UDim2.new(1, 0, 0, 30)
VersionText.Position = UDim2.new(0, 0, 0.9, 0)
VersionText.BackgroundTransparency = 1
VersionText.Text = "v8.0 FINAL"
VersionText.TextColor3 = Color3.fromRGB(100, 100, 120)
VersionText.TextSize = 14
VersionText.Font = Enum.Font.Gotham
VersionText.Parent = IntroFrame

-- Animate
spawn(function()
    wait(0.5)
    Tween(LoadBar, {Size = UDim2.new(1, 0, 1, 0)}, 2)
    wait(2.2)
    
    Tween(IntroFrame, {BackgroundTransparency = 1}, 0.5)
    Tween(MainTitle, {TextTransparency = 1}, 0.4)
    Tween(SubTitle, {TextTransparency = 1}, 0.4)
    Tween(LoadBg, {BackgroundTransparency = 1}, 0.3)
    Tween(LoadBar, {BackgroundTransparency = 1}, 0.3)
    
    wait(0.5)
    IntroGui:Destroy()
end)

wait(3)

-- ========== MAIN UI (SIMPLE & STABLE) ==========
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 400)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Round(MainFrame, 15)
MainFrame.Parent = ScreenGui

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Theme.Surface
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
Round(TopBar, 15)

local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 20)
TopFix.Position = UDim2.new(0, 0, 1, -20)
TopFix.BackgroundColor3 = Theme.Surface
TopFix.BorderSizePixel = 0
TopFix.Parent = TopBar

-- Profile (Small)
local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 36, 0, 36)
AvatarImg.Position = UDim2.new(0, 10, 0.5, -18)
AvatarImg.BackgroundColor3 = Theme.SurfaceLight
AvatarImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
Round(AvatarImg, 18)
AvatarImg.Parent = TopBar

local NameText = Instance.new("TextLabel")
NameText.Size = UDim2.new(0, 150, 0, 20)
NameText.Position = UDim2.new(0, 52, 0, 5)
NameText.BackgroundTransparency = 1
NameText.Text = LocalPlayer.Name
NameText.TextColor3 = Theme.Text
NameText.TextSize = 14
NameText.Font = Enum.Font.GothamBold
NameText.TextXAlignment = Enum.TextXAlignment.Left
NameText.TextTruncate = Enum.TextTruncate.AtEnd
NameText.Parent = TopBar

local GameText = Instance.new("TextLabel")
NameText.Size = UDim2.new(0, 150, 0, 15)
GameText.Position = UDim2.new(0, 52, 0, 26)
GameText.BackgroundTransparency = 1
GameText.Text = game.Name .. " | " .. #Players:GetPlayers() .. " players"
GameText.TextColor3 = Theme.TextMuted
GameText.TextSize = 10
GameText.Font = Enum.Font.Gotham
GameText.TextXAlignment = Enum.TextXAlignment.Left
GameText.TextTruncate = Enum.TextTruncate.AtEnd
GameText.Parent = TopBar

-- Update player count
spawn(function()
    while GameText.Parent do
        GameText.Text = game.Name .. " | " .. #Players:GetPlayers() .. " players"
        wait(5)
    end
end)

-- Controls
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0.5, -15)
MinBtn.BackgroundColor3 = Theme.SurfaceLight
MinBtn.Text = "−"
MinBtn.TextColor3 = Theme.TextMuted
MinBtn.TextSize = 20
MinBtn.Font = Enum.Font.GothamBold
Round(MinBtn, 6)
MinBtn.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -15)
CloseBtn.BackgroundColor3 = Theme.Error
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 20
CloseBtn.Font = Enum.Font.GothamBold
Round(CloseBtn, 6)
CloseBtn.Parent = TopBar

-- Content
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -65)
Content.Position = UDim2.new(0, 10, 0, 60)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 5
Content.ScrollBarImageColor3 = Theme.Primary
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.ScrollingDirection = Enum.ScrollingDirection.Y
Content.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 10)
ListLayout.Parent = Content

-- Components
local function CreateCard(title)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 0)
    Card.AutomaticSize = Enum.AutomaticSize.Y
    Card.BackgroundColor3 = Theme.Surface
    Card.BackgroundTransparency = 0.2
    Card.BorderSizePixel = 0
    Round(Card, 12)
    
    local CardTitle = Instance.new("TextLabel")
    CardTitle.Size = UDim2.new(1, -20, 0, 28)
    CardTitle.Position = UDim2.new(0, 10, 0, 6)
    CardTitle.BackgroundTransparency = 1
    CardTitle.Text = title
    CardTitle.TextColor3 = Theme.Primary
    CardTitle.TextSize = 13
    CardTitle.Font = Enum.Font.GothamBold
    CardTitle.TextXAlignment = Enum.TextXAlignment.Left
    CardTitle.Parent = Card
    
    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(1, -20, 0, 1)
    Line.Position = UDim2.new(0, 10, 0, 32)
    Line.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
    Line.BorderSizePixel = 0
    Line.Parent = Card
    
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -20, 0, 0)
    Container.Position = UDim2.new(0, 10, 0, 38)
    Container.AutomaticSize = Enum.AutomaticSize.Y
    Container.BackgroundTransparency = 1
    Container.Parent = Card
    
    local ContList = Instance.new("UIListLayout")
    ContList.Padding = UDim.new(0, 8)
    ContList.Parent = Container
    
    local Pad = Instance.new("UIPadding")
    Pad.PaddingBottom = UDim.new(0, 12)
    Pad.Parent = Card
    
    Card.Parent = Content
    return Container
end

local function CreateToggle(parent, text, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 34)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.TextSize = 12
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 48, 0, 26)
    Btn.Position = UDim2.new(1, -48, 0.5, -13)
    Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    Btn.Text = "OFF"
    Btn.TextColor3 = Theme.TextMuted
    Btn.TextSize = 11
    Btn.Font = Enum.Font.GothamBold
    Round(Btn, 13)
    Btn.Parent = Frame
    
    local enabled = false
    Btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        Btn.Text = enabled and "ON" or "OFF"
        Tween(Btn, {BackgroundColor3 = enabled and Theme.Success or Color3.fromRGB(60, 60, 75)}, 0.2)
        Tween(Btn, {TextColor3 = enabled and Color3.new(1,1,1) or Theme.TextMuted}, 0.2)
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
    Track.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
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
    Btn.Size = UDim2.new(1, 0, 0, 36)
    Btn.BackgroundColor3 = style == "primary" and Theme.Primary or (style == "admin" and Theme.Admin or Theme.SurfaceLight)
    Btn.Text = text
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.TextSize = 12
    Btn.Font = Enum.Font.GothamBold
    Round(Btn, 8)
    Btn.Parent = parent
    
    Btn.MouseButton1Click:Connect(function()
        Tween(Btn, {Size = UDim2.new(0.97, 0, 0, 34)}, 0.1)
        wait(0.1)
        Tween(Btn, {Size = UDim2.new(1, 0, 0, 36)}, 0.1)
        if callback then callback() end
    end)
    
    return Btn
end

-- ========== ORB BUTTON (DRAGGABLE) ==========
local OrbButton = Instance.new("TextButton")
OrbButton.Size = UDim2.new(0, 50, 0, 50)
OrbButton.Position = UDim2.new(0, 15, 0.5, -25)
OrbButton.BackgroundColor3 = Theme.Primary
OrbButton.Text = "G1"
OrbButton.TextColor3 = Color3.new(1, 1, 1)
OrbButton.TextSize = 20
OrbButton.Font = Enum.Font.GothamBlack
OrbButton.Visible = false
OrbButton.ZIndex = 100
OrbButton.Active = true
OrbButton.Draggable = true
Round(OrbButton, 25)

local OrbStroke = Instance.new("UIStroke")
OrbStroke.Color = Theme.Primary
OrbStroke.Thickness = 2
OrbStroke.Parent = OrbButton

OrbButton.Parent = ScreenGui

-- ========== FLY PANEL (DRAGGABLE) ==========
local FlyGui = Instance.new("ScreenGui")
FlyGui.Name = "FlyPanel"
FlyGui.Parent = CoreGui
FlyGui.Enabled = false

local FlyPanel = Instance.new("Frame")
FlyPanel.Size = UDim2.new(0, 200, 0, 280)
FlyPanel.Position = UDim2.new(0.7, 0, 0.5, -140)
FlyPanel.BackgroundColor3 = Theme.Surface
FlyPanel.BackgroundTransparency = 0.1
FlyPanel.BorderSizePixel = 0
FlyPanel.Active = true
FlyPanel.Draggable = true
FlyPanel.Visible = false
Round(FlyPanel, 15)

local FlyStroke = Instance.new("UIStroke")
FlyStroke.Color = Theme.Primary
FlyStroke.Thickness = 2
FlyStroke.Parent = FlyPanel

local FlyTitle = Instance.new("TextLabel")
FlyTitle.Size = UDim2.new(1, 0, 0, 35)
FlyTitle.BackgroundTransparency = 1
FlyTitle.Text = "✈️ FLY CONTROL"
FlyTitle.TextColor3 = Theme.Primary
FlyTitle.TextSize = 14
FlyTitle.Font = Enum.Font.GothamBlack
FlyTitle.Parent = FlyPanel

local CloseFlyBtn = Instance.new("TextButton")
CloseFlyBtn.Size = UDim2.new(0, 26, 0, 26)
CloseFlyBtn.Position = UDim2.new(1, -32, 0, 6)
CloseFlyBtn.BackgroundColor3 = Theme.Error
CloseFlyBtn.Text = "×"
CloseFlyBtn.TextColor3 = Color3.new(1, 1, 1)
CloseFlyBtn.TextSize = 16
CloseFlyBtn.Font = Enum.Font.GothamBold
Round(CloseFlyBtn, 6)
CloseFlyBtn.Parent = FlyPanel

-- Speed
local FlySpeedText = Instance.new("TextLabel")
FlySpeedText.Size = UDim2.new(1, -20, 0, 18)
FlySpeedText.Position = UDim2.new(0, 10, 0, 40)
FlySpeedText.BackgroundTransparency = 1
FlySpeedText.Text = "Speed: 100"
FlySpeedText.TextColor3 = Theme.Text
FlySpeedText.TextSize = 12
FlySpeedText.Font = Enum.Font.GothamBold
FlySpeedText.Parent = FlyPanel

local FlyTrack = Instance.new("Frame")
FlyTrack.Size = UDim2.new(1, -20, 0, 4)
FlyTrack.Position = UDim2.new(0, 10, 0, 60)
FlyTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
FlyTrack.BorderSizePixel = 0
Round(FlyTrack, 2)
FlyTrack.Parent = FlyPanel

local FlyFill = Instance.new("Frame")
FlyFill.Size = UDim2.new(0.2, 0, 1, 0)
FlyFill.BackgroundColor3 = Theme.Primary
FlyFill.BorderSizePixel = 0
Round(FlyFill, 2)
FlyFill.Parent = FlyTrack

local FlyKnob = Instance.new("Frame")
FlyKnob.Size = UDim2.new(0, 14, 0, 14)
FlyKnob.Position = UDim2.new(0.2, -7, 0.5, -7)
FlyKnob.BackgroundColor3 = Color3.new(1, 1, 1)
Round(FlyKnob, 7)
FlyKnob.Parent = FlyTrack

-- Fly Toggles
local FlyToggleBtn = Instance.new("TextButton")
FlyToggleBtn.Size = UDim2.new(1, -20, 0, 40)
FlyToggleBtn.Position = UDim2.new(0, 10, 0, 80)
FlyToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
FlyToggleBtn.Text = "FLY: OFF"
FlyToggleBtn.TextColor3 = Theme.TextMuted
FlyToggleBtn.TextSize = 13
FlyToggleBtn.Font = Enum.Font.GothamBold
Round(FlyToggleBtn, 10)
FlyToggleBtn.Parent = FlyPanel

local NoclipToggleBtn = Instance.new("TextButton")
NoclipToggleBtn.Size = UDim2.new(1, -20, 0, 40)
NoclipToggleBtn.Position = UDim2.new(0, 10, 0, 130)
NoclipToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
NoclipToggleBtn.Text = "NOCLIP: OFF"
NoclipToggleBtn.TextColor3 = Theme.TextMuted
NoclipToggleBtn.TextSize = 13
NoclipToggleBtn.Font = Enum.Font.GothamBold
Round(NoclipToggleBtn, 10)
NoclipToggleBtn.Parent = FlyPanel

-- Instructions
local FlyInstr = Instance.new("TextLabel")
FlyInstr.Size = UDim2.new(1, -20, 0, 90)
FlyInstr.Position = UDim2.new(0, 10, 0, 180)
FlyInstr.BackgroundTransparency = 1
FlyInstr.Text = "Controls:\n• Joystick = Move\n• Space = Up\n• Shift = Down\n• Camera = Direction"
FlyInstr.TextColor3 = Theme.TextMuted
FlyInstr.TextSize = 11
FlyInstr.Font = Enum.Font.Gotham
FlyInstr.TextYAlignment = Enum.TextYAlignment.Top
FlyInstr.Parent = FlyPanel

FlyPanel.Parent = FlyGui

-- Fly Logic (Perfect Camera Lock)
local flyDragging = false
FlyTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        flyDragging = true
        local pos = math.clamp((input.Position.X - FlyTrack.AbsolutePosition.X) / FlyTrack.AbsoluteSize.X, 0, 1)
        local val = math.floor(10 + 490 * pos)
        Config.FlySpeed = val
        FlySpeedText.Text = "Speed: " .. val
        FlyFill.Size = UDim2.new(pos, 0, 1, 0)
        FlyKnob.Position = UDim2.new(pos, -7, 0.5, -7)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if flyDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local pos = math.clamp((input.Position.X - FlyTrack.AbsolutePosition.X) / FlyTrack.AbsoluteSize.X, 0, 1)
        local val = math.floor(10 + 490 * pos)
        Config.FlySpeed = val
        FlySpeedText.Text = "Speed: " .. val
        FlyFill.Size = UDim2.new(pos, 0, 1, 0)
        FlyKnob.Position = UDim2.new(pos, -7, 0.5, -7)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    flyDragging = false
end)

-- Fly Toggle
FlyToggleBtn.MouseButton1Click:Connect(function()
    Config.Flying = not Config.Flying
    
    if Config.Flying then
        FlyToggleBtn.Text = "FLY: ON"
        Tween(FlyToggleBtn, {BackgroundColor3 = Theme.Success, TextColor3 = Color3.new(1,1,1)}, 0.2)
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.PlatformStand = true
        end
        
        if States.FlyConnection then States.FlyConnection:Disconnect() end
        
        States.FlyConnection = RunService.Heartbeat:Connect(function()
            if not Config.Flying then return end
            if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
            
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            
            if humanoid then
                local camCF = Camera.CFrame
                local moveDir = humanoid.MoveDirection
                
                if moveDir.Magnitude > 0 then
                    -- Perfect camera-aligned movement
                    local camLook = Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z).Unit
                    local camRight = Vector3.new(camCF.RightVector.X, 0, camCF.RightVector.Z).Unit
                    
                    local velocity = (camLook * moveDir.Z + camRight * moveDir.X) * Config.FlySpeed
                    hrp.Velocity = Vector3.new(velocity.X, hrp.Velocity.Y, velocity.Z)
                else
                    hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0)
                end
                
                -- Vertical
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, Config.FlySpeed, hrp.Velocity.Z)
                elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, -Config.FlySpeed, hrp.Velocity.Z)
                else
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
                end
            end
        end)
    else
        FlyToggleBtn.Text = "FLY: OFF"
        Tween(FlyToggleBtn, {BackgroundColor3 = Color3.fromRGB(60, 60, 75), TextColor3 = Theme.TextMuted}, 0.2)
        
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

-- Noclip Toggle
NoclipToggleBtn.MouseButton1Click:Connect(function()
    Config.Noclip = not Config.Noclip
    
    if Config.Noclip then
        NoclipToggleBtn.Text = "NOCLIP: ON"
        Tween(NoclipToggleBtn, {BackgroundColor3 = Theme.Success, TextColor3 = Color3.new(1,1,1)}, 0.2)
        
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
        NoclipToggleBtn.Text = "NOCLIP: OFF"
        Tween(NoclipToggleBtn, {BackgroundColor3 = Color3.fromRGB(60, 60, 75), TextColor3 = Theme.TextMuted}, 0.2)
        
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

CloseFlyBtn.MouseButton1Click:Connect(function()
    FlyGui.Enabled = false
    FlyPanel.Visible = false
end)

-- ========== ADMIN SYSTEM ==========
local AdminGui = Instance.new("ScreenGui")
AdminGui.Name = "AdminPanel"
AdminGui.Parent = CoreGui
AdminGui.Enabled = false

local AdminPanel = Instance.new("Frame")
AdminPanel.Size = UDim2.new(0, 280, 0, 180)
AdminPanel.Position = UDim2.new(0.5, -140, 0.5, -90)
AdminPanel.BackgroundColor3 = Theme.Surface
AdminPanel.BorderSizePixel = 0
AdminPanel.Visible = false
Round(AdminPanel, 15)

local AdminStroke = Instance.new("UIStroke")
AdminStroke.Color = Theme.Admin
AdminStroke.Thickness = 2
AdminStroke.Parent = AdminPanel

local AdminTitle = Instance.new("TextLabel")
AdminTitle.Size = UDim2.new(1, 0, 0, 40)
AdminTitle.BackgroundTransparency = 1
AdminTitle.Text = "🔐 ADMIN ACCESS"
AdminTitle.TextColor3 = Theme.Admin
AdminTitle.TextSize = 18
AdminTitle.Font = Enum.Font.GothamBlack
AdminTitle.Parent = AdminPanel

local PasswordBox = Instance.new("TextBox")
PasswordBox.Size = UDim2.new(1, -30, 0, 40)
PasswordBox.Position = UDim2.new(0, 15, 0, 50)
PasswordBox.BackgroundColor3 = Theme.Background
PasswordBox.PlaceholderText = "Enter Password..."
PasswordBox.Text = ""
PasswordBox.TextColor3 = Theme.Text
PasswordBox.TextSize = 14
PasswordBox.Font = Enum.Font.GothamBold
PasswordBox.ClearTextOnFocus = true
Round(PasswordBox, 8)
PasswordBox.Parent = AdminPanel

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(1, -30, 0, 45)
SubmitBtn.Position = UDim2.new(0, 15, 0, 100)
SubmitBtn.BackgroundColor3 = Theme.Admin
SubmitBtn.Text = "UNLOCK"
SubmitBtn.TextColor3 = Color3.new(0, 0, 0)
SubmitBtn.TextSize = 16
SubmitBtn.Font = Enum.Font.GothamBlack
Round(SubmitBtn, 10)
SubmitBtn.Parent = AdminPanel

local CloseAdminBtn = Instance.new("TextButton")
CloseAdminBtn.Size = UDim2.new(0, 28, 0, 28)
CloseAdminBtn.Position = UDim2.new(1, -36, 0, 8)
CloseAdminBtn.BackgroundColor3 = Theme.Error
CloseAdminBtn.Text = "×"
CloseAdminBtn.TextColor3 = Color3.new(1, 1, 1)
CloseAdminBtn.TextSize = 18
CloseAdminBtn.Font = Enum.Font.GothamBold
Round(CloseAdminBtn, 6)
CloseAdminBtn.Parent = AdminPanel

AdminPanel.Parent = AdminGui

-- Admin Status (RGB)
local AdminStatusGui = Instance.new("BillboardGui")
AdminStatusGui.Name = "AdminStatus"
AdminStatusGui.AlwaysOnTop = true
AdminStatusGui.Size = UDim2.new(0, 200, 0, 60)
AdminStatusGui.StudsOffset = Vector3.new(0, 4, 0)
AdminStatusGui.Enabled = false

local StatusBg = Instance.new("Frame")
StatusBg.Size = UDim2.new(1, 0, 1, 0)
StatusBg.BackgroundColor3 = Color3.new(0, 0, 0)
StatusBg.BackgroundTransparency = 0.3
StatusBg.BorderSizePixel = 0
Round(StatusBg, 12)
StatusBg.Parent = AdminStatusGui

local AdminLabel = Instance.new("TextLabel")
AdminLabel.Size = UDim2.new(1, 0, 0.6, 0)
AdminLabel.BackgroundTransparency = 1
AdminLabel.Text = "👑 ADMIN/OWNER"
AdminLabel.TextColor3 = Theme.Admin
AdminLabel.TextSize = 18
AdminLabel.Font = Enum.Font.GothamBlack
AdminLabel.Parent = StatusBg

local DevLabel = Instance.new("TextLabel")
DevLabel.Size = UDim2.new(1, 0, 0.4, 0)
DevLabel.Position = UDim2.new(0, 0, 0.6, 0)
DevLabel.BackgroundTransparency = 1
DevLabel.Text = "Dev Script"
DevLabel.TextColor3 = Theme.TextMuted
DevLabel.TextSize = 12
DevLabel.Font = Enum.Font.Gotham
DevLabel.Parent = StatusBg

-- Smooth RGB
spawn(function()
    local hue = 0
    while true do
        if AdminStatusGui.Enabled then
            hue = (hue + 0.02) % 1
            AdminLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
        end
        wait(0.05)
    end
end)

AdminStatusGui.Parent = CoreGui

-- Admin ESP
States.AdminESPFolder = Instance.new("Folder")
States.AdminESPFolder.Name = "AdminESP"
States.AdminESPFolder.Parent = CoreGui

local function CreateAdminESP(player)
    if player == LocalPlayer then return end
    
    local esp = Instance.new("BillboardGui")
    esp.Name = player.Name .. "_AdminESP"
    esp.AlwaysOnTop = true
    esp.Size = UDim2.new(0, 180, 0, 80)
    esp.StudsOffset = Vector3.new(0, 3, 0)
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Theme.Admin
    bg.BackgroundTransparency = 0.2
    Round(bg, 10)
    bg.Parent = esp
    
    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1, 0, 0.25, 0)
    name.BackgroundTransparency = 1
    name.Text = player.Name
    name.TextColor3 = Color3.new(1, 1, 1)
    name.TextSize = 14
    name.Font = Enum.Font.GothamBold
    name.Parent = bg
    
    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new(0.9, 0, 0, 6)
    healthBar.Position = UDim2.new(0.05, 0, 0.3, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    healthBar.BorderSizePixel = 0
    Round(healthBar, 3)
    healthBar.Parent = bg
    
    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = Theme.Success
    healthFill.BorderSizePixel = 0
    Round(healthFill, 3)
    healthFill.Parent = healthBar
    
    local healthText = Instance.new("TextLabel")
    healthText.Size = UDim2.new(1, 0, 0.2, 0)
    healthText.Position = UDim2.new(0, 0, 0.4, 0)
    healthText.BackgroundTransparency = 1
    healthText.Text = "HP: 100/100"
    healthText.TextColor3 = Theme.Text
    healthText.TextSize = 11
    healthText.Font = Enum.Font.Gotham
    healthText.Parent = bg
    
    local dist = Instance.new("TextLabel")
    dist.Size = UDim2.new(1, 0, 0.18, 0)
    dist.Position = UDim2.new(0, 0, 0.62, 0)
    dist.BackgroundTransparency = 1
    dist.Text = "0m"
    dist.TextColor3 = Theme.TextMuted
    dist.TextSize = 10
    dist.Font = Enum.Font.Gotham
    dist.Parent = bg
    
    local team = Instance.new("TextLabel")
    team.Size = UDim2.new(1, 0, 0.18, 0)
    team.Position = UDim2.new(0, 0, 0.8, 0)
    team.BackgroundTransparency = 1
    team.Text = "Team: None"
    team.TextColor3 = Theme.TextMuted
    team.TextSize = 10
    team.Font = Enum.Font.Gotham
    team.Parent = bg
    
    esp.Parent = States.AdminESPFolder
    
    spawn(function()
        while esp.Parent and Config.IsAdmin do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local humanoid = player.Character.Humanoid
                local d = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                
                esp.Adornee = player.Character.HumanoidRootPart
                healthFill.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)
                healthText.Text = string.format("HP: %d/%d", math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
                dist.Text = string.format("%dm", math.floor(d))
                team.Text = "Team: " .. tostring(player.Team or "None")
                esp.Enabled = true
            else
                esp.Enabled = false
            end
            wait(0.2)
        end
        if esp.Parent then esp:Destroy() end
    end)
end

-- Admin Verify
SubmitBtn.MouseButton1Click:Connect(function()
    if PasswordBox.Text == "GEN1GO" then
        Config.IsAdmin = true
        AdminGui.Enabled = false
        AdminPanel.Visible = false
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
            AdminStatusGui.Adornee = LocalPlayer.Character.Head
            AdminStatusGui.Enabled = true
        end
        
        for _, p in pairs(Players:GetPlayers()) do
            CreateAdminESP(p)
        end
        
        Players.PlayerAdded:Connect(function(p)
            if Config.IsAdmin then
                wait(1)
                CreateAdminESP(p)
            end
        end)
        
        StarterGui:SetCore("SendNotification", {
            Title = "ADMIN MODE",
            Text = "Welcome Developer!",
            Duration = 5
        })
    else
        PasswordBox.Text = ""
        PasswordBox.PlaceholderText = "WRONG!"
        Tween(PasswordBox, {BackgroundColor3 = Theme.Error}, 0.2)
        wait(0.5)
        Tween(PasswordBox, {BackgroundColor3 = Theme.Background}, 0.2)
        PasswordBox.PlaceholderText = "Enter Password..."
    end
end)

CloseAdminBtn.MouseButton1Click:Connect(function()
    AdminGui.Enabled = false
    AdminPanel.Visible = false
end)

-- ========== FEATURES ==========

-- Movement
local MoveCard = CreateCard("🏃 MOVEMENT")
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

-- Fly
local FlyCard = CreateCard("✈️ FLY SYSTEM")
CreateButton(FlyCard, "Open Fly Panel", "primary", function()
    FlyGui.Enabled = true
    FlyPanel.Visible = true
end)

CreateToggle(FlyCard, "Infinite Jump", function(enabled)
    Config.InfiniteJump = enabled
    if enabled then
        States.JumpConnection = UserInputService.JumpRequest:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if States.JumpConnection then
            States.JumpConnection:Disconnect()
            States.JumpConnection = nil
        end
    end
end)

-- Zoom Unlock
CreateToggle(FlyCard, "Unlock Zoom (No Limit)", function(enabled)
    Config.ZoomUnlock = enabled
    if enabled then
        LocalPlayer.CameraMaxZoomDistance = 999999
        LocalPlayer.CameraMinZoomDistance = 0.1
    else
        LocalPlayer.CameraMaxZoomDistance = 128
        LocalPlayer.CameraMinZoomDistance = 0.5
    end
end)

-- ESP Players
local ESPCard = CreateCard("👁️ ESP PLAYERS")
States.ESPPlayerFolder = Instance.new("Folder")
States.ESPPlayerFolder.Name = "ESP_Players"
States.ESPPlayerFolder.Parent = CoreGui

CreateToggle(ESPCard, "Enable Player ESP", function(enabled)
    Config.ESPPlayers = enabled
    if enabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local esp = Instance.new("BillboardGui")
                esp.Name = p.Name .. "_ESP"
                esp.AlwaysOnTop = true
                esp.Size = UDim2.new(0, 140, 0, 50)
                esp.StudsOffset = Vector3.new(0, 2.5, 0)
                
                local bg = Instance.new("Frame")
                bg.Size = UDim2.new(1, 0, 1, 0)
                bg.BackgroundColor3 = Theme.Primary
                bg.BackgroundTransparency = 0.6
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
                dist.TextSize = 11
                dist.Font = Enum.Font.Gotham
                dist.Parent = bg
                
                esp.Parent = States.ESPPlayerFolder
                
                spawn(function()
                    while esp.Parent and Config.ESPPlayers do
                        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            esp.Adornee = p.Character.HumanoidRootPart
                            local d = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                            dist.Text = math.floor(d) .. "m"
                            esp.Enabled = true
                        else
                            esp.Enabled = false
                        end
                        wait(0.3)
                    end
                    if esp.Parent then esp:Destroy() end
                end)
            end
        end
    else
        States.ESPPlayerFolder:ClearAllChildren()
    end
end)

-- ESP Blocks
local BlockCard = CreateCard("🧱 ESP BLOCKS")
States.ESPBlockFolder = Instance.new("Folder")
States.ESPBlockFolder.Name = "ESP_Blocks"
States.ESPBlockFolder.Parent = CoreGui

local BlockKeywords = {"Block", "Mission", "Quest", "Item", "Coin", "Money", "Cash", "Gem", "Collect", "Chest", "Reward", "Target", "Objective", "Pickup", "Token", "Star"}

local function IsBlock(obj)
    local name = obj.Name:lower()
    for _, keyword in pairs(BlockKeywords) do
        if name:find(keyword:lower()) then return true end
    end
    return false
end

local function CreateBlockESP(obj)
    if States.ESPBlockFolder:FindFirstChild(obj.Name .. "_" .. obj:GetFullName():gsub("[^%w]", "_")) then return end
    
    local esp = Instance.new("BillboardGui")
    esp.Name = obj.Name .. "_" .. obj:GetFullName():gsub("[^%w]", "_")
    esp.AlwaysOnTop = true
    esp.Size = UDim2.new(0, 130, 0, 45)
    esp.StudsOffset = Vector3.new(0, 1.5, 0)
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Theme.Warning
    bg.BackgroundTransparency = 0.5
    Round(bg, 8)
    bg.Parent = esp
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 0.6, 0)
    txt.BackgroundTransparency = 1
    txt.Text = obj.Name
    txt.TextColor3 = Color3.new(1, 1, 1)
    txt.TextSize = 12
    txt.Font = Enum.Font.GothamBold
    txt.Parent = bg
    
    local dist = Instance.new("TextLabel")
    dist.Size = UDim2.new(1, 0, 0.4, 0)
    dist.Position = UDim2.new(0, 0, 0.6, 0)
    dist.BackgroundTransparency = 1
    dist.Text = "0m"
    dist.TextColor3 = Theme.TextMuted
    dist.TextSize = 10
    dist.Font = Enum.Font.Gotham
    dist.Parent = bg
    
    esp.Parent = States.ESPBlockFolder
    
    spawn(function()
        while esp.Parent and Config.ESPBlocks do
            if obj.Parent then
                if obj:IsA("BasePart") then
                    esp.Adornee = obj
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local d = (LocalPlayer.Character.HumanoidRootPart.Position - obj.Position).Magnitude
                        dist.Text = math.floor(d) .. "m"
                    end
                    esp.Enabled = true
                else
                    esp.Enabled = false
                end
            else
                esp:Destroy()
                break
            end
            wait(0.5)
        end
        if esp.Parent then esp:Destroy() end
    end)
end

CreateToggle(BlockCard, "ESP Blocks/Missions", function(enabled)
    Config.ESPBlocks = enabled
    if enabled then
        for _, obj in pairs(workspace:GetDescendants()) do
            if IsBlock(obj) then
                CreateBlockESP(obj)
            end
        end
        
        States.BlockESPConnection = workspace.DescendantAdded:Connect(function(obj)
            if Config.ESPBlocks and IsBlock(obj) then
                wait(0.5)
                CreateBlockESP(obj)
            end
        end)
        
        spawn(function()
            while Config.ESPBlocks do
                for _, obj in pairs(workspace:GetDescendants()) do
                    if IsBlock(obj) then
                        CreateBlockESP(obj)
                    end
                end
                wait(5)
            end
        end)
    else
        if States.BlockESPConnection then States.BlockESPConnection:Disconnect() end
        States.ESPBlockFolder:ClearAllChildren()
    end
end)

-- Teleport
local TPCard = CreateCard("🎯 TELEPORT")

local PlayerListTP = Instance.new("ScrollingFrame")
PlayerListTP.Size = UDim2.new(1, 0, 0, 100)
PlayerListTP.BackgroundColor3 = Theme.SurfaceLight
PlayerListTP.BackgroundTransparency = 0.3
PlayerListTP.BorderSizePixel = 0
PlayerListTP.ScrollBarThickness = 4
PlayerListTP.CanvasSize = UDim2.new(0, 0, 0, 0)
Round(PlayerListTP, 8)
PlayerListTP.Parent = TPCard

local ListLayoutTP = Instance.new("UIListLayout")
ListLayoutTP.Padding = UDim.new(0, 4)
ListLayoutTP.Parent = PlayerListTP

local SelectedTPPlayer = nil

local function UpdateTPList()
    for _, c in pairs(PlayerListTP:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -8, 0, 30)
            btn.Position = UDim2.new(0, 4, 0, 0)
            btn.BackgroundColor3 = SelectedTPPlayer == p and Theme.Primary or Theme.Surface
            btn.Text = p.Name
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.TextSize = 12
            btn.Font = Enum.Font.Gotham
            Round(btn, 6)
            btn.Parent = PlayerListTP
            
            btn.MouseButton1Click:Connect(function()
                SelectedTPPlayer = p
                UpdateTPList()
            end)
        end
    end
    
    PlayerListTP.CanvasSize = UDim2.new(0, 0, 0, (#Players:GetPlayers() - 1) * 34)
end

UpdateTPList()
Players.PlayerAdded:Connect(UpdateTPList)
Players.PlayerRemoving:Connect(UpdateTPList)

CreateButton(TPCard, "Teleport to Player", "primary", function()
    if SelectedTPPlayer and SelectedTPPlayer.Character and SelectedTPPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = SelectedTPPlayer.Character.HumanoidRootPart.CFrame
    end
end)

CreateToggle(TPCard, "Follow Player (Exact)", function(enabled)
    Config.AutoFollow = enabled
    if enabled then
        States.FollowingPlayer = SelectedTPPlayer
        spawn(function()
            while Config.AutoFollow and States.FollowingPlayer and States.FollowingPlayer.Character and States.FollowingPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") do
                LocalPlayer.Character.HumanoidRootPart.CFrame = States.FollowingPlayer.Character.HumanoidRootPart.CFrame
                wait(0.03)
            end
        end)
    else
        States.FollowingPlayer = nil
    end
end)

-- God Mode
local GodCard = CreateCard("🛡️ GOD MODE")

local GodTypeBtn = Instance.new("TextButton")
GodTypeBtn.Size = UDim2.new(1, 0, 0, 30)
GodTypeBtn.BackgroundColor3 = Theme.SurfaceLight
GodTypeBtn.Text = "Mode: Gen1 (Heal)"
GodTypeBtn.TextColor3 = Theme.Text
GodTypeBtn.TextSize = 12
GodTypeBtn.Font = Enum.Font.GothamBold
Round(GodTypeBtn, 6)
GodTypeBtn.Parent = GodCard

GodTypeBtn.MouseButton1Click:Connect(function()
    Config.GodModeType = Config.GodModeType == "Gen1" and "Gen2" or "Gen1"
    GodTypeBtn.Text = Config.GodModeType == "Gen1" and "Mode: Gen1 (Heal)" or "Mode: Gen2 (Immortal)"
end)

CreateToggle(GodCard, "God Mode", function(enabled)
    Config.GodMode = enabled
    if States.GodConnection then States.GodConnection:Disconnect() end
    
    if enabled then
        States.GodConnection = RunService.Heartbeat:Connect(function()
            if not LocalPlayer.Character then return end
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if not humanoid then return end
            
            if Config.GodModeType == "Gen1" then
                humanoid.Health = humanoid.MaxHealth
            else
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
            end
        end)
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.MaxHealth = 100
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
            wait(0.2)
        end
    end)
end)

CreateButton(GodCard, "Heal Now", "primary", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
    end
end)

-- Utility
local UtilCard = CreateCard("⚙️ UTILITY")

CreateToggle(UtilCard, "Full Bright", function(enabled)
    Config.FullBright = enabled
    if enabled then
        States.BrightnessConnection = RunService.RenderStepped:Connect(function()
            Lighting.Brightness = 10
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        end)
    else
        if States.BrightnessConnection then States.BrightnessConnection:Disconnect() end
        Lighting.Brightness = 2
        Lighting.GlobalShadows = true
    end
end)

CreateToggle(UtilCard, "Anti-AFK", function(enabled)
    Config.AntiAFK = enabled
    if enabled then
        local conn = LocalPlayer.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
            wait(1)
            VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
        end)
        table.insert(States.Connections, conn)
    end
end)

CreateSlider(UtilCard, "Visual Coin", 0, 10000, 0, function(val)
    Config.CoinVisual = val
    -- Auto-detect coin UI
    for _, obj in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            local name = obj.Name:lower()
            if name:find("coin") or name:find("money") or name:find("cash") or name:find("gem") or name:find("gold") then
                obj.Text = tostring(val)
            end
        end
    end
end)

CreateToggle(UtilCard, "FPS Boost", function(enabled)
    Config.FPSBoost = enabled
    if enabled then
        settings().Rendering.QualityLevel = 1
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
                v.Material = Enum.Material.SmoothPlastic
            end
            if v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            end
            if v:IsA("ParticleEmitter") then
                v.Enabled = false
            end
        end
        Lighting.GlobalShadows = false
    else
        settings().Rendering.QualityLevel = 10
        Lighting.GlobalShadows = true
    end
end)

-- Admin
local AdminCard = CreateCard("🔐 SPECIAL")
CreateButton(AdminCard, "Admin Access", "admin", function()
    AdminGui.Enabled = true
    AdminPanel.Visible = true
    PasswordBox.Text = ""
end)

-- Server
local ServerCard = CreateCard("🌐 SERVER")
CreateButton(ServerCard, "Rejoin Server", "primary", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

CreateButton(ServerCard, "Server Hop", "normal", function()
    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    for _, server in pairs(servers.data) do
        if server.playing < server.maxPlayers and server.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id)
            break
        end
    end
end)

-- ========== CONTROLS ==========

-- Drag Main
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
    Tween(MainFrame, {Size = UDim2.new(0, 320, 0, 0)}, 0.3)
    wait(0.3)
    MainFrame.Visible = false
    OrbButton.Visible = true
    Tween(OrbButton, {Size = UDim2.new(0, 50, 0, 50)}, 0.3)
end)

OrbButton.MouseButton1Click:Connect(function()
    OrbButton.Visible = false
    MainFrame.Visible = true
    Tween(MainFrame, {Size = UDim2.new(0, 320, 0, 400)}, 0.3)
end)

-- Close (FIXED - NO FREEZE)
CloseBtn.MouseButton1Click:Connect(function()
    -- Stop all connections first
    Config.Flying = false
    Config.Noclip = false
    Config.GodMode = false
    Config.ESPPlayers = false
    Config.ESPBlocks = false
    Config.AutoFollow = false
    
    Cleanup()
    
    -- Destroy GUI
    ScreenGui:Destroy()
    FlyGui:Destroy()
    AdminGui:Destroy()
end)

-- Intro
MainFrame.Size = UDim2.new(0, 0, 0, 0)
wait(0.2)
Tween(MainFrame, {Size = UDim2.new(0, 320, 0, 400)}, 0.5, Enum.EasingStyle.Back)

print("✅ AP-NEXTGEN v8.0 FINAL Loaded!")
print("Stable | All Features | Mobile Optimized")
