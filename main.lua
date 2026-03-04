--[[
    AP-NEXTGEN v9.1 – UI SHELL (EDIT MODE) – ENHANCED & FIXED
    Tema: Biru & Kuning Transparan
    - Perbaikan icon (fallback teks jika gambar gagal dimuat)
    - Slider lebih presisi
    - Dropdown auto-close saat klik di luar
    - Drag lebih halus
    - Tata letak lebih rapi & responsif
    - Semua bug minor diperbaiki
]]

-- Services
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local ContentProvider  = game:GetService("ContentProvider")

local LocalPlayer = Players.LocalPlayer

-- ==================== LOAD IMAGE DARI GITHUB (DENGAN FALLBACK) ====================
local imageUrls = {
    logo = "https://raw.githubusercontent.com/aryaexeuyf/Image/main/logo_g1.png",
    bg   = "https://raw.githubusercontent.com/aryaexeuyf/Image/main/background.jpg"
}

-- Deteksi fungsi HTTP executor
local httpFunc = (syn and syn.request) or http_request or (http and http.request) or request
local getAsset = getcustomasset or getsynasset
local writeFile = writefile -- pastikan fungsi ini ada

-- Fungsi fetch dengan fallback
local function fetchImage(url, filename)
    if not (httpFunc and writeFile and getAsset) then return "" end
    local success, res = pcall(httpFunc, {
        Url = url, Method = "GET",
        Headers = { ["User-Agent"] = "Mozilla/5.0" }
    })
    if not (success and res and res.Body and #res.Body > 100) then return "" end
    local writeSuccess = pcall(writeFile, filename, res.Body)
    if not writeSuccess then return "" end
    local assetSuccess, assetId = pcall(getAsset, filename)
    return (assetSuccess and assetId and assetId ~= "") and assetId or ""
end

-- ==================== THEME ====================
local T = {
    Bg        = Color3.fromRGB(0, 0, 0),
    Surface   = Color3.fromRGB(20, 20, 40),
    SurfaceHi = Color3.fromRGB(35, 35, 60),
    NavBg     = Color3.fromRGB(10, 10, 25),
    Primary   = Color3.fromRGB(0, 170, 255),
    Success   = Color3.fromRGB(0, 210, 110),
    Warning   = Color3.fromRGB(255, 200, 0),
    Error     = Color3.fromRGB(255, 70, 80),
    Admin     = Color3.fromRGB(255, 210, 0),
    Text      = Color3.fromRGB(245, 245, 255),
    Muted     = Color3.fromRGB(160, 160, 190),
    Border    = Color3.fromRGB(70, 70, 120),

    bgTrans   = 0.45,
    surfTrans = 0.3,
    navTrans  = 0.5,
    btnTrans  = 0.2,
}

-- ==================== HELPERS ====================
local function Tween(obj, props, dur, style)
    TweenService:Create(obj, TweenInfo.new(dur or 0.22, style or Enum.EasingStyle.Quart), props):Play()
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
    s.Parent = inst
    return s
end

local function Lbl(parent, text, size, color, font, align)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextSize = size or 11
    l.TextColor3 = color or T.Text
    l.Font = font or Enum.Font.Gotham
    l.TextXAlignment = align or Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

local function FallbackIcon(btn, fallbackText)
    -- Jika gambar gagal dimuat, ganti dengan teks fallback
    btn:GetPropertyChangedSignal("Image"):Connect(function()
        if btn.Image == "" then
            btn.Text = fallbackText
            btn.TextSize = 20
            btn.TextColor3 = T.Primary
            btn.Font = Enum.Font.GothamBold
        else
            btn.Text = ""
        end
    end)
    if btn.Image == "" then
        btn.Text = fallbackText
        btn.TextSize = 20
        btn.TextColor3 = T.Primary
        btn.Font = Enum.Font.GothamBold
    end
end

-- ==================== SCREENGUI ====================
-- Hapus semua dari mulai OpeningFrame sampai task.spawn fetch, lalu ganti dengan:
local SG = Instance.new("ScreenGui")
SG.Name = "APNEXTGEN_UI"
SG.Parent = LocalPlayer:WaitForChild("PlayerGui")  -- Gunakan PlayerGui, bukan CoreGui
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.DisplayOrder = 100

-- Buat MainFrame langsung dengan ukuran penuh
local MF = Instance.new("Frame")
MF.Name = "MainFrame"
MF.Size = UDim2.new(0, 450, 0, 290)
MF.Position = UDim2.new(0.5, -225, 0.5, -145)
MF.BackgroundColor3 = Color3.fromRGB(0,0,0)
MF.BackgroundTransparency = 0.45
MF.BorderSizePixel = 0
MF.ClipsDescendants = true
MF.Active = true
MF.Visible = true
Instance.new("UICorner", MF).CornerRadius = UDim.new(0,16)
MF.Parent = SG

-- Tambahkan label sederhana untuk test
local testLabel = Instance.new("TextLabel", MF)
testLabel.Size = UDim2.new(1,0,1,0)
testLabel.Text = "UI BERHASIL DIMUAT"
testLabel.TextColor3 = Color3.new(1,1,1)
testLabel.BackgroundTransparency = 1
testLabel.TextSize = 20

local OpenCredit = Instance.new("TextLabel")
OpenCredit.Size = UDim2.new(0, 400, 0, 60)
OpenCredit.Position = UDim2.new(0.5, -200, 0.5, 30)
OpenCredit.BackgroundTransparency = 1
OpenCredit.Text = "By APTECH"
OpenCredit.TextColor3 = T.Warning
OpenCredit.TextSize = 40
OpenCredit.Font = Enum.Font.Gotham
OpenCredit.TextXAlignment = Enum.TextXAlignment.Center
OpenCredit.TextYAlignment = Enum.TextYAlignment.Center
OpenCredit.TextTransparency = 1
OpenCredit.Parent = OpeningFrame

Tween(OpenTitle, {TextTransparency = 0}, 1.2, Enum.EasingStyle.Quint)
Tween(OpenCredit, {TextTransparency = 0}, 1.2, Enum.EasingStyle.Quint)

task.wait(2.2)

Tween(OpeningFrame, {BackgroundTransparency = 1}, 0.8)
Tween(OpenTitle, {TextTransparency = 1}, 0.6)
Tween(OpenCredit, {TextTransparency = 1}, 0.6)

task.wait(0.8)
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
Round(MF, 16)
Stroke(MF, T.Primary, 1.2)
MF.Parent = SG

-- Background image (fallback jika gagal)
local BgImage = Instance.new("ImageLabel")
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.BackgroundColor3 = T.Surface
BgImage.BackgroundTransparency = 0.2
BgImage.Image = ""
BgImage.ScaleType = Enum.ScaleType.Crop
BgImage.ImageTransparency = 0.2
BgImage.ZIndex = 0
BgImage.Parent = MF

-- Fallback jika background gagal dimuat
BgImage:GetPropertyChangedSignal("Image"):Connect(function()
    if BgImage.Image == "" then
        BgImage.BackgroundTransparency = 0.2
        BgImage.BackgroundColor3 = T.Surface
    else
        BgImage.BackgroundTransparency = 1
    end
end)

-- ==================== TOP BAR ====================
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = T.Surface
TopBar.BackgroundTransparency = T.surfTrans
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 5
Round(TopBar, 16)
TopBar.Parent = MF

local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 12)
TopFix.Position = UDim2.new(0, 0, 1, -12)
TopFix.BackgroundColor3 = T.Surface
TopFix.BackgroundTransparency = T.surfTrans
TopFix.BorderSizePixel = 0
TopFix.ZIndex = 4
TopFix.Parent = TopBar

-- Avatar foto profil
local AvImg = Instance.new("ImageLabel")
AvImg.Size = UDim2.new(0, 30, 0, 30)
AvImg.Position = UDim2.new(0, 6, 0.5, -15)
AvImg.BackgroundColor3 = T.SurfaceHi
AvImg.BackgroundTransparency = T.surfTrans
AvImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=150&height=150&format=png"
AvImg.ZIndex = 6
Round(AvImg, 15)
Stroke(AvImg, T.Primary, 1)
AvImg.Parent = TopBar

-- Nama user
local NameLbl = Lbl(TopBar, LocalPlayer.Name, 12, T.Text, Enum.Font.GothamBold)
NameLbl.Size = UDim2.new(0, 100, 0, 16)
NameLbl.Position = UDim2.new(0, 42, 0, 4)
NameLbl.ZIndex = 6
NameLbl.TextTruncate = Enum.TextTruncate.AtEnd

-- Info game kecil di bawah nama
local GameLbl = Lbl(TopBar, game.Name:sub(1,14), 9, T.Muted)
GameLbl.Size = UDim2.new(0, 100, 0, 14)
GameLbl.Position = UDim2.new(0, 42, 0, 22)
GameLbl.ZIndex = 6
GameLbl.TextTruncate = Enum.TextTruncate.AtEnd

-- Server info tengah
local SrvLbl = Lbl(TopBar, "🌐 Global | ID:... | --/--", 10, T.Primary, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
SrvLbl.Size = UDim2.new(0, 210, 0, 16)
SrvLbl.Position = UDim2.new(0.5, -105, 0.5, -8)
SrvLbl.ZIndex = 6
SrvLbl.TextTruncate = Enum.TextTruncate.AtEnd

-- Tombol minimize (ImageButton) dengan fallback teks
local MinBtn = Instance.new("ImageButton")
MinBtn.Size = UDim2.new(0, 34, 0, 34)
MinBtn.Position = UDim2.new(1, -76, 0.5, -17)
MinBtn.BackgroundColor3 = T.SurfaceHi
MinBtn.BackgroundTransparency = 0.2
MinBtn.Image = ""
MinBtn.ZIndex = 7
MinBtn.AutoButtonColor = false
Round(MinBtn, 10)
Stroke(MinBtn, T.Primary, 1)
MinBtn.Parent = TopBar
FallbackIcon(MinBtn, "🗕")  -- fallback icon minimize

-- Tombol close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 34, 0, 34)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -17)
CloseBtn.BackgroundColor3 = T.Error
CloseBtn.BackgroundTransparency = 0.1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 7
CloseBtn.AutoButtonColor = false
Round(CloseBtn, 10)
Stroke(CloseBtn, T.Border, 1)
CloseBtn.Parent = TopBar

-- ==================== SERVER INFO UPDATER ====================
task.spawn(function()
    while SrvLbl and SrvLbl.Parent do
        local pc = #Players:GetPlayers()
        local mp = 0
        pcall(function() mp = Players.MaxPlayers end)
        GameLbl.Text = game.Name:sub(1, 14)
        SrvLbl.Text = "🌐 Global | ID:"..tostring(game.PlaceId):sub(1,9).." | "..pc.."/"..mp
        task.wait(5)
    end
end)

-- ==================== DRAG TOPBAR (DIPERBAIKI) ====================
local dragging = false
local dragStart, startPos

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

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MF.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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
NavFrame.ZIndex = 2
NavFrame.Parent = MF

local NavLL = Instance.new("UIListLayout")
NavLL.Padding = UDim.new(0, 4)
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
Div.BackgroundTransparency = 0.3
Div.BorderSizePixel = 0
Div.ZIndex = 2
Div.Parent = MF

-- ==================== CONTENT AREA ====================
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -57, 1, -40)
ContentArea.Position = UDim2.new(0, 57, 0, 40)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.ZIndex = 2
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
    sf.ScrollingDirection = Enum.ScrollingDirection.Y
    sf.Visible = false
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
        pg.Visible = (n == name)
    end
    for n, btn in pairs(NavBtns) do
        if n == name then
            Tween(btn, {BackgroundColor3 = T.Primary, BackgroundTransparency = 0.1}, 0.2)
            Tween(btn, {TextColor3 = Color3.new(1,1,1)}, 0.2)
        else
            Tween(btn, {BackgroundColor3 = T.NavBg, BackgroundTransparency = T.navTrans}, 0.2)
            Tween(btn, {TextColor3 = T.Muted}, 0.2)
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
    b.TextSize = 18
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    Round(b, 10)
    b.Parent = NavFrame
    NavBtns[pageName] = b
    b.MouseButton1Click:Connect(function() GoPage(pageName) end)
    return b
end

-- ==================== UI COMPONENT BUILDERS (DIPERBAIKI) ====================
local function Section(parent, title)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = T.Surface
    card.BackgroundTransparency = T.surfTrans
    card.BorderSizePixel = 0
    Round(card, 10)
    card.Parent = parent

    local ttl = Lbl(card, title, 12, T.Primary, Enum.Font.GothamBold)
    ttl.Size = UDim2.new(1, -16, 0, 24)
    ttl.Position = UDim2.new(0, 8, 0, 4)

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, -16, 0, 1)
    line.Position = UDim2.new(0, 8, 0, 28)
    line.BackgroundColor3 = T.Border
    line.BackgroundTransparency = 0.4
    line.BorderSizePixel = 0
    line.Parent = card

    local cont = Instance.new("Frame")
    cont.Name = "Cont"
    cont.Size = UDim2.new(1, -16, 0, 0)
    cont.Position = UDim2.new(0, 8, 0, 32)
    cont.AutomaticSize = Enum.AutomaticSize.Y
    cont.BackgroundTransparency = 1
    cont.Parent = card

    local cL = Instance.new("UIListLayout")
    cL.Padding = UDim.new(0, 6)
    cL.Parent = cont

    local cP = Instance.new("UIPadding")
    cP.PaddingBottom = UDim.new(0, 6)
    cP.Parent = card

    return cont
end

local function Toggle(parent, text, _callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 28)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local lbl = Lbl(row, text, 11, T.Text)
    lbl.Size = UDim2.new(0.7, 0, 1, 0)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 46, 0, 20)
    btn.Position = UDim2.new(1, -46, 0.5, -10)
    btn.BackgroundColor3 = T.SurfaceHi
    btn.BackgroundTransparency = 0.2
    btn.Text = "OFF"
    btn.TextColor3 = T.Muted
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    Round(btn, 10)
    btn.Parent = row

    local on = false
    btn.MouseButton1Click:Connect(function()
        on = not on
        btn.Text = on and "ON" or "OFF"
        Tween(btn, {BackgroundColor3 = on and T.Success or T.SurfaceHi, BackgroundTransparency = 0.1}, 0.18)
        Tween(btn, {TextColor3 = on and Color3.new(1,1,1) or T.Muted}, 0.18)
        if _callback then _callback(on) end
    end)
    return btn
end

local function Slider(parent, text, min, max, default, _callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 44)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local topRow = Instance.new("Frame")
    topRow.Size = UDim2.new(1, 0, 0, 18)
    topRow.BackgroundTransparency = 1
    topRow.Parent = frame

    local lbl = Lbl(topRow, text, 11, T.Text)
    lbl.Size = UDim2.new(0.6, 0, 1, 0)

    local vbox = Instance.new("TextBox")
    vbox.Size = UDim2.new(0, 48, 0, 18)
    vbox.Position = UDim2.new(1, -48, 0, 0)
    vbox.BackgroundColor3 = T.SurfaceHi
    vbox.BackgroundTransparency = 0.2
    vbox.Text = tostring(default)
    vbox.TextColor3 = T.Primary
    vbox.TextSize = 10
    vbox.Font = Enum.Font.GothamBold
    vbox.ClearTextOnFocus = false
    Round(vbox, 5)
    vbox.Parent = topRow

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 4)
    track.Position = UDim2.new(0, 0, 0, 28)
    track.BackgroundColor3 = T.NavBg
    track.BackgroundTransparency = 0.4
    track.BorderSizePixel = 0
    Round(track, 2)
    track.Parent = frame

    local pct = (default - min) / (max - min)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = T.Primary
    fill.BorderSizePixel = 0
    Round(fill, 2)
    fill.Parent = track

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(pct, -7, 0.5, -7)
    knob.BackgroundColor3 = T.Warning
    Round(knob, 7)
    knob.Parent = track

    local dragging = false
    local function updateFromInput(input)
        local pos = input.Position
        local trackPos, trackSize = track.AbsolutePosition, track.AbsoluteSize
        local relativeX = math.clamp(pos.X - trackPos.X, 0, trackSize.X)
        local p = relativeX / trackSize.X
        local val = math.floor(min + (max - min) * p + 0.5)
        val = math.clamp(val, min, max)
        vbox.Text = tostring(val)
        p = (val - min) / (max - min)
        fill.Size = UDim2.new(p, 0, 1, 0)
        knob.Position = UDim2.new(p, -7, 0.5, -7)
        if _callback then _callback(val) end
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromInput(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromInput(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    vbox.FocusLost:Connect(function()
        local val = math.clamp(tonumber(vbox.Text) or default, min, max)
        vbox.Text = tostring(val)
        local p = (val - min) / (max - min)
        fill.Size = UDim2.new(p, 0, 1, 0)
        knob.Position = UDim2.new(p, -7, 0.5, -7)
        if _callback then _callback(val) end
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
    b.BackgroundTransparency = 0.2
    b.Text = text
    b.TextColor3 = textCol
    b.TextSize = 11
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    Round(b, 8)
    b.Parent = parent
    b.MouseButton1Click:Connect(function()
        Tween(b, {BackgroundColor3 = col:Lerp(Color3.new(1,1,1), 0.2), BackgroundTransparency = 0}, 0.07)
        task.wait(0.07)
        Tween(b, {BackgroundColor3 = col, BackgroundTransparency = 0.2}, 0.1)
        if _callback then _callback() end
    end)
    return b
end

local function Dropdown(parent, labelTxt, options, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 0)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 26)
    button.BackgroundColor3 = T.SurfaceHi
    button.BackgroundTransparency = 0.2
    button.Text = labelTxt .. ": " .. options[1] .. " ▾"
    button.TextColor3 = T.Text
    button.TextSize = 11
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = false
    Round(button, 8)
    button.Parent = frame

    local list = Instance.new("Frame")
    list.Size = UDim2.new(1, 0, 0, 0)
    list.BackgroundColor3 = T.Surface
    list.BackgroundTransparency = 0.3
    list.BorderSizePixel = 0
    list.ClipsDescendants = true
    list.ZIndex = 10
    Round(list, 6)
    list.Parent = frame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = list

    local open = false
    local selected = options[1]

    for _, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 24)
        optBtn.BackgroundColor3 = T.Surface
        optBtn.BackgroundTransparency = 0.3
        optBtn.Text = opt
        optBtn.TextColor3 = T.Text
        optBtn.TextSize = 10
        optBtn.Font = Enum.Font.Gotham
        optBtn.BorderSizePixel = 0
        optBtn.AutoButtonColor = false
        optBtn.ZIndex = 11
        optBtn.Parent = list
        optBtn.MouseButton1Click:Connect(function()
            selected = opt
            button.Text = labelTxt .. ": " .. opt .. " ▾"
            open = false
            Tween(list, { Size = UDim2.new(1, 0, 0, 0) }, 0.15)
            if callback then callback(opt) end
        end)
    end

    button.MouseButton1Click:Connect(function()
        open = not open
        local targetHeight = open and (#options * 26) or 0
        Tween(list, { Size = UDim2.new(1, 0, 0, targetHeight) }, 0.18)
    end)

    -- Menutup dropdown jika klik di luar
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local pos = input.Position
            local absPos, absSize = frame.AbsolutePosition, frame.AbsoluteSize
            if not (pos.X >= absPos.X and pos.X <= absPos.X + absSize.X and pos.Y >= absPos.Y and pos.Y <= absPos.Y + absSize.Y) then
                if open then
                    open = false
                    Tween(list, { Size = UDim2.new(1, 0, 0, 0) }, 0.15)
                end
            end
        end
    end)

    return frame
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
-- (Hanya beberapa perbaikan minor, sisanya tetap seperti asli)
-- ====================================================================

-- ---------- DASHBOARD ----------
local dsC   = Section(PgDash, "📊 SERVER MONITOR")
local plrC  = Section(PgDash, "👤 PLAYER INFO")

local function StatRow(parent, labelTxt, valTxt, valCol)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1,0,0,20)
    row.BackgroundTransparency = 1
    row.Parent = parent
    local l = Lbl(row, labelTxt, 10, T.Muted)
    l.Size = UDim2.new(0.5,0,1,0)
    local v = Lbl(row, valTxt, 10, valCol or T.Primary, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
    v.Size = UDim2.new(0.5,0,1,0)
    v.Position = UDim2.new(0.5,0,0,0)
    return v
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

-- Credit
local creditFrame = Instance.new("Frame")
creditFrame.Size = UDim2.new(1,0,0,24)
creditFrame.BackgroundTransparency = 1
creditFrame.Parent = PgDash
local creditLbl = Lbl(creditFrame, "script by aptech", 10, T.Muted, Enum.Font.Gotham, Enum.TextXAlignment.Right)
creditLbl.Size = UDim2.new(1, -10, 1, 0)
creditLbl.Parent = creditFrame

task.spawn(function()
    while sPly and sPly.Parent do
        local pc = #Players:GetPlayers()
        local mp = 0
        pcall(function() mp = Players.MaxPlayers end)
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
spdRow.Parent = flyC

local spdLbl = Lbl(spdRow,"Fly Speed:",11,T.Text)
spdLbl.Size = UDim2.new(0.4,0,1,0)

local flyMin = Instance.new("TextButton")
flyMin.Size=UDim2.new(0,28,0,24)
flyMin.Position=UDim2.new(0.42,0,0.5,-12)
flyMin.BackgroundColor3=T.SurfaceHi
flyMin.BackgroundTransparency=0.2
flyMin.Text="−"
flyMin.TextColor3=T.Text
flyMin.TextSize=16
flyMin.Font=Enum.Font.GothamBold
flyMin.AutoButtonColor=false
Round(flyMin,8)
flyMin.Parent=spdRow

local flyDisp = Instance.new("TextLabel")
flyDisp.Size=UDim2.new(0,36,0,24)
flyDisp.Position=UDim2.new(0.42,30,0.5,-12)
flyDisp.BackgroundColor3=T.Surface
flyDisp.BackgroundTransparency=0.3
flyDisp.Text="1"
flyDisp.TextColor3=T.Primary
flyDisp.TextSize=12
flyDisp.Font=Enum.Font.GothamBold
flyDisp.TextXAlignment=Enum.TextXAlignment.Center
Round(flyDisp,8)
flyDisp.Parent=spdRow

local flyPlus = Instance.new("TextButton")
flyPlus.Size=UDim2.new(0,28,0,24)
flyPlus.Position=UDim2.new(0.42,68,0.5,-12)
flyPlus.BackgroundColor3=T.SurfaceHi
flyPlus.BackgroundTransparency=0.2
flyPlus.Text="+"
flyPlus.TextColor3=T.Text
flyPlus.TextSize=16
flyPlus.Font=Enum.Font.GothamBold
flyPlus.AutoButtonColor=false
Round(flyPlus,8)
flyPlus.Parent=spdRow

local udRow = Instance.new("Frame")
udRow.Size=UDim2.new(1,0,0,28)
udRow.BackgroundTransparency=1
udRow.Parent=flyC

local flyUpBtn = Instance.new("TextButton")
flyUpBtn.Size=UDim2.new(0.49,0,0,26)
flyUpBtn.BackgroundColor3=T.SurfaceHi
flyUpBtn.BackgroundTransparency=0.2
flyUpBtn.Text="▲  UP"
flyUpBtn.TextColor3=T.Text
flyUpBtn.TextSize=11
flyUpBtn.Font=Enum.Font.GothamBold
flyUpBtn.AutoButtonColor=false
Round(flyUpBtn,8)
flyUpBtn.Parent=udRow

local flyDnBtn = Instance.new("TextButton")
flyDnBtn.Size=UDim2.new(0.49,0,0,26)
flyDnBtn.Position=UDim2.new(0.51,0,0,0)
flyDnBtn.BackgroundColor3=T.SurfaceHi
flyDnBtn.BackgroundTransparency=0.2
flyDnBtn.Text="▼  DOWN"
flyDnBtn.TextColor3=T.Text
flyDnBtn.TextSize=11
flyDnBtn.Font=Enum.Font.GothamBold
flyDnBtn.AutoButtonColor=false
Round(flyDnBtn,8)
flyDnBtn.Parent=udRow

local flyTogBtn = Instance.new("TextButton")
flyTogBtn.Size=UDim2.new(1,0,0,30)
flyTogBtn.BackgroundColor3=T.SurfaceHi
flyTogBtn.BackgroundTransparency=0.2
flyTogBtn.Text="✈️  FLY: OFF"
flyTogBtn.TextColor3=T.Muted
flyTogBtn.TextSize=12
flyTogBtn.Font=Enum.Font.GothamBold
flyTogBtn.AutoButtonColor=false
Round(flyTogBtn,10)
flyTogBtn.Parent=flyC

local ncC = Section(PgFly, "🔮 NOCLIP")
Toggle(ncC, "No Clip")

-- ---------- ESP ----------
local espC   = Section(PgESP, "👁️ PLAYER ESP")
Toggle(espC, "Enable Player ESP")

local espV2C = Section(PgESP, "👑 ESP V2  –  ADMIN ONLY")
local espLock = Lbl(espV2C, "🔒 Login Admin untuk mengaktifkan ESP V2", 10, T.Warning)
espLock.Size = UDim2.new(1,0,0,20)
Toggle(espV2C, "👑 ESP V2 (HP + Dist + Team + RGB)")

local blkEspC = Section(PgESP, "🧱 BLOCK / ITEM ESP")
Toggle(blkEspC, "Scan & highlight blocks")

-- ---------- TELEPORT ----------
local tpC = Section(PgTP, "🎯 TELEPORT")

local tpSF = Instance.new("ScrollingFrame")
tpSF.Size=UDim2.new(1,0,0,90)
tpSF.BackgroundColor3=T.SurfaceHi
tpSF.BackgroundTransparency=0.4
tpSF.BorderSizePixel=0
tpSF.ScrollBarThickness=4
tpSF.AutomaticCanvasSize = Enum.AutomaticSize.Y
Round(tpSF,8)
tpSF.Parent=tpC

local tpLL = Instance.new("UIListLayout")
tpLL.Padding=UDim.new(0,4)
tpLL.Parent=tpSF

local function RefreshTPList()
    for _, c in pairs(tpSF:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local b = Instance.new("TextButton")
            b.Size=UDim2.new(1,-6,0,26)
            b.Position=UDim2.new(0,3,0,0)
            b.BackgroundColor3=T.Surface
            b.BackgroundTransparency=0.2
            b.Text=p.Name
            b.TextColor3=T.Text
            b.TextSize=11
            b.Font=Enum.Font.Gotham
            b.BorderSizePixel=0
            b.AutoButtonColor=false
            Round(b,6)
            b.Parent=tpSF
            b.MouseButton1Click:Connect(function()
                Tween(b,{BackgroundColor3=T.Primary, BackgroundTransparency=0.1},0.12)
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
godModeBtn.BackgroundTransparency=0.2
godModeBtn.Text="Mode: Gen1  (auto-heal)"
godModeBtn.TextColor3=T.Text
godModeBtn.TextSize=11
godModeBtn.Font=Enum.Font.GothamBold
godModeBtn.AutoButtonColor=false
Round(godModeBtn,8)
godModeBtn.Parent=godC

Toggle(godC, "God Mode")
Toggle(godC, "Auto Heal")
Btn(godC, "Heal Now", "success")

-- ---------- WORLD ----------
local wC = Section(PgWorld, "🧱 BLOCK SPAWNER")

Dropdown(wC, "Block Type",  {"Part","Wedge","CornerWedge","Truss","SpawnLocation"})
Dropdown(wC, "Material",    {"SmoothPlastic","Neon","Glass","Wood","Granite","Metal","ForceField"})
Dropdown(wC, "Color",       {"Red","Blue","Green","Yellow","White","Black","Pink","Orange"})
Slider(wC, "Block Size", 1, 50, 5)
Btn(wC, "🧱 Spawn Block di Depan", "primary")
Btn(wC, "🗑️ Hapus Block Terakhir", "danger")
Btn(wC, "💥 Clear Semua Block", "danger")

-- ---------- AVATAR ----------
local avC = Section(PgAva, "👤 COPY AVATAR")

local avStatus = Lbl(avC, "Pilih player untuk copy tampilan.", 10, T.Muted)
avStatus.Size = UDim2.new(1,0,0,18)

local avSF = Instance.new("ScrollingFrame")
avSF.Size=UDim2.new(1,0,0,90)
avSF.BackgroundColor3=T.SurfaceHi
avSF.BackgroundTransparency=0.4
avSF.BorderSizePixel=0
avSF.ScrollBarThickness=4
avSF.AutomaticCanvasSize = Enum.AutomaticSize.Y
Round(avSF,8)
avSF.Parent=avC

local avLL = Instance.new("UIListLayout")
avLL.Padding=UDim.new(0,4)
avLL.Parent=avSF

local function RefreshAvaList()
    for _, c in pairs(avSF:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local b = Instance.new("TextButton")
            b.Size=UDim2.new(1,-6,0,26)
            b.Position=UDim2.new(0,3,0,0)
            b.BackgroundColor3=T.Surface
            b.BackgroundTransparency=0.2
            b.Text=p.Name
            b.TextColor3=T.Text
            b.TextSize=11
            b.Font=Enum.Font.Gotham
            b.BorderSizePixel=0
            b.AutoButtonColor=false
            Round(b,6)
            b.Parent=avSF
            b.MouseButton1Click:Connect(function()
                for _, bb in pairs(avSF:GetChildren()) do
                    if bb:IsA("TextButton") then
                        Tween(bb,{BackgroundColor3=T.Surface, BackgroundTransparency=0.2},0.1)
                    end
                end
                Tween(b,{BackgroundColor3=T.Primary, BackgroundTransparency=0.1},0.12)
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
preNameBox.BackgroundTransparency=0.2
preNameBox.PlaceholderText="Nama preset…"
preNameBox.Text=""
preNameBox.TextColor3=T.Text
preNameBox.TextSize=11
preNameBox.Font=Enum.Font.Gotham
preNameBox.ClearTextOnFocus=false
Round(preNameBox,8)
preNameBox.Parent=svC

local preSF = Instance.new("ScrollingFrame")
preSF.Size=UDim2.new(1,0,0,80)
preSF.BackgroundColor3=T.SurfaceHi
preSF.BackgroundTransparency=0.4
preSF.BorderSizePixel=0
preSF.ScrollBarThickness=4
preSF.AutomaticCanvasSize = Enum.AutomaticSize.Y
Round(preSF,8)
preSF.Parent=svC
local preLL = Instance.new("UIListLayout")
preLL.Padding=UDim.new(0,4)
preLL.Parent=preSF

Btn(svC, "💾 Save Settings Sekarang", "primary")

local exportBox = Instance.new("TextBox")
exportBox.Size=UDim2.new(1,0,0,48)
exportBox.BackgroundColor3=T.NavBg
exportBox.BackgroundTransparency=0.4
exportBox.PlaceholderText="Kode export akan muncul di sini…"
exportBox.Text=""
exportBox.TextColor3=T.Primary
exportBox.TextSize=9
exportBox.Font=Enum.Font.Code
exportBox.MultiLine=true
exportBox.TextXAlignment=Enum.TextXAlignment.Left
exportBox.TextYAlignment=Enum.TextYAlignment.Top
exportBox.ClearTextOnFocus=false
Round(exportBox,8)
exportBox.Parent=svC

local importBox = Instance.new("TextBox")
importBox.Size=UDim2.new(1,0,0,42)
importBox.BackgroundColor3=T.NavBg
importBox.BackgroundTransparency=0.4
importBox.PlaceholderText="Paste kode import di sini…"
importBox.Text=""
importBox.TextColor3=T.Text
importBox.TextSize=9
importBox.Font=Enum.Font.Code
importBox.MultiLine=true
importBox.TextXAlignment=Enum.TextXAlignment.Left
importBox.TextYAlignment=Enum.TextYAlignment.Top
importBox.ClearTextOnFocus=false
Round(importBox,8)
importBox.Parent=svC

Btn(svC, "📥 Import dari Kode", "normal")

-- ---------- ADMIN ----------
local adC = Section(PgAdmin, "🔐 ADMIN LOGIN")

local adStatus = Lbl(adC, "🔒 Belum terautentikasi", 10, T.Muted)
adStatus.Size = UDim2.new(1,0,0,18)

local pwBox = Instance.new("TextBox")
pwBox.Size=UDim2.new(1,0,0,28)
pwBox.BackgroundColor3=T.NavBg
pwBox.BackgroundTransparency=0.4
pwBox.PlaceholderText="Masukkan password…"
pwBox.Text=""
pwBox.TextColor3=T.Text
pwBox.TextSize=12
pwBox.Font=Enum.Font.GothamBold
pwBox.ClearTextOnFocus=false
Round(pwBox,8)
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
OrbBtn.ZIndex = 100
OrbBtn.Active = true
OrbBtn.Draggable = true
OrbBtn.AutoButtonColor = false
Round(OrbBtn, 25)
Stroke(OrbBtn, T.Warning, 2)
OrbBtn.Parent = SG
FallbackIcon(OrbBtn, "◉")  -- fallback icon orb

MinBtn.MouseButton1Click:Connect(function()
    Tween(MF, {Size = UDim2.new(0, 450, 0, 0)}, 0.25)
    task.wait(0.25)
    MF.Visible = false
    OrbBtn.Visible = true
end)

OrbBtn.MouseButton1Click:Connect(function()
    OrbBtn.Visible = false
    MF.Visible = true
    Tween(MF, {Size = UDim2.new(0, 450, 0, 290)}, 0.4, Enum.EasingStyle.Back)
end)

CloseBtn.MouseButton1Click:Connect(function()
    SG:Destroy()
end)

-- ====================== OPENING ANIMASI MAIN =======================
MF.Size = UDim2.new(0, 0, 0, 0)
GoPage("Dash")
task.wait(0.2)
MF.Visible = true
Tween(MF, {Size = UDim2.new(0, 450, 0, 290)}, 0.6, Enum.EasingStyle.Back)

-- ==================== FETCH IMAGE (di background) ====================
task.spawn(function()
    local logoId = fetchImage(imageUrls.logo, "apng_logo.png")
    if logoId ~= "" then
        MinBtn.Image = logoId
        OrbBtn.Image = logoId
    end

    local bgId = fetchImage(imageUrls.bg, "apng_bg.jpg")
    if bgId ~= "" then
        BgImage.Image = bgId
    end
end)
