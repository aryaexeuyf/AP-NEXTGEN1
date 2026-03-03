-- ============================================
-- Overlay Panel v4 | Ultra Safe Build
-- Delta Android Compatible
-- ============================================

-- ============================================
-- STEP 1: DETEKSI FUNGSI EXECUTOR
-- ============================================
local httpFunc = nil
if syn and syn.request then
    httpFunc = syn.request
    print("[OK] http: syn.request")
elseif http and http.request then
    httpFunc = http.request
    print("[OK] http: http.request")
elseif request then
    httpFunc = request
    print("[OK] http: request")
else
    warn("[WARN] Tidak ada fungsi HTTP ditemukan")
end

local hasDrawingImage = pcall(function()
    local t = Drawing.new("Image")
    t:Remove()
end)
print("[OK] Drawing.Image supported: " .. tostring(hasDrawingImage))

-- ============================================
-- STEP 2: SETUP GUI
-- ============================================
local Players          = game:GetService("Players")
local CoreGui          = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local LocalPlayer      = Players.LocalPlayer

-- Hapus lama
pcall(function()
    local old = CoreGui:FindFirstChild("OvUI")
    if old then old:Destroy() end
end)
pcall(function()
    local old = LocalPlayer.PlayerGui:FindFirstChild("OvUI")
    if old then old:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name             = "OvUI"
ScreenGui.ResetOnSpawn     = false
ScreenGui.IgnoreGuiInset   = true
ScreenGui.DisplayOrder     = 9999
ScreenGui.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling

local parentOk = pcall(function() ScreenGui.Parent = CoreGui end)
if not parentOk then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    print("[WARN] Fallback ke PlayerGui")
else
    print("[OK] Parent: CoreGui")
end

-- ============================================
-- STEP 3: PANEL
-- ============================================
local Panel = Instance.new("Frame")
Panel.Name                 = "Panel"
Panel.Size                 = UDim2.new(0, 280, 0, 360)
Panel.Position             = UDim2.new(0, 20, 0.5, -180)
Panel.BackgroundColor3     = Color3.fromRGB(14, 14, 14)
Panel.BackgroundTransparency = 0
Panel.BorderSizePixel      = 0
Panel.ZIndex               = 100
Panel.Active               = true
Panel.Parent               = ScreenGui
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 12)

do
    local s = Instance.new("UIStroke", Panel)
    s.Color     = Color3.fromRGB(255, 140, 0)
    s.Thickness = 2
end

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size             = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
TitleBar.BorderSizePixel  = 0
TitleBar.ZIndex           = 101
TitleBar.Parent           = Panel
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

-- Fix rounded bottom title
do
    local f = Instance.new("Frame", TitleBar)
    f.Size             = UDim2.new(1, 0, 0.5, 0)
    f.Position         = UDim2.new(0, 0, 0.5, 0)
    f.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    f.BorderSizePixel  = 0
    f.ZIndex           = 101
end

do
    local lbl = Instance.new("TextLabel", TitleBar)
    lbl.Text               = "🖼️ Overlay Panel"
    lbl.Size               = UDim2.new(1, -44, 1, 0)
    lbl.Position           = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3         = Color3.fromRGB(255, 255, 255)
    lbl.TextSize           = 15
    lbl.Font               = Enum.Font.GothamBold
    lbl.TextXAlignment     = Enum.TextXAlignment.Left
    lbl.ZIndex             = 102
end

local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Text             = "✕"
CloseBtn.Size             = UDim2.new(0, 28, 0, 28)
CloseBtn.Position         = UDim2.new(1, -34, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize         = 13
CloseBtn.Font             = Enum.Font.GothamBold
CloseBtn.BorderSizePixel  = 0
CloseBtn.ZIndex           = 103
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- ============================================
-- HELPER: BUAT TOMBOL
-- ============================================
local function Btn(txt, y, col)
    local b = Instance.new("TextButton", Panel)
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
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

local function Lbl(txt, y, size, color)
    local l = Instance.new("TextLabel", Panel)
    l.Text               = txt
    l.Size               = UDim2.new(1, -20, 0, size or 20)
    l.Position           = UDim2.new(0, 10, 0, y)
    l.BackgroundTransparency = 1
    l.TextColor3         = color or Color3.fromRGB(200, 200, 200)
    l.TextSize           = 12
    l.Font               = Enum.Font.Gotham
    l.TextXAlignment     = Enum.TextXAlignment.Left
    l.TextWrapped        = true
    l.ZIndex             = 101
    return l
end

-- Status dan log
local StatusLbl  = Lbl("⏳ Siap...", 50, 20, Color3.fromRGB(255, 220, 80))
local LogLbl     = Lbl("", 74, 40, Color3.fromRGB(140, 140, 140))

-- Tombol-tombol
local BtnLoad1   = Btn("📥 Load GitHub (PNG)",    124, Color3.fromRGB(30, 120, 200))
local BtnLoad2   = Btn("📥 Load ImgBB (JPG)",     174, Color3.fromRGB(30, 100, 170))
local BtnToggle  = Btn("🟢 Overlay: ON",          224, Color3.fromRGB(30, 160, 60))
local BtnFull    = Btn("📐 Fullscreen Toggle",    274, Color3.fromRGB(80, 60, 180))
local BtnRemove  = Btn("🗑️ Hapus Overlay",        324, Color3.fromRGB(160, 30, 30))

-- ============================================
-- STEP 4: DRAWING IMAGE OBJECT
-- ============================================
local drawImg    = nil
local overlayOn  = false
local isFullscreen = false
local VP         = workspace.CurrentCamera.ViewportSize

local function destroyDrawing()
    if drawImg then
        pcall(function() drawImg:Remove() end)
        drawImg = nil
        overlayOn = false
    end
end

local function updateStatus(msg, color)
    StatusLbl.Text       = msg
    StatusLbl.TextColor3 = color or Color3.fromRGB(255, 220, 80)
    print("[Overlay] " .. msg)
end

-- ============================================
-- STEP 5: LOAD IMAGE DARI URL
-- ============================================
local function loadImageFromURL(url, label)
    if not httpFunc then
        updateStatus("❌ Tidak ada fungsi HTTP!", Color3.fromRGB(255, 80, 80))
        LogLbl.Text = "Executor tidak support request()\natau syn.request()"
        return
    end

    if not hasDrawingImage then
        updateStatus("❌ Drawing.Image tidak support!", Color3.fromRGB(255, 80, 80))
        LogLbl.Text = "Update Delta kamu ke versi terbaru"
        return
    end

    updateStatus("⏳ Fetching " .. label .. "...", Color3.fromRGB(255, 220, 80))
    LogLbl.Text = url

    task.spawn(function()
        -- Fetch raw bytes
        local ok, res = pcall(function()
            return httpFunc({
                Url    = url,
                Method = "GET",
            })
        end)

        if not ok or not res then
            updateStatus("❌ Fetch error: " .. label, Color3.fromRGB(255, 80, 80))
            LogLbl.Text = tostring(res)
            return
        end

        if not res.Body or #res.Body == 0 then
            updateStatus("❌ Body kosong: " .. label, Color3.fromRGB(255, 80, 80))
            return
        end

        -- Hapus drawing lama
        destroyDrawing()

        -- Buat Drawing baru
        local imgOk, imgErr = pcall(function()
            drawImg          = Drawing.new("Image")
            drawImg.Data     = res.Body
            drawImg.Size     = Vector2.new(VP.X, VP.Y)
            drawImg.Position = Vector2.new(0, 0)
            drawImg.Transparency = 1
            drawImg.ZIndex   = 1
            drawImg.Visible  = true
        end)

        if imgOk and drawImg then
            overlayOn = true
            BtnToggle.Text             = "🟢 Overlay: ON"
            BtnToggle.BackgroundColor3 = Color3.fromRGB(30, 160, 60)
            updateStatus("✅ Berhasil: " .. label, Color3.fromRGB(80, 255, 120))
            LogLbl.Text = "Size: " .. tostring(VP.X) .. "x" .. tostring(VP.Y)
        else
            updateStatus("❌ Drawing render gagal", Color3.fromRGB(255, 80, 80))
            LogLbl.Text = tostring(imgErr)
            destroyDrawing()
        end
    end)
end

-- ============================================
-- STEP 6: EVENTS TOMBOL
-- ============================================
BtnLoad1.MouseButton1Click:Connect(function()
    loadImageFromURL(
        "https://raw.githubusercontent.com/aryaexeuyf/Image/main/logo_g1.png",
        "GitHub PNG"
    )
end)

BtnLoad2.MouseButton1Click:Connect(function()
    loadImageFromURL(
        "https://i.ibb.co/ZR5QDJRJ/c16828dd-d8c9-4574-837c-614bb0730ec9.jpg",
        "ImgBB JPG"
    )
end)

BtnToggle.MouseButton1Click:Connect(function()
    if not drawImg then
        updateStatus("⚠️ Load image dulu!", Color3.fromRGB(255, 180, 0))
        return
    end
    overlayOn = not overlayOn
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
        updateStatus("⚠️ Load image dulu!", Color3.fromRGB(255, 180, 0))
        return
    end
    isFullscreen = not isFullscreen
    if isFullscreen then
        drawImg.Size     = Vector2.new(VP.X, VP.Y)
        drawImg.Position = Vector2.new(0, 0)
        BtnFull.Text     = "🔲 Ukuran 800x450"
    else
        drawImg.Size     = Vector2.new(800, 450)
        drawImg.Position = Vector2.new(VP.X/2 - 400, VP.Y/2 - 225)
        BtnFull.Text     = "📐 Fullscreen Toggle"
    end
end)

BtnRemove.MouseButton1Click:Connect(function()
    destroyDrawing()
    BtnToggle.Text             = "⚫ Overlay: Kosong"
    BtnToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    updateStatus("🗑️ Overlay dihapus", Color3.fromRGB(180, 180, 180))
end)

CloseBtn.MouseButton1Click:Connect(function()
    destroyDrawing()
    ScreenGui:Destroy()
end)

-- ============================================
-- DRAG PANEL
-- ============================================
local dragging, dStart, dOrigin = false, nil, nil
TitleBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch
    or inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dStart   = inp.Position
        dOrigin  = Panel.Position
    end
end)
UserInputService.InputChanged:Connect(function(inp)
    if dragging and (
        inp.UserInputType == Enum.UserInputType.Touch or
        inp.UserInputType == Enum.UserInputType.MouseMovement
    ) then
        local d = inp.Position - dStart
        Panel.Position = UDim2.new(
            dOrigin.X.Scale, dOrigin.X.Offset + d.X,
            dOrigin.Y.Scale, dOrigin.Y.Offset + d.Y
        )
    end
end)
UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch
    or inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- ============================================
-- CLEANUP
-- ============================================
ScreenGui.AncestryChanged:Connect(function()
    pcall(destroyDrawing)
end)

updateStatus("✅ Panel loaded! Tekan Load.", Color3.fromRGB(80, 255, 120))
print("[Overlay Panel] ✅ Ready — tekan tombol Load untuk mulai!")
