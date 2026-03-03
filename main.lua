-- ============================================
-- Overlay Panel v5 | Bug Fixed
-- Fix: UICorner chaining + TLS bypass
-- ============================================

local Players          = game:GetService("Players")
local CoreGui          = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer      = Players.LocalPlayer

-- ============================================
-- DETEKSI HTTP EXECUTOR
-- ============================================
local httpFunc = nil

if syn and syn.request then
    httpFunc = syn.request
    print("[OK] syn.request")
elseif http_request then
    httpFunc = http_request
    print("[OK] http_request")
elseif http and http.request then
    httpFunc = http.request
    print("[OK] http.request")
elseif request then
    httpFunc = request
    print("[OK] request")
else
    warn("[WARN] Tidak ada HTTP func!")
end

-- Cek Drawing.Image
local hasDrawImg = pcall(function()
    local t = Drawing.new("Image")
    t:Remove()
end)
print("[OK] Drawing.Image: " .. tostring(hasDrawImg))

-- ============================================
-- HAPUS GUI LAMA
-- ============================================
pcall(function()
    local old = CoreGui:FindFirstChild("OvUI5")
    if old then old:Destroy() end
end)
pcall(function()
    local old = LocalPlayer.PlayerGui:FindFirstChild("OvUI5")
    if old then old:Destroy() end
end)

-- ============================================
-- SCREEN GUI
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "OvUI5"
ScreenGui.ResetOnSpawn   = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder   = 9999

local ok = pcall(function() ScreenGui.Parent = CoreGui end)
if not ok then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ============================================
-- HELPER: BUAT CORNER (TANPA CHAIN)
-- ============================================
local function addCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent  -- parent terpisah, tidak di-chain
end

local function addStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color     = color or Color3.fromRGB(255, 140, 0)
    s.Thickness = thickness or 2
    s.Parent    = parent
end

-- ============================================
-- PANEL
-- ============================================
local Panel = Instance.new("Frame")
Panel.Name                   = "Panel"
Panel.Size                   = UDim2.new(0, 280, 0, 370)
Panel.Position               = UDim2.new(0, 20, 0.5, -185)
Panel.BackgroundColor3       = Color3.fromRGB(14, 14, 14)
Panel.BackgroundTransparency = 0
Panel.BorderSizePixel        = 0
Panel.ZIndex                 = 100
Panel.Active                 = true
Panel.Parent                 = ScreenGui
addCorner(Panel, 12)
addStroke(Panel, Color3.fromRGB(255, 140, 0), 2)

-- ============================================
-- TITLE BAR
-- ============================================
local TitleBar = Instance.new("Frame")
TitleBar.Size             = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
TitleBar.BorderSizePixel  = 0
TitleBar.ZIndex           = 101
TitleBar.Parent           = Panel
addCorner(TitleBar, 12)

-- Fix rounded bottom title
local TitleFix = Instance.new("Frame")
TitleFix.Size             = UDim2.new(1, 0, 0.5, 0)
TitleFix.Position         = UDim2.new(0, 0, 0.5, 0)
TitleFix.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
TitleFix.BorderSizePixel  = 0
TitleFix.ZIndex           = 101
TitleFix.Parent           = TitleBar

local TitleLbl = Instance.new("TextLabel")
TitleLbl.Text               = "🖼️ Overlay Panel v5"
TitleLbl.Size               = UDim2.new(1, -44, 1, 0)
TitleLbl.Position           = UDim2.new(0, 12, 0, 0)
TitleLbl.BackgroundTransparency = 1
TitleLbl.TextColor3         = Color3.fromRGB(255, 255, 255)
TitleLbl.TextSize           = 14
TitleLbl.Font               = Enum.Font.GothamBold
TitleLbl.TextXAlignment     = Enum.TextXAlignment.Left
TitleLbl.ZIndex             = 102
TitleLbl.Parent             = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text             = "✕"
CloseBtn.Size             = UDim2.new(0, 28, 0, 28)
CloseBtn.Position         = UDim2.new(1, -34, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize         = 13
CloseBtn.Font             = Enum.Font.GothamBold
CloseBtn.BorderSizePixel  = 0
CloseBtn.ZIndex           = 103
CloseBtn.Parent           = TitleBar
addCorner(CloseBtn, 6)

-- ============================================
-- HELPER TOMBOL & LABEL
-- ============================================
local function makeBtn(txt, y, col)
    local b = Instance.new("TextButton")
    b.Text             = txt
    b.Size             = UDim2.new(1, -20, 0, 42)
    b.Position         = UDim2.new(0, 10, 0, y)
    b.BackgroundColor3 = col
    b.TextColor3       = Color3.fromRGB(255, 255, 255)
    b.TextSize         = 13
    b.Font             = Enum.Font.GothamBold
    b.BorderSizePixel  = 0
    b.ZIndex           = 101
    b.AutoButtonColor  = true
    b.Parent           = Panel
    addCorner(b, 8)
    return b
end

local function makeLbl(txt, y, h, col)
    local l = Instance.new("TextLabel")
    l.Text               = txt
    l.Size               = UDim2.new(1, -20, 0, h or 22)
    l.Position           = UDim2.new(0, 10, 0, y)
    l.BackgroundTransparency = 1
    l.TextColor3         = col or Color3.fromRGB(200, 200, 200)
    l.TextSize           = 12
    l.Font               = Enum.Font.Gotham
    l.TextXAlignment     = Enum.TextXAlignment.Left
    l.TextWrapped        = true
    l.ZIndex             = 101
    l.Parent             = Panel
    return l
end

-- ============================================
-- UI ELEMENTS
-- ============================================
local StatusLbl = makeLbl("✅ Panel loaded!", 48, 22, Color3.fromRGB(80, 255, 120))
local LogLbl    = makeLbl("Tekan tombol Load untuk mulai.", 72, 44, Color3.fromRGB(140, 140, 140))

local BtnGithub = makeBtn("📥 Load GitHub (PNG)",   124, Color3.fromRGB(30, 120, 200))
local BtnIbb    = makeBtn("📥 Load ImgBB (JPG)",    174, Color3.fromRGB(30, 100, 170))
local BtnToggle = makeBtn("⚫ Overlay: Belum Load", 224, Color3.fromRGB(80, 80, 80))
local BtnFull   = makeBtn("📐 Fullscreen Toggle",   274, Color3.fromRGB(80, 60, 180))
local BtnClear  = makeBtn("🗑️ Hapus Overlay",       324, Color3.fromRGB(160, 30, 30))

-- ============================================
-- DRAWING STATE
-- ============================================
local drawImg    = nil
local overlayOn  = false
local isFullscr  = false
local VP         = workspace.CurrentCamera.ViewportSize

local function destroyDraw()
    if drawImg then
        pcall(function() drawImg:Remove() end)
        drawImg   = nil
        overlayOn = false
    end
end

local function setStatus(msg, col)
    StatusLbl.Text       = msg
    StatusLbl.TextColor3 = col or Color3.fromRGB(255, 220, 80)
    print("[OvUI] " .. msg)
end

-- ============================================
-- CORE LOAD FUNGSI (TLS BYPASS INCLUDED)
-- ============================================
local function loadImage(url, label)
    if not httpFunc then
        setStatus("❌ Tidak ada HTTP func!", Color3.fromRGB(255, 80, 80))
        LogLbl.Text = "Executor kamu tidak support request()"
        return
    end
    if not hasDrawImg then
        setStatus("❌ Drawing.Image tidak support!", Color3.fromRGB(255, 80, 80))
        LogLbl.Text = "Update Delta ke versi terbaru"
        return
    end

    setStatus("⏳ Fetching: " .. label, Color3.fromRGB(255, 220, 80))
    LogLbl.Text = url

    task.spawn(function()
        -- Coba dengan TLS normal dulu
        local ok, res = pcall(function()
            return httpFunc({
                Url     = url,
                Method  = "GET",
                Headers = {
                    ["User-Agent"] = "Mozilla/5.0",
                }
            })
        end)

        -- Kalau gagal (TLS error), coba non-https
        if not ok or not res or not res.Body or #res.Body == 0 then
            local httpUrl = url:gsub("^https://", "http://")
            if httpUrl ~= url then
                setStatus("⏳ Retry via HTTP...", Color3.fromRGB(255, 200, 0))
                ok, res = pcall(function()
                    return httpFunc({
                        Url     = httpUrl,
                        Method  = "GET",
                        Headers = {
                            ["User-Agent"] = "Mozilla/5.0",
                        }
                    })
                end)
            end
        end

        -- Validasi response
        if not ok then
            setStatus("❌ Fetch error: " .. label, Color3.fromRGB(255, 80, 80))
            LogLbl.Text = tostring(res):sub(1, 80)
            return
        end
        if not res or not res.Body or #res.Body == 0 then
            setStatus("❌ Body kosong: " .. label, Color3.fromRGB(255, 80, 80))
            LogLbl.Text = "Response tidak ada isi"
            return
        end

        -- Destroy drawing lama
        destroyDraw()

        -- Buat Drawing baru
        local imgOk, imgErr = pcall(function()
            drawImg              = Drawing.new("Image")
            drawImg.Data         = res.Body
            drawImg.Size         = Vector2.new(VP.X, VP.Y)
            drawImg.Position     = Vector2.new(0, 0)
            drawImg.Transparency = 1   -- 1 = fully opaque di Drawing API
            drawImg.ZIndex       = 1
            drawImg.Visible      = true
        end)

        if imgOk and drawImg then
            overlayOn = true
            BtnToggle.Text             = "🟢 Overlay: ON"
            BtnToggle.BackgroundColor3 = Color3.fromRGB(30, 160, 60)
            setStatus("✅ Berhasil: " .. label, Color3.fromRGB(80, 255, 120))
            LogLbl.Text = "Drawing aktif | " .. math.floor(#res.Body / 1024) .. " KB"
        else
            setStatus("❌ Drawing render gagal", Color3.fromRGB(255, 80, 80))
            LogLbl.Text = tostring(imgErr):sub(1, 80)
            destroyDraw()
        end
    end)
end

-- ============================================
-- BUTTON EVENTS
-- ============================================
BtnGithub.MouseButton1Click:Connect(function()
    loadImage(
        "https://raw.githubusercontent.com/aryaexeuyf/Image/main/logo_g1.png",
        "GitHub PNG"
    )
end)

BtnIbb.MouseButton1Click:Connect(function()
    loadImage(
        "https://i.ibb.co/ZR5QDJRJ/c16828dd-d8c9-4574-837c-614bb0730ec9.jpg",
        "ImgBB JPG"
    )
end)

BtnToggle.MouseButton1Click:Connect(function()
    if not drawImg then
        setStatus("⚠️ Load image dulu!", Color3.fromRGB(255, 180, 0))
        return
    end
    overlayOn       = not overlayOn
    drawImg.Visible = overlayOn
    if overlayOn then
        BtnToggle.Text             = "🟢 Overlay: ON"
        BtnToggle.BackgroundColor3 = Color3.fromRGB(30, 160, 60)
    else
        BtnToggle.Text             = "🔴 Overlay: OFF"
        BtnToggle.BackgroundColor3 = Color3.fromRGB(160, 50, 50)
    end
end)

BtnFull.MouseButton1Click:Connect(function()
    if not drawImg then
        setStatus("⚠️ Load image dulu!", Color3.fromRGB(255, 180, 0))
        return
    end
    isFullscr = not isFullscr
    if isFullscr then
        drawImg.Size     = Vector2.new(VP.X, VP.Y)
        drawImg.Position = Vector2.new(0, 0)
        BtnFull.Text     = "🔲 Ukuran 800x450"
    else
        drawImg.Size     = Vector2.new(800, 450)
        drawImg.Position = Vector2.new(VP.X/2 - 400, VP.Y/2 - 225)
        BtnFull.Text     = "📐 Fullscreen Toggle"
    end
end)

BtnClear.MouseButton1Click:Connect(function()
    destroyDraw()
    BtnToggle.Text             = "⚫ Overlay: Kosong"
    BtnToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    setStatus("🗑️ Overlay dihapus", Color3.fromRGB(180, 180, 180))
    LogLbl.Text = ""
end)

CloseBtn.MouseButton1Click:Connect(function()
    destroyDraw()
    ScreenGui:Destroy()
end)

-- ============================================
-- DRAG PANEL
-- ============================================
local drag, dS, dO = false, nil, nil
TitleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch
    or i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag, dS, dO = true, i.Position, Panel.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if drag and (i.UserInputType == Enum.UserInputType.Touch
    or i.UserInputType == Enum.UserInputType.MouseMovement) then
        local d = i.Position - dS
        Panel.Position = UDim2.new(dO.X.Scale, dO.X.Offset + d.X, dO.Y.Scale, dO.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch
    or i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = false
    end
end)

-- Cleanup
ScreenGui.AncestryChanged:Connect(function()
    pcall(destroyDraw)
end)

print("[OvUI5] ✅ Script ready!")
