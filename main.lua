--[[
    AP-NEXTGEN v9.0 – UI SHELL (EDIT MODE) – ENHANCED EDITION (FIXED)
    Perbaikan:
    - Minimize icon gawe anak ImageLabel (supaya ora nyebar/merusak layout)
    - Orb draggable manual (lebih konsisten)
    - Konsistensi TextSize / Font / Padding / Rounding
    - Perbaikan beberapa ScrollFrame / CanvasSize handling
    - Tweaks stroke/alpha supaya tampilan lebih professional & smooth
    - Tetep njaga struktur & fitur asli (ora ngilangke baris logika)
]]


-- Services
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local ContentProvider  = game:GetService("ContentProvider")
local LocalPlayer = Players.LocalPlayer

-- ==================== LOAD IMAGE DARI GITHUB ====================
local imageUrls = {
    logo = "https://raw.githubusercontent.com/aryaexeuyf/Image/main/logo_g1.png",
    bg   = "https://raw.githubusercontent.com/aryaexeuyf/Image/main/background.jpg"
}

local httpFunc = nil
if syn and syn.request then
    httpFunc = syn.request
elseif http_request then
    httpFunc = http_request
elseif http and http.request then
    httpFunc = http.request
elseif request then
    httpFunc = request
end

local getAsset = getcustomasset or getsynasset or nil

local function fetchImage(url, filename)
    if not httpFunc or not writefile or not getAsset then return "" end
    local ok, res = pcall(httpFunc, {
        Url = url, Method = "GET",
        Headers = { ["User-Agent"] = "Mozilla/5.0" }
    })
    if not ok or not res or not res.Body or #res.Body < 100 then return "" end
    local wOk = pcall(writefile, filename, res.Body)
    if not wOk then return "" end
    local aOk, id = pcall(getAsset, filename)
    return (aOk and id and id ~= "") and id or ""
end

-- ==================== THEME ====================
local T = {
    Bg        = Color3.fromRGB(8, 10, 15),
    Surface   = Color3.fromRGB(20, 22, 34),
    SurfaceHi = Color3.fromRGB(30, 34, 54),
    NavBg     = Color3.fromRGB(12, 12, 20),
    Primary   = Color3.fromRGB(0, 170, 255),
    Success   = Color3.fromRGB(0, 210, 110),
    Warning   = Color3.fromRGB(255, 200, 0),
    Error     = Color3.fromRGB(255, 70, 80),
    Admin     = Color3.fromRGB(255, 210, 0),
    Text      = Color3.fromRGB(240, 245, 255),
    Muted     = Color3.fromRGB(150, 155, 175),
    Border    = Color3.fromRGB(60, 64, 90),

    bgTrans   = 0.45,
    surfTrans = 0.28,
    navTrans  = 0.5,
    btnTrans  = 0.18,
}

-- ==================== HELPERS ====================
local function Tween(obj, props, dur, style)
    TweenService:Create(obj, TweenInfo.new(dur or 0.22, style or Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

local function Round(inst, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = inst
    return c
end

local function Stroke(inst, col, th)
    local s = Instance.new("UIStroke")
    s.Color = col or T.Border
    s.Thickness = th or 1
    s.Transparency = 0.15
    s.Parent = inst
    return s
end

local function Lbl(parent, text, size, color, font, align)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextSize = size or 12
    l.TextColor3 = color or T.Text
    l.Font = font or Enum.Font.Gotham
    l.TextXAlignment = align or Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.RichText = false
    l.Parent = parent
    return l
end

-- ==================== SCREENGUI ====================
local SG = Instance.new("ScreenGui")
SG.Name = "APNEXTGEN_UI"
SG.Parent = CoreGui
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.DisplayOrder = 1000

-- ==================== OPENING SEQUENCE ====================
local OpeningFrame = Instance.new("Frame")
OpeningFrame.Size = UDim2.new(1, 0, 1, 0)
OpeningFrame.BackgroundColor3 = Color3.new(0, 0, 0)
OpeningFrame.BackgroundTransparency = 0
OpeningFrame.ZIndex = 200
OpeningFrame.Parent = SG

local OpenTitle = Instance.new("TextLabel")
OpenTitle.Size = UDim2.new(0, 520, 0, 100)
OpenTitle.Position = UDim2.new(0.5, -260, 0.5, -70)
OpenTitle.BackgroundTransparency = 1
OpenTitle.Text = "AP-NEXTGEN1"
OpenTitle.TextColor3 = T.Primary
OpenTitle.TextSize = 56
OpenTitle.Font = Enum.Font.GothamBold
OpenTitle.TextXAlignment = Enum.TextXAlignment.Center
OpenTitle.TextYAlignment = Enum.TextYAlignment.Center
OpenTitle.TextTransparency = 1
OpenTitle.ZIndex = 201
OpenTitle.Parent = OpeningFrame
Stroke(OpenTitle, T.Warning, 1.4)

local OpenCredit = Instance.new("TextLabel")
OpenCredit.Size = UDim2.new(0, 360, 0, 40)
OpenCredit.Position = UDim2.new(0.5, -180, 0.5, 40)
OpenCredit.BackgroundTransparency = 1
OpenCredit.Text = "By APTECH"
OpenCredit.TextColor3 = T.Warning
OpenCredit.TextSize = 18
OpenCredit.Font = Enum.Font.Gotham
OpenCredit.TextXAlignment = Enum.TextXAlignment.Center
OpenCredit.TextYAlignment = Enum.TextYAlignment.Center
OpenCredit.TextTransparency = 1
OpenCredit.ZIndex = 201
OpenCredit.Parent = OpeningFrame

Tween(OpenTitle, {TextTransparency = 0}, 1.1, Enum.EasingStyle.Quint)
Tween(OpenCredit, {TextTransparency = 0}, 1.1, Enum.EasingStyle.Quint)
task.wait(2.0)
Tween(OpeningFrame, {BackgroundTransparency = 1}, 0.6)
Tween(OpenTitle, {TextTransparency = 1}, 0.5)
Tween(OpenCredit, {TextTransparency = 1}, 0.5)
task.wait(0.7)
OpeningFrame:Destroy()

-- ==================== MAIN FRAME ====================
local MF = Instance.new("Frame")
MF.Name = "MainFrame"
MF.Size = UDim2.new(0, 450, 0, 290)
MF.Position = UDim2.new(0.5, -225, 0.5, -145)
MF.BackgroundColor3 = T.Bg
MF.BackgroundTransparency = T.bgTrans
MF.BorderSizePixel = 0
MF.ClipsDescendants = true
MF.Active = true
MF.Visible = false
Round(MF, 14)
Stroke(MF, T.Primary, 1)
MF.ZIndex = 50
MF.Parent = SG

-- Background image
local BgImage = Instance.new("ImageLabel")
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.BackgroundTransparency = 1
BgImage.Image = ""
BgImage.ScaleType = Enum.ScaleType.Crop
BgImage.ImageTransparency = 0.28
BgImage.ZIndex = 0
BgImage.Parent = MF

-- ==================== TOP BAR ====================
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = T.Surface
TopBar.BackgroundTransparency = T.surfTrans
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 60
TopBar.Parent = MF

-- Small top accent to smooth corner look
local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 12)
TopFix.Position = UDim2.new(0, 0, 1, -12)
TopFix.BackgroundColor3 = T.Surface
TopFix.BackgroundTransparency = T.surfTrans
TopFix.BorderSizePixel = 0
TopFix.ZIndex = 59
TopFix.Parent = TopBar

-- Avatar foto profil
local AvImg = Instance.new("ImageLabel")
AvImg.Size = UDim2.new(0, 30, 0, 30)
AvImg.Position = UDim2.new(0, 8, 0.5, -15)
AvImg.BackgroundColor3 = T.SurfaceHi
AvImg.BackgroundTransparency = 0.22
AvImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=150&height=150&format=png"
AvImg.ZIndex = 61
Round(AvImg, 15)
Stroke(AvImg, T.Primary, 1)
AvImg.Parent = TopBar

-- Nama user
local NameLbl = Lbl(TopBar, LocalPlayer.Name, 12, T.Text, Enum.Font.GothamBold)
NameLbl.Size = UDim2.new(0, 120, 0, 16)
NameLbl.Position = UDim2.new(0, 46, 0, 4)
NameLbl.ZIndex = 61
NameLbl.TextTruncate = Enum.TextTruncate.AtEnd

-- Info game kecil di bawah nama
local GameLbl = Lbl(TopBar, game.Name:sub(1,16), 10, T.Muted)
GameLbl.Size = UDim2.new(0, 120, 0, 14)
GameLbl.Position = UDim2.new(0, 46, 0, 22)
GameLbl.ZIndex = 61
GameLbl.TextTruncate = Enum.TextTruncate.AtEnd

-- Server info tengah
local SrvLbl = Lbl(TopBar, "🌐 Global | ID:... | --/--", 11, T.Primary, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
SrvLbl.Size = UDim2.new(0, 240, 0, 18)
SrvLbl.Position = UDim2.new(0.5, -120, 0.5, -9)
SrvLbl.ZIndex = 61
SrvLbl.TextTruncate = Enum.TextTruncate.AtEnd

-- Tombol minimize (TextButton + small ImageLabel icon inside)
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 34, 0, 34)
MinBtn.Position = UDim2.new(1, -76, 0.5, -17)
MinBtn.BackgroundColor3 = T.SurfaceHi
MinBtn.BackgroundTransparency = 0.2
MinBtn.Text = "" -- no big text
MinBtn.ZIndex = 62
MinBtn.AutoButtonColor = false
Round(MinBtn, 10)
Stroke(MinBtn, T.Border, 1)
MinBtn.Parent = TopBar

local MinIcon = Instance.new("ImageLabel")
MinIcon.Size = UDim2.new(0, 18, 0, 18)
MinIcon.Position = UDim2.new(0.5, -9, 0.5, -9)
MinIcon.BackgroundTransparency = 1
MinIcon.Image = "" -- assigned later by fetch
MinIcon.ScaleType = Enum.ScaleType.Fit
MinIcon.ZIndex = 63
MinIcon.Parent = MinBtn

-- Tombol close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 34, 0, 34)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -17)
CloseBtn.BackgroundColor3 = T.Error
CloseBtn.BackgroundTransparency = 0.08
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 62
CloseBtn.AutoButtonColor = false
Round(CloseBtn, 10)
Stroke(CloseBtn, T.Border, 1)
CloseBtn.Parent = TopBar

-- ==================== SERVER INFO UPDATER ====================
spawn(function()
    while SrvLbl.Parent do
        local pc = #Players:GetPlayers()
        local mp = 0
        pcall(function() mp = Players.MaxPlayers end)
        GameLbl.Text = game.Name:sub(1, 16)
        SrvLbl.Text = "🌐 Global | ID:"..tostring(game.PlaceId).." | "..pc.."/"..mp
        task.wait(5)
    end
end)

-- ==================== DRAG TOPBAR ====================
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
NavFrame.Size = UDim2.new(0, 56, 1, -40)
NavFrame.Position = UDim2.new(0, 0, 0, 40)
NavFrame.BackgroundColor3 = T.NavBg
NavFrame.BackgroundTransparency = T.navTrans
NavFrame.BorderSizePixel = 0
NavFrame.ScrollBarThickness = 0
NavFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
NavFrame.ScrollingDirection = Enum.ScrollingDirection.Y
NavFrame.ZIndex = 52
NavFrame.Parent = MF

local NavLL = Instance.new("UIListLayout")
NavLL.Padding = UDim.new(0, 6)
NavLL.HorizontalAlignment = Enum.HorizontalAlignment.Center
NavLL.Parent = NavFrame

local NavPad = Instance.new("UIPadding")
NavPad.PaddingTop = UDim.new(0, 8)
NavPad.PaddingBottom = UDim.new(0, 8)
NavPad.Parent = NavFrame

-- Garis pemisah sidebar
local Div = Instance.new("Frame")
Div.Size = UDim2.new(0, 1, 1, -40)
Div.Position = UDim2.new(0, 56, 0, 40)
Div.BackgroundColor3 = T.Border
Div.BackgroundTransparency = 0.4
Div.BorderSizePixel = 0
Div.ZIndex = 52
Div.Parent = MF

-- ==================== CONTENT AREA ====================
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -57, 1, -40)
ContentArea.Position = UDim2.new(0, 57, 0, 40)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.ZIndex = 52
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
    sf.ScrollBarThickness = 6
    sf.ScrollBarImageColor3 = T.Primary
    sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sf.ScrollingDirection = Enum.ScrollingDirection.Y
    sf.Visible = false
    sf.ZIndex = 52
    sf.Parent = ContentArea

    local ll = Instance.new("UIListLayout")
    ll.Padding = UDim.new(0, 8)
    ll.Parent = sf

    local pd = Instance.new("UIPadding")
    pd.PaddingTop = UDim.new(0, 10)
    pd.PaddingLeft = UDim.new(0, 10)
    pd.PaddingRight = UDim.new(0, 10)
    pd.PaddingBottom = UDim.new(0, 10)
    pd.Parent = sf

    Pages[name] = sf
    return sf
end

local function GoPage(name)
    for n, pg in pairs(Pages) do
        pg.Visible = (n == name)
    end
    for n, btn in pairs(NavBtns) do
        if n == name then
            Tween(btn, {BackgroundColor3 = T.Primary, BackgroundTransparency = 0.06}, 0.18)
            Tween(btn, {TextColor3 = Color3.new(1,1,1)}, 0.18)
        else
            Tween(btn, {BackgroundColor3 = T.NavBg, BackgroundTransparency = T.navTrans}, 0.18)
            Tween(btn, {TextColor3 = T.Muted}, 0.18)
        end
    end
end

local function NavBtn(icon, pageName)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 48, 0, 40)
    b.BackgroundColor3 = T.NavBg
    b.BackgroundTransparency = T.navTrans
    b.Text = icon
    b.TextColor3 = T.Muted
    b.TextSize = 16
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    Round(b, 10)
    b.ZIndex = 53
    b.Parent = NavFrame
    NavBtns[pageName] = b
    b.MouseButton1Click:Connect(function() GoPage(pageName) end)
    return b
end

-- ==================== UI COMPONENT BUILDERS ====================
local function Section(parent, title)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = T.Surface
    card.BackgroundTransparency = T.surfTrans
    card.BorderSizePixel = 0
    Round(card, 10)
    card.ZIndex = 52
    card.Parent = parent

    local ttl = Lbl(card, title, 12, T.Primary, Enum.Font.GothamBold)
    ttl.Size = UDim2.new(1, -16, 0, 24)
    ttl.Position = UDim2.new(0, 8, 0, 6)

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, -16, 0, 1)
    line.Position = UDim2.new(0, 8, 0, 30)
    line.BackgroundColor3 = T.Border
    line.BackgroundTransparency = 0.45
    line.BorderSizePixel = 0
    line.ZIndex = 52
    line.Parent = card

    local cont = Instance.new("Frame")
    cont.Name = "Cont"
    cont.Size = UDim2.new(1, -16, 0, 0)
    cont.Position = UDim2.new(0, 8, 0, 34)
    cont.AutomaticSize = Enum.AutomaticSize.Y
    cont.BackgroundTransparency = 1
    cont.ZIndex = 52
    cont.Parent = card

    local cL = Instance.new("UIListLayout")
    cL.Padding = UDim.new(0, 8)
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
    row.ZIndex = 52
    row.Parent = parent

    local lbl = Lbl(row, text, 11, T.Text)
    lbl.Size = UDim2.new(0.7, 0, 1, 0)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 56, 0, 20)
    btn.Position = UDim2.new(1, -58, 0.5, -10)
    btn.BackgroundColor3 = T.SurfaceHi
    btn.BackgroundTransparency = 0.2
    btn.Text = "OFF"
    btn.TextColor3 = T.Muted
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    Round(btn, 10)
    btn.ZIndex = 52
    btn.Parent = row

    local on = false
    btn.MouseButton1Click:Connect(function()
        on = not on
        btn.Text = on and "ON" or "OFF"
        Tween(btn, {BackgroundColor3 = on and T.Success or T.SurfaceHi, BackgroundTransparency = 0.08}, 0.18)
        Tween(btn, {TextColor3 = on and Color3.new(1,1,1) or T.Muted}, 0.18)
        if _callback then _callback(on) end
    end)
    return btn
end

local function Slider(parent, text, min, max, default, _callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 44)
    frame.BackgroundTransparency = 1
    frame.ZIndex = 52
    frame.Parent = parent

    local topRow = Instance.new("Frame")
    topRow.Size = UDim2.new(1, 0, 0, 18)
    topRow.BackgroundTransparency = 1
    topRow.Parent = frame

    local lbl = Lbl(topRow, text, 11, T.Text)
    lbl.Size = UDim2.new(0.58, 0, 1, 0)

    local vbox = Instance.new("TextBox")
    vbox.Size = UDim2.new(0, 56, 0, 18)
    vbox.Position = UDim2.new(1, -56, 0, 0)
    vbox.BackgroundColor3 = T.SurfaceHi
    vbox.BackgroundTransparency = 0.2
    vbox.Text = tostring(default)
    vbox.TextColor3 = T.Primary
    vbox.TextSize = 10
    vbox.Font = Enum.Font.GothamBold
    vbox.ClearTextOnFocus = false
    Round(vbox, 6)
    vbox.ZIndex = 52
    vbox.Parent = topRow

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 6)
    track.Position = UDim2.new(0, 0, 0, 28)
    track.BackgroundColor3 = T.NavBg
    track.BackgroundTransparency = 0.45
    track.BorderSizePixel = 0
    Round(track, 4)
    track.ZIndex = 52
    track.Parent = frame

    local pct = (default - min) / math.max(max - min, 1)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = T.Primary
    fill.BorderSizePixel = 0
    Round(fill, 4)
    fill.ZIndex = 52
    fill.Parent = track

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(pct, -7, 0.5, -7)
    knob.BackgroundColor3 = T.Warning
    Round(knob, 7)
    knob.ZIndex = 53
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
             or style == "danger"  and T.Error
             or style == "admin"   and T.Admin
             or T.SurfaceHi
    local textCol = (style == "admin") and Color3.new(0,0,0) or Color3.new(1,1,1)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 28)
    b.BackgroundColor3 = col
    b.BackgroundTransparency = 0.16
    b.Text = text
    b.TextColor3 = textCol
    b.TextSize = 11
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    Round(b, 8)
    b.ZIndex = 52
    b.Parent = parent
    b.MouseButton1Click:Connect(function()
        Tween(b, {BackgroundColor3 = col:Lerp(Color3.new(1,1,1), 0.12), BackgroundTransparency = 0}, 0.06)
        task.wait(0.08)
        Tween(b, {BackgroundColor3 = col, BackgroundTransparency = 0.16}, 0.12)
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
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1,0,0,20)
    row.BackgroundTransparency = 1
    row.ZIndex = 52
    row.Parent = parent
    local l = Lbl(row, labelTxt, 11, T.Muted)
    l.Size = UDim2.new(0.5,0,1,0)
    local v = Lbl(row, valTxt, 11, valCol or T.Primary, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
    v.Size = UDim2.new(0.5,0,1,0)
    v.Position = UDim2.new(0.5,0,0,0)
    return v
end

StatRow(dsC, "Game Name:",   game.Name:sub(1,20),                 T.Primary)
StatRow(dsC, "Place ID:",    tostring(game.PlaceId),               T.Warning)
StatRow(dsC, "Job ID:",      tostring(game.JobId):sub(1,12) .. (string.len(tostring(game.JobId))>12 and "..." or ""),          T.Muted)
local sPly = StatRow(dsC, "Players:", "--/--",                    T.Success)
StatRow(dsC, "Server Type:", "🌐 Global",                          T.Primary)

StatRow(plrC, "Username:",     LocalPlayer.Name,                   T.Primary)
StatRow(plrC, "User ID:",      tostring(LocalPlayer.UserId),        T.Muted)
StatRow(plrC, "Display Name:", LocalPlayer.DisplayName,             T.Text)
StatRow(plrC, "Team:",         "None",                              T.Warning)

local creditFrame = Instance.new("Frame")
creditFrame.Size = UDim2.new(1,0,0,26)
creditFrame.BackgroundTransparency = 1
creditFrame.ZIndex = 52
creditFrame.Parent = PgDash
local creditLbl = Lbl(creditFrame, "script by aptech", 11, T.Muted, Enum.Font.Gotham, Enum.TextXAlignment.Right)
creditLbl.Size = UDim2.new(1, -10, 1, 0)
creditLbl.Parent = creditFrame

spawn(function()
    while sPly.Parent do
        local pc=0; local mp=0
        pcall(function() pc=#Players:GetPlayers(); mp=Players.MaxPlayers end)
        sPly.Text = pc.."/"..mp
        task.wait(5)
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
Toggle(gC, "Moon Gravity")
Slider(gC, "Custom Gravity", 5, 350, 196)

-- ---------- FLY ----------
local flyC = Section(PgFly, "✈️ FLY CONTROL")

local spdRow = Instance.new("Frame")
spdRow.Size = UDim2.new(1,0,0,28)
spdRow.BackgroundTransparency = 1
spdRow.ZIndex = 52
spdRow.Parent = flyC

local spdLbl = Lbl(spdRow,"Fly Speed:",11,T.Text)
spdLbl.Size = UDim2.new(0.36,0,1,0)

local flyMin = Instance.new("TextButton")
flyMin.Size=UDim2.new(0,30,0,24)
flyMin.Position=UDim2.new(0.42,0,0.5,-12)
flyMin.BackgroundColor3=T.SurfaceHi
flyMin.BackgroundTransparency=0.18
flyMin.Text="−"
flyMin.TextColor3=T.Text
flyMin.TextSize=16
flyMin.Font=Enum.Font.GothamBold
flyMin.AutoButtonColor=false
Round(flyMin,8)
flyMin.ZIndex = 52
flyMin.Parent=spdRow

local flyDisp = Instance.new("TextLabel")
flyDisp.Size=UDim2.new(0,40,0,24)
flyDisp.Position=UDim2.new(0.42,34,0.5,-12)
flyDisp.BackgroundColor3=T.Surface
flyDisp.BackgroundTransparency=0.32
flyDisp.Text="1"
flyDisp.TextColor3=T.Primary
flyDisp.TextSize=12
flyDisp.Font=Enum.Font.GothamBold
flyDisp.TextXAlignment=Enum.TextXAlignment.Center
Round(flyDisp,8)
flyDisp.ZIndex = 52
flyDisp.Parent=spdRow

local flyPlus = Instance.new("TextButton")
flyPlus.Size=UDim2.new(0,30,0,24)
flyPlus.Position=UDim2.new(0.42,78,0.5,-12)
flyPlus.BackgroundColor3=T.SurfaceHi
flyPlus.BackgroundTransparency=0.18
flyPlus.Text="+"
flyPlus.TextColor3=T.Text
flyPlus.TextSize=16
flyPlus.Font=Enum.Font.GothamBold
flyPlus.AutoButtonColor=false
Round(flyPlus,8)
flyPlus.ZIndex = 52
flyPlus.Parent=spdRow

local udRow = Instance.new("Frame")
udRow.Size=UDim2.new(1,0,0,28)
udRow.BackgroundTransparency = 1
udRow.ZIndex = 52
udRow.Parent=flyC

local flyUpBtn = Instance.new("TextButton")
flyUpBtn.Size=UDim2.new(0.49,0,0,26)
flyUpBtn.BackgroundColor3=T.SurfaceHi
flyUpBtn.BackgroundTransparency=0.18
flyUpBtn.Text="▲  UP"
flyUpBtn.TextColor3=T.Text
flyUpBtn.TextSize=11
flyUpBtn.Font=Enum.Font.GothamBold
flyUpBtn.AutoButtonColor=false
Round(flyUpBtn,8)
flyUpBtn.ZIndex = 52
flyUpBtn.Parent=udRow

local flyDnBtn = Instance.new("TextButton")
flyDnBtn.Size=UDim2.new(0.49,0,0,26)
flyDnBtn.Position=UDim2.new(0.51,0,0,0)
flyDnBtn.BackgroundColor3=T.SurfaceHi
flyDnBtn.BackgroundTransparency=0.18
flyDnBtn.Text="▼  DOWN"
flyDnBtn.TextColor3=T.Text
flyDnBtn.TextSize=11
flyDnBtn.Font=Enum.Font.GothamBold
flyDnBtn.AutoButtonColor=false
Round(flyDnBtn,8)
flyDnBtn.ZIndex = 52
flyDnBtn.Parent=udRow

local flyTogBtn = Instance.new("TextButton")
flyTogBtn.Size=UDim2.new(1,0,0,30)
flyTogBtn.BackgroundColor3=T.SurfaceHi
flyTogBtn.BackgroundTransparency=0.18
flyTogBtn.Text="✈️  FLY: OFF"
flyTogBtn.TextColor3=T.Muted
flyTogBtn.TextSize=12
flyTogBtn.Font=Enum.Font.GothamBold
flyTogBtn.AutoButtonColor=false
Round(flyTogBtn,10)
flyTogBtn.ZIndex = 52
flyTogBtn.Parent=flyC

local ncC = Section(PgFly, "🔮 NOCLIP")
Toggle(ncC, "No Clip")

-- ---------- ESP ----------
local espC   = Section(PgESP, "👁️ PLAYER ESP")
Toggle(espC, "Enable Player ESP")

local espV2C = Section(PgESP, "👑 ESP V2  –  ADMIN ONLY")
local espLock = Lbl(espV2C, "🔒 Login Admin untuk mengaktifkan ESP V2", 11, T.Warning)
espLock.Size = UDim2.new(1,0,0,20)
Toggle(espV2C, "👑 ESP V2 (HP + Dist + Team + RGB)")

local blkEspC = Section(PgESP, "🧱 BLOCK / ITEM ESP")
Toggle(blkEspC, "Scan & highlight blocks")

-- ---------- TELEPORT ----------
local tpC = Section(PgTP, "🎯 TELEPORT")

local tpSF = Instance.new("ScrollingFrame")
tpSF.Size=UDim2.new(1,0,0,90)
tpSF.BackgroundColor3=T.SurfaceHi
tpSF.BackgroundTransparency=0.34
tpSF.BorderSizePixel=0
tpSF.ScrollBarThickness=6
tpSF.AutomaticCanvasSize = Enum.AutomaticSize.Y
Round(tpSF,8)
tpSF.ZIndex = 52
tpSF.Parent=tpC

local tpLL = Instance.new("UIListLayout")
tpLL.Padding=UDim.new(0,6)
tpLL.Parent=tpSF

local function RefreshTPList()
    for _, c in pairs(tpSF:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    local n = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            n = n + 1
            local b = Instance.new("TextButton")
            b.Size=UDim2.new(1,-6,0,26)
            b.Position=UDim2.new(0,3,0,0)
            b.BackgroundColor3=T.Surface
            b.BackgroundTransparency=0.18
            b.Text=p.Name
            b.TextColor3=T.Text
            b.TextSize=11
            b.Font=Enum.Font.Gotham
            b.BorderSizePixel=0
            b.AutoButtonColor=false
            Round(b,6)
            b.ZIndex = 52
            b.Parent=tpSF
            b.MouseButton1Click:Connect(function()
                for _, ch in pairs(tpSF:GetChildren()) do if ch:IsA("TextButton") then Tween(ch,{BackgroundColor3=T.Surface, BackgroundTransparency=0.18},0.08) end end
                Tween(b,{BackgroundColor3=T.Primary, BackgroundTransparency=0.08},0.12)
            end)
        end
    end
end
RefreshTPList()
Players.PlayerAdded:Connect(RefreshTPList)
Players.PlayerRemoving:Connect(RefreshTPList)

Btn(tpC, "Teleport to Selected", "primary")
Toggle(tpC, "Follow Selected Player")

-- ---------- GOD ----------
local godC = Section(PgGod, "🛡️ GOD MODE")

local godModeBtn = Instance.new("TextButton")
godModeBtn.Size=UDim2.new(1,0,0,26)
godModeBtn.BackgroundColor3=T.SurfaceHi
godModeBtn.BackgroundTransparency=0.18
godModeBtn.Text="Mode: Gen1  (auto-heal)"
godModeBtn.TextColor3=T.Text
godModeBtn.TextSize=11
godModeBtn.Font=Enum.Font.GothamBold
godModeBtn.AutoButtonColor=false
Round(godModeBtn,8)
godModeBtn.ZIndex = 52
godModeBtn.Parent=godC

Toggle(godC, "God Mode")
Toggle(godC, "Auto Heal")
Btn(godC, "Heal Now", "success")

-- ---------- WORLD ----------
local wC = Section(PgWorld, "🧱 BLOCK SPAWNER")

local function Dropdown(parent, labelTxt, opts)
    local frame = Instance.new("Frame")
    frame.Size=UDim2.new(1,0,0,0)
    frame.AutomaticSize=Enum.AutomaticSize.Y
    frame.BackgroundTransparency=1
    frame.ZIndex = 52
    frame.Parent=parent

    local row = Instance.new("TextButton")
    row.Size=UDim2.new(1,0,0,28)
    row.BackgroundColor3=T.SurfaceHi
    row.BackgroundTransparency=0.18
    row.Text=labelTxt..": "..opts[1].." ▾"
    row.TextColor3=T.Text
    row.TextSize=11
    row.Font=Enum.Font.GothamBold
    row.AutoButtonColor=false
    Round(row,8)
    row.ZIndex = 52
    row.Parent=frame

    local list = Instance.new("Frame")
    list.Size=UDim2.new(1,0,0,0)
    list.BackgroundColor3=T.Surface
    list.BackgroundTransparency=0.32
    list.BorderSizePixel=0
    list.ClipsDescendants=true
    list.ZIndex=54
    Round(list,6)
    list.Parent=frame

    local ll = Instance.new("UIListLayout")
    ll.Parent=list
    local open = false

    for _, opt in ipairs(opts) do
        local ob = Instance.new("TextButton")
        ob.Size=UDim2.new(1,0,0,26)
        ob.BackgroundColor3=T.Surface
        ob.BackgroundTransparency=0.32
        ob.Text=opt
        ob.TextColor3=T.Text
        ob.TextSize=10
        ob.Font=Enum.Font.Gotham
        ob.BorderSizePixel=0
        ob.AutoButtonColor=false
        ob.ZIndex=55
        ob.Parent=list
        ob.MouseButton1Click:Connect(function()
            row.Text=labelTxt..": "..opt.." ▾"
            open=false
            Tween(list,{Size=UDim2.new(1,0,0,0)},0.15)
        end)
    end

    row.MouseButton1Click:Connect(function()
        open = not open
        Tween(list,{Size=UDim2.new(1,0,0,open and #opts*28 or 0)},0.18, Enum.EasingStyle.Quart)
    end)
end

Dropdown(wC, "Block Type",  {"Part","Wedge","CornerWedge","Truss","SpawnLocation"})
Dropdown(wC, "Material",    {"SmoothPlastic","Neon","Glass","Wood","Granite","Metal","ForceField"})
Dropdown(wC, "Color",       {"Red","Blue","Green","Yellow","White","Black","Pink","Orange"})
Slider(wC, "Block Size", 1, 50, 5)
Btn(wC, "🧱 Spawn Block di Depan", "primary")
Btn(wC, "🗑️ Hapus Block Terakhir", "danger")
Btn(wC, "💥 Clear Semua Block", "danger")

-- ---------- AVATAR ----------
local avC = Section(PgAva, "👤 COPY AVATAR")

local avStatus = Lbl(avC, "Pilih player untuk copy tampilan.", 11, T.Muted)
avStatus.Size = UDim2.new(1,0,0,18)
avStatus.ZIndex = 52

local avSF = Instance.new("ScrollingFrame")
avSF.Size=UDim2.new(1,0,0,90)
avSF.BackgroundColor3=T.SurfaceHi
avSF.BackgroundTransparency=0.34
avSF.BorderSizePixel=0
avSF.ScrollBarThickness=6
avSF.AutomaticCanvasSize = Enum.AutomaticSize.Y
Round(avSF,8)
avSF.ZIndex = 52
avSF.Parent=avC

local avLL = Instance.new("UIListLayout")
avLL.Padding=UDim.new(0,6)
avLL.Parent=avSF

local function RefreshAvaList()
    for _, c in pairs(avSF:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local b = Instance.new("TextButton")
            b.Size=UDim2.new(1,-6,0,26)
            b.BackgroundColor3=T.Surface
            b.BackgroundTransparency=0.18
            b.Text=p.Name
            b.TextColor3=T.Text
            b.TextSize=11
            b.Font=Enum.Font.Gotham
            b.BorderSizePixel=0
            b.AutoButtonColor=false
            Round(b,6)
            b.ZIndex = 52
            b.Parent=avSF
            b.MouseButton1Click:Connect(function()
                for _, bb in pairs(avSF:GetChildren()) do
                    if bb:IsA("TextButton") then
                        Tween(bb,{BackgroundColor3=T.Surface, BackgroundTransparency=0.18},0.08)
                    end
                end
                Tween(b,{BackgroundColor3=T.Primary, BackgroundTransparency=0.08},0.12)
            end)
        end
    end
end
RefreshAvaList()
Players.PlayerAdded:Connect(RefreshAvaList)
Players.PlayerRemoving:Connect(RefreshAvaList)

Btn(avC, "👤 Copy Avatar Target", "primary")
Btn(avC, "🔄 Restore Avatar Saya", "normal")

-- ---------- PRESETS ----------
local svC = Section(PgSave, "💾 SAVE PRESET")

local preNameBox = Instance.new("TextBox")
preNameBox.Size=UDim2.new(1,0,0,26)
preNameBox.BackgroundColor3=T.SurfaceHi
preNameBox.BackgroundTransparency=0.18
preNameBox.PlaceholderText="Nama preset…"
preNameBox.Text=""
preNameBox.TextColor3=T.Text
preNameBox.TextSize=11
preNameBox.Font=Enum.Font.Gotham
preNameBox.ClearTextOnFocus=false
Round(preNameBox,8)
preNameBox.ZIndex = 52
preNameBox.Parent=svC

local preSF = Instance.new("ScrollingFrame")
preSF.Size=UDim2.new(1,0,0,80)
preSF.BackgroundColor3=T.SurfaceHi
preSF.BackgroundTransparency=0.34
preSF.BorderSizePixel=0
preSF.ScrollBarThickness=6
preSF.AutomaticCanvasSize = Enum.AutomaticSize.Y
Round(preSF,8)
preSF.ZIndex = 52
preSF.Parent=svC
local preLL = Instance.new("UIListLayout")
preLL.Padding=UDim.new(0,6)
preLL.Parent=preSF

Btn(svC, "💾 Save Settings Sekarang", "primary")

local exportBox = Instance.new("TextBox")
exportBox.Size=UDim2.new(1,0,0,48)
exportBox.BackgroundColor3=T.NavBg
exportBox.BackgroundTransparency=0.36
exportBox.PlaceholderText="Kode export akan muncul di sini…"
exportBox.Text=""
exportBox.TextColor3=T.Primary
exportBox.TextSize=10
exportBox.Font=Enum.Font.Code
exportBox.MultiLine=true
exportBox.TextXAlignment=Enum.TextXAlignment.Left
exportBox.TextYAlignment=Enum.TextYAlignment.Top
exportBox.ClearTextOnFocus=false
Round(exportBox,8)
exportBox.ZIndex = 52
exportBox.Parent=svC

local importBox = Instance.new("TextBox")
importBox.Size=UDim2.new(1,0,0,42)
importBox.BackgroundColor3=T.NavBg
importBox.BackgroundTransparency=0.36
importBox.PlaceholderText="Paste kode import di sini…"
importBox.Text=""
importBox.TextColor3=T.Text
importBox.TextSize=10
importBox.Font=Enum.Font.Code
importBox.MultiLine=true
importBox.TextXAlignment=Enum.TextXAlignment.Left
importBox.TextYAlignment=Enum.TextYAlignment.Top
importBox.ClearTextOnFocus=false
Round(importBox,8)
importBox.ZIndex = 52
importBox.Parent=svC

Btn(svC, "📥 Import dari Kode", "normal")

-- ---------- ADMIN ----------
local adC = Section(PgAdmin, "🔐 ADMIN LOGIN")

local adStatus = Lbl(adC, "🔒 Belum terautentikasi", 11, T.Muted)
adStatus.Size = UDim2.new(1,0,0,18)
adStatus.ZIndex = 52

local pwBox = Instance.new("TextBox")
pwBox.Size=UDim2.new(1,0,0,28)
pwBox.BackgroundColor3=T.NavBg
pwBox.BackgroundTransparency=0.36
pwBox.PlaceholderText="Masukkan password…"
pwBox.Text=""
pwBox.TextColor3=T.Text
pwBox.TextSize=12
pwBox.Font=Enum.Font.GothamBold
pwBox.ClearTextOnFocus=false
Round(pwBox,8)
pwBox.ZIndex = 52
pwBox.Parent=adC

Btn(adC, "🔓 Unlock Admin Mode", "admin")

-- ---------- UTILITY ----------
local utC  = Section(PgUtil, "⚙️ UTILITIES")
local srC  = Section(PgUtil, "🌐 SERVER")

Toggle(utC, "Full Bright")
Toggle(utC, "Anti-AFK")
Toggle(utC, "Unlock Camera Zoom")
Toggle(utC, "FPS Boost")

Btn(srC, "Rejoin Server", "primary")
Btn(srC, "Server Hop", "normal")

-- ==================== ORB / MINIMIZE / CLOSE ====================
local OrbBtn = Instance.new("ImageButton")
OrbBtn.Size = UDim2.new(0, 50, 0, 50)
OrbBtn.Position = UDim2.new(0, 12, 0.5, -25)
OrbBtn.BackgroundColor3 = T.Primary
OrbBtn.BackgroundTransparency = 0.1
OrbBtn.Image = ""
OrbBtn.Visible = false
OrbBtn.ZIndex = 1000
OrbBtn.Active = true
OrbBtn.AutoButtonColor = false
Round(OrbBtn, 25)
Stroke(OrbBtn, T.Warning, 1.6)
OrbBtn.Parent = SG

-- Orb manual dragging (more consistent cross-executor)
do
    local dragging = false
    local dragStartPos, orbStartPos
    OrbBtn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStartPos = i.Position
            orbStartPos = OrbBtn.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - dragStartPos
            OrbBtn.Position = UDim2.new(orbStartPos.X.Scale, orbStartPos.X.Offset + delta.X, orbStartPos.Y.Scale, orbStartPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

MinBtn.MouseButton1Click:Connect(function()
    Tween(MF, {Size = UDim2.new(0, 450, 0, 0)}, 0.22, Enum.EasingStyle.Quad)
    task.wait(0.22)
    MF.Visible = false
    OrbBtn.Visible = true
end)

OrbBtn.MouseButton1Click:Connect(function()
    OrbBtn.Visible = false
    MF.Visible = true
    Tween(MF, {Size = UDim2.new(0, 450, 0, 290)}, 0.36, Enum.EasingStyle.Back)
end)

CloseBtn.MouseButton1Click:Connect(function()
    SG:Destroy()
end)

-- ====================== OPENING ANIMASI MAIN =======================
MF.Size = UDim2.new(0, 0, 0, 0)
GoPage("Dash")
task.wait(0.15)
MF.Visible = true
Tween(MF, {Size = UDim2.new(0, 450, 0, 290)}, 0.52, Enum.EasingStyle.Back)

-- ==================== FETCH IMAGE (di background, non-blocking) ====================
task.spawn(function()
    local logoId = fetchImage(imageUrls.logo, "apng_logo.png")
    if logoId ~= "" then
        -- apply to the small MinIcon and Orb (Orb keeps full image)
        MinIcon.Image = logoId
        OrbBtn.Image = logoId
    end

    local bgId = fetchImage(imageUrls.bg, "apng_bg.jpg")
    if bgId ~= "" then
        BgImage.Image = bgId
    end
end)
