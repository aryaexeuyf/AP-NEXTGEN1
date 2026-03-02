--[[
    AP-NEXTGEN HUB v3.1
    Optimized & Stable Version
    Opening: WELCOME TO AP-NEXTGEN1
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

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
    AutoFollow = false,
    MobileButtons = false,
    CurrentTab = "Main"
}

-- Theme
local Theme = {
    Background = Color3.fromRGB(10, 10, 15),
    Surface = Color3.fromRGB(20, 20, 28),
    SurfaceLight = Color3.fromRGB(30, 30, 40),
    Primary = Color3.fromRGB(0, 170, 255),
    Secondary = Color3.fromRGB(140, 80, 255),
    Success = Color3.fromRGB(0, 230, 120),
    Error = Color3.fromRGB(255, 60, 80),
    Text = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(150, 150, 170)
}

-- Utility
local function Tween(obj, props, dur, style, dir)
    style = style or Enum.EasingStyle.Quart
    dir = dir or Enum.EasingDirection.Out
    TweenService:Create(obj, TweenInfo.new(dur or 0.3, style, dir), props):Play()
end

local function Round(parent, rad)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, rad or 8)
    c.Parent = parent
    return c
end

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "APNEXTGEN"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- ========== OPENING ANIMATION ==========
local IntroFrame = Instance.new("Frame")
IntroFrame.Name = "Intro"
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.BackgroundColor3 = Color3.new(0, 0, 0)
IntroFrame.ZIndex = 1000
IntroFrame.Parent = ScreenGui

local IntroGradient = Instance.new("UIGradient")
IntroGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 10, 20)),
    ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
})
IntroGradient.Rotation = 90
IntroGradient.Parent = IntroFrame

-- Main Title
local WelcomeText = Instance.new("TextLabel")
WelcomeText.Size = UDim2.new(1, 0, 0, 60)
WelcomeText.Position = UDim2.new(0, 0, 0.4, 0)
WelcomeText.BackgroundTransparency = 1
WelcomeText.Text = ""
WelcomeText.TextColor3 = Theme.Primary
WelcomeText.TextSize = 48
WelcomeText.Font = Enum.Font.GothamBlack
WelcomeText.ZIndex = 1001
WelcomeText.Parent = IntroFrame

-- Subtitle
local SubText = Instance.new("TextLabel")
SubText.Size = UDim2.new(1, 0, 0, 30)
SubText.Position = UDim2.new(0, 0, 0.55, 0)
SubText.BackgroundTransparency = 1
SubText.Text = ""
SubText.TextColor3 = Theme.TextMuted
SubText.TextSize = 18
SubText.Font = Enum.Font.Gotham
SubText.ZIndex = 1001
SubText.Parent = IntroFrame

-- Loading Bar
local LoadBarBg = Instance.new("Frame")
LoadBarBg.Size = UDim2.new(0, 300, 0, 4)
LoadBarBg.Position = UDim2.new(0.5, -150, 0.65, 0)
LoadBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
LoadBarBg.BorderSizePixel = 0
LoadBarBg.ZIndex = 1001
Round(LoadBarBg, 2)
LoadBarBg.Parent = IntroFrame

local LoadBar = Instance.new("Frame")
LoadBar.Size = UDim2.new(0, 0, 1, 0)
LoadBar.BackgroundColor3 = Theme.Primary
LoadBar.BorderSizePixel = 0
LoadBar.ZIndex = 1002
Round(LoadBar, 2)
LoadBar.Parent = LoadBarBg

-- Typewriter Effect
local function TypeWrite(label, text, speed)
    for i = 1, #text do
        label.Text = string.sub(text, 1, i)
        wait(speed or 0.05)
    end
end

-- Opening Sequence
spawn(function()
    wait(0.5)
    
    -- Type main title
    TypeWrite(WelcomeText, "WELCOME TO AP-NEXTGEN1", 0.08)
    wait(0.3)
    
    -- Fade in subtitle
    SubText.Text = "professional script by APTECH"
    SubText.TextTransparency = 1
    Tween(SubText, {TextTransparency = 0}, 0.5)
    
    -- Animate loading bar
    Tween(LoadBar, {Size = UDim2.new(1, 0, 1, 0)}, 1.5)
    wait(1.5)
    
    -- Fade out intro
    Tween(IntroFrame, {BackgroundTransparency = 1}, 0.5)
    Tween(WelcomeText, {TextTransparency = 1}, 0.5)
    Tween(SubText, {TextTransparency = 1}, 0.5)
    Tween(LoadBarBg, {BackgroundTransparency = 1}, 0.5)
    wait(0.5)
    
    IntroFrame:Destroy()
end)

-- ========== MAIN GUI ==========
wait(2.2) -- Wait for intro

-- Minimized Orb
local OrbButton = Instance.new("ImageButton")
OrbButton.Size = UDim2.new(0, 50, 0, 50)
OrbButton.Position = UDim2.new(0, 20, 0.5, -25)
OrbButton.BackgroundColor3 = Theme.Surface
OrbButton.Image = ""
OrbButton.Visible = false
OrbButton.ZIndex = 100
Round(OrbButton, 25)

local OrbStroke = Instance.new("UIStroke")
OrbStroke.Color = Theme.Primary
OrbStroke.Thickness = 2
OrbStroke.Parent = OrbButton

local OrbText = Instance.new("TextLabel")
OrbText.Size = UDim2.new(1, 0, 1, 0)
OrbText.BackgroundTransparency = 1
OrbText.Text = "G1"
OrbText.TextColor3 = Theme.Primary
OrbText.TextSize = 20
OrbText.Font = Enum.Font.GothamBlack
OrbText.Parent = OrbButton

OrbButton.Parent = ScreenGui

-- Main Frame (Compact Size)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Round(MainFrame, 12)
MainFrame.Parent = ScreenGui

-- Glow Effect
local Glow = Instance.new("ImageLabel")
Glow.Size = UDim2.new(1, 40, 1, 40)
Glow.Position = UDim2.new(0.5, 0, 0.5, 0)
Glow.AnchorPoint = Vector2.new(0.5, 0.5)
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://6015897843"
Glow.ImageColor3 = Theme.Primary
Glow.ImageTransparency = 0.8
Glow.ScaleType = Enum.ScaleType.Slice
Glow.SliceCenter = Rect.new(49, 49, 450, 450)
Glow.ZIndex = -1
Glow.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Theme.Surface
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
Round(TopBar, 12)

local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 10)
TopFix.Position = UDim2.new(0, 0, 1, -10)
TopFix.BackgroundColor3 = Theme.Surface
TopFix.BorderSizePixel = 0
TopFix.Parent = TopBar

-- Logo
local Logo = Instance.new("Frame")
Logo.Size = UDim2.new(0, 26, 0, 26)
Logo.Position = UDim2.new(0, 10, 0.5, -13)
Logo.BackgroundColor3 = Theme.Primary
Round(Logo, 6)
Logo.Parent = TopBar

local LogoTxt = Instance.new("TextLabel")
LogoTxt.Size = UDim2.new(1, 0, 1, 0)
LogoTxt.BackgroundTransparency = 1
LogoTxt.Text = "G1"
LogoTxt.TextColor3 = Color3.new(1, 1, 1)
LogoTxt.TextSize = 12
LogoTxt.Font = Enum.Font.GothamBlack
LogoTxt.Parent = Logo

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 150, 0, 20)
Title.Position = UDim2.new(0, 42, 0, 2)
Title.BackgroundTransparency = 1
Title.Text = "AP-NEXTGEN"
Title.TextColor3 = Theme.Text
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 150, 0, 14)
SubTitle.Position = UDim2.new(0, 42, 0, 20)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "PREMIUM"
SubTitle.TextColor3 = Theme.Primary
SubTitle.TextSize = 9
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = TopBar

-- Controls
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 26, 0, 26)
MinBtn.Position = UDim2.new(1, -60, 0.5, -13)
MinBtn.BackgroundColor3 = Theme.SurfaceLight
MinBtn.Text = "-"
MinBtn.TextColor3 = Theme.Text
MinBtn.TextSize = 18
MinBtn.Font = Enum.Font.GothamBold
Round(MinBtn, 6)
MinBtn.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -32, 0.5, -13)
CloseBtn.BackgroundColor3 = Theme.Error
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
Round(CloseBtn, 6)
CloseBtn.Parent = TopBar

-- Content Frame
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -60)
Content.Position = UDim2.new(0, 10, 0, 50)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Simple List Layout
local List = Instance.new("UIListLayout")
List.Padding = UDim.new(0, 8)
List.Parent = Content

-- Component: Card
local function CreateCard(title)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 0)
    Card.AutomaticSize = Enum.AutomaticSize.Y
    Card.BackgroundColor3 = Theme.Surface
    Card.BackgroundTransparency = 0.3
    Card.BorderSizePixel = 0
    Round(Card, 10)
    
    local CardTitle = Instance.new("TextLabel")
    CardTitle.Size = UDim2.new(1, -20, 0, 28)
    CardTitle.Position = UDim2.new(0, 10, 0, 5)
    CardTitle.BackgroundTransparency = 1
    CardTitle.Text = title
    CardTitle.TextColor3 = Theme.Primary
    CardTitle.TextSize = 12
    CardTitle.Font = Enum.Font.GothamBold
    CardTitle.TextXAlignment = Enum.TextXAlignment.Left
    CardTitle.Parent = Card
    
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, -20, 0, 1)
    Divider.Position = UDim2.new(0, 10, 0, 30)
    Divider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Divider.BorderSizePixel = 0
    Divider.Parent = Card
    
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -20, 0, 0)
    Container.Position = UDim2.new(0, 10, 0, 35)
    Container.AutomaticSize = Enum.AutomaticSize.Y
    Container.BackgroundTransparency = 1
    Container.Parent = Card
    
    local ContList = Instance.new("UIListLayout")
    ContList.Padding = UDim.new(0, 6)
    ContList.Parent = Container
    
    local Pad = Instance.new("UIPadding")
    Pad.PaddingBottom = UDim.new(0, 10)
    Pad.Parent = Card
    
    return Card, Container
end

-- Component: Toggle
local function CreateToggle(parent, text, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 32)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.TextSize = 11
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 44, 0, 22)
    Btn.Position = UDim2.new(1, -44, 0.5, -11)
    Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    Btn.Text = "OFF"
    Btn.TextColor3 = Theme.TextMuted
    Btn.TextSize = 10
    Btn.Font = Enum.Font.GothamBold
    Round(Btn, 11)
    Btn.Parent = Frame
    
    local enabled = false
    Btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        Btn.Text = enabled and "ON" or "OFF"
        Tween(Btn, {BackgroundColor3 = enabled and Theme.Success or Color3.fromRGB(60, 60, 70)}, 0.2)
        Tween(Btn, {TextColor3 = enabled and Color3.new(1,1,1) or Theme.TextMuted}, 0.2)
        if callback then callback(enabled) end
    end)
    
    return Frame
end

-- Component: Slider
local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 45)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 0, 18)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.TextSize = 11
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local Val = Instance.new("TextLabel")
    Val.Size = UDim2.new(0.3, 0, 0, 18)
    Val.Position = UDim2.new(0.7, 0, 0, 0)
    Val.BackgroundTransparency = 1
    Val.Text = tostring(default)
    Val.TextColor3 = Theme.Primary
    Val.TextSize = 11
    Val.Font = Enum.Font.GothamBold
    Val.TextXAlignment = Enum.TextXAlignment.Right
    Val.Parent = Frame
    
    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, 0, 0, 4)
    Track.Position = UDim2.new(0, 0, 0, 32)
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
    Knob.Size = UDim2.new(0, 12, 0, 12)
    Knob.Position = UDim2.new((default-min)/(max-min), -6, 0.5, -6)
    Knob.BackgroundColor3 = Color3.new(1, 1, 1)
    Round(Knob, 6)
    Knob.Parent = Track
    
    local dragging = false
    
    local function update(input)
        local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        Val.Text = tostring(val)
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    return Frame
end

-- Component: Button
local function CreateButton(parent, text, style, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 32)
    Btn.BackgroundColor3 = style == "primary" and Theme.Primary or Theme.SurfaceLight
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

-- ========== FEATURES ==========

-- Speed Card
local SpeedCard, SpeedCont = CreateCard("SPEED")
SpeedCard.Parent = Content

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

-- Fly Card
local FlyCard, FlyCont = CreateCard("FLY CONTROL")
FlyCard.Parent = Content

CreateSlider(FlyCont, "Fly Speed", 10, 200, 50, function(val)
    Config.FlySpeed = val
end)

CreateToggle(FlyCont, "Enable Fly", function(enabled)
    Config.Flying = enabled
    -- Fly logic simplified
    if enabled then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            spawn(function()
                while Config.Flying and wait() do
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        hrp.Velocity = Vector3.new(0, Config.FlySpeed, 0)
                    elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        hrp.Velocity = Vector3.new(0, -Config.FlySpeed, 0)
                    end
                end
            end)
        end
    end
end)

-- Noclip Card
local NoclipCard, NoclipCont = CreateCard("NOCLIP")
NoclipCard.Parent = Content

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
    end
end)

-- Teleport Card
local TPCard, TPCont = CreateCard("TELEPORT")
TPCard.Parent = Content

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(1, 0, 0, 100)
PlayerList.BackgroundColor3 = Theme.SurfaceLight
PlayerList.BackgroundTransparency = 0.5
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 4
PlayerList.ScrollBarImageColor3 = Theme.Primary
Round(PlayerList, 6)
PlayerList.Parent = TPCont

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 4)
ListLayout.Parent = PlayerList

local SelectedPlayer = nil

local function UpdateList()
    for _, c in pairs(PlayerList:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -8, 0, 28)
            btn.Position = UDim2.new(0, 4, 0, 0)
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
        end
    end
    
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 32)
end

UpdateList()
Players.PlayerAdded:Connect(UpdateList)
Players.PlayerRemoving:Connect(UpdateList)

CreateButton(TPCont, "Teleport to Selected", "primary", function()
    if SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
    end
end)

-- ESP Card
local ESPCard, ESPCont = CreateCard("ESP")
ESPCard.Parent = Content

local ESPFolder = Instance.new("Folder")
ESPFolder.Parent = CoreGui

CreateToggle(ESPCont, "Enable Player ESP", function(enabled)
    Config.ESP = enabled
    if enabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local esp = Instance.new("BillboardGui")
                esp.AlwaysOnTop = true
                esp.Size = UDim2.new(0, 100, 0, 40)
                esp.StudsOffset = Vector3.new(0, 2, 0)
                esp.Adornee = p.Character.Head
                
                local bg = Instance.new("Frame")
                bg.Size = UDim2.new(1, 0, 1, 0)
                bg.BackgroundColor3 = Theme.Primary
                bg.BackgroundTransparency = 0.7
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
            end
        end
    else
        ESPFolder:ClearAllChildren()
    end
end)

-- God Mode Card
local GodCard, GodCont = CreateCard("GOD MODE")
GodCard.Parent = Content

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
    Tween(MainFrame, {Size = UDim2.new(0, 320, 0, 0)}, 0.3)
    wait(0.3)
    MainFrame.Visible = false
    OrbButton.Visible = true
    Tween(OrbButton, {Size = UDim2.new(0, 50, 0, 50)}, 0.3)
end)

OrbButton.MouseButton1Click:Connect(function()
    OrbButton.Visible = false
    MainFrame.Visible = true
    Tween(MainFrame, {Size = UDim2.new(0, 320, 0, 420)}, 0.3)
end)

-- Close
CloseBtn.MouseButton1Click:Connect(function()
    Tween(MainFrame, {Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, 1.5, 0)}, 0.3)
    wait(0.3)
    ScreenGui:Destroy()
end)

-- Intro Animation for Main GUI
MainFrame.Size = UDim2.new(0, 0, 0, 0)
wait(0.1)
Tween(MainFrame, {Size = UDim2.new(0, 320, 0, 420)}, 0.5, Enum.EasingStyle.Back)

print("✅ AP-NEXTGEN1 Loaded Successfully!")
