--[[
    AP-NEXTGEN v9.1 – UI SHELL (FIXED & POLISHED)
    Tema: Biru & Kuning Transparan
    Fix: MinBtn bukan ImageButton, ikon rapi, layout profesional
]]

-- Services
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- ==================== IMAGE LOADER ====================
local imageUrls = {
    logo = "https://raw.githubusercontent.com/aryaexeuyf/Image/main/logo_g1.png",
    bg   = "https://raw.githubusercontent.com/aryaexeuyf/Image/main/background.jpg"
}

local httpFunc = nil
if syn and syn.request then httpFunc = syn.request
elseif http_request then httpFunc = http_request
elseif http and http.request then httpFunc = http.request
elseif request then httpFunc = request end

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
    Bg        = Color3.fromRGB(8, 8, 20),
    Surface   = Color3.fromRGB(18, 18, 38),
    SurfaceHi = Color3.fromRGB(30, 30, 55),
    NavBg     = Color3.fromRGB(10, 10, 22),
    Primary   = Color3.fromRGB(0, 170, 255),
    Success   = Color3.fromRGB(0, 210, 110),
    Warning   = Color3.fromRGB(255, 200, 0),
    Error     = Color3.fromRGB(255, 65, 75),
    Admin     = Color3.fromRGB(255, 210, 0),
    Text      = Color3.fromRGB(235, 235, 250),
    Muted     = Color3.fromRGB(140, 140, 175),
    Border    = Color3.fromRGB(55, 55, 100),

    bgTrans   = 0.40,
    surfTrans = 0.28,
    navTrans  = 0.50,
}

-- ==================== HELPERS ====================
local function Tween(obj, props, dur, style)
    TweenService:Create(obj, TweenInfo.new(dur or 0.22, style or Enum.EasingStyle.Quart), props):Play()
end

local function Round(inst, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = inst
end

local function Stroke(inst, col, th)
    local s = Instance.new("UIStroke")
    s.Color = col or T.Border
    s.Thickness = th or 1
    s.Parent = inst
end

local function Lbl(parent, text, size, color, font, alignX)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextSize = size or 11
    l.TextColor3 = color or T.Text
    l.Font = font or Enum.Font.Gotham
    l.TextXAlignment = alignX or Enum.TextXAlignment.Left
    l.TextTruncate = Enum.TextTruncate.AtEnd
    l.Parent = parent
    return l
end

-- ==================== SCREENGUI ====================
local SG = Instance.new("ScreenGui")
SG.Name = "APNEXTGEN_UI"
SG.Parent = CoreGui
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.DisplayOrder = 100

-- ==================== OPENING SEQUENCE ====================
local OpenFrame = Instance.new("Frame")
OpenFrame.Size = UDim2.new(1, 0, 1, 0)
OpenFrame.BackgroundColor3 = Color3.new(0, 0, 0)
OpenFrame.BackgroundTransparency = 0
OpenFrame.ZIndex = 200
OpenFrame.Parent = SG

local OpenTitle = Instance.new("TextLabel")
OpenTitle.Size = UDim2.new(0, 500, 0, 90)
OpenTitle.Position = UDim2.new(0.5, -250, 0.5, -70)
OpenTitle.BackgroundTransparency = 1
OpenTitle.Text = "AP-NEXTGEN"
OpenTitle.TextColor3 = T.Primary
OpenTitle.TextSize = 62
OpenTitle.Font = Enum.Font.GothamBold
OpenTitle.TextXAlignment = Enum.TextXAlignment.Center
OpenTitle.TextYAlignment = Enum.TextYAlignment.Center
OpenTitle.TextTransparency = 1
OpenTitle.ZIndex = 201
OpenTitle.Parent = OpenFrame

local OpenSub = Instance.new("TextLabel")
OpenSub.Size = UDim2.new(0, 300, 0, 36)
OpenSub.Position = UDim2.new(0.5, -150, 0.5, 24)
OpenSub.BackgroundTransparency = 1
OpenSub.Text = "by  A P T E C H"
OpenSub.TextColor3 = T.Warning
OpenSub.TextSize = 22
OpenSub.Font = Enum.Font.GothamBold
OpenSub.TextXAlignment = Enum.TextXAlignment.Center
OpenSub.TextTransparency = 1
OpenSub.ZIndex = 201
OpenSub.Parent = OpenFrame

-- Garis dekorasi
local line1 = Instance.new("Frame")
line1.Size = UDim2.new(0, 0, 0, 1)
line1.Position = UDim2.new(0.5, 0, 0.5, 20)
line1.BackgroundColor3 = T.Primary
line1.BackgroundTransparency = 0.3
line1.ZIndex = 201
line1.Parent = OpenFrame

Tween(OpenTitle, {TextTransparency = 0}, 1.0, Enum.EasingStyle.Quint)
Tween(line1, {Size = UDim2.new(0, 320, 0, 1), Position = UDim2.new(0.5, -160, 0.5, 20)}, 0.8, Enum.EasingStyle.Quint)
wait(0.5)
Tween(OpenSub, {TextTransparency = 0}, 0.7, Enum.EasingStyle.Quint)
wait(1.6)
Tween(OpenFrame, {BackgroundTransparency = 1}, 0.7)
Tween(OpenTitle, {TextTransparency = 1}, 0.5)
Tween(OpenSub, {TextTransparency = 1}, 0.5)
wait(0.7)
OpenFrame:Destroy()

-- ==================== MAIN FRAME ====================
local MF = Instance.new("Frame")
MF.Name = "MainFrame"
MF.Size = UDim2.new(0, 460, 0, 295)
MF.Position = UDim2.new(0.5, -230, 0.5, -148)
MF.BackgroundColor3 = T.Bg
MF.BackgroundTransparency = T.bgTrans
MF.BorderSizePixel = 0
MF.ClipsDescendants = true
MF.Active = true
MF.Visible = false
Round(MF, 14)
Stroke(MF, T.Primary, 1)
MF.Parent = SG

-- Background image (z=0, muncul setelah fetch)
local BgImage = Instance.new("ImageLabel")
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.BackgroundTransparency = 1
BgImage.Image = ""
BgImage.ScaleType = Enum.ScaleType.Crop
BgImage.ImageTransparency = 0.25
BgImage.ZIndex = 0
BgImage.Parent = MF

-- ==================== TOP BAR ====================
local TOP_H = 42

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, TOP_H)
TopBar.BackgroundColor3 = T.Surface
TopBar.BackgroundTransparency = T.surfTrans
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 5
TopBar.Parent = MF
Round(TopBar, 14)

-- Patch rounded bagian bawah topbar agar rata
local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 14)
TopFix.Position = UDim2.new(0, 0, 1, -14)
TopFix.BackgroundColor3 = T.Surface
TopFix.BackgroundTransparency = T.surfTrans
TopFix.BorderSizePixel = 0
TopFix.ZIndex = 4
TopFix.Parent = TopBar

-- Avatar
local AvImg = Instance.new("ImageLabel")
AvImg.Size = UDim2.new(0, 28, 0, 28)
AvImg.Position = UDim2.new(0, 8, 0.5, -14)
AvImg.BackgroundColor3 = T.SurfaceHi
AvImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=150&height=150&format=png"
AvImg.ZIndex = 6
Round(AvImg, 14)
Stroke(AvImg, T.Primary, 1)
AvImg.Parent = TopBar

-- Username
local NameLbl = Lbl(TopBar, LocalPlayer.Name, 11, T.Text, Enum.Font.GothamBold)
NameLbl.Size = UDim2.new(0, 95, 0, 15)
NameLbl.Position = UDim2.new(0, 42, 0, 6)
NameLbl.ZIndex = 6

-- Game name kecil
local GameLbl = Lbl(TopBar, game.Name:sub(1, 15), 9, T.Muted)
GameLbl.Size = UDim2.new(0, 95, 0, 13)
GameLbl.Position = UDim2.new(0, 42, 0, 22)
GameLbl.ZIndex = 6

-- Server info tengah
local SrvLbl = Lbl(TopBar, "● Global  |  --/--", 9, T.Primary, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
SrvLbl.Size = UDim2.new(0, 180, 0, 14)
SrvLbl.Position = UDim2.new(0.5, -90, 0.5, -7)
SrvLbl.ZIndex = 6

-- ── Tombol kanan: MINIMIZE (text "-") dan CLOSE ("✕") ──
-- MINIMIZE: TextButton biasa dengan teks "−"
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 26)
MinBtn.Position = UDim2.new(1, -66, 0.5, -13)
MinBtn.BackgroundColor3 = T.SurfaceHi
MinBtn.BackgroundTransparency = 0.2
MinBtn.Text = "−"
MinBtn.TextColor3 = T.Text
MinBtn.TextSize = 18
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BorderSizePixel = 0
MinBtn.AutoButtonColor = false
MinBtn.ZIndex = 7
Round(MinBtn, 8)
Stroke(MinBtn, T.Border, 1)
MinBtn.Parent = TopBar

-- CLOSE: TextButton "✕"
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 26)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -13)
CloseBtn.BackgroundColor3 = T.Error
CloseBtn.BackgroundTransparency = 0.1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.AutoButtonColor = false
CloseBtn.ZIndex = 7
Round(CloseBtn, 8)
MinBtn.MouseEnter:Connect(function() Tween(MinBtn, {BackgroundColor3 = T.Border}, 0.15) end)
MinBtn.MouseLeave:Connect(function() Tween(MinBtn, {BackgroundColor3 = T.SurfaceHi}, 0.15) end)
CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn, {BackgroundTransparency = 0}, 0.15) end)
CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn, {BackgroundTransparency = 0.1}, 0.15) end)
CloseBtn.Parent = TopBar

-- ==================== SERVER INFO UPDATER ====================
spawn(function()
    while SG and SG.Parent do
        local pc = #Players:GetPlayers()
        local mp = 0
        pcall(function() mp = Players.MaxPlayers end)
        SrvLbl.Text = "● Global  |  "..pc.."/"..mp
        GameLbl.Text = game.Name:sub(1, 15)
        wait(5)
    end
end)

-- ==================== DRAG ====================
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
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        _drag = false
    end
end)

-- ==================== LEFT NAV SIDEBAR ====================
local NAV_W = 52

local NavFrame = Instance.new("ScrollingFrame")
NavFrame.Size = UDim2.new(0, NAV_W, 1, -TOP_H)
NavFrame.Position = UDim2.new(0, 0, 0, TOP_H)
NavFrame.BackgroundColor3 = T.NavBg
NavFrame.BackgroundTransparency = T.navTrans
NavFrame.BorderSizePixel = 0
NavFrame.ScrollBarThickness = 0
NavFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
NavFrame.ScrollingDirection = Enum.ScrollingDirection.Y
NavFrame.ZIndex = 2
NavFrame.Parent = MF

Instance.new("UIListLayout", NavFrame).Padding = UDim.new(0, 3)
local np = Instance.new("UIPadding", NavFrame)
np.PaddingTop = UDim.new(0, 7)
np.PaddingBottom = UDim.new(0, 7)
np.PaddingLeft = UDim.new(0, 2)
np.PaddingRight = UDim.new(0, 2)

-- Divider
local Div = Instance.new("Frame")
Div.Size = UDim2.new(0, 1, 1, -TOP_H)
Div.Position = UDim2.new(0, NAV_W, 0, TOP_H)
Div.BackgroundColor3 = T.Border
Div.BackgroundTransparency = 0.2
Div.BorderSizePixel = 0
Div.ZIndex = 2
Div.Parent = MF

-- ==================== CONTENT AREA ====================
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -(NAV_W + 1), 1, -TOP_H)
ContentArea.Position = UDim2.new(0, NAV_W + 1, 0, TOP_H)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.ZIndex = 2
ContentArea.Parent = MF

-- ==================== PAGE SYSTEM ====================
local Pages   = {}
local NavBtns = {}

local function NewPage(name)
    local sf = Instance.new("ScrollingFrame")
    sf.Name = name
    sf.Size = UDim2.new(1, 0, 1, 0)
    sf.BackgroundTransparency = 1
    sf.BorderSizePixel = 0
    sf.ScrollBarThickness = 3
    sf.ScrollBarImageColor3 = T.Primary
    sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sf.ScrollingDirection = Enum.ScrollingDirection.Y
    sf.Visible = false
    sf.Parent = ContentArea

    local ll = Instance.new("UIListLayout", sf)
    ll.Padding = UDim.new(0, 5)

    local pd = Instance.new("UIPadding", sf)
    pd.PaddingTop    = UDim.new(0, 7)
    pd.PaddingLeft   = UDim.new(0, 7)
    pd.PaddingRight  = UDim.new(0, 7)
    pd.PaddingBottom = UDim.new(0, 7)

    Pages[name] = sf
    return sf
end

local function GoPage(name)
    for n, pg in pairs(Pages) do pg.Visible = (n == name) end
    for n, btn in pairs(NavBtns) do
        if n == name then
            Tween(btn, {BackgroundColor3 = T.Primary, BackgroundTransparency = 0.05}, 0.18)
            Tween(btn, {TextColor3 = Color3.new(1,1,1)}, 0.18)
        else
            Tween(btn, {BackgroundColor3 = T.NavBg, BackgroundTransparency = T.navTrans + 0.2}, 0.18)
            Tween(btn, {TextColor3 = T.Muted}, 0.18)
        end
    end
end

-- Nav button: icon kecil + label 1-3 huruf
local function NavBtn(icon, label, pageName)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 44)
    b.BackgroundColor3 = T.NavBg
    b.BackgroundTransparency = T.navTrans + 0.2
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.ZIndex = 3
    Round(b, 8)
    b.Parent = NavFrame
    NavBtns[pageName] = b

    -- Icon baris atas
    local ic = Instance.new("TextLabel")
    ic.Size = UDim2.new(1, 0, 0, 22)
    ic.Position = UDim2.new(0, 0, 0, 4)
    ic.BackgroundTransparency = 1
    ic.Text = icon
    ic.TextSize = 16
    ic.Font = Enum.Font.GothamBold
    ic.TextColor3 = T.Muted
    ic.TextXAlignment = Enum.TextXAlignment.Center
    ic.ZIndex = 4
    ic.Parent = b

    -- Label baris bawah
    local lb = Instance.new("TextLabel")
    lb.Size = UDim2.new(1, 0, 0, 13)
    lb.Position = UDim2.new(0, 0, 0, 26)
    lb.BackgroundTransparency = 1
    lb.Text = label
    lb.TextSize = 8
    lb.Font = Enum.Font.GothamBold
    lb.TextColor3 = T.Muted
    lb.TextXAlignment = Enum.TextXAlignment.Center
    lb.ZIndex = 4
    lb.Parent = b

    b.MouseButton1Click:Connect(function() GoPage(pageName) end)

    -- Highlight icon & label saat aktif
    local function setActive(on)
        local col = on and Color3.new(1,1,1) or T.Muted
        Tween(ic, {TextColor3 = col}, 0.15)
        Tween(lb, {TextColor3 = col}, 0.15)
    end
    NavBtns[pageName .. "_setActive"] = setActive

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
    Round(card, 8)
    Stroke(card, T.Border, 0.8)
    card.Parent = parent

    local ttl = Lbl(card, title, 10, T.Primary, Enum.Font.GothamBold)
    ttl.Size = UDim2.new(1, -12, 0, 20)
    ttl.Position = UDim2.new(0, 8, 0, 4)

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, -12, 0, 1)
    line.Position = UDim2.new(0, 6, 0, 24)
    line.BackgroundColor3 = T.Border
    line.BackgroundTransparency = 0.3
    line.BorderSizePixel = 0
    line.Parent = card

    local cont = Instance.new("Frame")
    cont.Name = "Cont"
    cont.Size = UDim2.new(1, -12, 0, 0)
    cont.Position = UDim2.new(0, 6, 0, 28)
    cont.AutomaticSize = Enum.AutomaticSize.Y
    cont.BackgroundTransparency = 1
    cont.Parent = card

    local cL = Instance.new("UIListLayout", cont)
    cL.Padding = UDim.new(0, 5)

    local cP = Instance.new("UIPadding", card)
    cP.PaddingBottom = UDim.new(0, 7)

    return cont
end

local function Toggle(parent, text, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 26)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local lbl = Lbl(row, text, 10, T.Text)
    lbl.Size = UDim2.new(1, -56, 1, 0)

    -- Track background
    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 40, 0, 18)
    track.Position = UDim2.new(1, -42, 0.5, -9)
    track.BackgroundColor3 = T.SurfaceHi
    track.BackgroundTransparency = 0
    track.BorderSizePixel = 0
    Round(track, 9)
    Stroke(track, T.Border, 1)
    track.Parent = row

    -- Knob
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(0, 2, 0.5, -7)
    knob.BackgroundColor3 = T.Muted
    knob.BorderSizePixel = 0
    Round(knob, 7)
    knob.Parent = track

    local on = false
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 2
    btn.Parent = track

    btn.MouseButton1Click:Connect(function()
        on = not on
        if on then
            Tween(track, {BackgroundColor3 = T.Success}, 0.18)
            Tween(knob,  {Position = UDim2.new(0, 24, 0.5, -7), BackgroundColor3 = Color3.new(1,1,1)}, 0.18)
        else
            Tween(track, {BackgroundColor3 = T.SurfaceHi}, 0.18)
            Tween(knob,  {Position = UDim2.new(0, 2,  0.5, -7), BackgroundColor3 = T.Muted}, 0.18)
        end
        if callback then callback(on) end
    end)
    return btn
end

local function Slider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 42)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local lbl = Lbl(frame, text, 10, T.Text)
    lbl.Size = UDim2.new(0.6, 0, 0, 16)

    local vbox = Instance.new("TextBox")
    vbox.Size = UDim2.new(0, 44, 0, 16)
    vbox.Position = UDim2.new(1, -44, 0, 0)
    vbox.BackgroundColor3 = T.SurfaceHi
    vbox.BackgroundTransparency = 0.1
    vbox.Text = tostring(default)
    vbox.TextColor3 = T.Primary
    vbox.TextSize = 9
    vbox.Font = Enum.Font.GothamBold
    vbox.ClearTextOnFocus = false
    vbox.TextXAlignment = Enum.TextXAlignment.Center
    Round(vbox, 5)
    vbox.Parent = frame

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 4)
    track.Position = UDim2.new(0, 0, 0, 24)
    track.BackgroundColor3 = T.SurfaceHi
    track.BackgroundTransparency = 0.2
    track.BorderSizePixel = 0
    Round(track, 2)
    track.Parent = frame

    local pct = (default - min) / math.max(max - min, 1)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = T.Primary
    fill.BorderSizePixel = 0
    Round(fill, 2)
    fill.Parent = track

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = UDim2.new(pct, -6, 0.5, -6)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    Round(knob, 6)
    knob.Parent = track

    local dragging = false
    local function doUpdate(input)
        local p = math.clamp((input.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
        local v = math.floor(min + (max - min) * p)
        vbox.Text = tostring(v)
        fill.Size = UDim2.new(p, 0, 1, 0)
        knob.Position = UDim2.new(p, -6, 0.5, -6)
        if callback then callback(v) end
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
        knob.Position = UDim2.new(p, -6, 0.5, -6)
        if callback then callback(v) end
    end)
    return frame
end

local function Btn(parent, text, style, callback)
    local col = style == "primary" and T.Primary
             or style == "success" and T.Success
             or style == "danger"  and T.Error
             or style == "admin"   and T.Admin
             or T.SurfaceHi
    local txtCol = (style == "admin") and Color3.new(0,0,0) or Color3.new(1,1,1)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 26)
    b.BackgroundColor3 = col
    b.BackgroundTransparency = 0.15
    b.Text = text
    b.TextColor3 = txtCol
    b.TextSize = 10
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    Round(b, 7)
    b.Parent = parent
    b.MouseEnter:Connect(function() Tween(b, {BackgroundTransparency = 0}, 0.12) end)
    b.MouseLeave:Connect(function() Tween(b, {BackgroundTransparency = 0.15}, 0.12) end)
    b.MouseButton1Click:Connect(function()
        Tween(b, {BackgroundColor3 = col:Lerp(Color3.new(1,1,1), 0.15)}, 0.06)
        wait(0.06)
        Tween(b, {BackgroundColor3 = col}, 0.1)
        if callback then callback() end
    end)
    return b
end

local function Dropdown(parent, labelTxt, opts)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 0)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.BackgroundTransparency = 1
    frame.ClipsDescendants = false
    frame.Parent = parent

    local selected = opts[1]

    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, 0, 0, 26)
    row.BackgroundColor3 = T.SurfaceHi
    row.BackgroundTransparency = 0.15
    row.Text = labelTxt..":  "..selected.."  ▾"
    row.TextColor3 = T.Text
    row.TextSize = 10
    row.Font = Enum.Font.GothamBold
    row.AutoButtonColor = false
    row.ZIndex = 5
    Round(row, 7)
    row.Parent = frame

    local list = Instance.new("Frame")
    list.Size = UDim2.new(1, 0, 0, 0)
    list.Position = UDim2.new(0, 0, 0, 28)
    list.BackgroundColor3 = T.Surface
    list.BackgroundTransparency = 0.1
    list.BorderSizePixel = 0
    list.ClipsDescendants = true
    list.ZIndex = 20
    Round(list, 7)
    Stroke(list, T.Border, 1)
    list.Parent = frame

    local ll = Instance.new("UIListLayout", list)
    local open = false

    for _, opt in ipairs(opts) do
        local ob = Instance.new("TextButton")
        ob.Size = UDim2.new(1, 0, 0, 24)
        ob.BackgroundColor3 = T.Surface
        ob.BackgroundTransparency = 0.1
        ob.Text = "  "..opt
        ob.TextColor3 = T.Text
        ob.TextSize = 10
        ob.Font = Enum.Font.Gotham
        ob.TextXAlignment = Enum.TextXAlignment.Left
        ob.BorderSizePixel = 0
        ob.AutoButtonColor = false
        ob.ZIndex = 21
        ob.Parent = list
        ob.MouseEnter:Connect(function() Tween(ob, {BackgroundColor3 = T.SurfaceHi}, 0.1) end)
        ob.MouseLeave:Connect(function() Tween(ob, {BackgroundColor3 = T.Surface}, 0.1) end)
        ob.MouseButton1Click:Connect(function()
            selected = opt
            row.Text = labelTxt..":  "..opt.."  ▾"
            open = false
            Tween(list, {Size = UDim2.new(1, 0, 0, 0)}, 0.15)
        end)
    end

    row.MouseButton1Click:Connect(function()
        open = not open
        Tween(list, {Size = UDim2.new(1, 0, 0, open and #opts * 24 or 0)}, 0.18)
    end)
    return frame
end

-- ==================== BUAT HALAMAN ====================
NavBtn("📊", "DASH",  "Dash");  local PgDash  = NewPage("Dash")
NavBtn("🏃", "MOVE",  "Move");  local PgMove  = NewPage("Move")
NavBtn("✈️", "FLY",   "Fly");   local PgFly   = NewPage("Fly")
NavBtn("👁", "ESP",   "ESP");   local PgESP   = NewPage("ESP")
NavBtn("🎯", "TP",    "TP");    local PgTP    = NewPage("TP")
NavBtn("🛡", "GOD",   "God");   local PgGod   = NewPage("God")
NavBtn("🧱", "WORLD", "World"); local PgWorld = NewPage("World")
NavBtn("👤", "AVA",   "Ava");   local PgAva   = NewPage("Ava")
NavBtn("💾", "SAVE",  "Save");  local PgSave  = NewPage("Save")
NavBtn("🔐", "ADMIN", "Admin"); local PgAdmin = NewPage("Admin")
NavBtn("⚙", "UTIL",  "Util");  local PgUtil  = NewPage("Util")

-- ====================================================================
-- ====================== ISI TIAP HALAMAN ============================
-- ====================================================================

-- Stat row helper
local function StatRow(parent, labelTxt, valTxt, valCol)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 18)
    row.BackgroundTransparency = 1
    row.Parent = parent
    local l = Lbl(row, labelTxt, 9, T.Muted)
    l.Size = UDim2.new(0.5, 0, 1, 0)
    local v = Lbl(row, valTxt, 9, valCol or T.Primary, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
    v.Size = UDim2.new(0.5, 0, 1, 0)
    v.Position = UDim2.new(0.5, 0, 0, 0)
    return v
end

-- ---------- DASHBOARD ----------
local dsC  = Section(PgDash, "📊  SERVER MONITOR")
local plrC = Section(PgDash, "👤  PLAYER INFO")

StatRow(dsC, "Game Name:",   game.Name:sub(1, 20),         T.Primary)
StatRow(dsC, "Place ID:",    tostring(game.PlaceId),        T.Warning)
StatRow(dsC, "Job ID:",      game.JobId:sub(1, 14).."…",   T.Muted)
local sPly = StatRow(dsC, "Players:",  "--/--",             T.Success)
StatRow(dsC, "Server:",      "Global",                      T.Primary)

StatRow(plrC, "Username:",     LocalPlayer.Name,            T.Primary)
StatRow(plrC, "User ID:",      tostring(LocalPlayer.UserId), T.Muted)
StatRow(plrC, "Display Name:", LocalPlayer.DisplayName,     T.Text)
StatRow(plrC, "Team:",         "None",                      T.Warning)

local creditLbl = Lbl(PgDash, "script by aptech", 9, T.Muted, Enum.Font.Gotham, Enum.TextXAlignment.Right)
creditLbl.Size = UDim2.new(1, -4, 0, 16)

spawn(function()
    while sPly.Parent do
        local pc, mp = 0, 0
        pcall(function() pc = #Players:GetPlayers(); mp = Players.MaxPlayers end)
        sPly.Text = pc.."/"..mp
        wait(5)
    end
end)

-- ---------- MOVEMENT ----------
local mvC = Section(PgMove, "🏃  SPEED & JUMP")
Slider(mvC, "Walk Speed",  1, 500, 16)
Slider(mvC, "Jump Power",  1, 500, 50)
Btn(mvC, "Reset to Default", "normal")

local jC = Section(PgMove, "⬆  JUMP")
Toggle(jC, "Infinite Jump")

local gC = Section(PgMove, "🌙  GRAVITY")
Toggle(gC, "Moon Gravity")
Slider(gC, "Custom Gravity", 5, 350, 196)

-- ---------- FLY ----------
local flyC = Section(PgFly, "✈  FLY CONTROL")

-- Speed row ─ tombol − Nilai +
local spdRow = Instance.new("Frame")
spdRow.Size = UDim2.new(1, 0, 0, 26)
spdRow.BackgroundTransparency = 1
spdRow.Parent = flyC

local spdLbl = Lbl(spdRow, "Fly Speed", 10, T.Text)
spdLbl.Size = UDim2.new(0.38, 0, 1, 0)

local flyMin = Instance.new("TextButton")
flyMin.Size = UDim2.new(0, 24, 0, 22)
flyMin.Position = UDim2.new(0.4, 0, 0.5, -11)
flyMin.BackgroundColor3 = T.SurfaceHi
flyMin.BackgroundTransparency = 0.15
flyMin.Text = "−"
flyMin.TextColor3 = T.Text
flyMin.TextSize = 14
flyMin.Font = Enum.Font.GothamBold
flyMin.AutoButtonColor = false
Round(flyMin, 6)
flyMin.Parent = spdRow

local flyDisp = Instance.new("TextLabel")
flyDisp.Size = UDim2.new(0, 32, 0, 22)
flyDisp.Position = UDim2.new(0.4, 26, 0.5, -11)
flyDisp.BackgroundColor3 = T.Surface
flyDisp.BackgroundTransparency = 0.2
flyDisp.Text = "1"
flyDisp.TextColor3 = T.Primary
flyDisp.TextSize = 10
flyDisp.Font = Enum.Font.GothamBold
flyDisp.TextXAlignment = Enum.TextXAlignment.Center
Round(flyDisp, 6)
flyDisp.Parent = spdRow

local flyPlus = Instance.new("TextButton")
flyPlus.Size = UDim2.new(0, 24, 0, 22)
flyPlus.Position = UDim2.new(0.4, 60, 0.5, -11)
flyPlus.BackgroundColor3 = T.SurfaceHi
flyPlus.BackgroundTransparency = 0.15
flyPlus.Text = "+"
flyPlus.TextColor3 = T.Text
flyPlus.TextSize = 14
flyPlus.Font = Enum.Font.GothamBold
flyPlus.AutoButtonColor = false
Round(flyPlus, 6)
flyPlus.Parent = spdRow

local flySpeed = 1
flyMin.MouseButton1Click:Connect(function()
    flySpeed = math.max(1, flySpeed - 1)
    flyDisp.Text = tostring(flySpeed)
end)
flyPlus.MouseButton1Click:Connect(function()
    flySpeed = math.min(200, flySpeed + 1)
    flyDisp.Text = tostring(flySpeed)
end)

-- UP / DOWN row
local udRow = Instance.new("Frame")
udRow.Size = UDim2.new(1, 0, 0, 26)
udRow.BackgroundTransparency = 1
udRow.Parent = flyC

local flyUpBtn = Instance.new("TextButton")
flyUpBtn.Size = UDim2.new(0.48, 0, 0, 24)
flyUpBtn.BackgroundColor3 = T.SurfaceHi
flyUpBtn.BackgroundTransparency = 0.15
flyUpBtn.Text = "▲  UP"
flyUpBtn.TextColor3 = T.Text
flyUpBtn.TextSize = 10
flyUpBtn.Font = Enum.Font.GothamBold
flyUpBtn.AutoButtonColor = false
Round(flyUpBtn, 7)
flyUpBtn.Parent = udRow

local flyDnBtn = Instance.new("TextButton")
flyDnBtn.Size = UDim2.new(0.48, 0, 0, 24)
flyDnBtn.Position = UDim2.new(0.52, 0, 0, 0)
flyDnBtn.BackgroundColor3 = T.SurfaceHi
flyDnBtn.BackgroundTransparency = 0.15
flyDnBtn.Text = "▼  DOWN"
flyDnBtn.TextColor3 = T.Text
flyDnBtn.TextSize = 10
flyDnBtn.Font = Enum.Font.GothamBold
flyDnBtn.AutoButtonColor = false
Round(flyDnBtn, 7)
flyDnBtn.Parent = udRow

-- Fly toggle
local flyOn = false
local flyTogBtn = Instance.new("TextButton")
flyTogBtn.Size = UDim2.new(1, 0, 0, 28)
flyTogBtn.BackgroundColor3 = T.SurfaceHi
flyTogBtn.BackgroundTransparency = 0.15
flyTogBtn.Text = "✈  FLY:  OFF"
flyTogBtn.TextColor3 = T.Muted
flyTogBtn.TextSize = 11
flyTogBtn.Font = Enum.Font.GothamBold
flyTogBtn.AutoButtonColor = false
Round(flyTogBtn, 8)
flyTogBtn.Parent = flyC

flyTogBtn.MouseButton1Click:Connect(function()
    flyOn = not flyOn
    if flyOn then
        Tween(flyTogBtn, {BackgroundColor3 = T.Primary, BackgroundTransparency = 0.05}, 0.18)
        flyTogBtn.TextColor3 = Color3.new(1,1,1)
        flyTogBtn.Text = "✈  FLY:  ON"
    else
        Tween(flyTogBtn, {BackgroundColor3 = T.SurfaceHi, BackgroundTransparency = 0.15}, 0.18)
        flyTogBtn.TextColor3 = T.Muted
        flyTogBtn.Text = "✈  FLY:  OFF"
    end
end)

local ncC = Section(PgFly, "🔮  NO CLIP")
Toggle(ncC, "Enable No Clip")

-- ---------- ESP ----------
local espC = Section(PgESP, "👁  PLAYER ESP")
Toggle(espC, "Enable Player ESP")

local espV2C = Section(PgESP, "👑  ESP V2  —  ADMIN ONLY")
local espLock = Lbl(espV2C, "🔒  Requires Admin login", 9, T.Warning)
espLock.Size = UDim2.new(1, 0, 0, 18)
Toggle(espV2C, "ESP V2  (HP + Dist + Team + RGB)")

local blkEspC = Section(PgESP, "🧱  BLOCK / ITEM ESP")
Toggle(blkEspC, "Highlight blocks & items")

-- ---------- TELEPORT ----------
local tpC = Section(PgTP, "🎯  TELEPORT TO PLAYER")

local tpSF = Instance.new("ScrollingFrame")
tpSF.Size = UDim2.new(1, 0, 0, 88)
tpSF.BackgroundColor3 = T.SurfaceHi
tpSF.BackgroundTransparency = 0.35
tpSF.BorderSizePixel = 0
tpSF.ScrollBarThickness = 3
tpSF.CanvasSize = UDim2.new(0, 0, 0, 0)
Round(tpSF, 7)
tpSF.Parent = tpC

local tpLL = Instance.new("UIListLayout", tpSF)
tpLL.Padding = UDim.new(0, 3)
local tpPad = Instance.new("UIPadding", tpSF)
tpPad.PaddingTop = UDim.new(0,3); tpPad.PaddingBottom = UDim.new(0,3)
tpPad.PaddingLeft = UDim.new(0,3); tpPad.PaddingRight = UDim.new(0,3)

local selectedTP = nil
local function RefreshTPList()
    for _, c in pairs(tpSF:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    local n = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            n = n + 1
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 24)
            b.BackgroundColor3 = T.Surface
            b.BackgroundTransparency = 0.2
            b.Text = "  "..p.Name
            b.TextColor3 = T.Text
            b.TextSize = 10
            b.Font = Enum.Font.Gotham
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.BorderSizePixel = 0
            b.AutoButtonColor = false
            Round(b, 5)
            b.Parent = tpSF
            b.MouseButton1Click:Connect(function()
                selectedTP = p
                for _, bb in pairs(tpSF:GetChildren()) do
                    if bb:IsA("TextButton") then Tween(bb, {BackgroundColor3 = T.Surface, BackgroundTransparency = 0.2}, 0.1) end
                end
                Tween(b, {BackgroundColor3 = T.Primary, BackgroundTransparency = 0.1}, 0.12)
            end)
        end
    end
    tpSF.CanvasSize = UDim2.new(0, 0, 0, n * 27 + 6)
end
RefreshTPList()
Players.PlayerAdded:Connect(RefreshTPList)
Players.PlayerRemoving:Connect(RefreshTPList)

Btn(tpC, "Teleport to Selected", "primary")
Toggle(tpC, "Follow Selected Player")

-- ---------- GOD ----------
local godC = Section(PgGod, "🛡  GOD MODE")

local godModes = {"Gen1  (auto-heal)", "Gen2  (invincible)", "Gen3  (max health)"}
local godModeIdx = 1
local godModeBtn = Instance.new("TextButton")
godModeBtn.Size = UDim2.new(1, 0, 0, 24)
godModeBtn.BackgroundColor3 = T.SurfaceHi
godModeBtn.BackgroundTransparency = 0.15
godModeBtn.Text = "Mode:  "..godModes[godModeIdx].."  ▸"
godModeBtn.TextColor3 = T.Text
godModeBtn.TextSize = 10
godModeBtn.Font = Enum.Font.GothamBold
godModeBtn.AutoButtonColor = false
Round(godModeBtn, 7)
godModeBtn.Parent = godC
godModeBtn.MouseButton1Click:Connect(function()
    godModeIdx = (godModeIdx % #godModes) + 1
    godModeBtn.Text = "Mode:  "..godModes[godModeIdx].."  ▸"
end)

Toggle(godC, "God Mode")
Toggle(godC, "Auto Heal")
Btn(godC, "Heal Now", "success")

-- ---------- WORLD ----------
local wC = Section(PgWorld, "🧱  BLOCK SPAWNER")
Dropdown(wC, "Block Type", {"Part","Wedge","CornerWedge","Truss","SpawnLocation"})
Dropdown(wC, "Material",   {"SmoothPlastic","Neon","Glass","Wood","Granite","Metal","ForceField"})
Dropdown(wC, "Color",      {"Red","Blue","Green","Yellow","White","Black","Pink","Orange"})
Slider(wC, "Block Size", 1, 50, 5)
Btn(wC, "🧱  Spawn Block", "primary")
Btn(wC, "🗑  Hapus Block Terakhir", "danger")
Btn(wC, "💥  Clear Semua Block", "danger")

-- ---------- AVATAR ----------
local avC = Section(PgAva, "👤  COPY AVATAR")

local avStatus = Lbl(avC, "Pilih player untuk copy tampilan.", 9, T.Muted)
avStatus.Size = UDim2.new(1, 0, 0, 16)

local avSF = Instance.new("ScrollingFrame")
avSF.Size = UDim2.new(1, 0, 0, 88)
avSF.BackgroundColor3 = T.SurfaceHi
avSF.BackgroundTransparency = 0.35
avSF.BorderSizePixel = 0
avSF.ScrollBarThickness = 3
avSF.CanvasSize = UDim2.new(0, 0, 0, 0)
Round(avSF, 7)
avSF.Parent = avC

local avLL = Instance.new("UIListLayout", avSF)
avLL.Padding = UDim.new(0, 3)
local avPad = Instance.new("UIPadding", avSF)
avPad.PaddingTop = UDim.new(0,3); avPad.PaddingBottom = UDim.new(0,3)
avPad.PaddingLeft = UDim.new(0,3); avPad.PaddingRight = UDim.new(0,3)

local function RefreshAvaList()
    for _, c in pairs(avSF:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    local n = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            n = n + 1
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 24)
            b.BackgroundColor3 = T.Surface
            b.BackgroundTransparency = 0.2
            b.Text = "  "..p.Name
            b.TextColor3 = T.Text
            b.TextSize = 10
            b.Font = Enum.Font.Gotham
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.BorderSizePixel = 0
            b.AutoButtonColor = false
            Round(b, 5)
            b.Parent = avSF
            b.MouseButton1Click:Connect(function()
                for _, bb in pairs(avSF:GetChildren()) do
                    if bb:IsA("TextButton") then Tween(bb, {BackgroundColor3 = T.Surface, BackgroundTransparency = 0.2}, 0.1) end
                end
                Tween(b, {BackgroundColor3 = T.Primary, BackgroundTransparency = 0.1}, 0.12)
            end)
        end
    end
    avSF.CanvasSize = UDim2.new(0, 0, 0, n * 27 + 6)
end
RefreshAvaList()
Players.PlayerAdded:Connect(RefreshAvaList)
Players.PlayerRemoving:Connect(RefreshAvaList)

Btn(avC, "Copy Avatar Target", "primary")
Btn(avC, "Restore Avatar Saya", "normal")

-- ---------- PRESETS ----------
local svC = Section(PgSave, "💾  PRESET SETTINGS")

local preNameBox = Instance.new("TextBox")
preNameBox.Size = UDim2.new(1, 0, 0, 26)
preNameBox.BackgroundColor3 = T.SurfaceHi
preNameBox.BackgroundTransparency = 0.15
preNameBox.PlaceholderText = "Nama preset…"
preNameBox.Text = ""
preNameBox.TextColor3 = T.Text
preNameBox.TextSize = 10
preNameBox.Font = Enum.Font.Gotham
preNameBox.ClearTextOnFocus = false
Round(preNameBox, 7)
preNameBox.Parent = svC

local preSF = Instance.new("ScrollingFrame")
preSF.Size = UDim2.new(1, 0, 0, 70)
preSF.BackgroundColor3 = T.SurfaceHi
preSF.BackgroundTransparency = 0.35
preSF.BorderSizePixel = 0
preSF.ScrollBarThickness = 3
preSF.CanvasSize = UDim2.new(0, 0, 0, 0)
Round(preSF, 7)
preSF.Parent = svC
Instance.new("UIListLayout", preSF).Padding = UDim.new(0, 3)

Btn(svC, "💾  Save Settings Sekarang", "primary")

local exportBox = Instance.new("TextBox")
exportBox.Size = UDim2.new(1, 0, 0, 44)
exportBox.BackgroundColor3 = T.NavBg
exportBox.BackgroundTransparency = 0.3
exportBox.PlaceholderText = "Kode export akan muncul di sini…"
exportBox.Text = ""
exportBox.TextColor3 = T.Primary
exportBox.TextSize = 9
exportBox.Font = Enum.Font.Code
exportBox.MultiLine = true
exportBox.TextXAlignment = Enum.TextXAlignment.Left
exportBox.TextYAlignment = Enum.TextYAlignment.Top
exportBox.ClearTextOnFocus = false
Round(exportBox, 7)
exportBox.Parent = svC

local importBox = Instance.new("TextBox")
importBox.Size = UDim2.new(1, 0, 0, 38)
importBox.BackgroundColor3 = T.NavBg
importBox.BackgroundTransparency = 0.3
importBox.PlaceholderText = "Paste kode import di sini…"
importBox.Text = ""
importBox.TextColor3 = T.Text
importBox.TextSize = 9
importBox.Font = Enum.Font.Code
importBox.MultiLine = true
importBox.TextXAlignment = Enum.TextXAlignment.Left
importBox.TextYAlignment = Enum.TextYAlignment.Top
importBox.ClearTextOnFocus = false
Round(importBox, 7)
importBox.Parent = svC

Btn(svC, "📥  Import dari Kode", "normal")

-- ---------- ADMIN ----------
local adC = Section(PgAdmin, "🔐  ADMIN LOGIN")

local adStatus = Lbl(adC, "🔒  Belum terautentikasi", 9, T.Muted)
adStatus.Size = UDim2.new(1, 0, 0, 16)

local pwBox = Instance.new("TextBox")
pwBox.Size = UDim2.new(1, 0, 0, 26)
pwBox.BackgroundColor3 = T.NavBg
pwBox.BackgroundTransparency = 0.3
pwBox.PlaceholderText = "Masukkan password…"
pwBox.Text = ""
pwBox.TextColor3 = T.Text
pwBox.TextSize = 10
pwBox.Font = Enum.Font.GothamBold
pwBox.ClearTextOnFocus = false
Round(pwBox, 7)
pwBox.Parent = adC

Btn(adC, "🔓  Unlock Admin Mode", "admin")

-- ---------- UTILITY ----------
local utC = Section(PgUtil, "⚙  UTILITIES")
Toggle(utC, "Full Bright")
Toggle(utC, "Anti-AFK")
Toggle(utC, "Unlock Camera Zoom")
Toggle(utC, "FPS Boost")

local srC = Section(PgUtil, "🌐  SERVER")
Btn(srC, "Rejoin Server", "primary")
Btn(srC, "Server Hop",    "normal")

-- ==================== ORB BUTTON (saat minimize) ====================
-- OrbBtn: ImageButton dengan logo – muncul saat window di-minimize
local OrbBtn = Instance.new("ImageButton")
OrbBtn.Size = UDim2.new(0, 46, 0, 46)
OrbBtn.Position = UDim2.new(0, 14, 0.5, -23)
OrbBtn.BackgroundColor3 = T.Primary
OrbBtn.BackgroundTransparency = 0.05
OrbBtn.Image = ""           -- diisi setelah fetch
OrbBtn.ImageTransparency = 0
OrbBtn.Visible = false
OrbBtn.ZIndex = 100
OrbBtn.Active = true
OrbBtn.Draggable = true
OrbBtn.AutoButtonColor = false
Round(OrbBtn, 23)
Stroke(OrbBtn, T.Warning, 2)
OrbBtn.Parent = SG

-- Fallback teks kalau logo belum load
local OrbFallback = Lbl(OrbBtn, "AP", 13, Color3.new(1,1,1), Enum.Font.GothamBold, Enum.TextXAlignment.Center)
OrbFallback.Size = UDim2.new(1, 0, 1, 0)
OrbFallback.ZIndex = 101

-- ==================== MINIMIZE / RESTORE / CLOSE ====================
MinBtn.MouseButton1Click:Connect(function()
    Tween(MF, {Size = UDim2.new(0, 460, 0, 0)}, 0.22, Enum.EasingStyle.Quart)
    wait(0.22)
    MF.Visible = false
    OrbBtn.Visible = true
    Tween(OrbBtn, {BackgroundTransparency = 0}, 0.2)
end)

OrbBtn.MouseButton1Click:Connect(function()
    OrbBtn.Visible = false
    MF.Visible = true
    Tween(MF, {Size = UDim2.new(0, 460, 0, 295)}, 0.35, Enum.EasingStyle.Back)
end)

CloseBtn.MouseButton1Click:Connect(function()
    Tween(MF, {Size = UDim2.new(0, 460, 0, 0), BackgroundTransparency = 1}, 0.25)
    wait(0.26)
    SG:Destroy()
end)

-- ==================== OPENING ANIMASI MAIN ====================
MF.Size = UDim2.new(0, 0, 0, 0)
GoPage("Dash")
wait(0.15)
MF.Visible = true
Tween(MF, {Size = UDim2.new(0, 460, 0, 295)}, 0.5, Enum.EasingStyle.Back)

-- ==================== FETCH IMAGES (background, non-blocking) ====================
task.spawn(function()
    local logoId = fetchImage(imageUrls.logo, "apng_logo.png")
    if logoId ~= "" then
        OrbBtn.Image = logoId
        OrbFallback.Visible = false   -- sembunyikan fallback kalau gambar berhasil
    end

    local bgId = fetchImage(imageUrls.bg, "apng_bg.jpg")
    if bgId ~= "" then
        BgImage.Image = bgId
    end
end)
