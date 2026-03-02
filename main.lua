--[[
    AP-NEXTGEN HUB v3.2 REVISION
    - Fixed Opening Transparency & Animation
    - Fixed Logo Visibility
    - Fixed Scrolling (Smooth Scroll)
    - Added Virtual Fly Controller (Up/Down/Left/Right + Speed)
    - Enhanced UI Aesthetics
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local TextService = game:GetService("TextService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Wait for character
if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

-- Config
local Config = {
    Speed = 16,
    FlySpeed = 100,
    GodMode = false,
    Noclip = false,
    Flying = false,
    ESP = false,
    CurrentTab = "Main",
    FlyDirection = Vector3.new(0,0,0)
}

-- Theme (Modern Dark Blue/Purple)
local Theme = {
    Background = Color3.fromRGB(12, 12, 18),
    Surface = Color3.fromRGB(24, 24, 34),
    SurfaceLight = Color3.fromRGB(35, 35, 48),
    Primary = Color3.fromRGB(0, 162, 255), -- Cyan Blue
    Secondary = Color3.fromRGB(138, 43, 226), -- Purple
    Success = Color3.fromRGB(0, 230, 118),
    Error = Color3.fromRGB(255, 54, 74),
    Text = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(160, 160, 180)
}

-- Utility Functions
local function Tween(obj, props, dur, style, dir)
    style = style or Enum.EasingStyle.Quart
    dir = dir or Enum.EasingDirection.Out
    local tween = TweenService:Create(obj, TweenInfo.new(dur or 0.3, style, dir), props)
    tween:Play()
    return tween
end

local function Round(parent, rad)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, rad or 8)
    c.Parent = parent
    return c
end

local function Stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Primary
    s.Thickness = thickness or 1
    s.Transparency = 0.5
    s.Parent = parent
    return s
end

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "APNEXTGEN_V3.2"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.IgnoreGuiInset = true

-- ========== OPENING ANIMATION (FIXED) ==========
local IntroFrame = Instance.new("Frame")
IntroFrame.Name = "Intro"
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.BackgroundColor3 = Color3.new(0, 0, 0)
IntroFrame.BackgroundTransparency = 1 -- Start transparent for fade in effect if needed, but we set to 0 immediately
IntroFrame.ZIndex = 1000
IntroFrame.Parent = ScreenGui

-- Solid Black Background for Intro
local IntroBg = Instance.new("Frame")
IntroBg.Size = UDim2.new(1,0,1,0)
IntroBg.BackgroundColor3 = Color3.new(0,0,0)
IntroBg.BorderSizePixel = 0
IntroBg.ZIndex = 1000
IntroBg.Parent = IntroFrame

-- Gradient Overlay for Style
local IntroGradient = Instance.new("UIGradient")
IntroGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 5, 20)),
    ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
})
IntroGradient.Rotation = 90
IntroGradient.Parent = IntroBg

-- Main Title (Transparent Background)
local WelcomeText = Instance.new("TextLabel")
WelcomeText.Size = UDim2.new(1, 0, 0, 60)
WelcomeText.Position = UDim2.new(0, 0, 0.4, 0)
WelcomeText.BackgroundTransparency = 1 -- CRITICAL FIX
WelcomeText.Text = ""
WelcomeText.TextColor3 = Theme.Primary
WelcomeText.TextSize = 42
WelcomeText.Font = Enum.Font.GothamBlack
WelcomeText.TextStrokeTransparency = 0.5
WelcomeText.ZIndex = 1001
WelcomeText.Parent = IntroFrame

-- Subtitle (Transparent Background)
local SubText = Instance.new("TextLabel")
SubText.Size = UDim2.new(1, 0, 0, 30)
SubText.Position = UDim2.new(0, 0, 0.55, 0)
SubText.BackgroundTransparency = 1 -- CRITICAL FIX
SubText.Text = ""
SubText.TextColor3 = Theme.Text
SubText.TextSize = 16
SubText.Font = Enum.Font.Gotham
SubText.TextTransparency = 1
SubText.ZIndex = 1001
SubText.Parent = IntroFrame

-- Loading Bar Container
local LoadBarBg = Instance.new("Frame")
LoadBarBg.Size = UDim2.new(0, 250, 0, 4)
LoadBarBg.Position = UDim2.new(0.5, -125, 0.65, 0)
LoadBarBg.BackgroundColor3 = Theme.SurfaceLight
LoadBarBg.BackgroundTransparency = 0.5
LoadBarBg.BorderSizePixel = 0
LoadBarBg.ZIndex = 1001
Round(LoadBarBg, 2)
LoadBarBg.Parent = IntroFrame
Stroke(LoadBarBg, Theme.Primary, 1)

-- Loading Bar Fill
local LoadBar = Instance.new("Frame")
LoadBar.Size = UDim2.new(0, 0, 1, 0)
LoadBar.BackgroundColor3 = Theme.Primary
LoadBar.BorderSizePixel = 0
LoadBar.ZIndex = 1002
Round(LoadBar, 2)
LoadBar.Parent = LoadBarBg

-- Typewriter Effect Function
local function TypeWrite(label, text, speed)
    label.Text = ""
    for i = 1, #text do
        label.Text = string.sub(text, 1, i)
        task.wait(speed or 0.03)
    end
end

-- Opening Sequence
spawn(function()
    -- Fade In Background
    Tween(IntroBg, {BackgroundTransparency = 0}, 0.5)
    task.wait(0.5)
    
    -- Type main title
    TypeWrite(WelcomeText, "WELCOME TO AP-NEXTGEN", 0.05)
    
    -- Fade in subtitle
    SubText.Text = "Professional Script by APTECH"
    Tween(SubText, {TextTransparency = 0}, 0.5)
    
    -- Animate loading bar
    Tween(LoadBar, {Size = UDim2.new(1, 0, 1, 0)}, 1.2, Enum.EasingStyle.Quad)
    task.wait(1.2)
    
    -- Hold briefly
    task.wait(0.3)
    
    -- Fade out entire intro
    Tween(IntroFrame, {BackgroundTransparency = 1}, 0.4)
    Tween(WelcomeText, {TextTransparency = 1}, 0.4)
    Tween(SubText, {TextTransparency = 1}, 0.4)
    Tween(LoadBarBg, {BackgroundTransparency = 1}, 0.4)
    
    task.wait(0.5)
    IntroFrame:Destroy()
end)

-- ========== MAIN GUI STRUCTURE ==========
task.wait(2.2) -- Wait for intro to finish

-- Minimized Orb Button
local OrbButton = Instance.new("TextButton")
OrbButton.Size = UDim2.new(0, 50, 0, 50)
OrbButton.Position = UDim2.new(0, 20, 0.5, -25)
OrbButton.BackgroundColor3 = Theme.Surface
OrbButton.Text = ""
OrbButton.Visible = false
OrbButton.ZIndex = 100
Round(OrbButton, 25)
Stroke(OrbButton, Theme.Primary, 2)
OrbButton.Parent = ScreenGui

-- Orb Icon (Fixed to be visible)
local OrbIcon = Instance.new("TextLabel")
OrbIcon.Size = UDim2.new(1, 0, 1, 0)
OrbIcon.BackgroundTransparency = 1
OrbIcon.Text = "G1"
OrbIcon.TextColor3 = Theme.Primary
OrbIcon.TextSize = 20
OrbIcon.Font = Enum.Font.GothamBlack
OrbIcon.ZIndex = 101
OrbIcon.Parent = OrbButton

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 340, 0, 480) -- Slightly taller for scroll
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -240)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.ZIndex = 50
Round(MainFrame, 12)
MainFrame.Parent = ScreenGui

-- Glow Effect Behind
local Glow = Instance.new("ImageLabel")
Glow.Size = UDim2.new(1, 40, 1, 40)
Glow.Position = UDim2.new(0.5, 0, 0.5, 0)
Glow.AnchorPoint = Vector2.new(0.5, 0.5)
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://6015897843"
Glow.ImageColor3 = Theme.Primary
Glow.ImageTransparency = 0.85
Glow.ScaleType = Enum.ScaleType.Slice
Glow.SliceCenter = Rect.new(49, 49, 450, 450)
Glow.ZIndex = -1
Glow.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Theme.Surface
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 51
TopBar.Parent = MainFrame
Round(TopBar, 12)

-- Fix bottom edge of topbar to merge seamlessly
local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 5)
TopFix.Position = UDim2.new(0, 0, 1, -5)
TopFix.BackgroundColor3 = Theme.Surface
TopFix.BorderSizePixel = 0
TopFix.ZIndex = 51
TopFix.Parent = TopBar

-- LOGO (FIXED: Visible Circle with Content)
local LogoContainer = Instance.new("Frame")
LogoContainer.Size = UDim2.new(0, 30, 0, 30)
LogoContainer.Position = UDim2.new(0, 10, 0.5, -15)
LogoContainer.BackgroundColor3 = Theme.Primary
LogoContainer.ZIndex = 52
Round(LogoContainer, 8)
LogoContainer.Parent = TopBar

local LogoInner = Instance.new("Frame")
LogoInner.Size = UDim2.new(0.8, 0, 0.8, 0)
LogoInner.Position = UDim2.new(0.1, 0, 0.1, 0)
LogoInner.BackgroundColor3 = Color3.new(1,1,1)
LogoInner.ZIndex = 53
Round(LogoInner, 6)
LogoInner.Parent = LogoContainer

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(1, 0, 1, 0)
LogoText.BackgroundTransparency = 1
LogoText.Text = "G1"
LogoText.TextColor3 = Theme.Primary
LogoText.TextSize = 14
LogoText.Font = Enum.Font.GothamBlack
LogoText.ZIndex = 54
LogoText.Parent = LogoInner

-- Titles
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 160, 0, 20)
Title.Position = UDim2.new(0, 48, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "AP-NEXTGEN"
Title.TextColor3 = Theme.Text
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 52
Title.Parent = TopBar

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 160, 0, 12)
SubTitle.Position = UDim2.new(0, 48, 0, 26)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "PREMIUM EDITION"
SubTitle.TextColor3 = Theme.Primary
SubTitle.TextSize = 9
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.ZIndex = 52
SubTitle.Parent = TopBar

-- Controls (Min/Close)
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -65, 0.5, -14)
MinBtn.BackgroundColor3 = Theme.SurfaceLight
MinBtn.Text = "-"
MinBtn.TextColor3 = Theme.Text
MinBtn.TextSize = 18
MinBtn.Font = Enum.Font.GothamBold
Round(MinBtn, 6)
MinBtn.ZIndex = 52
MinBtn.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -14)
CloseBtn.BackgroundColor3 = Theme.Error
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
Round(CloseBtn, 6)
CloseBtn.ZIndex = 52
CloseBtn.Parent = TopBar

-- CONTENT AREA WITH SCROLLING (FIXED)
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -15, 1, -60)
ContentFrame.Position = UDim2.new(0, 10, 0, 55)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 5
ContentFrame.ScrollBarImageColor3 = Theme.Primary
ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will be updated by layout
ContentFrame.ZIndex = 50
ContentFrame.Parent = MainFrame

-- Layout for Content
local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 10)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = ContentFrame

local Padding = Instance.new("UIPadding")
Padding.PaddingBottom = UDim.new(0, 15)
Padding.PaddingLeft = UDim.new(0, 5)
Padding.PaddingRight = UDim.new(0, 5)
Padding.Parent = ContentFrame

-- Component: Card
local function CreateCard(title, order)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 0)
    Card.AutomaticSize = Enum.AutomaticSize.Y
    Card.BackgroundColor3 = Theme.Surface
    Card.BackgroundTransparency = 0.2
    Card.BorderSizePixel = 0
    Card.LayoutOrder = order
    Round(Card, 10)
    Stroke(Card, Theme.SurfaceLight, 1)
    
    local CardTitle = Instance.new("TextLabel")
    CardTitle.Size = UDim2.new(1, -20, 0, 24)
    CardTitle.Position = UDim2.new(0, 10, 0, 8)
    CardTitle.BackgroundTransparency = 1
    CardTitle.Text = title
    CardTitle.TextColor3 = Theme.Primary
    CardTitle.TextSize = 13
    CardTitle.Font = Enum.Font.GothamBold
    CardTitle.TextXAlignment = Enum.TextXAlignment.Left
    CardTitle.Parent = Card
    
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, -20, 0, 1)
    Divider.Position = UDim2.new(0, 10, 0, 35)
    Divider.BackgroundColor3 = Theme.SurfaceLight
    Divider.BackgroundTransparency = 0.5
    Divider.BorderSizePixel = 0
    Divider.Parent = Card
    
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -20, 0, 0)
    Container.Position = UDim2.new(0, 10, 0, 42)
    Container.AutomaticSize = Enum.AutomaticSize.Y
    Container.BackgroundTransparency = 1
    Container.Parent = Card
    
    local ContList = Instance.new("UIListLayout")
    ContList.Padding = UDim.new(0, 8)
    ContList.Parent = Container
    
    return Card, Container
end

-- Component: Toggle
local function CreateToggle(parent, text, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 36)
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
    Btn.Size = UDim2.new(0, 50, 0, 24)
    Btn.Position = UDim2.new(1, -50, 0.5, -12)
    Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
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
        Tween(Btn, {BackgroundColor3 = enabled and Theme.Success or Color3.fromRGB(50, 50, 60)}, 0.2)
        Tween(Btn, {TextColor3 = enabled and Color3.new(1,1,1) or Theme.TextMuted}, 0.2)
        if callback then callback(enabled) end
    end)
    
    return Frame
end

-- Component: Slider
local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 50)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 20)
    Header.BackgroundTransparency = 1
    Header.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.TextSize = 12
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Header
    
    local Val = Instance.new("TextLabel")
    Val.Size = UDim2.new(0.4, 0, 1, 0)
    Val.Position = UDim2.new(0.6, 0, 0, 0)
    Val.BackgroundTransparency = 1
    Val.Text = tostring(default)
    Val.TextColor3 = Theme.Primary
    Val.TextSize = 12
    Val.Font = Enum.Font.GothamBold
    Val.TextXAlignment = Enum.TextXAlignment.Right
    Val.Parent = Header
    
    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, 0, 0, 6)
    Track.Position = UDim2.new(0, 0, 0, 24)
    Track.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
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
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = UDim2.new((default-min)/(max-min), -7, 0.5, -7)
    Knob.BackgroundColor3 = Color3.new(1, 1, 1)
    Round(Knob, 7)
    Knob.Parent = Track
    
    local dragging = false
    
    local function update(input)
        local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        Val.Text = tostring(val)
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    return Frame
end

-- Component: Button
local function CreateButton(parent, text, style, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 36)
    Btn.BackgroundColor3 = style == "primary" and Theme.Primary or Theme.SurfaceLight
    Btn.Text = text
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.TextSize = 12
    Btn.Font = Enum.Font.GothamBold
    Round(Btn, 8)
    Btn.Parent = parent
    
    Btn.MouseButton1Click:Connect(function()
        Tween(Btn, {Size = UDim2.new(0.96, 0, 0, 34)}, 0.1)
        task.wait(0.1)
        Tween(Btn, {Size = UDim2.new(1, 0, 0, 36)}, 0.1)
        if callback then callback() end
    end)
    
    return Btn
end

-- ========== VIRTUAL FLY CONTROLLER (NEW GUI) ==========
local FlyController = Instance.new("Frame")
FlyController.Name = "FlyController"
FlyController.Size = UDim2.new(0, 180, 0, 220)
FlyController.Position = UDim2.new(1, -200, 1, -240) -- Bottom Right
FlyController.BackgroundColor3 = Theme.Background
FlyController.BackgroundTransparency = 0.1
FlyController.BorderSizePixel = 0
FlyController.Visible = false
FlyController.ZIndex = 200
Round(FlyController, 12)
Stroke(FlyController, Theme.Primary, 1)
FlyController.Parent = ScreenGui

-- Controller Header
local CtrlHeader = Instance.new("TextLabel")
CtrlHeader.Size = UDim2.new(1, 0, 0, 30)
CtrlHeader.BackgroundTransparency = 1
CtrlHeader.Text = "FLY CONTROL"
CtrlHeader.TextColor3 = Theme.Primary
CtrlHeader.TextSize = 10
CtrlHeader.Font = Enum.Font.GothamBold
CtrlHeader.Parent = FlyController

-- D-Pad Layout
local DPadFrame = Instance.new("Frame")
DPadFrame.Size = UDim2.new(0, 140, 0, 140)
DPadFrame.Position = UDim2.new(0.5, -70, 0, 35)
DPadFrame.BackgroundTransparency = 1
DPadFrame.Parent = FlyController

local function CreateDirBtn(parent, text, pos, key, direction)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = Theme.SurfaceLight
    btn.Text = text
    btn.TextColor3 = Theme.Text
    btn.TextSize = 18
    btn.Font = Enum.Font.GothamBlack
    Round(btn, 8)
    btn.Parent = parent
    
    local active = false
    
    local function startFly()
        active = true
        btn.BackgroundColor3 = Theme.Primary
        Config.FlyDirection = direction
    end
    
    local function stopFly()
        active = false
        btn.BackgroundColor3 = Theme.SurfaceLight
        if Config.FlyDirection == direction then
            Config.FlyDirection = Vector3.new(0,0,0)
        end
    end
    
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            startFly()
        end
    end)
    
    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            stopFly()
        end
    end)
    
    -- Mouse leave safety
    btn.MouseLeave:Connect(function()
        if active then stopFly() end
    end)
    
    return btn
end

-- D-Pad Buttons
CreateDirBtn(DPadFrame, "▲", UDim2.new(0.5, -20, 0, 0), Enum.KeyCode.W, Vector3.new(0, 0, -1)) -- Up (Forward)
CreateDirBtn(DPadFrame, "▼", UDim2.new(0.5, -20, 0, 100), Enum.KeyCode.S, Vector3.new(0, 0, 1)) -- Down (Backward)
CreateDirBtn(DPadFrame, "◀", UDim2.new(0, 0, 0.5, -20), Enum.KeyCode.A, Vector3.new(-1, 0, 0)) -- Left
CreateDirBtn(DPadFrame, "▶", UDim2.new(1, -40, 0.5, -20), Enum.KeyCode.D, Vector3.new(1, 0, 0)) -- Right

-- Vertical Fly (High/Low) - Smaller buttons below
local UpBtn = CreateDirBtn(DPadFrame, "UP", UDim2.new(0.5, -20, 0, -25), Enum.KeyCode.Space, Vector3.new(0, 1, 0))
UpBtn.Size = UDim2.new(0, 40, 0, 25)
UpBtn.TextSize = 10

local DownBtn = CreateDirBtn(DPadFrame, "DN", UDim2.new(0.5, -20, 0, 125), Enum.KeyCode.LeftShift, Vector3.new(0, -1, 0))
DownBtn.Size = UDim2.new(0, 40, 0, 25)
DownBtn.TextSize = 10

-- Speed Slider in Controller
local CtrlSliderTrack = Instance.new("Frame")
CtrlSliderTrack.Size = UDim2.new(0.8, 0, 0, 4)
CtrlSliderTrack.Position = UDim2.new(0.1, 0, 1, -25)
CtrlSliderTrack.BackgroundColor3 = Theme.SurfaceLight
Round(CtrlSliderTrack, 2)
CtrlSliderTrack.Parent = FlyController

local CtrlSliderFill = Instance.new("Frame")
CtrlSliderFill.Size = UDim2.new(0.5, 0, 1, 0)
CtrlSliderFill.BackgroundColor3 = Theme.Secondary
Round(CtrlSliderFill, 2)
CtrlSliderFill.Parent = CtrlSliderTrack

local CtrlSpeedLabel = Instance.new("TextLabel")
CtrlSpeedLabel.Size = UDim2.new(1, 0, 0, 15)
CtrlSpeedLabel.Position = UDim2.new(0, 0, 1, -22)
CtrlSpeedLabel.BackgroundTransparency = 1
CtrlSpeedLabel.Text = "Speed: 100"
CtrlSpeedLabel.TextColor3 = Theme.TextMuted
CtrlSpeedLabel.TextSize = 9
CtrlSpeedLabel.Font = Enum.Font.Gotham
CtrlSpeedLabel.Parent = FlyController

-- Slider Logic for Controller
local ctrlDragging = false
CtrlSliderTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        ctrlDragging = true
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if ctrlDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local pos = math.clamp((input.Position.X - CtrlSliderTrack.AbsolutePosition.X) / CtrlSliderTrack.AbsoluteSize.X, 0, 1)
        local val = math.floor(10 + (200 - 10) * pos)
        Config.FlySpeed = val
        CtrlSpeedLabel.Text = "Speed: " .. val
        CtrlSliderFill.Size = UDim2.new(pos, 0, 1, 0)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        ctrlDragging = false
    end
end)


-- ========== FEATURES IMPLEMENTATION ==========

-- 1. Speed Card
local SpeedCard, SpeedCont = CreateCard("MOVEMENT SPEED", 1)
SpeedCard.Parent = ContentFrame

CreateSlider(SpeedCont, "Walk Speed", 16, 300, 50, function(val)
    Config.Speed = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)

CreateButton(SpeedCont, "Reset Speed (16)", "normal", function()
    Config.Speed = 16
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- 2. Fly Card
local FlyCard, FlyCont = CreateCard("FLY SYSTEM", 2)
FlyCard.Parent = ContentFrame

CreateSlider(FlyCont, "Base Fly Speed", 10, 200, 100, function(val)
    Config.FlySpeed = val
    CtrlSpeedLabel.Text = "Speed: " .. val
    -- Update controller slider visual roughly
    local percent = (val - 10) / (200 - 10)
    CtrlSliderFill.Size = UDim2.new(percent, 0, 1, 0)
end)

local flyConnection = nil
CreateToggle(FlyCont, "Enable Fly Mode", function(enabled)
    Config.Flying = enabled
    FlyController.Visible = enabled
    
    if enabled then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            -- Stop existing loops if any
            if flyConnection then flyConnection:Disconnect() end
            
            flyConnection = RunService.Heartbeat:Connect(function()
                if Config.Flying and Config.FlyDirection ~= Vector3.new(0,0,0) then
                    -- Calculate velocity based on camera direction for forward/back
                    local camDir = Camera.CFrame.LookVector
                    local camRight = Camera.CFrame.RightVector
                    
                    local moveVec = Vector3.new(0,0,0)
                    
                    if Config.FlyDirection == Vector3.new(0, 0, -1) then -- Forward
                        moveVec = camDir * Config.FlySpeed
                    elseif Config.FlyDirection == Vector3.new(0, 0, 1) then -- Backward
                        moveVec = -camDir * Config.FlySpeed
                    elseif Config.FlyDirection == Vector3.new(-1, 0, 0) then -- Left
                        moveVec = -camRight * Config.FlySpeed
                    elseif Config.FlyDirection == Vector3.new(1, 0, 0) then -- Right
                        moveVec = camRight * Config.FlySpeed
                    elseif Config.FlyDirection == Vector3.new(0, 1, 0) then -- Up
                        moveVec = Vector3.new(0, Config.FlySpeed, 0)
                    elseif Config.FlyDirection == Vector3.new(0, -1, 0) then -- Down
                        moveVec = Vector3.new(0, -Config.FlySpeed, 0)
                    end
                    
                    hrp.Velocity = moveVec
                elseif not Config.Flying then
                    hrp.Velocity = Vector3.new(0,0,0)
                end
            end)
        end
    else
        FlyController.Visible = false
        if flyConnection then 
            flyConnection:Disconnect() 
            flyConnection = nil
        end
        -- Reset velocity
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        end
    end
end)

-- 3. Noclip Card
local NoclipCard, NoclipCont = CreateCard("NOCLIP", 3)
NoclipCard.Parent = ContentFrame

local NoclipConn = nil
CreateToggle(NoclipCont, "Enable Noclip", function(enabled)
    Config.Noclip = enabled
    if enabled then
        NoclipConn = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then 
                        part.CanCollide = false 
                    end
                end
            end
        end)
    else
        if NoclipConn then NoclipConn:Disconnect() end
        -- Restore collision
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
end)

-- 4. Teleport Card
local TPCard, TPCont = CreateCard("TELEPORT", 4)
TPCard.Parent = ContentFrame

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(1, 0, 0, 120)
PlayerList.BackgroundColor3 = Theme.SurfaceLight
PlayerList.BackgroundTransparency = 0.8
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 4
PlayerList.ScrollBarImageColor3 = Theme.Primary
PlayerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerList.CanvasSize = UDim2.new(0,0,0,0)
Round(PlayerList, 6)
PlayerList.Parent = TPCont

local ListLayoutPL = Instance.new("UIListLayout")
ListLayoutPL.Padding = UDim.new(0, 4)
ListLayoutPL.Parent = PlayerList

local SelectedPlayer = nil

local function UpdateList()
    for _, c in pairs(PlayerList:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    
    local count = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -8, 0, 30)
            btn.BackgroundColor3 = SelectedPlayer == p and Theme.Primary or Theme.Surface
            btn.Text = p.Name
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.TextSize = 11
            btn.Font = Enum.Font.Gotham
            Round(btn, 4)
            btn.Parent = PlayerList
            
            btn.MouseButton1Click:Connect(function()
                SelectedPlayer = p
                UpdateList()
            end)
            count = count + 1
        end
    end
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, (count * 34) + 4)
end

UpdateList()
Players.PlayerAdded:Connect(UpdateList)
Players.PlayerRemoving:Connect(UpdateList)

CreateButton(TPCont, "Teleport to Selected", "primary", function()
    if SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
    end
end)

-- 5. ESP Card
local ESPCard, ESPCont = CreateCard("VISUALS (ESP)", 5)
ESPCard.Parent = ContentFrame

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESP_Folder"
ESPFolder.Parent = CoreGui

local espConnections = {}

CreateToggle(ESPCont, "Enable Player ESP", function(enabled)
    Config.ESP = enabled
    if enabled then
        local function addEsp(p)
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local esp = Instance.new("BillboardGui")
                esp.AlwaysOnTop = true
                esp.Size = UDim2.new(0, 100, 0, 40)
                esp.StudsOffset = Vector3.new(0, 2.5, 0)
                esp.Adornee = p.Character.Head
                esp.Name = "ESP_" .. p.Name
                
                local bg = Instance.new("Frame")
                bg.Size = UDim2.new(1, 0, 1, 0)
                bg.BackgroundColor3 = Theme.Primary
                bg.BackgroundTransparency = 0.6
                Round(bg, 6)
                bg.Parent = esp
                
                local txt = Instance.new("TextLabel")
                txt.Size = UDim2.new(1, 0, 1, 0)
                txt.BackgroundTransparency = 1
                txt.Text = p.Name
                txt.TextColor3 = Color3.new(1, 1, 1)
                txt.TextSize = 12
                txt.Font = Enum.Font.GothamBold
                txt.Parent = bg
                
                esp.Parent = ESPFolder
                espConnections[p] = esp
                
                p.CharacterAdded:Connect(function()
                    if Config.ESP and espConnections[p] then
                        wait(1)
                        if p.Character and p.Character:FindFirstChild("Head") then
                            esp.Adornee = p.Character.Head
                        end
                    end
                end)
            end
        end
        
        for _, p in pairs(Players:GetPlayers()) do addEsp(p) end
        
        Players.PlayerAdded:Connect(addEsp)
        Players.PlayerRemoving:Connect(function(p)
            if espConnections[p] then espConnections[p]:Destroy() end
            espConnections[p] = nil
        end)
        
    else
        ESPFolder:ClearAllChildren()
        for _, conn in pairs(espConnections) do conn:Destroy() end
        espConnections = {}
    end
end)

-- 6. God Mode Card
local GodCard, GodCont = CreateCard("GOD MODE", 6)
GodCard.Parent = ContentFrame

CreateToggle(GodCont, "Enable God Mode", function(enabled)
    Config.GodMode = enabled
    spawn(function()
        while Config.GodMode and wait(0.2) do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
            end
        end
    end)
end)

-- ========== CONTROLS & DRAGGING ==========

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
    task.wait(0.3)
    MainFrame.Visible = false
    OrbButton.Visible = true
    Tween(OrbButton, {Size = UDim2.new(0, 50, 0, 50)}, 0.3)
end)

OrbButton.MouseButton1Click:Connect(function()
    OrbButton.Visible = false
    MainFrame.Visible = true
    Tween(MainFrame, {Size = UDim2.new(0, 340, 0, 480)}, 0.3, Enum.EasingStyle.Back)
end)

-- Close
CloseBtn.MouseButton1Click:Connect(function()
    Tween(MainFrame, {Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, 1.5, 0)}, 0.3)
    task.wait(0.3)
    ScreenGui:Destroy()
end)

-- Intro Animation for Main GUI
MainFrame.Size = UDim2.new(0, 0, 0, 0)
task.wait(0.1)
Tween(MainFrame, {Size = UDim2.new(0, 340, 0, 480)}, 0.6, Enum.EasingStyle.Back)

print("✅ AP-NEXTGEN v3.2 Loaded Successfully!")
print("🎮 Virtual Fly Controller added.")
print("📜 Scrolling fixed.")
