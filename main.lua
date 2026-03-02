--[[
    AP-NEXTGEN HUB
    Version: 2.0
    Features: Speed, Noclip, ESP, Teleport, Auto-Follow & More
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Config
local Config = {
    Speed = 16,
    DefaultSpeed = 16,
    Noclip = false,
    ESP = false,
    AutoFollow = false,
    FollowingPlayer = nil,
    GUIVisible = true
}

-- Create Main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "APNEXTGEN_HUB"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Modern Color Scheme
local Colors = {
    Background = Color3.fromRGB(15, 15, 20),
    Secondary = Color3.fromRGB(25, 25, 35),
    Accent = Color3.fromRGB(0, 170, 255),
    AccentDark = Color3.fromRGB(0, 120, 180),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 180),
    Success = Color3.fromRGB(0, 255, 100),
    Error = Color3.fromRGB(255, 50, 50),
    Warning = Color3.fromRGB(255, 170, 0)
}

-- Utility Functions
local function CreateTween(object, properties, duration, easingStyle, easingDirection)
    local tween = TweenService:Create(object, TweenInfo.new(duration or 0.3, easingStyle or Enum.EasingStyle.Quart, easingDirection or Enum.EasingDirection.Out), properties)
    tween:Play()
    return tween
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function CreateShadow(parent, size)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, size or 40, 1, size or 40)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Parent = parent
    return shadow
end

local function CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Colors.Accent
    stroke.Thickness = thickness or 1
    stroke.Parent = parent
    return stroke
end

-- Minimized Icon (When GUI is closed)
local MinimizeIcon = Instance.new("ImageButton")
MinimizeIcon.Name = "MinimizeIcon"
MinimizeIcon.Size = UDim2.new(0, 50, 0, 50)
MinimizeIcon.Position = UDim2.new(0, 20, 0.5, -25)
MinimizeIcon.BackgroundColor3 = Colors.Accent
MinimizeIcon.Image = "rbxassetid://3926305904" -- Menu icon
MinimizeIcon.ImageColor3 = Colors.Text
MinimizeIcon.Visible = false
MinimizeIcon.ZIndex = 100
CreateCorner(MinimizeIcon, 12)
CreateShadow(MinimizeIcon, 20)
MinimizeIcon.Parent = ScreenGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 550)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -275)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
CreateCorner(MainFrame, 12)
CreateShadow(MainFrame, 50)
CreateStroke(MainFrame, Color3.fromRGB(40, 40, 50), 2)
MainFrame.Parent = ScreenGui

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Colors.Secondary
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
CreateCorner(TopBar, 12)

-- Fix corner top only
local TopBarFix = Instance.new("Frame")
TopBarFix.Size = UDim2.new(1, 0, 0, 10)
TopBarFix.Position = UDim2.new(0, 0, 1, -10)
TopBarFix.BackgroundColor3 = Colors.Secondary
TopBarFix.BorderSizePixel = 0
TopBarFix.Parent = TopBar

-- Logo/Icon
local Logo = Instance.new("ImageLabel")
Logo.Name = "Logo"
Logo.Size = UDim2.new(0, 35, 0, 35)
Logo.Position = UDim2.new(0, 10, 0.5, -17.5)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://3926307971" -- Lightning icon
Logo.ImageColor3 = Colors.Accent
Logo.Parent = TopBar

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 55, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "AP-NEXTGEN"
Title.TextColor3 = Colors.Text
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local SubTitle = Instance.new("TextLabel")
SubTitle.Name = "SubTitle"
SubTitle.Size = UDim2.new(0, 200, 0, 15)
SubTitle.Position = UDim2.new(0, 55, 0.6, 0)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "PREMIUM HUB"
SubTitle.TextColor3 = Colors.Accent
SubTitle.TextSize = 10
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = TopBar

-- Control Buttons
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -75, 0.5, -15)
MinimizeBtn.BackgroundColor3 = Colors.Warning
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Colors.Text
MinimizeBtn.TextSize = 20
MinimizeBtn.Font = Enum.Font.GothamBold
CreateCorner(MinimizeBtn, 6)
MinimizeBtn.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
CloseBtn.BackgroundColor3 = Colors.Error
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Colors.Text
CloseBtn.TextSize = 20
CloseBtn.Font = Enum.Font.GothamBold
CreateCorner(CloseBtn, 6)
CloseBtn.Parent = TopBar

-- Content Container
local Content = Instance.new("ScrollingFrame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -20, 1, -70)
Content.Position = UDim2.new(0, 10, 0, 60)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4
Content.ScrollBarImageColor3 = Colors.Accent
Content.CanvasSize = UDim2.new(0, 0, 0, 800)
Content.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = Content

-- Utility: Create Section
local function CreateSection(title)
    local Section = Instance.new("Frame")
    Section.Name = title .. "Section"
    Section.Size = UDim2.new(1, 0, 0, 0)
    Section.AutomaticSize = Enum.AutomaticSize.Y
    Section.BackgroundColor3 = Colors.Secondary
    Section.BorderSizePixel = 0
    CreateCorner(Section, 8)
    Section.Parent = Content
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Size = UDim2.new(1, -20, 0, 30)
    SectionTitle.Position = UDim2.new(0, 10, 0, 5)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = "  " .. title
    SectionTitle.TextColor3 = Colors.Accent
    SectionTitle.TextSize = 14
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = Section
    
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, -20, 0, 1)
    Divider.Position = UDim2.new(0, 10, 0, 32)
    Divider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Divider.BorderSizePixel = 0
    Divider.Parent = Section
    
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -20, 0, 0)
    Container.Position = UDim2.new(0, 10, 0, 40)
    Container.AutomaticSize = Enum.AutomaticSize.Y
    Container.BackgroundTransparency = 1
    Container.Parent = Section
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.Parent = Container
    
    return Section, Container
end

-- Utility: Create Toggle
local function CreateToggle(parent, text, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Colors.Text
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 50, 0, 25)
    ToggleBtn.Position = UDim2.new(1, -50, 0.5, -12.5)
    ToggleBtn.BackgroundColor3 = default and Colors.Success or Color3.fromRGB(60, 60, 70)
    ToggleBtn.Text = default and "ON" or "OFF"
    ToggleBtn.TextColor3 = Colors.Text
    ToggleBtn.TextSize = 11
    ToggleBtn.Font = Enum.Font.GothamBold
    CreateCorner(ToggleBtn, 6)
    ToggleBtn.Parent = ToggleFrame
    
    local enabled = default
    
    ToggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        ToggleBtn.Text = enabled and "ON" or "OFF"
        CreateTween(ToggleBtn, {BackgroundColor3 = enabled and Colors.Success or Color3.fromRGB(60, 60, 70)}, 0.2)
        if callback then callback(enabled) end
    end)
    
    return ToggleBtn, function() return enabled end
end

-- Utility: Create Slider
local function CreateSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Colors.Text
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0.3, 0, 0, 20)
    ValueLabel.Position = UDim2.new(0.7, 0, 0, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Colors.Accent
    ValueLabel.TextSize = 13
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = SliderFrame
    
    local SliderBg = Instance.new("Frame")
    SliderBg.Size = UDim2.new(1, 0, 0, 8)
    SliderBg.Position = UDim2.new(0, 0, 0, 32)
    SliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    SliderBg.BorderSizePixel = 0
    CreateCorner(SliderBg, 4)
    SliderBg.Parent = SliderFrame
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Colors.Accent
    SliderFill.BorderSizePixel = 0
    CreateCorner(SliderFill, 4)
    SliderFill.Parent = SliderBg
    
    local SliderKnob = Instance.new("Frame")
    SliderKnob.Size = UDim2.new(0, 16, 0, 16)
    SliderKnob.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    SliderKnob.BackgroundColor3 = Colors.Text
    SliderKnob.BorderSizePixel = 0
    CreateCorner(SliderKnob, 8)
    SliderKnob.Parent = SliderBg
    
    local dragging = false
    
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * pos)
        
        ValueLabel.Text = tostring(value)
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        SliderKnob.Position = UDim2.new(pos, -8, 0.5, -8)
        
        if callback then callback(value) end
        return value
    end
    
    SliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    return SliderFrame
end

-- Utility: Create Dropdown
local function CreateDropdown(parent, text, callback)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Size = UDim2.new(1, 0, 0, 70)
    DropdownFrame.BackgroundTransparency = 1
    DropdownFrame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Colors.Text
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = DropdownFrame
    
    local DropdownBtn = Instance.new("TextButton")
    DropdownBtn.Size = UDim2.new(1, 0, 0, 35)
    DropdownBtn.Position = UDim2.new(0, 0, 0, 25)
    DropdownBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    DropdownBtn.Text = "Select Player..."
    DropdownBtn.TextColor3 = Colors.TextDark
    DropdownBtn.TextSize = 13
    DropdownBtn.Font = Enum.Font.Gotham
    CreateCorner(DropdownBtn, 6)
    DropdownBtn.Parent = DropdownFrame
    
    local Arrow = Instance.new("ImageLabel")
    Arrow.Size = UDim2.new(0, 20, 0, 20)
    Arrow.Position = UDim2.new(1, -25, 0.5, -10)
    Arrow.BackgroundTransparency = 1
    Arrow.Image = "rbxassetid://3926307971"
    Arrow.ImageColor3 = Colors.TextDark
    Arrow.Rotation = 90
    Arrow.Parent = DropdownBtn
    
    local PlayerList = Instance.new("ScrollingFrame")
    PlayerList.Size = UDim2.new(1, 0, 0, 0)
    PlayerList.Position = UDim2.new(0, 0, 1, 5)
    PlayerList.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    PlayerList.BorderSizePixel = 0
    PlayerList.ScrollBarThickness = 3
    PlayerList.ScrollBarImageColor3 = Colors.Accent
    PlayerList.Visible = false
    PlayerList.ZIndex = 10
    CreateCorner(PlayerList, 6)
    PlayerList.Parent = DropdownBtn
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 2)
    ListLayout.Parent = PlayerList
    
    local selectedPlayer = nil
    local isOpen = false
    
    local function updatePlayerList()
        for _, child in pairs(PlayerList:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        
        local count = 0
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -10, 0, 30)
                btn.Position = UDim2.new(0, 5, 0, 0)
                btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                btn.Text = player.Name
                btn.TextColor3 = Colors.Text
                btn.TextSize = 12
                btn.Font = Enum.Font.Gotham
                btn.ZIndex = 11
                CreateCorner(btn, 4)
                btn.Parent = PlayerList
                
                btn.MouseButton1Click:Connect(function()
                    selectedPlayer = player
                    DropdownBtn.Text = player.Name
                    DropdownBtn.TextColor3 = Colors.Accent
                    isOpen = false
                    PlayerList.Visible = false
                    Arrow.Rotation = 90
                    if callback then callback(player) end
                end)
                
                count = count + 1
            end
        end
        
        PlayerList.CanvasSize = UDim2.new(0, 0, 0, count * 32)
        PlayerList.Size = UDim2.new(1, 0, 0, math.min(count * 32, 150))
    end
    
    DropdownBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        PlayerList.Visible = isOpen
        Arrow.Rotation = isOpen and -90 or 90
        if isOpen then updatePlayerList() end
    end)
    
    Players.PlayerAdded:Connect(updatePlayerList)
    Players.PlayerRemoving:Connect(updatePlayerList)
    
    return DropdownFrame, function() return selectedPlayer end
end

-- Utility: Create Button
local function CreateButton(parent, text, color, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundColor3 = color or Colors.Accent
    Btn.Text = text
    Btn.TextColor3 = Colors.Text
    Btn.TextSize = 13
    Btn.Font = Enum.Font.GothamBold
    CreateCorner(Btn, 6)
    Btn.Parent = parent
    
    Btn.MouseEnter:Connect(function()
        CreateTween(Btn, {BackgroundColor3 = (color or Colors.Accent):Lerp(Color3.new(1,1,1), 0.2)}, 0.2)
    end)
    
    Btn.MouseLeave:Connect(function()
        CreateTween(Btn, {BackgroundColor3 = color or Colors.Accent}, 0.2)
    end)
    
    Btn.MouseButton1Click:Connect(function()
        CreateTween(Btn, {Size = UDim2.new(0.95, 0, 0, 33)}, 0.1)
        wait(0.1)
        CreateTween(Btn, {Size = UDim2.new(1, 0, 0, 35)}, 0.1)
        if callback then callback() end
    end)
    
    return Btn
end

-- ==================== FEATURES ====================

-- 1. SPEED SECTION
local SpeedSection, SpeedContainer = CreateSection("SPEED HACK")

CreateSlider(SpeedContainer, "WalkSpeed", 16, 500, 50, function(value)
    Config.Speed = value
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
end)

CreateButton(SpeedContainer, "Reset Speed", Colors.Error, function()
    Config.Speed = Config.DefaultSpeed
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.DefaultSpeed
    end
end)

-- 2. NOCLIP SECTION
local NoclipSection, NoclipContainer = CreateSection("NOCLIP")

local NoclipConnection = nil

CreateToggle(NoclipContainer, "Enable Noclip", false, function(enabled)
    Config.Noclip = enabled
    
    if enabled then
        NoclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
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

-- 3. ESP SECTION
local ESPSection, ESPContainer = CreateSection("ESP PLAYER")

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESP"
ESPFolder.Parent = CoreGui

local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local esp = Instance.new("BillboardGui")
    esp.Name = player.Name .. "_ESP"
    esp.AlwaysOnTop = true
    esp.Size = UDim2.new(0, 200, 0, 50)
    esp.StudsOffset = Vector3.new(0, 3, 0)
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 0.5
    frame.BackgroundColor3 = Colors.Accent
    frame.BorderSizePixel = 0
    frame.Parent = esp
    
    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1, 0, 0.5, 0)
    name.BackgroundTransparency = 1
    name.Text = player.Name
    name.TextColor3 = Colors.Text
    name.TextSize = 14
    name.Font = Enum.Font.GothamBold
    name.Parent = frame
    
    local dist = Instance.new("TextLabel")
    dist.Size = UDim2.new(1, 0, 0.5, 0)
    dist.Position = UDim2.new(0, 0, 0.5, 0)
    dist.BackgroundTransparency = 1
    dist.Text = "0 studs"
    dist.TextColor3 = Colors.TextDark
    dist.TextSize = 12
    dist.Font = Enum.Font.Gotham
    dist.Parent = frame
    
    esp.Parent = ESPFolder
    
    local connection = RunService.RenderStepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            esp.Adornee = player.Character.HumanoidRootPart
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            dist.Text = math.floor(distance) .. " studs"
        else
            esp.Enabled = false
        end
    end)
    
    return esp, connection
end

local ESPConnections = {}

CreateToggle(ESPContainer, "Enable ESP", false, function(enabled)
    Config.ESP = enabled
    
    if enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local esp, conn = CreateESP(player)
                ESPConnections[player] = conn
            end
        end
        
        Players.PlayerAdded:Connect(function(player)
            if Config.ESP then
                local esp, conn = CreateESP(player)
                ESPConnections[player] = conn
            end
        end)
    else
        ESPFolder:ClearAllChildren()
        for _, conn in pairs(ESPConnections) do
            conn:Disconnect()
        end
        ESPConnections = {}
    end
end)

-- 4. TELEPORT SECTION
local TPSection, TPContainer = CreateSection("TELEPORT")

local selectedTPPlayer = nil
local Dropdown, GetSelected = CreateDropdown(TPContainer, "Select Target", function(player)
    selectedTPPlayer = player
end)

CreateButton(TPContainer, "TELEPORT TO PLAYER", Colors.Success, function()
    if selectedTPPlayer and selectedTPPlayer.Character and selectedTPPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = selectedTPPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
        end
    end
end)

-- Auto Follow
CreateToggle(TPContainer, "Auto Follow Player", false, function(enabled)
    Config.AutoFollow = enabled
    
    if enabled then
        Config.FollowingPlayer = selectedTPPlayer
        spawn(function()
            while Config.AutoFollow and Config.FollowingPlayer do
                if Config.FollowingPlayer.Character and Config.FollowingPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, Config.FollowingPlayer.Character.HumanoidRootPart.Position)
                    LocalPlayer.Character.Humanoid:MoveTo(Config.FollowingPlayer.Character.HumanoidRootPart.Position)
                end
                wait(0.1)
            end
        end)
    else
        Config.FollowingPlayer = nil
    end
end)

-- 5. EXTRA FEATURES
local ExtraSection, ExtraContainer = CreateSection("EXTRA FEATURES")

-- Infinite Jump
local InfiniteJump = false
CreateToggle(ExtraContainer, "Infinite Jump", false, function(enabled)
    InfiniteJump = enabled
end)

UserInputService.JumpRequest:Connect(function()
    if InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Fly (Simple)
local Flying = false
local FlyConnection = nil

CreateToggle(ExtraContainer, "Fly Mode", false, function(enabled)
    Flying = enabled
    
    if enabled then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart
            local humanoid = character:FindFirstChild("Humanoid")
            
            FlyConnection = RunService.RenderStepped:Connect(function()
                if not Flying then return end
                
                local direction = Vector3.new(0, 0, 0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then direction = direction - Vector3.new(0, 1, 0) end
                
                hrp.Velocity = direction * Config.Speed
                if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Physics) end
            end)
        end
    else
        if FlyConnection then FlyConnection:Disconnect() end
    end
end)

-- God Mode (Semi)
CreateButton(ExtraContainer, "Full Heal", Colors.Warning, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
    end
end)

-- Rejoin Server
CreateButton(ExtraContainer, "Rejoin Server", Colors.Error, function()
    local TeleportService = game:GetService("TeleportService")
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

-- ==================== GUI CONTROLS ====================

-- Drag Functionality
local dragging = false
local dragStart = nil
local startPos = nil

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

-- Minimize Function
local function MinimizeGUI()
    Config.GUIVisible = false
    CreateTween(MainFrame, {Size = UDim2.new(0, 450, 0, 0)}, 0.3)
    wait(0.3)
    MainFrame.Visible = false
    MinimizeIcon.Visible = true
    CreateTween(MinimizeIcon, {Size = UDim2.new(0, 50, 0, 50)}, 0.3)
end

local function MaximizeGUI()
    Config.GUIVisible = true
    MinimizeIcon.Visible = false
    MainFrame.Visible = true
    CreateTween(MainFrame, {Size = UDim2.new(0, 450, 0, 550)}, 0.3)
end

MinimizeBtn.MouseButton1Click:Connect(MinimizeGUI)
MinimizeIcon.MouseButton1Click:Connect(MaximizeGUI)

-- Close Function
CloseBtn.MouseButton1Click:Connect(function()
    CreateTween(MainFrame, {Position = UDim2.new(0.5, -225, 1, 0)}, 0.3)
    wait(0.3)
    ScreenGui:Destroy()
    -- Cleanup connections
    if NoclipConnection then NoclipConnection:Disconnect() end
    if FlyConnection then FlyConnection:Disconnect() end
    for _, conn in pairs(ESPConnections) do conn:Disconnect() end
end)

-- Intro Animation
MainFrame.Size = UDim2.new(0, 0, 0, 0)
CreateTween(MainFrame, {Size = UDim2.new(0, 450, 0, 550)}, 0.5, Enum.EasingStyle.Back)

print("AP-NEXTGEN HUB Loaded Successfully!")
print("Features: Speed, Noclip, ESP, Teleport, Auto-Follow, Fly, Infinite Jump")
