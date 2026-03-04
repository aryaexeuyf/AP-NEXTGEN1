-- AP-NEXTGEN v9.2 — FULL FIX (Menu load, BG crop, Drag, Textbox visibility)
-- Semua perbaikan: page manager robust, bg cover halus, topbar drag, orb drag, textbox visibility

-- SERVICES
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local LocalPlayer      = Players.LocalPlayer

-- SAFE GLOBAL CHECKS
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
    local ok, res = pcall(httpFunc, {Url=url, Method="GET", Headers={["User-Agent"]="Mozilla/5.0"}})
    if not ok or not res or not res.Body or #res.Body < 100 then return "" end
    if not pcall(_writefile, filename, res.Body) then return "" end
    local aOk, id = pcall(_getAsset, filename)
    return (aOk and id and id ~= "") and id or ""
end

-- THEME
local T = {
    Bg        = Color3.fromRGB(8,8,20),
    Surface   = Color3.fromRGB(18,18,38),
    SurfaceHi = Color3.fromRGB(28,28,52),
    NavBg     = Color3.fromRGB(10,10,22),
    Primary   = Color3.fromRGB(0,170,255),
    Success   = Color3.fromRGB(0,200,105),
    Warning   = Color3.fromRGB(255,198,0),
    Error     = Color3.fromRGB(255,60,70),
    Admin     = Color3.fromRGB(255,210,0),
    Text      = Color3.fromRGB(240,240,250),
    Muted     = Color3.fromRGB(130,130,165),
    Border    = Color3.fromRGB(50,50,95),
    bgTrans   = 0.40,
    sfTrans   = 0.24,
    navTrans  = 0.46,
}

-- HELPERS
local function Tween(obj, props, dur, style)
    TweenService:Create(obj, TweenInfo.new(dur or 0.2, style or Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end
local function Round(inst, r) local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 8); c.Parent = inst end
local function Stroke(inst, col, th) local s = Instance.new("UIStroke"); s.Color = col or T.Border; s.Thickness = th or 1; s.Transparency = 0.12; s.Parent = inst end
local function Lbl(parent, text, size, color, font, ax)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text or ""
    l.TextSize = size or 11
    l.TextColor3 = color or T.Text
    l.Font = font or Enum.Font.Gotham
    l.TextXAlignment = ax or Enum.TextXAlignment.Left
    l.TextTruncate = Enum.TextTruncate.AtEnd
    l.Parent = parent
    return l
end

-- ROOT GUI
local SG = Instance.new("ScreenGui")
SG.Name = "APNEXTGEN_UI"
SG.Parent = CoreGui
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.DisplayOrder = 1000

-- CONSTANTS
local TOP_H = 42
local NAV_W = 52
local WIN_W = 520  -- sedikit lebih lebar lagi sesuai request
local WIN_H = 300

-- MAIN FRAME
local MF = Instance.new("Frame")
MF.Name = "MainFrame"
MF.Size = UDim2.new(0, WIN_W, 0, WIN_H)
MF.Position = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2)
MF.BackgroundColor3 = T.Bg
MF.BackgroundTransparency = T.bgTrans
MF.BorderSizePixel = 0
MF.ClipsDescendants = true -- penting supaya bg/children ga bocor
MF.Active = true
MF.Visible = false
Round(MF, 14)
Stroke(MF, T.Primary, 1)
MF.Parent = SG

-- BACKGROUND IMAGE (cover halus: size = 1,0 agar ga over-zoom; center crop natural)
local BgImage = Instance.new("ImageLabel")
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.Position = UDim2.new(0, 0, 0, 0)
BgImage.BackgroundTransparency = 1
BgImage.Image = ""
BgImage.ScaleType = Enum.ScaleType.Crop
BgImage.ImageTransparency = 0.30
BgImage.ZIndex = 0
BgImage.Parent = MF

-- TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, TOP_H)
TopBar.BackgroundColor3 = T.Surface
TopBar.BackgroundTransparency = T.sfTrans
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 6
TopBar.Parent = MF
Round(TopBar, 14)

-- TopBar patch (clean corner overlap)
local TopPatch = Instance.new("Frame")
TopPatch.Size = UDim2.new(1,0,0,14)
TopPatch.Position = UDim2.new(0,0,1,-14)
TopPatch.BackgroundColor3 = T.Surface
TopPatch.BackgroundTransparency = T.sfTrans
TopPatch.BorderSizePixel = 0
TopPatch.ZIndex = 5
TopPatch.Parent = TopBar

-- LOGO (kotak melengkung)
local LogoSquare = Instance.new("ImageLabel")
LogoSquare.Size = UDim2.new(0,34,0,34)
LogoSquare.Position = UDim2.new(0,8,0.5,-17)
LogoSquare.BackgroundColor3 = T.SurfaceHi
LogoSquare.BackgroundTransparency = 0.06
LogoSquare.Image = ""
LogoSquare.ScaleType = Enum.ScaleType.Fit
LogoSquare.ZIndex = 7
Round(LogoSquare, 6)
Stroke(LogoSquare, T.Primary, 1)
LogoSquare.Parent = TopBar

-- AVATAR
local AvImg = Instance.new("ImageLabel")
AvImg.Size = UDim2.new(0,34,0,34)
AvImg.Position = UDim2.new(0,52,0.5,-17)
AvImg.BackgroundColor3 = T.SurfaceHi
AvImg.BackgroundTransparency = 0.18
AvImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=150&height=150&format=png"
AvImg.ZIndex = 7
Round(AvImg, 6)
Stroke(AvImg, T.Primary, 1)
AvImg.Parent = TopBar

-- NAME + VERIFIED (sedikit rapi posisi)
local NameLbl = Lbl(TopBar, LocalPlayer.Name, 12, T.Text, Enum.Font.GothamBold)
NameLbl.Size = UDim2.new(0,180,0,16)
NameLbl.Position = UDim2.new(0,92,0,6)
NameLbl.ZIndex = 7

local VerBadge = Instance.new("ImageLabel")
VerBadge.Size = UDim2.new(0,18,0,18)
VerBadge.Position = UDim2.new(0,92,0,22)
VerBadge.BackgroundTransparency = 1
VerBadge.Image = "" -- nanti diisi asset (bisa pakai fetch image asset kalau perlu)
VerBadge.ZIndex = 7
-- fallback: pake text jika image gagal
local VerTxt = Instance.new("TextLabel")
VerTxt.Size = UDim2.new(1,0,1,0)
VerTxt.BackgroundTransparency = 1
VerTxt.Text = "✔"
VerTxt.TextColor3 = T.Primary
VerTxt.Font = Enum.Font.GothamBold
VerTxt.TextSize = 12
VerTxt.TextXAlignment = Enum.TextXAlignment.Center
VerTxt.Parent = VerBadge
VerBadge.Parent = TopBar

local GameLbl = Lbl(TopBar, game.Name:sub(1,26), 9, T.Muted)
GameLbl.Size = UDim2.new(0,200,0,12)
GameLbl.Position = UDim2.new(0,120,0,22)
GameLbl.ZIndex = 7

local SrvLbl = Lbl(TopBar, "● Global  |  --/--", 9, T.Primary, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
SrvLbl.Size = UDim2.new(0,200,0,13)
SrvLbl.Position = UDim2.new(0.5,-100,0.5,-7)
SrvLbl.ZIndex = 7

-- MINIMIZE / CLOSE
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0,32,0,24)
MinBtn.Position = UDim2.new(1,-76,0.5,-12)
MinBtn.BackgroundColor3 = T.SurfaceHi
MinBtn.BackgroundTransparency = 0.12
MinBtn.Text = "-"
MinBtn.TextColor3 = T.Text
MinBtn.TextSize = 18
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BorderSizePixel = 0
MinBtn.AutoButtonColor = false
Round(MinBtn, 7)
Stroke(MinBtn, T.Border, 1)
MinBtn.ZIndex = 8
MinBtn.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,32,0,24)
CloseBtn.Position = UDim2.new(1,-40,0.5,-12)
CloseBtn.BackgroundColor3 = T.Error
CloseBtn.BackgroundTransparency = 0.1
CloseBtn.Text = "x"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.TextSize = 13
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.AutoButtonColor = false
Round(CloseBtn, 7)
CloseBtn.ZIndex = 8
CloseBtn.Parent = TopBar

-- LEFT NAV & CONTENT
local NavFrame = Instance.new("ScrollingFrame")
NavFrame.Size = UDim2.new(0, NAV_W, 1, -TOP_H)
NavFrame.Position = UDim2.new(0,0,0,TOP_H)
NavFrame.BackgroundColor3 = T.NavBg
NavFrame.BackgroundTransparency = T.navTrans
NavFrame.BorderSizePixel = 0
NavFrame.ScrollBarThickness = 0
NavFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
NavFrame.ScrollingDirection = Enum.ScrollingDirection.Y
NavFrame.ZIndex = 6
NavFrame.Parent = MF
local navLL = Instance.new("UIListLayout", NavFrame); navLL.Padding = UDim.new(0,6); navLL.HorizontalAlignment = Enum.HorizontalAlignment.Center
local navPad = Instance.new("UIPadding", NavFrame); navPad.PaddingTop = UDim.new(0,8); navPad.PaddingBottom = UDim.new(0,8)

local Div = Instance.new("Frame")
Div.Size = UDim2.new(0,1,1,-TOP_H)
Div.Position = UDim2.new(0,NAV_W,0,TOP_H)
Div.BackgroundColor3 = T.Border
Div.BackgroundTransparency = 0.2
Div.BorderSizePixel = 0
Div.ZIndex = 6
Div.Parent = MF

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -(NAV_W+1), 1, -TOP_H)
ContentArea.Position = UDim2.new(0, NAV_W+1, 0, TOP_H)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.ZIndex = 6
ContentArea.Parent = MF

-- UI HELPERS (Section, Toggle, Slider, Btn, Dropdown, StatRow, makeTextBox)
local Pages = {}
local NavBtns = {}

local function NewPage(name)
    local sf = Instance.new("ScrollingFrame")
    sf.Name = name
    sf.Size = UDim2.new(1,0,1,0)
    sf.BackgroundTransparency = 1
    sf.BorderSizePixel = 0
    sf.ScrollBarThickness = 4
    sf.ScrollBarImageColor3 = T.Primary
    sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sf.ScrollingDirection = Enum.ScrollingDirection.Y
    sf.Visible = false
    sf.Parent = ContentArea
    Instance.new("UIListLayout", sf).Padding = UDim.new(0,8)
    local pd = Instance.new("UIPadding", sf)
    pd.PaddingTop = UDim.new(0,10)
    pd.PaddingLeft = UDim.new(0,10)
    pd.PaddingRight = UDim.new(0,10)
    pd.PaddingBottom = UDim.new(0,10)
    Pages[name] = sf
    return sf
end

local function GoPage(name)
    for n, pg in pairs(Pages) do
        pg.Visible = (n == name)
    end
    for n, btn in pairs(NavBtns) do
        local ic = btn:FindFirstChild("Ic")
        local lb = btn:FindFirstChild("Lb")
        if n == name then
            Tween(btn, {BackgroundColor3 = T.Primary, BackgroundTransparency = 0.05}, 0.18)
            if ic then Tween(ic, {TextColor3 = Color3.new(1,1,1)}, 0.18) end
            if lb then Tween(lb, {TextColor3 = Color3.new(1,1,1)}, 0.18) end
        else
            Tween(btn, {BackgroundColor3 = T.NavBg, BackgroundTransparency = T.navTrans + 0.08}, 0.18)
            if ic then Tween(ic, {TextColor3 = T.Muted}, 0.18) end
            if lb then Tween(lb, {TextColor3 = T.Muted}, 0.18) end
        end
    end
end

local function NavBtn(icon, label, pageName)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, NAV_W - 6, 0, 46)
    b.BackgroundColor3 = T.NavBg
    b.BackgroundTransparency = T.navTrans + 0.08
    b.Text = ""
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    Round(b, 8)
    b.Parent = NavFrame

    local ic = Instance.new("TextLabel")
    ic.Name = "Ic"
    ic.Size = UDim2.new(1, 0, 0, 24)
    ic.Position = UDim2.new(0, 0, 0, 4)
    ic.BackgroundTransparency = 1
    ic.Text = icon
    ic.TextSize = 16
    ic.Font = Enum.Font.GothamBold
    ic.TextColor3 = T.Muted
    ic.TextXAlignment = Enum.TextXAlignment.Center
    ic.ZIndex = 7
    ic.Parent = b

    local lb = Instance.new("TextLabel")
    lb.Name = "Lb"
    lb.Size = UDim2.new(1, 0, 0, 12)
    lb.Position = UDim2.new(0, 0, 0, 28)
    lb.BackgroundTransparency = 1
    lb.Text = label
    lb.TextSize = 8
    lb.Font = Enum.Font.GothamBold
    lb.TextColor3 = T.Muted
    lb.TextXAlignment = Enum.TextXAlignment.Center
    lb.ZIndex = 7
    lb.Parent = b

    NavBtns[pageName] = b
    b.MouseButton1Click:Connect(function()
        GoPage(pageName)
    end)
    return b
end

local function Section(parent, title)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = T.Surface
    card.BackgroundTransparency = T.sfTrans
    card.BorderSizePixel = 0
    Round(card, 10)
    Stroke(card, T.Border, 0.9)
    card.Parent = parent

    local ttl = Lbl(card, title, 11, T.Primary, Enum.Font.GothamBold)
    ttl.Size = UDim2.new(1, -16, 0, 22)
    ttl.Position = UDim2.new(0, 12, 0, 6)

    local ln = Instance.new("Frame")
    ln.Size = UDim2.new(1, -16, 0, 1)
    ln.Position = UDim2.new(0, 8, 0, 30)
    ln.BackgroundColor3 = T.Border
    ln.BackgroundTransparency = 0.28
    ln.BorderSizePixel = 0
    ln.Parent = card

    local cont = Instance.new("Frame")
    cont.Name = "Cont"
    cont.Size = UDim2.new(1, -16, 0, 0)
    cont.Position = UDim2.new(0, 8, 0, 34)
    cont.AutomaticSize = Enum.AutomaticSize.Y
    cont.BackgroundTransparency = 1
    cont.Parent = card
    Instance.new("UIListLayout", cont).Padding = UDim.new(0, 8)
    Instance.new("UIPadding", card).PaddingBottom = UDim.new(0, 8)
    return cont
end

local function makeTextBox(props)
    local tb = Instance.new("TextBox")
    tb.BackgroundColor3 = props.bg or T.SurfaceHi
    tb.BackgroundTransparency = (props.transparency ~= nil) and props.transparency or 0.06
    tb.PlaceholderText = props.placeholder or ""
    tb.Text = props.text or ""
    tb.TextColor3 = props.textColor or T.Text
    tb.TextSize = props.textSize or 11
    tb.Font = props.font or Enum.Font.Gotham
    tb.ClearTextOnFocus = false
    tb.TextXAlignment = props.align or Enum.TextXAlignment.Left
    Round(tb, props.radius or 8)
    return tb
end

local function Toggle(parent, text, cb)
    local row = Instance.new("Frame"); row.Size = UDim2.new(1,0,0,28); row.BackgroundTransparency = 1; row.Parent = parent
    local lbl = Lbl(row, text, 11, T.Text); lbl.Size = UDim2.new(1,-70,1,0)
    local track = Instance.new("Frame"); track.Size = UDim2.new(0,44,0,18); track.Position = UDim2.new(1,-48,0.5,-9); track.BackgroundColor3 = T.SurfaceHi; Round(track,10); Stroke(track,T.Border,1); track.Parent = row
    local knob = Instance.new("Frame"); knob.Size = UDim2.new(0,16,0,16); knob.Position = UDim2.new(0,4,0.5,-8); Round(knob,8); knob.BackgroundColor3 = T.Muted; knob.Parent = track
    local on = false
    local hit = Instance.new("TextButton"); hit.Size = UDim2.new(1,0,1,0); hit.BackgroundTransparency = 1; hit.Text = ""; hit.Parent = track
    hit.MouseButton1Click:Connect(function()
        on = not on
        if on then Tween(track, {BackgroundColor3 = T.Success}, 0.16); Tween(knob, {Position = UDim2.new(0,28,0.5,-8), BackgroundColor3 = Color3.new(1,1,1)}, 0.16)
        else Tween(track, {BackgroundColor3 = T.SurfaceHi}, 0.16); Tween(knob, {Position = UDim2.new(0,4,0.5,-8), BackgroundColor3 = T.Muted}, 0.16) end
        if cb then cb(on) end
    end)
    return hit
end

local function Slider(parent, label, sMin, sMax, default, cb)
    local frame = Instance.new("Frame"); frame.Size = UDim2.new(1,0,0,42); frame.BackgroundTransparency = 1; frame.Parent = parent
    local lbl = Lbl(frame, label, 10, T.Text); lbl.Size = UDim2.new(0.6,0,0,16)
    local vbox = Instance.new("TextBox"); vbox.Size = UDim2.new(0,48,0,18); vbox.Position = UDim2.new(1,-48,0,0); vbox.BackgroundColor3 = T.SurfaceHi; vbox.BackgroundTransparency = 0.08; vbox.Text = tostring(default); vbox.TextColor3 = T.Text; vbox.TextSize = 10; vbox.Font = Enum.Font.GothamBold; vbox.ClearTextOnFocus = false; vbox.TextXAlignment = Enum.TextXAlignment.Center; Round(vbox,6); vbox.Parent = frame
    local track = Instance.new("Frame"); track.Size = UDim2.new(1,0,0,6); track.Position = UDim2.new(0,0,0,22); track.BackgroundColor3 = T.SurfaceHi; track.BackgroundTransparency = 0.12; Round(track,4); track.Parent = frame
    local pct = (default - sMin) / math.max(sMax - sMin, 1)
    local fill = Instance.new("Frame"); fill.Size = UDim2.new(pct,0,1,0); fill.BackgroundColor3 = T.Primary; Round(fill,4); fill.Parent = track
    local knob = Instance.new("Frame"); knob.Size = UDim2.new(0,14,0,14); knob.Position = UDim2.new(pct, -7, 0.5, -7); knob.BackgroundColor3 = Color3.new(1,1,1); Round(knob,8); knob.Parent = track
    local dragging = false
    local function doUpdate(input)
        local p = math.clamp((input.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
        local v = math.floor(sMin + (sMax - sMin) * p)
        vbox.Text = tostring(v)
        fill.Size = UDim2.new(p, 0, 1, 0)
        knob.Position = UDim2.new(p, -7, 0.5, -7)
        if cb then cb(v) end
    end
    track.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; doUpdate(i) end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then doUpdate(i) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    vbox.FocusLost:Connect(function() local v = math.clamp(tonumber(vbox.Text) or default, sMin, sMax); vbox.Text = tostring(v); local p = (v - sMin) / math.max(sMax - sMin, 1); fill.Size = UDim2.new(p, 0, 1, 0); knob.Position = UDim2.new(p, -7, 0.5, -7); if cb then cb(v) end end)
    return frame
end

local function Btn(parent, text, style, cb)
    local col = (style == "primary" and T.Primary) or (style == "success" and T.Success) or (style == "danger" and T.Error) or (style == "admin" and T.Admin) or T.SurfaceHi
    local tcol = (style == "admin" and Color3.new(0,0,0)) or Color3.new(1,1,1)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,0,0,28)
    b.BackgroundColor3 = col
    b.BackgroundTransparency = 0.14
    b.Text = text
    b.TextColor3 = tcol
    b.TextSize = 11
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    Round(b, 8)
    b.Parent = parent
    b.MouseEnter:Connect(function() Tween(b, {BackgroundTransparency = 0}, 0.12) end)
    b.MouseLeave:Connect(function() Tween(b, {BackgroundTransparency = 0.14}, 0.12) end)
    b.MouseButton1Click:Connect(function() Tween(b, {BackgroundColor3 = col:Lerp(Color3.new(1,1,1), 0.12)}, 0.06); task.delay(0.1, function() Tween(b, {BackgroundColor3 = col}, 0.1) end); if cb then cb() end end)
    return b
end

local function Dropdown(parent, labelTxt, opts)
    local frame = Instance.new("Frame"); frame.Size = UDim2.new(1,0,0,0); frame.AutomaticSize = Enum.AutomaticSize.Y; frame.BackgroundTransparency = 1; frame.Parent = parent
    local row = Instance.new("TextButton"); row.Size = UDim2.new(1,0,0,28); row.BackgroundColor3 = T.SurfaceHi; row.BackgroundTransparency = 0.12; row.Text = labelTxt..":  "..opts[1].."  ▾"; row.TextColor3 = T.Text; row.TextSize = 11; row.Font = Enum.Font.GothamBold; row.AutoButtonColor = false; Round(row, 8); row.Parent = frame
    local list = Instance.new("Frame"); list.Size = UDim2.new(1,0,0,0); list.Position = UDim2.new(0,0,0,32); list.BackgroundColor3 = T.Surface; list.BackgroundTransparency = 0.06; list.ClipsDescendants = true; list.ZIndex = 20; Round(list, 8); Stroke(list, T.Border, 1); list.Parent = frame
    Instance.new("UIListLayout", list)
    local open = false
    for _, opt in ipairs(opts) do
        local ob = Instance.new("TextButton")
        ob.Size = UDim2.new(1,0,0,28)
        ob.BackgroundColor3 = T.Surface
        ob.BackgroundTransparency = 0.08
        ob.Text = "   "..opt
        ob.TextColor3 = T.Text
        ob.TextSize = 11
        ob.Font = Enum.Font.Gotham
        ob.TextXAlignment = Enum.TextXAlignment.Left
        ob.BorderSizePixel = 0
        ob.AutoButtonColor = false
        ob.Parent = list
        ob.MouseButton1Click:Connect(function()
            row.Text = labelTxt..":  "..opt.."  ▾"
            open = false
            Tween(list, {Size = UDim2.new(1,0,0,0)}, 0.15)
        end)
    end
    row.MouseButton1Click:Connect(function()
        open = not open
        Tween(list, {Size = UDim2.new(1,0,0, open and #opts*28 or 0)}, 0.18)
    end)
    return frame
end

local function StatRow(parent, lTxt, vTxt, vCol)
    local row = Instance.new("Frame"); row.Size = UDim2.new(1,0,0,18); row.BackgroundTransparency = 1; row.Parent = parent
    local l = Lbl(row, lTxt, 9, T.Muted); l.Size = UDim2.new(0.5,0,1,0)
    local v = Lbl(row, vTxt, 9, vCol or T.Primary, Enum.Font.GothamBold, Enum.TextXAlignment.Right); v.Size = UDim2.new(0.5,0,1,0); v.Position = UDim2.new(0.5,0,0,0)
    return v
end

-- CREATE PAGES (first)
NavBtn("📊","DASH","Dash"); NewPage("Dash")
NavBtn("🏃","MOVE","Move"); NewPage("Move")
NavBtn("✈️","FLY","Fly");  NewPage("Fly")
NavBtn("👁️","ESP","ESP");  NewPage("ESP")
NavBtn("🎯","TP","TP");    NewPage("TP")
NavBtn("🛡️","GOD","God");  NewPage("God")
NavBtn("🧱","WORLD","World"); NewPage("World")
NavBtn("👤","AVA","Ava");  NewPage("Ava")
NavBtn("💾","SAVE","Save"); NewPage("Save")
NavBtn("🔐","ADMIN","Admin"); NewPage("Admin")
NavBtn("⚙️","UTIL","Util"); NewPage("Util")

-- FILL PAGES (example: Dash, Move, Save, Admin) — keep concise but functional

-- DASH
local dsC = Section(Pages["Dash"], "SERVER MONITOR")
local plrC = Section(Pages["Dash"], "PLAYER INFO")
StatRow(dsC, "Game Name:", game.Name:sub(1,24), T.Primary)
StatRow(dsC, "Place ID:", tostring(game.PlaceId), T.Warning)
StatRow(dsC, "Job ID:", tostring(game.JobId):sub(1,14).."...", T.Muted)
local sPly = StatRow(dsC, "Players:", "--/--", T.Success)
StatRow(plrC, "Username:", LocalPlayer.Name, T.Primary)
StatRow(plrC, "User ID:", tostring(LocalPlayer.UserId), T.Muted)
StatRow(plrC, "Display Name:", LocalPlayer.DisplayName, T.Text)
StatRow(plrC, "Team:", "None", T.Warning)

-- MOVE
local mvC = Section(Pages["Move"], "SPEED & JUMP")
Slider(mvC, "Walk Speed", 1, 500, 16)
Slider(mvC, "Jump Power", 1, 500, 50)
Btn(mvC, "Reset to Default", "normal")

-- SAVE (textbox styles fixed)
local svC = Section(Pages["Save"], "PRESET SETTINGS")
local preBox = makeTextBox{placeholder="Nama preset...", transparency=0.06, textColor=T.Text, textSize=11}
preBox.Size = UDim2.new(1,0,0,28); preBox.Parent = svC
local preSF = Instance.new("ScrollingFrame"); preSF.Size = UDim2.new(1,0,0,72); preSF.BackgroundColor3 = T.SurfaceHi; preSF.BackgroundTransparency = 0.28; preSF.BorderSizePixel = 0; preSF.ScrollBarThickness = 3; preSF.AutomaticCanvasSize = Enum.AutomaticSize.Y; Round(preSF, 8); preSF.Parent = svC
Instance.new("UIListLayout", preSF).Padding = UDim.new(0,6)
Btn(svC, "Save Settings Sekarang", "primary")
local exportBox = makeTextBox{placeholder="Export code akan muncul di sini...", transparency=0.12, textColor=T.Primary, textSize=10, font=Enum.Font.Code}
exportBox.Size = UDim2.new(1,0,0,46); exportBox.MultiLine = true; Round(exportBox, 8); exportBox.Parent = svC
local importBox = makeTextBox{placeholder="Paste kode import di sini...", transparency=0.12, textColor=T.Text, textSize=10, font=Enum.Font.Code}
importBox.Size = UDim2.new(1,0,0,40); importBox.MultiLine = true; Round(importBox, 8); importBox.Parent = svC

-- ADMIN
local adC = Section(Pages["Admin"], "ADMIN LOGIN")
local adStatus = Lbl(adC, "Belum terautentikasi", 9, T.Muted); adStatus.Size = UDim2.new(1,0,0,16)
local pwBox = makeTextBox{placeholder="Masukkan password...", transparency=0.10, textColor=T.Text}
pwBox.Size = UDim2.new(1,0,0,28); Round(pwBox,8); pwBox.Parent = adC
Btn(adC, "Unlock Admin Mode", "admin")

-- UTIL
local utC = Section(Pages["Util"], "UTILITIES")
Toggle(utC, "Full Bright")
Toggle(utC, "Anti-AFK")
Toggle(utC, "Unlock Camera Zoom")
Toggle(utC, "FPS Boost")
local srC = Section(Pages["Util"], "SERVER")
Btn(srC, "Rejoin Server", "primary")
Btn(srC, "Server Hop", "normal")

-- ORB (restore) and manual drag
local OrbBtn = Instance.new("ImageButton")
OrbBtn.Size = UDim2.new(0,48,0,48)
OrbBtn.Position = UDim2.new(0,14,0.5,-24)
OrbBtn.BackgroundColor3 = T.Primary
OrbBtn.BackgroundTransparency = 0.05
OrbBtn.Image = ""
OrbBtn.Visible = false
OrbBtn.ZIndex = 110
OrbBtn.Active = true
OrbBtn.AutoButtonColor = false
Round(OrbBtn, 12); Stroke(OrbBtn, T.Warning, 1.8)
OrbBtn.Parent = SG
local OrbFb = Lbl(OrbBtn, "AP", 12, Color3.new(1,1,1), Enum.Font.GothamBold, Enum.TextXAlignment.Center)
OrbFb.Size = UDim2.new(1,0,1,0); OrbFb.ZIndex = 111; OrbFb.Parent = OrbBtn

do
    local dragging = false
    local startPos, orbStart
    OrbBtn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = i.Position
            orbStart = OrbBtn.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - startPos
            OrbBtn.Position = UDim2.new(orbStart.X.Scale, orbStart.X.Offset + delta.X, orbStart.Y.Scale, orbStart.Y.Offset + delta.Y)
        end
    end)
end

-- MINIMIZE / RESTORE / CLOSE logic
MinBtn.MouseButton1Click:Connect(function()
    Tween(MF, {Size = UDim2.new(0, WIN_W, 0, 0)}, 0.18)
    task.delay(0.18, function() MF.Visible = false; OrbBtn.Visible = true end)
end)
OrbBtn.MouseButton1Click:Connect(function()
    OrbBtn.Visible = false
    MF.Visible = true
    Tween(MF, {Size = UDim2.new(0, WIN_W, 0, WIN_H)}, 0.34, Enum.EasingStyle.Back)
end)
CloseBtn.MouseButton1Click:Connect(function()
    Tween(MF, {Size = UDim2.new(0, WIN_W, 0, 0), BackgroundTransparency = 1}, 0.18)
    task.delay(0.20, function() SG:Destroy() end)
end)

-- TOPBAR DRAG (robust)
do
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MF.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and dragInput and input == dragInput then
            local delta = input.Position - dragStart
            MF.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- SERVER INFO UPDATER
task.spawn(function()
    while SG and SG.Parent do
        local pc, mp = #Players:GetPlayers(), 0
        pcall(function() mp = Players.MaxPlayers end)
        SrvLbl.Text = "● Global  |  "..pc.."/"..mp
        GameLbl.Text = game.Name:sub(1,26)
        task.wait(4)
    end
end)

-- OPENING (typewriter + mild pulse + color shift)
task.spawn(function()
    local OF = Instance.new("Frame")
    OF.Size = UDim2.new(1,0,1,0)
    OF.BackgroundColor3 = T.Bg
    OF.BackgroundTransparency = 0.60
    OF.ZIndex = 200
    OF.Parent = SG

    local OBg = Instance.new("ImageLabel")
    OBg.Size = UDim2.new(1,0,1,0)
    OBg.BackgroundTransparency = 1
    OBg.Image = ""
    OBg.ImageTransparency = 0.7
    OBg.ZIndex = 199
    OBg.Parent = OF

    local OT = Instance.new("TextLabel")
    OT.Size = UDim2.new(0, 480, 0, 80)
    OT.Position = UDim2.new(0.5, -240, 0.45, -40)
    OT.BackgroundTransparency = 1
    OT.Text = ""
    OT.TextColor3 = T.Primary
    OT.TextSize = 46
    OT.Font = Enum.Font.GothamBlack
    OT.TextXAlignment = Enum.TextXAlignment.Center
    OT.ZIndex = 201
    OT.Parent = OF

    local OS = Instance.new("TextLabel")
    OS.Size = UDim2.new(0, 320, 0, 28)
    OS.Position = UDim2.new(0.5, -160, 0.55, 12)
    OS.BackgroundTransparency = 1
    OS.Text = "by  A P T E C H"
    OS.TextColor3 = T.Warning
    OS.TextSize = 16
    OS.Font = Enum.Font.Gotham
    OS.TextXAlignment = Enum.TextXAlignment.Center
    OS.TextTransparency = 0.6
    OS.ZIndex = 201
    OS.Parent = OF

    local OL = Instance.new("Frame")
    OL.Size = UDim2.new(0, 0, 0, 3)
    OL.Position = UDim2.new(0.5, 0, 0.5, 14)
    OL.BackgroundColor3 = T.Primary
    OL.BackgroundTransparency = 0.4
    OL.ZIndex = 201
    OL.Parent = OF

    local title = "AP-NEXTGEN"
    for i = 1, #title do
        OT.Text = title:sub(1, i)
        task.wait(0.035)
    end

    Tween(OT, {TextSize = 50}, 0.22, Enum.EasingStyle.Sine)
    task.wait(0.12)
    Tween(OT, {TextSize = 46}, 0.18, Enum.EasingStyle.Sine)

    Tween(OL, {Size = UDim2.new(0, 360, 0, 3), Position = UDim2.new(0.5, -180, 0.5, 14)}, 0.6, Enum.EasingStyle.Quint)
    task.wait(0.2)
    Tween(OS, {TextTransparency = 0}, 0.5, Enum.EasingStyle.Quint)

    Tween(OT, {TextColor3 = T.Primary:Lerp(T.Success, 0.28)}, 0.45, Enum.EasingStyle.Sine)
    task.wait(0.9)
    Tween(OT, {TextColor3 = T.Primary}, 0.35, Enum.EasingStyle.Sine)

    Tween(OF, {BackgroundTransparency = 1}, 0.45)
    Tween(OT, {TextTransparency = 1}, 0.35)
    Tween(OS, {TextTransparency = 1}, 0.35)
    task.wait(0.45)
    OF:Destroy()

    GoPage("Dash")
    MF.Size = UDim2.new(0, 0, 0, 0)
    MF.Visible = true
    Tween(MF, {Size = UDim2.new(0, WIN_W, 0, WIN_H)}, 0.42, Enum.EasingStyle.Back)
end)

-- FETCH images (logo + bg) non-blocking
task.spawn(function()
    local logoId = fetchImage(imageUrls.logo, "apng_logo.png")
    if logoId ~= "" then
        LogoSquare.Image = logoId
        OrbBtn.Image = logoId
        OrbFb.Visible = false
        -- try to set a tiny verif badge asset if available (optional)
    end
    local bgId = fetchImage(imageUrls.bg, "apng_bg.jpg")
    if bgId ~= "" then
        BgImage.Image = bgId
        BgImage.ImageTransparency = 0.30
    end
end)

-- ensure default page visible (safety)
task.spawn(function()
    task.wait(0.2)
    if Pages["Dash"] then GoPage("Dash") end
end)
