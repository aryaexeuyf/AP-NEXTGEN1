--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║          AP-NEXTGEN v9.0  –  UI REDESIGN EDITION            ║
    ║                  Script by APTECH                           ║
    ║          Tema: Biru × Kuning | Transparan | Smooth          ║
    ╚══════════════════════════════════════════════════════════════╝
    Semua fungsi dikosongkan (placeholder), tampilan + animasi jalan
    Edit dan merge sama logic sesuai kebutuhan
]]

-- ===================== SERVICES =====================
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local RunService       = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- ===================== THEME ========================
local T = {
    -- Background utama
    Bg           = Color3.fromRGB(8,   14,  30 ),
    BgGlass      = Color3.fromRGB(10,  18,  38 ),
    Surface      = Color3.fromRGB(14,  22,  48 ),
    SurfaceHi    = Color3.fromRGB(22,  34,  68 ),
    SurfaceCard  = Color3.fromRGB(16,  26,  56 ),
    NavBg        = Color3.fromRGB(9,   15,  34 ),

    -- Aksen biru × kuning
    Blue         = Color3.fromRGB(0,   148, 255),
    BlueDark     = Color3.fromRGB(0,    90, 190),
    BlueGlow     = Color3.fromRGB(40,  160, 255),
    Yellow       = Color3.fromRGB(255, 200,  0 ),
    YellowDark   = Color3.fromRGB(200, 150,  0 ),
    YellowGlow   = Color3.fromRGB(255, 220,  60),

    -- Status
    Success      = Color3.fromRGB(0,   210, 110),
    Warning      = Color3.fromRGB(255, 190,  40),
    Error        = Color3.fromRGB(255,  55,  75),
    Admin        = Color3.fromRGB(255, 210,   0),

    -- Teks
    Text         = Color3.fromRGB(230, 238, 255),
    TextDim      = Color3.fromRGB(170, 185, 220),
    Muted        = Color3.fromRGB(110, 130, 175),
    Border       = Color3.fromRGB(30,  48,  95 ),
    BorderGlow   = Color3.fromRGB(0,   100, 220),
}

-- Transparansi panel – ubah nilai ini untuk terang/gelap panel
local PANEL_TRANS = 0.35    -- 0 = solid, 1 = invisible
local NAV_TRANS   = 0.30

-- ===================== BASE64 ICON MINIMIZE =====================
-- isi manual base64 PNG icon di sini (semi-rounded rectangle shape)
local ICON_MINIMIZE_B64 = "data:image/png;base64,ISI_BASE64_ICON_MINIMIZE_DI_SINI"
-- isi manual base64 PNG background untuk content area
local BG_CONTENT_B64    = "data:image/png;base64,ISI_BASE64_BACKGROUND_KONTEN_DI_SINI"

-- ===================== HELPERS =====================
local function Tween(obj, props, dur, style, dir)
    TweenService:Create(obj,
        TweenInfo.new(dur or 0.22,
            style or Enum.EasingStyle.Quart,
            dir   or Enum.EasingDirection.Out),
        props):Play()
end

local function TweenBack(obj, props, dur)
    Tween(obj, props, dur or 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

local function Round(inst, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = inst
    return c
end

local function Stroke(inst, col, th, trans)
    local s = Instance.new("UIStroke")
    s.Color        = col   or T.Border
    s.Thickness    = th    or 1
    s.Transparency = trans or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = inst
    return s
end

local function Gradient(inst, c0, c1, rot)
    local g = Instance.new("UIGradient")
    g.Color    = ColorSequence.new(c0, c1)
    g.Rotation = rot or 90
    g.Parent   = inst
    return g
end

local function Lbl(parent, text, size, color, font, align)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text           = text
    l.TextSize       = size  or 11
    l.TextColor3     = color or T.Text
    l.Font           = font  or Enum.Font.Gotham
    l.TextXAlignment = align or Enum.TextXAlignment.Left
    l.Parent         = parent
    return l
end

-- Glow frame (frame dengan UIGradient + semi-transparan + stroke berwarna)
local function GlassFrame(parent, bgCol, trans, strokeCol)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = bgCol   or T.Surface
    f.BackgroundTransparency = trans or PANEL_TRANS
    f.BorderSizePixel  = 0
    f.Parent           = parent
    if strokeCol then Stroke(f, strokeCol, 1, 0.3) end
    return f
end

-- ===================== SCREENGUI =====================
local SG = Instance.new("ScreenGui")
SG.Name           = "APNEXTGEN_V9"
SG.Parent         = CoreGui
SG.ResetOnSpawn   = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.DisplayOrder   = 100

-- ╔═══════════════════════════════════════════════╗
-- ║          OPENING SPLASH SCREEN                ║
-- ╚═══════════════════════════════════════════════╝
local SplashBG = Instance.new("Frame")
SplashBG.Name               = "SplashBG"
SplashBG.Size               = UDim2.new(1, 0, 1, 0)
SplashBG.BackgroundColor3   = Color3.fromRGB(4, 8, 20)
SplashBG.BorderSizePixel    = 0
SplashBG.ZIndex             = 200
SplashBG.Parent             = SG

-- Gradient latar splash
local splashGrad = Instance.new("UIGradient")
splashGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(3,  8,  22)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(5, 12,  35)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(2,  5,  18)),
})
splashGrad.Rotation = 135
splashGrad.Parent = SplashBG

-- Garis dekorasi atas
local SplashLineTop = Instance.new("Frame")
SplashLineTop.Size             = UDim2.new(0, 0, 0, 2)
SplashLineTop.Position         = UDim2.new(0.5, 0, 0, 80)
SplashLineTop.AnchorPoint      = Vector2.new(0.5, 0)
SplashLineTop.BackgroundColor3 = T.Blue
SplashLineTop.BorderSizePixel  = 0
SplashLineTop.ZIndex           = 201
Gradient(SplashLineTop, T.Yellow, T.Blue, 0)
SplashLineTop.Parent = SplashBG

-- Garis dekorasi bawah
local SplashLineBtm = SplashLineTop:Clone()
SplashLineBtm.Position = UDim2.new(0.5, 0, 1, -82)
SplashLineBtm.Parent   = SplashBG

-- Container tengah splash
local SplashCenter = Instance.new("Frame")
SplashCenter.Size               = UDim2.new(0, 360, 0, 200)
SplashCenter.Position           = UDim2.new(0.5, -180, 0.5, -100)
SplashCenter.BackgroundTransparency = 1
SplashCenter.ZIndex             = 201
SplashCenter.Parent             = SplashBG

-- Logo text besar
local SplashLogo = Instance.new("TextLabel")
SplashLogo.Size               = UDim2.new(1, 0, 0, 68)
SplashLogo.Position           = UDim2.new(0, 0, 0, 20)
SplashLogo.BackgroundTransparency = 1
SplashLogo.Text               = "AP-NEXTGEN"
SplashLogo.TextSize           = 52
SplashLogo.Font               = Enum.Font.GothamBlack
SplashLogo.TextColor3         = Color3.new(1, 1, 1)
SplashLogo.TextXAlignment     = Enum.TextXAlignment.Center
SplashLogo.TextTransparency   = 1
SplashLogo.ZIndex             = 202
SplashLogo.Parent             = SplashCenter

-- Gradient warna pada logo
local logoGrad = Instance.new("UIGradient")
logoGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,    T.Yellow),
    ColorSequenceKeypoint.new(0.45, T.YellowGlow),
    ColorSequenceKeypoint.new(0.55, T.BlueGlow),
    ColorSequenceKeypoint.new(1,    T.Blue),
})
logoGrad.Rotation = 0
logoGrad.Parent   = SplashLogo

-- Badge versi "1"
local VersionBadge = Instance.new("TextLabel")
VersionBadge.Size             = UDim2.new(0, 32, 0, 32)
VersionBadge.Position         = UDim2.new(1, -10, 0, 14)
VersionBadge.AnchorPoint      = Vector2.new(0, 0)
VersionBadge.BackgroundColor3 = T.Yellow
VersionBadge.Text             = "1"
VersionBadge.TextSize         = 18
VersionBadge.Font             = Enum.Font.GothamBlack
VersionBadge.TextColor3       = Color3.fromRGB(5, 10, 25)
VersionBadge.TextXAlignment   = Enum.TextXAlignment.Center
VersionBadge.TextTransparency = 1
VersionBadge.ZIndex           = 203
Round(VersionBadge, 6)
VersionBadge.Parent = SplashCenter

-- Sub-judul
local SplashSub = Instance.new("TextLabel")
SplashSub.Size               = UDim2.new(1, 0, 0, 22)
SplashSub.Position           = UDim2.new(0, 0, 0, 93)
SplashSub.BackgroundTransparency = 1
SplashSub.Text               = "By  APTECH"
SplashSub.TextSize           = 16
SplashSub.Font               = Enum.Font.GothamBold
SplashSub.TextColor3         = T.Blue
SplashSub.TextXAlignment     = Enum.TextXAlignment.Center
SplashSub.TextTransparency   = 1
SplashSub.LetterSpacing      = 8
SplashSub.ZIndex             = 202
SplashSub.Parent             = SplashCenter

-- Tagline kecil
local SplashTag = Instance.new("TextLabel")
SplashTag.Size               = UDim2.new(1, 0, 0, 16)
SplashTag.Position           = UDim2.new(0, 0, 0, 120)
SplashTag.BackgroundTransparency = 1
SplashTag.Text               = "✦  Professional Script Suite  ✦"
SplashTag.TextSize           = 11
SplashTag.Font               = Enum.Font.Gotham
SplashTag.TextColor3         = T.Muted
SplashTag.TextXAlignment     = Enum.TextXAlignment.Center
SplashTag.TextTransparency   = 1
SplashTag.ZIndex             = 202
SplashTag.Parent             = SplashCenter

-- Loading bar track
local LoadTrack = Instance.new("Frame")
LoadTrack.Size             = UDim2.new(0, 280, 0, 4)
LoadTrack.Position         = UDim2.new(0.5, -140, 0, 155)
LoadTrack.BackgroundColor3 = Color3.fromRGB(20, 30, 60)
LoadTrack.BorderSizePixel  = 0
LoadTrack.ZIndex           = 202
Round(LoadTrack, 2)
LoadTrack.Parent = SplashCenter

local LoadFill = Instance.new("Frame")
LoadFill.Size             = UDim2.new(0, 0, 1, 0)
LoadFill.BackgroundColor3 = T.Blue
LoadFill.BorderSizePixel  = 0
LoadFill.ZIndex           = 203
Round(LoadFill, 2)
Gradient(LoadFill, T.Yellow, T.Blue, 0)
LoadFill.Parent = LoadTrack

-- Loading persen text
local LoadPct = Instance.new("TextLabel")
LoadPct.Size               = UDim2.new(1, 0, 0, 14)
LoadPct.Position           = UDim2.new(0, 0, 0, 170)
LoadPct.BackgroundTransparency = 1
LoadPct.Text               = "Loading..."
LoadPct.TextSize           = 9
LoadPct.Font               = Enum.Font.Gotham
LoadPct.TextColor3         = T.Muted
LoadPct.TextXAlignment     = Enum.TextXAlignment.Center
LoadPct.TextTransparency   = 1
LoadPct.ZIndex             = 202
LoadPct.Parent             = SplashCenter

-- Copyright bottom
local SplashCopy = Instance.new("TextLabel")
SplashCopy.Size               = UDim2.new(1, 0, 0, 14)
SplashCopy.Position           = UDim2.new(0, 0, 1, -30)
SplashCopy.BackgroundTransparency = 1
SplashCopy.Text               = "© 2025 APTECH  –  AP-NEXTGEN Script"
SplashCopy.TextSize           = 9
SplashCopy.Font               = Enum.Font.Gotham
SplashCopy.TextColor3         = T.Muted
SplashCopy.TextTransparency   = 1
SplashCopy.TextXAlignment     = Enum.TextXAlignment.Center
SplashCopy.ZIndex             = 201
SplashCopy.Parent             = SplashBG

-- ==================== MAIN FRAME (awalnya disembunyiin) ====================
local MF = Instance.new("Frame")
MF.Name             = "MainFrame"
MF.Size             = UDim2.new(0, 460, 0, 300)
MF.Position         = UDim2.new(0.5, -230, 0.5, -150)
MF.BackgroundColor3 = T.Bg
MF.BackgroundTransparency = 0.05
MF.BorderSizePixel  = 0
MF.ClipsDescendants = true
MF.Active           = true
MF.Visible          = false
Round(MF, 16)
Stroke(MF, T.BorderGlow, 1.5, 0.2)
MF.Parent = SG

-- Gradient subtle di background main frame
Gradient(MF, Color3.fromRGB(8,14,32), Color3.fromRGB(6,10,24), 145)

-- ==================== TOP BAR ====================
local TopBar = Instance.new("Frame")
TopBar.Name             = "TopBar"
TopBar.Size             = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = T.Surface
TopBar.BackgroundTransparency = 0.1
TopBar.BorderSizePixel  = 0
TopBar.ZIndex           = 5
Round(TopBar, 16)
Stroke(TopBar, T.BorderGlow, 1, 0.5)
TopBar.Parent = MF

-- Garis bawah topbar (divider berwarna)
local TopBarLine = Instance.new("Frame")
TopBarLine.Size             = UDim2.new(1, 0, 0, 1.5)
TopBarLine.Position         = UDim2.new(0, 0, 1, -1)
TopBarLine.BackgroundColor3 = T.Blue
TopBarLine.BorderSizePixel  = 0
TopBarLine.ZIndex           = 6
Gradient(TopBarLine, T.Yellow, T.Blue, 0)
TopBarLine.Parent = TopBar

-- Fix rounded corners bawah topbar
local TopFix = Instance.new("Frame")
TopFix.Size             = UDim2.new(1, 0, 0, 14)
TopFix.Position         = UDim2.new(0, 0, 1, -14)
TopFix.BackgroundColor3 = T.Surface
TopFix.BackgroundTransparency = 0.1
TopFix.BorderSizePixel  = 0
TopFix.ZIndex           = 4
TopFix.Parent           = TopBar

-- Avatar
local AvImg = Instance.new("ImageLabel")
AvImg.Size             = UDim2.new(0, 27, 0, 27)
AvImg.Position         = UDim2.new(0, 7, 0.5, -13.5)
AvImg.BackgroundColor3 = T.SurfaceHi
AvImg.Image            = "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=150&height=150&format=png"
AvImg.ZIndex           = 6
Round(AvImg, 13)
Stroke(AvImg, T.Yellow, 1.5, 0.1)
AvImg.Parent = TopBar

-- Nama user
local NameLbl = Lbl(TopBar, LocalPlayer.Name, 11, T.Text, Enum.Font.GothamBold)
NameLbl.Size         = UDim2.new(0, 90, 0, 13)
NameLbl.Position     = UDim2.new(0, 38, 0, 5)
NameLbl.ZIndex       = 6
NameLbl.TextTruncate = Enum.TextTruncate.AtEnd

-- Subteks game
local GameLbl = Lbl(TopBar, game.Name:sub(1,15), 8, T.Muted)
GameLbl.Size         = UDim2.new(0, 90, 0, 11)
GameLbl.Position     = UDim2.new(0, 38, 0, 21)
GameLbl.ZIndex       = 6
GameLbl.TextTruncate = Enum.TextTruncate.AtEnd

-- Server info tengah
local SrvLbl = Lbl(TopBar, "🌐 Global | ID:"..tostring(game.PlaceId):sub(1,9).." | --/--", 9,
    T.BlueGlow, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
SrvLbl.Size         = UDim2.new(0, 190, 0, 14)
SrvLbl.Position     = UDim2.new(0.5, -95, 0.5, -7)
SrvLbl.ZIndex       = 6
SrvLbl.TextTruncate = Enum.TextTruncate.AtEnd

-- ── TOMBOL MINIMIZE (ImageButton, icon rounded-rect semi-bulat) ──
local MinBtn = Instance.new("ImageButton")
MinBtn.Size             = UDim2.new(0, 26, 0, 20)
MinBtn.Position         = UDim2.new(1, -56, 0.5, -10)
MinBtn.BackgroundColor3 = T.SurfaceHi
MinBtn.BackgroundTransparency = 0.3
MinBtn.Image            = ICON_MINIMIZE_B64   -- ← isi base64 PNG di atas
MinBtn.ScaleType        = Enum.ScaleType.Fit
MinBtn.ZIndex           = 7
MinBtn.AutoButtonColor  = false
Round(MinBtn, 6)
Stroke(MinBtn, T.Border, 1, 0.3)
MinBtn.Parent = TopBar

-- Fallback teks (kelihatan kalau base64 belum diisi)
local MinFallback = Lbl(MinBtn, "−", 16, T.Muted, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
MinFallback.Size     = UDim2.new(1, 0, 1, 0)
MinFallback.ZIndex   = 8

-- Tombol close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size             = UDim2.new(0, 26, 0, 20)
CloseBtn.Position         = UDim2.new(1, -27, 0.5, -10)
CloseBtn.BackgroundColor3 = T.Error
CloseBtn.Text             = "✕"
CloseBtn.TextColor3       = Color3.new(1, 1, 1)
CloseBtn.TextSize         = 11
CloseBtn.Font             = Enum.Font.GothamBold
CloseBtn.ZIndex           = 7
CloseBtn.AutoButtonColor  = false
Round(CloseBtn, 6)
CloseBtn.Parent = TopBar

-- APTECH branding kecil di pojok kiri bawah topbar area
local BrandLbl = Lbl(TopBar, "Script by APTECH", 7, T.Yellow, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
BrandLbl.Size     = UDim2.new(0, 90, 0, 10)
BrandLbl.Position = UDim2.new(0, 132, 1, -11)
BrandLbl.ZIndex   = 6

-- ==================== SERVER INFO UPDATER ====================
spawn(function()
    while SrvLbl.Parent do
        local pc=0; local mp=0
        pcall(function() pc=#Players:GetPlayers(); mp=Players.MaxPlayers end)
        GameLbl.Text = game.Name:sub(1,15)
        SrvLbl.Text  = "🌐 Global | ID:"..tostring(game.PlaceId):sub(1,9).." | "..pc.."/"..mp
        wait(5)
    end
end)

-- ==================== DRAG TOPBAR ====================
local _drag, _ds, _sp = false, nil, nil
TopBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        _drag=true; _ds=i.Position; _sp=MF.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if _drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
        local d = i.Position - _ds
        MF.Position = UDim2.new(_sp.X.Scale, _sp.X.Offset+d.X, _sp.Y.Scale, _sp.Y.Offset+d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        _drag=false
    end
end)

-- ==================== LEFT NAV SIDEBAR ====================
local NavFrame = Instance.new("ScrollingFrame")
NavFrame.Name                = "NavFrame"
NavFrame.Size                = UDim2.new(0, 52, 1, -38)
NavFrame.Position            = UDim2.new(0, 0, 0, 38)
NavFrame.BackgroundColor3    = T.NavBg
NavFrame.BackgroundTransparency = NAV_TRANS
NavFrame.BorderSizePixel     = 0
NavFrame.ScrollBarThickness  = 0
NavFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
NavFrame.ScrollingDirection  = Enum.ScrollingDirection.Y
NavFrame.Parent              = MF

local NavLL = Instance.new("UIListLayout")
NavLL.Padding             = UDim.new(0, 3)
NavLL.HorizontalAlignment = Enum.HorizontalAlignment.Center
NavLL.Parent              = NavFrame

local NavPad = Instance.new("UIPadding")
NavPad.PaddingTop   = UDim.new(0, 5)
NavPad.PaddingLeft  = UDim.new(0, 3)
NavPad.PaddingRight = UDim.new(0, 3)
NavPad.Parent       = NavFrame

-- Divider nav
local Div = Instance.new("Frame")
Div.Size             = UDim2.new(0, 1, 1, -38)
Div.Position         = UDim2.new(0, 52, 0, 38)
Div.BackgroundColor3 = T.BorderGlow
Div.BackgroundTransparency = 0.7
Div.BorderSizePixel  = 0
Div.Parent           = MF

-- ==================== CONTENT AREA + BACKGROUND IMAGE ====================
local ContentArea = Instance.new("Frame")
ContentArea.Name             = "ContentArea"
ContentArea.Size             = UDim2.new(1, -53, 1, -38)
ContentArea.Position         = UDim2.new(0, 53, 0, 38)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.Parent           = MF

-- Background image di bawah konten (isi base64 di atas)
local BgImage = Instance.new("ImageLabel")
BgImage.Name               = "BgImage"
BgImage.Size               = UDim2.new(1, 0, 1, 0)
BgImage.BackgroundTransparency = 1
BgImage.Image              = BG_CONTENT_B64   -- ← isi base64 PNG di atas
BgImage.ScaleType          = Enum.ScaleType.Crop
BgImage.ImageTransparency  = 0.65
BgImage.ZIndex             = 0
BgImage.Parent             = ContentArea

-- ==================== PAGE SYSTEM ====================
local Pages   = {}
local NavBtns = {}
local CurPage = nil

local function NewPage(name)
    local sf = Instance.new("ScrollingFrame")
    sf.Name                = name
    sf.Size                = UDim2.new(1, 0, 1, 0)
    sf.BackgroundTransparency = 1
    sf.BorderSizePixel     = 0
    sf.ScrollBarThickness  = 3
    sf.ScrollBarImageColor3= T.Yellow
    sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sf.ScrollingDirection  = Enum.ScrollingDirection.Y
    sf.Visible             = false
    sf.ZIndex              = 1
    sf.Parent              = ContentArea

    local ll = Instance.new("UIListLayout")
    ll.Padding = UDim.new(0, 6)
    ll.Parent  = sf

    local pd = Instance.new("UIPadding")
    pd.PaddingTop    = UDim.new(0, 6)
    pd.PaddingLeft   = UDim.new(0, 6)
    pd.PaddingRight  = UDim.new(0, 8)
    pd.PaddingBottom = UDim.new(0, 6)
    pd.Parent        = sf

    Pages[name] = sf
    return sf
end

local function GoPage(name)
    for n, pg in pairs(Pages) do
        if n == name then
            pg.Visible = true
            pg.Position = UDim2.new(0.08, 0, 0, 0)
            pg.BackgroundTransparency = 1
            Tween(pg, {Position = UDim2.new(0, 0, 0, 0)}, 0.28, Enum.EasingStyle.Quart)
        else
            pg.Visible = false
        end
    end
    for n, btn in pairs(NavBtns) do
        if n == name then
            Tween(btn, {BackgroundColor3 = T.Blue}, 0.2)
            Tween(btn, {TextColor3 = T.Yellow}, 0.2)
        else
            Tween(btn, {BackgroundColor3 = Color3.fromRGB(12, 20, 44)}, 0.2)
            Tween(btn, {TextColor3 = T.Muted}, 0.2)
        end
    end
    CurPage = name
end

local function NavBtn(icon, pageName)
    local b = Instance.new("TextButton")
    b.Size             = UDim2.new(0, 44, 0, 34)
    b.BackgroundColor3 = Color3.fromRGB(12, 20, 44)
    b.Text             = icon
    b.TextColor3       = T.Muted
    b.TextSize         = 15
    b.Font             = Enum.Font.GothamBold
    b.BorderSizePixel  = 0
    b.AutoButtonColor  = false
    Round(b, 8)
    b.Parent  = NavFrame
    NavBtns[pageName] = b
    b.MouseButton1Click:Connect(function()
        GoPage(pageName)
    end)
    -- Hover efek
    b.MouseEnter:Connect(function()
        if CurPage ~= pageName then
            Tween(b, {BackgroundColor3 = Color3.fromRGB(20, 34, 72)}, 0.15)
            Tween(b, {TextColor3 = T.BlueGlow}, 0.15)
        end
    end)
    b.MouseLeave:Connect(function()
        if CurPage ~= pageName then
            Tween(b, {BackgroundColor3 = Color3.fromRGB(12, 20, 44)}, 0.15)
            Tween(b, {TextColor3 = T.Muted}, 0.15)
        end
    end)
    return b
end

-- ==================== UI COMPONENT BUILDERS ====================

-- Section card (judul + container isi) dengan background transparan + border
local function Section(parent, title)
    local card = Instance.new("Frame")
    card.Size             = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize    = Enum.AutomaticSize.Y
    card.BackgroundColor3 = T.SurfaceCard
    card.BackgroundTransparency = PANEL_TRANS
    card.BorderSizePixel  = 0
    Round(card, 10)
    Stroke(card, T.BorderGlow, 1, 0.55)
    card.Parent = parent

    -- Header bar section dengan gradient tipis
    local hdr = Instance.new("Frame")
    hdr.Size             = UDim2.new(1, 0, 0, 22)
    hdr.BackgroundColor3 = T.SurfaceHi
    hdr.BackgroundTransparency = 0.2
    hdr.BorderSizePixel  = 0
    hdr.ZIndex           = 2
    Round(hdr, 10)
    hdr.Parent = card

    -- Fix corner bawah header
    local hdrFix = Instance.new("Frame")
    hdrFix.Size = UDim2.new(1, 0, 0, 10)
    hdrFix.Position = UDim2.new(0, 0, 1, -10)
    hdrFix.BackgroundColor3 = T.SurfaceHi
    hdrFix.BackgroundTransparency = 0.2
    hdrFix.BorderSizePixel = 0
    hdrFix.ZIndex = 2
    hdrFix.Parent = hdr

    -- Garis aksen kuning-biru di kiri header
    local accent = Instance.new("Frame")
    accent.Size             = UDim2.new(0, 3, 0, 14)
    accent.Position         = UDim2.new(0, 6, 0.5, -7)
    accent.BackgroundColor3 = T.Yellow
    accent.BorderSizePixel  = 0
    accent.ZIndex           = 3
    Round(accent, 2)
    Gradient(accent, T.Yellow, T.Blue, 90)
    accent.Parent = hdr

    local ttl = Lbl(hdr, title, 10, T.Yellow, Enum.Font.GothamBold)
    ttl.Size     = UDim2.new(1, -18, 1, 0)
    ttl.Position = UDim2.new(0, 14, 0, 0)
    ttl.ZIndex   = 3

    local cont = Instance.new("Frame")
    cont.Name             = "Cont"
    cont.Size             = UDim2.new(1, -10, 0, 0)
    cont.Position         = UDim2.new(0, 5, 0, 24)
    cont.AutomaticSize    = Enum.AutomaticSize.Y
    cont.BackgroundTransparency = 1
    cont.Parent           = card

    local cL = Instance.new("UIListLayout")
    cL.Padding = UDim.new(0, 4)
    cL.Parent  = cont

    local cP = Instance.new("UIPadding")
    cP.PaddingBottom = UDim.new(0, 7)
    cP.Parent        = card

    return cont
end

-- Toggle row
local function Toggle(parent, text, _callback)
    local row = Instance.new("Frame")
    row.Size             = UDim2.new(1, 0, 0, 26)
    row.BackgroundTransparency = 1
    row.Parent           = parent

    local lbl = Lbl(row, text, 10, T.TextDim)
    lbl.Size = UDim2.new(0.68, 0, 1, 0)

    local track = Instance.new("TextButton")
    track.Size             = UDim2.new(0, 44, 0, 20)
    track.Position         = UDim2.new(1, -44, 0.5, -10)
    track.BackgroundColor3 = Color3.fromRGB(28, 36, 65)
    track.Text             = ""
    track.AutoButtonColor  = false
    track.BorderSizePixel  = 0
    Round(track, 10)
    Stroke(track, T.Border, 1, 0.4)
    track.Parent = row

    local knob = Instance.new("Frame")
    knob.Size             = UDim2.new(0, 14, 0, 14)
    knob.Position         = UDim2.new(0, 3, 0.5, -7)
    knob.BackgroundColor3 = T.Muted
    knob.BorderSizePixel  = 0
    Round(knob, 7)
    knob.Parent = track

    local stateTag = Lbl(row, "OFF", 8, T.Muted, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
    stateTag.Size     = UDim2.new(0, 40, 1, 0)
    stateTag.Position = UDim2.new(1, -88, 0, 0)

    local on = false
    track.MouseButton1Click:Connect(function()
        on = not on
        if on then
            Tween(knob,   {Position = UDim2.new(0, 27, 0.5, -7), BackgroundColor3 = T.Yellow}, 0.2, Enum.EasingStyle.Back)
            Tween(track,  {BackgroundColor3 = T.Blue}, 0.2)
            stateTag.Text      = "ON"
            stateTag.TextColor3 = T.Yellow
        else
            Tween(knob,   {Position = UDim2.new(0, 3, 0.5, -7),  BackgroundColor3 = T.Muted}, 0.2, Enum.EasingStyle.Back)
            Tween(track,  {BackgroundColor3 = Color3.fromRGB(28, 36, 65)}, 0.2)
            stateTag.Text      = "OFF"
            stateTag.TextColor3 = T.Muted
        end
        if _callback then _callback(on) end   -- <<< sambung fungsi di sini nanti
    end)
    return track
end

-- Slider row
local function Slider(parent, text, min, max, default, _callback)
    local frame = Instance.new("Frame")
    frame.Size             = UDim2.new(1, 0, 0, 44)
    frame.BackgroundTransparency = 1
    frame.Parent           = parent

    local topRow = Instance.new("Frame")
    topRow.Size            = UDim2.new(1, 0, 0, 16)
    topRow.BackgroundTransparency = 1
    topRow.Parent          = frame

    local lbl = Lbl(topRow, text, 10, T.TextDim)
    lbl.Size = UDim2.new(0.62, 0, 1, 0)

    local vbox = Instance.new("TextBox")
    vbox.Size             = UDim2.new(0, 46, 0, 17)
    vbox.Position         = UDim2.new(1, -46, 0, -0.5)
    vbox.BackgroundColor3 = T.SurfaceHi
    vbox.Text             = tostring(default)
    vbox.TextColor3       = T.Yellow
    vbox.TextSize         = 9
    vbox.Font             = Enum.Font.GothamBold
    vbox.ClearTextOnFocus = false
    vbox.TextXAlignment   = Enum.TextXAlignment.Center
    Round(vbox, 5)
    Stroke(vbox, T.BorderGlow, 1, 0.5)
    vbox.Parent = topRow

    local track = Instance.new("Frame")
    track.Size             = UDim2.new(1, 0, 0, 5)
    track.Position         = UDim2.new(0, 0, 0, 30)
    track.BackgroundColor3 = Color3.fromRGB(22, 32, 62)
    track.BorderSizePixel  = 0
    Round(track, 3)
    track.Parent = frame

    local pct  = (default - min) / math.max(max - min, 1)
    local fill = Instance.new("Frame")
    fill.Size             = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = T.Blue
    fill.BorderSizePixel  = 0
    Round(fill, 3)
    Gradient(fill, T.Yellow, T.Blue, 0)
    fill.Parent = track

    local knob = Instance.new("Frame")
    knob.Size             = UDim2.new(0, 13, 0, 13)
    knob.Position         = UDim2.new(pct, -6, 0.5, -6)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    Round(knob, 7)
    Stroke(knob, T.Yellow, 1.5, 0.1)
    knob.Parent = track

    local dragging = false
    local function doUpdate(input)
        local p = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local v = math.floor(min + (max - min) * p)
        vbox.Text     = tostring(v)
        fill.Size     = UDim2.new(p, 0, 1, 0)
        knob.Position = UDim2.new(p, -6, 0.5, -6)
        if _callback then _callback(v) end    -- <<< sambung fungsi di sini nanti
    end

    track.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true; doUpdate(i)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            doUpdate(i)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=false
        end
    end)
    vbox.FocusLost:Connect(function()
        local v = math.clamp(tonumber(vbox.Text) or default, min, max)
        vbox.Text     = tostring(v)
        local p = (v - min) / math.max(max - min, 1)
        fill.Size     = UDim2.new(p, 0, 1, 0)
        knob.Position = UDim2.new(p, -6, 0.5, -6)
        if _callback then _callback(v) end
    end)

    return frame
end

-- Button
local function Btn(parent, text, style, _callback)
    local col = style=="primary" and T.Blue
             or style=="success"  and T.Success
             or style=="danger"   and T.Error
             or style=="admin"    and T.Yellow
             or T.SurfaceHi
    local tCol = (style=="admin") and Color3.fromRGB(5,10,20) or Color3.new(1,1,1)

    local b = Instance.new("TextButton")
    b.Size             = UDim2.new(1, 0, 0, 26)
    b.BackgroundColor3 = col
    b.BackgroundTransparency = 0.1
    b.Text             = text
    b.TextColor3       = tCol
    b.TextSize         = 10
    b.Font             = Enum.Font.GothamBold
    b.BorderSizePixel  = 0
    b.AutoButtonColor  = false
    Round(b, 7)
    b.Parent = parent

    b.MouseEnter:Connect(function()
        Tween(b, {BackgroundTransparency = 0, BackgroundColor3 = col:Lerp(Color3.new(1,1,1), 0.12)}, 0.15)
    end)
    b.MouseLeave:Connect(function()
        Tween(b, {BackgroundTransparency = 0.1, BackgroundColor3 = col}, 0.15)
    end)
    b.MouseButton1Click:Connect(function()
        Tween(b, {BackgroundColor3 = col:Lerp(Color3.new(1,1,1), 0.3)}, 0.08)
        wait(0.08); Tween(b, {BackgroundColor3 = col}, 0.15)
        if _callback then _callback() end    -- <<< sambung fungsi di sini nanti
    end)
    return b
end

-- ==================== BUAT HALAMAN ====================
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
-- ====================== ISI TIAP HALAMAN ===========================
-- ====================================================================

-- ---------- DASHBOARD ----------
local dsC  = Section(PgDash, "📊 SERVER MONITOR")
local plrC = Section(PgDash, "👤 PLAYER INFO")

local function StatRow(parent, labelTxt, valTxt, valCol)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1,0,0,18); row.BackgroundTransparency=1; row.Parent=parent
    local l = Lbl(row, labelTxt, 9, T.Muted); l.Size = UDim2.new(0.52,0,1,0)
    local v = Lbl(row, valTxt, 9, valCol or T.Blue, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
    v.Size = UDim2.new(0.48,0,1,0); v.Position = UDim2.new(0.52,0,0,0)
    return v
end

StatRow(dsC, "Game Name:",   game.Name:sub(1,18),                T.Blue)
StatRow(dsC, "Place ID:",    tostring(game.PlaceId),              T.Yellow)
StatRow(dsC, "Job ID:",      game.JobId:sub(1,12).."...",         T.Muted)
local sPly = StatRow(dsC, "Players:", "--/--",                   T.Success)
StatRow(dsC, "Server Type:", "🌐 Global",                         T.Blue)

StatRow(plrC, "Username:",     LocalPlayer.Name,                  T.Blue)
StatRow(plrC, "User ID:",      tostring(LocalPlayer.UserId),       T.Muted)
StatRow(plrC, "Display Name:", LocalPlayer.DisplayName,            T.Text)
StatRow(plrC, "Team:",         "None",                             T.Yellow)

spawn(function()
    while sPly.Parent do
        local pc=0; local mp=0
        pcall(function() pc=#Players:GetPlayers(); mp=Players.MaxPlayers end)
        sPly.Text = pc.."/"..mp; wait(5)
    end
end)

-- ---------- MOVEMENT ----------
local mvC = Section(PgMove, "🏃 SPEED & JUMP")
Slider(mvC, "Walk Speed",  1, 500, 16)
Slider(mvC, "Jump Power",  1, 500, 50)
Btn(mvC, "Reset Speed & Jump", "normal")

local jC = Section(PgMove, "⬆️ JUMP")
Toggle(jC, "Infinite Jump")

local gC = Section(PgMove, "🌙 GRAVITY")
Toggle(gC, "Moon Gravity (low gravity)")
Slider(gC, "Custom Gravity", 5, 350, 196)

-- ---------- FLY ----------
local flyC = Section(PgFly, "✈️ FLY CONTROL")

local spdRow = Instance.new("Frame")
spdRow.Size=UDim2.new(1,0,0,28); spdRow.BackgroundTransparency=1; spdRow.Parent=flyC
local spdLbl = Lbl(spdRow,"Fly Speed:",10,T.TextDim); spdLbl.Size=UDim2.new(0.36,0,1,0)

local flyMin = Instance.new("TextButton")
flyMin.Size=UDim2.new(0,24,0,21); flyMin.Position=UDim2.new(0.38,0,0.5,-10)
flyMin.BackgroundColor3=T.SurfaceHi; flyMin.Text="−"; flyMin.TextColor3=T.Text
flyMin.TextSize=14; flyMin.Font=Enum.Font.GothamBold; flyMin.AutoButtonColor=false
Round(flyMin,6); Stroke(flyMin,T.Border,1,0.4); flyMin.Parent=spdRow

local flyDisp = Instance.new("TextLabel")
flyDisp.Size=UDim2.new(0,32,0,21); flyDisp.Position=UDim2.new(0.38,26,0.5,-10)
flyDisp.BackgroundColor3=T.SurfaceHi; flyDisp.Text="1"; flyDisp.TextColor3=T.Yellow
flyDisp.TextSize=11; flyDisp.Font=Enum.Font.GothamBold; flyDisp.TextXAlignment=Enum.TextXAlignment.Center
Round(flyDisp,6); flyDisp.Parent=spdRow

local flyPlus = Instance.new("TextButton")
flyPlus.Size=UDim2.new(0,24,0,21); flyPlus.Position=UDim2.new(0.38,60,0.5,-10)
flyPlus.BackgroundColor3=T.SurfaceHi; flyPlus.Text="+"; flyPlus.TextColor3=T.Text
flyPlus.TextSize=14; flyPlus.Font=Enum.Font.GothamBold; flyPlus.AutoButtonColor=false
Round(flyPlus,6); Stroke(flyPlus,T.Border,1,0.4); flyPlus.Parent=spdRow

local udRow = Instance.new("Frame")
udRow.Size=UDim2.new(1,0,0,26); udRow.BackgroundTransparency=1; udRow.Parent=flyC

local flyUpBtn = Instance.new("TextButton")
flyUpBtn.Size=UDim2.new(0.49,0,0,24); flyUpBtn.BackgroundColor3=T.SurfaceHi
flyUpBtn.BackgroundTransparency=0.2; flyUpBtn.Text="▲  UP"; flyUpBtn.TextColor3=T.Text; flyUpBtn.TextSize=10
flyUpBtn.Font=Enum.Font.GothamBold; flyUpBtn.AutoButtonColor=false
Round(flyUpBtn,7); flyUpBtn.Parent=udRow

local flyDnBtn = Instance.new("TextButton")
flyDnBtn.Size=UDim2.new(0.49,0,0,24); flyDnBtn.Position=UDim2.new(0.51,0,0,0)
flyDnBtn.BackgroundColor3=T.SurfaceHi; flyDnBtn.BackgroundTransparency=0.2; flyDnBtn.Text="▼  DOWN"
flyDnBtn.TextColor3=T.Text; flyDnBtn.TextSize=10; flyDnBtn.Font=Enum.Font.GothamBold
flyDnBtn.AutoButtonColor=false; Round(flyDnBtn,7); flyDnBtn.Parent=udRow

local flyTogBtn = Instance.new("TextButton")
flyTogBtn.Size=UDim2.new(1,0,0,28); flyTogBtn.BackgroundColor3=Color3.fromRGB(22,34,70)
flyTogBtn.BackgroundTransparency=0.15; flyTogBtn.Text="✈️  FLY: OFF"; flyTogBtn.TextColor3=T.Muted; flyTogBtn.TextSize=12
flyTogBtn.Font=Enum.Font.GothamBold; flyTogBtn.AutoButtonColor=false
Round(flyTogBtn,8); Stroke(flyTogBtn,T.Border,1,0.4); flyTogBtn.Parent=flyC

local ncC = Section(PgFly, "🔮 NOCLIP")
Toggle(ncC, "No Clip (pass through walls)")

-- ---------- ESP ----------
local espC   = Section(PgESP, "👁️ PLAYER ESP")
Toggle(espC, "Enable Player ESP")

local espV2C = Section(PgESP, "👑 ESP V2  –  ADMIN ONLY")
local espLock = Lbl(espV2C, "🔒 Login Admin untuk mengaktifkan ESP V2", 9, T.Yellow)
espLock.Size = UDim2.new(1,0,0,18)
Toggle(espV2C, "👑 ESP V2 (HP + Dist + Team + RGB)")

local blkEspC = Section(PgESP, "🧱 BLOCK / ITEM ESP")
Toggle(blkEspC, "Scan & highlight blocks / items")

-- ---------- TELEPORT ----------
local tpC = Section(PgTP, "🎯 TELEPORT")

local tpSF = Instance.new("ScrollingFrame")
tpSF.Size=UDim2.new(1,0,0,82); tpSF.BackgroundColor3=T.SurfaceHi; tpSF.BackgroundTransparency=0.35
tpSF.BorderSizePixel=0; tpSF.ScrollBarThickness=3; tpSF.ScrollBarImageColor3=T.Yellow
tpSF.CanvasSize=UDim2.new(0,0,0,0)
Round(tpSF,8); Stroke(tpSF,T.BorderGlow,1,0.6); tpSF.Parent=tpC

local tpLL = Instance.new("UIListLayout"); tpLL.Padding=UDim.new(0,3); tpLL.Parent=tpSF

local function RefreshTPList()
    for _, c in pairs(tpSF:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    local n = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            n = n + 1
            local b = Instance.new("TextButton")
            b.Size=UDim2.new(1,-6,0,24); b.Position=UDim2.new(0,3,0,0)
            b.BackgroundColor3=T.SurfaceCard; b.BackgroundTransparency=0.2; b.Text=p.Name
            b.TextColor3=T.Text; b.TextSize=10; b.Font=Enum.Font.Gotham; b.BorderSizePixel=0; b.AutoButtonColor=false
            Round(b,6); b.Parent=tpSF
            b.MouseButton1Click:Connect(function()  -- <<< sambung TP logic di sini nanti
                for _, bb in pairs(tpSF:GetChildren()) do
                    if bb:IsA("TextButton") then Tween(bb,{BackgroundColor3=T.SurfaceCard},0.12) end
                end
                Tween(b,{BackgroundColor3=T.Blue},0.15)
            end)
        end
    end
    tpSF.CanvasSize = UDim2.new(0,0,0,n*27)
end
RefreshTPList()
Players.PlayerAdded:Connect(RefreshTPList)
Players.PlayerRemoving:Connect(RefreshTPList)

Btn(tpC, "Teleport to Selected", "primary")
Toggle(tpC, "Follow Selected Player")

-- ---------- GOD ----------
local godC = Section(PgGod, "🛡️ GOD MODE")

local godModeBtn = Instance.new("TextButton")
godModeBtn.Size=UDim2.new(1,0,0,24); godModeBtn.BackgroundColor3=T.SurfaceHi; godModeBtn.BackgroundTransparency=0.25
godModeBtn.Text="Mode: Gen1  (auto-heal)"; godModeBtn.TextColor3=T.Text
godModeBtn.TextSize=10; godModeBtn.Font=Enum.Font.GothamBold; godModeBtn.AutoButtonColor=false
Round(godModeBtn,7); Stroke(godModeBtn,T.Border,1,0.4); godModeBtn.Parent=godC

Toggle(godC, "God Mode")
Toggle(godC, "Auto Heal (setiap 0.2s)")
Btn(godC, "Heal Now", "success")

-- ---------- WORLD ----------
local wC = Section(PgWorld, "🧱 BLOCK SPAWNER")

local function Dropdown(parent, labelTxt, opts)
    local frame = Instance.new("Frame")
    frame.Size=UDim2.new(1,0,0,0); frame.AutomaticSize=Enum.AutomaticSize.Y
    frame.BackgroundTransparency=1; frame.Parent=parent

    local row = Instance.new("TextButton")
    row.Size=UDim2.new(1,0,0,24); row.BackgroundColor3=T.SurfaceHi; row.BackgroundTransparency=0.25
    row.Text=labelTxt..": "..opts[1].." ▾"; row.TextColor3=T.Text
    row.TextSize=10; row.Font=Enum.Font.GothamBold; row.AutoButtonColor=false
    Round(row,7); Stroke(row,T.BorderGlow,1,0.6); row.Parent=frame

    local list = Instance.new("Frame")
    list.Size=UDim2.new(1,0,0,0); list.BackgroundColor3=T.Surface; list.BackgroundTransparency=0.1
    list.BorderSizePixel=0; list.ClipsDescendants=true; list.ZIndex=15
    Round(list,7); Stroke(list,T.BorderGlow,1,0.4); list.Parent=frame

    local ll = Instance.new("UIListLayout"); ll.Parent=list
    local open = false

    for _, opt in ipairs(opts) do
        local ob = Instance.new("TextButton")
        ob.Size=UDim2.new(1,0,0,22); ob.BackgroundColor3=T.SurfaceHi; ob.BackgroundTransparency=0.3
        ob.Text=opt; ob.TextColor3=T.TextDim; ob.TextSize=9; ob.Font=Enum.Font.Gotham
        ob.BorderSizePixel=0; ob.AutoButtonColor=false; ob.ZIndex=16; ob.Parent=list
        ob.MouseEnter:Connect(function() Tween(ob,{BackgroundColor3=T.Blue,BackgroundTransparency=0.15},0.12) end)
        ob.MouseLeave:Connect(function() Tween(ob,{BackgroundColor3=T.SurfaceHi,BackgroundTransparency=0.3},0.12) end)
        ob.MouseButton1Click:Connect(function()
            row.Text=labelTxt..": "..opt.." ▾"
            open=false; Tween(list,{Size=UDim2.new(1,0,0,0)},0.18,Enum.EasingStyle.Quart)
            -- <<< sambung logic pilihan di sini nanti
        end)
    end

    row.MouseButton1Click:Connect(function()
        open = not open
        Tween(list,{Size=UDim2.new(1,0,0,open and #opts*22 or 0)},0.2,Enum.EasingStyle.Quart)
    end)
end

Dropdown(wC, "Block Type",  {"Part","WedgePart","CornerWedgePart","TrussPart","SpawnLocation"})
Dropdown(wC, "Material",    {"SmoothPlastic","Neon","Glass","Wood","Granite","DiamondPlate","Metal","ForceField"})
Dropdown(wC, "Color",       {"Bright red","Bright blue","Bright green","Bright yellow","White","Black","Hot pink","Neon orange"})
Slider(wC, "Block Size", 1, 50, 5)
Btn(wC, "🧱 Spawn Block di Depan", "primary")
Btn(wC, "🗑️ Hapus Block Terakhir", "danger")
Btn(wC, "💥 Clear Semua Block", "danger")

-- ---------- AVATAR ----------
local avC = Section(PgAva, "👤 COPY AVATAR")

local avStatus = Lbl(avC, "Pilih player untuk copy tampilan.", 9, T.Muted)
avStatus.Size  = UDim2.new(1,0,0,16)

local avSF = Instance.new("ScrollingFrame")
avSF.Size=UDim2.new(1,0,0,80); avSF.BackgroundColor3=T.SurfaceHi; avSF.BackgroundTransparency=0.35
avSF.BorderSizePixel=0; avSF.ScrollBarThickness=3; avSF.ScrollBarImageColor3=T.Yellow
avSF.CanvasSize=UDim2.new(0,0,0,0)
Round(avSF,8); Stroke(avSF,T.BorderGlow,1,0.6); avSF.Parent=avC

local avLL = Instance.new("UIListLayout"); avLL.Padding=UDim.new(0,3); avLL.Parent=avSF

local function RefreshAvaList()
    for _, c in pairs(avSF:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    local n = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            n=n+1
            local b = Instance.new("TextButton")
            b.Size=UDim2.new(1,-6,0,24); b.Position=UDim2.new(0,3,0,0)
            b.BackgroundColor3=T.SurfaceCard; b.BackgroundTransparency=0.2; b.Text=p.Name
            b.TextColor3=T.Text; b.TextSize=10; b.Font=Enum.Font.Gotham; b.BorderSizePixel=0; b.AutoButtonColor=false
            Round(b,6); b.Parent=avSF
            b.MouseButton1Click:Connect(function()  -- <<< sambung copy logic di sini nanti
                for _, bb in pairs(avSF:GetChildren()) do
                    if bb:IsA("TextButton") then Tween(bb,{BackgroundColor3=T.SurfaceCard},0.1) end
                end
                Tween(b,{BackgroundColor3=T.Blue},0.15)
            end)
        end
    end
    avSF.CanvasSize = UDim2.new(0,0,0,n*27)
end
RefreshAvaList()
Players.PlayerAdded:Connect(RefreshAvaList)
Players.PlayerRemoving:Connect(RefreshAvaList)

Btn(avC, "👤 Copy Avatar Target", "primary")
Btn(avC, "🔄 Restore Avatar Saya", "normal")

-- ---------- PRESETS ----------
local svC = Section(PgSave, "💾 SAVE PRESET")

local preNameBox = Instance.new("TextBox")
preNameBox.Size=UDim2.new(1,0,0,24); preNameBox.BackgroundColor3=T.SurfaceHi; preNameBox.BackgroundTransparency=0.2
preNameBox.PlaceholderText="Nama preset…"; preNameBox.Text=""
preNameBox.TextColor3=T.Text; preNameBox.TextSize=10; preNameBox.Font=Enum.Font.Gotham
preNameBox.ClearTextOnFocus=false; Round(preNameBox,6); Stroke(preNameBox,T.BorderGlow,1,0.5); preNameBox.Parent=svC

local preSF = Instance.new("ScrollingFrame")
preSF.Size=UDim2.new(1,0,0,72); preSF.BackgroundColor3=T.SurfaceHi; preSF.BackgroundTransparency=0.35
preSF.BorderSizePixel=0; preSF.ScrollBarThickness=3; preSF.ScrollBarImageColor3=T.Yellow
preSF.CanvasSize=UDim2.new(0,0,0,0)
Round(preSF,8); Stroke(preSF,T.BorderGlow,1,0.6); preSF.Parent=svC
local preLL = Instance.new("UIListLayout"); preLL.Padding=UDim.new(0,3); preLL.Parent=preSF

Btn(svC, "💾 Save Settings Sekarang", "primary")

local exportBox = Instance.new("TextBox")
exportBox.Size=UDim2.new(1,0,0,42); exportBox.BackgroundColor3=T.NavBg; exportBox.BackgroundTransparency=0.15
exportBox.PlaceholderText="Kode export akan muncul di sini…"; exportBox.Text=""
exportBox.TextColor3=T.Yellow; exportBox.TextSize=8; exportBox.Font=Enum.Font.Code
exportBox.MultiLine=true; exportBox.TextXAlignment=Enum.TextXAlignment.Left
exportBox.TextYAlignment=Enum.TextYAlignment.Top; exportBox.ClearTextOnFocus=false
Round(exportBox,6); Stroke(exportBox,T.Border,1,0.4); exportBox.Parent=svC

local importBox = Instance.new("TextBox")
importBox.Size=UDim2.new(1,0,0,38); importBox.BackgroundColor3=T.NavBg; importBox.BackgroundTransparency=0.15
importBox.PlaceholderText="Paste kode import di sini…"; importBox.Text=""
importBox.TextColor3=T.Text; importBox.TextSize=8; importBox.Font=Enum.Font.Code
importBox.MultiLine=true; importBox.TextXAlignment=Enum.TextXAlignment.Left
importBox.TextYAlignment=Enum.TextYAlignment.Top; importBox.ClearTextOnFocus=false
Round(importBox,6); Stroke(importBox,T.Border,1,0.4); importBox.Parent=svC

Btn(svC, "📥 Import dari Kode", "normal")

-- ---------- ADMIN ----------
local adC = Section(PgAdmin, "🔐 ADMIN LOGIN")

local adStatus = Lbl(adC, "🔒 Belum terautentikasi", 9, T.Muted)
adStatus.Size  = UDim2.new(1,0,0,16)

local pwBox = Instance.new("TextBox")
pwBox.Size=UDim2.new(1,0,0,26); pwBox.BackgroundColor3=T.NavBg; pwBox.BackgroundTransparency=0.1
pwBox.PlaceholderText="Masukkan password…"; pwBox.Text=""
pwBox.TextColor3=T.Text; pwBox.TextSize=11; pwBox.Font=Enum.Font.GothamBold
pwBox.ClearTextOnFocus=false; Round(pwBox,7); Stroke(pwBox,T.Yellow,1,0.3); pwBox.Parent=adC

Btn(adC, "🔓 Unlock Admin Mode", "admin")

-- ---------- UTILITY ----------
local utC = Section(PgUtil, "⚙️ UTILITIES")
local srC = Section(PgUtil, "🌐 SERVER")

Toggle(utC, "Full Bright")
Toggle(utC, "Anti-AFK")
Toggle(utC, "Unlock Camera Zoom")
Toggle(utC, "FPS Boost (reduce quality)")

Btn(srC, "Rejoin Server", "primary")
Btn(srC, "Server Hop", "normal")

-- ====================================================================
-- ===================== ORB / MINIMIZE / CLOSE ======================
-- ====================================================================
local OrbBtn = Instance.new("TextButton")
OrbBtn.Size=UDim2.new(0,46,0,46); OrbBtn.Position=UDim2.new(0,14,0.5,-23)
OrbBtn.BackgroundColor3=T.Blue; OrbBtn.Text="AP"; OrbBtn.TextColor3=Color3.new(1,1,1)
OrbBtn.TextSize=14; OrbBtn.Font=Enum.Font.GothamBlack
OrbBtn.Visible=false; OrbBtn.ZIndex=100; OrbBtn.Active=true; OrbBtn.Draggable=true
OrbBtn.AutoButtonColor=false
Round(OrbBtn, 10)
Stroke(OrbBtn, T.Yellow, 2, 0)
Gradient(OrbBtn, T.Blue, T.BlueDark, 135)
OrbBtn.Parent = SG

-- Hover orb
OrbBtn.MouseEnter:Connect(function()
    Tween(OrbBtn, {BackgroundColor3=T.BlueGlow}, 0.2)
end)
OrbBtn.MouseLeave:Connect(function()
    Tween(OrbBtn, {BackgroundColor3=T.Blue}, 0.2)
end)

MinBtn.MouseButton1Click:Connect(function()
    Tween(MF, {Size=UDim2.new(0,460,0,0), Position=UDim2.new(0.5,-230,0.5,0)}, 0.25, Enum.EasingStyle.Quart)
    wait(0.25); MF.Visible=false; OrbBtn.Visible=true
end)

OrbBtn.MouseButton1Click:Connect(function()
    OrbBtn.Visible=false; MF.Visible=true
    MF.Size=UDim2.new(0,0,0,0)
    MF.Position=UDim2.new(0.5,-230,0.5,-150)
    TweenBack(MF, {Size=UDim2.new(0,460,0,300)}, 0.38)
end)

CloseBtn.MouseButton1Click:Connect(function()
    Tween(MF, {BackgroundTransparency=1, Size=UDim2.new(0,460,0,0)}, 0.22)
    wait(0.22)
    SG:Destroy()
    pcall(function() OrbBtn:Destroy() end)
end)

-- ====================================================================
-- ====================== OPENING ANIMATION ==========================
-- ====================================================================
-- Urutan: Splash masuk → logo muncul → loading → splash exit → main frame buka

spawn(function()
    -- Fase 1: Garis dekor muncul
    wait(0.05)
    Tween(SplashLineTop, {Size=UDim2.new(0,300,0,2)}, 0.5, Enum.EasingStyle.Quart)
    Tween(SplashLineBtm, {Size=UDim2.new(0,300,0,2)}, 0.5, Enum.EasingStyle.Quart)

    -- Fase 2: Logo AP-NEXTGEN muncul (scale dari kecil)
    wait(0.35)
    SplashLogo.TextSize = 36
    Tween(SplashLogo, {TextTransparency=0}, 0.55, Enum.EasingStyle.Quart)
    -- Animasi TextSize tidak bisa di-tween langsung, pakai delay
    wait(0.1)
    SplashLogo.TextSize = 42
    wait(0.1)
    SplashLogo.TextSize = 48
    wait(0.1)
    SplashLogo.TextSize = 52

    -- Badge versi
    Tween(VersionBadge, {TextTransparency=0}, 0.3)

    -- Fase 3: Sub & tag muncul
    wait(0.3)
    Tween(SplashSub, {TextTransparency=0}, 0.4, Enum.EasingStyle.Quart)
    wait(0.2)
    Tween(SplashTag, {TextTransparency=0}, 0.35)
    Tween(SplashCopy, {TextTransparency=0}, 0.35)
    Tween(LoadPct,   {TextTransparency=0}, 0.35)

    -- Fase 4: Loading bar
    wait(0.3)
    local msgs = {"Initializing modules...","Loading features...","Connecting services...","Authenticating...","Ready!"}
    for i, msg in ipairs(msgs) do
        LoadPct.Text = msg
        Tween(LoadFill, {Size=UDim2.new(i/5, 0, 1, 0)}, 0.32, Enum.EasingStyle.Quart)
        wait(0.33)
    end

    wait(0.25)

    -- Fase 5: Splash fade out
    Tween(SplashBG, {BackgroundTransparency=1}, 0.55, Enum.EasingStyle.Quart)
    Tween(SplashLogo, {TextTransparency=1}, 0.4)
    Tween(SplashSub,  {TextTransparency=1}, 0.4)
    Tween(SplashTag,  {TextTransparency=1}, 0.35)
    Tween(SplashCopy, {TextTransparency=1}, 0.35)
    Tween(LoadPct,    {TextTransparency=1}, 0.3)
    Tween(VersionBadge, {TextTransparency=1}, 0.3)
    Tween(SplashLineTop, {BackgroundTransparency=1}, 0.3)
    Tween(SplashLineBtm, {BackgroundTransparency=1}, 0.3)
    Tween(LoadFill,   {BackgroundTransparency=1}, 0.3)

    wait(0.45)
    SplashBG:Destroy()

    -- Fase 6: Main frame buka dengan animasi Back
    GoPage("Dash")
    MF.Visible = true
    MF.Size     = UDim2.new(0, 0, 0, 0)
    MF.Position = UDim2.new(0.5, 0, 0.5, 0)

    wait(0.04)
    TweenBack(MF, {
        Size     = UDim2.new(0, 460, 0, 300),
        Position = UDim2.new(0.5, -230, 0.5, -150)
    }, 0.52)
end)
