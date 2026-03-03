--[[
    AP-NEXTGEN HUB v6.0 MASTER
    Complete Features | Admin Mode | Perfect Fly | Smooth Opening
    Password: GEN1GO (Hidden)
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
    AutoFollow = false,
    AutoHeal = false,
    FullBright = false,
    AntiAFK = false,
    FPSBoost = false,
    CoinVisual = 0,
    IsAdmin = false
}

-- State
local States = {
    FollowingPlayer = nil,
    ESPPlayerFolder = nil,
    ESPItemFolder = nil,
    AdminESPFolder = nil,
    NoclipConnection = nil,
    GodConnection = nil,
    FlyConnection = nil,
    BrightnessConnection = nil,
    PlayerESPConnection = nil,
    ItemESPConnection = nil,
    Connections = {}
}

-- Theme
local Theme = {
    Background = Color3.fromRGB(15, 15, 20),
    Surface = Color3.fromRGB(25, 25, 35),
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

-- Cleanup
local function Cleanup()
    for _, conn in pairs(States.Connections) do
        if conn then conn:Disconnect() end
    end
    if States.NoclipConnection then States.NoclipConnection:Disconnect() end
    if States.GodConnection then States.GodConnection:Disconnect() end
    if States.FlyConnection then States.FlyConnection:Disconnect() end
    if States.BrightnessConnection then States.BrightnessConnection:Disconnect() end
    if States.PlayerESPConnection then States.PlayerESPConnection:Disconnect() end
    if States.ItemESPConnection then States.ItemESPConnection:Disconnect() end
    if States.ESPPlayerFolder then States.ESPPlayerFolder:Destroy() end
    if States.ESPItemFolder then States.ESPItemFolder:Destroy() end
    if States.AdminESPFolder then States.AdminESPFolder:Destroy() end
    getgenv().APNEXTGEN_LOADED = nil
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "APNEXTGEN_MASTER"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ========== SMOOTH OPENING ANIMATION ==========
local IntroGui = Instance.new("ScreenGui")
IntroGui.Name = "Intro"
IntroGui.Parent = CoreGui
IntroGui.DisplayOrder = 10000

local IntroFrame = Instance.new("Frame")
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
IntroFrame.BorderSizePixel = 0
IntroFrame.Parent = IntroGui

-- Modern Gray Gradient
local IntroGradient = Instance.new("UIGradient")
IntroGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 35)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(45, 45, 55)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 35))
})
IntroGradient.Rotation = 45
IntroGradient.Parent = IntroFrame

-- Animated gradient
spawn(function()
    while IntroFrame.Parent do
        IntroGradient.Rotation = IntroGradient.Rotation + 0.3
        wait(0.05)
    end
end)

-- Floating particles
for i = 1, 15 do
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, math.random(3, 8), 0, math.random(3, 8))
    particle.Position = UDim2.new(math.random(), 0, 1.2, 0)
    particle.BackgroundColor3 = Theme.Primary
    particle.BackgroundTransparency = math.random(0.4, 0.8)
    particle.BorderSizePixel = 0
    Round(particle, 10)
    particle.Parent = IntroFrame
    
    spawn(function()
        while particle.Parent do
            local duration = math.random(4, 8)
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

-- Main Title Container
local TitleContainer = Instance.new("Frame")
TitleContainer.Size = UDim2.new(0, 700, 0, 200)
TitleContainer.Position = UDim2.new(0.5, -350, 0.4, -100)
TitleContainer.BackgroundTransparency = 1
TitleContainer.Parent = IntroFrame

-- Glow behind text
local TextGlow = Instance.new("ImageLabel")
TextGlow.Size = UDim2.new(1.3, 0, 1.3, 0)
TextGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
TextGlow.AnchorPoint = Vector2.new(0.5, 0.5)
TextGlow.BackgroundTransparency = 1
TextGlow.Image = "rbxassetid://6015897843"
TextGlow.ImageColor3 = Theme.Primary
TextGlow.ImageTransparency = 0.85
TextGlow.ScaleType = Enum.ScaleType.Slice
TextGlow.SliceCenter = Rect.new(49, 49, 450, 450)
TextGlow.Parent = TitleContainer

-- Main Title
local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(1, 0, 0.7, 0)
MainTitle.BackgroundTransparency = 1
MainTitle.Text = ""
MainTitle.TextColor3 = Theme.Primary
MainTitle.TextSize = 64
MainTitle.Font = Enum.Font.GothamBlack
MainTitle.TextStrokeTransparency = 0.9
MainTitle.TextStrokeColor3 = Color3.new(0, 0, 0)
MainTitle.Parent = TitleContainer

-- Subtitle
local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, 0, 0.3, 0)
SubTitle.Position = UDim2.new(0, 0, 0.7, 0)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = ""
SubTitle.TextColor3 = Theme.TextMuted
SubTitle.TextSize = 22
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextStrokeTransparency = 0.95
SubTitle.TextStrokeColor3 = Color3.new(0, 0, 0)
SubTitle.Parent = TitleContainer

-- Loading bar
local LoadBg = Instance.new("Frame")
LoadBg.Size = UDim2.new(0, 450, 0, 4)
LoadBg.Position = UDim2.new(0.5, -225, 0.65, 0)
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

local LoadShine = Instance.new("Frame")
LoadShine.Size = UDim2.new(0.3, 0, 1, 0)
LoadShine.Position = UDim2.new(0, 0, 0, 0)
LoadShine.BackgroundColor3 = Color3.new(1, 1, 1)
LoadShine.BackgroundTransparency = 0.8
LoadShine.BorderSizePixel = 0
LoadShine.Parent = LoadBar

-- Version
local VersionText = Instance.new("TextLabel")
VersionText.Size = UDim2.new(1, 0, 0, 20)
VersionText.Position = UDim2.new(0, 0, 0.9, 0)
VersionText.BackgroundTransparency = 1
VersionText.Text = "MASTER EDITION v6.0"
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

-- Opening sequence
spawn(function()
    wait(0.5)
    
    -- Pulse glow
    spawn(function()
        while TextGlow.Parent do
            Tween(TextGlow, {ImageTransparency = 0.8}, 1.5)
            wait(1.5)
            Tween(TextGlow, {ImageTransparency = 0.9}, 1.5)
            wait(1.5)
        end
    end)
    
    -- Shine animation
    spawn(function()
        while LoadShine.Parent do
            Tween(LoadShine, {Position = UDim2.new(1, 0, 0, 0)}, 0.8)
            wait(0.8)
            LoadShine.Position = UDim2.new(-0.3, 0, 0, 0)
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
    
    Tween(LoadBar, {Size = UDim2.new(1, 0, 1, 0)}, 2, Enum.EasingStyle.Quart)
    wait(2.2)
    
    -- Fade out
    Tween(IntroFrame, {BackgroundTransparency = 1}, 0.8)
    Tween(MainTitle, {TextTransparency = 1, TextStrokeTransparency = 1}, 0.6)
    Tween(SubTitle, {TextTransparency = 1, TextStrokeTransparency = 1}, 0.6)
    Tween(LoadBg, {BackgroundTransparency = 1}, 0.5)
    Tween(LoadBar, {BackgroundTransparency = 1}, 0.5)
    Tween(TextGlow, {ImageTransparency = 1}, 0.5)
    
    wait(0.8)
    IntroGui:Destroy()
end)

wait(3.5)

-- ========== DRAGGABLE ORB BUTTON ==========
local OrbButton = Instance.new("TextButton")
OrbButton.Name = "Orb"
OrbButton.Size = UDim2.new(0, 60, 0, 60)
OrbButton.Position = UDim2.new(0, 20, 0.5, -30)
OrbButton.BackgroundColor3 = Theme.Surface
OrbButton.Text = ""
OrbButton.Visible = false
OrbButton.ZIndex = 100
OrbButton.Active = true
OrbButton.Draggable = true
Round(OrbButton, 30)

-- Orb gradient
local OrbGradient = Instance.new("UIGradient")
OrbGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.Primary),
    ColorSequenceKeypoint.new(1, Theme.Secondary)
})
OrbGradient.Rotation = 45
OrbGradient.Parent = OrbButton

-- Orb stroke
local OrbStroke = Instance.new("UIStroke")
OrbStroke.Color = Theme.Primary
OrbStroke.Thickness = 3
OrbStroke.Parent = OrbButton

-- Perfect G1 Logo
local OrbIcon = Instance.new("TextLabel")
OrbIcon.Size = UDim2.new(1, 0, 1, 0)
OrbIcon.BackgroundTransparency = 1
OrbIcon.Text = "G1"
OrbIcon.TextColor3 = Color3.new(1, 1, 1)
OrbIcon.TextSize = 26
OrbIcon.Font = Enum.Font.GothamBlack
OrbIcon.ZIndex = 101
OrbIcon.Parent = OrbButton

-- Glow
local OrbGlow = Instance.new("ImageLabel")
OrbGlow.Size = UDim2.new(1.6, 0, 1.6, 0)
OrbGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
OrbGlow.AnchorPoint = Vector2.new(0.5, 0.5)
OrbGlow.BackgroundTransparency = 1
OrbGlow.Image = "rbxassetid://6015897843"
OrbGlow.ImageColor3 = Theme.Primary
OrbGlow.ImageTransparency = 0.7
OrbGlow.ScaleType = Enum.ScaleType.Slice
OrbGlow.SliceCenter = Rect.new(49, 49, 450, 450)
OrbGlow.ZIndex = 99
OrbGlow.Parent = OrbButton

Shadow(OrbButton, 30)
OrbButton.Parent = ScreenGui

-- ========== FLY CONTROL PANEL (DRAGGABLE) ==========
local FlyGui = Instance.new("ScreenGui")
FlyGui.Name = "FlyPanel"
FlyGui.Parent = CoreGui
FlyGui.Enabled = false

local FlyPanel = Instance.new("Frame")
FlyPanel.Name = "FlyControl"
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

Shadow(FlyPanel, 40)

-- Title
local FlyTitle = Instance.new("TextLabel")
FlyTitle.Size = UDim2.new(1, 0, 0, 40)
FlyTitle.BackgroundTransparency = 1
FlyTitle.Text = "✈️ FLY CONTROL"
FlyTitle.TextColor3 = Theme.Primary
FlyTitle.TextSize = 16
FlyTitle.Font = Enum.Font.GothamBlack
FlyTitle.Parent = FlyPanel

-- Close button
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

-- Speed slider
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
FlySpeedFill.Size = UDim2.new(0.3, 0, 1, 0)
FlySpeedFill.BackgroundColor3 = Theme.Primary
FlySpeedFill.BorderSizePixel = 0
Round(FlySpeedFill, 3)
FlySpeedFill.Parent = FlySpeedTrack

local FlySpeedKnob = Instance.new("Frame")
FlySpeedKnob.Size = UDim2.new(0, 16, 0, 16)
FlySpeedKnob.Position = UDim2.new(0.3, -8, 0.5, -8)
FlySpeedKnob.BackgroundColor3 = Color3.new(1, 1, 1)
Round(FlySpeedKnob, 8)
FlySpeedKnob.Parent = FlySpeedTrack

local flySpeedDragging = false
FlySpeedTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        flySpeedDragging = true
        local pos = math.clamp((input.Position.X - FlySpeedTrack.AbsolutePosition.X) / FlySpeedTrack.AbsoluteSize.X, 0, 1)
        local val = math.floor(10 + 290 * pos)
        Config.FlySpeed = val
        FlySpeedLabel.Text = "Speed: " .. val
        FlySpeedFill.Size = UDim2.new(pos, 0, 1, 0)
        FlySpeedKnob.Position = UDim2.new(pos, -8, 0.5, -8)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if flySpeedDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local pos = math.clamp((input.Position.X - FlySpeedTrack.AbsolutePosition.X) / FlySpeedTrack.AbsoluteSize.X, 0, 1)
        local val = math.floor(10 + 290 * pos)
        Config.FlySpeed = val
        FlySpeedLabel.Text = "Speed: " .. val
        FlySpeedFill.Size = UDim2.new(pos, 0, 1, 0)
        FlySpeedKnob.Position = UDim2.new(pos, -8, 0.5, -8)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    flySpeedDragging = false
end)

-- Toggle buttons
local FlyToggleBtn = Instance.new("TextButton")
FlyToggleBtn.Size = UDim2.new(1, -20, 0, 40)
FlyToggleBtn.Position = UDim2.new(0, 10, 0, 90)
FlyToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
FlyToggleBtn.Text = "FLY: OFF"
FlyToggleBtn.TextColor3 = Theme.TextMuted
FlyToggleBtn.TextSize = 14
FlyToggleBtn.Font = Enum.Font.GothamBold
Round(FlyToggleBtn, 10)
FlyToggleBtn.Parent = FlyPanel

local NoclipToggleBtn = Instance.new("TextButton")
NoclipToggleBtn.Size = UDim2.new(1, -20, 0, 40)
NoclipToggleBtn.Position = UDim2.new(0, 10, 0, 140)
NoclipToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
NoclipToggleBtn.Text = "NOCLIP: OFF"
NoclipToggleBtn.TextColor3 = Theme.TextMuted
NoclipToggleBtn.TextSize = 14
NoclipToggleBtn.Font = Enum.Font.GothamBold
Round(NoclipToggleBtn, 10)
NoclipToggleBtn.Parent = FlyPanel

-- Instructions
local FlyInstr = Instance.new("TextLabel")
FlyInstr.Size = UDim2.new(1, -20, 0, 80)
FlyInstr.Position = UDim2.new(0, 10, 0, 190)
FlyInstr.BackgroundTransparency = 1
FlyInstr.Text = "Controls:\n• Joystick = Move\n• Space = Up\n• Shift = Down"
FlyInstr.TextColor3 = Theme.TextMuted
FlyInstr.TextSize = 11
FlyInstr.Font = Enum.Font.Gotham
FlyInstr.TextYAlignment = Enum.TextYAlignment.Top
FlyInstr.Parent = FlyPanel

FlyPanel.Parent = FlyGui

-- Fly toggle logic
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
                -- Get camera direction
                local cam = Camera.CFrame
                local moveDir = humanoid.MoveDirection
                
                -- Calculate velocity based on camera
                if moveDir.Magnitude > 0 then
                    -- Forward/Backward based on camera look vector
                    local lookVector = cam.LookVector
                    lookVector = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
                    
                    -- Right/Left based on camera right vector
                    local rightVector = cam.RightVector
                    
                    -- Combine directions
                    local velocity = (lookVector * moveDir.Z + rightVector * moveDir.X) * Config.FlySpeed
                    
                    -- Apply horizontal movement
                    hrp.Velocity = Vector3.new(velocity.X, hrp.Velocity.Y, velocity.Z)
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
                    -- Maintain vertical position when not pressing up/down
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
                end
            end
        end)
    else
        FlyToggleBtn.Text = "FLY: OFF"
        Tween(FlyToggleBtn, {BackgroundColor3 = Color3.fromRGB(60, 60, 70), TextColor3 = Theme.TextMuted}, 0.2)
        
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

-- Noclip toggle logic
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
        Tween(NoclipToggleBtn, {BackgroundColor3 = Color3.fromRGB(60, 60, 70), TextColor3 = Theme.TextMuted}, 0.2)
        
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

-- ========== MAIN GUI ==========
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 500)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -250)
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

-- Title
local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0, 200, 0, 25)
TitleText.Position = UDim2.new(0, 60, 0, 5)
TitleText.BackgroundTransparency = 1
TitleText.Text = "AP-NEXTGEN"
TitleText.TextColor3 = Theme.Text
TitleText.TextSize = 18
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TopBar

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 200, 0, 15)
SubTitle.Position = UDim2.new(0, 60, 0, 28)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "MASTER EDITION"
SubTitle.TextColor3 = Theme.Primary
SubTitle.TextSize = 11
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = TopBar

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

-- Scrollable Content
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -70)
Content.Position = UDim2.new(0, 10, 0, 65)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 6
Content.ScrollBarImageColor3 = Theme.Primary
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.ScrollingDirection = Enum.ScrollingDirection.Y
Content.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 12)
ListLayout.Parent = Content

-- Components
local function CreateCard(title)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 0)
    Card.AutomaticSize = Enum.AutomaticSize.Y
    Card.BackgroundColor3 = Theme.Surface
    Card.BackgroundTransparency = 0.2
    Card.BorderSizePixel = 0
    Round(Card, 15)
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(45, 45, 60)
    Stroke.Thickness = 1.5
    Stroke.Parent = Card
    
    local CardTitle = Instance.new("TextLabel")
    CardTitle.Size = UDim2.new(1, -20, 0, 32)
    CardTitle.Position = UDim2.new(0, 12, 0, 8)
    CardTitle.BackgroundTransparency = 1
    CardTitle.Text = title
    CardTitle.TextColor3 = Theme.Primary
    CardTitle.TextSize = 14
    CardTitle.Font = Enum.Font.GothamBold
    CardTitle.TextXAlignment = Enum.TextXAlignment.Left
    CardTitle.Parent = Card
    
    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(1, -24, 0, 1)
    Line.Position = UDim2.new(0, 12, 0, 38)
    Line.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
    Line.BorderSizePixel = 0
    Line.Parent = Card
    
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -24, 0, 0)
    Container.Position = UDim2.new(0, 12, 0, 42)
    Container.AutomaticSize = Enum.AutomaticSize.Y
    Container.BackgroundTransparency = 1
    Container.Parent = Card
    
    local ContList = Instance.new("UIListLayout")
    ContList.Padding = UDim.new(0, 10)
    ContList.Parent = Container
    
    local Pad = Instance.new("UIPadding")
    Pad.PaddingBottom = UDim.new(0, 15)
    Pad.Parent = Card
    
    Card.Parent = Content
    return Container
end

local function CreateToggle(parent, text, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 38)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 52, 0, 28)
    Btn.Position = UDim2.new(1, -52, 0.5, -14)
    Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    Btn.Text = "OFF"
    Btn.TextColor3 = Theme.TextMuted
    Btn.TextSize = 11
    Btn.Font = Enum.Font.GothamBold
    Round(Btn, 14)
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
    Btn.BackgroundColor3 = style == "primary" and Theme.Primary or (style == "admin" and Theme.Admin or Theme.SurfaceLight)
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

-- ========== ADMIN MODE SYSTEM ==========
local AdminGui = Instance.new("ScreenGui")
AdminGui.Name = "AdminPanel"
AdminGui.Parent = CoreGui
AdminGui.Enabled = false

local AdminPanel = Instance.new("Frame")
AdminPanel.Size = UDim2.new(0, 300, 0, 200)
AdminPanel.Position = UDim2.new(0.5, -150, 0.5, -100)
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
AdminTitle.TextSize = 20
AdminTitle.Font = Enum.Font.GothamBlack
AdminTitle.Parent = AdminPanel

local PasswordBox = Instance.new("TextBox")
PasswordBox.Size = UDim2.new(1, -40, 0, 45)
PasswordBox.Position = UDim2.new(0, 20, 0, 60)
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
SubmitBtn.Size = UDim2.new(1, -40, 0, 45)
SubmitBtn.Position = UDim2.new(0, 20, 0, 115)
SubmitBtn.BackgroundColor3 = Theme.Admin
SubmitBtn.Text = "UNLOCK"
SubmitBtn.TextColor3 = Color3.new(0, 0, 0)
SubmitBtn.TextSize = 16
SubmitBtn.Font = Enum.Font.GothamBlack
Round(SubmitBtn, 10)
SubmitBtn.Parent = AdminPanel

local CloseAdminBtn = Instance.new("TextButton")
CloseAdminBtn.Size = UDim2.new(0, 30, 0, 30)
CloseAdminBtn.Position = UDim2.new(1, -40, 0, 10)
CloseAdminBtn.BackgroundColor3 = Theme.Error
CloseAdminBtn.Text = "×"
CloseAdminBtn.TextColor3 = Color3.new(1, 1, 1)
CloseAdminBtn.TextSize = 20
CloseAdminBtn.Font = Enum.Font.GothamBold
Round(CloseAdminBtn, 8)
CloseAdminBtn.Parent = AdminPanel

AdminPanel.Parent = AdminGui

-- Admin Status GUI (Above Avatar)
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
AdminLabel.Text = "ADMIN/OWNER"
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

-- RGB Animation for Admin
spawn(function()
    while AdminStatusGui.Enabled do
        for i = 0, 1, 0.05 do
            AdminLabel.TextColor3 = Color3.fromHSV(i, 1, 1)
            wait(0.1)
        end
    end
end)

AdminStatusGui.Parent = CoreGui

-- Admin ESP System
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
    bg.BackgroundTransparency = 0.3
    Round(bg, 10)
    bg.Parent = esp
    
    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1, 0, 0.3, 0)
    name.BackgroundTransparency = 1
    name.Text = player.Name
    name.TextColor3 = Color3.new(1, 1, 1)
    name.TextSize = 14
    name.Font = Enum.Font.GothamBold
    name.Parent = bg
    
    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new(0.9, 0, 0, 6)
    healthBar.Position = UDim2.new(0.05, 0, 0.4, 0)
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
    healthText.Size = UDim2.new(1, 0, 0.25, 0)
    healthText.Position = UDim2.new(0, 0, 0.5, 0)
    healthText.BackgroundTransparency = 1
    healthText.Text = "HP: 100/100"
    healthText.TextColor3 = Theme.Text
    healthText.TextSize = 11
    healthText.Font = Enum.Font.Gotham
    healthText.Parent = bg
    
    local dist = Instance.new("TextLabel")
    dist.Size = UDim2.new(1, 0, 0.25, 0)
    dist.Position = UDim2.new(0, 0, 0.75, 0)
    dist.BackgroundTransparency = 1
    dist.Text = "0m | Team: None"
    dist.TextColor3 = Theme.TextMuted
    dist.TextSize = 10
    dist.Font = Enum.Font.Gotham
    dist.Parent = bg
    
    esp.Parent = States.AdminESPFolder
    
    -- Update loop
    spawn(function()
        while esp.Parent and Config.IsAdmin do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local humanoid = player.Character.Humanoid
                local d = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                
                esp.Adornee = player.Character.HumanoidRootPart
                healthFill.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)
                healthText.Text = string.format("HP: %d/%d", math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
                dist.Text = string.format("%dm | Team: %s", math.floor(d), tostring(player.Team or "None"))
                esp.Enabled = true
            else
                esp.Enabled = false
            end
            wait(0.2)
        end
        if esp.Parent then esp:Destroy() end
    end)
end

-- Admin verification
SubmitBtn.MouseButton1Click:Connect(function()
    if PasswordBox.Text == "GEN1GO" then
        Config.IsAdmin = true
        AdminGui.Enabled = false
        AdminPanel.Visible = false
        
        -- Show admin status
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
            AdminStatusGui.Adornee = LocalPlayer.Character.Head
            AdminStatusGui.Enabled = true
        end
        
        -- Enable admin ESP
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
            Text = "Access Granted! Welcome Developer.",
            Duration = 5
        })
    else
        PasswordBox.Text = ""
        PasswordBox.PlaceholderText = "WRONG PASSWORD!"
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
local MoveCard = CreateCard("MOVEMENT")
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

-- Fly Control (Opens Panel)
local FlyCard = CreateCard("FLY SYSTEM")
CreateButton(FlyCard, "✈️ Open Fly Control Panel", "primary", function()
    FlyGui.Enabled = true
    FlyPanel.Visible = true
    Tween(FlyPanel, {Size = UDim2.new(0, 200, 0, 280)}, 0.3)
end)

-- ESP
local ESPCard = CreateCard("ESP SYSTEM")
States.ESPPlayerFolder = Instance.new("Folder")
States.ESPPlayerFolder.Name = "ESP_Players"
States.ESPPlayerFolder.Parent = CoreGui

CreateToggle(ESPCard, "ESP Players", function(enabled)
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

-- Teleport
local TPCard = CreateCard("TELEPORT")

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(1, 0, 0, 120)
PlayerList.BackgroundColor3 = Theme.SurfaceLight
PlayerList.BackgroundTransparency = 0.3
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 4
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
Round(PlayerList, 8)
PlayerList.Parent = TPCard

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 4)
ListLayout.Parent = PlayerList

local SelectedPlayer = nil

local function UpdatePlayerList()
    for _, c in pairs(PlayerList:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -8, 0, 32)
            btn.Position = UDim2.new(0, 4, 0, 0)
            btn.BackgroundColor3 = SelectedPlayer == p and Theme.Primary or Theme.Surface
            btn.Text = p.Name
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
    
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, (#Players:GetPlayers() - 1) * 36)
end

UpdatePlayerList()
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)

CreateButton(TPCard, "Teleport to Player", "primary", function()
    if SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame
    end
end)

CreateToggle(TPCard, "Follow Player (Exact)", function(enabled)
    Config.AutoFollow = enabled
    if enabled then
        States.FollowingPlayer = SelectedPlayer
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
local GodCard = CreateCard("GOD MODE")

local GodTypeBtn = Instance.new("TextButton")
GodTypeBtn.Size = UDim2.new(1, 0, 0, 32)
GodTypeBtn.BackgroundColor3 = Theme.SurfaceLight
GodTypeBtn.Text = "Mode: Gen1 (Auto Heal)"
GodTypeBtn.TextColor3 = Theme.Text
GodTypeBtn.TextSize = 12
GodTypeBtn.Font = Enum.Font.GothamBold
Round(GodTypeBtn, 8)
GodTypeBtn.Parent = GodCard

GodTypeBtn.MouseButton1Click:Connect(function()
    Config.GodModeType = Config.GodModeType == "Gen1" and "Gen2" or "Gen1"
    GodTypeBtn.Text = Config.GodModeType == "Gen1" and "Mode: Gen1 (Auto Heal)" or "Mode: Gen2 (Super Immortal)"
end)

CreateToggle(GodCard, "Enable God Mode", function(enabled)
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

CreateButton(GodCard, "Heal Instantly", "primary", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
    end
end)

-- Utility
local UtilCard = CreateCard("UTILITY")

CreateToggle(UtilCard, "Full Brightness", function(enabled)
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
        Lighting.Brightness = 1
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

CreateSlider(UtilCard, "Visual Coin", 0, 1000, 0, function(val)
    Config.CoinVisual = val
end)

CreateToggle(UtilCard, "FPS Boost", function(enabled)
    Config.FPSBoost = enabled
    if enabled then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
                v.Material = Enum.Material.SmoothPlastic
            end
            if v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            end
        end
        settings().Rendering.QualityLevel = 1
    end
end)

-- Admin Access
local AdminCard = CreateCard("🔐 SPECIAL ACCESS")
CreateButton(AdminCard, "Enter Admin Mode", "admin", function()
    AdminGui.Enabled = true
    AdminPanel.Visible = true
    PasswordBox.Text = ""
end)

-- Server
local ServerCard = CreateCard("SERVER")
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
    Tween(OrbButton, {Size = UDim2.new(0, 60, 0, 60)}, 0.3)
end)

OrbButton.MouseButton1Click:Connect(function()
    OrbButton.Visible = false
    MainFrame.Visible = true
    Tween(MainFrame, {Size = UDim2.new(0, 380, 0, 500)}, 0.3)
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
Tween(MainFrame, {Size = UDim2.new(0, 380, 0, 500)}, 0.6, Enum.EasingStyle.Back)

print("✅ AP-NEXTGEN v6.0 MASTER Loaded!")
print("Features: Draggable Orb & Fly Panel | Admin Mode | Perfect Fly Controls")
