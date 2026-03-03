--[[
    AP-NEXTGEN HUB v7.0 ULTIMATE MASTERPIECE
    Landscape UI | Perfect Fly | All Features Working
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
local MarketPlaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Wait for character
repeat wait() until LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

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
    IsAdmin = false
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
    Connections = {}
}

-- Theme
local Theme = {
    Background = Color3.fromRGB(12, 12, 18),
    Surface = Color3.fromRGB(22, 22, 32),
    SurfaceLight = Color3.fromRGB(35, 35, 48),
    Primary = Color3.fromRGB(0, 212, 255),
    Secondary = Color3.fromRGB(157, 78, 221),
    Success = Color3.fromRGB(0, 255, 136),
    Warning = Color3.fromRGB(255, 200, 64),
    Error = Color3.fromRGB(255, 71, 87),
    Admin = Color3.fromRGB(255, 215, 0),
    Text = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(170, 170, 190)
}

-- Utility
local function Tween(obj, props, dur, style)
    TweenService:Create(obj, TweenInfo.new(dur or 0.3, style or Enum.EasingStyle.Quart), props):Play()
end

local function Round(parent, rad)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, rad or 12)
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
    if States.AFKConnection then States.AFKConnection:Disconnect() end
    if States.PlayerESPConnection then States.PlayerESPConnection:Disconnect() end
    if States.ItemESPConnection then States.ItemESPConnection:Disconnect() end
    if States.BlockESPConnection then States.BlockESPConnection:Disconnect() end
    if States.ESPPlayerFolder then States.ESPPlayerFolder:Destroy() end
    if States.ESPItemFolder then States.ESPItemFolder:Destroy() end
    if States.ESPBlockFolder then States.ESPBlockFolder:Destroy() end
    getgenv().APNEXTGEN_LOADED = nil
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "APNEXTGEN_ULTIMATE"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ========== SMOOTH OPENING ==========
local IntroGui = Instance.new("ScreenGui")
IntroGui.Name = "Intro"
IntroGui.Parent = CoreGui
IntroGui.DisplayOrder = 10000

local IntroFrame = Instance.new("Frame")
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
IntroFrame.BorderSizePixel = 0
IntroFrame.Parent = IntroGui

-- Modern gray gradient
local IntroGradient = Instance.new("UIGradient")
IntroGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 42)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 50, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 42))
})
IntroGradient.Rotation = 45
IntroGradient.Parent = IntroFrame

spawn(function()
    while IntroFrame.Parent do
        IntroGradient.Rotation = IntroGradient.Rotation + 0.2
        wait(0.05)
    end
end)

-- Floating particles
for i = 1, 20 do
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, math.random(2, 6), 0, math.random(2, 6))
    particle.Position = UDim2.new(math.random(), 0, 1.2, 0)
    particle.BackgroundColor3 = Theme.Primary
    particle.BackgroundTransparency = math.random(0.4, 0.8)
    particle.BorderSizePixel = 0
    Round(particle, 10)
    particle.Parent = IntroFrame
    
    spawn(function()
        while particle.Parent do
            local duration = math.random(5, 10)
            Tween(particle, {
                Position = UDim2.new(particle.Position.X.Scale + math.random(-0.1, 0.1), 0, -0.2, 0),
                BackgroundTransparency = 1
            }, duration)
            wait(duration)
            particle.Position = UDim2.new(math.random(), 0, 1.2, 0)
            particle.BackgroundTransparency = math.random(0.4, 0.8)
        end
    end)
end

-- Title Container
local TitleContainer = Instance.new("Frame")
TitleContainer.Size = UDim2.new(0, 800, 0, 250)
TitleContainer.Position = UDim2.new(0.5, -400, 0.35, -125)
TitleContainer.BackgroundTransparency = 1
TitleContainer.Parent = IntroFrame

local TextGlow = Instance.new("ImageLabel")
TextGlow.Size = UDim2.new(1.4, 0, 1.4, 0)
TextGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
TextGlow.AnchorPoint = Vector2.new(0.5, 0.5)
TextGlow.BackgroundTransparency = 1
TextGlow.Image = "rbxassetid://6015897843"
TextGlow.ImageColor3 = Theme.Primary
TextGlow.ImageTransparency = 0.85
TextGlow.ScaleType = Enum.ScaleType.Slice
TextGlow.SliceCenter = Rect.new(49, 49, 450, 450)
TextGlow.Parent = TitleContainer

local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(1, 0, 0.7, 0)
MainTitle.BackgroundTransparency = 1
MainTitle.Text = ""
MainTitle.TextColor3 = Theme.Primary
MainTitle.TextSize = 72
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
SubTitle.TextSize = 24
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextStrokeTransparency = 0.95
SubTitle.TextStrokeColor3 = Color3.new(0, 0, 0)
SubTitle.Parent = TitleContainer

-- Loading bar
local LoadBg = Instance.new("Frame")
LoadBg.Size = UDim2.new(0, 500, 0, 4)
LoadBg.Position = UDim2.new(0.5, -250, 0.65, 0)
LoadBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
LoadBg.BorderSizePixel = 0
Round(LoadBg, 2)
LoadBg.Parent = IntroFrame

local LoadBar = Instance.new("Frame")
LoadBar.Size = UDim2.new(0, 0, 1, 0)
LoadBar.BackgroundColor3 = Theme.Primary
LoadBar.BorderSizePixel = 0
Round(LoadBar, 2)
LoadBar.Parent = LoadBg

local LoadShine = Instance.new("Frame")
LoadShine.Size = UDim2.new(0.2, 0, 1, 0)
LoadShine.Position = UDim2.new(-0.2, 0, 0, 0)
LoadShine.BackgroundColor3 = Color3.new(1, 1, 1)
LoadShine.BackgroundTransparency = 0.9
LoadShine.BorderSizePixel = 0
LoadShine.Parent = LoadBar

spawn(function()
    while LoadShine.Parent do
        Tween(LoadShine, {Position = UDim2.new(1, 0, 0, 0)}, 1)
        wait(1)
        LoadShine.Position = UDim2.new(-0.2, 0, 0, 0)
    end
end)

-- Version
local VersionText = Instance.new("TextLabel")
VersionText.Size = UDim2.new(1, 0, 0, 20)
VersionText.Position = UDim2.new(0, 0, 0.9, 0)
VersionText.BackgroundTransparency = 1
VersionText.Text = "ULTIMATE EDITION v7.0 | by APTECH"
VersionText.TextColor3 = Color3.fromRGB(100, 100, 120)
VersionText.TextSize = 14
VersionText.Font = Enum.Font.Gotham
VersionText.Parent = IntroFrame

-- Typewriter
local function TypeWrite(label, text, speed)
    for i = 1, #text do
        label.Text = string.sub(text, 1, i)
        wait(speed or 0.05)
    end
end

spawn(function()
    wait(0.5)
    
    spawn(function()
        while TextGlow.Parent do
            Tween(TextGlow, {ImageTransparency = 0.8}, 1.5)
            wait(1.5)
            Tween(TextGlow, {ImageTransparency = 0.9}, 1.5)
            wait(1.5)
        end
    end)
    
    TypeWrite(MainTitle, "WELCOME TO AP-NEXTGEN1", 0.06)
    wait(0.4)
    
    SubTitle.TextTransparency = 1
    SubTitle.Text = "professional script by APTECH"
    
    for i = 1, 20 do
        SubTitle.TextTransparency = 1 - (i/20)
        wait(0.03)
    end
    
    Tween(LoadBar, {Size = UDim2.new(1, 0, 1, 0)}, 2.5, Enum.EasingStyle.Quart)
    wait(2.7)
    
    Tween(IntroFrame, {BackgroundTransparency = 1}, 0.8)
    Tween(MainTitle, {TextTransparency = 1, TextStrokeTransparency = 1}, 0.6)
    Tween(SubTitle, {TextTransparency = 1, TextStrokeTransparency = 1}, 0.6)
    Tween(LoadBg, {BackgroundTransparency = 1}, 0.5)
    Tween(LoadBar, {BackgroundTransparency = 1}, 0.5)
    Tween(TextGlow, {ImageTransparency = 1}, 0.5)
    
    wait(0.8)
    IntroGui:Destroy()
end)

wait(4)

-- ========== LANDSCAPE UI (PHONE OPTIMIZED) ==========
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 350)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -175)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Round(MainFrame, 20)
Shadow(MainFrame, 80)
MainFrame.Parent = ScreenGui

-- Left Panel (Profile & Info)
local LeftPanel = Instance.new("Frame")
LeftPanel.Size = UDim2.new(0, 180, 1, 0)
LeftPanel.BackgroundColor3 = Theme.Surface
LeftPanel.BorderSizePixel = 0
LeftPanel.Parent = MainFrame

local LeftGradient = Instance.new("UIGradient")
LeftGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.Surface),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 40))
})
LeftGradient.Rotation = 90
LeftGradient.Parent = LeftPanel

-- Profile Section
local ProfileFrame = Instance.new("Frame")
ProfileFrame.Size = UDim2.new(1, 0, 0, 140)
ProfileFrame.BackgroundTransparency = 1
ProfileFrame.Parent = LeftPanel

-- Avatar Image
local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(0, 80, 0, 80)
AvatarImage.Position = UDim2.new(0.5, -40, 0, 15)
AvatarImage.BackgroundColor3 = Theme.SurfaceLight
AvatarImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
Round(AvatarImage, 40)
AvatarImage.Parent = ProfileFrame

local AvatarStroke = Instance.new("UIStroke")
AvatarStroke.Color = Theme.Primary
AvatarStroke.Thickness = 3
AvatarStroke.Parent = AvatarImage

-- Username
local UsernameText = Instance.new("TextLabel")
UsernameText.Size = UDim2.new(1, -20, 0, 25)
UsernameText.Position = UDim2.new(0, 10, 0, 105)
UsernameText.BackgroundTransparency = 1
UsernameText.Text = LocalPlayer.Name
UsernameText.TextColor3 = Theme.Text
UsernameText.TextSize = 14
UsernameText.Font = Enum.Font.GothamBold
UsernameText.TextTruncate = Enum.TextTruncate.AtEnd
UsernameText.Parent = ProfileFrame

-- Display Name
local DisplayNameText = Instance.new("TextLabel")
DisplayNameText.Size = UDim2.new(1, -20, 0, 20)
DisplayNameText.Position = UDim2.new(0, 10, 0, 128)
DisplayNameText.BackgroundTransparency = 1
DisplayNameText.Text = "@" .. LocalPlayer.DisplayName
DisplayNameText.TextColor3 = Theme.TextMuted
DisplayNameText.TextSize = 11
DisplayNameText.Font = Enum.Font.Gotham
DisplayNameText.Parent = ProfileFrame

-- Game Info Section
local GameInfoFrame = Instance.new("Frame")
GameInfoFrame.Size = UDim2.new(1, -20, 0, 100)
GameInfoFrame.Position = UDim2.new(0, 10, 0, 155)
GameInfoFrame.BackgroundColor3 = Theme.Background
GameInfoFrame.BackgroundTransparency = 0.5
Round(GameInfoFrame, 12)
GameInfoFrame.Parent = LeftPanel

local GameTitle = Instance.new("TextLabel")
GameTitle.Size = UDim2.new(1, -10, 0, 20)
GameTitle.Position = UDim2.new(0, 5, 0, 8)
GameTitle.BackgroundTransparency = 1
GameTitle.Text = "🎮 GAME INFO"
GameTitle.TextColor3 = Theme.Primary
GameTitle.TextSize = 12
GameTitle.Font = Enum.Font.GothamBold
GameTitle.Parent = GameInfoFrame

local GameNameLabel = Instance.new("TextLabel")
GameNameLabel.Size = UDim2.new(1, -10, 0, 35)
GameNameLabel.Position = UDim2.new(0, 5, 0, 30)
GameNameLabel.BackgroundTransparency = 1
GameNameLabel.Text = game.Name
GameNameLabel.TextColor3 = Theme.Text
GameNameLabel.TextSize = 11
GameNameLabel.Font = Enum.Font.Gotham
GameNameLabel.TextWrapped = true
GameNameLabel.Parent = GameInfoFrame

local PlayerCountLabel = Instance.new("TextLabel")
PlayerCountLabel.Size = UDim2.new(1, -10, 0, 20)
PlayerCountLabel.Position = UDim2.new(0, 5, 0, 70)
PlayerCountLabel.BackgroundTransparency = 1
PlayerCountLabel.Text = "👥 Players: " .. #Players:GetPlayers()
PlayerCountLabel.TextColor3 = Theme.Success
PlayerCountLabel.TextSize = 12
PlayerCountLabel.Font = Enum.Font.GothamBold
PlayerCountLabel.Parent = GameInfoFrame

-- Update player count
spawn(function()
    while GameInfoFrame.Parent do
        PlayerCountLabel.Text = "👥 Players: " .. #Players:GetPlayers()
        wait(5)
    end
end)

-- APTech Credit
local CreditFrame = Instance.new("Frame")
CreditFrame.Size = UDim2.new(1, -20, 0, 40)
CreditFrame.Position = UDim2.new(0, 10, 1, -55)
CreditFrame.BackgroundColor3 = Theme.Primary
CreditFrame.BackgroundTransparency = 0.8
Round(CreditFrame, 8)
CreditFrame.Parent = LeftPanel

local CreditText = Instance.new("TextLabel")
CreditText.Size = UDim2.new(1, 0, 1, 0)
CreditText.BackgroundTransparency = 1
CreditText.Text = "🔥 Script by APTECH"
CreditText.TextColor3 = Color3.new(1, 1, 1)
CreditText.TextSize = 12
CreditText.Font = Enum.Font.GothamBold
CreditText.Parent = CreditFrame

-- Right Panel (Features)
local RightPanel = Instance.new("Frame")
RightPanel.Size = UDim2.new(1, -180, 1, 0)
RightPanel.Position = UDim2.new(0, 180, 0, 0)
RightPanel.BackgroundTransparency = 1
RightPanel.Parent = MainFrame

-- Top Bar Right
local TopBarRight = Instance.new("Frame")
TopBarRight.Size = UDim2.new(1, 0, 0, 45)
TopBarRight.BackgroundTransparency = 1
TopBarRight.Parent = RightPanel

local TitleRight = Instance.new("TextLabel")
TitleRight.Size = UDim2.new(0.6, 0, 1, 0)
TitleRight.Position = UDim2.new(0, 15, 0, 0)
TitleRight.BackgroundTransparency = 1
TitleRight.Text = "⚡ FEATURES"
TitleRight.TextColor3 = Theme.Text
TitleRight.TextSize = 18
TitleRight.Font = Enum.Font.GothamBlack
TitleRight.TextXAlignment = Enum.TextXAlignment.Left
TitleRight.Parent = TopBarRight

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 32, 0, 32)
MinBtn.Position = UDim2.new(1, -75, 0.5, -16)
MinBtn.BackgroundColor3 = Theme.SurfaceLight
MinBtn.Text = "−"
MinBtn.TextColor3 = Theme.TextMuted
MinBtn.TextSize = 24
MinBtn.Font = Enum.Font.GothamBold
Round(MinBtn, 8)
MinBtn.Parent = TopBarRight

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -16)
CloseBtn.BackgroundColor3 = Theme.Error
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 24
CloseBtn.Font = Enum.Font.GothamBold
Round(CloseBtn, 8)
CloseBtn.Parent = TopBarRight

-- Content Grid (2 columns for landscape)
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -20, 1, -55)
ContentFrame.Position = UDim2.new(0, 10, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 6
ContentFrame.ScrollBarImageColor3 = Theme.Primary
ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ContentFrame.Parent = RightPanel

local GridLayout = Instance.new("UIGridLayout")
GridLayout.CellSize = UDim2.new(0.5, -10, 0, 180)
GridLayout.CellPadding = UDim.new(0, 10)
GridLayout.FillDirection = Enum.FillDirection.Horizontal
GridLayout.Parent = ContentFrame

-- Update canvas size
GridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, GridLayout.AbsoluteContentSize.Y + 20)
end)

-- Component: Feature Card
local function CreateFeatureCard(title, icon)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 180)
    Card.BackgroundColor3 = Theme.Surface
    Card.BackgroundTransparency = 0.3
    Card.BorderSizePixel = 0
    Round(Card, 15)
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(50, 50, 65)
    Stroke.Thickness = 1.5
    Stroke.Parent = Card
    
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 35)
    Header.BackgroundTransparency = 1
    Header.Parent = Card
    
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Size = UDim2.new(0, 30, 0, 30)
    IconLabel.Position = UDim2.new(0, 10, 0, 2)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = icon or "⚡"
    IconLabel.TextSize = 20
    IconLabel.Parent = Header
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -45, 1, 0)
    TitleLabel.Position = UDim2.new(0, 40, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Theme.Primary
    TitleLabel.TextSize = 13
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header
    
    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(1, -20, 0, 1)
    Line.Position = UDim2.new(0, 10, 0, 33)
    Line.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    Line.BorderSizePixel = 0
    Line.Parent = Card
    
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -20, 1, -45)
    Container.Position = UDim2.new(0, 10, 0, 40)
    Container.BackgroundTransparency = 1
    Container.Parent = Card
    
    Card.Parent = ContentFrame
    return Container
end

local function CreateToggle(parent, text, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 32)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.TextSize = 11
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 44, 0, 24)
    Btn.Position = UDim2.new(1, -44, 0.5, -12)
    Btn.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
    Btn.Text = "OFF"
    Btn.TextColor3 = Theme.TextMuted
    Btn.TextSize = 10
    Btn.Font = Enum.Font.GothamBold
    Round(Btn, 12)
    Btn.Parent = Frame
    
    local enabled = false
    Btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        Btn.Text = enabled and "ON" or "OFF"
        Tween(Btn, {BackgroundColor3 = enabled and Theme.Success or Color3.fromRGB(55, 55, 70)}, 0.2)
        Tween(Btn, {TextColor3 = enabled and Color3.new(1,1,1) or Theme.TextMuted}, 0.2)
        if callback then callback(enabled) end
    end)
    
    return Frame
end

local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 45)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Frame.Size = UDim2.new(0.55, 0, 0, 18)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.TextSize = 11
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local ValueBox = Instance.new("TextBox")
    ValueBox.Size = UDim2.new(0, 45, 0, 20)
    ValueBox.Position = UDim2.new(1, -45, 0, 0)
    ValueBox.BackgroundColor3 = Theme.SurfaceLight
    ValueBox.Text = tostring(default)
    ValueBox.TextColor3 = Theme.Primary
    ValueBox.TextSize = 10
    ValueBox.Font = Enum.Font.GothamBold
    Round(ValueBox, 4)
    ValueBox.Parent = Frame
    
    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, 0, 0, 4)
    Track.Position = UDim2.new(0, 0, 0, 32)
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
    Knob.Size = UDim2.new(0, 12, 0, 12)
    Knob.Position = UDim2.new((default-min)/(max-min), -6, 0.5, -6)
    Knob.BackgroundColor3 = Color3.new(1, 1, 1)
    Round(Knob, 6)
    Knob.Parent = Track
    
    local dragging = false
    
    local function update(input)
        local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        ValueBox.Text = tostring(val)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Knob.Position = UDim2.new(pos, -6, 0.5, -6)
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
        Knob.Position = UDim2.new(pos, -6, 0.5, -6)
        if callback then callback(val) end
    end)
    
    return Frame
end

local function CreateButton(parent, text, style, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 32)
    Btn.BackgroundColor3 = style == "primary" and Theme.Primary or (style == "admin" and Theme.Admin or Theme.SurfaceLight)
    Btn.Text = text
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.TextSize = 11
    Btn.Font = Enum.Font.GothamBold
    Round(Btn, 6)
    Btn.Parent = parent
    
    Btn.MouseButton1Click:Connect(function()
        Tween(Btn, {Size = UDim2.new(0.96, 0, 0, 30)}, 0.1)
        wait(0.1)
        Tween(Btn, {Size = UDim2.new(1, 0, 0, 32)}, 0.1)
        if callback then callback() end
    end)
    
    return Btn
end

-- ========== DRAGGABLE ORB ==========
local OrbButton = Instance.new("TextButton")
OrbButton.Name = "Orb"
OrbButton.Size = UDim2.new(0, 55, 0, 55)
OrbButton.Position = UDim2.new(0, 15, 0.5, -27)
OrbButton.BackgroundColor3 = Theme.Surface
OrbButton.Text = "G1"
OrbButton.TextColor3 = Color3.new(1, 1, 1)
OrbButton.TextSize = 22
OrbButton.Font = Enum.Font.GothamBlack
OrbButton.Visible = false
OrbButton.ZIndex = 100
OrbButton.Active = true
OrbButton.Draggable = true
Round(OrbButton, 27)

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

Shadow(OrbButton, 25)
OrbButton.Parent = ScreenGui

-- ========== FLY PANEL (DRAGGABLE) ==========
local FlyGui = Instance.new("ScreenGui")
FlyGui.Name = "FlyPanel"
FlyGui.Parent = CoreGui
FlyGui.Enabled = false

local FlyPanel = Instance.new("Frame")
FlyPanel.Size = UDim2.new(0, 220, 0, 300)
FlyPanel.Position = UDim2.new(0.7, 0, 0.5, -150)
FlyPanel.BackgroundColor3 = Theme.Surface
FlyPanel.BackgroundTransparency = 0.1
FlyPanel.BorderSizePixel = 0
FlyPanel.Active = true
FlyPanel.Draggable = true
FlyPanel.Visible = false
Round(FlyPanel, 18)

local FlyStroke = Instance.new("UIStroke")
FlyStroke.Color = Theme.Primary
FlyStroke.Thickness = 2
FlyStroke.Parent = FlyPanel

Shadow(FlyPanel, 35)

-- Fly Title
local FlyTitle = Instance.new("TextLabel")
FlyTitle.Size = UDim2.new(1, 0, 0, 40)
FlyTitle.BackgroundTransparency = 1
FlyTitle.Text = "✈️ FLY CONTROL"
FlyTitle.TextColor3 = Theme.Primary
FlyTitle.TextSize = 16
FlyTitle.Font = Enum.Font.GothamBlack
FlyTitle.Parent = FlyPanel

local CloseFlyBtn = Instance.new("TextButton")
CloseFlyBtn.Size = UDim2.new(0, 28, 0, 28)
CloseFlyBtn.Position = UDim2.new(1, -35, 0, 8)
CloseFlyBtn.BackgroundColor3 = Theme.Error
CloseFlyBtn.Text = "×"
CloseFlyBtn.TextColor3 = Color3.new(1, 1, 1)
CloseFlyBtn.TextSize = 18
CloseFlyBtn.Font = Enum.Font.GothamBold
Round(CloseFlyBtn, 6)
CloseFlyBtn.Parent = FlyPanel

-- Speed Control
local FlySpeedLabel = Instance.new("TextLabel")
FlySpeedLabel.Size = UDim2.new(1, -20, 0, 20)
FlySpeedLabel.Position = UDim2.new(0, 10, 0, 45)
FlySpeedLabel.BackgroundTransparency = 1
FlySpeedLabel.Text = "Speed: 100"
FlySpeedLabel.TextColor3 = Theme.Text
FlySpeedLabel.TextSize = 12
FlySpeedLabel.Font = Enum.Font.GothamBold
FlySpeedLabel.Parent = FlyPanel

local FlySpeedTrack = Instance.new("Frame")
FlySpeedTrack.Size = UDim2.new(1, -20, 0, 6)
FlySpeedTrack.Position = UDim2.new(0, 10, 0, 68)
FlySpeedTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
FlySpeedTrack.BorderSizePixel = 0
Round(FlySpeedTrack, 3)
FlySpeedTrack.Parent = FlyPanel

local FlySpeedFill = Instance.new("Frame")
FlySpeedFill.Size = UDim2.new(0.35, 0, 1, 0)
FlySpeedFill.BackgroundColor3 = Theme.Primary
FlySpeedFill.BorderSizePixel = 0
Round(FlySpeedFill, 3)
FlySpeedFill.Parent = FlySpeedTrack

local FlySpeedKnob = Instance.new("Frame")
FlySpeedKnob.Size = UDim2.new(0, 16, 0, 16)
FlySpeedKnob.Position = UDim2.new(0.35, -8, 0.5, -8)
FlySpeedKnob.BackgroundColor3 = Color3.new(1, 1, 1)
Round(FlySpeedKnob, 8)
FlySpeedKnob.Parent = FlySpeedTrack

-- Fly Speed Logic
local flySpeedDragging = false
FlySpeedTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        flySpeedDragging = true
        local pos = math.clamp((input.Position.X - FlySpeedTrack.AbsolutePosition.X) / FlySpeedTrack.AbsoluteSize.X, 0, 1)
        local val = math.floor(10 + 490 * pos)
        Config.FlySpeed = val
        FlySpeedLabel.Text = "Speed: " .. val
        FlySpeedFill.Size = UDim2.new(pos, 0, 1, 0)
        FlySpeedKnob.Position = UDim2.new(pos, -8, 0.5, -8)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if flySpeedDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local pos = math.clamp((input.Position.X - FlySpeedTrack.AbsolutePosition.X) / FlySpeedTrack.AbsoluteSize.X, 0, 1)
        local val = math.floor(10 + 490 * pos)
        Config.FlySpeed = val
        FlySpeedLabel.Text = "Speed: " .. val
        FlySpeedFill.Size = UDim2.new(pos, 0, 1, 0)
        FlySpeedKnob.Position = UDim2.new(pos, -8, 0.5, -8)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    flySpeedDragging = false
end)

-- Fly Toggle
local FlyToggleBtn = Instance.new("TextButton")
FlyToggleBtn.Size = UDim2.new(1, -20, 0, 45)
FlyToggleBtn.Position = UDim2.new(0, 10, 0, 85)
FlyToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
FlyToggleBtn.Text = "FLY: OFF"
FlyToggleBtn.TextColor3 = Theme.TextMuted
FlyToggleBtn.TextSize = 14
FlyToggleBtn.Font = Enum.Font.GothamBold
Round(FlyToggleBtn, 10)
FlyToggleBtn.Parent = FlyPanel

-- Noclip Toggle
local NoclipToggleBtn = Instance.new("TextButton")
NoclipToggleBtn.Size = UDim2.new(1, -20, 0, 45)
NoclipToggleBtn.Position = UDim2.new(0, 10, 0, 140)
NoclipToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
NoclipToggleBtn.Text = "NOCLIP: OFF"
NoclipToggleBtn.TextColor3 = Theme.TextMuted
NoclipToggleBtn.TextSize = 14
NoclipToggleBtn.Font = Enum.Font.GothamBold
Round(NoclipToggleBtn, 10)
NoclipToggleBtn.Parent = FlyPanel

-- Instructions
local FlyInstr = Instance.new("TextLabel")
FlyInstr.Size = UDim2.new(1, -20, 0, 100)
FlyInstr.Position = UDim2.new(0, 10, 0, 195)
FlyInstr.BackgroundTransparency = 1
FlyInstr.Text = "Controls:\n• Joystick = Move (follows camera)\n• Space = Up\n• Shift = Down\n• Camera lock for direction"
FlyInstr.TextColor3 = Theme.TextMuted
FlyInstr.TextSize = 11
FlyInstr.Font = Enum.Font.Gotham
FlyInstr.TextYAlignment = Enum.TextYAlignment.Top
FlyInstr.Parent = FlyPanel

FlyPanel.Parent = FlyGui

-- ========== PERFECT FLY SYSTEM (CAMERA LOCKED) ==========
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
                -- Get camera CFrame for direction
                local camCF = Camera.CFrame
                local moveDir = humanoid.MoveDirection
                
                if moveDir.Magnitude > 0 then
                    -- Calculate forward direction based on camera look
                    local camLook = camCF.LookVector
                    local camRight = camCF.RightVector
                    
                    -- Flatten Y for horizontal movement
                    camLook = Vector3.new(camLook.X, 0, camLook.Z).Unit
                    camRight = Vector3.new(camRight.X, 0, camRight.Z).Unit
                    
                    -- Combine directions: Forward/Back uses camera look, Left/Right uses camera right
                    local forwardBack = moveDir.Z -- W/S
                    local leftRight = moveDir.X -- A/D
                    
                    local velocity = (camLook * forwardBack + camRight * leftRight) * Config.FlySpeed
                    
                    -- Apply horizontal movement
                    hrp.Velocity = Vector3.new(velocity.X, hrp.Velocity.Y, velocity.Z)
                    
                    -- Rotate character to face camera direction when moving
                    if forwardBack ~= 0 or leftRight ~= 0 then
                        local lookPos = hrp.Position + camLook
                        hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(lookPos.X, hrp.Position.Y, lookPos.Z))
                    end
                else
                    -- Stop horizontal movement when no input
                    hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0)
                end
                
                -- Vertical movement
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, Config.FlySpeed, hrp.Velocity.Z)
                elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, -Config.FlySpeed, hrp.Velocity.Z)
                else
                    -- Maintain altitude
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
AdminPanel.Size = UDim2.new(0, 320, 0, 220)
AdminPanel.Position = UDim2.new(0.5, -160, 0.5, -110)
AdminPanel.BackgroundColor3 = Theme.Surface
AdminPanel.BorderSizePixel = 0
AdminPanel.Visible = false
Round(AdminPanel, 20)

local AdminStroke = Instance.new("UIStroke")
AdminStroke.Color = Theme.Admin
AdminStroke.Thickness = 3
AdminStroke.Parent = AdminPanel

Shadow(AdminPanel, 50)

local AdminTitle = Instance.new("TextLabel")
AdminTitle.Size = UDim2.new(1, 0, 0, 50)
AdminTitle.BackgroundTransparency = 1
AdminTitle.Text = "🔐 ADMIN ACCESS"
AdminTitle.TextColor3 = Theme.Admin
AdminTitle.TextSize = 22
AdminTitle.Font = Enum.Font.GothamBlack
AdminTitle.Parent = AdminPanel

local PasswordBox = Instance.new("TextBox")
PasswordBox.Size = UDim2.new(1, -40, 0, 45)
PasswordBox.Position = UDim2.new(0, 20, 0, 65)
PasswordBox.BackgroundColor3 = Theme.Background
PasswordBox.PlaceholderText = "Enter Password..."
PasswordBox.Text = ""
PasswordBox.TextColor3 = Theme.Text
PasswordBox.TextSize = 16
PasswordBox.Font = Enum.Font.GothamBold
PasswordBox.ClearTextOnFocus = true
Round(PasswordBox, 10)
PasswordBox.Parent = AdminPanel

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(1, -40, 0, 50)
SubmitBtn.Position = UDim2.new(0, 20, 0, 125)
SubmitBtn.BackgroundColor3 = Theme.Admin
SubmitBtn.Text = "UNLOCK"
SubmitBtn.TextColor3 = Color3.new(0, 0, 0)
SubmitBtn.TextSize = 18
SubmitBtn.Font = Enum.Font.GothamBlack
Round(SubmitBtn, 12)
SubmitBtn.Parent = AdminPanel

local CloseAdminBtn = Instance.new("TextButton")
CloseAdminBtn.Size = UDim2.new(0, 32, 0, 32)
CloseAdminBtn.Position = UDim2.new(1, -42, 0, 10)
CloseAdminBtn.BackgroundColor3 = Theme.Error
CloseAdminBtn.Text = "×"
CloseAdminBtn.TextColor3 = Color3.new(1, 1, 1)
CloseAdminBtn.TextSize = 20
CloseAdminBtn.Font = Enum.Font.GothamBold
Round(CloseAdminBtn, 8)
CloseAdminBtn.Parent = AdminPanel

AdminPanel.Parent = AdminGui

-- Admin Status (Above Avatar) with RGB Animation
local AdminStatusGui = Instance.new("BillboardGui")
AdminStatusGui.Name = "AdminStatus"
AdminStatusGui.AlwaysOnTop = true
AdminStatusGui.Size = UDim2.new(0, 220, 0, 70)
AdminStatusGui.StudsOffset = Vector3.new(0, 4.5, 0)
AdminStatusGui.Enabled = false

local StatusBg = Instance.new("Frame")
StatusBg.Size = UDim2.new(1, 0, 1, 0)
StatusBg.BackgroundColor3 = Color3.new(0, 0, 0)
StatusBg.BackgroundTransparency = 0.2
StatusBg.BorderSizePixel = 0
Round(StatusBg, 15)
StatusBg.Parent = AdminStatusGui

local AdminLabel = Instance.new("TextLabel")
AdminLabel.Size = UDim2.new(1, 0, 0.55, 0)
AdminLabel.BackgroundTransparency = 1
AdminLabel.Text = "👑 ADMIN/OWNER"
AdminLabel.TextColor3 = Theme.Admin
AdminLabel.TextSize = 20
AdminLabel.Font = Enum.Font.GothamBlack
AdminLabel.Parent = StatusBg

local DevLabel = Instance.new("TextLabel")
DevLabel.Size = UDim2.new(1, 0, 0.45, 0)
DevLabel.Position = UDim2.new(0, 0, 0.55, 0)
DevLabel.BackgroundTransparency = 1
DevLabel.Text = "Dev Script"
DevLabel.TextColor3 = Theme.TextMuted
DevLabel.TextSize = 14
DevLabel.Font = Enum.Font.Gotham
DevLabel.Parent = StatusBg

-- Smooth RGB Animation
spawn(function()
    local hue = 0
    while AdminStatusGui.Enabled do
        hue = hue + 0.01
        if hue > 1 then hue = 0 end
        AdminLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
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
    esp.Size = UDim2.new(0, 200, 0, 90)
    esp.StudsOffset = Vector3.new(0, 3.5, 0)
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Theme.Admin
    bg.BackgroundTransparency = 0.2
    Round(bg, 12)
    bg.Parent = esp
    
    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1, 0, 0.25, 0)
    name.BackgroundTransparency = 1
    name.Text = player.Name
    name.TextColor3 = Color3.new(1, 1, 1)
    name.TextSize = 14
    name.Font = Enum.Font.GothamBold
    name.Parent = bg
    
    -- Health Bar
    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new(0.9, 0, 0, 8)
    healthBar.Position = UDim2.new(0.05, 0, 0.3, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    healthBar.BorderSizePixel = 0
    Round(healthBar, 4)
    healthBar.Parent = bg
    
    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = Theme.Success
    healthFill.BorderSizePixel = 0
    Round(healthFill, 4)
    healthFill.Parent = healthBar
    
    local healthText = Instance.new("TextLabel")
    healthText.Size = UDim2.new(1, 0, 0.2, 0)
    healthText.Position = UDim2.new(0, 0, 0.42, 0)
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

-- Admin Verification
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
            Title = "ADMIN MODE ACTIVATED",
            Text = "Welcome Developer! All admin features unlocked.",
            Duration = 5
        })
    else
        PasswordBox.Text = ""
        PasswordBox.PlaceholderText = "❌ WRONG PASSWORD!"
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

-- Movement Card
local MoveCard = CreateFeatureCard("MOVEMENT", "🏃")
CreateSlider(MoveCard, "Speed", 16, 500, 50, function(val)
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

-- Fly Card
local FlyCard = CreateFeatureCard("FLY SYSTEM", "✈️")
CreateButton(FlyCard, "Open Fly Panel", "primary", function()
    FlyGui.Enabled = true
    FlyPanel.Visible = true
    Tween(FlyPanel, {Size = UDim2.new(0, 220, 0, 300)}, 0.3)
end)

-- Infinite Jump (FIXED)
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

-- ESP Cards
local ESPCard = CreateFeatureCard("ESP PLAYERS", "👁️")
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

-- Block/Mission ESP
local BlockCard = CreateFeatureCard("ESP BLOCKS", "🧱")
States.ESPBlockFolder = Instance.new("Folder")
States.ESPBlockFolder.Name = "ESP_Blocks"
States.ESPBlockFolder.Parent = CoreGui

local BlockKeywords = {"Block", "Mission", "Quest", "Item", "Coin", "Money", "Cash", "Gem", "Collect", "Chest", "Reward", "Target", "Objective", "Pickup", "Token", "Star"}

local function IsBlock(obj)
    local name = obj.Name:lower()
    for _, keyword in pairs(BlockKeywords) do
        if name:find(keyword:lower()) then return true end
    end
    return obj:IsA("BasePart") and (obj.Name:len() < 20 or name:find("coin") or name:find("gem"))
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
                elseif obj:FindFirstChildWhichIsA("BasePart") then
                    esp.Adornee = obj:FindFirstChildWhichIsA("BasePart")
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
        -- Deep scan
        for _, obj in pairs(workspace:GetDescendants()) do
            if IsBlock(obj) then
                CreateBlockESP(obj)
            end
        end
        
        -- Auto detect new
        States.BlockESPConnection = workspace.DescendantAdded:Connect(function(obj)
            if Config.ESPBlocks and IsBlock(obj) then
                wait(0.5)
                CreateBlockESP(obj)
            end
        end)
        
        -- Periodic rescan
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

-- Teleport Card
local TPCard = CreateFeatureCard("TELEPORT", "🎯")

local PlayerListTP = Instance.new("ScrollingFrame")
PlayerListTP.Size = UDim2.new(1, 0, 0, 80)
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
            btn.Size = UDim2.new(1, -8, 0, 28)
            btn.Position = UDim2.new(0, 4, 0, 0)
            btn.BackgroundColor3 = SelectedTPPlayer == p and Theme.Primary or Theme.Surface
            btn.Text = p.Name
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.TextSize = 11
            btn.Font = Enum.Font.Gotham
            Round(btn, 6)
            btn.Parent = PlayerListTP
            
            btn.MouseButton1Click:Connect(function()
                SelectedTPPlayer = p
                UpdateTPList()
            end)
        end
    end
    
    PlayerListTP.CanvasSize = UDim2.new(0, 0, 0, (#Players:GetPlayers() - 1) * 32)
end

UpdateTPList()
Players.PlayerAdded:Connect(UpdateTPList)
Players.PlayerRemoving:Connect(UpdateTPList)

CreateButton(TPCard, "Teleport", "primary", function()
    if SelectedTPPlayer and SelectedTPPlayer.Character and SelectedTPPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = SelectedTPPlayer.Character.HumanoidRootPart.CFrame
    end
end)

CreateToggle(TPCard, "Follow (Exact)", function(enabled)
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

-- God Mode Card
local GodCard = CreateFeatureCard("GOD MODE", "🛡️")

local GodTypeBtn = Instance.new("TextButton")
GodTypeBtn.Size = UDim2.new(1, 0, 0, 28)
GodTypeBtn.BackgroundColor3 = Theme.SurfaceLight
GodTypeBtn.Text = "Mode: Gen1 (Heal)"
GodTypeBtn.TextColor3 = Theme.Text
GodTypeBtn.TextSize = 11
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

-- Utility Card
local UtilCard = CreateFeatureCard("UTILITY", "⚙️")

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

-- Anti-AFK (FIXED)
CreateToggle(UtilCard, "Anti-AFK", function(enabled)
    Config.AntiAFK = enabled
    if enabled then
        -- Method 1: VirtualUser
        local vuConn = LocalPlayer.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            wait(1)
            VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)
        table.insert(States.Connections, vuConn)
        
        -- Method 2: Camera jitter
        States.AFKConnection = spawn(function()
            while Config.AntiAFK do
                local cam = workspace.CurrentCamera
                local original = cam.CFrame
                cam.CFrame = original * CFrame.new(0, 0.01, 0)
                wait(0.1)
                cam.CFrame = original
                wait(29)
            end
        end)
    else
        if States.AFKConnection then
            -- Cannot stop spawn, but flag will prevent new actions
        end
    end
end)

-- FPS Boost (FIXED)
CreateToggle(UtilCard, "FPS Boost", function(enabled)
    Config.FPSBoost = enabled
    if enabled then
        -- Reduce quality
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        
        -- Optimize workspace
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
                v.Material = Enum.Material.SmoothPlastic
            end
            if v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            end
            if v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            end
        end
        
        -- Disable shadows
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 100000
        
        -- Optimize lighting
        for _, v in pairs(Lighting:GetDescendants()) do
            if v:IsA("PostEffect") then
                v.Enabled = false
            end
        end
    else
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level10
        Lighting.GlobalShadows = true
    end
end)

-- Coin Visual (Auto-Detect System)
CreateSlider(UtilCard, "Visual Coin", 0, 10000, 0, function(val)
    Config.CoinVisual = val
    -- Auto-detect coin system in game
    for _, obj in pairs(workspace:GetDescendants()) do
        local name = obj.Name:lower()
        if name:find("coin") or name:find("money") or name:find("cash") or name:find("gem") then
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                obj.Text = tostring(val)
            elseif obj:FindFirstChildWhichIsA("TextLabel") then
                obj:FindFirstChildWhichIsA("TextLabel").Text = tostring(val)
            end
        end
    end
end)

-- Admin Card
local AdminCard = CreateFeatureCard("🔐 SPECIAL", "⭐")
CreateButton(AdminCard, "Admin Access", "admin", function()
    AdminGui.Enabled = true
    AdminPanel.Visible = true
    PasswordBox.Text = ""
end)

-- Admin Kill Player Feature
if Config.IsAdmin then
    local KillCard = CreateFeatureCard("ADMIN: KILL", "💀")
    
    local KillList = Instance.new("ScrollingFrame")
    KillList.Size = UDim2.new(1, 0, 0, 80)
    KillList.BackgroundColor3 = Theme.Error
    KillList.BackgroundTransparency = 0.8
    KillList.BorderSizePixel = 0
    KillList.ScrollBarThickness = 4
    Round(KillList, 8)
    KillList.Parent = KillCard
    
    local KillLayout = Instance.new("UIListLayout")
    KillLayout.Padding = UDim.new(0, 4)
    KillLayout.Parent = KillList
    
    local function UpdateKillList()
        for _, c in pairs(KillList:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -8, 0, 28)
                btn.BackgroundColor3 = Theme.Error
                btn.Text = "💀 " .. p.Name
                btn.TextColor3 = Color3.new(1, 1, 1)
                btn.TextSize = 11
                btn.Font = Enum.Font.GothamBold
                Round(btn, 6)
                btn.Parent = KillList
                
                btn.MouseButton1Click:Connect(function()
                    if p.Character and p.Character:FindFirstChild("Humanoid") then
                        p.Character.Humanoid.Health = 0
                    end
                end)
            end
        end
        
        KillList.CanvasSize = UDim2.new(0, 0, 0, (#Players:GetPlayers() - 1) * 32)
    end
    
    UpdateKillList()
    Players.PlayerAdded:Connect(UpdateKillList)
    Players.PlayerRemoving:Connect(UpdateKillList)
end

-- Server Card
local ServerCard = CreateFeatureCard("SERVER", "🌐")
CreateButton(ServerCard, "Rejoin", "primary", function()
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

TopBarRight.InputBegan:Connect(function(input)
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
    Tween(MainFrame, {Size = UDim2.new(0, 600, 0, 0)}, 0.3)
    wait(0.3)
    MainFrame.Visible = false
    OrbButton.Visible = true
    Tween(OrbButton, {Size = UDim2.new(0, 55, 0, 55)}, 0.3)
end)

OrbButton.MouseButton1Click:Connect(function()
    OrbButton.Visible = false
    MainFrame.Visible = true
    Tween(MainFrame, {Size = UDim2.new(0, 600, 0, 350)}, 0.3)
end)

-- Close
CloseBtn.MouseButton1Click:Connect(function()
    Cleanup()
    Tween(MainFrame, {Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, 1.5, 0)}, 0.4)
    wait(0.4)
    ScreenGui:Destroy()
    FlyGui:Destroy()
    AdminGui:Destroy()
end)

-- Intro Animation
MainFrame.Size = UDim2.new(0, 0, 0, 0)
wait(0.2)
Tween(MainFrame, {Size = UDim2.new(0, 600, 0, 350)}, 0.6, Enum.EasingStyle.Back)

print("✅ AP-NEXTGEN v7.0 ULTIMATE MASTERPIECE Loaded!")
print("Landscape UI | Perfect Fly | All Features Working")
