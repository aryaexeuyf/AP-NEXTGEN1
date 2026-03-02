--[[
    AP-NEXTGEN HUB v3.2 PREMIUM
    Optimized & Stable Version (Scroll Fixed, Virtual Fly Added)
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Wait for character
if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

-- Config & States
local Config = {
    Speed = 16,
    FlySpeed = 50,
    GodMode = false,
    Noclip = false,
    Flying = false,
    ESP = false
}

local FlyInputs = { F = 0, B = 0, L = 0, R = 0, U = 0, D = 0 }

-- Theme Premium
local Theme = {
    Background = Color3.fromRGB(15, 15, 20),
    Surface = Color3.fromRGB(25, 25, 35),
    SurfaceLight = Color3.fromRGB(35, 35, 45),
    Primary = Color3.fromRGB(0, 190, 255),
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
    local t = TweenService:Create(obj, TweenInfo.new(dur or 0.3, style, dir), props)
    t:Play()
    return t
end

local function Round(parent, rad)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, rad or 8)
    c.Parent = parent
    return c
end

local function AddStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Primary
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function MakeDraggable(topbar, object)
    local dragging, dragStart, startPos = false, nil, nil
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "APNEXTGEN"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- ========== OPENING ANIMATION (TRANSPARENT) ==========
local IntroFrame = Instance.new("Frame")
IntroFrame.Name = "Intro"
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.BackgroundColor3 = Color3.new(0, 0, 0)
IntroFrame.BackgroundTransparency = 0.4 -- Membuatnya tembus pandang
IntroFrame.ZIndex = 1000
IntroFrame.Parent = ScreenGui

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
SubText.TextColor3 = Theme.Text
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

local function TypeWrite(label, text, speed)
    for i = 1, #text do
        label.Text = string.sub(text, 1, i)
        wait(speed or 0.05)
    end
end

-- Sequence
spawn(function()
    wait(0.5)
    TypeWrite(WelcomeText, "AP-NEXTGEN PREMIUM", 0.06)
    SubText.Text = "Initializing Systems..."
    SubText.TextTransparency = 1
    Tween(SubText, {TextTransparency = 0}, 0.5)
    Tween(LoadBar, {Size = UDim2.new(1, 0, 1, 0)}, 1.5)
    wait(1.5)
    Tween(IntroFrame, {BackgroundTransparency = 1}, 0.5)
    Tween(WelcomeText, {TextTransparency = 1}, 0.5)
    Tween(SubText, {TextTransparency = 1}, 0.5)
    Tween(LoadBarBg, {BackgroundTransparency = 1}, 0.5)
    wait(0.5)
    IntroFrame:Destroy()
end)

wait(2.5) -- Wait for intro

-- ========== MAIN GUI ==========

-- Minimized Orb
local OrbButton = Instance.new("ImageButton")
OrbButton.Size = UDim2.new(0, 50, 0, 50)
OrbButton.Position = UDim2.new(0, 20, 0.5, -25)
OrbButton.BackgroundColor3 = Theme.Surface
OrbButton.Visible = false
OrbButton.ZIndex = 100
Round(OrbButton, 25)
AddStroke(OrbButton, Theme.Primary, 2)

local OrbIcon = Instance.new("ImageLabel")
OrbIcon.Size = UDim2.new(0, 26, 0, 26)
OrbIcon.Position = UDim2.new(0.5, -13, 0.5, -13)
OrbIcon.BackgroundTransparency = 1
OrbIcon.Image = "rbxassetid://6031280882" -- Cool icon
OrbIcon.ImageColor3 = Theme.Primary
OrbIcon.Parent = OrbButton
OrbButton.Parent = ScreenGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Round(MainFrame, 12)
AddStroke(MainFrame, Color3.fromRGB(40,40,50), 1)
MainFrame.Parent = ScreenGui

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Theme.Surface
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
Round(TopBar, 12)
MakeDraggable(TopBar, MainFrame)

local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 10)
TopFix.Position = UDim2.new(0, 0, 1, -10)
TopFix.BackgroundColor3 = Theme.Surface
TopFix.BorderSizePixel = 0
TopFix.Parent = TopBar

-- Logo (Diperbaiki jadi gambar icon)
local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 24, 0, 24)
Logo.Position = UDim2.new(0, 12, 0.5, -12)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://6031280882" -- Icon Shield/Gear
Logo.ImageColor3 = Theme.Primary
Logo.Parent = TopBar

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 150, 0, 20)
Title.Position = UDim2.new(0, 45, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "AP-NEXTGEN"
Title.TextColor3 = Theme.Text
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 150, 0, 14)
SubTitle.Position = UDim2.new(0, 45, 0, 23)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "PREMIUM EDITION"
SubTitle.TextColor3 = Theme.Primary
SubTitle.TextSize = 10
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = TopBar

-- Controls
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -64, 0.5, -14)
MinBtn.BackgroundColor3 = Theme.SurfaceLight
MinBtn.Text = "-"
MinBtn.TextColor3 = Theme.Text
MinBtn.TextSize = 18
MinBtn.Font = Enum.Font.GothamBold
Round(MinBtn, 6)
MinBtn.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -14)
CloseBtn.BackgroundColor3 = Theme.Error
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
Round(CloseBtn, 6)
CloseBtn.Parent = TopBar

-- Content Frame (DIPERBAIKI JADI SCROLLINGFRAME)
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -16, 1, -55)
Content.Position = UDim2.new(0, 8, 0, 50)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 3
Content.ScrollBarImageColor3 = Theme.Primary
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y -- Kunci agar bisa discroll otomatis
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.Parent = MainFrame

local List = Instance.new("UIListLayout")
List.Padding = UDim.new(0, 8)
List.SortOrder = Enum.SortOrder.LayoutOrder
List.Parent = Content

-- Components
local function CreateCard(title)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -8, 0, 0)
    Card.AutomaticSize = Enum.AutomaticSize.Y
    Card.BackgroundColor3 = Theme.Surface
    Card.BorderSizePixel = 0
    Round(Card, 8)
    
    local CardTitle = Instance.new("TextLabel")
    CardTitle.Size = UDim2.new(1, -20, 0, 28)
    CardTitle.Position = UDim2.new(0, 10, 0, 2)
    CardTitle.BackgroundTransparency = 1
    CardTitle.Text = title
    CardTitle.TextColor3 = Theme.Primary
    CardTitle.TextSize = 12
    CardTitle.Font = Enum.Font.GothamBold
    CardTitle.TextXAlignment = Enum.TextXAlignment.Left
    CardTitle.Parent = Card
    
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, -20, 0, 1)
    Divider.Position = UDim2.new(0, 10, 0, 28)
    Divider.BackgroundColor3 = Theme.SurfaceLight
    Divider.BorderSizePixel = 0
    Divider.Parent = Card
    
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -20, 0, 0)
    Container.Position = UDim2.new(0, 10, 0, 33)
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

local function CreateToggle(parent, text, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 32)
    Frame.BackgroundColor3 = Theme.SurfaceLight
    Round(Frame, 6)
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.TextSize = 11
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 40, 0, 20)
    Btn.Position = UDim2.new(1, -48, 0.5, -10)
    Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Btn.Text = ""
    Round(Btn, 10)
    Btn.Parent = Frame
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = UDim2.new(0, 2, 0.5, -8)
    Circle.BackgroundColor3 = Color3.new(1, 1, 1)
    Round(Circle, 8)
    Circle.Parent = Btn
    
    local enabled = false
    Btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        Tween(Btn, {BackgroundColor3 = enabled and Theme.Success or Color3.fromRGB(50, 50, 60)}, 0.2)
        Tween(Circle, {Position = UDim2.new(enabled and 1 or 0, enabled and -18 or 2, 0.5, -8)}, 0.2)
        if callback then callback(enabled) end
    end)
end

local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 45)
    Frame.BackgroundColor3 = Theme.SurfaceLight
    Round(Frame, 6)
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 4)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.TextSize = 11
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local Val = Instance.new("TextLabel")
    Val.Size = UDim2.new(0.3, 0, 0, 20)
    Val.Position = UDim2.new(0.7, -10, 0, 4)
    Val.BackgroundTransparency = 1
    Val.Text = tostring(default)
    Val.TextColor3 = Theme.Primary
    Val.TextSize = 11
    Val.Font = Enum.Font.GothamBold
    Val.TextXAlignment = Enum.TextXAlignment.Right
    Val.Parent = Frame
    
    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, -20, 0, 4)
    Track.Position = UDim2.new(0, 10, 0, 30)
    Track.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
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
    Knob.Position = UDim2.new(1, -6, 0.5, -6)
    Knob.BackgroundColor3 = Color3.new(1, 1, 1)
    Round(Knob, 6)
    Knob.Parent = Fill
    
    local dragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        Val.Text = tostring(val)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
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
end

-- ========== VIRTUAL FLY CONTROLLER (BARU) ==========
local FlyUI = Instance.new("Frame")
FlyUI.Name = "FlyController"
FlyUI.Size = UDim2.new(0, 180, 0, 200)
FlyUI.Position = UDim2.new(0.8, -100, 0.5, -100)
FlyUI.BackgroundColor3 = Theme.Background
FlyUI.BackgroundTransparency = 0.2
FlyUI.Visible = false
Round(FlyUI, 12)
AddStroke(FlyUI, Theme.Primary, 1)
FlyUI.Parent = ScreenGui
MakeDraggable(FlyUI, FlyUI)

local FlyTitle = Instance.new("TextLabel")
FlyTitle.Size = UDim2.new(1, 0, 0, 30)
FlyTitle.BackgroundTransparency = 1
FlyTitle.Text = "FLY CONTROLS"
FlyTitle.TextColor3 = Theme.Primary
FlyTitle.TextSize = 12
FlyTitle.Font = Enum.Font.GothamBold
FlyTitle.Parent = FlyUI

local function CreateVBtn(parent, text, pos, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = Theme.Surface
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Round(btn, 8)
    AddStroke(btn, Color3.fromRGB(60,60,70), 1)
    btn.Parent = parent

    btn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            FlyInputs[key] = 1
            Tween(btn, {BackgroundColor3 = Theme.Primary}, 0.1)
        end
    end)
    btn.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            FlyInputs[key] = 0
            Tween(btn, {BackgroundColor3 = Theme.Surface}, 0.1)
        end
    end)
end

-- D-Pad Position
CreateVBtn(FlyUI, "W", UDim2.new(0.5, -20, 0, 40), "F")
CreateVBtn(FlyUI, "S", UDim2.new(0.5, -20, 0, 130), "B")
CreateVBtn(FlyUI, "A", UDim2.new(0.5, -65, 0, 85), "L")
CreateVBtn(FlyUI, "D", UDim2.new(0.5, 25, 0, 85), "R")
CreateVBtn(FlyUI, "UP", UDim2.new(0, 10, 0, 40), "U")
CreateVBtn(FlyUI, "DN", UDim2.new(0, 10, 0, 130), "D")

-- ========== FEATURES ==========

-- Speed
local SpeedCard, SpeedCont = CreateCard("MOVEMENT")
SpeedCard.Parent = Content
CreateSlider(SpeedCont, "WalkSpeed", 16, 200, 16, function(val)
    Config.Speed = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)

-- Fly
local FlyCard, FlyCont = CreateCard("FLY CONTROL")
FlyCard.Parent = Content
CreateSlider(FlyCont, "Fly Speed", 10, 200, 50, function(val)
    Config.FlySpeed = val
end)

local FlyLoop
CreateToggle(FlyCont, "Enable Fly (Virtual UI)", function(enabled)
    Config.Flying = enabled
    FlyUI.Visible = enabled
    
    if enabled then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            local hum = char:FindFirstChild("Humanoid")
            if hum then hum.PlatformStand = true end

            FlyLoop = RunService.RenderStepped:Connect(function()
                if not Config.Flying then return end
                
                local camCFrame = Camera.CFrame
                local moveVector = Vector3.new(0,0,0)

                -- Keyboard Support
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then FlyInputs.F = 1 else if FlyInputs.F == 1 and not UserInputService:GetFocusedTextBox() then FlyInputs.F = 0 end end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then FlyInputs.B = 1 else if FlyInputs.B == 1 then FlyInputs.B = 0 end end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then FlyInputs.L = 1 else if FlyInputs.L == 1 then FlyInputs.L = 0 end end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then FlyInputs.R = 1 else if FlyInputs.R == 1 then FlyInputs.R = 0 end end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then FlyInputs.U = 1 else if FlyInputs.U == 1 then FlyInputs.U = 0 end end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then FlyInputs.D = 1 else if FlyInputs.D == 1 then FlyInputs.D = 0 end end

                -- Calculate direction
                if FlyInputs.F > 0 then moveVector = moveVector + camCFrame.LookVector end
                if FlyInputs.B > 0 then moveVector = moveVector - camCFrame.LookVector end
                if FlyInputs.L > 0 then moveVector = moveVector - camCFrame.RightVector end
                if FlyInputs.R > 0 then moveVector = moveVector + camCFrame.RightVector end
                if FlyInputs.U > 0 then moveVector = moveVector + Vector3.new(0, 1, 0) end
                if FlyInputs.D > 0 then moveVector = moveVector - Vector3.new(0, 1, 0) end

                -- Apply Velocity & CFrame
                hrp.Velocity = Vector3.new(0,0,0) -- Stabilizer
                if moveVector.Magnitude > 0 then
                    moveVector = moveVector.Unit
                    hrp.CFrame = hrp.CFrame + (moveVector * (Config.FlySpeed * 0.02))
                end
            end)
        end
    else
        if FlyLoop then FlyLoop:Disconnect() end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
    end
end)

-- Noclip & God Mode
local UtilCard, UtilCont = CreateCard("UTILITIES")
UtilCard.Parent = Content

local NoclipConn
CreateToggle(UtilCont, "Noclip", function(enabled)
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

CreateToggle(UtilCont, "God Mode (Auto-Heal)", function(enabled)
    Config.GodMode = enabled
    spawn(function()
        while Config.GodMode and wait(0.5) do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
            end
        end
    end)
end)

-- ========== WINDOW CONTROLS ==========
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

CloseBtn.MouseButton1Click:Connect(function()
    Tween(MainFrame, {Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, 1.5, 0)}, 0.3)
    if Config.Flying then FlyUI:Destroy() end
    wait(0.3)
    ScreenGui:Destroy()
end)

-- Intro Animation
MainFrame.Size = UDim2.new(0, 0, 0, 0)
wait(0.1)
Tween(MainFrame, {Size = UDim2.new(0, 320, 0, 420)}, 0.5, Enum.EasingStyle.Back)
