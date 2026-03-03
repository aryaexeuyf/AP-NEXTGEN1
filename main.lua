--[[
    AP-NEXTGEN v10.1 – STABLE PREMIUM UI
    Fixed: Crash & Loading Issues
    By APTECH
]]

-- Services
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local RunService       = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- ==================== OPTIMIZED THEME ====================
local T = {
    Bg        = Color3.fromRGB(8, 12, 28),
    Surface   = Color3.fromRGB(15, 25, 50),
    SurfaceHi = Color3.fromRGB(25, 40, 75),
    NavBg     = Color3.fromRGB(12, 20, 40),
    Primary   = Color3.fromRGB(0, 150, 255),
    Secondary = Color3.fromRGB(255, 200, 50),
    Success   = Color3.fromRGB(0, 230, 120),
    Warning   = Color3.fromRGB(255, 180, 0),
    Error     = Color3.fromRGB(255, 60, 80),
    Text      = Color3.fromRGB(245, 245, 255),
    Muted     = Color3.fromRGB(150, 170, 200),
    GoldText  = Color3.fromRGB(255, 215, 100),
    Border    = Color3.fromRGB(0, 200, 255),
}

-- ==================== SIMPLE HELPERS ====================
local ActiveTweens = {} -- Track tweens for cleanup

local function Tween(obj, props, dur, style)
    -- Cleanup existing tween for this object
    if ActiveTweens[obj] then
        ActiveTweens[obj]:Cancel()
    end
    
    local tween = TweenService:Create(obj, TweenInfo.new(dur or 0.3, style or Enum.EasingStyle.Quart), props)
    ActiveTweens[obj] = tween
    
    tween.Completed:Connect(function()
        ActiveTweens[obj] = nil
    end)
    
    tween:Play()
    return tween
end

local function Round(inst, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 12)
    c.Parent = inst
    return c
end

local function Stroke(inst, col, th)
    local s = Instance.new("UIStroke")
    s.Color = col or T.Border
    s.Thickness = th or 1
    s.Transparency = 0.4
    s.Parent = inst
    return s
end

local function Lbl(parent, text, size, color, font, align)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextSize = size or 12
    l.TextColor3 = color or T.Text
    l.Font = font or Enum.Font.GothamSemibold
    l.TextXAlignment = align or Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

-- ==================== SCREENGUI ====================
local SG = Instance.new("ScreenGui")
SG.Name = "APNEXTGEN_STABLE"
SG.Parent = CoreGui
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.DisplayOrder = 999

-- ==================== SIMPLIFIED OPENING ====================
local IntroFrame = Instance.new("Frame")
IntroFrame.Name = "Intro"
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.BackgroundColor3 = T.Bg
IntroFrame.BorderSizePixel = 0
IntroFrame.ZIndex = 1000
IntroFrame.Parent = SG

-- Simple gradient (no image)
local IntroGrad = Instance.new("UIGradient")
IntroGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 12, 28)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 40, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 12, 28))
})
IntroGrad.Rotation = 45
IntroGrad.Parent = IntroFrame

-- Logo Container (simplified)
local LogoContainer = Instance.new("Frame")
LogoContainer.Size = UDim2.new(0, 180, 0, 180)
LogoContainer.Position = UDim2.new(0.5, -90, 0.4, -90)
LogoContainer.BackgroundTransparency = 1
LogoContainer.Parent = IntroFrame

-- Glow circle (frame based, no image)
local GlowCircle = Instance.new("Frame")
GlowCircle.Size = UDim2.new(1.2, 0, 1.2, 0)
GlowCircle.Position = UDim2.new(-0.1, 0, -0.1, 0)
GlowCircle.BackgroundColor3 = T.Primary
GlowCircle.BackgroundTransparency = 0.9
Round(GlowCircle, 100)
GlowCircle.Parent = LogoContainer

-- Logo Text
local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(1, 0, 0.5, 0)
LogoText.Position = UDim2.new(0, 0, 0.1, 0)
LogoText.BackgroundTransparency = 1
LogoText.Text = "AP"
LogoText.TextSize = 64
LogoText.Font = Enum.Font.GothamBlack
LogoText.TextColor3 = T.Secondary
LogoText.TextStrokeTransparency = 0.9
LogoText.TextStrokeColor3 = T.Primary
LogoText.Parent = LogoContainer

local VersionText = Instance.new("TextLabel")
VersionText.Size = UDim2.new(1, 0, 0.2, 0)
VersionText.Position = UDim2.new(0, 0, 0.6, 0)
VersionText.BackgroundTransparency = 1
VersionText.Text = "NEXTGEN1"
VersionText.TextSize = 24
VersionText.Font = Enum.Font.GothamBold
VersionText.TextColor3 = T.Primary
VersionText.Parent = LogoContainer

local AptechText = Instance.new("TextLabel")
AptechText.Size = UDim2.new(1, 0, 0.15, 0)
AptechText.Position = UDim2.new(0, 0, 0.8, 0)
AptechText.BackgroundTransparency = 1
AptechText.Text = "By APTECH"
AptechText.TextSize = 12
AptechText.Font = Enum.Font.GothamSemibold
AptechText.TextColor3 = T.Muted
AptechText.Parent = LogoContainer

-- Loading bar
local LoadBg = Instance.new("Frame")
LoadBg.Size = UDim2.new(0, 250, 0, 3)
LoadBg.Position = UDim2.new(0.5, -125, 0.65, 0)
LoadBg.BackgroundColor3 = Color3.fromRGB(40, 50, 80)
LoadBg.BorderSizePixel = 0
Round(LoadBg, 2)
LoadBg.Parent = IntroFrame

local LoadFill = Instance.new("Frame")
LoadFill.Size = UDim2.new(0, 0, 1, 0)
LoadFill.BackgroundColor3 = T.Secondary
LoadFill.BorderSizePixel = 0
Round(LoadFill, 2)
LoadFill.Parent = LoadBg

local LoadText = Lbl(IntroFrame, "Initializing...", 11, T.Muted)
LoadText.Size = UDim2.new(0, 200, 0, 20)
LoadText.Position = UDim2.new(0.5, -100, 0.68, 0)
LoadText.TextAlignment = Enum.TextXAlignment.Center

-- ==================== MAIN FRAME ====================
local MF = Instance.new("Frame")
MF.Name = "MainFrame"
MF.Size = UDim2.new(0, 480, 0, 300)
MF.Position = UDim2.new(0.5, -240, 0.5, -150)
MF.BackgroundColor3 = T.Surface
MF.BackgroundTransparency = 0.1
MF.BorderSizePixel = 0
MF.ClipsDescendants = true
MF.Active = true
MF.Visible = false
MF.ZIndex = 10
Round(MF, 14)
Stroke(MF, T.Primary, 2)

-- Background Image Placeholder (user isi nanti)
local BgImage = Instance.new("ImageLabel")
BgImage.Name = "BgImage"
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.BackgroundTransparency = 1
BgImage.Image = "" -- USER ISI: data:image/png;base64,...
BgImage.ImageTransparency = 0.5
BgImage.ZIndex = 1
BgImage.Parent = MF

-- Glass overlay
local GlassOverlay = Instance.new("Frame")
GlassOverlay.Size = UDim2.new(1, 0, 1, 0)
GlassOverlay.BackgroundColor3 = T.Bg
GlassOverlay.BackgroundTransparency = 0.5
GlassOverlay.ZIndex = 2
GlassOverlay.Parent = MF

MF.Parent = SG

-- ==================== TOP BAR ====================
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = T.SurfaceHi
TopBar.BackgroundTransparency = 0.1
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 20
Round(TopBar, 14)

-- Fix bottom
local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 14)
TopFix.Position = UDim2.new(0, 0, 1, -14)
TopFix.BackgroundColor3 = T.SurfaceHi
TopFix.BackgroundTransparency = 0.1
TopFix.BorderSizePixel = 0
TopFix.ZIndex = 19
TopFix.Parent = TopBar

TopBar.Parent = MF

-- Avatar
local AvImg = Instance.new("ImageLabel")
AvImg.Size = UDim2.new(0, 28, 0, 28)
AvImg.Position = UDim2.new(0, 10, 0.5, -14)
AvImg.BackgroundColor3 = T.SurfaceHi
AvImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=150&height=150&format=png"
AvImg.ZIndex = 22
Round(AvImg, 14)
AvImg.Parent = TopBar

-- User Info
local NameLbl = Lbl(TopBar, LocalPlayer.Name, 12, T.Text, Enum.Font.GothamBold)
NameLbl.Size = UDim2.new(0, 100, 0, 14)
NameLbl.Position = UDim2.new(0, 44, 0, 4)
NameLbl.ZIndex = 22
NameLbl.TextTruncate = Enum.TextTruncate.AtEnd

local GameLbl = Lbl(TopBar, "AP-NEXTGEN v10.1", 9, T.GoldText)
GameLbl.Size = UDim2.new(0, 100, 0, 12)
GameLbl.Position = UDim2.new(0, 44, 0, 20)
GameLbl.ZIndex = 22

-- Title Center
local TitleText = Lbl(TopBar, "🌟 AP-NEXTGEN PREMIUM", 13, T.Text, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
TitleText.Size = UDim2.new(0, 200, 0, 20)
TitleText.Position = UDim2.new(0.5, -100, 0.5, -10)
TitleText.ZIndex = 22

-- Server Info
local SrvLbl = Lbl(TopBar, "🌐 Loading...", 9, T.Primary, Enum.Font.GothamSemibold, Enum.TextXAlignment.Right)
SrvLbl.Size = UDim2.new(0, 150, 0, 14)
SrvLbl.Position = UDim2.new(1, -210, 0.5, -7)
SrvLbl.ZIndex = 22

-- Controls
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 26, 0, 22)
MinBtn.Position = UDim2.new(1, -56, 0.5, -11)
MinBtn.BackgroundColor3 = T.SurfaceHi
MinBtn.Text = "−"
MinBtn.TextColor3 = T.Muted
MinBtn.TextSize = 16
MinBtn.Font = Enum.Font.GothamBold
MinBtn.ZIndex = 23
MinBtn.AutoButtonColor = false
Round(MinBtn, 6)
MinBtn.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 22)
CloseBtn.Position = UDim2.new(1, -28, 0.5, -11)
CloseBtn.BackgroundColor3 = T.Error
CloseBtn.BackgroundTransparency = 0.2
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 23
CloseBtn.AutoButtonColor = false
Round(CloseBtn, 6)
CloseBtn.Parent = TopBar

-- ==================== NAVIGATION ====================
local NavFrame = Instance.new("ScrollingFrame")
NavFrame.Size = UDim2.new(0, 55, 1, -38)
NavFrame.Position = UDim2.new(0, 0, 0, 38)
NavFrame.BackgroundColor3 = T.NavBg
NavFrame.BackgroundTransparency = 0.2
NavFrame.BorderSizePixel = 0
NavFrame.ScrollBarThickness = 0
NavFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
NavFrame.ZIndex = 15
NavFrame.Parent = MF

local NavLL = Instance.new("UIListLayout")
NavLL.Padding = UDim.new(0, 3)
NavLL.HorizontalAlignment = Enum.HorizontalAlignment.Center
NavLL.Parent = NavFrame

local NavPad = Instance.new("UIPadding")
NavPad.PaddingTop = UDim.new(0, 6)
NavPad.PaddingLeft = UDim.new(0, 3)
NavPad.PaddingRight = UDim.new(0, 3)
NavPad.Parent = NavFrame

-- Gold accent
local NavAccent = Instance.new("Frame")
NavAccent.Size = UDim2.new(0, 2, 1, 0)
NavAccent.Position = UDim2.new(1, -2, 0, 0)
NavAccent.BackgroundColor3 = T.Secondary
NavAccent.BackgroundTransparency = 0.5
NavAccent.ZIndex = 16
NavAccent.Parent = NavFrame

-- ==================== CONTENT AREA ====================
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -60, 1, -44)
ContentArea.Position = UDim2.new(0, 58, 0, 42)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.ZIndex = 15
ContentArea.Parent = MF

-- ==================== PAGE SYSTEM ====================
local Pages = {}
local NavBtns = {}
local ActiveTab = nil

local function NewPage(name)
    local sf = Instance.new("ScrollingFrame")
    sf.Name = name
    sf.Size = UDim2.new(1, 0, 1, 0)
    sf.BackgroundTransparency = 1
    sf.BorderSizePixel = 0
    sf.ScrollBarThickness = 3
    sf.ScrollBarImageColor3 = T.Secondary
    sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sf.Visible = false
    sf.ZIndex = 16
    sf.Parent = ContentArea

    local ll = Instance.new("UIListLayout")
    ll.Padding = UDim.new(0, 6)
    ll.Parent = sf
    
    local pd = Instance.new("UIPadding")
    pd.Padding = UDim.new(0, 6)
    pd.Parent = sf

    Pages[name] = sf
    return sf
end

local function GoPage(name)
    -- Simple fade transition
    for n, pg in pairs(Pages) do
        if pg.Visible and n ~= name then
            pg.Visible = false
        end
    end
    
    local target = Pages[name]
    if target then
        target.Visible = true
        target.CanvasPosition = Vector2.new(0, 0) -- Reset scroll
    end
    
    -- Update nav
    for n, btn in pairs(NavBtns) do
        if n == name then
            Tween(btn, {BackgroundColor3 = T.Primary}, 0.2)
            btn.Icon.TextColor3 = Color3.new(1,1,1)
            btn.Selected = true
        else
            Tween(btn, {BackgroundColor3 = T.NavBg}, 0.2)
            btn.Icon.TextColor3 = T.Muted
            btn.Selected = false
        end
    end
    
    ActiveTab = name
end

local function NavBtn(icon, pageName)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 46, 0, 40)
    b.BackgroundColor3 = T.NavBg
    b.BackgroundTransparency = 0.5
    b.Text = ""
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.ZIndex = 17
    b.Selected = false
    Round(b, 8)
    
    local ic = Instance.new("TextLabel")
    ic.Name = "Icon"
    ic.Size = UDim2.new(1, 0, 1, 0)
    ic.BackgroundTransparency = 1
    ic.Text = icon
    ic.TextColor3 = T.Muted
    ic.TextSize = 16
    ic.Font = Enum.Font.GothamBold
    ic.ZIndex = 18
    ic.Parent = b
    
    b.Parent = NavFrame
    NavBtns[pageName] = b
    
    b.MouseButton1Click:Connect(function()
        GoPage(pageName)
    end)
    
    return b
end

-- ==================== COMPONENTS ====================
local function Section(parent, title)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = T.SurfaceHi
    card.BackgroundTransparency = 0.3
    card.BorderSizePixel = 0
    card.ZIndex = 20
    Round(card, 10)
    Stroke(card, T.Border, 1)
    
    local ttl = Lbl(card, "✦ "..title, 11, T.GoldText, Enum.Font.GothamBold)
    ttl.Size = UDim2.new(1, -12, 0, 24)
    ttl.Position = UDim2.new(0, 10, 0, 4)
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, -20, 0, 1)
    line.Position = UDim2.new(0, 10, 0, 26)
    line.BackgroundColor3 = T.Border
    line.BackgroundTransparency = 0.5
    line.BorderSizePixel = 0
    line.ZIndex = 21
    line.Parent = card
    
    local cont = Instance.new("Frame")
    cont.Name = "Content"
    cont.Size = UDim2.new(1, -12, 0, 0)
    cont.Position = UDim2.new(0, 6, 0, 32)
    cont.AutomaticSize = Enum.AutomaticSize.Y
    cont.BackgroundTransparency = 1
    cont.ZIndex = 21
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
    row.Size = UDim2.new(1, 0, 0, 28)
    row.BackgroundTransparency = 1
    row.ZIndex = 22
    row.Parent = parent
    
    local lbl = Lbl(row, text, 10, T.Text)
    lbl.Size = UDim2.new(0.6, 0, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 44, 0, 20)
    btn.Position = UDim2.new(1, -48, 0.5, -10)
    btn.BackgroundColor3 = Color3.fromRGB(40, 50, 80)
    btn.Text = "OFF"
    btn.TextColor3 = T.Muted
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBlack
    btn.AutoButtonColor = false
    btn.ZIndex = 23
    Round(btn, 10)
    btn.Parent = row
    
    local on = false
    btn.MouseButton1Click:Connect(function()
        on = not on
        btn.Text = on and "ON" or "OFF"
        Tween(btn, {BackgroundColor3 = on and T.Success or Color3.fromRGB(40, 50, 80)}, 0.2)
        btn.TextColor3 = on and Color3.new(1,1,1) or T.Muted
        if _callback then _callback(on) end
    end)
    
    return btn
end

local function Slider(parent, text, min, max, default, _callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 46)
    frame.BackgroundTransparency = 1
    frame.ZIndex = 22
    frame.Parent = parent
    
    local topRow = Instance.new("Frame")
    topRow.Size = UDim2.new(1, 0, 0, 18)
    topRow.BackgroundTransparency = 1
    topRow.Parent = frame
    
    local lbl = Lbl(topRow, text, 10, T.Text)
    lbl.Size = UDim2.new(0.6, 0, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    
    local vbox = Instance.new("TextBox")
    vbox.Size = UDim2.new(0, 45, 0, 18)
    vbox.Position = UDim2.new(1, -49, 0, 0)
    vbox.BackgroundColor3 = T.Surface
    vbox.BackgroundTransparency = 0.3
    vbox.Text = tostring(default)
    vbox.TextColor3 = T.Secondary
    vbox.TextSize = 10
    vbox.Font = Enum.Font.GothamBold
    vbox.ClearTextOnFocus = false
    vbox.ZIndex = 23
    Round(vbox, 4)
    vbox.Parent = topRow
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -16, 0, 4)
    track.Position = UDim2.new(0, 8, 0, 32)
    track.BackgroundColor3 = Color3.fromRGB(35, 45, 70)
    track.BorderSizePixel = 0
    track.ZIndex = 22
    Round(track, 2)
    track.Parent = frame
    
    local pct = (default - min) / math.max(max - min, 1)
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = T.Primary
    fill.BorderSizePixel = 0
    fill.ZIndex = 23
    Round(fill, 2)
    fill.Parent = track
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(pct, -7, 0.5, -7)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.ZIndex = 24
    Round(knob, 7)
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
            dragging = true; doUpdate(i)
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
             or style == "gold" and T.Secondary
             or T.SurfaceHi
    
    local txtCol = style == "gold" and Color3.new(0.1, 0.08, 0) or Color3.new(1, 1, 1)
    
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 28)
    b.BackgroundColor3 = col
    b.BackgroundTransparency = 0.15
    b.Text = text
    b.TextColor3 = txtCol
    b.TextSize = 11
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.ZIndex = 23
    Round(b, 6)
    b.Parent = parent
    
    b.MouseEnter:Connect(function()
        Tween(b, {BackgroundTransparency = 0}, 0.15)
    end)
    b.MouseLeave:Connect(function()
        Tween(b, {BackgroundTransparency = 0.15}, 0.15)
    end)
    
    b.MouseButton1Click:Connect(function()
        Tween(b, {Size = UDim2.new(0.98, 0, 0, 26)}, 0.08)
        task.delay(0.08, function()
            if b and b.Parent then
                Tween(b, {Size = UDim2.new(1, 0, 0, 28)}, 0.12)
            end
        end)
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

-- ==================== PAGE CONTENT ====================
-- DASHBOARD
local dsC = Section(PgDash, "Server Monitor")
local plrC = Section(PgDash, "Player Info")

local function StatRow(parent, label, value, valColor)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 22)
    row.BackgroundTransparency = 1
    row.ZIndex = 23
    row.Parent = parent
    
    local l = Lbl(row, label, 10, T.Muted)
    l.Size = UDim2.new(0.5, 0, 1, 0)
    l.Position = UDim2.new(0, 8, 0, 0)
    
    local v = Lbl(row, value, 10, valColor or T.Primary, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
    v.Size = UDim2.new(0.5, 0, 1, 0)
    v.Position = UDim2.new(0.5, -8, 0, 0)
    
    return v
end

StatRow(dsC, "Game:", game.Name:sub(1, 20), T.GoldText)
StatRow(dsC, "Place ID:", tostring(game.PlaceId), T.Primary)
local sPly = StatRow(dsC, "Players:", "--/--", T.Success)
StatRow(dsC, "Server:", "Premium Node", T.Warning)

StatRow(plrC, "Username:", LocalPlayer.Name, T.GoldText)
StatRow(plrC, "User ID:", tostring(LocalPlayer.UserId), T.Primary)
StatRow(plrC, "Display:", LocalPlayer.DisplayName, T.Text)
StatRow(plrC, "Account Age:", LocalPlayer.AccountAge.." days", T.Success)

-- MOVEMENT
local mvC = Section(PgMove, "Speed Control")
Slider(mvC, "Walk Speed", 1, 500, 16)
Slider(mvC, "Jump Power", 1, 500, 50)
Btn(mvC, "Reset to Default", "primary")

local jC = Section(PgMove, "Jump Settings")
Toggle(jC, "Infinite Jump")
Toggle(jC, "Auto Jump")

local gC = Section(PgMove, "Gravity")
Toggle(gC, "Low Gravity")
Slider(gC, "Gravity Value", 0, 196, 196)

-- FLY
local flyC = Section(PgFly, "Flight Control")
local spdRow = Instance.new("Frame")
spdRow.Size = UDim2.new(1, 0, 0, 30)
spdRow.BackgroundTransparency = 1
spdRow.Parent = flyC

Lbl(spdRow, "Fly Speed:", 11, T.Text).Size = UDim2.new(0.3, 0, 1, 0)
local flyDisp = Lbl(spdRow, "50", 12, T.Secondary, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
flyDisp.Size = UDim2.new(0, 40, 0, 24)
flyDisp.Position = UDim2.new(0.35, 0, 0.5, -12)
flyDisp.BackgroundColor3 = T.Surface
flyDisp.BackgroundTransparency = 0.5
Round(flyDisp, 6)

Btn(flyC, "✈️ ACTIVATE FLIGHT", "gold")
Toggle(flyC, "No Clip Mode")

-- ESP
local espC = Section(PgESP, "Player ESP")
Toggle(espC, "Enable ESP")
Toggle(espC, "Show Distance")
Toggle(espC, "Show Health")

local espV2C = Section(PgESP, "Premium ESP")
Lbl(espV2C, "🔒 Requires Admin", 10, T.Warning)
Toggle(espV2C, "Advanced ESP V2")

-- TELEPORT
local tpC = Section(PgTP, "Player Teleport")

local tpSF = Instance.new("ScrollingFrame")
tpSF.Size = UDim2.new(1, 0, 0, 90)
tpSF.BackgroundColor3 = T.Surface
tpSF.BackgroundTransparency = 0.5
tpSF.BorderSizePixel = 0
tpSF.ScrollBarThickness = 3
tpSF.CanvasSize = UDim2.new(0, 0, 0, 0)
tpSF.ZIndex = 23
Round(tpSF, 6)
tpSF.Parent = tpC

local tpLL = Instance.new("UIListLayout")
tpLL.Padding = UDim.new(0, 3)
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
            b.Size = UDim2.new(1, -8, 0, 26)
            b.Position = UDim2.new(0, 4, 0, 0)
            b.BackgroundColor3 = T.SurfaceHi
            b.BackgroundTransparency = 0.6
            b.Text = p.Name
            b.TextColor3 = T.Text
            b.TextSize = 11
            b.Font = Enum.Font.GothamSemibold
            b.BorderSizePixel = 0
            b.AutoButtonColor = false
            b.ZIndex = 24
            Round(b, 5)
            b.Parent = tpSF
        end
    end
    tpSF.CanvasSize = UDim2.new(0, 0, 0, n * 29)
end

RefreshTPList()
Players.PlayerAdded:Connect(RefreshTPList)
Players.PlayerRemoving:Connect(RefreshTPList)

Btn(tpC, "Teleport to Selected", "primary")
Toggle(tpC, "Follow Player")

-- GOD MODE
local godC = Section(PgGod, "Immortality")
Toggle(godC, "God Mode")
Toggle(godC, "Auto Heal")
Slider(godC, "Heal Interval", 0.1, 5, 0.2)
Btn(godC, "💚 Heal Instantly", "success")

-- WORLD
local wC = Section(PgWorld, "Block Spawner")
Btn(wC, "🧱 Spawn Block", "primary")
Btn(wC, "💥 Clear All", "danger")

-- AVATAR
local avC = Section(PgAva, "Avatar Copy")
local avStatus = Lbl(avC, "Select player to copy", 10, T.Muted)

local avSF = Instance.new("ScrollingFrame")
avSF.Size = UDim2.new(1, 0, 0, 90)
avSF.BackgroundColor3 = T.Surface
avSF.BackgroundTransparency = 0.5
avSF.BorderSizePixel = 0
avSF.ScrollBarThickness = 3
avSF.CanvasSize = UDim2.new(0, 0, 0, 0)
avSF.ZIndex = 23
Round(avSF, 6)
avSF.Parent = avC

local avLL = Instance.new("UIListLayout")
avLL.Padding = UDim.new(0, 3)
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
            b.Size = UDim2.new(1, -8, 0, 26)
            b.BackgroundColor3 = T.SurfaceHi
            b.BackgroundTransparency = 0.6
            b.Text = p.Name
            b.TextColor3 = T.Text
            b.TextSize = 11
            b.Font = Enum.Font.GothamSemibold
            b.BorderSizePixel = 0
            b.AutoButtonColor = false
            b.ZIndex = 24
            Round(b, 5)
            b.Parent = avSF
        end
    end
    avSF.CanvasSize = UDim2.new(0, 0, 0, n * 29)
end

RefreshAvaList()
Players.PlayerAdded:Connect(RefreshAvaList)
Players.PlayerRemoving:Connect(RefreshAvaList)

Btn(avC, "👤 Copy Selected", "primary")
Btn(avC, "🔄 Restore Avatar", "normal")

-- SAVE
local svC = Section(PgSave, "Configuration")

local preNameBox = Instance.new("TextBox")
preNameBox.Size = UDim2.new(1, 0, 0, 28)
preNameBox.BackgroundColor3 = T.Surface
preNameBox.BackgroundTransparency = 0.4
preNameBox.PlaceholderText = "Preset name..."
preNameBox.Text = ""
preNameBox.TextColor3 = T.Text
preNameBox.TextSize = 11
preNameBox.Font = Enum.Font.Gotham
preNameBox.ClearTextOnFocus = false
preNameBox.ZIndex = 24
Round(preNameBox, 6)
preNameBox.Parent = svC

Btn(svC, "💾 Save Settings", "success")

local exportBox = Instance.new("TextBox")
exportBox.Size = UDim2.new(1, 0, 0, 50)
exportBox.BackgroundColor3 = T.NavBg
exportBox.BackgroundTransparency = 0.3
exportBox.PlaceholderText = "Export code..."
exportBox.Text = ""
exportBox.TextColor3 = T.Secondary
exportBox.TextSize = 9
exportBox.Font = Enum.Font.Code
exportBox.MultiLine = true
exportBox.ClearTextOnFocus = false
exportBox.ZIndex = 24
Round(exportBox, 4)
exportBox.Parent = svC

Btn(svC, "📥 Import", "primary")

-- ADMIN
local adC = Section(PgAdmin, "Authentication")
Lbl(adC, "🔒 Status: Not Authenticated", 11, T.Error)

local pwBox = Instance.new("TextBox")
pwBox.Size = UDim2.new(1, 0, 0, 32)
pwBox.BackgroundColor3 = T.Surface
pwBox.BackgroundTransparency = 0.3
pwBox.PlaceholderText = "Admin password..."
pwBox.Text = ""
pwBox.TextColor3 = T.Text
pwBox.TextSize = 11
pwBox.Font = Enum.Font.GothamSemibold
pwBox.ClearTextOnFocus = false
pwBox.ZIndex = 24
Round(pwBox, 6)
Stroke(pwBox, T.Secondary, 1)
pwBox.Parent = adC

Btn(adC, "🔓 Unlock Admin", "gold")

-- UTILITIES
local utC = Section(PgUtil, "Performance")
Toggle(utC, "Full Bright")
Toggle(utC, "Anti-AFK")
Toggle(utC, "Unlock Zoom")
Toggle(utC, "FPS Boost")

local srC = Section(PgUtil, "Server")
Btn(srC, "🔄 Rejoin", "primary")
Btn(srC, "🌐 Server Hop", "normal")

-- ==================== MINIMIZE BUTTON (ROUNDED SQUARE) ====================
local OrbBtn = Instance.new("ImageButton")
OrbBtn.Name = "MinimizeOrb"
OrbBtn.Size = UDim2.new(0, 50, 0, 50)
OrbBtn.Position = UDim2.new(0, 20, 0.5, -25)
OrbBtn.BackgroundColor3 = T.SurfaceHi
OrbBtn.BackgroundTransparency = 0.2
OrbBtn.Image = "" -- USER ISI: data:image/png;base64,...
OrbBtn.ImageColor3 = Color3.new(1, 1, 1)
OrbBtn.Visible = false
OrbBtn.ZIndex = 100
OrbBtn.Active = true
OrbBtn.AutoButtonColor = false

-- Rounded square (squircle)
Round(OrbBtn, 14)
Stroke(OrbBtn, T.Secondary, 2)

-- Simple glow (frame based)
local orbGlow = Instance.new("Frame")
orbGlow.Size = UDim2.new(1.3, 0, 1.3, 0)
orbGlow.Position = UDim2.new(-0.15, 0, -0.15, 0)
orbGlow.BackgroundColor3 = T.Primary
orbGlow.BackgroundTransparency = 0.9
Round(orbGlow, 18)
orbGlow.ZIndex = 99
orbGlow.Parent = OrbBtn

OrbBtn.Parent = SG

-- ==================== DRAG SYSTEM ====================
local dragObj, dragStart, startPos = nil, nil, nil

local function setupDrag(obj)
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragObj = obj
            dragStart = input.Position
            startPos = MF.Position
        end
    end)
end

setupDrag(TopBar)
setupDrag(OrbBtn)

UserInputService.InputChanged:Connect(function(input)
    if dragObj and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MF.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragObj = nil
    end
end)

-- ==================== BUTTON FUNCTIONALITY ====================
MinBtn.MouseButton1Click:Connect(function()
    Tween(MF, {Size = UDim2.new(0, 480, 0, 0)}, 0.25)
    task.delay(0.25, function()
        if MF and MF.Parent then
            MF.Visible = false
            OrbBtn.Visible = true
            Tween(OrbBtn, {Size = UDim2.new(0, 50, 0, 50)}, 0.3, Enum.EasingStyle.Back)
        end
    end)
end)

OrbBtn.MouseButton1Click:Connect(function()
    Tween(OrbBtn, {Size = UDim2.new(0, 0, 0, 0)}, 0.15)
    task.delay(0.15, function()
        if OrbBtn and OrbBtn.Parent then
            OrbBtn.Visible = false
            MF.Visible = true
            MF.Size = UDim2.new(0, 480, 0, 0)
            Tween(MF, {Size = UDim2.new(0, 480, 0, 300)}, 0.4, Enum.EasingStyle.Back)
        end
    end)
end)

CloseBtn.MouseButton1Click:Connect(function()
    -- Cleanup tweens
    for obj, tween in pairs(ActiveTweens) do
        if tween then tween:Cancel() end
    end
    ActiveTweens = {}
    
    Tween(MF, {BackgroundTransparency = 1}, 0.15)
    task.delay(0.2, function()
        if SG and SG.Parent then
            SG:Destroy()
        end
    end)
end)

-- Hover effects
MinBtn.MouseEnter:Connect(function()
    Tween(MinBtn, {BackgroundColor3 = T.Primary}, 0.15)
    MinBtn.TextColor3 = Color3.new(1,1,1)
end)
MinBtn.MouseLeave:Connect(function()
    Tween(MinBtn, {BackgroundColor3 = T.SurfaceHi}, 0.15)
    MinBtn.TextColor3 = T.Muted
end)

CloseBtn.MouseEnter:Connect(function()
    Tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(255, 80, 100)}, 0.15)
end)
CloseBtn.MouseLeave:Connect(function()
    Tween(CloseBtn, {BackgroundColor3 = T.Error}, 0.15)
end)

-- ==================== SERVER INFO ====================
task.spawn(function()
    while SrvLbl and SrvLbl.Parent do
        local success, pc, mp = pcall(function()
            return #Players:GetPlayers(), Players.MaxPlayers
        end)
        if success then
            SrvLbl.Text = "🌐 Global | "..pc.."/"..mp
        end
        task.wait(5) -- Use task.wait instead of wait
    end
end)

-- ==================== OPENING ANIMATION (SIMPLIFIED) ====================
task.spawn(function()
    -- Initial states
    MF.Visible = false
    OrbBtn.Visible = false
    IntroFrame.Visible = true
    
    -- Animate logo (simplified, no spawn/wait spam)
    LogoContainer.Position = UDim2.new(0.5, -90, 0.35, -90)
    
    -- Single tween for logo
    Tween(LogoContainer, {Position = UDim2.new(0.5, -90, 0.4, -90)}, 0.6, Enum.EasingStyle.Back)
    Tween(GlowCircle, {BackgroundTransparency = 0.8}, 0.8)
    
    task.wait(0.4)
    
    -- Loading steps (simplified)
    local steps = {"Loading...", "Connecting...", "Ready!"}
    for i, step in ipairs(steps) do
        LoadText.Text = step
        Tween(LoadFill, {Size = UDim2.new(i/#steps, 0, 1, 0)}, 0.3)
        task.wait(0.4)
    end
    
    task.wait(0.2)
    
    -- Fade out intro
    Tween(IntroFrame, {BackgroundTransparency = 1}, 0.3)
    Tween(LogoContainer, {Position = UDim2.new(0.5, -90, 0.3, -90)}, 0.3)
    
    -- Hide intro elements
    for _, v in pairs({LoadBg, LoadFill, LoadText, LogoText, VersionText, AptechText}) do
        if v then v.Visible = false end
    end
    
    task.wait(0.3)
    IntroFrame.Visible = false
    
    -- Show main UI
    MF.Visible = true
    MF.Size = UDim2.new(0, 0, 0, 0)
    MF.BackgroundTransparency = 0.1
    
    Tween(MF, {Size = UDim2.new(0, 480, 0, 300)}, 0.5, Enum.EasingStyle.Back)
    
    task.wait(0.2)
    GoPage("Dash")
end)

print("✨ AP-NEXTGEN v10.1 Stable Loaded | By APTECH")
