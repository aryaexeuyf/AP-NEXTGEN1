-- Overlay Panel | 3 Method Auto-Detect
-- by Script System

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local ContentProvider = game:GetService("ContentProvider")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Hapus GUI lama
pcall(function()
    if CoreGui:FindFirstChild("OverlayPanelUI") then
        CoreGui:FindFirstChild("OverlayPanelUI"):Destroy()
    end
end)

-- ========================
-- 3 METODE IMAGE
-- ========================
local METHODS = {
    { name = "Metode 1 (rbxassetid)", src = "rbxassetid://111580113698335" },
    { name = "Metode 2 (ibb.co)",     src = "https://i.ibb.co.com/ZR5QDJRJ/c16828dd-d8c9-4574-837c-614bb0730ec9.jpg" },
    { name = "Metode 3 (GitHub Raw)", src = "https://raw.githubusercontent.com/aryaexeuyf/Image/main/logo_g1.png" },
}

local currentMethod = 0
local activeSource = ""

-- ========================
-- SCREEN GUI
-- ========================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OverlayPanelUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local ok = pcall(function() ScreenGui.Parent = CoreGui end)
if not ok then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- ========================
-- PANEL UTAMA
-- ========================
local Panel = Instance.new("Frame")
Panel.Name = "Panel"
Panel.Size = UDim2.new(0, 300, 0, 420)
Panel.Position = UDim2.new(0.5, -150, 0.5, -210)
Panel.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Panel.BackgroundTransparency = 0.05
Panel.BorderSizePixel = 0
Panel.ZIndex = 10
Panel.Active = true
Panel.Parent = ScreenGui
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 14)

local PanelStroke = Instance.new("UIStroke", Panel)
PanelStroke.Color = Color3.fromRGB(255, 130, 0)
PanelStroke.Thickness = 2

-- ========================
-- TITLE BAR
-- ========================
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 130, 0)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 11
TitleBar.Parent = Panel
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 14)

-- Fix corner bawah
local TFix = Instance.new("Frame")
TFix.Size = UDim2.new(1, 0, 0.5, 0)
TFix.Position = UDim2.new(0, 0, 0.5, 0)
TFix.BackgroundColor3 = Color3.fromRGB(255, 130, 0)
TFix.BorderSizePixel = 0
TFix.ZIndex = 11
TFix.Parent = TitleBar

local TitleLbl = Instance.new("TextLabel")
TitleLbl.Text = "🖼️  Image Overlay Panel"
TitleLbl.Size = UDim2.new(1, -44, 1, 0)
TitleLbl.Position = UDim2.new(0, 12, 0, 0)
TitleLbl.BackgroundTransparency = 1
TitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLbl.TextSize = 14
TitleLbl.Font = Enum.Font.GothamBold
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
TitleLbl.ZIndex = 12
TitleLbl.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "✕"
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.TextSize = 13
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 13
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- ========================
-- TV BOX / IMAGE PREVIEW
-- ========================
local TVBox = Instance.new("Frame")
TVBox.Name = "TVBox"
TVBox.Size = UDim2.new(1, -20, 0, 200)
TVBox.Position = UDim2.new(0, 10, 0, 50)
TVBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TVBox.BorderSizePixel = 0
TVBox.ZIndex = 11
TVBox.ClipsDescendants = true
TVBox.Parent = Panel
Instance.new("UICorner", TVBox).CornerRadius = UDim.new(0, 10)

local TVStroke = Instance.new("UIStroke", TVBox)
TVStroke.Color = Color3.fromRGB(60, 60, 60)
TVStroke.Thickness = 2

-- ImageLabel di dalam TV Box
local ImageDisplay = Instance.new("ImageLabel")
ImageDisplay.Name = "ImageDisplay"
ImageDisplay.Size = UDim2.new(1, 0, 1, 0)
ImageDisplay.Position = UDim2.new(0, 0, 0, 0)
ImageDisplay.BackgroundTransparency = 1
ImageDisplay.ImageTransparency = 0
ImageDisplay.ScaleType = Enum.ScaleType.Fit
ImageDisplay.ZIndex = 12
ImageDisplay.Image = ""
ImageDisplay.Parent = TVBox

-- Loading label di TV Box
local LoadingLbl = Instance.new("TextLabel")
LoadingLbl.Text = "⏳ Mendeteksi metode..."
LoadingLbl.Size = UDim2.new(1, 0, 1, 0)
LoadingLbl.BackgroundTransparency = 1
LoadingLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
LoadingLbl.TextSize = 13
LoadingLbl.Font = Enum.Font.Gotham
LoadingLbl.ZIndex = 13
LoadingLbl.Visible = true
LoadingLbl.Parent = TVBox

-- ========================
-- STATUS LABEL
-- ========================
local StatusLbl = Instance.new("TextLabel")
StatusLbl.Text = "Status: Menunggu..."
StatusLbl.Size = UDim2.new(1, -20, 0, 18)
StatusLbl.Position = UDim2.new(0, 10, 0, 258)
StatusLbl.BackgroundTransparency = 1
StatusLbl.TextColor3 = Color3.fromRGB(255, 200, 80)
StatusLbl.TextSize = 12
StatusLbl.Font = Enum.Font.Gotham
StatusLbl.TextXAlignment = Enum.TextXAlignment.Left
StatusLbl.ZIndex = 11
StatusLbl.TextWrapped = true
StatusLbl.Parent = Panel

-- ========================
-- METHOD BADGE LABELS (M1, M2, M3)
-- ========================
local badgeColors = {
    Color3.fromRGB(80, 80, 80),
    Color3.fromRGB(80, 80, 80),
    Color3.fromRGB(80, 80, 80),
}
local badges = {}

for i = 1, 3 do
    local badge = Instance.new("TextLabel")
    badge.Text = "M" .. i
    badge.Size = UDim2.new(0, 40, 0, 22)
    badge.Position = UDim2.new(0, 8 + (i - 1) * 46, 0, 280)
    badge.BackgroundColor3 = badgeColors[i]
    badge.TextColor3 = Color3.fromRGB(255, 255, 255)
    badge.TextSize = 12
    badge.Font = Enum.Font.GothamBold
    badge.BorderSizePixel = 0
    badge.ZIndex = 11
    badge.Parent = Panel
    Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 6)
    badges[i] = badge
end

-- ========================
-- HELPER TOMBOL
-- ========================
local function makeBtn(text, posY, color)
    local b = Instance.new("TextButton")
    b.Text = text
    b.Size = UDim2.new(1, -20, 0, 38)
    b.Position = UDim2.new(0, 10, 0, posY)
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 13
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.ZIndex = 11
    b.Parent = Panel
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

local RetryBtn  = makeBtn("🔁  Coba Metode Berikutnya", 312, Color3.fromRGB(40, 110, 210))
local ReloadBtn = makeBtn("🔄  Reload Metode Aktif",    360, Color3.fromRGB(100, 60, 180))

-- ========================
-- DRAG PANEL
-- ========================
local dragging, dragStart, startPos = false, nil, nil
TitleBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch
    or inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging, dragStart, startPos = true, inp.Position, Panel.Position
    end
end)
UserInputService.InputChanged:Connect(function(inp)
    if dragging and (inp.UserInputType == Enum.UserInputType.Touch
    or inp.UserInputType == Enum.UserInputType.MouseMovement) then
        local d = inp.Position - dragStart
        Panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                    startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch
    or inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- ========================
-- CORE: COBA LOAD IMAGE
-- ========================
local function resetBadges()
    for i = 1, 3 do
        badges[i].BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        badges[i].Text = "M" .. i
    end
end

local function tryLoadMethod(idx)
    if idx > #METHODS then
        StatusLbl.Text = "❌ Semua metode gagal!"
        StatusLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
        LoadingLbl.Text = "❌ Tidak ada yang berhasil"
        LoadingLbl.Visible = true
        ImageDisplay.Image = ""
        return
    end

    local m = METHODS[idx]
    currentMethod = idx

    -- Update badge: kuning = sedang dicoba
    resetBadges()
    badges[idx].BackgroundColor3 = Color3.fromRGB(220, 180, 0)
    badges[idx].Text = "⏳" .. idx

    LoadingLbl.Text = "⏳ Mencoba " .. m.name .. "..."
    LoadingLbl.Visible = true
    ImageDisplay.Image = ""
    StatusLbl.TextColor3 = Color3.fromRGB(255, 200, 80)
    StatusLbl.Text = "Mencoba: " .. m.name

    print("[Overlay] Mencoba " .. m.name .. " | src: " .. m.src)

    task.spawn(function()
        -- Preload kalau rbxassetid
        if m.src:find("rbxassetid") then
            pcall(function()
                ContentProvider:PreloadAsync({m.src})
            end)
        end

        -- Set image
        ImageDisplay.Image = m.src
        task.wait(2.5) -- tunggu load

        -- Cek apakah gambar berhasil dimuat
        local loaded = false

        if m.src:find("rbxassetid") then
            -- Cek via ImageLabel content size
            loaded = (ImageDisplay.ImageRectSize.X > 0 or ImageDisplay.ImageRectSize.Y > 0)
            -- Fallback: cek via ContentProvider status
            if not loaded then
                local status = ContentProvider:GetAssetFetchStatus(m.src)
                loaded = (status == Enum.AssetFetchStatus.Success)
            end
        else
            -- HTTP image: kalau tidak error langsung anggap loaded
            -- (Roblox biasanya block HTTP luar, tapi kita cek ImageRectSize juga)
            loaded = (ImageDisplay.ImageRectSize.X > 0)
            -- Jika rect size 0 tapi mungkin gambar transparan, coba cek via IsLoaded
            if not loaded then
                -- Fallback sederhana: set ulang dan wait lebih lama
                ImageDisplay.Image = ""
                task.wait(0.2)
                ImageDisplay.Image = m.src
                task.wait(3)
                loaded = (ImageDisplay.ImageRectSize.X > 0)
            end
        end

        if loaded then
            -- BERHASIL ✅
            badges[idx].BackgroundColor3 = Color3.fromRGB(30, 180, 60)
            badges[idx].Text = "✅" .. idx
            LoadingLbl.Visible = false
            activeSource = m.src
            StatusLbl.TextColor3 = Color3.fromRGB(80, 255, 120)
            StatusLbl.Text = "✅ BERHASIL: " .. m.name
            TVStroke.Color = Color3.fromRGB(30, 180, 60)
            print("[Overlay] ✅ BERHASIL dengan " .. m.name .. " | " .. m.src)
        else
            -- GAGAL ❌ coba berikutnya
            badges[idx].BackgroundColor3 = Color3.fromRGB(180, 40, 40)
            badges[idx].Text = "❌" .. idx
            ImageDisplay.Image = ""
            print("[Overlay] ❌ Gagal " .. m.name .. ", lanjut ke berikutnya...")
            task.wait(0.5)
            tryLoadMethod(idx + 1)
        end
    end)
end

-- ========================
-- RETRY & RELOAD BUTTONS
-- ========================
RetryBtn.MouseButton1Click:Connect(function()
    local next = (currentMethod % #METHODS) + 1
    tryLoadMethod(next)
end)

ReloadBtn.MouseButton1Click:Connect(function()
    if currentMethod > 0 then
        tryLoadMethod(currentMethod)
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    Panel.Visible = false
end)

-- ========================
-- AUTO START: coba dari Metode 1
-- ========================
task.delay(0.5, function()
    tryLoadMethod(1)
end)

print("[Overlay Panel] ✅ Script loaded!")
