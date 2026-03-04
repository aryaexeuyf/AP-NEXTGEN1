--[[
    AP-NEXTGEN v9.2 – FIXED EDITION (Revisi UI & Opening)
    Perubahan utama:
      • Nav icons diganti karo emoji tema lawas (kaya request)
      • Opening: efek "lawas" typewriter + garis animasi, background opening lebih lembut (ora hitam pekat)
      • Logo/avatar kotak dengan sudut melengkung (tidak lancip)
      • UI lebih halus, transparansi disetel merata, tweens disesuaikan
      • Tetep aman: pcall untuk executor, task.wait dipakai, thread opening non-blocking
]]

-- ==================== SERVICES ====================
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local LocalPlayer      = Players.LocalPlayer

-- ==================== SAFE GLOBAL CHECKS ====================
local function safeGet(name)
    local ok, v = pcall(function() return getfenv()[name] end)
    return (ok and v ~= nil) and v or nil
end

local _syn = safeGet("syn")
local httpFunc = (_syn and _syn.request)
              or safeGet("http_request")
              or (safeGet("http") and safeGet("http").request)
              or safeGet("request")

local _writefile = safeGet("writefile")
local _getAsset  = safeGet("getcustomasset") or safeGet("getsynasset")

local imageUrls = {
    logo = "https://raw.githubusercontent.com/aryaexeuyf/Image/main/logo_g1.png",
    bg   = "https://raw.githubusercontent.com/aryaexeuyf/Image/main/background.jpg"
}

local function fetchImage(url, filename)
    if not httpFunc or not _writefile or not _getAsset then return "" end
    local ok, res = pcall(httpFunc, {
        Url=url, Method="GET",
        Headers={["User-Agent"]="Mozilla/5.0"}
    })
    if not ok or not res or not res.Body or #res.Body < 100 then return "" end
    if not pcall(_writefile, filename, res.Body) then return "" end
    local aOk, id = pcall(_getAsset, filename)
    return (aOk and id and id ~= "") and id or ""
end

-- ==================== THEME ====================
local T = {
    Bg        = Color3.fromRGB(8,   8,  20),
    Surface   = Color3.fromRGB(18, 18,  38),
    SurfaceHi = Color3.fromRGB(28, 28,  52),
    NavBg     = Color3.fromRGB(10, 10,  22),
    Primary   = Color3.fromRGB(0,  170, 255),
    Success   = Color3.fromRGB(0,  200, 105),
    Warning   = Color3.fromRGB(255,198,   0),
    Error     = Color3.fromRGB(255, 60,  70),
    Admin     = Color3.fromRGB(255,210,   0),
    Text      = Color3.fromRGB(230,230, 248),
    Muted     = Color3.fromRGB(130,130, 165),
    Border    = Color3.fromRGB(50,  50,  95),
    bgTrans   = 0.36,
    sfTrans   = 0.24,
    navTrans  = 0.46,
}

-- ==================== HELPERS ====================
local function Tween(obj, props, dur, style)
    TweenService:Create(obj,
        TweenInfo.new(dur or 0.2, style or Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        props):Play()
end

local function Round(inst, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = inst
end

local function Stroke(inst, col, th)
    local s = Instance.new("UIStroke")
    s.Color     = col or T.Border
    s.Thickness = th  or 1
    s.Transparency = 0.12
    s.Parent    = inst
end

local function Lbl(parent, text, size, color, font, ax)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text           = text
    l.TextSize       = size  or 11
    l.TextColor3     = color or T.Text
    l.Font           = font  or Enum.Font.Gotham
    l.TextXAlignment = ax    or Enum.TextXAlignment.Left
    l.TextTruncate   = Enum.TextTruncate.AtEnd
    l.Parent         = parent
    return l
end

-- ==================== SCREENGUI ====================
local SG = Instance.new("ScreenGui")
SG.Name          = "APNEXTGEN_UI"
SG.Parent        = CoreGui
SG.ResetOnSpawn  = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.DisplayOrder  = 1000

-- ==================== CONSTANTS ====================
local TOP_H = 42
local NAV_W = 52
local WIN_W = 460
local WIN_H = 295

-- ==================== MAIN FRAME ====================
local MF = Instance.new("Frame")
MF.Name                  = "MainFrame"
MF.Size                  = UDim2.new(0, WIN_W, 0, WIN_H)
MF.Position              = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2)
MF.BackgroundColor3      = T.Bg
MF.BackgroundTransparency = T.bgTrans
MF.BorderSizePixel       = 0
MF.ClipsDescendants      = true
MF.Active                = true
MF.Visible               = false
Round(MF, 14)
Stroke(MF, T.Primary, 1)
MF.Parent = SG

local BgImage = Instance.new("ImageLabel")
BgImage.Size               = UDim2.new(1,0,1,0)
BgImage.BackgroundTransparency = 1
BgImage.Image              = ""
BgImage.ScaleType          = Enum.ScaleType.Crop
BgImage.ImageTransparency  = 0.32
BgImage.ZIndex             = 0
BgImage.Parent             = MF

-- ==================== TOP BAR ====================
local TopBar = Instance.new("Frame")
TopBar.Size                  = UDim2.new(1, 0, 0, TOP_H)
TopBar.BackgroundColor3      = T.Surface
TopBar.BackgroundTransparency = T.sfTrans
TopBar.BorderSizePixel       = 0
TopBar.ZIndex                = 5
TopBar.Parent                = MF
Round(TopBar, 14)

local TopPatch = Instance.new("Frame")
TopPatch.Size                  = UDim2.new(1,0,0,14)
TopPatch.Position              = UDim2.new(0,0,1,-14)
TopPatch.BackgroundColor3      = T.Surface
TopPatch.BackgroundTransparency = T.sfTrans
TopPatch.BorderSizePixel       = 0
TopPatch.ZIndex                = 4
TopPatch.Parent                = TopBar

-- Logo square (kotak melengkung) di pojok kiri atas
local LogoSquare = Instance.new("ImageLabel")
LogoSquare.Size = UDim2.new(0,28,0,28)
LogoSquare.Position = UDim2.new(0,8,0.5,-14)
LogoSquare.BackgroundColor3 = T.SurfaceHi
LogoSquare.BackgroundTransparency = 0.08
LogoSquare.Image = "" -- di-set setelah fetch
LogoSquare.ScaleType = Enum.ScaleType.Fit
LogoSquare.ZIndex = 6
Round(LogoSquare, 6) -- kotak tapi pinggiran halus
Stroke(LogoSquare, T.Primary, 1)
LogoSquare.Parent = TopBar

-- Avatar (geser dikit ke kanan supaya ga tabrakan)
local AvImg = Instance.new("ImageLabel")
AvImg.Size   = UDim2.new(0,28,0,28)
AvImg.Position = UDim2.new(0,44,0.5,-14)
AvImg.BackgroundColor3 = T.SurfaceHi
AvImg.BackgroundTransparency = 0.18
AvImg.Image  = "https://www.roblox.com/headshot-thumbnail/image?userId="
               ..LocalPlayer.UserId.."&width=150&height=150&format=png"
AvImg.ZIndex = 6
Round(AvImg, 6) -- bukan circular, melengkung
Stroke(AvImg, T.Primary, 1)
AvImg.Parent = TopBar

local NameLbl = Lbl(TopBar, LocalPlayer.Name, 11, T.Text, Enum.Font.GothamBold)
NameLbl.Size     = UDim2.new(0,90,0,15)
NameLbl.Position = UDim2.new(0,78,0,6)
NameLbl.ZIndex   = 6

local GameLbl = Lbl(TopBar, game.Name:sub(1,20), 9, T.Muted)
GameLbl.Size     = UDim2.new(0,150,0,13)
GameLbl.Position = UDim2.new(0,78,0,22)
GameLbl.ZIndex   = 6

local SrvLbl = Lbl(TopBar, "● Global  |  --/--", 9, T.Primary,
    Enum.Font.GothamBold, Enum.TextXAlignment.Center)
SrvLbl.Size     = UDim2.new(0,165,0,13)
SrvLbl.Position = UDim2.new(0.5,-82,0.5,-6)
SrvLbl.ZIndex   = 6

-- Tombol MINIMIZE: TextButton biasa
local MinBtn = Instance.new("TextButton")
MinBtn.Size                  = UDim2.new(0,28,0,24)
MinBtn.Position              = UDim2.new(1,-64,0.5,-12)
MinBtn.BackgroundColor3      = T.SurfaceHi
MinBtn.BackgroundTransparency = 0.15
MinBtn.Text                  = "-"
MinBtn.TextColor3            = T.Text
MinBtn.TextSize              = 18
MinBtn.Font                  = Enum.Font.GothamBold
MinBtn.BorderSizePixel       = 0
MinBtn.AutoButtonColor       = false
MinBtn.ZIndex                = 7
Round(MinBtn, 7)
Stroke(MinBtn, T.Border, 1)
MinBtn.Parent = TopBar

-- Tombol CLOSE
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size                  = UDim2.new(0,28,0,24)
CloseBtn.Position              = UDim2.new(1,-33,0.5,-12)
CloseBtn.BackgroundColor3      = T.Error
CloseBtn.BackgroundTransparency = 0.1
CloseBtn.Text                  = "x"
CloseBtn.TextColor3            = Color3.new(1,1,1)
CloseBtn.TextSize              = 13
CloseBtn.Font                  = Enum.Font.GothamBold
CloseBtn.BorderSizePixel       = 0
CloseBtn.AutoButtonColor       = false
CloseBtn.ZIndex                = 7
Round(CloseBtn, 7)
CloseBtn.Parent = TopBar

MinBtn.MouseEnter:Connect(function()
    Tween(MinBtn, {BackgroundTransparency=0}, 0.12)
end)
MinBtn.MouseLeave:Connect(function()
    Tween(MinBtn, {BackgroundTransparency=0.15}, 0.12)
end)
CloseBtn.MouseEnter:Connect(function()
    Tween(CloseBtn, {BackgroundTransparency=0}, 0.12)
end)
CloseBtn.MouseLeave:Connect(function()
    Tween(CloseBtn, {BackgroundTransparency=0.1}, 0.12)
end)

-- ==================== SERVER INFO UPDATE ====================
task.spawn(function()
    while SG and SG.Parent do
        local pc, mp = #Players:GetPlayers(), 0
        pcall(function() mp = Players.MaxPlayers end)
        SrvLbl.Text = "● Global  |  "..pc.."/"..mp
        GameLbl.Text = game.Name:sub(1,20)
        task.wait(5)
    end
end)

-- ==================== DRAG ====================
local _drag, _ds, _sp = false, nil, nil
TopBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        _drag=true; _ds=i.Position; _sp=MF.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if _drag and (i.UserInputType == Enum.UserInputType.MouseMovement
    or  i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - _ds
        MF.Position = UDim2.new(
            _sp.X.Scale, _sp.X.Offset+d.X,
            _sp.Y.Scale, _sp.Y.Offset+d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        _drag = false
    end
end)

-- ==================== LEFT NAV ====================
local NavFrame = Instance.new("ScrollingFrame")
NavFrame.Size                 = UDim2.new(0,NAV_W,1,-TOP_H)
NavFrame.Position             = UDim2.new(0,0,0,TOP_H)
NavFrame.BackgroundColor3     = T.NavBg
NavFrame.BackgroundTransparency = T.navTrans
NavFrame.BorderSizePixel      = 0
NavFrame.ScrollBarThickness   = 0
NavFrame.AutomaticCanvasSize  = Enum.AutomaticSize.Y
NavFrame.ScrollingDirection   = Enum.ScrollingDirection.Y
NavFrame.ZIndex               = 2
NavFrame.Parent               = MF

local navLL = Instance.new("UIListLayout", NavFrame)
navLL.Padding             = UDim.new(0, 4)
navLL.HorizontalAlignment = Enum.HorizontalAlignment.Center

local navPad = Instance.new("UIPadding", NavFrame)
navPad.PaddingTop    = UDim.new(0, 8)
navPad.PaddingBottom = UDim.new(0, 8)
navPad.PaddingLeft   = UDim.new(0, 2)
navPad.PaddingRight  = UDim.new(0, 2)

local Div = Instance.new("Frame")
Div.Size              = UDim2.new(0,1,1,-TOP_H)
Div.Position          = UDim2.new(0,NAV_W,0,TOP_H)
Div.BackgroundColor3  = T.Border
Div.BackgroundTransparency = 0.2
Div.BorderSizePixel   = 0
Div.ZIndex            = 2
Div.Parent            = MF

-- ==================== CONTENT AREA ====================
local ContentArea = Instance.new("Frame")
ContentArea.Size                 = UDim2.new(1,-(NAV_W+1),1,-TOP_H)
ContentArea.Position             = UDim2.new(0,NAV_W+1,0,TOP_H)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants     = true
ContentArea.ZIndex               = 2
ContentArea.Parent               = MF

-- ==================== PAGE SYSTEM ====================
local Pages   = {}
local NavBtns = {}

local function NewPage(name)
    local sf = Instance.new("ScrollingFrame")
    sf.Name                 = name
    sf.Size                 = UDim2.new(1,0,1,0)
    sf.BackgroundTransparency = 1
    sf.BorderSizePixel      = 0
    sf.ScrollBarThickness   = 3
    sf.ScrollBarImageColor3 = T.Primary
    sf.AutomaticCanvasSize  = Enum.AutomaticSize.Y
    sf.ScrollingDirection   = Enum.ScrollingDirection.Y
    sf.Visible              = false
    sf.Parent               = ContentArea

    local ll = Instance.new("UIListLayout", sf)
    ll.Padding = UDim.new(0, 6)

    local pd = Instance.new("UIPadding", sf)
    pd.PaddingTop    = UDim.new(0, 8)
    pd.PaddingLeft   = UDim.new(0, 8)
    pd.PaddingRight  = UDim.new(0, 8)
    pd.PaddingBottom = UDim.new(0, 8)

    Pages[name] = sf
    return sf
end

local function GoPage(name)
    for n, pg in pairs(Pages) do
        pg.Visible = (n == name)
    end
    for n, btn in pairs(NavBtns) do
        local ic  = btn:FindFirstChild("Ic")
        local lb  = btn:FindFirstChild("Lb")
        if n == name then
            Tween(btn, {BackgroundColor3=T.Primary, BackgroundTransparency=0.05}, 0.18)
            if ic then Tween(ic, {TextColor3=Color3.new(1,1,1)}, 0.18) end
            if lb then Tween(lb, {TextColor3=Color3.new(1,1,1)}, 0.18) end
        else
            Tween(btn, {BackgroundColor3=T.NavBg, BackgroundTransparency=T.navTrans+0.1}, 0.18)
            if ic then Tween(ic, {TextColor3=T.Muted}, 0.18) end
            if lb then Tween(lb, {TextColor3=T.Muted}, 0.18) end
        end
    end
end

local function NavBtn(icon, label, pageName)
    local b = Instance.new("TextButton")
    b.Size                  = UDim2.new(0, NAV_W-6, 0, 44)
    b.BackgroundColor3      = T.NavBg
    b.BackgroundTransparency = T.navTrans+0.08
    b.Text                  = ""
    b.BorderSizePixel       = 0
    b.AutoButtonColor       = false
    b.ZIndex                = 3
    Round(b, 8)
    b.Parent = NavFrame

    local ic = Instance.new("TextLabel")
    ic.Name              = "Ic"
    ic.Size              = UDim2.new(1,0,0,22)
    ic.Position          = UDim2.new(0,0,0,4)
    ic.BackgroundTransparency = 1
    ic.Text              = icon
    ic.TextSize          = 16
    ic.Font              = Enum.Font.GothamBold
    ic.TextColor3        = T.Muted
    ic.TextXAlignment    = Enum.TextXAlignment.Center
    ic.ZIndex            = 4
    ic.Parent            = b

    local lb = Instance.new("TextLabel")
    lb.Name              = "Lb"
    lb.Size              = UDim2.new(1,0,0,11)
    lb.Position          = UDim2.new(0,0,0,27)
    lb.BackgroundTransparency = 1
    lb.Text              = label
    lb.TextSize          = 8
    lb.Font              = Enum.Font.GothamBold
    lb.TextColor3        = T.Muted
    lb.TextXAlignment    = Enum.TextXAlignment.Center
    lb.ZIndex            = 4
    lb.Parent            = b

    NavBtns[pageName] = b
    b.MouseButton1Click:Connect(function() GoPage(pageName) end)
    return b
end

-- Nav icons pake tema lawas (emoji)
NavBtn("📊", "DASH",  "Dash");  local PgDash  = NewPage("Dash")
NavBtn("🏃", "MOVE",  "Move");  local PgMove  = NewPage("Move")
NavBtn("✈️", "FLY",   "Fly");   local PgFly   = NewPage("Fly")
NavBtn("👁️", "ESP",   "ESP");   local PgESP   = NewPage("ESP")
NavBtn("🎯", "TP",    "TP");    local PgTP    = NewPage("TP")
NavBtn("🛡️", "GOD",   "God");   local PgGod   = NewPage("God")
NavBtn("🧱", "WORLD", "World"); local PgWorld = NewPage("World")
NavBtn("👤", "AVA",   "Ava");   local PgAva   = NewPage("Ava")
NavBtn("💾", "SAVE",  "Save");  local PgSave  = NewPage("Save")
NavBtn("🔐", "ADMIN", "Admin"); local PgAdmin = NewPage("Admin")
NavBtn("⚙️", "UTIL",  "Util");  local PgUtil  = NewPage("Util")

-- ==================== UI COMPONENTS (fungsi helper: Section, Toggle, Slider, Btn, Dropdown, StatRow)
local function Section(parent, title)
    local card = Instance.new("Frame")
    card.Size                  = UDim2.new(1,0,0,0)
    card.AutomaticSize         = Enum.AutomaticSize.Y
    card.BackgroundColor3      = T.Surface
    card.BackgroundTransparency = T.sfTrans
    card.BorderSizePixel       = 0
    Round(card, 8)
    Stroke(card, T.Border, 0.8)
    card.Parent = parent

    local ttl = Lbl(card, title, 10, T.Primary, Enum.Font.GothamBold)
    ttl.Size     = UDim2.new(1,-12,0,20)
    ttl.Position = UDim2.new(0,8,0,4)

    local ln = Instance.new("Frame")
    ln.Size               = UDim2.new(1,-12,0,1)
    ln.Position           = UDim2.new(0,6,0,24)
    ln.BackgroundColor3   = T.Border
    ln.BackgroundTransparency = 0.28
    ln.BorderSizePixel    = 0
    ln.Parent             = card

    local cont = Instance.new("Frame")
    cont.Name              = "Cont"
    cont.Size              = UDim2.new(1,-12,0,0)
    cont.Position          = UDim2.new(0,6,0,28)
    cont.AutomaticSize     = Enum.AutomaticSize.Y
    cont.BackgroundTransparency = 1
    cont.Parent            = card

    Instance.new("UIListLayout", cont).Padding = UDim.new(0,6)
    Instance.new("UIPadding",    card).PaddingBottom = UDim.new(0,7)
    return cont
end

local function Toggle(parent, text, cb)
    local row = Instance.new("Frame")
    row.Size               = UDim2.new(1,0,0,26)
    row.BackgroundTransparency = 1
    row.Parent             = parent

    local lbl = Lbl(row, text, 10, T.Text)
    lbl.Size = UDim2.new(1,-60,1,0)

    local track = Instance.new("Frame")
    track.Size             = UDim2.new(0,40,0,18)
    track.Position         = UDim2.new(1,-44,0.5,-9)
    track.BackgroundColor3 = T.SurfaceHi
    track.BorderSizePixel  = 0
    Round(track, 9)
    Stroke(track, T.Border, 1)
    track.Parent = row

    local knob = Instance.new("Frame")
    knob.Size              = UDim2.new(0,14,0,14)
    knob.Position          = UDim2.new(0,3,0.5,-7)
    knob.BackgroundColor3  = T.Muted
    Round(knob, 7)
    knob.Parent = track

    local on     = false
    local hitbox = Instance.new("TextButton")
    hitbox.Size              = UDim2.new(1,0,1,0)
    hitbox.BackgroundTransparency = 1
    hitbox.Text              = ""
    hitbox.ZIndex            = 2
    hitbox.Parent            = track

    hitbox.MouseButton1Click:Connect(function()
        on = not on
        if on then
            Tween(track, {BackgroundColor3=T.Success}, 0.16)
            Tween(knob,  {Position=UDim2.new(0,22,0.5,-7), BackgroundColor3=Color3.new(1,1,1)}, 0.16)
        else
            Tween(track, {BackgroundColor3=T.SurfaceHi}, 0.16)
            Tween(knob,  {Position=UDim2.new(0,3,0.5,-7), BackgroundColor3=T.Muted}, 0.16)
        end
        if cb then cb(on) end
    end)
    return hitbox
end

local function Slider(parent, label, sMin, sMax, default, cb)
    local frame = Instance.new("Frame")
    frame.Size               = UDim2.new(1,0,0,40)
    frame.BackgroundTransparency = 1
    frame.Parent             = parent

    local lbl = Lbl(frame, label, 10, T.Text)
    lbl.Size = UDim2.new(0.6,0,0,15)

    local vbox = Instance.new("TextBox")
    vbox.Size              = UDim2.new(0,44,0,16)
    vbox.Position          = UDim2.new(1,-44,0,0)
    vbox.BackgroundColor3  = T.SurfaceHi
    vbox.BackgroundTransparency = 0.12
    vbox.Text              = tostring(default)
    vbox.TextColor3        = T.Primary
    vbox.TextSize          = 9
    vbox.Font              = Enum.Font.GothamBold
    vbox.ClearTextOnFocus  = false
    vbox.TextXAlignment    = Enum.TextXAlignment.Center
    Round(vbox, 6)
    vbox.Parent = frame

    local track = Instance.new("Frame")
    track.Size             = UDim2.new(1,0,0,4)
    track.Position         = UDim2.new(0,0,0,22)
    track.BackgroundColor3 = T.SurfaceHi
    track.BackgroundTransparency = 0.12
    Round(track, 2)
    track.Parent = frame

    local pct = (default-sMin)/math.max(sMax-sMin,1)
    local fill = Instance.new("Frame")
    fill.Size              = UDim2.new(pct,0,1,0)
    fill.BackgroundColor3  = T.Primary
    Round(fill, 2)
    fill.Parent = track

    local knob = Instance.new("Frame")
    knob.Size              = UDim2.new(0,12,0,12)
    knob.Position          = UDim2.new(pct,-6,0.5,-6)
    knob.BackgroundColor3  = Color3.new(1,1,1)
    Round(knob, 6)
    knob.Parent = track

    local dragging = false
    local function doUpdate(input)
        local p = math.clamp((input.Position.X - track.AbsolutePosition.X)/math.max(track.AbsoluteSize.X,1), 0, 1)
        local v = math.floor(sMin + (sMax-sMin)*p)
        vbox.Text        = tostring(v)
        fill.Size        = UDim2.new(p,0,1,0)
        knob.Position    = UDim2.new(p,-6,0.5,-6)
        if cb then cb(v) end
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
        local v = math.clamp(tonumber(vbox.Text) or default, sMin, sMax)
        vbox.Text     = tostring(v)
        local p       = (v-sMin)/math.max(sMax-sMin,1)
        fill.Size     = UDim2.new(p,0,1,0)
        knob.Position = UDim2.new(p,-6,0.5,-6)
        if cb then cb(v) end
    end)
    return frame
end

local function Btn(parent, text, style, cb)
    local col  = style=="primary" and T.Primary
              or style=="success" and T.Success
              or style=="danger"  and T.Error
              or style=="admin"   and T.Admin
              or T.SurfaceHi
    local tcol = (style=="admin") and Color3.new(0,0,0) or Color3.new(1,1,1)

    local b = Instance.new("TextButton")
    b.Size                  = UDim2.new(1,0,0,26)
    b.BackgroundColor3      = col
    b.BackgroundTransparency = 0.14
    b.Text                  = text
    b.TextColor3            = tcol
    b.TextSize              = 10
    b.Font                  = Enum.Font.GothamBold
    b.BorderSizePixel       = 0
    b.AutoButtonColor       = false
    Round(b, 7)
    b.Parent = parent

    b.MouseEnter:Connect(function()
        Tween(b, {BackgroundTransparency=0}, 0.12)
    end)
    b.MouseLeave:Connect(function()
        Tween(b, {BackgroundTransparency=0.14}, 0.12)
    end)
    b.MouseButton1Click:Connect(function()
        Tween(b, {BackgroundColor3=col:Lerp(Color3.new(1,1,1),0.12)}, 0.06)
        task.delay(0.1, function() Tween(b,{BackgroundColor3=col},0.1) end)
        if cb then cb() end
    end)
    return b
end

local function Dropdown(parent, labelTxt, opts)
    local frame = Instance.new("Frame")
    frame.Size             = UDim2.new(1,0,0,0)
    frame.AutomaticSize    = Enum.AutomaticSize.Y
    frame.BackgroundTransparency = 1
    frame.Parent           = parent

    local row = Instance.new("TextButton")
    row.Size               = UDim2.new(1,0,0,26)
    row.BackgroundColor3   = T.SurfaceHi
    row.BackgroundTransparency = 0.15
    row.Text               = labelTxt..":  "..opts[1].."  v"
    row.TextColor3         = T.Text
    row.TextSize           = 10
    row.Font               = Enum.Font.GothamBold
    row.AutoButtonColor    = false
    row.ZIndex             = 5
    Round(row, 7)
    row.Parent = frame

    local list = Instance.new("Frame")
    list.Size              = UDim2.new(1,0,0,0)
    list.Position          = UDim2.new(0,0,0,28)
    list.BackgroundColor3  = T.Surface
    list.BackgroundTransparency = 0.06
    list.BorderSizePixel   = 0
    list.ClipsDescendants  = true
    list.ZIndex            = 20
    Round(list, 7)
    Stroke(list, T.Border, 1)
    list.Parent = frame

    Instance.new("UIListLayout", list)
    local open = false

    for _, opt in ipairs(opts) do
        local ob = Instance.new("TextButton")
        ob.Size              = UDim2.new(1,0,0,24)
        ob.BackgroundColor3  = T.Surface
        ob.BackgroundTransparency = 0.08
        ob.Text              = "   "..opt
        ob.TextColor3        = T.Text
        ob.TextSize          = 10
        ob.Font              = Enum.Font.Gotham
        ob.TextXAlignment    = Enum.TextXAlignment.Left
        ob.BorderSizePixel   = 0
        ob.AutoButtonColor   = false
        ob.ZIndex            = 21
        ob.Parent            = list
        ob.MouseEnter:Connect(function()
            Tween(ob,{BackgroundColor3=T.SurfaceHi},0.1)
        end)
        ob.MouseLeave:Connect(function()
            Tween(ob,{BackgroundColor3=T.Surface},0.1)
        end)
        ob.MouseButton1Click:Connect(function()
            row.Text = labelTxt..":  "..opt.."  v"
            open = false
            Tween(list,{Size=UDim2.new(1,0,0,0)},0.15)
        end)
    end

    row.MouseButton1Click:Connect(function()
        open = not open
        Tween(list,{Size=UDim2.new(1,0,0, open and #opts*24 or 0)},0.18)
    end)
    return frame
end

local function StatRow(parent, lTxt, vTxt, vCol)
    local row = Instance.new("Frame")
    row.Size               = UDim2.new(1,0,0,18)
    row.BackgroundTransparency = 1
    row.Parent             = parent
    local l = Lbl(row, lTxt, 9, T.Muted)
    l.Size = UDim2.new(0.5,0,1,0)
    local v = Lbl(row, vTxt, 9, vCol or T.Primary,
        Enum.Font.GothamBold, Enum.TextXAlignment.Right)
    v.Size     = UDim2.new(0.5,0,1,0)
    v.Position = UDim2.new(0.5,0,0,0)
    return v
end

-- ==================== PAGES & ISI ====================
local PgDash  = Pages["Dash"]  or NewPage("Dash")
local PgMove  = Pages["Move"]  or NewPage("Move")
local PgFly   = Pages["Fly"]   or NewPage("Fly")
local PgESP   = Pages["ESP"]   or NewPage("ESP")
local PgTP    = Pages["TP"]    or NewPage("TP")
local PgGod   = Pages["God"]   or NewPage("God")
local PgWorld = Pages["World"] or NewPage("World")
local PgAva   = Pages["Ava"]   or NewPage("Ava")
local PgSave  = Pages["Save"]  or NewPage("Save")
local PgAdmin = Pages["Admin"] or NewPage("Admin")
local PgUtil  = Pages["Util"]  or NewPage("Util")

-- DASHBOARD
local dsC  = Section(PgDash, "SERVER MONITOR")
local plrC = Section(PgDash, "PLAYER INFO")

StatRow(dsC, "Game Name:",  game.Name:sub(1,20),        T.Primary)
StatRow(dsC, "Place ID:",   tostring(game.PlaceId),      T.Warning)
StatRow(dsC, "Job ID:",     tostring(game.JobId):sub(1,14).."...", T.Muted)
local sPly = StatRow(dsC,  "Players:", "--/--",          T.Success)
StatRow(dsC, "Server:",     "Global",                    T.Primary)

StatRow(plrC, "Username:",     LocalPlayer.Name,             T.Primary)
StatRow(plrC, "User ID:",      tostring(LocalPlayer.UserId),  T.Muted)
StatRow(plrC, "Display Name:", LocalPlayer.DisplayName,       T.Text)
StatRow(plrC, "Team:",         "None",                        T.Warning)

local credL = Lbl(PgDash, "script by aptech", 9, T.Muted, Enum.Font.Gotham, Enum.TextXAlignment.Right)
credL.Size = UDim2.new(1,-4,0,14)

task.spawn(function()
    while sPly and sPly.Parent do
        local pc, mp = #Players:GetPlayers(), 0
        pcall(function() mp = Players.MaxPlayers end)
        sPly.Text = pc.."/"..mp
        task.wait(5)
    end
end)

-- MOVEMENT
local mvC = Section(PgMove, "SPEED & JUMP")
Slider(mvC, "Walk Speed", 1, 500, 16)
Slider(mvC, "Jump Power", 1, 500, 50)
Btn(mvC, "Reset to Default", "normal")

local jC = Section(PgMove, "INFINITE JUMP")
Toggle(jC, "Infinite Jump")

local gC = Section(PgMove, "GRAVITY")
Toggle(gC, "Moon Gravity")
Slider(gC, "Custom Gravity", 5, 350, 196)

-- FLY (sederhana)
local flyC = Section(PgFly, "FLY CONTROL")
local spdRow = Instance.new("Frame")
spdRow.Size = UDim2.new(1,0,0,26); spdRow.BackgroundTransparency = 1; spdRow.Parent = flyC
local spdL = Lbl(spdRow, "Fly Speed", 10, T.Text); spdL.Size = UDim2.new(0.4,0,1,0)

local fMin = Instance.new("TextButton"); fMin.Size = UDim2.new(0,22,0,20); fMin.Position = UDim2.new(0.42,0,0.5,-10)
fMin.BackgroundColor3 = T.SurfaceHi; fMin.BackgroundTransparency = 0.15; fMin.Text = "-"; fMin.Font = Enum.Font.GothamBold
Round(fMin,5); fMin.Parent = spdRow
local fDisp = Instance.new("TextLabel"); fDisp.Size = UDim2.new(0,30,0,20); fDisp.Position = UDim2.new(0.42,24,0.5,-10)
fDisp.BackgroundColor3 = T.Surface; fDisp.BackgroundTransparency = 0.2; fDisp.Text = "1"; fDisp.TextColor3 = T.Primary; fDisp.Font = Enum.Font.GothamBold
Round(fDisp,5); fDisp.Parent = spdRow
local fPlus = Instance.new("TextButton"); fPlus.Size = UDim2.new(0,22,0,20); fPlus.Position = UDim2.new(0.42,56,0.5,-10)
fPlus.BackgroundColor3 = T.SurfaceHi; fPlus.BackgroundTransparency = 0.15; fPlus.Text = "+"; Round(fPlus,5); fPlus.Parent = spdRow

local flySpeed = 1
fMin.MouseButton1Click:Connect(function() flySpeed = math.max(1, flySpeed-1); fDisp.Text = tostring(flySpeed) end)
fPlus.MouseButton1Click:Connect(function() flySpeed = math.min(200, flySpeed+1); fDisp.Text = tostring(flySpeed) end)

local udRow = Instance.new("Frame"); udRow.Size = UDim2.new(1,0,0,26); udRow.BackgroundTransparency = 1; udRow.Parent = flyC
local flyUp = Instance.new("TextButton"); flyUp.Size = UDim2.new(0.48,0,0,24); flyUp.BackgroundColor3 = T.SurfaceHi; flyUp.BackgroundTransparency = 0.15; flyUp.Text = "^ UP"; Round(flyUp,7); flyUp.Parent = udRow
local flyDn = Instance.new("TextButton"); flyDn.Size = UDim2.new(0.48,0,0,24); flyDn.Position = UDim2.new(0.52,0,0,0); flyDn.BackgroundColor3 = T.SurfaceHi; flyDn.BackgroundTransparency = 0.15; flyDn.Text = "v DOWN"; Round(flyDn,7); flyDn.Parent = udRow

local flyTog = Instance.new("TextButton"); flyTog.Size = UDim2.new(1,0,0,28); flyTog.BackgroundColor3 = T.SurfaceHi; flyTog.BackgroundTransparency = 0.15; flyTog.Text = "FLY:  OFF"; flyTog.TextColor3 = T.Muted; Round(flyTog,8); flyTog.Parent = flyC
local flyOn = false
flyTog.MouseButton1Click:Connect(function()
    flyOn = not flyOn
    if flyOn then Tween(flyTog,{BackgroundColor3=T.Primary,BackgroundTransparency=0.06},0.16); flyTog.TextColor3 = Color3.new(1,1,1); flyTog.Text = "FLY:  ON"
    else Tween(flyTog,{BackgroundColor3=T.SurfaceHi,BackgroundTransparency=0.15},0.16); flyTog.TextColor3 = T.Muted; flyTog.Text = "FLY:  OFF" end
end)

Toggle(Section(PgFly,"NO CLIP"), "Enable No Clip")

-- ESP
local espC = Section(PgESP, "PLAYER ESP")
Toggle(espC, "Enable Player ESP")
local espV2C = Section(PgESP, "ESP V2  -  ADMIN ONLY")
local espLock = Lbl(espV2C, "Requires Admin login", 9, T.Warning); espLock.Size = UDim2.new(1,0,0,16)
Toggle(espV2C, "ESP V2  (HP + Dist + Team)")
local blkC = Section(PgESP, "BLOCK / ITEM ESP"); Toggle(blkC, "Highlight Blocks and Items")

-- TELEPORT
local tpC = Section(PgTP, "TELEPORT TO PLAYER")
local tpSF = Instance.new("ScrollingFrame"); tpSF.Size = UDim2.new(1,0,0,86); tpSF.BackgroundColor3 = T.SurfaceHi; tpSF.BackgroundTransparency = 0.3; tpSF.BorderSizePixel = 0; tpSF.ScrollBarThickness = 3; tpSF.AutomaticCanvasSize = Enum.AutomaticSize.Y; Round(tpSF, 7); tpSF.Parent = tpC
local tpLL2 = Instance.new("UIListLayout", tpSF); tpLL2.Padding = UDim.new(0,3)
local function RefreshTPList()
    for _, c in pairs(tpSF:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    local n = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            n = n+1
            local b = Instance.new("TextButton")
            b.Size             = UDim2.new(1,0,0,24)
            b.BackgroundColor3 = T.Surface
            b.BackgroundTransparency = 0.18
            b.Text             = "  "..p.Name
            b.TextColor3       = T.Text
            b.TextSize         = 10
            b.Font             = Enum.Font.Gotham
            b.TextXAlignment   = Enum.TextXAlignment.Left
            b.BorderSizePixel  = 0
            b.AutoButtonColor  = false
            Round(b, 5)
            b.Parent = tpSF
            b.MouseButton1Click:Connect(function()
                for _, bb in pairs(tpSF:GetChildren()) do if bb:IsA("TextButton") then Tween(bb,{BackgroundColor3=T.Surface, BackgroundTransparency=0.18},0.1) end end
                Tween(b,{BackgroundColor3=T.Primary,BackgroundTransparency=0.1},0.12)
            end)
        end
    end
    tpSF.CanvasSize = UDim2.new(0,0,0,math.max(0,n*27+6))
end
RefreshTPList()
Players.PlayerAdded:Connect(RefreshTPList)
Players.PlayerRemoving:Connect(RefreshTPList)
Btn(tpC, "Teleport to Selected", "primary")
Toggle(tpC, "Follow Selected Player")

-- GOD
local godC = Section(PgGod, "GOD MODE")
local godModes = {"Gen1 (auto-heal)", "Gen2 (invincible)", "Gen3 (max HP)"}; local godIdx = 1
local godModeBtn = Instance.new("TextButton"); godModeBtn.Size=UDim2.new(1,0,0,24); godModeBtn.BackgroundColor3=T.SurfaceHi; godModeBtn.BackgroundTransparency=0.15; godModeBtn.Text="Mode: "..godModes[godIdx].." >"; godModeBtn.TextColor3 = T.Text; godModeBtn.Font = Enum.Font.GothamBold; Round(godModeBtn,7); godModeBtn.Parent = godC
godModeBtn.MouseButton1Click:Connect(function() godIdx=(godIdx%#godModes)+1; godModeBtn.Text="Mode: "..godModes[godIdx].." >" end)
Toggle(godC, "God Mode"); Toggle(godC, "Auto Heal"); Btn(godC, "Heal Now", "success")

-- WORLD
local wC = Section(PgWorld, "BLOCK SPAWNER")
Dropdown(wC, "Block Type", {"Part","Wedge","CornerWedge","Truss","SpawnLocation"})
Dropdown(wC, "Material",   {"SmoothPlastic","Neon","Glass","Wood","Granite","Metal"})
Dropdown(wC, "Color",      {"Red","Blue","Green","Yellow","White","Black","Pink"})
Slider(wC, "Block Size", 1, 50, 5)
Btn(wC, "Spawn Block",           "primary")
Btn(wC, "Hapus Block Terakhir",  "danger")
Btn(wC, "Clear Semua Block",     "danger")

-- AVATAR
local avC = Section(PgAva, "COPY AVATAR")
local avStatus = Lbl(avC, "Pilih player untuk copy tampilan.", 9, T.Muted); avStatus.Size = UDim2.new(1,0,0,15)
local avSF = Instance.new("ScrollingFrame"); avSF.Size = UDim2.new(1,0,0,86); avSF.BackgroundColor3 = T.SurfaceHi; avSF.BackgroundTransparency = 0.3; avSF.BorderSizePixel = 0; avSF.ScrollBarThickness = 3; avSF.AutomaticCanvasSize = Enum.AutomaticSize.Y; Round(avSF,7); avSF.Parent = avC
local function RefreshAvaList()
    for _, c in pairs(avSF:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    local n = 0
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then n=n+1
        local b = Instance.new("TextButton"); b.Size = UDim2.new(1,0,0,24); b.BackgroundColor3 = T.Surface; b.BackgroundTransparency = 0.18
        b.Text = "  "..p.Name; b.TextColor3 = T.Text; b.TextSize = 10; b.Font = Enum.Font.Gotham; b.TextXAlignment = Enum.TextXAlignment.Left
        b.BorderSizePixel = 0; b.AutoButtonColor = false; Round(b,5); b.Parent = avSF
        b.MouseButton1Click:Connect(function() for _, bb in pairs(avSF:GetChildren()) do if bb:IsA("TextButton") then Tween(bb,{BackgroundColor3=T.Surface, BackgroundTransparency=0.18},0.1) end end; Tween(b,{BackgroundColor3=T.Primary,BackgroundTransparency=0.1},0.12) end)
    end end
    avSF.CanvasSize = UDim2.new(0,0,0,math.max(0,n*27+6))
end
RefreshAvaList(); Players.PlayerAdded:Connect(RefreshAvaList); Players.PlayerRemoving:Connect(RefreshAvaList)
Btn(avC, "Copy Avatar Target", "primary"); Btn(avC, "Restore Avatar Saya", "normal")

-- SAVE
local svC = Section(PgSave, "PRESET SETTINGS")
local preBox = Instance.new("TextBox"); preBox.Size = UDim2.new(1,0,0,26); preBox.BackgroundColor3 = T.SurfaceHi; preBox.BackgroundTransparency = 0.15; preBox.PlaceholderText = "Nama preset..."; Round(preBox,7); preBox.Parent = svC
local preSF = Instance.new("ScrollingFrame"); preSF.Size = UDim2.new(1,0,0,68); preSF.BackgroundColor3 = T.SurfaceHi; preSF.BackgroundTransparency = 0.3; preSF.BorderSizePixel = 0; preSF.ScrollBarThickness = 3; preSF.AutomaticCanvasSize = Enum.AutomaticSize.Y; Round(preSF,7); preSF.Parent = svC
Instance.new("UIListLayout", preSF).Padding = UDim.new(0,3)
Btn(svC, "Save Settings Sekarang", "primary")
local exportBox = Instance.new("TextBox"); exportBox.Size = UDim2.new(1,0,0,40); exportBox.BackgroundColor3 = T.NavBg; exportBox.BackgroundTransparency = 0.25; exportBox.PlaceholderText = "Export code akan muncul di sini..."; exportBox.Font = Enum.Font.Code; Round(exportBox,7); exportBox.Parent = svC
local importBox = Instance.new("TextBox"); importBox.Size = UDim2.new(1,0,0,36); importBox.BackgroundColor3 = T.NavBg; importBox.BackgroundTransparency = 0.25; importBox.PlaceholderText = "Paste kode import di sini..."; importBox.Font = Enum.Font.Code; Round(importBox,7); importBox.Parent = svC
Btn(svC, "Import dari Kode", "normal")

-- ADMIN
local adC = Section(PgAdmin, "ADMIN LOGIN")
local adStatus = Lbl(adC, "Belum terautentikasi", 9, T.Muted); adStatus.Size = UDim2.new(1,0,0,16)
local pwBox = Instance.new("TextBox"); pwBox.Size = UDim2.new(1,0,0,26); pwBox.BackgroundColor3 = T.NavBg; pwBox.BackgroundTransparency = 0.25; pwBox.PlaceholderText = "Masukkan password..."; Round(pwBox,7); pwBox.Parent = adC
Btn(adC, "Unlock Admin Mode", "admin")

-- UTIL
local utC = Section(PgUtil, "UTILITIES")
Toggle(utC, "Full Bright"); Toggle(utC, "Anti-AFK"); Toggle(utC, "Unlock Camera Zoom"); Toggle(utC, "FPS Boost")
local srC = Section(PgUtil, "SERVER"); Btn(srC, "Rejoin Server", "primary"); Btn(srC, "Server Hop", "normal")

-- ORB BUTTON (restore)
local OrbBtn = Instance.new("ImageButton")
OrbBtn.Size              = UDim2.new(0,44,0,44)
OrbBtn.Position          = UDim2.new(0,14,0.5,-22)
OrbBtn.BackgroundColor3  = T.Primary
OrbBtn.BackgroundTransparency = 0.05
OrbBtn.Image             = ""
OrbBtn.Visible           = false
OrbBtn.ZIndex            = 100
OrbBtn.Active            = true
OrbBtn.AutoButtonColor   = false
Round(OrbBtn, 10)
Stroke(OrbBtn, T.Warning, 1.8)
OrbBtn.Parent = SG

local OrbFb = Lbl(OrbBtn, "AP", 12, Color3.new(1,1,1), Enum.Font.GothamBold, Enum.TextXAlignment.Center)
OrbFb.Size   = UDim2.new(1,0,1,0)
OrbFb.ZIndex = 101

-- MINIMIZE / RESTORE / CLOSE
MinBtn.MouseButton1Click:Connect(function()
    Tween(MF, {Size=UDim2.new(0,WIN_W,0,0)}, 0.18)
    task.delay(0.18, function() MF.Visible = false; OrbBtn.Visible = true end)
end)
OrbBtn.MouseButton1Click:Connect(function()
    OrbBtn.Visible = false
    MF.Visible     = true
    Tween(MF, {Size=UDim2.new(0,WIN_W,0,WIN_H)}, 0.3, Enum.EasingStyle.Back)
end)
CloseBtn.MouseButton1Click:Connect(function()
    Tween(MF,{Size=UDim2.new(0,WIN_W,0,0), BackgroundTransparency=1}, 0.18)
    task.delay(0.2, function() SG:Destroy() end)
end)

-- OPENING SEQUENCE (non-blocking, typewriter + soft bg)
task.spawn(function()
    local OF = Instance.new("Frame")
    OF.Size              = UDim2.new(1,0,1,0)
    OF.BackgroundColor3  = T.Bg
    OF.BackgroundTransparency = 0.58 -- lembut, ora hitam pekat
    OF.ZIndex            = 200
    OF.Parent            = SG

    -- optional subtle background image (jika sudah di-fetch nanti akan muncul di MF BgImage)
    local OBg = Instance.new("ImageLabel")
    OBg.Size = UDim2.new(1,0,1,0)
    OBg.BackgroundTransparency = 1
    OBg.Image = "" -- diisi kalau available
    OBg.ImageTransparency = 0.65
    OBg.ZIndex = 199
    OBg.Parent = OF

    local OT = Instance.new("TextLabel")
    OT.Size              = UDim2.new(0,420,0,66)
    OT.Position          = UDim2.new(0.5,-210,0.5,-56)
    OT.BackgroundTransparency = 1
    OT.Text              = ""
    OT.TextColor3        = T.Primary
    OT.TextSize          = 48
    OT.Font              = Enum.Font.GothamBold
    OT.TextXAlignment    = Enum.TextXAlignment.Center
    OT.TextTransparency  = 0
    OT.ZIndex            = 201
    OT.Parent            = OF

    local OS = Instance.new("TextLabel")
    OS.Size              = UDim2.new(0,260,0,26)
    OS.Position          = UDim2.new(0.5,-130,0.5,18)
    OS.BackgroundTransparency = 1
    OS.Text              = "by  A P T E C H"
    OS.TextColor3        = T.Warning
    OS.TextSize          = 16
    OS.Font              = Enum.Font.Gotham
    OS.TextXAlignment    = Enum.TextXAlignment.Center
    OS.TextTransparency  = 0.5
    OS.ZIndex            = 201
    OS.Parent            = OF

    local OL = Instance.new("Frame")
    OL.Size              = UDim2.new(0,0,0,2)
    OL.Position          = UDim2.new(0.5,0,0.5,12)
    OL.BackgroundColor3  = T.Primary
    OL.BackgroundTransparency = 0.4
    OL.ZIndex            = 201
    OL.Parent            = OF

    -- typewriter style (lawas) reveal
    local title = "AP-NEXTGEN"
    for i = 1, #title do
        OT.Text = title:sub(1, i)
        task.wait(0.04)
    end
    -- expand line and fade in subtitle
    Tween(OL, {Size=UDim2.new(0,300,0,2), Position=UDim2.new(0.5,-150,0.5,12)}, 0.6, Enum.EasingStyle.Quint)
    task.wait(0.22)
    Tween(OS, {TextTransparency=0}, 0.5, Enum.EasingStyle.Quint)
    task.wait(1.25)

    -- fade out opening softly
    Tween(OF, {BackgroundTransparency=1}, 0.45)
    Tween(OT, {TextTransparency=1}, 0.35)
    Tween(OS, {TextTransparency=1}, 0.35)
    task.wait(0.5)
    OF:Destroy()

    -- tampilkan main window
    GoPage("Dash")
    MF.Size    = UDim2.new(0, 0, 0, 0)
    MF.Visible = true
    Tween(MF, {Size=UDim2.new(0,WIN_W,0,WIN_H)}, 0.42, Enum.EasingStyle.Back)
end)

-- FETCH IMAGES (background + logo) non-blocking
task.spawn(function()
    local logoId = fetchImage(imageUrls.logo, "apng_logo.png")
    if logoId ~= "" then
        LogoSquare.Image = logoId
        OrbBtn.Image = logoId
        OrbFb.Visible = false
    end
    local bgId = fetchImage(imageUrls.bg, "apng_bg.jpg")
    if bgId ~= "" then
        BgImage.Image = bgId
    end
end)
