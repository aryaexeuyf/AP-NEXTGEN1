--[[
    AP-NEXTGEN v9.0 – REBORN EDITION (UI ONLY)
    Theme: Yellow & Blue Transparent (Glossy Pro)
    Created By: APTECH
]]

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local LocalPlayer      = Players.LocalPlayer

-- ==================== THEME CONFIGURATION ====================
local T = {
    Bg          = Color3.fromRGB(10, 15, 28), -- Deep Blue
    BgTrans     = 0.15,                        -- Transparansi Background
    Accent      = Color3.fromRGB(255, 210, 0), -- Electric Yellow
    Primary     = Color3.fromRGB(0, 140, 255), -- Cyber Blue
    Surface     = Color3.fromRGB(20, 25, 45),
    Text        = Color3.fromRGB(255, 255, 255),
    Muted       = Color3.fromRGB(160, 170, 190),
    Success     = Color3.fromRGB(0, 255, 130),
    Error       = Color3.fromRGB(255, 60, 90),
}

-- ==================== HELPERS ====================
local function Tween(obj, props, dur, style, dir)
    local info = TweenInfo.new(dur or 0.3, style or Enum.EasingStyle.Exponential, dir or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function Round(inst, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 8); c.Parent = inst; return c
end

local function Stroke(inst, col, th, trans)
    local s = Instance.new("UIStroke")
    s.Color = col or T.Primary
    s.Thickness = th or 1.2
    s.Transparency = trans or 0.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = inst
    return s
end

-- ==================== MAIN SCREEN GUI ====================
local SG = Instance.new("ScreenGui")
SG.Name = "APNEXTGEN_PRO"
SG.Parent = CoreGui
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ==================== OPENING SEQUENCE ====================
local function StartOpening()
    local Splash = Instance.new("Frame")
    Splash.Size = UDim2.new(1, 0, 1, 0)
    Splash.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
    Splash.ZIndex = 999
    Splash.Parent = SG

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Position = UDim2.new(0, 0, 0.45, -25)
    Title.BackgroundTransparency = 1
    Title.Text = "(AP-NEXTGEN1)"
    Title.TextColor3 = T.Accent
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 35
    Title.TextTransparency = 1
    Title.Parent = Splash

    local Sub = Instance.new("TextLabel")
    Sub.Size = UDim2.new(1, 0, 0, 20)
    Sub.Position = UDim2.new(0, 0, 0.45, 25)
    Sub.BackgroundTransparency = 1
    Sub.Text = "By APTECH"
    Sub.TextColor3 = T.Primary
    Sub.Font = Enum.Font.GothamBold
    Sub.TextSize = 14
    Sub.TextTransparency = 1
    Sub.Parent = Splash

    -- Animasi Opening
    Tween(Title, {TextTransparency = 0}, 1)
    task.wait(0.5)
    Tween(Sub, {TextTransparency = 0}, 1)
    task.wait(2)
    Tween(Title, {TextTransparency = 1}, 0.8)
    Tween(Sub, {TextTransparency = 1}, 0.8)
    local t = Tween(Splash, {BackgroundTransparency = 1}, 1)
    t.Completed:Connect(function() Splash:Destroy() end)
end

-- ==================== MAIN FRAME ====================
local MF = Instance.new("Frame")
MF.Name = "MainFrame"
MF.Size = UDim2.new(0, 520, 0, 340) -- Ukuran lebih proporsional
MF.Position = UDim2.new(0.5, -260, 0.5, -170)
MF.BackgroundColor3 = T.Bg
MF.BackgroundTransparency = T.BgTrans
MF.BorderSizePixel = 0
MF.Visible = false -- Hidden initially for opening
MF.ClipsDescendants = true
Round(MF, 16)
Stroke(MF, T.Accent, 1.8, 0.3)
MF.Parent = SG

-- Background Image (User can paste Base64 later)
local GlobalBg = Instance.new("ImageLabel")
GlobalBg.Name = "PanelBackground"
GlobalBg.Size = UDim2.new(1, 0, 1, 0)
GlobalBg.BackgroundTransparency = 1
GlobalBg.Image = "rbxassetid://0" -- PASTE DATA BASE64 DISINI
GlobalBg.ImageTransparency = 0.75
GlobalBg.ScaleType = Enum.ScaleType.Crop
GlobalBg.ZIndex = 0
Round(GlobalBg, 16)
GlobalBg.Parent = MF

-- ==================== TOP BAR ====================
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = T.Surface
TopBar.BackgroundTransparency = 0.2
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 10
Round(TopBar, 16)
TopBar.Parent = MF

local TitleMain = Instance.new("TextLabel")
TitleMain.Text = "AP-NEXTGEN v9.0 <font color='#FFD200'>| By APTECH</font>"
TitleMain.RichText = true
TitleMain.Size = UDim2.new(0, 200, 1, 0)
TitleMain.Position = UDim2.new(0, 15, 0, 0)
TitleMain.BackgroundTransparency = 1
TitleMain.TextColor3 = T.Text
TitleMain.Font = Enum.Font.GothamBold
TitleMain.TextSize = 13
TitleMain.TextXAlignment = Enum.TextXAlignment.Left
TitleMain.ZIndex = 11
TitleMain.Parent = TopBar

-- Minimize Button (Squircle Style)
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -75, 0.5, -14)
MinBtn.BackgroundColor3 = T.Surface
MinBtn.Text = "-"
MinBtn.TextColor3 = T.Accent
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.AutoButtonColor = false
MinBtn.ZIndex = 11
Round(MinBtn, 10) -- Semi-rounded (Squircle)
Stroke(MinBtn, T.Accent, 1)
MinBtn.Parent = TopBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -14)
CloseBtn.BackgroundColor3 = T.Error
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.AutoButtonColor = false
CloseBtn.ZIndex = 11
Round(CloseBtn, 10)
CloseBtn.Parent = TopBar

-- ==================== SIDEBAR (LEFT) ====================
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 60, 1, -42)
Sidebar.Position = UDim2.new(0, 0, 0, 42)
Sidebar.BackgroundColor3 = T.Surface
Sidebar.BackgroundTransparency = 0.4
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MF

local SideList = Instance.new("UIListLayout")
SideList.Padding = UDim.new(0, 10)
SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideList.Parent = Sidebar

local SidePad = Instance.new("UIPadding")
SidePad.PaddingTop = UDim.new(0, 15)
SidePad.Parent = Sidebar

-- ==================== CONTENT AREA ====================
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -65, 1, -50)
Container.Position = UDim2.new(0, 65, 0, 47)
Container.BackgroundTransparency = 1
Container.Parent = MF

local Pages = {}
local NavButtons = {}

local function NewPage(id, icon)
    local p = Instance.new("ScrollingFrame")
    p.Name = id
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.ScrollBarThickness = 2
    p.ScrollBarImageColor3 = T.Accent
    p.Visible = false
    p.BorderSizePixel = 0
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    p.Parent = Container

    local ll = Instance.new("UIListLayout"); ll.Padding = UDim.new(0, 8); ll.Parent = p
    local pd = Instance.new("UIPadding"); pd.PaddingLeft = UDim.new(0,5); pd.PaddingRight = UDim.new(0,10); pd.Parent = p

    Pages[id] = p

    -- Nav Button
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 40, 0, 40)
    b.BackgroundColor3 = T.Surface
    b.BackgroundTransparency = 0.5
    b.Text = icon
    b.TextColor3 = T.Muted
    b.TextSize = 18
    b.AutoButtonColor = false
    Round(b, 12)
    Stroke(b, T.Primary, 1)
    b.Parent = Sidebar

    b.MouseButton1Click:Connect(function()
        for _, pg in pairs(Pages) do pg.Visible = false end
        for _, btn in pairs(NavButtons) do 
            Tween(btn, {BackgroundColor3 = T.Surface, TextColor3 = T.Muted}, 0.2)
        end
        p.Visible = true
        Tween(b, {BackgroundColor3 = T.Primary, TextColor3 = T.Accent}, 0.2)
    end)
    
    NavButtons[id] = b
    return p
end

-- ==================== UI COMPONENTS (STYLIZED) ====================
local function Section(parent, title)
    local s = Instance.new("Frame")
    s.Size = UDim2.new(1, 0, 0, 30)
    s.BackgroundColor3 = T.Primary
    s.BackgroundTransparency = 0.8
    s.AutomaticSize = Enum.AutomaticSize.Y
    Round(s, 10)
    Stroke(s, T.Primary, 0.8, 0.6)
    s.Parent = parent

    local t = Instance.new("TextLabel")
    t.Text = "  " .. title:upper()
    t.Size = UDim2.new(1, 0, 0, 25)
    t.BackgroundTransparency = 1
    t.TextColor3 = T.Accent
    t.Font = Enum.Font.GothamBold
    t.TextSize = 10
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = s

    local c = Instance.new("Frame")
    c.Name = "Container"
    c.Size = UDim2.new(1, -10, 0, 0)
    c.Position = UDim2.new(0, 5, 0, 28)
    c.BackgroundTransparency = 1
    c.AutomaticSize = Enum.AutomaticSize.Y
    c.Parent = s

    local cll = Instance.new("UIListLayout"); cll.Padding = UDim.new(0, 5); cll.Parent = c
    local cpd = Instance.new("UIPadding"); cpd.PaddingBottom = UDim.new(0, 8); cpd.Parent = c
    
    return c
end

local function NewToggle(parent, text, callback)
    local t = Instance.new("TextButton")
    t.Size = UDim2.new(1, 0, 0, 32)
    t.BackgroundColor3 = T.Surface
    t.BackgroundTransparency = 0.5
    t.Text = "   " .. text
    t.TextColor3 = T.Text
    t.Font = Enum.Font.Gotham
    t.TextSize = 11
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.AutoButtonColor = false
    Round(t, 8)
    t.Parent = parent

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 34, 0, 18)
    indicator.Position = UDim2.new(1, -40, 0.5, -9)
    indicator.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
    Round(indicator, 9)
    indicator.Parent = t

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(0, 2, 0.5, -7)
    knob.BackgroundColor3 = T.Muted
    Round(knob, 7)
    knob.Parent = indicator

    local active = false
    t.MouseButton1Click:Connect(function()
        active = not active
        Tween(indicator, {BackgroundColor3 = active and T.Success or Color3.fromRGB(40, 45, 60)}, 0.2)
        Tween(knob, {Position = active and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = active and T.Text or T.Muted}, 0.2)
        if callback then callback(active) end
    end)
end

-- ==================== BUILDING PAGES ====================
local Dash = NewPage("Dash", "🏠")
local Move = NewPage("Move", "⚡")
local World = NewPage("World", "🌎")
local Settings = NewPage("Settings", "⚙️")

-- Example Content
local s1 = Section(Dash, "Player Status")
local l1 = Instance.new("TextLabel")
l1.Text = "Welcome, " .. LocalPlayer.DisplayName
l1.Size = UDim2.new(1,0,0,20); l1.TextColor3 = T.Text; l1.BackgroundTransparency=1; l1.Font=Enum.Font.Gotham; l1.TextSize=11; l1.Parent=s1

local s2 = Section(Move, "Movement Hacks")
NewToggle(s2, "Infinite Jump", function(v) print("Jump:", v) end)
NewToggle(s2, "Walkspeed Boost", function(v) print("Speed:", v) end)

-- ==================== DRAG SYSTEM ====================
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = MF.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MF.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ==================== ORB / MINIMIZE ====================
local Orb = Instance.new("ImageButton")
Orb.Size = UDim2.new(0, 50, 0, 50)
Orb.Position = UDim2.new(0, 20, 0.5, -25)
Orb.BackgroundColor3 = T.Accent
Orb.Visible = false
Orb.ZIndex = 100
Orb.Image = "data:image/png;base64,..." -- Paste icon Base64 disini
Round(Orb, 15) -- Squircle orb
Stroke(Orb, T.Primary, 2)
Orb.Parent = SG

MinBtn.MouseButton1Click:Connect(function()
    Tween(MF, {Size = UDim2.new(0, 520, 0, 0), BackgroundTransparency = 1}, 0.4)
    task.wait(0.3)
    MF.Visible = false
    Orb.Visible = true
    Tween(Orb, {Size = UDim2.new(0, 50, 0, 50)}, 0.4, Enum.EasingStyle.Back)
end)

Orb.MouseButton1Click:Connect(function()
    Orb.Visible = false
    MF.Visible = true
    Tween(MF, {Size = UDim2.new(0, 520, 0, 340), BackgroundTransparency = T.BgTrans}, 0.5, Enum.EasingStyle.Back)
end)

CloseBtn.MouseButton1Click:Connect(function()
    SG:Destroy()
end)

-- ==================== START ====================
task.spawn(StartOpening)
task.wait(3.5)
MF.Visible = true
MF.Size = UDim2.new(0, 0, 0, 0)
Tween(MF, {Size = UDim2.new(0, 520, 0, 340)}, 0.6, Enum.EasingStyle.Back)
NavButtons["Dash"].MouseButton1Click:Fire() -- Auto open first page
