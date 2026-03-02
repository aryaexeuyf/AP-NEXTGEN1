--[[
    AP-NEXTGEN HUB v4.0 PRO EDITION
    - Scroll 100% Fixed (AbsoluteContentSize method)
    - Professional Tabbed UI
    - Virtual Fly Controller
    - Clean Transparent Opening
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

-- ==========================================
-- SETTINGS & THEMES
-- ==========================================
local Config = {
    Speed = 16,
    FlySpeed = 50,
    GodMode = false,
    Noclip = false,
    Flying = false,
    ESP = false
}

local FlyInputs = { W = 0, S = 0, A = 0, D = 0, UP = 0, DOWN = 0 }

local Theme = {
    MainBg = Color3.fromRGB(12, 12, 18),
    TabBg = Color3.fromRGB(18, 18, 25),
    SectionBg = Color3.fromRGB(22, 22, 30),
    Accent = Color3.fromRGB(0, 200, 255),
    AccentHover = Color3.fromRGB(50, 220, 255),
    Text = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(140, 140, 150),
    Border = Color3.fromRGB(35, 35, 45)
}

-- ==========================================
-- UTILITY FUNCTIONS
-- ==========================================
local function Tween(obj, props, time)
    local tw = TweenService:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    tw:Play()
    return tw
end

local function Round(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = obj
end

local function Stroke(obj, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Border
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = obj
end

local function MakeDraggable(dragPart, mainFrame)
    local dragging, dragInput, dragStart, startPos
    dragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    dragPart.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    dragPart.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- ==========================================
-- CREATE GUI INSTANCES
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AP_NEXTGEN_PRO"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.Parent = CoreGui

-- --- 1. OPENING ANIMATION ---
local IntroFrame = Instance.new("Frame")
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.BackgroundColor3 = Color3.new(0, 0, 0)
IntroFrame.BackgroundTransparency = 0.5 -- Transparan
IntroFrame.Parent = ScreenGui

local IntroLogo = Instance.new("ImageLabel")
IntroLogo.Size = UDim2.new(0, 80, 0, 80)
IntroLogo.Position = UDim2.new(0.5, -40, 0.4, -40)
IntroLogo.BackgroundTransparency = 1
IntroLogo.Image = "rbxassetid://13768404285" -- Cool Tech Icon
IntroLogo.ImageColor3 = Theme.Accent
IntroLogo.ImageTransparency = 1
IntroLogo.Parent = IntroFrame

local IntroTitle = Instance.new("TextLabel")
IntroTitle.Size = UDim2.new(0, 300, 0, 40)
IntroTitle.Position = UDim2.new(0.5, -150, 0.4, 50)
IntroTitle.BackgroundTransparency = 1
IntroTitle.Text = "AP-NEXTGEN PRO"
IntroTitle.TextColor3 = Theme.Text
IntroTitle.Font = Enum.Font.GothamBold
IntroTitle.TextSize = 28
IntroTitle.TextTransparency = 1
IntroTitle.Parent = IntroFrame

local IntroLine = Instance.new("Frame")
IntroLine.Size = UDim2.new(0, 0, 0, 2)
IntroLine.Position = UDim2.new(0.5, 0, 0.4, 95)
IntroLine.BackgroundColor3 = Theme.Accent
IntroLine.BorderSizePixel = 0
IntroLine.Parent = IntroFrame

spawn(function()
    Tween(IntroLogo, {ImageTransparency = 0}, 1)
    Tween(IntroTitle, {TextTransparency = 0}, 1)
    wait(0.5)
    Tween(IntroLine, {Size = UDim2.new(0, 200, 0, 2), Position = UDim2.new(0.5, -100, 0.4, 95)}, 0.8)
    wait(1.5)
    Tween(IntroLogo, {ImageTransparency = 1}, 0.5)
    Tween(IntroTitle, {TextTransparency = 1}, 0.5)
    Tween(IntroLine, {BackgroundTransparency = 1}, 0.5)
    Tween(IntroFrame, {BackgroundTransparency = 1}, 0.5)
    wait(0.5)
    IntroFrame:Destroy()
end)

wait(3) -- Tunggu animasi selesai

-- --- 2. MAIN WINDOW ---
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 320)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -160)
MainFrame.BackgroundColor3 = Theme.MainBg
MainFrame.BackgroundTransparency = 0.05
MainFrame.ClipsDescendants = true
Round(MainFrame, 8)
Stroke(MainFrame, Theme.Border, 1)
MainFrame.Parent = ScreenGui

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Theme.TabBg
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
MakeDraggable(TopBar, MainFrame)

local LogoImg = Instance.new("ImageLabel")
LogoImg.Size = UDim2.new(0, 20, 0, 20)
LogoImg.Position = UDim2.new(0, 10, 0.5, -10)
LogoImg.BackgroundTransparency = 1
LogoImg.Image = "rbxassetid://13768404285"
LogoImg.ImageColor3 = Theme.Accent
LogoImg.Parent = TopBar

local TitleTxt = Instance.new("TextLabel")
TitleTxt.Size = UDim2.new(0, 200, 1, 0)
TitleTxt.Position = UDim2.new(0, 38, 0, 0)
TitleTxt.BackgroundTransparency = 1
TitleTxt.Text = "AP-NEXTGEN | Professional"
TitleTxt.TextColor3 = Theme.Text
TitleTxt.Font = Enum.Font.GothamBold
TitleTxt.TextSize = 13
TitleTxt.TextXAlignment = Enum.TextXAlignment.Left
TitleTxt.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Theme.TextDark
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = TopBar

CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn, {TextColor3 = Color3.fromRGB(255, 50, 50)}, 0.2) end)
CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn, {TextColor3 = Theme.TextDark}, 0.2) end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Sidebar & Content Area
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -35)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.BackgroundColor3 = Theme.TabBg
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -130, 1, -35)
ContentContainer.Position = UDim2.new(0, 130, 0, 35)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local SidebarList = Instance.new("UIListLayout")
SidebarList.Padding = UDim.new(0, 2)
SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarList.Parent = Sidebar

local SidebarPad = Instance.new("UIPadding")
SidebarPad.PaddingTop = UDim.new(0, 10)
SidebarPad.Parent = Sidebar

-- ==========================================
-- UI LIBRARY SYSTEM
-- ==========================================
local Tabs = {}
local FirstTab = true

local function CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0.9, 0, 0, 30)
    TabBtn.BackgroundColor3 = Theme.SectionBg
    TabBtn.BackgroundTransparency = FirstTab and 0 or 1
    TabBtn.Text = name
    TabBtn.TextColor3 = FirstTab and Theme.Accent or Theme.TextDark
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 12
    Round(TabBtn, 6)
    TabBtn.Parent = Sidebar

    -- SCROLL FIX ADA DI SINI --
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.ScrollBarThickness = 2
    ScrollFrame.ScrollBarImageColor3 = Theme.Accent
    ScrollFrame.Visible = FirstTab
    ScrollFrame.Parent = ContentContainer

    local ScrollPad = Instance.new("UIPadding")
    ScrollPad.PaddingTop = UDim.new(0, 10)
    ScrollPad.PaddingLeft = UDim.new(0, 10)
    ScrollPad.PaddingRight = UDim.new(0, 10)
    ScrollPad.PaddingBottom = UDim.new(0, 10)
    ScrollPad.Parent = ScrollFrame

    local ScrollList = Instance.new("UIListLayout")
    ScrollList.Padding = UDim.new(0, 8)
    ScrollList.Parent = ScrollFrame

    -- Kunci utama perbaikan Scroll: Selalu hitung ulang CanvasSize saat ada elemen baru
    ScrollList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ScrollList.AbsoluteContentSize.Y + 20)
    end)

    Tabs[name] = {Btn = TabBtn, Scroll = ScrollFrame}

    TabBtn.MouseButton1Click:Connect(function()
        for tName, data in pairs(Tabs) do
            if tName == name then
                Tween(data.Btn, {BackgroundTransparency = 0, TextColor3 = Theme.Accent}, 0.2)
                data.Scroll.Visible = true
            else
                Tween(data.Btn, {BackgroundTransparency = 1, TextColor3 = Theme.TextDark}, 0.2)
                data.Scroll.Visible = false
            end
        end
    end)

    FirstTab = false
    return ScrollFrame
end

local function CreateToggle(parent, text, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 36)
    Frame.BackgroundColor3 = Theme.SectionBg
    Round(Frame, 6)
    Stroke(Frame, Theme.Border, 1)
    Frame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 36, 0, 18)
    Btn.Position = UDim2.new(1, -48, 0.5, -9)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Btn.Text = ""
    Round(Btn, 9)
    Btn.Parent = Frame

    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 14, 0, 14)
    Indicator.Position = UDim2.new(0, 2, 0.5, -7)
    Indicator.BackgroundColor3 = Color3.new(1, 1, 1)
    Round(Indicator, 7)
    Indicator.Parent = Btn

    local Toggled = false
    Btn.MouseButton1Click:Connect(function()
        Toggled = not Toggled
        if Toggled then
            Tween(Btn, {BackgroundColor3 = Theme.Accent}, 0.2)
            Tween(Indicator, {Position = UDim2.new(1, -16, 0.5, -7)}, 0.2)
        else
            Tween(Btn, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}, 0.2)
            Tween(Indicator, {Position = UDim2.new(0, 2, 0.5, -7)}, 0.2)
        end
        if callback then callback(Toggled) end
    end)
end

local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 50)
    Frame.BackgroundColor3 = Theme.SectionBg
    Round(Frame, 6)
    Stroke(Frame, Theme.Border, 1)
    Frame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 0, 25)
    Label.Position = UDim2.new(0, 12, 0, 2)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local ValLabel = Instance.new("TextLabel")
    ValLabel.Size = UDim2.new(0.3, 0, 0, 25)
    ValLabel.Position = UDim2.new(0.7, -12, 0, 2)
    ValLabel.BackgroundTransparency = 1
    ValLabel.Text = tostring(default)
    ValLabel.TextColor3 = Theme.Accent
    ValLabel.Font = Enum.Font.GothamBold
    ValLabel.TextSize = 12
    ValLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValLabel.Parent = Frame

    local TrackBg = Instance.new("Frame")
    TrackBg.Size = UDim2.new(1, -24, 0, 4)
    TrackBg.Position = UDim2.new(0, 12, 0, 35)
    TrackBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    TrackBg.BorderSizePixel = 0
    Round(TrackBg, 2)
    TrackBg.Parent = Frame

    local TrackFill = Instance.new("Frame")
    TrackFill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    TrackFill.BackgroundColor3 = Theme.Accent
    TrackFill.BorderSizePixel = 0
    Round(TrackFill, 2)
    TrackFill.Parent = TrackBg

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 12, 0, 12)
    Knob.Position = UDim2.new(1, -6, 0.5, -6)
    Knob.BackgroundColor3 = Color3.new(1, 1, 1)
    Round(Knob, 6)
    Knob.Parent = TrackFill

    local dragging = false
    local function UpdateSlide(input)
        local pos = math.clamp((input.Position.X - TrackBg.AbsolutePosition.X) / TrackBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + ((max - min) * pos))
        ValLabel.Text = tostring(val)
        Tween(TrackFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.05)
        if callback then callback(val) end
    end

    TrackBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            UpdateSlide(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlide(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- ==========================================
-- VIRTUAL FLY CONTROLLER UI
-- ==========================================
local FlyUI = Instance.new("Frame")
FlyUI.Size = UDim2.new(0, 160, 0, 160)
FlyUI.Position = UDim2.new(1, -180, 1, -180)
FlyUI.BackgroundColor3 = Theme.MainBg
FlyUI.BackgroundTransparency = 0.2
FlyUI.Visible = false
Round(FlyUI, 80) -- Buat jadi bundar (Joystick base)
Stroke(FlyUI, Theme.Accent, 1)
FlyUI.Parent = ScreenGui
MakeDraggable(FlyUI, FlyUI)

local function CreateJoyBtn(text, pos, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = Theme.SectionBg
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Round(btn, 20)
    Stroke(btn, Theme.Border, 1)
    btn.Parent = FlyUI

    btn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            FlyInputs[key] = 1
            Tween(btn, {BackgroundColor3 = Theme.Accent}, 0.1)
        end
    end)
    btn.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            FlyInputs[key] = 0
            Tween(btn, {BackgroundColor3 = Theme.SectionBg}, 0.1)
        end
    end)
end

-- D-Pad Kiri/Kanan/Maju/Mundur
CreateJoyBtn("W", UDim2.new(0.5, -20, 0, 10), "W")
CreateJoyBtn("S", UDim2.new(0.5, -20, 1, -50), "S")
CreateJoyBtn("A", UDim2.new(0, 10, 0.5, -20), "A")
CreateJoyBtn("D", UDim2.new(1, -50, 0.5, -20), "D")

-- Tombol Up & Down di tengah
local UpBtn = Instance.new("TextButton")
UpBtn.Size = UDim2.new(0, 30, 0, 20)
UpBtn.Position = UDim2.new(0.5, -15, 0.5, -22)
UpBtn.BackgroundColor3 = Color3.fromRGB(40,150,40)
UpBtn.Text = "UP"
UpBtn.TextColor3 = Color3.new(1,1,1)
UpBtn.Font = Enum.Font.GothamBold
UpBtn.TextSize = 10
Round(UpBtn, 4)
UpBtn.Parent = FlyUI
UpBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then FlyInputs.UP = 1 end end)
UpBtn.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then FlyInputs.UP = 0 end end)

local DnBtn = Instance.new("TextButton")
DnBtn.Size = UDim2.new(0, 30, 0, 20)
DnBtn.Position = UDim2.new(0.5, -15, 0.5, 2)
DnBtn.BackgroundColor3 = Color3.fromRGB(150,40,40)
DnBtn.Text = "DN"
DnBtn.TextColor3 = Color3.new(1,1,1)
DnBtn.Font = Enum.Font.GothamBold
DnBtn.TextSize = 10
Round(DnBtn, 4)
DnBtn.Parent = FlyUI
DnBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then FlyInputs.DOWN = 1 end end)
DnBtn.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then FlyInputs.DOWN = 0 end end)


-- ==========================================
-- POPULATE TABS & FEATURES
-- ==========================================

-- TAB: MOVEMENT
local TabMovement = CreateTab("Movement")

CreateSlider(TabMovement, "Walk Speed", 16, 250, 16, function(val)
    Config.Speed = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)

CreateSlider(TabMovement, "Jump Power", 50, 300, 50, function(val)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = val
    end
end)

local FlyLoop
CreateToggle(TabMovement, "Enable Fly (+ Virtual UI)", function(enabled)
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

                -- Keyboard Support (Agar user PC tetap bisa jalan)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then FlyInputs.W = 1 else if FlyInputs.W == 1 and not UserInputService:GetFocusedTextBox() then FlyInputs.W = 0 end end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then FlyInputs.S = 1 else if FlyInputs.S == 1 then FlyInputs.S = 0 end end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then FlyInputs.A = 1 else if FlyInputs.A == 1 then FlyInputs.A = 0 end end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then FlyInputs.D = 1 else if FlyInputs.D == 1 then FlyInputs.D = 0 end end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then FlyInputs.UP = 1 else if FlyInputs.UP == 1 then FlyInputs.UP = 0 end end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then FlyInputs.DOWN = 1 else if FlyInputs.DOWN == 1 then FlyInputs.DOWN = 0 end end

                -- Cek Input
                if FlyInputs.W > 0 then moveVector = moveVector + camCFrame.LookVector end
                if FlyInputs.S > 0 then moveVector = moveVector - camCFrame.LookVector end
                if FlyInputs.A > 0 then moveVector = moveVector - camCFrame.RightVector end
                if FlyInputs.D > 0 then moveVector = moveVector + camCFrame.RightVector end
                if FlyInputs.UP > 0 then moveVector = moveVector + Vector3.new(0, 1, 0) end
                if FlyInputs.DOWN > 0 then moveVector = moveVector - Vector3.new(0, 1, 0) end

                -- Stabilizer & Gerak
                hrp.Velocity = Vector3.new(0,0,0) 
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

CreateSlider(TabMovement, "Fly Speed", 10, 300, 50, function(val)
    Config.FlySpeed = val
end)

-- TAB: UTILITIES
local TabUtility = CreateTab("Utilities")

local NoclipConn
CreateToggle(TabUtility, "Noclip (Walk through walls)", function(enabled)
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

CreateToggle(TabUtility, "God Mode (Auto Heal)", function(enabled)
    Config.GodMode = enabled
    spawn(function()
        while Config.GodMode and wait(0.1) do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
            end
        end
    end)
end)

-- TAB: VISUALS
local TabVisuals = CreateTab("Visuals")

CreateToggle(TabVisuals, "Fullbright", function(enabled)
    if enabled then
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").ClockTime = 14
        game:GetService("Lighting").GlobalShadows = false
    else
        game:GetService("Lighting").Brightness = 1
        game:GetService("Lighting").GlobalShadows = true
    end
end)
