--[[
    AP-NEXTGEN HUB v5.1 STABLE
    Crash Fixed | Deep ESP Auto-Scan | All Features Preserved
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
    CoinVisual = 0
}

-- State
local States = {
    FollowingPlayer = nil,
    ESPPlayerFolder = nil,
    ESPItemFolder = nil,
    NoclipConnection = nil,
    GodConnection = nil,
    FlyConnection = nil,
    BrightnessConnection = nil,
    PlayerESPConnection = nil,
    ItemESPConnection = nil,
    Connections = {}
}

-- Cleanup function
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
    getgenv().APNEXTGEN_LOADED = nil
end

-- Theme
local Theme = {
    Background = Color3.fromRGB(10, 10, 15),
    Surface = Color3.fromRGB(20, 20, 28),
    SurfaceLight = Color3.fromRGB(30, 30, 40),
    Primary = Color3.fromRGB(0, 200, 255),
    Secondary = Color3.fromRGB(140, 80, 255),
    Success = Color3.fromRGB(0, 255, 130),
    Error = Color3.fromRGB(255, 60, 80),
    Text = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(160, 160, 180)
}

-- Utility
local function Tween(obj, props, dur)
    TweenService:Create(obj, TweenInfo.new(dur or 0.3, Enum.EasingStyle.Quart), props):Play()
end

local function Round(parent, rad)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, rad or 8)
    c.Parent = parent
    return c
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "APNEXTGEN"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Minimized Orb
local OrbButton = Instance.new("TextButton")
OrbButton.Size = UDim2.new(0, 50, 0, 50)
OrbButton.Position = UDim2.new(0, 15, 0.5, -25)
OrbButton.BackgroundColor3 = Theme.Surface
OrbButton.Text = "G1"
OrbButton.TextColor3 = Theme.Primary
OrbButton.TextSize = 20
OrbButton.Font = Enum.Font.GothamBlack
OrbButton.Visible = false
OrbButton.ZIndex = 100
Round(OrbButton, 25)

local OrbStroke = Instance.new("UIStroke")
OrbStroke.Color = Theme.Primary
OrbStroke.Thickness = 2
OrbStroke.Parent = OrbButton

OrbButton.Parent = ScreenGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Round(MainFrame, 15)
MainFrame.Parent = ScreenGui

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Theme.Surface
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
Round(TopBar, 15)

local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 15)
TopFix.Position = UDim2.new(0, 0, 1, -15)
TopFix.BackgroundColor3 = Theme.Surface
TopFix.BorderSizePixel = 0
TopFix.Parent = TopBar

-- Title
local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0, 200, 0, 25)
TitleText.Position = UDim2.new(0, 15, 0, 5)
TitleText.BackgroundTransparency = 1
TitleText.Text = "AP-NEXTGEN"
TitleText.TextColor3 = Theme.Text
TitleText.TextSize = 16
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TopBar

local SubText = Instance.new("TextLabel")
SubText.Size = UDim2.new(0, 200, 0, 15)
SubText.Position = UDim2.new(0, 15, 0, 25)
SubText.BackgroundTransparency = 1
SubText.Text = "ULTIMATE v5.1"
SubText.TextColor3 = Theme.Primary
SubText.TextSize = 10
SubText.Font = Enum.Font.Gotham
SubText.TextXAlignment = Enum.TextXAlignment.Left
SubText.Parent = TopBar

-- Controls
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -65, 0.5, -14)
MinBtn.BackgroundColor3 = Theme.SurfaceLight
MinBtn.Text = "−"
MinBtn.TextColor3 = Theme.TextMuted
MinBtn.TextSize = 20
MinBtn.Font = Enum.Font.GothamBold
Round(MinBtn, 6)
MinBtn.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -14)
CloseBtn.BackgroundColor3 = Theme.Error
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 20
CloseBtn.Font = Enum.Font.GothamBold
Round(CloseBtn, 6)
CloseBtn.Parent = TopBar

-- Scrollable Content
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -60)
Content.Position = UDim2.new(0, 10, 0, 55)
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
    CardTitle.Position = UDim2.new(0, 10, 0, 5)
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
    Line.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
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
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.TextSize = 12
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 48, 0, 24)
    Btn.Position = UDim2.new(1, -48, 0.5, -12)
    Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
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
        Tween(Btn, {BackgroundColor3 = enabled and Theme.Success or Color3.fromRGB(60, 60, 70)}, 0.2)
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

-- ========== DEEP ESP SYSTEM ==========

-- Player ESP with Auto-Scan
States.ESPPlayerFolder = Instance.new("Folder")
States.ESPPlayerFolder.Name = "ESP_Players"
States.ESPPlayerFolder.Parent = CoreGui

local function CreatePlayerESP(player)
    if player == LocalPlayer then return end
    if States.ESPPlayerFolder:FindFirstChild(player.Name .. "_ESP") then return end
    
    local esp = Instance.new("BillboardGui")
    esp.Name = player.Name .. "_ESP"
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
    name.Text = player.Name
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
    
    -- Update distance
    spawn(function()
        while esp.Parent and Config.ESPPlayers do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                esp.Adornee = player.Character.HumanoidRootPart
                local d = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
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

-- Item/Mission ESP with Deep Scan
States.ESPItemFolder = Instance.new("Folder")
States.ESPItemFolder.Name = "ESP_Items"
States.ESPItemFolder.Parent = CoreGui

local ItemNames = {"Coin", "Money", "Cash", "Gem", "Mission", "Quest", "Item", "Collectible", "Token", "Star", "Chest", "Reward", "Objective", "Target", "Collect", "Pickup"}

local function IsMissionItem(obj)
    local name = obj.Name:lower()
    for _, keyword in pairs(ItemNames) do
        if name:find(keyword:lower()) then return true end
    end
    return false
end

local function CreateItemESP(obj)
    if States.ESPItemFolder:FindFirstChild(obj.Name .. "_" .. obj:GetFullName():gsub("%.", "_")) then return end
    
    local esp = Instance.new("BillboardGui")
    esp.Name = obj.Name .. "_" .. obj:GetFullName():gsub("%.", "_")
    esp.AlwaysOnTop = true
    esp.Size = UDim2.new(0, 120, 0, 40)
    esp.StudsOffset = Vector3.new(0, 1, 0)
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Theme.Warning
    bg.BackgroundTransparency = 0.5
    Round(bg, 6)
    bg.Parent = esp
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = obj.Name
    txt.TextColor3 = Color3.new(1, 1, 1)
    txt.TextSize = 12
    txt.Font = Enum.Font.GothamBold
    txt.Parent = bg
    
    esp.Parent = States.ESPItemFolder
    
    spawn(function()
        while esp.Parent and Config.ESPItems do
            if obj.Parent then
                if obj:IsA("BasePart") then
                    esp.Adornee = obj
                elseif obj:FindFirstChildWhichIsA("BasePart") then
                    esp.Adornee = obj:FindFirstChildWhichIsA("BasePart")
                else
                    esp.Enabled = false
                end
                esp.Enabled = true
            else
                esp:Destroy()
                break
            end
            wait(0.5)
        end
        if esp.Parent then esp:Destroy() end
    end)
end

-- Deep Scanner
local function DeepScanItems()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") or obj:IsA("MeshPart") then
            if IsMissionItem(obj) then
                CreateItemESP(obj)
            end
        end
    end
end

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

-- Fly
local FlyCard = CreateCard("FLY CONTROL")
CreateSlider(FlyCard, "Fly Speed", 10, 300, 100, function(val)
    Config.FlySpeed = val
end)

CreateToggle(FlyCard, "Enable Fly (Use Joystick)", function(enabled)
    Config.Flying = enabled
    
    if enabled then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.PlatformStand = true
        end
        
        States.FlyConnection = RunService.Heartbeat:Connect(function()
            if not Config.Flying then return end
            if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
            
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            
            if humanoid then
                local moveDir = humanoid.MoveDirection
                if moveDir.Magnitude > 0 then
                    local cam = Camera.CFrame
                    local velocity = (cam.RightVector * moveDir.X + cam.LookVector * moveDir.Z) * Config.FlySpeed
                    hrp.Velocity = Vector3.new(velocity.X, hrp.Velocity.Y, velocity.Z)
                end
                
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, Config.FlySpeed, hrp.Velocity.Z)
                elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, -Config.FlySpeed, hrp.Velocity.Z)
                end
            end
        end)
    else
        if States.FlyConnection then States.FlyConnection:Disconnect() end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.PlatformStand = false
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
end)

CreateToggle(FlyCard, "Noclip", function(enabled)
    Config.Noclip = enabled
    if enabled then
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

-- ESP Players (Auto-Scan)
local ESPCard = CreateCard("ESP SYSTEM")

CreateToggle(ESPCard, "ESP Players (Auto-Detect)", function(enabled)
    Config.ESPPlayers = enabled
    
    if enabled then
        -- Initial scan
        for _, p in pairs(Players:GetPlayers()) do
            CreatePlayerESP(p)
        end
        
        -- Auto-detect new players
        States.PlayerESPConnection = Players.PlayerAdded:Connect(function(player)
            if Config.ESPPlayers then
                wait(1) -- Wait for character to load
                CreatePlayerESP(player)
            end
        end)
        
        -- Deep scan loop
        spawn(function()
            while Config.ESPPlayers do
                for _, p in pairs(Players:GetPlayers()) do
                    CreatePlayerESP(p)
                end
                wait(2)
            end
        end)
    else
        if States.PlayerESPConnection then States.PlayerESPConnection:Disconnect() end
        States.ESPPlayerFolder:ClearAllChildren()
    end
end)

CreateToggle(ESPCard, "ESP Items/Missions (Deep Scan)", function(enabled)
    Config.ESPItems = enabled
    
    if enabled then
        DeepScanItems()
        
        -- Continuous deep scan
        spawn(function()
            while Config.ESPItems do
                DeepScanItems()
                wait(3)
            end
        end)
        
        -- Detect new items
        States.ItemESPConnection = workspace.DescendantAdded:Connect(function(obj)
            if Config.ESPItems and IsMissionItem(obj) then
                wait(0.5)
                CreateItemESP(obj)
            end
        end)
    else
        if States.ItemESPConnection then States.ItemESPConnection:Disconnect() end
        States.ESPItemFolder:ClearAllChildren()
    end
end)

-- Teleport
local TPCard = CreateCard("TELEPORT")

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(1, 0, 0, 100)
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
            btn.Size = UDim2.new(1, -8, 0, 30)
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
    
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, (#Players:GetPlayers() - 1) * 34)
end

UpdatePlayerList()
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)

CreateButton(TPCard, "Teleport to Player", "primary", function()
    if SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame
    end
end)

CreateToggle(TPCard, "Follow Player (Exact Position)", function(enabled)
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
GodTypeBtn.Size = UDim2.new(1, 0, 0, 30)
GodTypeBtn.BackgroundColor3 = Theme.SurfaceLight
GodTypeBtn.Text = "Mode: Gen1 (Auto Heal)"
GodTypeBtn.TextColor3 = Theme.Text
GodTypeBtn.TextSize = 12
GodTypeBtn.Font = Enum.Font.GothamBold
Round(GodTypeBtn, 6)
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
        for _, v in pairs(workspace:GetDescendants()) do
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
    Tween(MainFrame, {Size = UDim2.new(0, 350, 0, 0)}, 0.3)
    wait(0.3)
    MainFrame.Visible = false
    OrbButton.Visible = true
    Tween(OrbButton, {Size = UDim2.new(0, 50, 0, 50)}, 0.3)
end)

OrbButton.MouseButton1Click:Connect(function()
    OrbButton.Visible = false
    MainFrame.Visible = true
    Tween(MainFrame, {Size = UDim2.new(0, 350, 0, 450)}, 0.3)
end)

-- Close (FIXED)
CloseBtn.MouseButton1Click:Connect(function()
    Cleanup()
    
    Tween(MainFrame, {Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, 1.5, 0)}, 0.4)
    wait(0.4)
    
    ScreenGui:Destroy()
end)

-- Intro
MainFrame.Size = UDim2.new(0, 0, 0, 0)
wait(0.1)
Tween(MainFrame, {Size = UDim2.new(0, 350, 0, 450)}, 0.5, Enum.EasingStyle.Back)

print("✅ AP-NEXTGEN v5.1 Loaded | All Features Working | Deep ESP Active")
