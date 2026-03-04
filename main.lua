--[[
    AP-NEXTGEN v9.0 – UI SHELL (EDIT MODE) – ENHANCED EDITION
    Semua fungsi dikosongkan, tampilan + animasi tetap jalan
    Edit sesukamu lalu kirim balik untuk di-merge sama logic
]]

-- Services
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local RunService       = game:GetService("RunService")
local LocalPlayer      = Players.LocalPlayer

-- ==================== THEME (warna biru + kuning transparan) ====================
local T = {
    Bg        = Color3.fromRGB(11,  11,  17 ),  -- dasar gelap
    Surface   = Color3.fromRGB(20,  20,  30 ),  -- permukaan
    SurfaceHi = Color3.fromRGB(32,  32,  48 ),  -- lebih terang
    NavBg     = Color3.fromRGB(15,  15,  24 ),  -- sidebar
    Primary   = Color3.fromRGB(0,   170, 255),  -- biru cerah
    Success   = Color3.fromRGB(0,   210, 110),  -- hijau
    Warning   = Color3.fromRGB(255, 190, 40 ),  -- kuning/oranye
    Error     = Color3.fromRGB(255, 55,  75 ),  -- merah
    Admin     = Color3.fromRGB(255, 210, 0   ),  -- kuning emas
    Text      = Color3.fromRGB(235, 235, 255),  -- teks utama
    Muted     = Color3.fromRGB(145, 145, 175),  -- teks redup
    Border    = Color3.fromRGB( 40,  40,  62 ),  -- garis batas
}

-- Transparansi untuk efek kaca
local GLASS_ALPHA = 0.85  -- 0 = transparan penuh, 1 = solid

-- ==================== HELPERS ====================
local function Tween(obj, props, dur, style)
    TweenService:Create(obj, TweenInfo.new(dur or 0.22, style or Enum.EasingStyle.Quart), props):Play()
end
local function Round(inst, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 8); c.Parent = inst; return c
end
local function Stroke(inst, col, th)
    local s = Instance.new("UIStroke"); s.Color = col or T.Border; s.Thickness = th or 1; s.Parent = inst; return s
end
local function Lbl(parent, text, size, color, font, align)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text        = text
    l.TextSize    = size  or 11
    l.TextColor3  = color or T.Text
    l.Font        = font  or Enum.Font.Gotham
    l.TextXAlignment = align or Enum.TextXAlignment.Left
    l.Parent      = parent
    return l
end

-- ==================== SCREENGUI ====================
local SG = Instance.new("ScreenGui")
SG.Name           = "APNEXTGEN_UI"
SG.Parent         = CoreGui
SG.ResetOnSpawn   = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.DisplayOrder   = 100

-- ==================== BACKGROUND IMAGE (kaca) ====================
-- Ganti base64 di bawah dengan data:image/png;base64,...
local BgImage = Instance.new("ImageLabel")
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.Position = UDim2.new(0, 0, 0, 0)
BgImage.BackgroundTransparency = 1
BgImage.Image = ""  -- <<< ISI BASE64 ATAU IMAGE ID ANDA
BgImage.ImageTransparency = 0.4
BgImage.Parent = SG

-- ==================== OPENING SCREEN (mewah) ====================
local Opening = Instance.new("Frame")
Opening.Size = UDim2.new(1, 0, 1, 0)
Opening.BackgroundColor3 = T.Bg
Opening.BackgroundTransparency = 0
Opening.BorderSizePixel = 0
Opening.ZIndex = 200
Opening.Parent = SG

local OpeningTitle = Instance.new("TextLabel")
OpeningTitle.Size = UDim2.new(0, 400, 0, 80)
OpeningTitle.Position = UDim2.new(0.5, -200, 0.5, -60)
OpeningTitle.BackgroundTransparency = 1
OpeningTitle.Text = "AP-NEXTGEN1"
OpeningTitle.TextColor3 = T.Primary
OpeningTitle.TextSize = 48
OpeningTitle.Font = Enum.Font.GothamBlack
OpeningTitle.TextXAlignment = Enum.TextXAlignment.Center
OpeningTitle.ZIndex = 201
OpeningTitle.Parent = Opening

local OpeningSub = Instance.new("TextLabel")
OpeningSub.Size = UDim2.new(0, 300, 0, 30)
OpeningSub.Position = UDim2.new(0.5, -150, 0.5, 20)
OpeningSub.BackgroundTransparency = 1
OpeningSub.Text = "By APTECH"
OpeningSub.TextColor3 = T.Admin
OpeningSub.TextSize = 20
OpeningSub.Font = Enum.Font.Gotham
OpeningSub.TextXAlignment = Enum.TextXAlignment.Center
OpeningSub.ZIndex = 201
OpeningSub.Parent = Opening

-- Tambahkan efek garis bawah
local Underline = Instance.new("Frame")
Underline.Size = UDim2.new(0, 200, 0, 3)
Underline.Position = UDim2.new(0.5, -100, 0.5, 60)
Underline.BackgroundColor3 = T.Primary
Underline.BorderSizePixel = 0
Underline.ZIndex = 201
Round(Underline, 1.5)
Underline.Parent = Opening

-- Animasi opening: fade out + scale
task.spawn(function()
    wait(1.5)
    Tween(Opening, {BackgroundTransparency = 1}, 0.8)
    Tween(OpeningTitle, {TextTransparency = 1}, 0.6)
    Tween(OpeningSub, {TextTransparency = 1}, 0.6)
    Tween(Underline, {BackgroundTransparency = 1}, 0.6)
    wait(0.8)
    Opening:Destroy()
end)

-- ==================== MAIN FRAME (transparan) ====================
local MF = Instance.new("Frame")
MF.Name             = "MainFrame"
MF.Size             = UDim2.new(0, 450, 0, 290)
MF.Position         = UDim2.new(0.5, -225, 0.5, -145)
MF.BackgroundColor3 = T.Bg
MF.BackgroundTransparency = 1 - GLASS_ALPHA  -- efek kaca
MF.BorderSizePixel  = 0
MF.ClipsDescendants = true
MF.Active           = true
Round(MF, 18)  -- lebih bulat
Stroke(MF, T.Border, 1.5)
MF.Parent = SG

-- ==================== TOP BAR ====================
local TopBar = Instance.new("Frame")
TopBar.Size             = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = T.Surface
TopBar.BackgroundTransparency = 0.2
TopBar.BorderSizePixel  = 0
TopBar.ZIndex           = 5
Round(TopBar, 18)
TopBar.Parent = MF

-- Fix rounded corners bawah topbar
local TopFix = Instance.new("Frame")
TopFix.Size             = UDim2.new(1, 0, 0, 12)
TopFix.Position         = UDim2.new(0, 0, 1, -12)
TopFix.BackgroundColor3 = T.Surface
TopFix.BackgroundTransparency = 0.2
TopFix.BorderSizePixel  = 0
TopFix.ZIndex           = 4
TopFix.Parent           = TopBar

-- Avatar foto profil
local AvImg = Instance.new("ImageLabel")
AvImg.Size             = UDim2.new(0, 30, 0, 30)
AvImg.Position         = UDim2.new(0, 6, 0.5, -15)
AvImg.BackgroundColor3 = T.SurfaceHi
AvImg.BackgroundTransparency = 0.3
AvImg.Image            = "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=150&height=150&format=png"
AvImg.ZIndex           = 6
Round(AvImg, 15)
AvImg.Parent = TopBar

-- Nama user
local NameLbl = Lbl(TopBar, LocalPlayer.Name, 11, T.Text, Enum.Font.GothamBold)
NameLbl.Size          = UDim2.new(0, 100, 0, 13)
NameLbl.Position      = UDim2.new(0, 40, 0, 5)
NameLbl.ZIndex        = 6
NameLbl.TextTruncate  = Enum.TextTruncate.AtEnd

-- Info game kecil di bawah nama
local GameLbl = Lbl(TopBar, game.Name:sub(1,14), 8, T.Muted)
GameLbl.Size          = UDim2.new(0, 100, 0, 11)
GameLbl.Position      = UDim2.new(0, 40, 0, 20)
GameLbl.ZIndex        = 6
GameLbl.TextTruncate  = Enum.TextTruncate.AtEnd

-- Server info tengah
local SrvLbl = Lbl(TopBar, "🌐 Global | ID:"..tostring(game.PlaceId):sub(1,9).." | --/--", 9, T.Primary, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
SrvLbl.Size          = UDim2.new(0, 220, 0, 14)
SrvLbl.Position      = UDim2.new(0.5, -110, 0.5, -7)
SrvLbl.ZIndex        = 6
SrvLbl.TextTruncate  = Enum.TextTruncate.AtEnd

-- Tombol minimize dengan image base64 (placeholder)
local MinBtn = Instance.new("ImageButton")
MinBtn.Size             = UDim2.new(0, 26, 0, 26)
MinBtn.Position         = UDim2.new(1, -58, 0.5, -13)
MinBtn.BackgroundColor3 = T.SurfaceHi
MinBtn.BackgroundTransparency = 0.3
MinBtn.Image = ""  -- <<< ISI BASE64 ANDA UNTUK ICON MINIMIZE (data:image/png;base64,...)
MinBtn.ZIndex           = 7
MinBtn.AutoButtonColor  = false
Round(MinBtn, 8)  -- setengah bulat
MinBtn.Parent = TopBar

-- Tombol close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size             = UDim2.new(0, 26, 0, 26)
CloseBtn.Position         = UDim2.new(1, -30, 0.5, -13)
CloseBtn.BackgroundColor3 = T.Error
CloseBtn.BackgroundTransparency = 0.1
CloseBtn.Text             = "✕"
CloseBtn.TextColor3       = Color3.new(1, 1, 1)
CloseBtn.TextSize         = 14
CloseBtn.Font             = Enum.Font.GothamBold
CloseBtn.ZIndex           = 7
CloseBtn.AutoButtonColor  = false
Round(CloseBtn, 8)
CloseBtn.Parent = TopBar

-- ==================== SERVER INFO UPDATER ====================
spawn(function()
    while SrvLbl.Parent do
        local pc = #Players:GetPlayers(); local mp = 0; pcall(function() mp = Players.MaxPlayers end)
        GameLbl.Text = game.Name:sub(1, 14)
        SrvLbl.Text  = "🌐 Global | ID:"..tostring(game.PlaceId):sub(1,9).." | "..pc.."/"..mp
        wait(5)
    end
end)

-- ==================== DRAG TOPBAR ====================
local _drag, _ds, _sp = false, nil, nil
TopBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        _drag = true; _ds = i.Position; _sp = MF.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if _drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - _ds
        MF.Position = UDim2.new(_sp.X.Scale, _sp.X.Offset + d.X, _sp.Y.Scale, _sp.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then _drag = false end
end)

-- ==================== LEFT NAV SIDEBAR ====================
local NavFrame = Instance.new("ScrollingFrame")
NavFrame.Size                = UDim2.new(0, 50, 1, -40)
NavFrame.Position            = UDim2.new(0, 0, 0, 40)
NavFrame.BackgroundColor3    = T.NavBg
NavFrame.BackgroundTransparency = 0.2
NavFrame.BorderSizePixel     = 0
NavFrame.ScrollBarThickness  = 0
NavFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
NavFrame.ScrollingDirection  = Enum.ScrollingDirection.Y
NavFrame.Parent              = MF

local NavLL = Instance.new("UIListLayout")
NavLL.Padding             = UDim.new(0, 4)
NavLL.HorizontalAlignment = Enum.HorizontalAlignment.Center
NavLL.Parent              = NavFrame

local NavPad = Instance.new("UIPadding")
NavPad.PaddingTop   = UDim.new(0, 6)
NavPad.PaddingLeft  = UDim.new(0, 3)
NavPad.PaddingRight = UDim.new(0, 3)
NavPad.Parent       = NavFrame

-- Garis pemisah sidebar
local Div = Instance.new("Frame")
Div.Size             = UDim2.new(0, 1, 1, -40)
Div.Position         = UDim2.new(0, 50, 0, 40)
Div.BackgroundColor3 = T.Border
Div.BackgroundTransparency = 0.3
Div.BorderSizePixel  = 0
Div.Parent           = MF

-- ==================== CONTENT AREA ====================
local ContentArea = Instance.new("Frame")
ContentArea.Size             = UDim2.new(1, -51, 1, -40)
ContentArea.Position         = UDim2.new(0, 51, 0, 40)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.Parent           = MF

-- ==================== PAGE SYSTEM ====================
local Pages      = {}
local NavBtns    = {}

local function NewPage(name)
    local sf = Instance.new("ScrollingFrame")
    sf.Name                = name
    sf.Size                = UDim2.new(1, 0, 1, 0)
    sf.BackgroundTransparency = 1
    sf.BorderSizePixel     = 0
    sf.ScrollBarThickness  = 4
    sf.ScrollBarImageColor3= T.Primary
    sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sf.ScrollingDirection  = Enum.ScrollingDirection.Y
    sf.Visible             = false
    sf.Parent              = ContentArea

    local ll = Instance.new("UIListLayout"); ll.Padding = UDim.new(0, 8); ll.Parent = sf
    local pd = Instance.new("UIPadding")
    pd.PaddingTop = UDim.new(0,8); pd.PaddingLeft = UDim.new(0,8)
    pd.PaddingRight = UDim.new(0,8); pd.PaddingBottom = UDim.new(0,8)
    pd.Parent = sf

    Pages[name] = sf
    return sf
end

local function GoPage(name)
    for n, pg in pairs(Pages) do pg.Visible = (n == name) end
    for n, btn in pairs(NavBtns) do
        if n == name then
            Tween(btn, {BackgroundColor3 = T.Primary, BackgroundTransparency = 0}, 0.18)
            Tween(btn, {TextColor3 = Color3.new(1,1,1)}, 0.18)
        else
            Tween(btn, {BackgroundColor3 = T.NavBg, BackgroundTransparency = 0.2}, 0.18)
            Tween(btn, {TextColor3 = T.Muted}, 0.18)
        end
    end
end

local function NavBtn(icon, pageName)
    local b = Instance.new("TextButton")
    b.Size             = UDim2.new(0, 42, 0, 36)
    b.BackgroundColor3 = T.NavBg
    b.BackgroundTransparency = 0.2
    b.Text             = icon
    b.TextColor3       = T.Muted
    b.TextSize         = 16
    b.Font             = Enum.Font.GothamBold
    b.BorderSizePixel  = 0
    b.AutoButtonColor  = false
    Round(b, 10)
    b.Parent  = NavFrame
    NavBtns[pageName] = b
    b.MouseButton1Click:Connect(function() GoPage(pageName) end)
    return b
end

-- ==================== UI COMPONENT BUILDERS ====================
-- Section card (judul + container isi) dengan efek transparan
local function Section(parent, title)
    local card = Instance.new("Frame")
    card.Size             = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize    = Enum.AutomaticSize.Y
    card.BackgroundColor3 = T.Surface
    card.BackgroundTransparency = 0.15
    card.BorderSizePixel  = 0
    Round(card, 12)
    card.Parent = parent

    local ttl = Lbl(card, title, 11, T.Primary, Enum.Font.GothamBold)
    ttl.Size     = UDim2.new(1, -12, 0, 22)
    ttl.Position = UDim2.new(0, 8, 0, 5)

    local line = Instance.new("Frame")
    line.Size             = UDim2.new(1, -16, 0, 1)
    line.Position         = UDim2.new(0, 8, 0, 28)
    line.BackgroundColor3 = T.Border
    line.BackgroundTransparency = 0.4
    line.BorderSizePixel  = 0
    line.Parent           = card

    local cont = Instance.new("Frame")
    cont.Name             = "Cont"
    cont.Size             = UDim2.new(1, -12, 0, 0)
    cont.Position         = UDim2.new(0, 6, 0, 32)
    cont.AutomaticSize    = Enum.AutomaticSize.Y
    cont.BackgroundTransparency = 1
    cont.Parent           = card

    local cL = Instance.new("UIListLayout"); cL.Padding = UDim.new(0, 6); cL.Parent = cont
    local cP = Instance.new("UIPadding");   cP.PaddingBottom = UDim.new(0, 8); cP.Parent = card

    return cont
end

-- Toggle row (dengan efek warna kuning saat on)
local function Toggle(parent, text, _callback)
    local row = Instance.new("Frame")
    row.Size             = UDim2.new(1, 0, 0, 28)
    row.BackgroundTransparency = 1
    row.Parent           = parent

    local lbl = Lbl(row, text, 10, T.Text)
    lbl.Size = UDim2.new(0.7, 0, 1, 0)

    local btn = Instance.new("TextButton")
    btn.Size             = UDim2.new(0, 46, 0, 20)
    btn.Position         = UDim2.new(1, -46, 0.5, -10)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 62)
    btn.BackgroundTransparency = 0.2
    btn.Text             = "OFF"
    btn.TextColor3       = T.Muted
    btn.TextSize         = 9
    btn.Font             = Enum.Font.GothamBold
    btn.AutoButtonColor  = false
    Round(btn, 10)
    btn.Parent = row

    local on = false
    btn.MouseButton1Click:Connect(function()
        on = not on
        btn.Text = on and "ON" or "OFF"
        Tween(btn, {BackgroundColor3 = on and T.Success or Color3.fromRGB(45,45,62)}, 0.18)
        Tween(btn, {TextColor3 = on and Color3.new(1,1,1) or T.Muted}, 0.18)
        if _callback then _callback(on) end
    end)
    return btn
end

-- Slider row (dengan warna biru)
local function Slider(parent, text, min, max, default, _callback)
    local frame = Instance.new("Frame")
    frame.Size             = UDim2.new(1, 0, 0, 48)
    frame.BackgroundTransparency = 1
    frame.Parent           = parent

    local topRow = Instance.new("Frame")
    topRow.Size            = UDim2.new(1, 0, 0, 18)
    topRow.BackgroundTransparency = 1
    topRow.Parent          = frame

    local lbl = Lbl(topRow, text, 10, T.Text)
    lbl.Size = UDim2.new(0.62, 0, 1, 0)

    local vbox = Instance.new("TextBox")
    vbox.Size             = UDim2.new(0, 48, 0, 18)
    vbox.Position         = UDim2.new(1, -48, 0, 0)
    vbox.BackgroundColor3 = T.SurfaceHi
    vbox.BackgroundTransparency = 0.2
    vbox.Text             = tostring(default)
    vbox.TextColor3       = T.Primary
    vbox.TextSize         = 10
    vbox.Font             = Enum.Font.GothamBold
    vbox.ClearTextOnFocus = false
    Round(vbox, 5)
    vbox.Parent = topRow

    local track = Instance.new("Frame")
    track.Size             = UDim2.new(1, 0, 0, 4)
    track.Position         = UDim2.new(0, 0, 0, 30)
    track.BackgroundColor3 = Color3.fromRGB(38, 38, 55)
    track.BackgroundTransparency = 0.3
    track.BorderSizePixel  = 0
    Round(track, 2)
    track.Parent = frame

    local pct  = (default - min) / math.max(max - min, 1)
    local fill = Instance.new("Frame")
    fill.Size             = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = T.Primary
    fill.BorderSizePixel  = 0
    Round(fill, 2)
    fill.Parent = track

    local knob = Instance.new("Frame")
    knob.Size             = UDim2.new(0, 14, 0, 14)
    knob.Position         = UDim2.new(pct, -7, 0.5, -7)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    Round(knob, 7)
    knob.Parent = track

    local dragging = false
    local function doUpdate(input)
        local p = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local v = math.floor(min + (max - min) * p)
        vbox.Text     = tostring(v)
        fill.Size     = UDim2.new(p, 0, 1, 0)
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
        vbox.Text     = tostring(v)
        local p = (v - min) / math.max(max - min, 1)
        fill.Size     = UDim2.new(p, 0, 1, 0)
        knob.Position = UDim2.new(p, -7, 0.5, -7)
        if _callback then _callback(v) end
    end)

    return frame
end

-- Button dengan efek warna biru/kuning
local function Btn(parent, text, style, _callback)
    local col = style == "primary" and T.Primary
             or style == "success"  and T.Success
             or style == "danger"   and T.Error
             or style == "admin"    and T.Admin
             or T.SurfaceHi
    local b = Instance.new("TextButton")
    b.Size             = UDim2.new(1, 0, 0, 28)
    b.BackgroundColor3 = col
    b.BackgroundTransparency = 0.1
    b.Text             = text
    b.TextColor3       = style == "admin" and Color3.new(0,0,0) or Color3.new(1,1,1)
    b.TextSize         = 11
    b.Font             = Enum.Font.GothamBold
    b.BorderSizePixel  = 0
    b.AutoButtonColor  = false
    Round(b, 8)
    b.Parent = parent
    b.MouseButton1Click:Connect(function()
        Tween(b, {BackgroundColor3 = col:Lerp(Color3.new(1,1,1), 0.25), BackgroundTransparency = 0}, 0.07)
        wait(0.07); Tween(b, {BackgroundColor3 = col, BackgroundTransparency = 0.1}, 0.1)
        if _callback then _callback() end
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
local dsC   = Section(PgDash, "📊 SERVER MONITOR")
local plrC  = Section(PgDash, "👤 PLAYER INFO")

local function StatRow(parent, labelTxt, valTxt, valCol)
    local row = Instance.new("Frame"); row.Size = UDim2.new(1,0,0,20); row.BackgroundTransparency=1; row.Parent=parent
    local l = Lbl(row, labelTxt, 9, T.Muted); l.Size = UDim2.new(0.52,0,1,0)
    local v = Lbl(row, valTxt, 9, valCol or T.Primary, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
    v.Size = UDim2.new(0.48,0,1,0); v.Position = UDim2.new(0.52,0,0,0); return v
end

StatRow(dsC, "Game Name:",   game.Name:sub(1,18),                 T.Primary)
StatRow(dsC, "Place ID:",    tostring(game.PlaceId),               T.Warning)
StatRow(dsC, "Job ID:",      game.JobId:sub(1,12).."...",          T.Muted)
local sPly = StatRow(dsC, "Players:", "--/--",                    T.Success)
StatRow(dsC, "Server Type:", "🌐 Global",                          T.Primary)

StatRow(plrC, "Username:",     LocalPlayer.Name,                   T.Primary)
StatRow(plrC, "User ID:",      tostring(LocalPlayer.UserId),        T.Muted)
StatRow(plrC, "Display Name:", LocalPlayer.DisplayName,             T.Text)
StatRow(plrC, "Team:",         "None",                              T.Warning)

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

-- Speed +/- row
local spdRow = Instance.new("Frame")
spdRow.Size = UDim2.new(1,0,0,28); spdRow.BackgroundTransparency=1; spdRow.Parent=flyC

local spdLbl = Lbl(spdRow,"Fly Speed:",10,T.Text); spdLbl.Size = UDim2.new(0.36,0,1,0)

local flyMin = Instance.new("TextButton")
flyMin.Size=UDim2.new(0,26,0,22); flyMin.Position=UDim2.new(0.38,0,0.5,-11)
flyMin.BackgroundColor3=T.SurfaceHi; flyMin.BackgroundTransparency=0.2; flyMin.Text="−"; flyMin.TextColor3=T.Text
flyMin.TextSize=16; flyMin.Font=Enum.Font.GothamBold; flyMin.AutoButtonColor=false
Round(flyMin,7); flyMin.Parent=spdRow

local flyDisp = Instance.new("TextLabel")
flyDisp.Size=UDim2.new(0,36,0,22); flyDisp.Position=UDim2.new(0.38,28,0.5,-11)
flyDisp.BackgroundColor3=T.Surface; flyDisp.BackgroundTransparency=0.2; flyDisp.Text="1"; flyDisp.TextColor3=T.Primary
flyDisp.TextSize=12; flyDisp.Font=Enum.Font.GothamBold; flyDisp.TextXAlignment=Enum.TextXAlignment.Center
Round(flyDisp,7); flyDisp.Parent=spdRow

local flyPlus = Instance.new("TextButton")
flyPlus.Size=UDim2.new(0,26,0,22); flyPlus.Position=UDim2.new(0.38,66,0.5,-11)
flyPlus.BackgroundColor3=T.SurfaceHi; flyPlus.BackgroundTransparency=0.2; flyPlus.Text="+"; flyPlus.TextColor3=T.Text
flyPlus.TextSize=16; flyPlus.Font=Enum.Font.GothamBold; flyPlus.AutoButtonColor=false
Round(flyPlus,7); flyPlus.Parent=spdRow

-- UP/DOWN row
local udRow = Instance.new("Frame")
udRow.Size=UDim2.new(1,0,0,30); udRow.BackgroundTransparency=1; udRow.Parent=flyC

local flyUpBtn = Instance.new("TextButton")
flyUpBtn.Size=UDim2.new(0.49,0,0,26); flyUpBtn.BackgroundColor3=T.SurfaceHi
flyUpBtn.BackgroundTransparency=0.2; flyUpBtn.Text="▲  UP"; flyUpBtn.TextColor3=T.Text; flyUpBtn.TextSize=11
flyUpBtn.Font=Enum.Font.GothamBold; flyUpBtn.AutoButtonColor=false
Round(flyUpBtn,8); flyUpBtn.Parent=udRow

local flyDnBtn = Instance.new("TextButton")
flyDnBtn.Size=UDim2.new(0.49,0,0,26); flyDnBtn.Position=UDim2.new(0.51,0,0,0)
flyDnBtn.BackgroundColor3=T.SurfaceHi; flyDnBtn.BackgroundTransparency=0.2; flyDnBtn.Text="▼  DOWN"
flyDnBtn.TextColor3=T.Text; flyDnBtn.TextSize=11; flyDnBtn.Font=Enum.Font.GothamBold
flyDnBtn.AutoButtonColor=false; Round(flyDnBtn,8); flyDnBtn.Parent=udRow

-- Fly toggle
local flyTogBtn = Instance.new("TextButton")
flyTogBtn.Size=UDim2.new(1,0,0,30); flyTogBtn.BackgroundColor3=Color3.fromRGB(45,45,62)
flyTogBtn.BackgroundTransparency=0.2; flyTogBtn.Text="✈️  FLY: OFF"; flyTogBtn.TextColor3=T.Muted; flyTogBtn.TextSize=13
flyTogBtn.Font=Enum.Font.GothamBold; flyTogBtn.AutoButtonColor=false
Round(flyTogBtn,10); flyTogBtn.Parent=flyC

-- Noclip
local ncC = Section(PgFly, "🔮 NOCLIP")
Toggle(ncC, "No Clip (pass through walls)")

-- ---------- ESP ----------
local espC   = Section(PgESP, "👁️ PLAYER ESP")
Toggle(espC, "Enable Player ESP")

local espV2C = Section(PgESP, "👑 ESP V2  –  ADMIN ONLY")
local espLock = Lbl(espV2C, "🔒 Login Admin untuk mengaktifkan ESP V2", 9, T.Warning)
espLock.Size = UDim2.new(1,0,0,20)
Toggle(espV2C, "👑 ESP V2 (HP + Dist + Team + RGB)")

local blkEspC = Section(PgESP, "🧱 BLOCK / ITEM ESP")
Toggle(blkEspC, "Scan & highlight blocks / items")

-- ---------- TELEPORT ----------
local tpC = Section(PgTP, "🎯 TELEPORT")

local tpSF = Instance.new("ScrollingFrame")
tpSF.Size=UDim2.new(1,0,0,90); tpSF.BackgroundColor3=T.SurfaceHi; tpSF.BackgroundTransparency=0.3
tpSF.BorderSizePixel=0; tpSF.ScrollBarThickness=4; tpSF.CanvasSize=UDim2.new(0,0,0,0)
Round(tpSF,8); tpSF.Parent=tpC

local tpLL = Instance.new("UIListLayout"); tpLL.Padding=UDim.new(0,4); tpLL.Parent=tpSF

local function RefreshTPList()
    for _, c in pairs(tpSF:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    local n = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            n = n + 1
            local b = Instance.new("TextButton")
            b.Size=UDim2.new(1,-6,0,26); b.Position=UDim2.new(0,3,0,0)
            b.BackgroundColor3=T.Surface; b.BackgroundTransparency=0.2; b.Text=p.Name; b.TextColor3=Color3.new(1,1,1)
            b.TextSize=10; b.Font=Enum.Font.Gotham; b.BorderSizePixel=0; b.AutoButtonColor=false
            Round(b,6); b.Parent=tpSF
            b.MouseButton1Click:Connect(function()
                Tween(b,{BackgroundColor3=T.Primary, BackgroundTransparency=0},0.12)
            end)
        end
    end
    tpSF.CanvasSize = UDim2.new(0,0,0,n*30)
end
RefreshTPList()
Players.PlayerAdded:Connect(RefreshTPList)
Players.PlayerRemoving:Connect(RefreshTPList)

Btn(tpC, "Teleport to Selected", "primary")
Toggle(tpC, "Follow Selected Player")

-- ---------- GOD ----------
local godC = Section(PgGod, "🛡️ GOD MODE")

local godModeBtn = Instance.new("TextButton")
godModeBtn.Size=UDim2.new(1,0,0,26); godModeBtn.BackgroundColor3=T.SurfaceHi
godModeBtn.BackgroundTransparency=0.2; godModeBtn.Text="Mode: Gen1  (auto-heal)"; godModeBtn.TextColor3=T.Text
godModeBtn.TextSize=10; godModeBtn.Font=Enum.Font.GothamBold; godModeBtn.AutoButtonColor=false
Round(godModeBtn,8); godModeBtn.Parent=godC

Toggle(godC, "God Mode")
Toggle(godC, "Auto Heal (setiap 0.2s)")
Btn(godC, "Heal Now", "success")

-- ---------- WORLD ----------
local wC = Section(PgWorld, "🧱 BLOCK SPAWNER")

-- Dropdown sederhana
local function Dropdown(parent, labelTxt, opts)
    local frame = Instance.new("Frame")
    frame.Size=UDim2.new(1,0,0,0); frame.AutomaticSize=Enum.AutomaticSize.Y
    frame.BackgroundTransparency=1; frame.Parent=parent

    local row = Instance.new("TextButton")
    row.Size=UDim2.new(1,0,0,26); row.BackgroundColor3=T.SurfaceHi
    row.BackgroundTransparency=0.2; row.Text=labelTxt..": "..opts[1].." ▾"; row.TextColor3=T.Text
    row.TextSize=10; row.Font=Enum.Font.GothamBold; row.AutoButtonColor=false
    Round(row,7); row.Parent=frame

    local list = Instance.new("Frame")
    list.Size=UDim2.new(1,0,0,0); list.BackgroundColor3=T.Surface
    list.BackgroundTransparency=0.1; list.BorderSizePixel=0; list.ClipsDescendants=true; list.ZIndex=10
    Round(list,6); list.Parent=frame

    local ll = Instance.new("UIListLayout"); ll.Parent=list
    local open = false

    for _, opt in ipairs(opts) do
        local ob = Instance.new("TextButton")
        ob.Size=UDim2.new(1,0,0,24); ob.BackgroundColor3=T.Surface; ob.BackgroundTransparency=0.2; ob.Text=opt
        ob.TextColor3=T.Text; ob.TextSize=9; ob.Font=Enum.Font.Gotham
        ob.BorderSizePixel=0; ob.AutoButtonColor=false; ob.ZIndex=11; ob.Parent=list
        ob.MouseButton1Click:Connect(function()
            row.Text=labelTxt..": "..opt.." ▾"
            open=false; Tween(list,{Size=UDim2.new(1,0,0,0)},0.15)
        end)
    end

    row.MouseButton1Click:Connect(function()
        open = not open
        Tween(list,{Size=UDim2.new(1,0,0,open and #opts*24 or 0)},0.18)
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
avStatus.Size  = UDim2.new(1,0,0,18)

local avSF = Instance.new("ScrollingFrame")
avSF.Size=UDim2.new(1,0,0,90); avSF.BackgroundColor3=T.SurfaceHi; avSF.BackgroundTransparency=0.3
avSF.BorderSizePixel=0; avSF.ScrollBarThickness=4; avSF.CanvasSize=UDim2.new(0,0,0,0)
Round(avSF,8); avSF.Parent=avC

local avLL = Instance.new("UIListLayout"); avLL.Padding=UDim.new(0,4); avLL.Parent=avSF

local function RefreshAvaList()
    for _, c in pairs(avSF:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    local n = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            n=n+1
            local b = Instance.new("TextButton")
            b.Size=UDim2.new(1,-6,0,26); b.Position=UDim2.new(0,3,0,0)
            b.BackgroundColor3=T.Surface; b.BackgroundTransparency=0.2; b.Text=p.Name; b.TextColor3=Color3.new(1,1,1)
            b.TextSize=10; b.Font=Enum.Font.Gotham; b.BorderSizePixel=0; b.AutoButtonColor=false
            Round(b,6); b.Parent=avSF
            b.MouseButton1Click:Connect(function()
                for _, bb in pairs(avSF:GetChildren()) do
                    if bb:IsA("TextButton") then Tween(bb,{BackgroundColor3=T.Surface, BackgroundTransparency=0.2},0.1) end
                end
                Tween(b,{BackgroundColor3=T.Primary, BackgroundTransparency=0},0.12)
            end)
        end
    end
    avSF.CanvasSize = UDim2.new(0,0,0,n*30)
end
RefreshAvaList()
Players.PlayerAdded:Connect(RefreshAvaList)
Players.PlayerRemoving:Connect(RefreshAvaList)

Btn(avC, "👤 Copy Avatar Target", "primary")
Btn(avC, "🔄 Restore Avatar Saya", "normal")

-- ---------- PRESETS ----------
local svC = Section(PgSave, "💾 SAVE PRESET")

local preNameBox = Instance.new("TextBox")
preNameBox.Size=UDim2.new(1,0,0,26); preNameBox.BackgroundColor3=T.SurfaceHi
preNameBox.BackgroundTransparency=0.2; preNameBox.PlaceholderText="Nama preset…"; preNameBox.Text=""
preNameBox.TextColor3=T.Text; preNameBox.TextSize=10; preNameBox.Font=Enum.Font.Gotham
preNameBox.ClearTextOnFocus=false; Round(preNameBox,7); preNameBox.Parent=svC

local preSF = Instance.new("ScrollingFrame")
preSF.Size=UDim2.new(1,0,0,80); preSF.BackgroundColor3=T.SurfaceHi; preSF.BackgroundTransparency=0.3
preSF.BorderSizePixel=0; preSF.ScrollBarThickness=4; preSF.CanvasSize=UDim2.new(0,0,0,0)
Round(preSF,8); preSF.Parent=svC
local preLL = Instance.new("UIListLayout"); preLL.Padding=UDim.new(0,4); preLL.Parent=preSF

Btn(svC, "💾 Save Settings Sekarang", "primary")

local exportBox = Instance.new("TextBox")
exportBox.Size=UDim2.new(1,0,0,50); exportBox.BackgroundColor3=T.NavBg
exportBox.BackgroundTransparency=0.2; exportBox.PlaceholderText="Kode export akan muncul di sini…"; exportBox.Text=""
exportBox.TextColor3=T.Primary; exportBox.TextSize=8; exportBox.Font=Enum.Font.Code
exportBox.MultiLine=true; exportBox.TextXAlignment=Enum.TextXAlignment.Left
exportBox.TextYAlignment=Enum.TextYAlignment.Top; exportBox.ClearTextOnFocus=false
Round(exportBox,6); exportBox.Parent=svC

local importBox = Instance.new("TextBox")
importBox.Size=UDim2.new(1,0,0,44); importBox.BackgroundColor3=T.NavBg
importBox.BackgroundTransparency=0.2; importBox.PlaceholderText="Paste kode import di sini…"; importBox.Text=""
importBox.TextColor3=T.Text; importBox.TextSize=8; importBox.Font=Enum.Font.Code
importBox.MultiLine=true; importBox.TextXAlignment=Enum.TextXAlignment.Left
importBox.TextYAlignment=Enum.TextYAlignment.Top; importBox.ClearTextOnFocus=false
Round(importBox,6); importBox.Parent=svC

Btn(svC, "📥 Import dari Kode", "normal")

-- ---------- ADMIN ----------
local adC = Section(PgAdmin, "🔐 ADMIN LOGIN")

local adStatus = Lbl(adC, "🔒 Belum terautentikasi", 9, T.Muted)
adStatus.Size  = UDim2.new(1,0,0,18)

local pwBox = Instance.new("TextBox")
pwBox.Size=UDim2.new(1,0,0,28); pwBox.BackgroundColor3=T.NavBg
pwBox.BackgroundTransparency=0.2; pwBox.PlaceholderText="Masukkan password…"; pwBox.Text=""
pwBox.TextColor3=T.Text; pwBox.TextSize=11; pwBox.Font=Enum.Font.GothamBold
pwBox.ClearTextOnFocus=false; Round(pwBox,8); pwBox.Parent=adC

Btn(adC, "🔓 Unlock Admin Mode", "admin")

-- ---------- UTILITY ----------
local utC  = Section(PgUtil, "⚙️ UTILITIES")
local srC  = Section(PgUtil, "🌐 SERVER")

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
OrbBtn.Size=UDim2.new(0,48,0,48); OrbBtn.Position=UDim2.new(0,12,0.5,-24)
OrbBtn.BackgroundColor3=T.Primary; OrbBtn.BackgroundTransparency=0.1; OrbBtn.Text="AP"; OrbBtn.TextColor3=Color3.new(1,1,1)
OrbBtn.TextSize=16; OrbBtn.Font=Enum.Font.GothamBlack
OrbBtn.Visible=false; OrbBtn.ZIndex=100; OrbBtn.Active=true; OrbBtn.Draggable=true
OrbBtn.AutoButtonColor=false; Round(OrbBtn,24); Stroke(OrbBtn,T.Primary,2)
OrbBtn.Parent = SG

MinBtn.MouseButton1Click:Connect(function()
    Tween(MF, {Size=UDim2.new(0,450,0,0), BackgroundTransparency = 1}, 0.22)
    wait(0.22); MF.Visible=false; OrbBtn.Visible=true
end)

OrbBtn.MouseButton1Click:Connect(function()
    OrbBtn.Visible=false; MF.Visible=true
    Tween(MF, {Size=UDim2.new(0,450,0,290), BackgroundTransparency = 1 - GLASS_ALPHA}, 0.3, Enum.EasingStyle.Back)
end)

CloseBtn.MouseButton1Click:Connect(function()
    SG:Destroy(); pcall(function() OrbBtn:Destroy() end)
end)

-- ==================== FOOTER "script by aptech" ====================
local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(0, 120, 0, 20)
Footer.Position = UDim2.new(1, -130, 1, -25)
Footer.BackgroundTransparency = 1
Footer.Text = "script by aptech"
Footer.TextColor3 = T.Muted
Footer.TextSize = 9
Footer.Font = Enum.Font.Gotham
Footer.TextXAlignment = Enum.TextXAlignment.Right
Footer.Parent = MF

-- ====================================================================
-- ====================== OPENING ANIMATION ==========================
-- ====================================================================
MF.Size = UDim2.new(0, 0, 0, 0)
MF.BackgroundTransparency = 1
GoPage("Dash")
wait(0.1)
Tween(MF, {Size=UDim2.new(0,450,0,290), BackgroundTransparency = 1 - GLASS_ALPHA}, 0.6, Enum.EasingStyle.Back)
