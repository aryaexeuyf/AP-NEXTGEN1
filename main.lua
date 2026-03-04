--[[
AP-NEXTGEN v9.0 – PREMIUM UI EDITION
Improved by APTECH | Yellow & Blue Transparent Theme
Opening Animation + Professional UI Design
]]

-- ==================== SERVICES ====================
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local RunService       = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ==================== THEME (YELLOW & BLUE) ====================
local T = {
    -- Primary Colors
    Primary       = Color3.fromRGB(0, 140, 255),      -- Blue
    Secondary     = Color3.fromRGB(255, 200, 0),      -- Yellow
    Accent        = Color3.fromRGB(0, 180, 255),      -- Light Blue
    
    -- Background Colors (Semi Transparent)
    Bg            = Color3.fromRGB(8, 12, 20),
    Surface       = Color3.fromRGB(15, 22, 35),
    SurfaceHi     = Color3.fromRGB(25, 35, 55),
    NavBg         = Color3.fromRGB(12, 18, 30),
    
    -- Status Colors
    Success       = Color3.fromRGB(0, 220, 120),
    Warning       = Color3.fromRGB(255, 180, 0),
    Error         = Color3.fromRGB(255, 60, 80),
    Admin         = Color3.fromRGB(255, 200, 0),
    
    -- Text Colors
    Text          = Color3.fromRGB(240, 245, 255),
    Muted         = Color3.fromRGB(130, 145, 170),
    Border        = Color3.fromRGB(35, 50, 80),
    
    -- Transparency Values
    PanelTrans    = 0.15,
    OverlayTrans  = 0.92
}

-- ==================== ASSETS ====================
local ASSETS = {
    MinimizeIcon = "https://raw.githubusercontent.com/aryaexeuyf/Image/main/logo_g1.png",
    Background   = "https://raw.githubusercontent.com/aryaexeuyf/Image/main/background.jpg"
}

-- ==================== TWEEN HELPER ====================
local function Tween(obj, props, dur, style, dir)
    local tweenInfo = TweenInfo.new(
        dur or 0.3,
        style or Enum.EasingStyle.Quart,
        dir or Enum.EasingDirection.Out
    )
    TweenService:Create(obj, tweenInfo, props):Play()
end

local function TweenWait(obj, props, dur, style, dir)
    local tween = TweenService:Create(obj, TweenInfo.new(dur or 0.3, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props)
    tween:Play()
    local completed = false
    tween.Completed:Connect(function() completed = true end)
    while not completed do RunService.Heartbeat:Wait() end
end

-- ==================== UI BUILDERS ====================
local function Round(inst, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 10)
    c.Parent = inst
    return c
end

local function SoftRound(inst, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = inst
    return c
end

local function Stroke(inst, col, th, trans)
    local s = Instance.new("UIStroke")
    s.Color = col or T.Border
    s.Thickness = th or 1
    s.Transparency = trans or 0
    s.Parent = inst
    return s
end

local function Gradient(inst, col1, col2, rot)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(col1 or T.Primary, col2 or T.Accent)
    g.Rotation = rot or 90
    g.Parent = inst
    return g
end

local function BlurBackground(inst, amount)
    local vb = Instance.new("ImageLabel")
    vb.Size = UDim2.new(1, 0, 1, 0)
    vb.Position = UDim2.new(0, 0, 0, 0)
    vb.BackgroundTransparency = 1
    vb.Image = ASSETS.Background
    vb.ImageColor3 = Color3.fromRGB(255, 255, 255)
    vb.ImageTransparency = T.PanelTrans
    vb.ScaleType = Enum.ScaleType.Crop
    vb.SliceCenter = Rect.new(0, 0, 1, 1)
    vb.ZIndex = -1
    vb.Parent = inst
    
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = T.Bg
    overlay.BackgroundTransparency = T.OverlayTrans
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 0
    overlay.Parent = inst
    
    return vb
end

local function Lbl(parent, text, size, color, font, align, wrap)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextSize = size or 12
    l.TextColor3 = color or T.Text
    l.Font = font or Enum.Font.Gotham
    l.TextXAlignment = align or Enum.TextXAlignment.Left
    l.TextWrapped = wrap or false
    l.TextStrokeTransparency = 0.5
    l.Parent = parent
    return l
end

-- ==================== SCREENGUI ====================
local SG = Instance.new("ScreenGui")
SG.Name = "APNEXTGEN_PREMIUM"
SG.Parent = CoreGui
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.DisplayOrder = 1000
SG.IgnoreGuiInset = true

-- ==================== OPENING SCREEN ====================
local OpeningFrame = Instance.new("Frame")
OpeningFrame.Size = UDim2.new(1, 0, 1, 0)
OpeningFrame.Position = UDim2.new(0, 0, 0, 0)
OpeningFrame.BackgroundColor3 = Color3.fromRGB(5, 8, 15)
OpeningFrame.BorderSizePixel = 0
OpeningFrame.ZIndex = 2000
OpeningFrame.Parent = SG

-- Opening Background Gradient
local openGradient = Instance.new("UIGradient")
openGradient.Color = ColorSequence.new(
    Color3.fromRGB(5, 8, 15),
    Color3.fromRGB(15, 25, 45)
)
openGradient.Rotation = 135
openGradient.Parent = OpeningFrame

-- Opening Logo Container
local LogoContainer = Instance.new("Frame")
LogoContainer.Size = UDim2.new(0, 280, 0, 280)
LogoContainer.Position = UDim2.new(0.5, -140, 0.5, -140)
LogoContainer.BackgroundTransparency = 1
LogoContainer.ZIndex = 2001
LogoContainer.Parent = OpeningFrame

-- Logo Image
local LogoImg = Instance.new("ImageLabel")
LogoImg.Size = UDim2.new(0, 200, 0, 200)
LogoImg.Position = UDim2.new(0.5, -100, 0.5, -100)
LogoImg.BackgroundTransparency = 1
LogoImg.Image = "rbxassetid://0"
LogoImg.ImageTransparency = 1
LogoImg.ZIndex = 2002
LogoImg.Parent = LogoContainer

-- Title Text
local TitleLbl = Instance.new("TextLabel")
TitleLbl.Size = UDim2.new(0, 400, 0, 60)
TitleLbl.Position = UDim2.new(0.5, -200, 0.5, 80)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text = "AP-NEXTGEN"
TitleLbl.TextSize = 42
TitleLbl.TextColor3 = T.Primary
TitleLbl.Font = Enum.Font.GothamBlack
TitleLbl.TextStrokeTransparency = 0
TitleLbl.TextTransparency = 1
TitleLbl.ZIndex = 2002
TitleLbl.Parent = LogoContainer

-- Subtitle
local SubtitleLbl = Instance.new("TextLabel")
SubtitleLbl.Size = UDim2.new(0, 300, 0, 25)
SubtitleLbl.Position = UDim2.new(0.5, -150, 0.5, 135)
SubtitleLbl.BackgroundTransparency = 1
SubtitleLbl.Text = "By APTECH"
SubtitleLbl.TextSize = 16
SubtitleLbl.TextColor3 = T.Secondary
SubtitleLbl.Font = Enum.Font.GothamBold
SubtitleLbl.TextTransparency = 1
SubtitleLbl.ZIndex = 2002
SubtitleLbl.Parent = LogoContainer

-- Version
local VersionLbl = Instance.new("TextLabel")
VersionLbl.Size = UDim2.new(0, 200, 0, 18)
VersionLbl.Position = UDim2.new(0.5, -100, 0.5, 165)
VersionLbl.BackgroundTransparency = 1
VersionLbl.Text = "v9.0 PREMIUM EDITION"
VersionLbl.TextSize = 11
VersionLbl.TextColor3 = T.Muted
VersionLbl.Font = Enum.Font.Gotham
VersionLbl.TextTransparency = 1
VersionLbl.ZIndex = 2002
VersionLbl.Parent = LogoContainer

-- Loading Bar Container
local LoadBarCont = Instance.new("Frame")
LoadBarCont.Size = UDim2.new(0, 250, 0, 6)
LoadBarCont.Position = UDim2.new(0.5, -125, 0.5, 210)
LoadBarCont.BackgroundColor3 = T.SurfaceHi
LoadBarCont.BackgroundTransparency = 0.3
LoadBarCont.BorderSizePixel = 0
LoadBarCont.ZIndex = 2002
Round(LoadBarCont, 3)
LoadBarCont.Parent = LogoContainer

-- Loading Bar Fill
local LoadBarFill = Instance.new("Frame")
LoadBarFill.Size = UDim2.new(0, 0, 1, 0)
LoadBarFill.Position = UDim2.new(0, 0, 0, 0)
LoadBarFill.BackgroundColor3 = T.Primary
LoadBarFill.BorderSizePixel = 0
LoadBarFill.ZIndex = 2003
SoftRound(LoadBarFill, 3)
LoadBarFill.Parent = LoadBarCont

-- Loading Bar Gradient
Gradient(LoadBarFill, T.Primary, T.Secondary, 0)

-- ==================== MAIN FRAME ====================
local MF = Instance.new("Frame")
MF.Name = "MainFrame"
MF.Size = UDim2.new(0, 0, 0, 0)
MF.Position = UDim2.new(0.5, -240, 0.5, -165)
MF.BackgroundColor3 = T.Bg
MF.BackgroundTransparency = T.PanelTrans
MF.BorderSizePixel = 0
MF.ClipsDescendants = true
MF.Active = true
MF.Visible = false
MF.ZIndex = 100
MF.Parent = SG

-- Main Background Image
BlurBackground(MF, 15)

-- Main Border Glow
local mainStroke = Stroke(MF, T.Primary, 1.5, 0.3)
Round(MF, 16)

-- ==================== TOP BAR ====================
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 48)
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.BackgroundColor3 = T.Surface
TopBar.BackgroundTransparency = 0.25
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 101
SoftRound(TopBar, 16)
TopBar.Parent = MF

-- Top Bar Bottom Fix (for rounded corners)
local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 16)
TopFix.Position = UDim2.new(0, 0, 1, -16)
TopFix.BackgroundColor3 = T.Surface
TopFix.BackgroundTransparency = 0.25
TopFix.BorderSizePixel = 0
TopFix.ZIndex = 100
TopFix.Parent = TopBar
SoftRound(TopFix, 16)

-- Logo/Brand
local BrandLbl = Lbl(TopBar, "⚡ AP-NEXTGEN", 14, T.Primary, Enum.Font.GothamBlack, Enum.TextXAlignment.Left)
BrandLbl.Size = UDim2.new(0, 150, 0, 20)
BrandLbl.Position = UDim2.new(0, 14, 0, 14)
BrandLbl.ZIndex = 102
BrandLbl.TextStrokeTransparency = 0.3

-- Avatar
local AvImg = Instance.new("ImageLabel")
AvImg.Size = UDim2.new(0, 32, 0, 32)
AvImg.Position = UDim2.new(0, 10, 0.5, -16)
AvImg.BackgroundColor3 = T.SurfaceHi
AvImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=150&height=150&format=png"
AvImg.ZIndex = 102
Round(AvImg, 16)
Stroke(AvImg, T.Primary, 1.5, 0.5)
AvImg.Parent = TopBar

-- Player Name
local NameLbl = Lbl(TopBar, LocalPlayer.Name, 12, T.Text, Enum.Font.GothamBold)
NameLbl.Size = UDim2.new(0, 100, 0, 16)
NameLbl.Position = UDim2.new(0, 48, 0, 10)
NameLbl.ZIndex = 102
NameLbl.TextTruncate = Enum.TextTruncate.AtEnd

-- Script Credit
local CreditLbl = Lbl(TopBar, "Script by APTECH", 9, T.Secondary, Enum.Font.GothamBold)
CreditLbl.Size = UDim2.new(0, 100, 0, 12)
CreditLbl.Position = UDim2.new(0, 48, 0, 28)
CreditLbl.ZIndex = 102
CreditLbl.TextTransparency = 0.3

-- Game Info
local GameLbl = Lbl(TopBar, game.Name:sub(1,18), 8, T.Muted)
GameLbl.Size = UDim2.new(0, 100, 0, 10)
GameLbl.Position = UDim2.new(0, 48, 0, 38)
GameLbl.ZIndex = 102
GameLbl.TextTruncate = Enum.TextTruncate.AtEnd

-- Server Info Center
local SrvLbl = Lbl(TopBar, "🌐 Global | "..tostring(game.PlaceId):sub(1,8), 10, T.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
SrvLbl.Size = UDim2.new(0, 220, 0, 16)
SrvLbl.Position = UDim2.new(0.5, -110, 0.5, -8)
SrvLbl.ZIndex = 102
SrvLbl.TextTruncate = Enum.TextTruncate.AtEnd

-- Minimize Button (Semi-Rounded with Image)
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 32, 0, 32)
MinBtn.Position = UDim2.new(1, -70, 0.5, -16)
MinBtn.BackgroundColor3 = T.SurfaceHi
MinBtn.BackgroundTransparency = 0.3
MinBtn.Text = ""
MinBtn.ZIndex = 103
MinBtn.AutoButtonColor = false
SoftRound(MinBtn, 8)
Stroke(MinBtn, T.Border, 1, 0.5)
MinBtn.Parent = TopBar

-- Minimize Icon
local MinIcon = Instance.new("ImageLabel")
MinIcon.Size = UDim2.new(0, 18, 0, 18)
MinIcon.Position = UDim2.new(0.5, -9, 0.5, -9)
MinIcon.BackgroundTransparency = 1
MinIcon.Image = ASSETS.MinimizeIcon
MinIcon.ImageColor3 = T.Muted
MinIcon.ZIndex = 104
SoftRound(MinIcon, 4)
MinIcon.Parent = MinBtn

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -16)
CloseBtn.BackgroundColor3 = T.Error
CloseBtn.BackgroundTransparency = 0.2
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 103
CloseBtn.AutoButtonColor = false
SoftRound(CloseBtn, 8)
CloseBtn.Parent = TopBar

-- ==================== SERVER INFO UPDATER ====================
spawn(function()
    while SrvLbl.Parent do
        local pc = #Players:GetPlayers()
        local mp = 0
        pcall(function() mp = Players.MaxPlayers end)
        GameLbl.Text = game.Name:sub(1,18)
        SrvLbl.Text = "🌐 Global | "..tostring(game.PlaceId):sub(1,8).." | "..pc.."/"..mp
        wait(5)
    end
end)

-- ==================== DRAG FUNCTIONALITY ====================
local _drag, _ds, _sp = false, nil, nil
TopBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        _drag = true
        _ds = i.Position
        _sp = MF.Position
    end
end)

UserInputService.InputChanged:Connect(function(i)
    if _drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - _ds
        MF.Position = UDim2.new(_sp.X.Scale, _sp.X.Offset + d.X, _sp.Y.Scale, _sp.Y.Offset + d.Y)
    end
end)

UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        _drag = false
    end
end)

-- ==================== LEFT NAV SIDEBAR ====================
local NavFrame = Instance.new("ScrollingFrame")
NavFrame.Size = UDim2.new(0, 62, 1, -48)
NavFrame.Position = UDim2.new(0, 0, 0, 48)
NavFrame.BackgroundColor3 = T.NavBg
NavFrame.BackgroundTransparency = 0.4
NavFrame.BorderSizePixel = 0
NavFrame.ScrollBarThickness = 0
NavFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
NavFrame.ScrollingDirection = Enum.ScrollingDirection.Y
NavFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
NavFrame.ZIndex = 101
NavFrame.Parent = MF

local NavLL = Instance.new("UIListLayout")
NavLL.Padding = UDim.new(0, 4)
NavLL.HorizontalAlignment = Enum.HorizontalAlignment.Center
NavLL.Parent = NavFrame

local NavPad = Instance.new("UIPadding")
NavPad.PaddingTop = UDim.new(0, 6)
NavPad.PaddingBottom = UDim.new(0, 6)
NavPad.Parent = NavFrame

-- Separator Line
local Div = Instance.new("Frame")
Div.Size = UDim2.new(0, 1, 1, -48)
Div.Position = UDim2.new(0, 62, 0, 48)
Div.BackgroundColor3 = T.Border
Div.BackgroundTransparency = 0.5
Div.BorderSizePixel = 0
Div.ZIndex = 101
Div.Parent = MF

-- ==================== CONTENT AREA ====================
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -63, 1, -48)
ContentArea.Position = UDim2.new(0, 63, 0, 48)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.ZIndex = 101
ContentArea.Parent = MF

-- ==================== PAGE SYSTEM ====================
local Pages = {}
local NavBtns = {}

local function NewPage(name)
    local sf = Instance.new("ScrollingFrame")
    sf.Name = name
    sf.Size = UDim2.new(1, 0, 1, 0)
    sf.BackgroundTransparency = 1
    sf.BorderSizePixel = 0
    sf.ScrollBarThickness = 4
    sf.ScrollBarImageColor3 = T.Primary
    sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sf.CanvasSize = UDim2.new(0, 0, 0, 0)
    sf.ScrollingDirection = Enum.ScrollingDirection.Y
    sf.Visible = false
    sf.ZIndex = 102
    sf.Parent = ContentArea
    
    local ll = Instance.new("UIListLayout")
    ll.Padding = UDim.new(0, 6)
    ll.Parent = sf
    
    local pd = Instance.new("UIPadding")
    pd.PaddingTop = UDim.new(0, 8)
    pd.PaddingLeft = UDim.new(0, 8)
    pd.PaddingRight = UDim.new(0, 8)
    pd.PaddingBottom = UDim.new(0, 8)
    pd.Parent = sf
    
    Pages[name] = sf
    return sf
end

local function GoPage(name)
    for n, pg in pairs(Pages) do
        if n == name then
            pg.Visible = true
            Tween(pg, {ScrollPosition = 0}, 0.3)
        else
            pg.Visible = false
        end
    end
    
    for n, btn in pairs(NavBtns) do
        if n == name then
            Tween(btn, {BackgroundColor3 = T.Primary}, 0.2, Enum.EasingStyle.Quart)
            Tween(btn, {BackgroundTransparency = 0.1}, 0.2)
            btn.TextColor3 = Color3.new(1, 1, 1)
        else
            Tween(btn, {BackgroundColor3 = T.NavBg}, 0.2, Enum.EasingStyle.Quart)
            Tween(btn, {BackgroundTransparency = 0.4}, 0.2)
            btn.TextColor3 = T.Muted
        end
    end
end

local function NavBtn(icon, pageName)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 48, 0, 42)
    b.BackgroundColor3 = T.NavBg
    b.BackgroundTransparency = 0.4
    b.Text = icon
    b.TextColor3 = T.Muted
    b.TextSize = 16
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.ZIndex = 102
    SoftRound(b, 10)
    Stroke(b, T.Border, 1, 0.7)
    b.Parent = NavFrame
    
    NavBtns[pageName] = b
    
    b.MouseButton1Click:Connect(function()
        GoPage(pageName)
    end)
    
    return b
end

-- ==================== UI COMPONENT BUILDERS ====================
local function Section(parent, title, icon)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = T.Surface
    card.BackgroundTransparency = 0.3
    card.BorderSizePixel = 0
    card.ZIndex = 103
    Round(card, 12)
    Stroke(card, T.Border, 1, 0.5)
    card.Parent = parent
    
    -- Background for card
    BlurBackground(card, 10)
    
    local ttl = Lbl(card, (icon or "").." "..title, 11, T.Primary, Enum.Font.GothamBold)
    ttl.Size = UDim2.new(1, -16, 0, 24)
    ttl.Position = UDim2.new(0, 10, 0, 5)
    ttl.ZIndex = 104
    ttl.TextStrokeTransparency = 0.5
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, -20, 0, 1)
    line.Position = UDim2.new(0, 10, 0, 28)
    line.BackgroundColor3 = T.Primary
    line.BackgroundTransparency = 0.5
    line.BorderSizePixel = 0
    line.ZIndex = 104
    SoftRound(line, 1)
    line.Parent = card
    
    local cont = Instance.new("Frame")
    cont.Name = "Cont"
    cont.Size = UDim2.new(1, -14, 0, 0)
    cont.Position = UDim2.new(0, 7, 0, 33)
    cont.AutomaticSize = Enum.AutomaticSize.Y
    cont.BackgroundTransparency = 1
    cont.ZIndex = 104
    cont.Parent = card
    
    local cL = Instance.new("UIListLayout")
    cL.Padding = UDim.new(0, 5)
    cL.Parent = cont
    
    local cP = Instance.new("UIPadding")
    cP.PaddingBottom = UDim.new(0, 8)
    cP.Parent = card
    
    return cont
end

local function Toggle(parent, text, _callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 30)
    row.BackgroundTransparency = 1
    row.ZIndex = 104
    row.Parent = parent
    
    local lbl = Lbl(row, text, 11, T.Text)
    lbl.Size = UDim2.new(0.68, 0, 1, 0)
    lbl.ZIndex = 105
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 22)
    btn.Position = UDim2.new(1, -50, 0.5, -11)
    btn.BackgroundColor3 = Color3.fromRGB(40, 50, 70)
    btn.BackgroundTransparency = 0.3
    btn.Text = "OFF"
    btn.TextColor3 = T.Muted
    btn.TextSize = 9
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.ZIndex = 105
    SoftRound(btn, 11)
    Stroke(btn, T.Border, 1, 0.6)
    btn.Parent = row
    
    local on = false
    
    btn.MouseButton1Click:Connect(function()
        on = not on
        btn.Text = on and "ON" or "OFF"
        Tween(btn, {BackgroundColor3 = on and T.Success or Color3.fromRGB(40, 50, 70)}, 0.18, Enum.EasingStyle.Quart)
        Tween(btn, {BackgroundTransparency = on and 0.1 or 0.3}, 0.18)
        Tween(btn, {TextColor3 = on and Color3.new(1,1,1) or T.Muted}, 0.18)
        if _callback then _callback(on) end
    end)
    
    return btn
end

local function Slider(parent, text, min, max, default, _callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 48)
    frame.BackgroundTransparency = 1
    frame.ZIndex = 104
    frame.Parent = parent
    
    local topRow = Instance.new("Frame")
    topRow.Size = UDim2.new(1, 0, 0, 18)
    topRow.BackgroundTransparency = 1
    topRow.ZIndex = 105
    topRow.Parent = frame
    
    local lbl = Lbl(topRow, text, 11, T.Text)
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.ZIndex = 106
    
    local vbox = Instance.new("TextBox")
    vbox.Size = UDim2.new(0, 50, 0, 18)
    vbox.Position = UDim2.new(1, -50, 0, 0)
    vbox.BackgroundColor3 = T.SurfaceHi
    vbox.BackgroundTransparency = 0.4
    vbox.Text = tostring(default)
    vbox.TextColor3 = T.Primary
    vbox.TextSize = 10
    vbox.Font = Enum.Font.GothamBold
    vbox.ClearTextOnFocus = false
    vbox.ZIndex = 106
    SoftRound(vbox, 5)
    Stroke(vbox, T.Border, 1, 0.5)
    vbox.Parent = topRow
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 5)
    track.Position = UDim2.new(0, 0, 0, 32)
    track.BackgroundColor3 = Color3.fromRGB(35, 45, 65)
    track.BackgroundTransparency = 0.4
    track.BorderSizePixel = 0
    track.ZIndex = 106
    SoftRound(track, 3)
    track.Parent = frame
    
    local pct = (default - min) / math.max(max - min, 1)
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = T.Primary
    fill.BorderSizePixel = 0
    fill.ZIndex = 107
    SoftRound(fill, 3)
    Gradient(fill, T.Primary, T.Secondary, 0)
    fill.Parent = track
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(pct, -7, 0.5, -7)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.ZIndex = 108
    Round(knob, 7)
    Stroke(knob, T.Primary, 2, 0)
    knob.Parent = track
    
    local dragging = false
    
    local function doUpdate(input)
        local p = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local v = math.floor(min + (max - min) * p)
        vbox.Text = tostring(v)
        fill.Size = UDim2.new(p, 0, 1, 0)
        knob.Position = UDim2.new(p, -7, 0.5, -7)
        if _callback then _callback(v) end
    end
    
    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            doUpdate(i)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            doUpdate(i)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    vbox.FocusLost:Connect(function()
        local v = math.clamp(tonumber(vbox.Text) or default, min, max)
        vbox.Text = tostring(v)
        local p = (v - min) / math.max(max - min, 1)
        fill.Size = UDim2.new(p, 0, 1, 0)
        knob.Position = UDim2.new(p, -7, 0.5, -7)
        if _callback then _callback(v) end
    end)
    
    return frame
end

local function Btn(parent, text, style, _callback)
    local col = style == "primary" and T.Primary
        or style == "success" and T.Success
        or style == "danger" and T.Error
        or style == "admin" and T.Admin
        or T.SurfaceHi
    
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 30)
    b.BackgroundColor3 = col
    b.BackgroundTransparency = style == "admin" and 0.1 or 0.2
    b.Text = text
    b.TextColor3 = style == "admin" and Color3.new(0,0,0) or Color3.new(1,1,1)
    b.TextSize = 11
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.ZIndex = 105
    SoftRound(b, 8)
    Stroke(b, T.Border, 1, style == "admin" and 0.3 or 0.5)
    b.Parent = parent
    
    b.MouseButton1Click:Connect(function()
        Tween(b, {BackgroundColor3 = col:Lerp(Color3.new(1,1,1), 0.2)}, 0.08)
        wait(0.08)
        Tween(b, {BackgroundColor3 = col}, 0.12)
        if _callback then _callback() end
    end)
    
    return b
end

-- ==================== CREATE PAGES ====================
NavBtn("📊", "Dash");  local PgDash  = NewPage("Dash")
NavBtn("🏃", "Move");  local PgMove  = NewPage("Move")
NavBtn("✈️", "Fly");   local PgFly   = NewPage("Fly")
NavBtn("👁️", "ESP");   local PgESP   = NewPage("ESP")
NavBtn("🎯", "TP");    local PgTP    = NewPage("TP")
NavBtn("🛡️", "God");   local PgGod   = NewPage("God")
NavBtn("🧱", "World"); local PgWorld = NewPage("World")
NavBtn("👤", "Ava");   local PgAva   = NewPage("Ava")
NavBtn("💾", "Save");  local PgSave  = NewPage("Save")
NavBtn("🔐", "Admin"); local PgAdmin = NewPage("Admin")
NavBtn("⚙️", "Util");  local PgUtil  = NewPage("Util")

-- ====================================================================
-- ====================== PAGE CONTENTS ===============================
-- ====================================================================

-- ---------- DASHBOARD ----------
local dsC = Section(PgDash, "SERVER MONITOR", "📊")
local plrC = Section(PgDash, "PLAYER INFO", "👤")

local function StatRow(parent, labelTxt, valTxt, valCol)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 22)
    row.BackgroundTransparency = 1
    row.ZIndex = 105
    row.Parent = parent
    
    local l = Lbl(row, labelTxt, 10, T.Muted)
    l.Size = UDim2.new(0.52, 0, 1, 0)
    l.ZIndex = 106
    
    local v = Lbl(row, valTxt, 10, valCol or T.Primary, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
    v.Size = UDim2.new(0.48, 0, 1, 0)
    v.Position = UDim2.new(0.52, 0, 0, 0)
    v.ZIndex = 106
    v.TextStrokeTransparency = 0.5
    
    return v
end

StatRow(dsC, "Game Name:", game.Name:sub(1,20), T.Primary)
StatRow(dsC, "Place ID:", tostring(game.PlaceId), T.Warning)
StatRow(dsC, "Job ID:", game.JobId:sub(1,12).."...", T.Muted)
local sPly = StatRow(dsC, "Players:", "--/--", T.Success)
StatRow(dsC, "Server Type:", "🌐 Global", T.Primary)

StatRow(plrC, "Username:", LocalPlayer.Name, T.Primary)
StatRow(plrC, "User ID:", tostring(LocalPlayer.UserId), T.Muted)
StatRow(plrC, "Display Name:", LocalPlayer.DisplayName, T.Text)
StatRow(plrC, "Team:", "None", T.Warning)

spawn(function()
    while sPly.Parent do
        local pc = 0
        local mp = 0
        pcall(function()
            pc = #Players:GetPlayers()
            mp = Players.MaxPlayers
        end)
        sPly.Text = pc.."/"..mp
        wait(5)
    end
end)

-- ---------- MOVEMENT ----------
local mvC = Section(PgMove, "SPEED & JUMP", "🏃")
Slider(mvC, "Walk Speed", 1, 500, 16)
Slider(mvC, "Jump Power", 1, 500, 50)
Btn(mvC, "Reset Speed & Jump", "normal")

local jC = Section(PgMove, "JUMP OPTIONS", "⬆️")
Toggle(jC, "Infinite Jump")

local gC = Section(PgMove, "GRAVITY", "🌙")
Toggle(gC, "Moon Gravity (Low)")
Slider(gC, "Custom Gravity", 5, 350, 196)

-- ---------- FLY ----------
local flyC = Section(PgFly, "FLY CONTROL", "✈️")

local spdRow = Instance.new("Frame")
spdRow.Size = UDim2.new(1, 0, 0, 32)
spdRow.BackgroundTransparency = 1
spdRow.ZIndex = 105
spdRow.Parent = flyC

local spdLbl = Lbl(spdRow, "Fly Speed:", 11, T.Text)
spdLbl.Size = UDim2.new(0.35, 0, 1, 0)
spdLbl.ZIndex = 106

local flyMin = Instance.new("TextButton")
flyMin.Size = UDim2.new(0, 28, 0, 24)
flyMin.Position = UDim2.new(0.37, 0, 0.5, -12)
flyMin.BackgroundColor3 = T.SurfaceHi
flyMin.BackgroundTransparency = 0.3
flyMin.Text = "−"
flyMin.TextColor3 = T.Text
flyMin.TextSize = 16
flyMin.Font = Enum.Font.GothamBold
flyMin.AutoButtonColor = false
flyMin.ZIndex = 106
SoftRound(flyMin, 6)
Stroke(flyMin, T.Border, 1, 0.5)
flyMin.Parent = spdRow

local flyDisp = Instance.new("TextLabel")
flyDisp.Size = UDim2.new(0, 36, 0, 24)
flyDisp.Position = UDim2.new(0.37, 30, 0.5, -12)
flyDisp.BackgroundColor3 = T.Surface
flyDisp.BackgroundTransparency = 0.4
flyDisp.Text = "1"
flyDisp.TextColor3 = T.Primary
flyDisp.TextSize = 12
flyDisp.Font = Enum.Font.GothamBold
flyDisp.TextXAlignment = Enum.TextXAlignment.Center
flyDisp.ZIndex = 106
SoftRound(flyDisp, 6)
Stroke(flyDisp, T.Border, 1, 0.5)
flyDisp.Parent = spdRow

local flyPlus = Instance.new("TextButton")
flyPlus.Size = UDim2.new(0, 28, 0, 24)
flyPlus.Position = UDim2.new(0.37, 68, 0.5, -12)
flyPlus.BackgroundColor3 = T.SurfaceHi
flyPlus.BackgroundTransparency = 0.3
flyPlus.Text = "+"
flyPlus.TextColor3 = T.Text
flyPlus.TextSize = 16
flyPlus.Font = Enum.Font.GothamBold
flyPlus.AutoButtonColor = false
flyPlus.ZIndex = 106
SoftRound(flyPlus, 6)
Stroke(flyPlus, T.Border, 1, 0.5)
flyPlus.Parent = spdRow

local udRow = Instance.new("Frame")
udRow.Size = UDim2.new(1, 0, 0, 28)
udRow.BackgroundTransparency = 1
udRow.ZIndex = 105
udRow.Parent = flyC

local flyUpBtn = Instance.new("TextButton")
flyUpBtn.Size = UDim2.new(0.49, 0, 0, 28)
flyUpBtn.BackgroundColor3 = T.SurfaceHi
flyUpBtn.BackgroundTransparency = 0.3
flyUpBtn.Text = "▲ UP"
flyUpBtn.TextColor3 = T.Text
flyUpBtn.TextSize = 11
flyUpBtn.Font = Enum.Font.GothamBold
flyUpBtn.AutoButtonColor = false
flyUpBtn.ZIndex = 106
SoftRound(flyUpBtn, 7)
Stroke(flyUpBtn, T.Border, 1, 0.5)
flyUpBtn.Parent = udRow

local flyDnBtn = Instance.new("TextButton")
flyDnBtn.Size = UDim2.new(0.49, 0, 0, 28)
flyDnBtn.Position = UDim2.new(0.51, 0, 0, 0)
flyDnBtn.BackgroundColor3 = T.SurfaceHi
flyDnBtn.BackgroundTransparency = 0.3
flyDnBtn.Text = "▼ DOWN"
flyDnBtn.TextColor3 = T.Text
flyDnBtn.TextSize = 11
flyDnBtn.Font = Enum.Font.GothamBold
flyDnBtn.AutoButtonColor = false
flyDnBtn.ZIndex = 106
SoftRound(flyDnBtn, 7)
Stroke(flyDnBtn, T.Border, 1, 0.5)
flyDnBtn.Parent = udRow

local flyTogBtn = Instance.new("TextButton")
flyTogBtn.Size = UDim2.new(1, 0, 0, 34)
flyTogBtn.BackgroundColor3 = Color3.fromRGB(40, 50, 70)
flyTogBtn.BackgroundTransparency = 0.3
flyTogBtn.Text = "✈️ FLY: OFF"
flyTogBtn.TextColor3 = T.Muted
flyTogBtn.TextSize = 13
flyTogBtn.Font = Enum.Font.GothamBold
flyTogBtn.AutoButtonColor = false
flyTogBtn.ZIndex = 106
SoftRound(flyTogBtn, 9)
Stroke(flyTogBtn, T.Border, 1, 0.5)
flyTogBtn.Parent = flyC

local ncC = Section(PgFly, "NOCLIP", "🔮")
Toggle(ncC, "No Clip (Pass Through)")

-- ---------- ESP ----------
local espC = Section(PgESP, "PLAYER ESP", "👁️")
Toggle(espC, "Enable Player ESP")

local espV2C = Section(PgESP, "ESP V2 – ADMIN", "👑")
local espLock = Lbl(espV2C, "🔒 Login Admin untuk ESP V2", 10, T.Warning)
espLock.Size = UDim2.new(1, 0, 0, 20)
espLock.ZIndex = 106
Toggle(espV2C, "👑 ESP V2 (HP + Dist + Team)")

local blkEspC = Section(PgESP, "BLOCK / ITEM ESP", "🧱")
Toggle(blkEspC, "Scan & Highlight Blocks")

-- ---------- TELEPORT ----------
local tpC = Section(PgTP, "TELEPORT", "🎯")

local tpSF = Instance.new("ScrollingFrame")
tpSF.Size = UDim2.new(1, 0, 0, 90)
tpSF.BackgroundColor3 = T.SurfaceHi
tpSF.BackgroundTransparency = 0.5
tpSF.BorderSizePixel = 0
tpSF.ScrollBarThickness = 4
tpSF.ScrollBarImageColor3 = T.Primary
tpSF.CanvasSize = UDim2.new(0, 0, 0, 0)
tpSF.ZIndex = 105
SoftRound(tpSF, 8)
Stroke(tpSF, T.Border, 1, 0.5)
tpSF.Parent = tpC

local tpLL = Instance.new("UIListLayout")
tpLL.Padding = UDim.new(0, 4)
tpLL.Parent = tpSF

local function RefreshTPList()
    for _, c in pairs(tpSF:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    local n = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            n = n + 1
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -8, 0, 28)
            b.Position = UDim2.new(0, 4, 0, 0)
            b.BackgroundColor3 = T.Surface
            b.BackgroundTransparency = 0.3
            b.Text = p.Name
            b.TextColor3 = Color3.new(1, 1, 1)
            b.TextSize = 11
            b.Font = Enum.Font.Gotham
            b.BorderSizePixel = 0
            b.AutoButtonColor = false
            b.ZIndex = 106
            SoftRound(b, 6)
            Stroke(b, T.Border, 1, 0.5)
            b.Parent = tpSF
            b.MouseButton1Click:Connect(function()
                for _, bb in pairs(tpSF:GetChildren()) do
                    if bb:IsA("TextButton") then
                        Tween(bb, {BackgroundTransparency = 0.3}, 0.12)
                    end
                end
                Tween(b, {BackgroundTransparency = 0.1}, 0.12)
            end)
        end
    end
    tpSF.CanvasSize = UDim2.new(0, 0, 0, n * 32)
end

RefreshTPList()
Players.PlayerAdded:Connect(RefreshTPList)
Players.PlayerRemoving:Connect(RefreshTPList)

Btn(tpC, "Teleport to Selected", "primary")
Toggle(tpC, "Follow Selected Player")

-- ---------- GOD ----------
local godC = Section(PgGod, "GOD MODE", "🛡️")

local godModeBtn = Instance.new("TextButton")
godModeBtn.Size = UDim2.new(1, 0, 0, 28)
godModeBtn.BackgroundColor3 = T.SurfaceHi
godModeBtn.BackgroundTransparency = 0.3
godModeBtn.Text = "Mode: Gen1 (Auto-Heal)"
godModeBtn.TextColor3 = T.Text
godModeBtn.TextSize = 11
godModeBtn.Font = Enum.Font.GothamBold
godModeBtn.AutoButtonColor = false
godModeBtn.ZIndex = 105
SoftRound(godModeBtn, 7)
Stroke(godModeBtn, T.Border, 1, 0.5)
godModeBtn.Parent = godC

Toggle(godC, "God Mode")
Toggle(godC, "Auto Heal (0.2s)")
Btn(godC, "Heal Now", "success")

-- ---------- WORLD ----------
local wC = Section(PgWorld, "BLOCK SPAWNER", "🧱")

local function Dropdown(parent, labelTxt, opts)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 0)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.BackgroundTransparency = 1
    frame.ZIndex = 105
    frame.Parent = parent
    
    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, 0, 0, 28)
    row.BackgroundColor3 = T.SurfaceHi
    row.BackgroundTransparency = 0.3
    row.Text = labelTxt..": "..opts[1].." ▾"
    row.TextColor3 = T.Text
    row.TextSize = 11
    row.Font = Enum.Font.GothamBold
    row.AutoButtonColor = false
    row.ZIndex = 106
    SoftRound(row, 7)
    Stroke(row, T.Border, 1, 0.5)
    row.Parent = frame
    
    local list = Instance.new("Frame")
    list.Size = UDim2.new(1, 0, 0, 0)
    list.BackgroundColor3 = T.Surface
    list.BackgroundTransparency = 0.2
    list.BorderSizePixel = 0
    list.ClipsDescendants = true
    list.ZIndex = 110
    SoftRound(list, 7)
    Stroke(list, T.Border, 1, 0.5)
    list.Parent = frame
    
    local ll = Instance.new("UIListLayout")
    ll.Parent = list
    
    local open = false
    
    for _, opt in ipairs(opts) do
        local ob = Instance.new("TextButton")
        ob.Size = UDim2.new(1, 0, 0, 26)
        ob.BackgroundColor3 = T.Surface
        ob.BackgroundTransparency = 0.3
        ob.Text = opt
        ob.TextColor3 = T.Text
        ob.TextSize = 10
        ob.Font = Enum.Font.Gotham
        ob.BorderSizePixel = 0
        ob.AutoButtonColor = false
        ob.ZIndex = 111
        ob.Parent = list
        ob.MouseButton1Click:Connect(function()
            row.Text = labelTxt..": "..opt.." ▾"
            open = false
            Tween(list, {Size = UDim2.new(1, 0, 0, 0)}, 0.15, Enum.EasingStyle.Quart)
        end)
    end
    
    row.MouseButton1Click:Connect(function()
        open = not open
        Tween(list, {Size = UDim2.new(1, 0, 0, open and #opts * 26 or 0)}, 0.18, Enum.EasingStyle.Quart)
    end)
end

Dropdown(wC, "Block Type", {"Part", "WedgePart", "CornerWedge", "TrussPart", "SpawnLocation"})
Dropdown(wC, "Material", {"SmoothPlastic", "Neon", "Glass", "Wood", "Granite", "DiamondPlate", "Metal"})
Dropdown(wC, "Color", {"Bright Red", "Bright Blue", "Bright Green", "Bright Yellow", "White", "Black", "Hot Pink"})
Slider(wC, "Block Size", 1, 50, 5)
Btn(wC, "🧱 Spawn Block", "primary")
Btn(wC, "🗑️ Delete Last Block", "danger")
Btn(wC, "💥 Clear All Blocks", "danger")

-- ---------- AVATAR ----------
local avC = Section(PgAva, "COPY AVATAR", "👤")
local avStatus = Lbl(avC, "Pilih player untuk copy tampilan.", 10, T.Muted)
avStatus.Size = UDim2.new(1, 0, 0, 18)
avStatus.ZIndex = 106

local avSF = Instance.new("ScrollingFrame")
avSF.Size = UDim2.new(1, 0, 0, 85)
avSF.BackgroundColor3 = T.SurfaceHi
avSF.BackgroundTransparency = 0.5
avSF.BorderSizePixel = 0
avSF.ScrollBarThickness = 4
avSF.ScrollBarImageColor3 = T.Primary
avSF.CanvasSize = UDim2.new(0, 0, 0, 0)
avSF.ZIndex = 105
SoftRound(avSF, 8)
Stroke(avSF, T.Border, 1, 0.5)
avSF.Parent = avC

local avLL = Instance.new("UIListLayout")
avLL.Padding = UDim.new(0, 4)
avLL.Parent = avSF

local function RefreshAvaList()
    for _, c in pairs(avSF:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    local n = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            n = n + 1
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -8, 0, 28)
            b.Position = UDim2.new(0, 4, 0, 0)
            b.BackgroundColor3 = T.Surface
            b.BackgroundTransparency = 0.3
            b.Text = p.Name
            b.TextColor3 = Color3.new(1, 1, 1)
            b.TextSize = 11
            b.Font = Enum.Font.Gotham
            b.BorderSizePixel = 0
            b.AutoButtonColor = false
            b.ZIndex = 106
            SoftRound(b, 6)
            Stroke(b, T.Border, 1, 0.5)
            b.Parent = avSF
            b.MouseButton1Click:Connect(function()
                for _, bb in pairs(avSF:GetChildren()) do
                    if bb:IsA("TextButton") then
                        Tween(bb, {BackgroundTransparency = 0.3}, 0.1)
                    end
                end
                Tween(b, {BackgroundTransparency = 0.1}, 0.12)
            end)
        end
    end
    avSF.CanvasSize = UDim2.new(0, 0, 0, n * 32)
end

RefreshAvaList()
Players.PlayerAdded:Connect(RefreshAvaList)
Players.PlayerRemoving:Connect(RefreshAvaList)

Btn(avC, "👤 Copy Avatar Target", "primary")
Btn(avC, "🔄 Restore My Avatar", "normal")

-- ---------- PRESETS ----------
local svC = Section(PgSave, "SAVE PRESET", "💾")

local preNameBox = Instance.new("TextBox")
preNameBox.Size = UDim2.new(1, 0, 0, 28)
preNameBox.BackgroundColor3 = T.SurfaceHi
preNameBox.BackgroundTransparency = 0.4
preNameBox.PlaceholderText = "Nama preset..."
preNameBox.Text = ""
preNameBox.TextColor3 = T.Text
preNameBox.TextSize = 11
preNameBox.Font = Enum.Font.Gotham
preNameBox.ClearTextOnFocus = false
preNameBox.ZIndex = 105
SoftRound(preNameBox, 7)
Stroke(preNameBox, T.Border, 1, 0.5)
preNameBox.Parent = svC

local preSF = Instance.new("ScrollingFrame")
preSF.Size = UDim2.new(1, 0, 0, 78)
preSF.BackgroundColor3 = T.SurfaceHi
preSF.BackgroundTransparency = 0.5
preSF.BorderSizePixel = 0
preSF.ScrollBarThickness = 4
preSF.ScrollBarImageColor3 = T.Primary
preSF.CanvasSize = UDim2.new(0, 0, 0, 0)
preSF.ZIndex = 105
SoftRound(preSF, 8)
Stroke(preSF, T.Border, 1, 0.5)
preSF.Parent = svC

local preLL = Instance.new("UIListLayout")
preLL.Padding = UDim.new(0, 4)
preLL.Parent = preSF

Btn(svC, "💾 Save Settings", "primary")

local exportBox = Instance.new("TextBox")
exportBox.Size = UDim2.new(1, 0, 0, 50)
exportBox.BackgroundColor3 = T.NavBg
exportBox.BackgroundTransparency = 0.5
exportBox.PlaceholderText = "Kode export akan muncul di sini..."
exportBox.Text = ""
exportBox.TextColor3 = T.Primary
exportBox.TextSize = 9
exportBox.Font = Enum.Font.Code
exportBox.MultiLine = true
exportBox.TextXAlignment = Enum.TextXAlignment.Left
exportBox.TextYAlignment = Enum.TextYAlignment.Top
exportBox.ClearTextOnFocus = false
exportBox.ZIndex = 105
SoftRound(exportBox, 7)
Stroke(exportBox, T.Border, 1, 0.5)
exportBox.Parent = svC

local importBox = Instance.new("TextBox")
importBox.Size = UDim2.new(1, 0, 0, 44)
importBox.BackgroundColor3 = T.NavBg
importBox.BackgroundTransparency = 0.5
importBox.PlaceholderText = "Paste kode import di sini..."
importBox.Text = ""
importBox.TextColor3 = T.Text
importBox.TextSize = 9
importBox.Font = Enum.Font.Code
importBox.MultiLine = true
importBox.TextXAlignment = Enum.TextXAlignment.Left
importBox.TextYAlignment = Enum.TextYAlignment.Top
importBox.ClearTextOnFocus = false
importBox.ZIndex = 105
SoftRound(importBox, 7)
Stroke(importBox, T.Border, 1, 0.5)
importBox.Parent = svC

Btn(svC, "📥 Import from Code", "normal")

-- ---------- ADMIN ----------
local adC = Section(PgAdmin, "ADMIN LOGIN", "🔐")
local adStatus = Lbl(adC, "🔒 Belum terautentikasi", 10, T.Muted)
adStatus.Size = UDim2.new(1, 0, 0, 18)
adStatus.ZIndex = 106

local pwBox = Instance.new("TextBox")
pwBox.Size = UDim2.new(1, 0, 0, 32)
pwBox.BackgroundColor3 = T.NavBg
pwBox.BackgroundTransparency = 0.5
pwBox.PlaceholderText = "Masukkan password..."
pwBox.Text = ""
pwBox.TextColor3 = T.Text
pwBox.TextSize = 12
pwBox.Font = Enum.Font.GothamBold
pwBox.ClearTextOnFocus = false
pwBox.ZIndex = 105
SoftRound(pwBox, 8)
Stroke(pwBox, T.Border, 1, 0.5)
pwBox.Parent = adC

Btn(adC, "🔓 Unlock Admin Mode", "admin")

-- ---------- UTILITY ----------
local utC = Section(PgUtil, "UTILITIES", "⚙️")
Toggle(utC, "Full Bright")
Toggle(utC, "Anti-AFK")
Toggle(utC, "Unlock Camera Zoom")
Toggle(utC, "FPS Boost")

local srC = Section(PgUtil, "SERVER", "🌐")
Btn(srC, "Rejoin Server", "primary")
Btn(srC, "Server Hop", "normal")

-- ====================================================================
-- ==================== ORB / MINIMIZE / CLOSE ========================
-- ====================================================================
local OrbBtn = Instance.new("TextButton")
OrbBtn.Size = UDim2.new(0, 50, 0, 50)
OrbBtn.Position = UDim2.new(0, 20, 0.5, -25)
OrbBtn.BackgroundColor3 = T.Primary
OrbBtn.BackgroundTransparency = 0.1
OrbBtn.Text = "AP"
OrbBtn.TextColor3 = Color3.new(1, 1, 1)
OrbBtn.TextSize = 16
OrbBtn.Font = Enum.Font.GothamBlack
OrbBtn.Visible = false
OrbBtn.ZIndex = 1000
OrbBtn.Active = true
OrbBtn.Draggable = true
OrbBtn.AutoButtonColor = false
Round(OrbBtn, 25)
Stroke(OrbBtn, T.Secondary, 2, 0.3)
OrbBtn.Parent = SG

MinBtn.MouseButton1Click:Connect(function()
    Tween(MF, {Size = UDim2.new(0, 480, 0, 0)}, 0.25, Enum.EasingStyle.Quart)
    wait(0.25)
    MF.Visible = false
    OrbBtn.Visible = true
    Tween(OrbBtn, {Size = UDim2.new(0, 50, 0, 50)}, 0.3, Enum.EasingStyle.Back)
end)

OrbBtn.MouseButton1Click:Connect(function()
    OrbBtn.Visible = false
    MF.Visible = true
    Tween(MF, {Size = UDim2.new(0, 480, 0, 330)}, 0.35, Enum.EasingStyle.Back)
end)

CloseBtn.MouseButton1Click:Connect(function()
    Tween(MF, {Size = UDim2.new(0, 0, 0, 0)}, 0.25, Enum.EasingStyle.Quart)
    wait(0.25)
    SG:Destroy()
    pcall(function() OrbBtn:Destroy() end)
end)

-- ====================================================================
-- ==================== OPENING ANIMATION =============================
-- ====================================================================
spawn(function()
    -- Logo fade in
    TweenWait(LogoImg, {ImageTransparency = 0}, 0.8, Enum.EasingStyle.Quint)
    wait(0.1)
    
    -- Title slide up
    TweenWait(TitleLbl, {TextTransparency = 0, Position = UDim2.new(0.5, -200, 0.5, 70)}, 0.6, Enum.EasingStyle.Quart)
    
    -- Subtitle fade
    TweenWait(SubtitleLbl, {TextTransparency = 0.2}, 0.5, Enum.EasingStyle.Quart)
    
    -- Version fade
    TweenWait(VersionLbl, {TextTransparency = 0.3}, 0.4, Enum.EasingStyle.Quart)
    
    -- Loading bar animation
    TweenWait(LoadBarFill, {Size = UDim2.new(0.7, 0, 1, 0)}, 1.2, Enum.EasingStyle.Quart)
    wait(0.3)
    
    -- Fade out opening
    TweenWait(OpeningFrame, {BackgroundTransparency = 1}, 0.5, Enum.EasingStyle.Quart)
    wait(0.1)
    OpeningFrame:Destroy()
    
    -- Show main UI
    MF.Visible = true
    GoPage("Dash")
    wait(0.05)
    
    -- Main UI slide in animation
    Tween(MF, {Size = UDim2.new(0, 480, 0, 330)}, 0.5, Enum.EasingStyle.Back)
end)

-- ==================== MINIMIZE ICON HOVER EFFECT ====================
MinBtn.MouseEnter:Connect(function()
    Tween(MinIcon, {ImageColor3 = T.Primary}, 0.15)
end)

MinBtn.MouseLeave:Connect(function()
    Tween(MinIcon, {ImageColor3 = T.Muted}, 0.15)
end)
