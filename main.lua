--[[
    AP-NEXTGEN HUB v9.0 ULTRA
    Redesigned Landscape UI | All Features | Mobile Optimized
    FLY V3 Logic | Admin ESP V2 | Block Spawner | Copy Avatar | Presets
    by APTECH
]]

-- Anti-duplicate
if getgenv().APNEXTGEN_LOADED then return end
getgenv().APNEXTGEN_LOADED = true

-- ==================== SERVICES ====================
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local Workspace        = game:GetService("Workspace")
local Lighting         = game:GetService("Lighting")
local TeleportService  = game:GetService("TeleportService")
local VirtualUser      = game:GetService("VirtualUser")
local HttpService      = game:GetService("HttpService")
local StarterGui       = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Camera      = Workspace.CurrentCamera

if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

-- ==================== CONFIG ====================
local Config = {
    Speed        = 16,
    JumpPower    = 50,
    GodMode      = false,
    GodModeType  = "Gen1",
    Noclip       = false,
    Flying       = false,
    ESPPlayers   = false,
    ESPBlocks    = false,
    ESPAdmin     = false,
    AutoFollow   = false,
    AutoHeal     = false,
    FullBright   = false,
    AntiAFK      = false,
    FPSBoost     = false,
    InfiniteJump = false,
    MoonGravity  = false,
    ZoomUnlock   = false,
    IsAdmin      = false,
}

-- ==================== STATES ====================
local States = {
    FollowingPlayer    = nil,
    ESPPlayerFolder    = nil,
    ESPBlockFolder     = nil,
    AdminESPFolder     = nil,
    NoclipConnection   = nil,
    GodConnection      = nil,
    BrightnessConnection = nil,
    JumpConnection     = nil,
    Connections        = {},
    FlyActive          = false,
    FlySpeedCount      = 1,
    tpwalking          = false,
    FlyBodyGyro        = nil,
    FlyBodyVelocity    = nil,
    FlyRenderConn      = nil,
    upHeld             = false,
    downHeld           = false,
}

-- ==================== CLEANUP ====================
local function Cleanup()
    States.FlyActive  = false
    States.tpwalking  = false
    States.upHeld     = false
    States.downHeld   = false
    for _, conn in pairs(States.Connections) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    for _, name in ipairs({"NoclipConnection","GodConnection","BrightnessConnection","JumpConnection","FlyRenderConn"}) do
        if States[name] then pcall(function() States[name]:Disconnect() end); States[name] = nil end
    end
    if States.FlyBodyGyro     and States.FlyBodyGyro.Parent     then States.FlyBodyGyro:Destroy()     end
    if States.FlyBodyVelocity and States.FlyBodyVelocity.Parent then States.FlyBodyVelocity:Destroy() end
    if States.ESPPlayerFolder  then pcall(function() States.ESPPlayerFolder:Destroy()  end) end
    if States.ESPBlockFolder   then pcall(function() States.ESPBlockFolder:Destroy()   end) end
    if States.AdminESPFolder   then pcall(function() States.AdminESPFolder:Destroy()   end) end
    getgenv().APNEXTGEN_LOADED = nil
end

-- ==================== THEME ====================
local T = {
    Bg          = Color3.fromRGB(11,  11,  17 ),
    Surface     = Color3.fromRGB(20,  20,  30 ),
    SurfaceHi   = Color3.fromRGB(32,  32,  48 ),
    NavBg       = Color3.fromRGB(15,  15,  24 ),
    Primary     = Color3.fromRGB(0,   170, 255),
    Success     = Color3.fromRGB(0,   210, 110),
    Warning     = Color3.fromRGB(255, 190, 40 ),
    Error       = Color3.fromRGB(255,  55,  75),
    Admin       = Color3.fromRGB(255, 210,  0 ),
    Text        = Color3.fromRGB(235, 235, 255),
    Muted       = Color3.fromRGB(145, 145, 175),
    Border      = Color3.fromRGB(40,  40,  62 ),
}

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

local function Label(parent, text, size, color, font, align)
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

-- ==================== MAIN SCREENGUI ====================
local SG = Instance.new("ScreenGui")
SG.Name            = "APNEXTGEN_V9"
SG.Parent          = CoreGui
SG.ResetOnSpawn    = false
SG.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
SG.DisplayOrder    = 100

-- ==================== MAIN FRAME (landscape 450 x 290) ====================
local MF = Instance.new("Frame")
MF.Name             = "MainFrame"
MF.Size             = UDim2.new(0, 450, 0, 290)
MF.Position         = UDim2.new(0.5, -225, 0.5, -145)
MF.BackgroundColor3 = T.Bg
MF.BorderSizePixel  = 0
MF.ClipsDescendants = true
MF.Active           = true
Round(MF, 14)
Stroke(MF, T.Border, 1.5)
MF.Parent = SG

-- ==================== TOP BAR ====================
local TopBar = Instance.new("Frame")
TopBar.Size             = UDim2.new(1, 0, 0, 36)
TopBar.BackgroundColor3 = T.Surface
TopBar.BorderSizePixel  = 0
TopBar.ZIndex           = 5
Round(TopBar, 14)
TopBar.Parent = MF

-- fix rounded corners only on top
local TopBarFix = Instance.new("Frame")
TopBarFix.Size             = UDim2.new(1, 0, 0, 12)
TopBarFix.Position         = UDim2.new(0, 0, 1, -12)
TopBarFix.BackgroundColor3 = T.Surface
TopBarFix.BorderSizePixel  = 0
TopBarFix.ZIndex           = 4
TopBarFix.Parent           = TopBar

-- Avatar
local AvImg = Instance.new("ImageLabel")
AvImg.Size              = UDim2.new(0, 26, 0, 26)
AvImg.Position          = UDim2.new(0, 6, 0.5, -13)
AvImg.BackgroundColor3  = T.SurfaceHi
AvImg.Image             = "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=150&height=150&format=png"
AvImg.ZIndex            = 6
Round(AvImg, 13)
AvImg.Parent = TopBar

-- Name
local NameLbl = Label(TopBar, LocalPlayer.Name, 11, T.Text, Enum.Font.GothamBold)
NameLbl.Size     = UDim2.new(0, 85, 0, 13)
NameLbl.Position = UDim2.new(0, 36, 0, 5)
NameLbl.ZIndex   = 6
NameLbl.TextTruncate = Enum.TextTruncate.AtEnd

-- Game mini info
local GameLbl = Label(TopBar, "...", 8, T.Muted)
GameLbl.Size     = UDim2.new(0, 85, 0, 11)
GameLbl.Position = UDim2.new(0, 36, 0, 20)
GameLbl.ZIndex   = 6
GameLbl.TextTruncate = Enum.TextTruncate.AtEnd

-- Server info (center)
local SrvLbl = Label(TopBar, "Loading...", 9, T.Primary, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
SrvLbl.Size     = UDim2.new(0, 200, 0, 14)
SrvLbl.Position = UDim2.new(0.5, -100, 0.5, -7)
SrvLbl.ZIndex   = 6
SrvLbl.TextTruncate = Enum.TextTruncate.AtEnd

-- Minimize button
local MinBtn = Instance.new("TextButton")
MinBtn.Size             = UDim2.new(0, 24, 0, 20)
MinBtn.Position         = UDim2.new(1, -52, 0.5, -10)
MinBtn.BackgroundColor3 = T.SurfaceHi
MinBtn.Text             = "−"
MinBtn.TextColor3       = T.Muted
MinBtn.TextSize         = 16
MinBtn.Font             = Enum.Font.GothamBold
MinBtn.ZIndex           = 7
Round(MinBtn, 5)
MinBtn.Parent = TopBar

-- Close button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size             = UDim2.new(0, 24, 0, 20)
CloseBtn.Position         = UDim2.new(1, -26, 0.5, -10)
CloseBtn.BackgroundColor3 = T.Error
CloseBtn.Text             = "✕"
CloseBtn.TextColor3       = Color3.new(1,1,1)
CloseBtn.TextSize         = 11
CloseBtn.Font             = Enum.Font.GothamBold
CloseBtn.ZIndex           = 7
Round(CloseBtn, 5)
CloseBtn.Parent = TopBar

-- Server info updater
local function UpdateSrv()
    local pc = #Players:GetPlayers()
    local mp = 0; pcall(function() mp = Players.MaxPlayers end)
    GameLbl.Text = game.Name:sub(1, 14)
    SrvLbl.Text  = "🌐 Global | ID:"..tostring(game.PlaceId):sub(1,9).." | "..pc.."/"..mp
end
UpdateSrv()
spawn(function() while SrvLbl.Parent do wait(5); UpdateSrv() end end)

-- ==================== DRAG LOGIC ====================
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

-- ==================== LEFT NAV ====================
local NavFrame = Instance.new("ScrollingFrame")
NavFrame.Size                 = UDim2.new(0, 50, 1, -36)
NavFrame.Position             = UDim2.new(0, 0, 0, 36)
NavFrame.BackgroundColor3     = T.NavBg
NavFrame.BorderSizePixel      = 0
NavFrame.ScrollBarThickness   = 0
NavFrame.AutomaticCanvasSize  = Enum.AutomaticSize.Y
NavFrame.ScrollingDirection   = Enum.ScrollingDirection.Y
NavFrame.Parent               = MF

local NavLayout = Instance.new("UIListLayout")
NavLayout.Padding             = UDim.new(0, 2)
NavLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
NavLayout.Parent              = NavFrame

local NavPad = Instance.new("UIPadding")
NavPad.PaddingTop  = UDim.new(0, 4)
NavPad.PaddingLeft = UDim.new(0, 3)
NavPad.PaddingRight= UDim.new(0, 3)
NavPad.Parent      = NavFrame

-- Divider
local Div = Instance.new("Frame")
Div.Size             = UDim2.new(0, 1, 1, -36)
Div.Position         = UDim2.new(0, 50, 0, 36)
Div.BackgroundColor3 = T.Border
Div.BorderSizePixel  = 0
Div.Parent           = MF

-- ==================== CONTENT AREA ====================
local ContentArea = Instance.new("Frame")
ContentArea.Size             = UDim2.new(1, -51, 1, -36)
ContentArea.Position         = UDim2.new(0, 51, 0, 36)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.Parent           = MF

-- ==================== PAGE SYSTEM ====================
local Pages      = {}
local NavButtons = {}
local ActivePage = nil

local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name                = name
    page.Size                = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel     = 0
    page.ScrollBarThickness  = 3
    page.ScrollBarImageColor3= T.Primary
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollingDirection  = Enum.ScrollingDirection.Y
    page.Visible             = false
    page.Parent              = ContentArea

    local layout = Instance.new("UIListLayout")
    layout.Padding  = UDim.new(0, 5)
    layout.Parent   = page

    local pad = Instance.new("UIPadding")
    pad.PaddingTop    = UDim.new(0, 5)
    pad.PaddingLeft   = UDim.new(0, 5)
    pad.PaddingRight  = UDim.new(0, 5)
    pad.PaddingBottom = UDim.new(0, 5)
    pad.Parent        = page

    Pages[name] = page
    return page
end

local function SwitchPage(name)
    for pname, page in pairs(Pages) do page.Visible = (pname == name) end
    ActivePage = name
    for bname, btn in pairs(NavButtons) do
        if bname == name then
            Tween(btn, {BackgroundColor3 = T.Primary}, 0.18)
            Tween(btn, {TextColor3 = Color3.new(1,1,1)}, 0.18)
        else
            Tween(btn, {BackgroundColor3 = T.NavBg}, 0.18)
            Tween(btn, {TextColor3 = T.Muted}, 0.18)
        end
    end
end

local function MakeNavBtn(icon, pageName)
    local btn = Instance.new("TextButton")
    btn.Size             = UDim2.new(0, 42, 0, 32)
    btn.BackgroundColor3 = T.NavBg
    btn.Text             = icon
    btn.TextColor3       = T.Muted
    btn.TextSize         = 14
    btn.Font             = Enum.Font.GothamBold
    btn.BorderSizePixel  = 0
    btn.AutoButtonColor  = false
    Round(btn, 7)
    btn.Parent = NavFrame
    NavButtons[pageName] = btn
    btn.MouseButton1Click:Connect(function() SwitchPage(pageName) end)
    return btn
end

-- ==================== UI COMPONENT BUILDERS ====================
local function Section(parent, title)
    local card = Instance.new("Frame")
    card.Size            = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize   = Enum.AutomaticSize.Y
    card.BackgroundColor3= T.Surface
    card.BorderSizePixel = 0
    Round(card, 8)
    card.Parent = parent

    local ttl = Label(card, title, 10, T.Primary, Enum.Font.GothamBold)
    ttl.Size     = UDim2.new(1, -10, 0, 20)
    ttl.Position = UDim2.new(0, 8, 0, 3)

    local line = Instance.new("Frame")
    line.Size             = UDim2.new(1, -16, 0, 1)
    line.Position         = UDim2.new(0, 8, 0, 23)
    line.BackgroundColor3 = T.Border
    line.BorderSizePixel  = 0
    line.Parent           = card

    local cont = Instance.new("Frame")
    cont.Name            = "Cont"
    cont.Size            = UDim2.new(1, -10, 0, 0)
    cont.Position        = UDim2.new(0, 5, 0, 27)
    cont.AutomaticSize   = Enum.AutomaticSize.Y
    cont.BackgroundTransparency = 1
    cont.Parent          = card

    local cL = Instance.new("UIListLayout")
    cL.Padding = UDim.new(0, 4)
    cL.Parent  = cont

    local cP = Instance.new("UIPadding")
    cP.PaddingBottom = UDim.new(0, 7)
    cP.Parent        = card

    return cont
end

local function Toggle(parent, text, callback)
    local row = Instance.new("Frame")
    row.Size             = UDim2.new(1, 0, 0, 26)
    row.BackgroundTransparency = 1
    row.Parent           = parent

    local lbl = Label(row, text, 10, T.Text)
    lbl.Size = UDim2.new(0.7, 0, 1, 0)

    local btn = Instance.new("TextButton")
    btn.Size             = UDim2.new(0, 42, 0, 18)
    btn.Position         = UDim2.new(1, -42, 0.5, -9)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 62)
    btn.Text             = "OFF"
    btn.TextColor3       = T.Muted
    btn.TextSize         = 9
    btn.Font             = Enum.Font.GothamBold
    btn.AutoButtonColor  = false
    Round(btn, 9)
    btn.Parent = row

    local on = false
    btn.MouseButton1Click:Connect(function()
        on = not on
        btn.Text = on and "ON" or "OFF"
        Tween(btn, {BackgroundColor3 = on and T.Success or Color3.fromRGB(45,45,62)}, 0.18)
        Tween(btn, {TextColor3 = on and Color3.new(1,1,1) or T.Muted}, 0.18)
        if callback then callback(on) end
    end)

    local self = {Row = row, Btn = btn, _on = false}
    function self:Set(state)
        on = state; self._on = state
        btn.Text = on and "ON" or "OFF"
        btn.BackgroundColor3 = on and T.Success or Color3.fromRGB(45,45,62)
        btn.TextColor3       = on and Color3.new(1,1,1) or T.Muted
    end
    return self
end

local function Slider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size             = UDim2.new(1, 0, 0, 42)
    frame.BackgroundTransparency = 1
    frame.Parent           = parent

    local topRow = Instance.new("Frame")
    topRow.Size            = UDim2.new(1, 0, 0, 16)
    topRow.BackgroundTransparency = 1
    topRow.Parent          = frame

    local lbl = Label(topRow, text, 10, T.Text)
    lbl.Size = UDim2.new(0.62, 0, 1, 0)

    local vbox = Instance.new("TextBox")
    vbox.Size             = UDim2.new(0, 44, 0, 16)
    vbox.Position         = UDim2.new(1, -44, 0, 0)
    vbox.BackgroundColor3 = T.SurfaceHi
    vbox.Text             = tostring(default)
    vbox.TextColor3       = T.Primary
    vbox.TextSize         = 9
    vbox.Font             = Enum.Font.GothamBold
    vbox.ClearTextOnFocus = false
    Round(vbox, 4)
    vbox.Parent = topRow

    local track = Instance.new("Frame")
    track.Size             = UDim2.new(1, 0, 0, 4)
    track.Position         = UDim2.new(0, 0, 0, 28)
    track.BackgroundColor3 = Color3.fromRGB(38, 38, 55)
    track.BorderSizePixel  = 0
    Round(track, 2)
    track.Parent = frame

    local pct = (default - min) / math.max(max - min, 1)
    local fill = Instance.new("Frame")
    fill.Size             = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = T.Primary
    fill.BorderSizePixel  = 0
    Round(fill, 2)
    fill.Parent = track

    local knob = Instance.new("Frame")
    knob.Size             = UDim2.new(0, 12, 0, 12)
    knob.Position         = UDim2.new(pct, -6, 0.5, -6)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    Round(knob, 6)
    knob.Parent = track

    local dragging = false
    local function doUpdate(input)
        local p = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local v = math.floor(min + (max - min) * p)
        vbox.Text = tostring(v)
        fill.Size     = UDim2.new(p, 0, 1, 0)
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
        fill.Size     = UDim2.new(p, 0, 1, 0)
        knob.Position = UDim2.new(p, -6, 0.5, -6)
        if callback then callback(v) end
    end)

    return frame
end

local function Btn(parent, text, style, callback)
    local b = Instance.new("TextButton")
    b.Size             = UDim2.new(1, 0, 0, 26)
    local col = style == "primary" and T.Primary
             or style == "success"  and T.Success
             or style == "danger"   and T.Error
             or style == "admin"    and T.Admin
             or T.SurfaceHi
    b.BackgroundColor3 = col
    b.Text             = text
    b.TextColor3       = style == "admin" and Color3.new(0,0,0) or Color3.new(1,1,1)
    b.TextSize         = 10
    b.Font             = Enum.Font.GothamBold
    b.BorderSizePixel  = 0
    b.AutoButtonColor  = false
    Round(b, 6)
    b.Parent = parent

    b.MouseButton1Click:Connect(function()
        Tween(b, {BackgroundColor3 = col:Lerp(Color3.new(1,1,1), 0.25)}, 0.07)
        wait(0.07)
        Tween(b, {BackgroundColor3 = col}, 0.1)
        if callback then callback() end
    end)
    return b
end

local function PlayerList(parent, height, onSelect)
    local sf = Instance.new("ScrollingFrame")
    sf.Size              = UDim2.new(1, 0, 0, height)
    sf.BackgroundColor3  = T.SurfaceHi
    sf.BackgroundTransparency = 0.4
    sf.BorderSizePixel   = 0
    sf.ScrollBarThickness= 3
    sf.CanvasSize        = UDim2.new(0, 0, 0, 0)
    Round(sf, 6)
    sf.Parent = parent

    local ll = Instance.new("UIListLayout")
    ll.Padding = UDim.new(0, 3)
    ll.Parent  = sf

    local selected = nil
    local btns = {}

    local function Refresh()
        for _, c in pairs(sf:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        btns = {}
        local count = 0
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                count = count + 1
                local b = Instance.new("TextButton")
                b.Size             = UDim2.new(1, -6, 0, 24)
                b.Position         = UDim2.new(0, 3, 0, 0)
                b.BackgroundColor3 = (selected == p) and T.Primary or T.Surface
                b.Text             = p.Name
                b.TextColor3       = Color3.new(1, 1, 1)
                b.TextSize         = 10
                b.Font             = Enum.Font.Gotham
                b.BorderSizePixel  = 0
                b.AutoButtonColor  = false
                Round(b, 5)
                b.Parent = sf
                table.insert(btns, b)
                b.MouseButton1Click:Connect(function()
                    selected = p
                    for _, bb in pairs(btns) do
                        Tween(bb, {BackgroundColor3 = T.Surface}, 0.12)
                    end
                    Tween(b, {BackgroundColor3 = T.Primary}, 0.12)
                    if onSelect then onSelect(p) end
                end)
            end
        end
        sf.CanvasSize = UDim2.new(0, 0, 0, count * 27)
    end

    Refresh()
    Players.PlayerAdded:Connect(Refresh)
    Players.PlayerRemoving:Connect(Refresh)

    local self = {}
    function self:GetSelected() return selected end
    function self:Refresh() Refresh() end
    return self
end

-- ==================== CREATE ALL PAGES ====================
-- Dashboard
MakeNavBtn("📊", "Dash")
local DashPage = CreatePage("Dash")

-- Movement
MakeNavBtn("🏃", "Move")
local MovePage = CreatePage("Move")

-- Fly
MakeNavBtn("✈️", "Fly")
local FlyPage = CreatePage("Fly")

-- ESP
MakeNavBtn("👁️", "ESP")
local ESPPage = CreatePage("ESP")

-- Teleport
MakeNavBtn("🎯", "TP")
local TPPage = CreatePage("TP")

-- God
MakeNavBtn("🛡️", "God")
local GodPage = CreatePage("God")

-- World
MakeNavBtn("🧱", "World")
local WorldPage = CreatePage("World")

-- Avatar
MakeNavBtn("👤", "Ava")
local AvaPage = CreatePage("Ava")

-- Presets
MakeNavBtn("💾", "Save")
local PrePage = CreatePage("Save")

-- Admin
MakeNavBtn("🔐", "Admin")
local AdminPage = CreatePage("Admin")

-- Utility
MakeNavBtn("⚙️", "Util")
local UtilPage = CreatePage("Util")

-- ==================== ESP FOLDERS ====================
States.ESPPlayerFolder = Instance.new("Folder"); States.ESPPlayerFolder.Name = "ESP_P";  States.ESPPlayerFolder.Parent = CoreGui
States.ESPBlockFolder  = Instance.new("Folder"); States.ESPBlockFolder.Name  = "ESP_B";  States.ESPBlockFolder.Parent  = CoreGui
States.AdminESPFolder  = Instance.new("Folder"); States.AdminESPFolder.Name  = "ESP_A";  States.AdminESPFolder.Parent  = CoreGui

-- ====================================================================
-- ======================== DASHBOARD PAGE ============================
-- ====================================================================
local dsCard  = Section(DashPage, "📊 SERVER MONITOR")
local plrCard = Section(DashPage, "👤 PLAYER INFO")

local function StatRow(parent, ltext, defaultVal, valColor)
    local row = Instance.new("Frame")
    row.Size             = UDim2.new(1, 0, 0, 18)
    row.BackgroundTransparency = 1
    row.Parent           = parent
    local l = Label(row, ltext, 9, T.Muted)
    l.Size = UDim2.new(0.52, 0, 1, 0)
    local v = Label(row, defaultVal, 9, valColor or T.Primary, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
    v.Size     = UDim2.new(0.48, 0, 1, 0)
    v.Position = UDim2.new(0.52, 0, 0, 0)
    return v
end

local sGameName = StatRow(dsCard,  "Game Name:",   game.Name:sub(1,18),         T.Primary)
local sPlaceId  = StatRow(dsCard,  "Place ID:",    tostring(game.PlaceId),      T.Warning)
local sJobId    = StatRow(dsCard,  "Job ID:",      game.JobId:sub(1,12).."...", T.Muted)
local sPlayers  = StatRow(dsCard,  "Players:",     "?/?",                        T.Success)
local sServer   = StatRow(dsCard,  "Server Type:", "🌐 Global",                  T.Primary)

local sUser    = StatRow(plrCard, "Username:",     LocalPlayer.Name,            T.Primary)
local sUID     = StatRow(plrCard, "User ID:",      tostring(LocalPlayer.UserId),T.Muted)
local sDisplay = StatRow(plrCard, "Display Name:", LocalPlayer.DisplayName,     T.Text)
local sTeam    = StatRow(plrCard, "Team:",         "None",                       T.Warning)

spawn(function()
    while sPlayers.Parent do
        local pc = #Players:GetPlayers(); local mp = 0; pcall(function() mp = Players.MaxPlayers end)
        sPlayers.Text  = pc.."/"..mp
        sGameName.Text = game.Name:sub(1,18)
        sJobId.Text    = game.JobId:sub(1,12).."..."
        if LocalPlayer.Team then sTeam.Text = LocalPlayer.Team.Name end
        wait(5)
    end
end)

-- ====================================================================
-- ======================== MOVEMENT PAGE ============================
-- ====================================================================
local mvCard  = Section(MovePage, "🏃 SPEED & JUMP")
Slider(mvCard, "Walk Speed",  1, 500, 16, function(v)
    Config.Speed = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
end)

Slider(mvCard, "Jump Power",  1, 500, 50, function(v)
    Config.JumpPower = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local h = LocalPlayer.Character.Humanoid
        if h.UseJumpPower then h.JumpPower = v else h.JumpHeight = v / 10 end
    end
end)

local jumpCard = Section(MovePage, "⬆️ JUMP OPTIONS")
Toggle(jumpCard, "Infinite Jump", function(on)
    Config.InfiniteJump = on
    if on then
        local conn = UserInputService.JumpRequest:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        table.insert(States.Connections, conn)
    end
end)

local gravCard = Section(MovePage, "🌙 GRAVITY")
Toggle(gravCard, "Moon Gravity (Low Gravity)", function(on)
    Config.MoonGravity = on
    workspace.Gravity  = on and 20 or 196.2
end)
Slider(gravCard, "Custom Gravity", 5, 350, 196, function(v)
    workspace.Gravity = v
end)

Btn(mvCard, "Reset Speed & Jump", "normal", function()
    Config.Speed = 16; Config.JumpPower = 50
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local h = LocalPlayer.Character.Humanoid
        h.WalkSpeed = 16
        if h.UseJumpPower then h.JumpPower = 50 else h.JumpHeight = 7.2 end
    end
end)

-- ====================================================================
-- ========================== FLY PAGE ================================
-- ====================================================================
-- Fly system using FLY GUI V3 logic:
-- • TranslateBy(hum.MoveDirection) * flySpeedCount   → horizontal speed multiplier
-- • BodyGyro + BodyVelocity via RenderStepped        → smooth physics / tilt
-- • Up/Down buttons → direct CFrame vertical movement (held)

local flyCard    = Section(FlyPage, "✈️ FLY CONTROL")
local noclipCard = Section(FlyPage, "🔮 NOCLIP")

local flySpeedCount = 1  -- speed multiplier (1-20)

-- Speed counter row
local spdRow = Instance.new("Frame")
spdRow.Size             = UDim2.new(1, 0, 0, 26)
spdRow.BackgroundTransparency = 1
spdRow.Parent           = flyCard

local spdLbl = Label(spdRow, "Fly Speed:", 10, T.Text)
spdLbl.Size = UDim2.new(0.36, 0, 1, 0)

local flyMinB = Instance.new("TextButton")
flyMinB.Size             = UDim2.new(0, 24, 0, 20)
flyMinB.Position         = UDim2.new(0.38, 0, 0.5, -10)
flyMinB.BackgroundColor3 = T.SurfaceHi
flyMinB.Text             = "−"
flyMinB.TextColor3       = T.Text
flyMinB.TextSize         = 14
flyMinB.Font             = Enum.Font.GothamBold
flyMinB.AutoButtonColor  = false
Round(flyMinB, 5)
flyMinB.Parent = spdRow

local flySpdDisp = Instance.new("TextLabel")
flySpdDisp.Size             = UDim2.new(0, 30, 0, 20)
flySpdDisp.Position         = UDim2.new(0.38, 26, 0.5, -10)
flySpdDisp.BackgroundColor3 = T.Surface
flySpdDisp.Text             = "1"
flySpdDisp.TextColor3       = T.Primary
flySpdDisp.TextSize         = 11
flySpdDisp.Font             = Enum.Font.GothamBold
flySpdDisp.TextXAlignment   = Enum.TextXAlignment.Center
Round(flySpdDisp, 5)
flySpdDisp.Parent = spdRow

local flyPlusB = Instance.new("TextButton")
flyPlusB.Size             = UDim2.new(0, 24, 0, 20)
flyPlusB.Position         = UDim2.new(0.38, 58, 0.5, -10)
flyPlusB.BackgroundColor3 = T.SurfaceHi
flyPlusB.Text             = "+"
flyPlusB.TextColor3       = T.Text
flyPlusB.TextSize         = 14
flyPlusB.Font             = Enum.Font.GothamBold
flyPlusB.AutoButtonColor  = false
Round(flyPlusB, 5)
flyPlusB.Parent = spdRow

-- Up / Down row
local udRow = Instance.new("Frame")
udRow.Size             = UDim2.new(1, 0, 0, 26)
udRow.BackgroundTransparency = 1
udRow.Parent           = flyCard

local flyUpB = Instance.new("TextButton")
flyUpB.Size             = UDim2.new(0.49, 0, 0, 24)
flyUpB.BackgroundColor3 = T.SurfaceHi
flyUpB.Text             = "▲  UP"
flyUpB.TextColor3       = T.Text
flyUpB.TextSize         = 10
flyUpB.Font             = Enum.Font.GothamBold
flyUpB.AutoButtonColor  = false
Round(flyUpB, 6)
flyUpB.Parent = udRow

local flyDnB = Instance.new("TextButton")
flyDnB.Size             = UDim2.new(0.49, 0, 0, 24)
flyDnB.Position         = UDim2.new(0.51, 0, 0, 0)
flyDnB.BackgroundColor3 = T.SurfaceHi
flyDnB.Text             = "▼  DOWN"
flyDnB.TextColor3       = T.Text
flyDnB.TextSize         = 10
flyDnB.Font             = Enum.Font.GothamBold
flyDnB.AutoButtonColor  = false
Round(flyDnB, 6)
flyDnB.Parent = udRow

-- Main fly toggle
local flyTogBtn = Instance.new("TextButton")
flyTogBtn.Size             = UDim2.new(1, 0, 0, 28)
flyTogBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 62)
flyTogBtn.Text             = "✈️  FLY: OFF"
flyTogBtn.TextColor3       = T.Muted
flyTogBtn.TextSize         = 12
flyTogBtn.Font             = Enum.Font.GothamBold
flyTogBtn.AutoButtonColor  = false
Round(flyTogBtn, 8)
flyTogBtn.Parent = flyCard

-- Noclip
Toggle(noclipCard, "No Clip (pass through walls)", function(on)
    Config.Noclip = on
    if on then
        States.NoclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    else
        if States.NoclipConnection then States.NoclipConnection:Disconnect(); States.NoclipConnection = nil end
        if LocalPlayer.Character then
            for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
    end
end)

-- ---- FLY LOGIC (V3 style) ----
local function RestoreHumanoid(hum)
    for _, state in pairs({
        Enum.HumanoidStateType.Climbing, Enum.HumanoidStateType.FallingDown,
        Enum.HumanoidStateType.Flying,   Enum.HumanoidStateType.Freefall,
        Enum.HumanoidStateType.GettingUp,Enum.HumanoidStateType.Jumping,
        Enum.HumanoidStateType.Landed,   Enum.HumanoidStateType.Physics,
        Enum.HumanoidStateType.PlatformStanding, Enum.HumanoidStateType.Ragdoll,
        Enum.HumanoidStateType.Running,  Enum.HumanoidStateType.RunningNoPhysics,
        Enum.HumanoidStateType.Seated,   Enum.HumanoidStateType.StrafingNoPhysics,
        Enum.HumanoidStateType.Swimming,
    }) do pcall(function() hum:SetStateEnabled(state, true) end) end
    pcall(function() hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics) end)
end

local function DisableHumanoid(hum)
    for _, state in pairs({
        Enum.HumanoidStateType.Climbing, Enum.HumanoidStateType.FallingDown,
        Enum.HumanoidStateType.Flying,   Enum.HumanoidStateType.Freefall,
        Enum.HumanoidStateType.GettingUp,Enum.HumanoidStateType.Jumping,
        Enum.HumanoidStateType.Landed,   Enum.HumanoidStateType.Physics,
        Enum.HumanoidStateType.PlatformStanding, Enum.HumanoidStateType.Ragdoll,
        Enum.HumanoidStateType.Running,  Enum.HumanoidStateType.RunningNoPhysics,
        Enum.HumanoidStateType.Seated,   Enum.HumanoidStateType.StrafingNoPhysics,
        Enum.HumanoidStateType.Swimming,
    }) do pcall(function() hum:SetStateEnabled(state, false) end) end
    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Swimming) end)
end

local function StopFly()
    States.FlyActive = false
    States.tpwalking = false
    States.upHeld    = false
    States.downHeld  = false
    Tween(flyTogBtn, {BackgroundColor3 = Color3.fromRGB(45,45,62), TextColor3 = T.Muted}, 0.2)
    flyTogBtn.Text = "✈️  FLY: OFF"

    if States.FlyRenderConn then States.FlyRenderConn:Disconnect(); States.FlyRenderConn = nil end
    if States.FlyBodyGyro     and States.FlyBodyGyro.Parent     then States.FlyBodyGyro:Destroy()     end
    if States.FlyBodyVelocity and States.FlyBodyVelocity.Parent then States.FlyBodyVelocity:Destroy() end

    local chr = LocalPlayer.Character
    if chr then
        local hum = chr:FindFirstChildWhichIsA("Humanoid")
        if hum then
            RestoreHumanoid(hum)
            hum.PlatformStand = false
        end
        if chr:FindFirstChild("Animate") then chr.Animate.Disabled = false end
    end
end

local function StartFly()
    local chr = LocalPlayer.Character
    if not chr then return end
    local hum = chr:FindFirstChildWhichIsA("Humanoid")
    if not hum then return end

    States.FlyActive = true
    Tween(flyTogBtn, {BackgroundColor3 = T.Success, TextColor3 = Color3.new(1,1,1)}, 0.2)
    flyTogBtn.Text = "✈️  FLY: ON"

    -- Disable animations
    pcall(function() chr.Animate.Disabled = true end)
    pcall(function()
        for _, t in pairs(hum:GetPlayingAnimationTracks()) do t:AdjustSpeed(0) end
    end)

    DisableHumanoid(hum)
    hum.PlatformStand = true

    -- Horizontal movement via TranslateBy (V3 speed-multiplier style)
    States.tpwalking = true
    for i = 1, flySpeedCount do
        spawn(function()
            local hb = RunService.Heartbeat
            local c  = LocalPlayer.Character
            local h  = c and c:FindFirstChildWhichIsA("Humanoid")
            while States.FlyActive and States.tpwalking and hb:Wait() and c and h and h.Parent do
                if h.MoveDirection.Magnitude > 0 then
                    c:TranslateBy(h.MoveDirection)
                end
            end
        end)
    end

    -- BodyGyro + BodyVelocity for physics/tilt
    local rigType = hum.RigType
    local torso = (rigType == Enum.HumanoidRigType.R6) and chr:FindFirstChild("Torso") or chr:FindFirstChild("UpperTorso")
    if not torso then StopFly(); return end

    local bg = Instance.new("BodyGyro", torso)
    bg.P         = 9e4
    bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.cframe    = torso.CFrame
    States.FlyBodyGyro = bg

    local bv = Instance.new("BodyVelocity", torso)
    bv.velocity  = Vector3.new(0, 0.1, 0)
    bv.maxForce  = Vector3.new(9e9, 9e9, 9e9)
    States.FlyBodyVelocity = bv

    local ctrl     = {f=0,b=0,l=0,r=0}
    local lastctrl = {f=0,b=0,l=0,r=0}
    local spd      = 0
    local maxspeed = 50

    local renderEvt = (rigType == Enum.HumanoidRigType.R6) and RunService.RenderStepped or RunService.Heartbeat

    States.FlyRenderConn = renderEvt:Connect(function()
        if not States.FlyActive then return end

        -- Accelerate / decelerate
        if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
            spd = math.min(spd + 0.5 + spd/maxspeed, maxspeed)
        elseif spd ~= 0 then
            spd = math.max(spd - 1, 0)
        end

        local cam = workspace.CurrentCamera.CoordinateFrame

        if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
            bv.velocity = ((cam.lookVector * (ctrl.f+ctrl.b)) + ((cam * CFrame.new(ctrl.l+ctrl.r, (ctrl.f+ctrl.b)*0.2, 0)).p - cam.p)) * spd
            lastctrl = {f=ctrl.f, b=ctrl.b, l=ctrl.l, r=ctrl.r}
        elseif (ctrl.l+ctrl.r) == 0 and (ctrl.f+ctrl.b) == 0 and spd ~= 0 then
            bv.velocity = ((cam.lookVector * (lastctrl.f+lastctrl.b)) + ((cam * CFrame.new(lastctrl.l+lastctrl.r, (lastctrl.f+lastctrl.b)*0.2, 0)).p - cam.p)) * spd
        else
            bv.velocity = Vector3.new(0, 0, 0)
        end

        bg.cframe = cam * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*spd/maxspeed), 0, 0)
    end)
end

flyTogBtn.MouseButton1Click:Connect(function()
    if States.FlyActive then StopFly() else StartFly() end
end)

-- Speed +/-
flyPlusB.MouseButton1Click:Connect(function()
    flySpeedCount = math.min(flySpeedCount + 1, 20)
    flySpdDisp.Text = tostring(flySpeedCount)
    if States.FlyActive then StopFly(); wait(0.1); StartFly() end
end)
flyMinB.MouseButton1Click:Connect(function()
    if flySpeedCount <= 1 then
        flySpdDisp.Text = "MIN!"; wait(0.8); flySpdDisp.Text = "1"; return
    end
    flySpeedCount = flySpeedCount - 1
    flySpdDisp.Text = tostring(flySpeedCount)
    if States.FlyActive then StopFly(); wait(0.1); StartFly() end
end)

-- Up / Down vertical movement via CFrame (hold-to-move, V3 style)
flyUpB.MouseButton1Down:Connect(function()
    States.upHeld = true
    spawn(function()
        while States.upHeld do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, 0)
            end
            wait(0.04)
        end
    end)
end)
flyUpB.MouseButton1Up:Connect(function() States.upHeld = false end)
flyUpB.MouseLeave:Connect(function()   States.upHeld = false end)

flyDnB.MouseButton1Down:Connect(function()
    States.downHeld = true
    spawn(function()
        while States.downHeld do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -1, 0)
            end
            wait(0.04)
        end
    end)
end)
flyDnB.MouseButton1Up:Connect(function() States.downHeld = false end)
flyDnB.MouseLeave:Connect(function()   States.downHeld = false end)

-- ====================================================================
-- ========================== ESP PAGE ================================
-- ====================================================================
local espCard    = Section(ESPPage, "👁️ ESP PLAYERS")
local espV2Card  = Section(ESPPage, "👑 ESP V2  –  ADMIN ONLY")
local blkEspCard = Section(ESPPage, "🧱 BLOCK / ITEM ESP")

Toggle(espCard, "Enable Player ESP (name + distance)", function(on)
    Config.ESPPlayers = on
    if on then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local esp = Instance.new("BillboardGui")
                esp.Name         = p.Name.."_ESP"
                esp.AlwaysOnTop  = true
                esp.Size         = UDim2.new(0, 120, 0, 42)
                esp.StudsOffset  = Vector3.new(0, 2.5, 0)

                local bg = Instance.new("Frame")
                bg.Size                    = UDim2.new(1,0,1,0)
                bg.BackgroundColor3        = T.Primary
                bg.BackgroundTransparency  = 0.55
                Round(bg, 6)
                bg.Parent = esp

                local nm = Instance.new("TextLabel")
                nm.Size               = UDim2.new(1,0,0.55,0)
                nm.BackgroundTransparency = 1
                nm.Text               = p.Name
                nm.TextColor3         = Color3.new(1,1,1)
                nm.TextSize           = 12
                nm.Font               = Enum.Font.GothamBold
                nm.Parent             = bg

                local dt = Instance.new("TextLabel")
                dt.Size               = UDim2.new(1,0,0.45,0)
                dt.Position           = UDim2.new(0,0,0.55,0)
                dt.BackgroundTransparency = 1
                dt.Text               = "0m"
                dt.TextColor3         = Color3.fromRGB(210,210,210)
                dt.TextSize           = 10
                dt.Font               = Enum.Font.Gotham
                dt.Parent             = bg

                esp.Parent = States.ESPPlayerFolder

                spawn(function()
                    while esp.Parent and Config.ESPPlayers do
                        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            esp.Adornee = p.Character.HumanoidRootPart
                            dt.Text     = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude).."m"
                            esp.Enabled = true
                        else
                            esp.Enabled = false
                        end
                        wait(0.3)
                    end
                    if esp.Parent then esp:Destroy() end
                end)
            end
        end
    else
        States.ESPPlayerFolder:ClearAllChildren()
    end
end)

-- Admin ESP V2 (hidden until admin login)
local espV2LockLbl = Label(espV2Card, "🔒 Login as Admin to enable ESP V2", 9, T.Warning)
espV2LockLbl.Size = UDim2.new(1, 0, 0, 18)

local espV2Row = Instance.new("Frame")
espV2Row.Size             = UDim2.new(1, 0, 0, 26)
espV2Row.BackgroundTransparency = 1
espV2Row.Visible          = false    -- revealed after admin login
espV2Row.Parent           = espV2Card

local espV2Lbl = Label(espV2Row, "👑 ESP V2  (HP + Dist + Team + RGB)", 10, T.Admin, Enum.Font.GothamBold)
espV2Lbl.Size = UDim2.new(0.72, 0, 1, 0)

local espV2Btn = Instance.new("TextButton")
espV2Btn.Size             = UDim2.new(0, 42, 0, 18)
espV2Btn.Position         = UDim2.new(1, -42, 0.5, -9)
espV2Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 62)
espV2Btn.Text             = "OFF"
espV2Btn.TextColor3       = T.Muted
espV2Btn.TextSize         = 9
espV2Btn.Font             = Enum.Font.GothamBold
espV2Btn.AutoButtonColor  = false
Round(espV2Btn, 9)
espV2Btn.Parent = espV2Row

local espV2On = false

local function CreateAdminESP(p)
    if p == LocalPlayer then return end
    if States.AdminESPFolder:FindFirstChild(p.Name.."_AESP") then return end

    local esp = Instance.new("BillboardGui")
    esp.Name        = p.Name.."_AESP"
    esp.AlwaysOnTop = true
    esp.Size        = UDim2.new(0, 160, 0, 68)
    esp.StudsOffset = Vector3.new(0, 3.5, 0)
    esp.Parent      = States.AdminESPFolder

    local bg = Instance.new("Frame")
    bg.Size                   = UDim2.new(1,0,1,0)
    bg.BackgroundColor3       = T.Admin
    bg.BackgroundTransparency = 0.25
    Round(bg, 10)
    bg.Parent = esp

    local nm = Instance.new("TextLabel")
    nm.Size = UDim2.new(1,0,0.22,0); nm.BackgroundTransparency = 1
    nm.Text = p.Name; nm.TextColor3 = Color3.new(1,1,1)
    nm.TextSize = 13; nm.Font = Enum.Font.GothamBlack; nm.Parent = bg

    local hpBg = Instance.new("Frame")
    hpBg.Size = UDim2.new(0.9,0,0,5); hpBg.Position = UDim2.new(0.05,0,0.28,0)
    hpBg.BackgroundColor3 = Color3.fromRGB(40,40,55); hpBg.BorderSizePixel = 0
    Round(hpBg, 3); hpBg.Parent = bg

    local hpFill = Instance.new("Frame")
    hpFill.Size = UDim2.new(1,0,1,0); hpFill.BackgroundColor3 = T.Success
    hpFill.BorderSizePixel = 0; Round(hpFill, 3); hpFill.Parent = hpBg

    local hpT = Instance.new("TextLabel")
    hpT.Size = UDim2.new(1,0,0.2,0); hpT.Position = UDim2.new(0,0,0.42,0)
    hpT.BackgroundTransparency = 1; hpT.TextSize = 10; hpT.Font = Enum.Font.Gotham
    hpT.TextColor3 = T.Text; hpT.Parent = bg

    local dT = Instance.new("TextLabel")
    dT.Size = UDim2.new(1,0,0.18,0); dT.Position = UDim2.new(0,0,0.64,0)
    dT.BackgroundTransparency = 1; dT.TextSize = 9; dT.Font = Enum.Font.Gotham
    dT.TextColor3 = T.Muted; dT.Parent = bg

    local tmT = Instance.new("TextLabel")
    tmT.Size = UDim2.new(1,0,0.16,0); tmT.Position = UDim2.new(0,0,0.83,0)
    tmT.BackgroundTransparency = 1; tmT.TextSize = 9; tmT.Font = Enum.Font.Gotham
    tmT.TextColor3 = T.Warning; tmT.Parent = bg

    -- RGB name cycle
    spawn(function()
        local h = 0
        while esp.Parent and espV2On do
            h = (h + 0.03) % 1
            nm.TextColor3 = Color3.fromHSV(h, 1, 1)
            wait(0.05)
        end
    end)

    spawn(function()
        while esp.Parent and espV2On do
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local hm = p.Character.Humanoid
                local d  = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                esp.Adornee    = p.Character.HumanoidRootPart
                hpFill.Size    = UDim2.new(math.clamp(hm.Health/hm.MaxHealth, 0, 1), 0, 1, 0)
                hpT.Text       = string.format("HP: %d/%d", math.floor(hm.Health), math.floor(hm.MaxHealth))
                dT.Text        = math.floor(d).."m away"
                tmT.Text       = "Team: "..(p.Team and p.Team.Name or "None")
                esp.Enabled    = true
            else
                esp.Enabled    = false
            end
            wait(0.2)
        end
        if esp.Parent then esp:Destroy() end
    end)
end

espV2Btn.MouseButton1Click:Connect(function()
    if not Config.IsAdmin then
        espV2LockLbl.Text      = "⚠️  Enter admin password first!"
        espV2LockLbl.TextColor3 = T.Error
        wait(2)
        espV2LockLbl.Text      = "🔒 Login as Admin to enable ESP V2"
        espV2LockLbl.TextColor3 = T.Warning
        return
    end
    espV2On = not espV2On
    espV2Btn.Text = espV2On and "ON" or "OFF"
    Tween(espV2Btn, {BackgroundColor3 = espV2On and T.Admin or Color3.fromRGB(45,45,62)}, 0.18)
    Tween(espV2Btn, {TextColor3 = espV2On and Color3.new(0,0,0) or T.Muted}, 0.18)
    Config.ESPAdmin = espV2On
    if espV2On then
        for _, p in pairs(Players:GetPlayers()) do CreateAdminESP(p) end
        Players.PlayerAdded:Connect(function(p) if espV2On then wait(1); CreateAdminESP(p) end end)
    else
        States.AdminESPFolder:ClearAllChildren()
    end
end)

-- Block ESP
local BlockKW = {"block","mission","quest","item","coin","money","cash","gem","collect","chest","reward","target","objective","pickup","token","star"}
local function IsBlockObj(obj)
    local n = obj.Name:lower()
    for _, kw in ipairs(BlockKW) do if n:find(kw) then return true end end
    return false
end
local function MakeBlockESP(obj)
    local key = obj.Name.."_"..tostring(obj:GetDebugId())
    if States.ESPBlockFolder:FindFirstChild(key) then return end
    local esp = Instance.new("BillboardGui")
    esp.Name = key; esp.AlwaysOnTop = true; esp.Size = UDim2.new(0,115,0,38); esp.StudsOffset = Vector3.new(0,1.5,0)
    local bg = Instance.new("Frame"); bg.Size = UDim2.new(1,0,1,0); bg.BackgroundColor3 = T.Warning; bg.BackgroundTransparency = 0.5; Round(bg,6); bg.Parent = esp
    local t1 = Instance.new("TextLabel"); t1.Size = UDim2.new(1,0,0.55,0); t1.BackgroundTransparency = 1; t1.Text = obj.Name; t1.TextColor3 = Color3.new(1,1,1); t1.TextSize = 10; t1.Font = Enum.Font.GothamBold; t1.Parent = bg
    local t2 = Instance.new("TextLabel"); t2.Size = UDim2.new(1,0,0.45,0); t2.Position = UDim2.new(0,0,0.55,0); t2.BackgroundTransparency = 1; t2.Text = "0m"; t2.TextColor3 = T.Muted; t2.TextSize = 9; t2.Font = Enum.Font.Gotham; t2.Parent = bg
    esp.Parent = States.ESPBlockFolder
    spawn(function()
        while esp.Parent and Config.ESPBlocks do
            if obj.Parent and obj:IsA("BasePart") then
                esp.Adornee = obj
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    t2.Text = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - obj.Position).Magnitude).."m"
                end
                esp.Enabled = true
            else
                esp:Destroy(); break
            end
            wait(0.5)
        end
        if esp.Parent then esp:Destroy() end
    end)
end

Toggle(blkEspCard, "Scan & highlight blocks / items", function(on)
    Config.ESPBlocks = on
    if on then
        for _, o in pairs(workspace:GetDescendants()) do if IsBlockObj(o) then MakeBlockESP(o) end end
        workspace.DescendantAdded:Connect(function(o) if Config.ESPBlocks and IsBlockObj(o) then wait(0.3); MakeBlockESP(o) end end)
    else
        States.ESPBlockFolder:ClearAllChildren()
    end
end)

-- ====================================================================
-- ======================== TELEPORT PAGE ============================
-- ====================================================================
local tpCard = Section(TPPage, "🎯 TELEPORT")
local tpList = PlayerList(tpCard, 80)

Btn(tpCard, "Teleport to Selected Player", "primary", function()
    local sel = tpList:GetSelected()
    if sel and sel.Character and sel.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = sel.Character.HumanoidRootPart.CFrame
    end
end)

Toggle(tpCard, "Follow Selected Player", function(on)
    Config.AutoFollow = on
    States.FollowingPlayer = on and tpList:GetSelected() or nil
    if on then
        spawn(function()
            while Config.AutoFollow and States.FollowingPlayer do
                if States.FollowingPlayer.Character and States.FollowingPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = States.FollowingPlayer.Character.HumanoidRootPart.CFrame
                end
                wait(0.04)
            end
        end)
    end
end)

-- ====================================================================
-- ========================== GOD PAGE ================================
-- ====================================================================
local godCard = Section(GodPage, "🛡️ GOD MODE")

local godModeTypeBtn = Instance.new("TextButton")
godModeTypeBtn.Size             = UDim2.new(1, 0, 0, 24)
godModeTypeBtn.BackgroundColor3 = T.SurfaceHi
godModeTypeBtn.Text             = "Mode: Gen1  (auto-heal)"
godModeTypeBtn.TextColor3       = T.Text
godModeTypeBtn.TextSize         = 10
godModeTypeBtn.Font             = Enum.Font.GothamBold
godModeTypeBtn.AutoButtonColor  = false
Round(godModeTypeBtn, 6)
godModeTypeBtn.Parent = godCard
godModeTypeBtn.MouseButton1Click:Connect(function()
    Config.GodModeType = Config.GodModeType == "Gen1" and "Gen2" or "Gen1"
    godModeTypeBtn.Text = Config.GodModeType == "Gen1" and "Mode: Gen1  (auto-heal)" or "Mode: Gen2  (immortal ∞)"
end)

Toggle(godCard, "God Mode", function(on)
    Config.GodMode = on
    if States.GodConnection then States.GodConnection:Disconnect(); States.GodConnection = nil end
    if on then
        States.GodConnection = RunService.Heartbeat:Connect(function()
            if not LocalPlayer.Character then return end
            local h = LocalPlayer.Character:FindFirstChild("Humanoid"); if not h then return end
            if Config.GodModeType == "Gen1" then h.Health = h.MaxHealth
            else h.MaxHealth = math.huge; h.Health = math.huge end
        end)
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            pcall(function() LocalPlayer.Character.Humanoid.MaxHealth = 100 end)
        end
    end
end)

Toggle(godCard, "Auto Heal (every 0.2s)", function(on)
    Config.AutoHeal = on
    spawn(function()
        while Config.AutoHeal do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                local h = LocalPlayer.Character.Humanoid; h.Health = h.MaxHealth
            end
            wait(0.2)
        end
    end)
end)

Btn(godCard, "Heal Now", "success", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
    end
end)

-- ====================================================================
-- ========================== WORLD PAGE ==============================
-- ====================================================================
local blkCard = Section(WorldPage, "🧱 BLOCK SPAWNER")

local selBlockType  = "Part"
local selMaterial   = Enum.Material.SmoothPlastic
local selColor      = BrickColor.new("Bright blue")
local blkSize       = 5

-- Inline dropdown builder for this page (simple version)
local function SimpleDropdown(parent, label, opts, onChange)
    local frame = Instance.new("Frame")
    frame.Size             = UDim2.new(1, 0, 0, 0)
    frame.AutomaticSize    = Enum.AutomaticSize.Y
    frame.BackgroundTransparency = 1
    frame.Parent           = parent

    local row = Instance.new("TextButton")
    row.Size             = UDim2.new(1, 0, 0, 24)
    row.BackgroundColor3 = T.SurfaceHi
    row.Text             = label..": "..opts[1].." ▾"
    row.TextColor3       = T.Text
    row.TextSize         = 10
    row.Font             = Enum.Font.GothamBold
    row.AutoButtonColor  = false
    Round(row, 6)
    row.Parent = frame

    local list = Instance.new("Frame")
    list.Size             = UDim2.new(1, 0, 0, 0)
    list.BackgroundColor3 = T.Surface
    list.BorderSizePixel  = 0
    list.ClipsDescendants = true
    list.ZIndex           = 10
    Round(list, 5)
    list.Parent = frame

    local ll = Instance.new("UIListLayout"); ll.Parent = list

    local open = false
    for _, opt in ipairs(opts) do
        local ob = Instance.new("TextButton")
        ob.Size             = UDim2.new(1,0,0,22)
        ob.BackgroundColor3 = T.Surface
        ob.Text             = opt
        ob.TextColor3       = T.Text
        ob.TextSize         = 9
        ob.Font             = Enum.Font.Gotham
        ob.BorderSizePixel  = 0
        ob.AutoButtonColor  = false
        ob.ZIndex           = 11
        ob.Parent           = list
        ob.MouseButton1Click:Connect(function()
            row.Text = label..": "..opt.." ▾"
            open = false; Tween(list, {Size = UDim2.new(1,0,0,0)}, 0.15)
            if onChange then onChange(opt) end
        end)
    end

    row.MouseButton1Click:Connect(function()
        open = not open
        Tween(list, {Size = UDim2.new(1,0,0, open and #opts*22 or 0)}, 0.18)
    end)
end

SimpleDropdown(blkCard, "Block Type", {"Part","WedgePart","CornerWedgePart","TrussPart","SpawnLocation"}, function(v) selBlockType = v end)
SimpleDropdown(blkCard, "Material",   {"SmoothPlastic","Neon","Glass","Wood","Granite","DiamondPlate","Metal","ForceField"}, function(v) selMaterial = Enum.Material[v] end)
SimpleDropdown(blkCard, "Color",      {"Bright red","Bright blue","Bright green","Bright yellow","White","Black","Hot pink","Neon orange","Medium stone grey"}, function(v) selColor = BrickColor.new(v) end)
Slider(blkCard, "Block Size", 1, 50, 5, function(v) blkSize = v end)

Btn(blkCard, "🧱 Spawn Block in Front", "primary", function()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp  = LocalPlayer.Character.HumanoidRootPart
    local part = Instance.new(selBlockType)
    part.Size        = Vector3.new(blkSize, blkSize, blkSize)
    part.BrickColor  = selColor
    part.Material    = selMaterial
    part.CFrame      = hrp.CFrame * CFrame.new(0, -hrp.Size.Y/2 - blkSize/2, -(blkSize + 4))
    part.Anchored    = true
    part.Parent      = workspace
    if selMaterial == Enum.Material.Neon then
        local pl = Instance.new("PointLight"); pl.Brightness = 5; pl.Range = 20; pl.Color = part.BrickColor.Color; pl.Parent = part
    end
end)

Btn(blkCard, "🗑️ Remove Last Spawned Block", "danger", function()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("BasePart") and obj.Anchored and obj.Name ~= "Baseplate" and not obj:FindFirstAncestorOfClass("Model") then
            obj:Destroy(); break
        end
    end
end)

Btn(blkCard, "💥 Clear All Spawned Blocks", "danger", function()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("BasePart") and obj.Anchored and obj.Name ~= "Baseplate" and not obj:FindFirstAncestorOfClass("Model") then
            obj:Destroy()
        end
    end
end)

-- ====================================================================
-- ========================= AVATAR PAGE ==============================
-- ====================================================================
local avaCard   = Section(AvaPage, "👤 COPY AVATAR")
local avaSelP   = nil
local avaStatus = Label(avaCard, "Select a player to copy their look.", 9, T.Muted)
avaStatus.Size  = UDim2.new(1, 0, 0, 16)

local avaListObj = PlayerList(avaCard, 78, function(p) avaSelP = p end)

Btn(avaCard, "👤 Copy Avatar", "primary", function()
    if not avaSelP then
        avaStatus.Text = "⚠️  No player selected!"; avaStatus.TextColor3 = T.Error
        wait(2); avaStatus.Text = "Select a player to copy their look."; avaStatus.TextColor3 = T.Muted; return
    end
    avaStatus.Text = "⏳ Copying "..avaSelP.Name.."..."; avaStatus.TextColor3 = T.Warning

    local ok = false
    -- Method 1: get applied description from target character
    pcall(function()
        if avaSelP.Character and avaSelP.Character:FindFirstChild("Humanoid") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local desc = avaSelP.Character.Humanoid:GetAppliedDescription()
            LocalPlayer.Character.Humanoid:ApplyDescription(desc)
            ok = true
        end
    end)
    -- Method 2: fetch via API
    if not ok then
        pcall(function()
            local desc = Players:GetHumanoidDescriptionFromUserId(avaSelP.UserId)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:ApplyDescription(desc)
                ok = true
            end
        end)
    end

    avaStatus.Text      = ok and "✅ Copied "..avaSelP.Name.."!" or "❌ Failed – game may restrict this"
    avaStatus.TextColor3 = ok and T.Success or T.Error
    wait(3); avaStatus.Text = "Select a player to copy their look."; avaStatus.TextColor3 = T.Muted
end)

Btn(avaCard, "🔄 Restore My Avatar", "normal", function()
    pcall(function()
        local desc = Players:GetHumanoidDescriptionFromUserId(LocalPlayer.UserId)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:ApplyDescription(desc)
        end
    end)
    avaStatus.Text = "✅ Avatar restored!"; avaStatus.TextColor3 = T.Success
    wait(2); avaStatus.Text = "Select a player to copy their look."; avaStatus.TextColor3 = T.Muted
end)

-- ====================================================================
-- ========================= PRESETS PAGE =============================
-- ====================================================================
local saveCard   = Section(PrePage, "💾 SAVE PRESET")
local Presets    = {}

local preNameBox = Instance.new("TextBox")
preNameBox.Size             = UDim2.new(1, 0, 0, 24)
preNameBox.BackgroundColor3 = T.SurfaceHi
preNameBox.PlaceholderText  = "Preset name…"
preNameBox.Text             = ""
preNameBox.TextColor3       = T.Text
preNameBox.TextSize         = 10
preNameBox.Font             = Enum.Font.Gotham
preNameBox.ClearTextOnFocus = false
Round(preNameBox, 5)
preNameBox.Parent = saveCard

local preListSF = Instance.new("ScrollingFrame")
preListSF.Size                 = UDim2.new(1, 0, 0, 72)
preListSF.BackgroundColor3     = T.SurfaceHi
preListSF.BackgroundTransparency = 0.45
preListSF.BorderSizePixel      = 0
preListSF.ScrollBarThickness   = 3
preListSF.CanvasSize           = UDim2.new(0, 0, 0, 0)
Round(preListSF, 6)
preListSF.Parent = saveCard
local preLL = Instance.new("UIListLayout"); preLL.Padding = UDim.new(0,3); preLL.Parent = preListSF

local exportBox = Instance.new("TextBox")
exportBox.Size              = UDim2.new(1, 0, 0, 46)
exportBox.BackgroundColor3  = T.NavBg
exportBox.PlaceholderText   = "Exported code will appear here…"
exportBox.Text              = ""
exportBox.TextColor3        = T.Primary
exportBox.TextSize          = 8
exportBox.Font              = Enum.Font.Code
exportBox.MultiLine         = true
exportBox.TextXAlignment    = Enum.TextXAlignment.Left
exportBox.TextYAlignment    = Enum.TextYAlignment.Top
exportBox.ClearTextOnFocus  = false
Round(exportBox, 5)
exportBox.Parent = saveCard

local function RefreshPresets()
    for _, c in pairs(preListSF:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    local n = 0
    for name, data in pairs(Presets) do
        n = n + 1
        local row = Instance.new("Frame"); row.Size = UDim2.new(1,-6,0,24); row.Position = UDim2.new(0,3,0,0); row.BackgroundColor3 = T.Surface; row.BorderSizePixel = 0; Round(row,5); row.Parent = preListSF
        local nl = Label(row, name, 9, T.Text, Enum.Font.GothamBold); nl.Size = UDim2.new(0.5,0,1,0); nl.Position = UDim2.new(0,5,0,0)

        local function SmallBtn(parent, txt, col, xOff)
            local b = Instance.new("TextButton"); b.Size = UDim2.new(0,36,0,18); b.Position = UDim2.new(1,xOff,0.5,-9); b.BackgroundColor3 = col; b.Text = txt; b.TextColor3 = Color3.new(col == T.Admin and 0 or 1,col == T.Admin and 0 or 1,col == T.Admin and 0 or 1); b.TextSize = 8; b.Font = Enum.Font.GothamBold; b.AutoButtonColor = false; Round(b,4); b.Parent = parent; return b
        end

        SmallBtn(row, "Load",   T.Primary,  -118).MouseButton1Click:Connect(function()
            Config.Speed = data.Speed or 16; Config.JumpPower = data.JumpPower or 50
            workspace.Gravity = data.Gravity or 196.2
            flySpeedCount = data.FlySpeed or 1; flySpdDisp.Text = tostring(flySpeedCount)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                local h = LocalPlayer.Character.Humanoid; h.WalkSpeed = Config.Speed
                if h.UseJumpPower then h.JumpPower = Config.JumpPower else h.JumpHeight = Config.JumpPower/10 end
            end
        end)
        SmallBtn(row, "Export", T.Warning,  -80).MouseButton1Click:Connect(function()
            exportBox.Text = string.format("-- Preset: %s\nConfig.Speed=%d\nConfig.JumpPower=%d\nConfig.FlySpeed=%d\nworkspace.Gravity=%g", name, data.Speed or 16, data.JumpPower or 50, data.FlySpeed or 1, data.Gravity or 196.2)
        end)
        SmallBtn(row, "✕",     T.Error,    -40).MouseButton1Click:Connect(function()
            Presets[name] = nil; RefreshPresets()
        end)
    end
    preListSF.CanvasSize = UDim2.new(0, 0, 0, n * 27)
end

Btn(saveCard, "💾 Save Current Settings", "primary", function()
    local nm = preNameBox.Text ~= "" and preNameBox.Text or ("Preset "..tostring(os.time()))
    Presets[nm] = {Speed=Config.Speed, JumpPower=Config.JumpPower, FlySpeed=flySpeedCount, Gravity=workspace.Gravity}
    preNameBox.Text = ""; RefreshPresets()
end)

local importBox = Instance.new("TextBox")
importBox.Size              = UDim2.new(1, 0, 0, 40)
importBox.BackgroundColor3  = T.NavBg
importBox.PlaceholderText   = "Paste exported code here to import…"
importBox.Text              = ""
importBox.TextColor3        = T.Text
importBox.TextSize          = 8
importBox.Font              = Enum.Font.Code
importBox.MultiLine         = true
importBox.TextXAlignment    = Enum.TextXAlignment.Left
importBox.TextYAlignment    = Enum.TextYAlignment.Top
importBox.ClearTextOnFocus  = false
Round(importBox, 5)
importBox.Parent = saveCard

Btn(saveCard, "📥 Import from Code", "normal", function()
    local code = importBox.Text
    local nm    = code:match("-- Preset: ([^\n]+)")
    if nm then
        Presets[nm] = {
            Speed     = tonumber(code:match("Config%.Speed=(%d+)"))     or 16,
            JumpPower = tonumber(code:match("Config%.JumpPower=(%d+)")) or 50,
            FlySpeed  = tonumber(code:match("Config%.FlySpeed=(%d+)"))  or 1,
            Gravity   = tonumber(code:match("workspace%.Gravity=([%d%.]+)")) or 196.2,
        }
        RefreshPresets(); importBox.Text = ""
    end
end)

-- ====================================================================
-- ========================= ADMIN PAGE ===============================
-- ====================================================================
local adminCard   = Section(AdminPage, "🔐 ADMIN LOGIN")
local adminStatus = Label(adminCard, "🔒 Not authenticated", 9, T.Muted)
adminStatus.Size  = UDim2.new(1, 0, 0, 16)

local pwBox = Instance.new("TextBox")
pwBox.Size             = UDim2.new(1, 0, 0, 26)
pwBox.BackgroundColor3 = T.NavBg
pwBox.PlaceholderText  = "Enter password…"
pwBox.Text             = ""
pwBox.TextColor3       = T.Text
pwBox.TextSize         = 11
pwBox.Font             = Enum.Font.GothamBold
pwBox.ClearTextOnFocus = false
Round(pwBox, 6)
pwBox.Parent = adminCard

Btn(adminCard, "🔓 Unlock Admin Mode", "admin", function()
    if pwBox.Text == "GEN1GO" then
        Config.IsAdmin        = true
        adminStatus.Text      = "✅ Admin Mode Active!"
        adminStatus.TextColor3= T.Success
        pwBox.Text            = ""
        -- Reveal ESP V2 toggle
        espV2Row.Visible        = true
        espV2LockLbl.Text       = "✅ Admin verified – ESP V2 available"
        espV2LockLbl.TextColor3 = T.Success
        -- Billboard over head
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
            local bill = Instance.new("BillboardGui"); bill.Name = "AdminBadge"; bill.AlwaysOnTop = true
            bill.Size = UDim2.new(0,170,0,48); bill.StudsOffset = Vector3.new(0,4,0)
            bill.Adornee = LocalPlayer.Character.Head; bill.Parent = LocalPlayer.Character.Head
            local bg = Instance.new("Frame"); bg.Size = UDim2.new(1,0,1,0); bg.BackgroundColor3 = Color3.new(0,0,0); bg.BackgroundTransparency = 0.4; Round(bg,10); bg.Parent = bill
            local lbl1 = Instance.new("TextLabel"); lbl1.Size = UDim2.new(1,0,0.6,0); lbl1.BackgroundTransparency = 1; lbl1.Text = "👑  ADMIN / OWNER"; lbl1.TextColor3 = T.Admin; lbl1.TextSize = 15; lbl1.Font = Enum.Font.GothamBlack; lbl1.Parent = bg
            local lbl2 = Instance.new("TextLabel"); lbl2.Size = UDim2.new(1,0,0.4,0); lbl2.Position = UDim2.new(0,0,0.6,0); lbl2.BackgroundTransparency = 1; lbl2.Text = "AP-NEXTGEN v9"; lbl2.TextColor3 = T.Muted; lbl2.TextSize = 10; lbl2.Font = Enum.Font.Gotham; lbl2.Parent = bg
            spawn(function() local h=0; while bill.Parent do h=(h+0.02)%1; lbl1.TextColor3=Color3.fromHSV(h,1,1); wait(0.05) end end)
        end
        StarterGui:SetCore("SendNotification", {Title="ADMIN MODE", Text="Welcome, Developer!", Duration=5})
    else
        pwBox.Text             = ""
        adminStatus.Text       = "❌ Wrong password!"
        adminStatus.TextColor3 = T.Error
        Tween(pwBox, {BackgroundColor3 = T.Error}, 0.14)
        wait(0.5); Tween(pwBox, {BackgroundColor3 = T.NavBg}, 0.14)
        wait(1.5); adminStatus.Text = "🔒 Not authenticated"; adminStatus.TextColor3 = T.Muted
    end
end)

-- ====================================================================
-- ========================= UTILITY PAGE ============================
-- ====================================================================
local utilCard   = Section(UtilPage, "⚙️ UTILITIES")
local serverCard = Section(UtilPage, "🌐 SERVER")

Toggle(utilCard, "Full Bright", function(on)
    Config.FullBright = on
    if on then
        States.BrightnessConnection = RunService.RenderStepped:Connect(function()
            Lighting.Brightness    = 10
            Lighting.GlobalShadows = false
            Lighting.Ambient       = Color3.new(1,1,1)
            Lighting.OutdoorAmbient= Color3.new(1,1,1)
        end)
    else
        if States.BrightnessConnection then States.BrightnessConnection:Disconnect(); States.BrightnessConnection = nil end
        Lighting.Brightness    = 2
        Lighting.GlobalShadows = true
    end
end)

Toggle(utilCard, "Anti-AFK", function(on)
    Config.AntiAFK = on
    if on then
        local conn = LocalPlayer.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
            wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
        end)
        table.insert(States.Connections, conn)
    end
end)

Toggle(utilCard, "Unlock Camera Zoom", function(on)
    Config.ZoomUnlock = on
    if on then
        LocalPlayer.CameraMaxZoomDistance = 999999
        LocalPlayer.CameraMinZoomDistance = 0.1
    else
        LocalPlayer.CameraMaxZoomDistance = 128
        LocalPlayer.CameraMinZoomDistance = 0.5
    end
end)

Toggle(utilCard, "FPS Boost (reduce quality)", function(on)
    Config.FPSBoost = on
    if on then
        settings().Rendering.QualityLevel = 1
        Lighting.GlobalShadows = false
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") then v.Enabled = false end
        end
    else
        settings().Rendering.QualityLevel = 10
        Lighting.GlobalShadows = true
    end
end)

Btn(serverCard, "Rejoin This Server", "primary", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

Btn(serverCard, "Server Hop (find new server)", "normal", function()
    pcall(function()
        local data = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        for _, sv in pairs(data.data) do
            if sv.playing < sv.maxPlayers and sv.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, sv.id); break
            end
        end
    end)
end)

-- ====================================================================
-- ==================== ORB / MINIMIZE / CLOSE =======================
-- ====================================================================
local OrbBtn = Instance.new("TextButton")
OrbBtn.Size             = UDim2.new(0, 44, 0, 44)
OrbBtn.Position         = UDim2.new(0, 12, 0.5, -22)
OrbBtn.BackgroundColor3 = T.Primary
OrbBtn.Text             = "AP"
OrbBtn.TextColor3       = Color3.new(1, 1, 1)
OrbBtn.TextSize         = 14
OrbBtn.Font             = Enum.Font.GothamBlack
OrbBtn.Visible          = false
OrbBtn.ZIndex           = 100
OrbBtn.Active           = true
OrbBtn.Draggable        = true
OrbBtn.AutoButtonColor  = false
Round(OrbBtn, 22)
Stroke(OrbBtn, T.Primary, 2)
OrbBtn.Parent = SG

MinBtn.MouseButton1Click:Connect(function()
    Tween(MF, {Size = UDim2.new(0, 450, 0, 0)}, 0.22)
    wait(0.22); MF.Visible = false; OrbBtn.Visible = true
end)

OrbBtn.MouseButton1Click:Connect(function()
    OrbBtn.Visible = false; MF.Visible = true
    Tween(MF, {Size = UDim2.new(0, 450, 0, 290)}, 0.3, Enum.EasingStyle.Back)
end)

CloseBtn.MouseButton1Click:Connect(function()
    States.FlyActive = false
    Config.Flying    = false
    Config.Noclip    = false
    Config.GodMode   = false
    Cleanup()
    SG:Destroy()
    pcall(function() OrbBtn:Destroy() end)
end)

-- ====================================================================
-- ==================== CHARACTER RE-ADDED ===========================
-- ====================================================================
LocalPlayer.CharacterAdded:Connect(function(chr)
    wait(0.7)
    States.FlyActive = false; States.tpwalking = false
    if chr:FindFirstChild("Animate") then chr.Animate.Disabled = false end
    local hum = chr:FindFirstChildWhichIsA("Humanoid")
    if hum then
        hum.WalkSpeed    = Config.Speed
        hum.PlatformStand = false
        if hum.UseJumpPower then hum.JumpPower = Config.JumpPower else hum.JumpHeight = Config.JumpPower/10 end
    end
    flyTogBtn.Text = "✈️  FLY: OFF"
    Tween(flyTogBtn, {BackgroundColor3 = Color3.fromRGB(45,45,62), TextColor3 = T.Muted}, 0.1)
end)

-- ====================================================================
-- ====================== OPENING ANIMATION ==========================
-- ====================================================================
MF.Size = UDim2.new(0, 0, 0, 0)
SwitchPage("Dash")
wait(0.1)
Tween(MF, {Size = UDim2.new(0, 450, 0, 290)}, 0.5, Enum.EasingStyle.Back)

StarterGui:SetCore("SendNotification", {
    Title    = "AP-NEXTGEN v9.0 ULTRA",
    Text     = "Hub loaded! by APTECH",
    Duration = 4,
})

print("✅ AP-NEXTGEN v9.0 ULTRA Loaded!")
print("Fly V3 ✓ | Admin ESP V2 ✓ | Block Spawner ✓ | Copy Avatar ✓ | Presets ✓")
