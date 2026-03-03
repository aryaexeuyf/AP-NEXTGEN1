--[[
AP-NEXTGEN HUB v9.0 ENHANCED
Perfect UI | All Features Working | Mobile Optimized | New Features Added
Created by: APTECH
Enhanced by: User Requirements
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
    ESPAdminV2 = false,
    ESPItems = false,
    ESPBlocks = false,
    AutoFollow = false,
    AutoHeal = false,
    FullBright = false,
    AntiAFK = false,
    FPSBoost = false,
    InfiniteJump = false,
    JumpPower = 50,
    MoonGravity = false,
    CoinVisual = 0,
    IsAdmin = false,
    ZoomUnlock = false,
    CopyAvatarTarget = nil
}

-- State
local States = {
    FollowingPlayer = nil,
    ESPPlayerFolder = nil,
    ESPItemFolder = nil,
    ESPBlockFolder = nil,
    AdminESPFolder = nil,
    AdminESPV2Folder = nil,
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
    GravityConnection = nil,
    Connections = {}
}

-- Preset Storage
local Presets = {}

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
    if States.GravityConnection then States.GravityConnection:Disconnect() end
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
ScreenGui.Name = "APNEXTGEN_FINAL_V9"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ========== OPENING ==========
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

local TitleFrame = Instance.new("Frame")
TitleFrame.Size = UDim2.new(0.9, 0, 0, 150)
TitleFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
TitleFrame.BackgroundTransparency = 1
TitleFrame.Parent = IntroFrame
local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(1, 0, 0.6, 0)
MainTitle.BackgroundTransparency = 1
MainTitle.Text = "AP-NEXTGEN V9"
MainTitle.TextColor3 = Theme.Primary
MainTitle.TextSize = 40
MainTitle.Font = Enum.Font.GothamBlack
MainTitle.TextScaled = true
MainTitle.Parent = TitleFrame
local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, 0, 0.3, 0)
SubTitle.Position = UDim2.new(0, 0, 0.65, 0)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "by APTECH | Enhanced"
SubTitle.TextColor3 = Theme.TextMuted
SubTitle.TextSize = 20
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextScaled = true
SubTitle.Parent = TitleFrame

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

spawn(function()
    wait(0.5)
    Tween(LoadBar, {Size = UDim2.new(1, 0, 1, 0)}, 2)
    wait(2.2)
    Tween(IntroFrame, {BackgroundTransparency = 1}, 0.5)
    Tween(MainTitle, {TextTransparency = 1}, 0.4)
    Tween(SubTitle, {TextTransparency = 1}, 0.4)
    wait(0.5)
    IntroGui:Destroy()
end)
wait(3)

-- ========== MAIN UI ==========
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 450)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -225)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Round(MainFrame, 15)
MainFrame.Parent = ScreenGui

-- Top Bar with Profile & Info Monitor
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 70)
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

-- Profile Section
local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 45, 0, 45)
AvatarImg.Position = UDim2.new(0, 10, 0, 10)
AvatarImg.BackgroundColor3 = Theme.SurfaceLight
AvatarImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
Round(AvatarImg, 22)
AvatarImg.Parent = TopBar

local NameText = Instance.new("TextLabel")
NameText.Size = UDim2.new(0, 180, 0, 22)
NameText.Position = UDim2.new(0, 62, 0, 8)
NameText.BackgroundTransparency = 1
NameText.Text = LocalPlayer.Name
NameText.TextColor3 = Theme.Text
NameText.TextSize = 15
NameText.Font = Enum.Font.GothamBold
NameText.TextXAlignment = Enum.TextXAlignment.Left
NameText.TextTruncate = Enum.TextTruncate.AtEnd
NameText.Parent = TopBar

local UIDText = Instance.new("TextLabel")
UIDText.Size = UDim2.new(0, 180, 0, 16)
UIDText.Position = UDim2.new(0, 62, 0, 28)
UIDText.BackgroundTransparency = 1
UIDText.Text = "UID: " .. LocalPlayer.UserId
UIDText.TextColor3 = Theme.TextMuted
UIDText.TextSize = 11
UIDText.Font = Enum.Font.Gotham
UIDText.TextXAlignment = Enum.TextXAlignment.Left
UIDText.Parent = TopBar

-- Info Monitor Section
local InfoFrame = Instance.new("Frame")
InfoFrame.Size = UDim2.new(0, 150, 0, 50)
InfoFrame.Position = UDim2.new(1, -160, 0, 10)
InfoFrame.BackgroundColor3 = Theme.SurfaceLight
InfoFrame.BackgroundTransparency = 0.5
Round(InfoFrame, 8)
InfoFrame.Parent = TopBar

local GameInfoText = Instance.new("TextLabel")
GameInfoText.Size = UDim2.new(1, -10, 0, 14)
GameInfoText.Position = UDim2.new(0, 5, 0, 2)
GameInfoText.BackgroundTransparency = 1
GameInfoText.Text = "🎮 " .. game.Name
GameInfoText.TextColor3 = Theme.Primary
GameInfoText.TextSize = 10
GameInfoText.Font = Enum.Font.GothamBold
GameInfoText.TextXAlignment = Enum.TextXAlignment.Left
GameInfoText.TextTruncate = Enum.TextTruncate.AtEnd
GameInfoText.Parent = InfoFrame

local ServerInfoText = Instance.new("TextLabel")
ServerInfoText.Size = UDim2.new(1, -10, 0, 14)
ServerInfoText.Position = UDim2.new(0, 5, 0, 16)
ServerInfoText.BackgroundTransparency = 1
ServerInfoText.Text = "🌐 Global Server"
ServerInfoText.TextColor3 = Theme.TextMuted
ServerInfoText.TextSize = 9
ServerInfoText.Font = Enum.Font.Gotham
ServerInfoText.TextXAlignment = Enum.TextXAlignment.Left
ServerInfoText.Parent = InfoFrame

local PlayerCountText = Instance.new("TextLabel")
PlayerCountText.Size = UDim2.new(1, -10, 0, 14)
PlayerCountText.Position = UDim2.new(0, 5, 0, 30)
PlayerCountText.BackgroundTransparency = 1
PlayerCountText.Text = "👥 0/0"
PlayerCountText.TextColor3 = Theme.Success
PlayerCountText.TextSize = 9
PlayerCountText.Font = Enum.Font.Gotham
PlayerCountText.TextXAlignment = Enum.TextXAlignment.Left
PlayerCountText.Parent = InfoFrame

-- Update info real-time
spawn(function()
    while PlayerCountText.Parent do
        local maxPlayers = Players.MaxPlayers
        local currentPlayers = #Players:GetPlayers()
        PlayerCountText.Text = string.format("👥 %d/%d", currentPlayers, maxPlayers)
        GameInfoText.Text = "🎮 " .. game.Name
        ServerInfoText.Text = "🌐 JobId: " .. string.sub(game.JobId, 1, 8) .. "..."
        wait(3)
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
Content.Size = UDim2.new(1, -20, 1, -85)
Content.Position = UDim2.new(0, 10, 0, 80)
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

-- ========== ORB BUTTON ==========
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
OrbButton.Parent = ScreenGui

-- ========== FLY PANEL (ENHANCED V3) ==========
local FlyGui = Instance.new("ScreenGui")
FlyGui.Name = "FlyPanelV3"
FlyGui.Parent = CoreGui
FlyGui.Enabled = false

local FlyPanel = Instance.new("Frame")
FlyPanel.Size = UDim2.new(0, 190, 0, 180)
FlyPanel.Position = UDim2.new(0.7, 0, 0.5, -90)
FlyPanel.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
FlyPanel.BorderColor3 = Color3.fromRGB(103, 221, 213)
FlyPanel.BorderSizePixel = 0
FlyPanel.Active = true
FlyPanel.Draggable = true
FlyPanel.Visible = false
Round(FlyPanel, 10)
FlyPanel.Parent = FlyGui

local FlyTitle = Instance.new("TextLabel")
FlyTitle.Size = UDim2.new(1, 0, 0, 28)
FlyTitle.BackgroundTransparency = 1
FlyTitle.Text = "FLY GUI V3"
FlyTitle.TextColor3 = Color3.fromRGB(0, 0, 0)
FlyTitle.TextScaled = true
FlyTitle.Font = Enum.Font.SourceSans
FlyTitle.Parent = FlyPanel

-- Up Button
local up = Instance.new("TextButton")
up.Size = UDim2.new(0, 44, 0, 28)
up.Position = UDim2.new(0, 0, 0, 28)
up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
up.Text = "UP"
up.TextColor3 = Color3.fromRGB(0, 0, 0)
up.TextSize = 14
up.Font = Enum.Font.SourceSans
Round(up, 5)
up.Parent = FlyPanel

-- Down Button
local down = Instance.new("TextButton")
down.Size = UDim2.new(0, 44, 0, 28)
down.Position = UDim2.new(0, 0, 0.49, 0)
down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
down.Text = "DOWN"
down.TextColor3 = Color3.fromRGB(0, 0, 0)
down.TextSize = 14
down.Font = Enum.Font.SourceSans
Round(down, 5)
down.Parent = FlyPanel

-- Fly On/Off Button
local onof = Instance.new("TextButton")
onof.Size = UDim2.new(0, 56, 0, 28)
onof.Position = UDim2.new(0.70, 0, 0.49, 0)
onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
onof.Text = "fly"
onof.TextColor3 = Color3.fromRGB(0, 0, 0)
onof.TextSize = 14
onof.Font = Enum.Font.SourceSans
Round(onof, 5)
onof.Parent = FlyPanel

-- Speed Plus
local plus = Instance.new("TextButton")
plus.Size = UDim2.new(0, 45, 0, 28)
plus.Position = UDim2.new(0.23, 0, 0, 0)
plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(0, 0, 0)
plus.TextScaled = true
plus.Font = Enum.Font.SourceSans
Round(plus, 5)
plus.Parent = FlyPanel

-- Speed Display
local speed = Instance.new("TextLabel")
speed.Size = UDim2.new(0, 44, 0, 28)
speed.Position = UDim2.new(0.47, 0, 0.49, 0)
speed.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
speed.Text = "1"
speed.TextColor3 = Color3.fromRGB(0, 0, 0)
speed.TextScaled = true
speed.Font = Enum.Font.SourceSans
speed.Parent = FlyPanel

-- Speed Minus
local mine = Instance.new("TextButton")
mine.Size = UDim2.new(0, 45, 0, 29)
mine.Position = UDim2.new(0.23, 0, 0.49, 0)
mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
mine.Text = "-"
mine.TextColor3 = Color3.fromRGB(0, 0, 0)
mine.TextScaled = true
mine.Font = Enum.Font.SourceSans
Round(mine, 5)
mine.Parent = FlyPanel

-- Close Button
local closebutton = Instance.new("TextButton")
closebutton.Size = UDim2.new(0, 45, 0, 28)
closebutton.Position = UDim2.new(0, 0, -1, 27)
closebutton.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
closebutton.Text = "X"
closebutton.TextSize = 30
closebutton.Font = Enum.Font.SourceSans
Round(closebutton, 5)
closebutton.Parent = FlyPanel

-- Minimize Buttons
local mini = Instance.new("TextButton")
mini.Size = UDim2.new(0, 45, 0, 28)
mini.Position = UDim2.new(0, 44, -1, 27)
mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini.Text = "-"
mini.TextSize = 40
mini.Font = Enum.Font.SourceSans
Round(mini, 5)
mini.Parent = FlyPanel

local mini2 = Instance.new("TextButton")
mini2.Size = UDim2.new(0, 45, 0, 28)
mini2.Position = UDim2.new(0, 44, -1, 57)
mini2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini2.Text = "+"
mini2.TextSize = 40
mini2.Font = Enum.Font.SourceSans
mini2.Visible = false
Round(mini2, 5)
mini2.Parent = FlyPanel

-- Noclip Toggle for Fly Panel
local noclipFly = Instance.new("TextButton")
noclipFly.Size = UDim2.new(0, 60, 0, 22)
noclipFly.Position = UDim2.new(0.65, 0, 0.85, 0)
noclipFly.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
noclipFly.Text = "NOCLIP"
noclipFly.TextColor3 = Theme.TextMuted
noclipFly.TextSize = 10
noclipFly.Font = Enum.Font.GothamBold
Round(noclipFly, 5)
noclipFly.Parent = FlyPanel

-- Fly Logic Variables
local speeds = 1
local nowe = false
local tpwalking = false
local tis = nil
local dis = nil

-- Fly Toggle Function
onof.MouseButton1Down:Connect(function()
    local speaker = Players.LocalPlayer
    if nowe == true then
        nowe = false
        tpwalking = false
        if speaker.Character and speaker.Character:FindFirstChild("Humanoid") then
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
            speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
            speaker.Character.Animate.Disabled = false
            speaker.Character.Humanoid.PlatformStand = false
        end
    else
        nowe = true
        tpwalking = true
        if speaker.Character and speaker.Character:FindFirstChild("Humanoid") then
            speaker.Character.Animate.Disabled = true
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
            speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
            speaker.Character.Humanoid.PlatformStand = true
            
            -- Fly movement loop
            spawn(function()
                local hb = RunService.Heartbeat
                while tpwalking and hb:Wait() and speaker.Character and speaker.Character:FindFirstChild("Humanoid") do
                    local hum = speaker.Character.Humanoid
                    if hum.MoveDirection.Magnitude > 0 then
                        speaker.Character:TranslateBy(hum.MoveDirection * speeds * 0.5)
                    end
                end
            end)
        end
    end
end)

-- Up Button
up.MouseButton1Down:Connect(function()
    tis = up.MouseEnter:Connect(function()
        while tis and Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") do
            wait()
            Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, 0)
        end
    end)
end)
up.MouseLeave:Connect(function()
    if tis then tis:Disconnect() tis = nil end
end)

-- Down Button
down.MouseButton1Down:Connect(function()
    dis = down.MouseEnter:Connect(function()
        while dis and Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") do
            wait()
            Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -1, 0)
        end
    end)
end)
down.MouseLeave:Connect(function()
    if dis then dis:Disconnect() dis = nil end
end)

-- Speed Plus
plus.MouseButton1Down:Connect(function()
    speeds = speeds + 1
    speed.Text = speeds
end)

-- Speed Minus
mine.MouseButton1Down:Connect(function()
    if speeds == 1 then
        speed.Text = "min 1"
        wait(1)
        speed.Text = speeds
    else
        speeds = speeds - 1
        speed.Text = speeds
    end
end)

-- Close Button
closebutton.MouseButton1Click:Connect(function()
    FlyGui.Enabled = false
    FlyPanel.Visible = false
end)

-- Minimize
mini.MouseButton1Click:Connect(function()
    up.Visible = false
    down.Visible = false
    onof.Visible = false
    plus.Visible = false
    speed.Visible = false
    mine.Visible = false
    mini.Visible = false
    mini2.Visible = true
    noclipFly.Visible = false
    FlyPanel.BackgroundTransparency = 1
    closebutton.Position = UDim2.new(0, 0, -1, 57)
end)

-- Restore
mini2.MouseButton1Click:Connect(function()
    up.Visible = true
    down.Visible = true
    onof.Visible = true
    plus.Visible = true
    speed.Visible = true
    mine.Visible = true
    mini.Visible = true
    mini2.Visible = false
    noclipFly.Visible = true
    FlyPanel.BackgroundTransparency = 0
    closebutton.Position = UDim2.new(0, 0, -1, 27)
end)

-- Noclip for Fly
local flyNoclipActive = false
noclipFly.MouseButton1Click:Connect(function()
    flyNoclipActive = not flyNoclipActive
    noclipFly.Text = flyNoclipActive and "NOCLIP: ON" or "NOCLIP"
    noclipFly.TextColor3 = flyNoclipActive and Theme.Success or Theme.TextMuted
    if flyNoclipActive then
        States.NoclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        if States.NoclipConnection then States.NoclipConnection:Disconnect() end
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
end)

-- Character Added Reset
Players.LocalPlayer.CharacterAdded:Connect(function(char)
    wait(0.7)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = false
        LocalPlayer.Character.Animate.Disabled = false
    end
    nowe = false
    tpwalking = false
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
AdminPanel.Parent = AdminGui

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

-- Admin ESP V2 Folder
States.AdminESPV2Folder = Instance.new("Folder")
States.AdminESPV2Folder.Name = "AdminESP_V2"
States.AdminESPV2Folder.Parent = CoreGui

local function CreateAdminESPV2(player)
    if player == LocalPlayer then return end
    local esp = Instance.new("BillboardGui")
    esp.Name = player.Name .. "_AdminESPV2"
    esp.AlwaysOnTop = true
    esp.Size = UDim2.new(0, 200, 0, 90)
    esp.StudsOffset = Vector3.new(0, 3.5, 0)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Theme.Admin
    bg.BackgroundTransparency = 0.3
    Round(bg, 12)
    bg.Parent = esp
    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1, 0, 0.25, 0)
    name.BackgroundTransparency = 1
    name.Text = "👑 " .. player.Name
    name.TextColor3 = Color3.new(1, 1, 1)
    name.TextSize = 15
    name.Font = Enum.Font.GothamBold
    name.Parent = bg
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
    healthText.TextSize = 12
    healthText.Font = Enum.Font.Gotham
    healthText.Parent = bg
    local dist = Instance.new("TextLabel")
    dist.Size = UDim2.new(1, 0, 0.18, 0)
    dist.Position = UDim2.new(0, 0, 0.62, 0)
    dist.BackgroundTransparency = 1
    dist.Text = "0m"
    dist.TextColor3 = Theme.TextMuted
    dist.TextSize = 11
    dist.Font = Enum.Font.Gotham
    dist.Parent = bg
    local team = Instance.new("TextLabel")
    team.Size = UDim2.new(1, 0, 0.18, 0)
    team.Position = UDim2.new(0, 0, 0.8, 0)
    team.BackgroundTransparency = 1
    team.Text = "Team: None"
    team.TextColor3 = Theme.TextMuted
    team.TextSize = 11
    team.Font = Enum.Font.Gotham
    team.Parent = bg
    esp.Parent = States.AdminESPV2Folder
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
            local status = Instance.new("BillboardGui")
            status.Name = "AdminStatus"
            status.AlwaysOnTop = true
            status.Size = UDim2.new(0, 200, 0, 60)
            status.StudsOffset = Vector3.new(0, 4, 0)
            status.Adornee = LocalPlayer.Character.Head
            local statusBg = Instance.new("Frame")
            statusBg.Size = UDim2.new(1, 0, 1, 0)
            statusBg.BackgroundColor3 = Color3.new(0, 0, 0)
            statusBg.BackgroundTransparency = 0.3
            statusBg.BorderSizePixel = 0
            Round(statusBg, 12)
            statusBg.Parent = status
            local adminLabel = Instance.new("TextLabel")
            adminLabel.Size = UDim2.new(1, 0, 0.6, 0)
            adminLabel.BackgroundTransparency = 1
            adminLabel.Text = "👑 ADMIN/OWNER"
            adminLabel.TextColor3 = Theme.Admin
            adminLabel.TextSize = 18
            adminLabel.Font = Enum.Font.GothamBlack
            adminLabel.Parent = statusBg
            status.Parent = CoreGui
            -- RGB Effect
            spawn(function()
                local hue = 0
                while status.Parent do
                    hue = (hue + 0.02) % 1
                    adminLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
                    wait(0.05)
                end
            end)
        end
        -- Enable Admin ESP V2 Toggle
        for _, p in pairs(Players:GetPlayers()) do
            CreateAdminESPV2(p)
        end
        Players.PlayerAdded:Connect(function(p)
            if Config.IsAdmin then
                wait(1)
                CreateAdminESPV2(p)
            end
        end)
        StarterGui:SetCore("SendNotification", {
            Title = "ADMIN MODE",
            Text = "Welcome Developer! ESP V2 Available",
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

-- Jump Power (NEW)
CreateSlider(MoveCard, "Jump Power", 50, 500, 50, function(val)
    Config.JumpPower = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = val
    end
end)
CreateButton(MoveCard, "Reset Jump", "normal", function()
    Config.JumpPower = 50
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
end)

-- Moon Gravity (NEW)
CreateToggle(MoveCard, "Moon Gravity", function(enabled)
    Config.MoonGravity = enabled
    if States.GravityConnection then States.GravityConnection:Disconnect() end
    if enabled then
        States.GravityConnection = RunService.Heartbeat:Connect(function()
            if Workspace.Gravity ~= 50 then
                Workspace.Gravity = 50
            end
        end)
    else
        Workspace.Gravity = 196.2
    end
end)

-- Fly
local FlyCard = CreateCard("✈️ FLY SYSTEM")
CreateButton(FlyCard, "Open Fly Panel V3", "primary", function()
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

-- Admin ESP V2 Toggle (NEW - Only visible after admin login)
CreateToggle(ESPCard, "ESP V2 (Admin Only)", function(enabled)
    if not Config.IsAdmin then
        StarterGui:SetCore("SendNotification", {
            Title = "ACCESS DENIED",
            Text = "Admin password required!",
            Duration = 3
        })
        return
    end
    Config.ESPAdminV2 = enabled
    if enabled then
        States.AdminESPV2Folder:ClearAllChildren()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                CreateAdminESPV2(p)
            end
        end
    else
        States.AdminESPV2Folder:ClearAllChildren()
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
    else
        if States.BlockESPConnection then States.BlockESPConnection:Disconnect() end
        States.ESPBlockFolder:ClearAllChildren()
    end
end)

-- Add Block Feature (NEW)
local AddBlockCard = CreateCard("📦 ADD BLOCK")
local BlockSelector = Instance.new("TextBox")
BlockSelector.Size = UDim2.new(1, 0, 0, 35)
BlockSelector.BackgroundColor3 = Theme.SurfaceLight
BlockSelector.PlaceholderText = "Block Name..."
BlockSelector.Text = ""
BlockSelector.TextColor3 = Theme.Text
BlockSelector.TextSize = 12
BlockSelector.Font = Enum.Font.GothamBold
Round(BlockSelector, 6)
BlockSelector.Parent = AddBlockCard
CreateButton(AddBlockCard, "Summon Block", "primary", function()
    if BlockSelector.Text ~= "" then
        local block = Instance.new("Part")
        block.Name = BlockSelector.Text
        block.Size = Vector3.new(4, 4, 4)
        block.BrickColor = BrickColor.Random()
        block.Material = Enum.Material.Neon
        block.CanCollide = true
        block.Anchored = false
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            block.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, -5)
        end
        block.Parent = Workspace
        StarterGui:SetCore("SendNotification", {
            Title = "BLOCK ADDED",
            Text = BlockSelector.Text .. " spawned!",
            Duration = 3
        })
    end
end)

-- Copy Avatar (NEW)
local AvatarCard = CreateCard("👤 COPY AVATAR")
local PlayerListAvatar = Instance.new("ScrollingFrame")
PlayerListAvatar.Size = UDim2.new(1, 0, 0, 80)
PlayerListAvatar.BackgroundColor3 = Theme.SurfaceLight
PlayerListAvatar.BackgroundTransparency = 0.3
PlayerListAvatar.BorderSizePixel = 0
PlayerListAvatar.ScrollBarThickness = 4
PlayerListAvatar.CanvasSize = UDim2.new(0, 0, 0, 0)
Round(PlayerListAvatar, 8)
PlayerListAvatar.Parent = AvatarCard
local ListLayoutAvatar = Instance.new("UIListLayout")
ListLayoutAvatar.Padding = UDim.new(0, 4)
ListLayoutAvatar.Parent = PlayerListAvatar
local SelectedAvatarPlayer = nil
local function UpdateAvatarList()
    for _, c in pairs(PlayerListAvatar:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -8, 0, 28)
            btn.Position = UDim2.new(0, 4, 0, 0)
            btn.BackgroundColor3 = SelectedAvatarPlayer == p and Theme.Primary or Theme.Surface
            btn.Text = p.Name
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.TextSize = 11
            btn.Font = Enum.Font.Gotham
            Round(btn, 6)
            btn.Parent = PlayerListAvatar
            btn.MouseButton1Click:Connect(function()
                SelectedAvatarPlayer = p
                UpdateAvatarList()
            end)
        end
    end
    PlayerListAvatar.CanvasSize = UDim2.new(0, 0, 0, (#Players:GetPlayers() - 1) * 32)
end
UpdateAvatarList()
Players.PlayerAdded:Connect(UpdateAvatarList)
Players.PlayerRemoving:Connect(UpdateAvatarList)
CreateButton(AvatarCard, "Copy Avatar", "primary", function()
    if SelectedAvatarPlayer and SelectedAvatarPlayer.Character then
        Config.CopyAvatarTarget = SelectedAvatarPlayer
        -- Clone appearance
        for _, child in pairs(SelectedAvatarPlayer.Character:GetChildren()) do
            if child:IsA("Accessory") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then
                local existing = LocalPlayer.Character:FindFirstChild(child.Name)
                if existing then existing:Destroy() end
                local clone = child:Clone()
                clone.Parent = LocalPlayer.Character
            end
        end
        StarterGui:SetCore("SendNotification", {
            Title = "AVATAR COPIED",
            Text = "Now looks like " .. SelectedAvatarPlayer.Name,
            Duration = 3
        })
    end
end)

-- Save Preset (NEW)
local PresetCard = CreateCard("💾 SAVE PRESET")
local PresetNameBox = Instance.new("TextBox")
PresetNameBox.Size = UDim2.new(1, 0, 0, 35)
PresetNameBox.BackgroundColor3 = Theme.SurfaceLight
PresetNameBox.PlaceholderText = "Preset Name..."
PresetNameBox.Text = ""
PresetNameBox.TextColor3 = Theme.Text
PresetNameBox.TextSize = 12
PresetNameBox.Font = Enum.Font.GothamBold
Round(PresetNameBox, 6)
PresetNameBox.Parent = PresetCard
CreateButton(PresetCard, "Save Preset", "primary", function()
    if PresetNameBox.Text ~= "" then
        Presets[PresetNameBox.Text] = {
            Speed = Config.Speed,
            JumpPower = Config.JumpPower,
            FlySpeed = Config.FlySpeed,
            GodMode = Config.GodMode,
            ESPPlayers = Config.ESPPlayers,
            ESPBlocks = Config.ESPBlocks,
            MoonGravity = Config.MoonGravity
        }
        StarterGui:SetCore("SendNotification", {
            Title = "PRESET SAVED",
            Text = PresetNameBox.Text .. " saved!",
            Duration = 3
        })
    end
end)
CreateButton(PresetCard, "Export Preset", "normal", function()
    if PresetNameBox.Text ~= "" and Presets[PresetNameBox.Text] then
        local export = HttpService:JSONEncode(Presets[PresetNameBox.Text])
        setclipboard(export)
        StarterGui:SetCore("SendNotification", {
            Title = "EXPORTED",
            Text = "Copied to clipboard!",
            Duration = 3
        })
    end
end)
CreateButton(PresetCard, "Load Preset", "admin", function()
    if PresetNameBox.Text ~= "" and Presets[PresetNameBox.Text] then
        local preset = Presets[PresetNameBox.Text]
        Config.Speed = preset.Speed
        Config.JumpPower = preset.JumpPower
        Config.FlySpeed = preset.FlySpeed
        Config.GodMode = preset.GodMode
        Config.ESPPlayers = preset.ESPPlayers
        Config.ESPBlocks = preset.ESPBlocks
        Config.MoonGravity = preset.MoonGravity
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Config.Speed
            LocalPlayer.Character.Humanoid.JumpPower = Config.JumpPower
        end
        StarterGui:SetCore("SendNotification", {
            Title = "PRESET LOADED",
            Text = PresetNameBox.Text .. " loaded!",
            Duration = 3
        })
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
    Tween(MainFrame, {Size = UDim2.new(0, 380, 0, 0)}, 0.3)
    wait(0.3)
    MainFrame.Visible = false
    OrbButton.Visible = true
end)
OrbButton.MouseButton1Click:Connect(function()
    OrbButton.Visible = false
    MainFrame.Visible = true
    Tween(MainFrame, {Size = UDim2.new(0, 380, 0, 450)}, 0.3)
end)

-- Close
CloseBtn.MouseButton1Click:Connect(function()
    Config.Flying = false
    Config.Noclip = false
    Config.GodMode = false
    Config.ESPPlayers = false
    Config.ESPBlocks = false
    Config.AutoFollow = false
    Cleanup()
    ScreenGui:Destroy()
    FlyGui:Destroy()
    AdminGui:Destroy()
end)

-- Intro Animation
MainFrame.Size = UDim2.new(0, 0, 0, 0)
wait(0.2)
Tween(MainFrame, {Size = UDim2.new(0, 380, 0, 450)}, 0.5, Enum.EasingStyle.Back)

print("✅ AP-NEXTGEN v9.0 ENHANCED Loaded!")
print("All Features | Mobile Optimized | New Features Added")
