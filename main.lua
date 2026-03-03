-- ============================================
-- Overlay Panel | Drawing API Method (Bypass)
-- Tidak butuh Roblox asset system sama sekali
-- ============================================

local Players       = game:GetService("Players")
local CoreGui       = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer   = Players.LocalPlayer

-- Hapus GUI lama
pcall(function()
    if CoreGui:FindFirstChild("OverlayPanelUI") then
        CoreGui:FindFirstChild("OverlayPanelUI"):Destroy()
    end
end)

-- ============================================
-- IMAGE SOURCE (Drawing API pakai URL langsung)
-- ============================================
local IMAGE_URLS = {
    "https://raw.githubusercontent.com/aryaexeuyf/Image/main/logo_g1.png",
    "https://i.ibb.co/ZR5QDJRJ/c16828dd-d8c9-4574-837c-614bb0730ec9.jpg",
}

-- ============================================
-- DRAWING IMAGE OBJECT (Bypass Roblox filter)
-- ============================================
local drawingImg = Drawing.new("Image")
drawingImg.Visible = false
drawingImg.Size    = Vector2.new(800, 450)
drawingImg.Position = Vector2.new(
    (workspace.CurrentCamera.ViewportSize.X / 2) - 400,
    (workspace.CurrentCamera.ViewportSize.Y / 2) - 225
)
drawingImg.Transparency = 1  -- opak penuh
drawingImg.ZIndex = 1

-- ============================================
-- SCREEN GUI (untuk panel kontrol saja)
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OverlayPanelUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local ok = pcall(function() ScreenGui.Parent = CoreGui end)
if not ok then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- ============================================
-- PANEL FRAME
-- ============================================
local Panel = Instance.new("Frame")
Panel.Size = UDim2.new(0, 300, 0, 390)
Panel.Position = UDim2.new(0, 20, 0.5, -195)
Panel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Panel.BackgroundTransparency = 0.05
Panel.BorderSizePixel = 0
Panel.ZIndex = 10
Panel.Active = true
Panel.Parent = ScreenGui
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 14)

local PanelStroke = Instance.new("UIStroke", Panel)
PanelStroke.Color = Color3.fromRGB(255, 130, 0)
PanelStroke.Thickness = 2

-- ============================================
-- TITLE BAR
-- ============================================
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 130, 0)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 11
TitleBar.Parent = Panel
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 14)

local TFix = Instance.new("Frame")
TFix.Size = UDim2.new(1, 0, 0.5, 0)
TFix.Position = UDim2.new(0, 0, 0.5, 0)
TFix.BackgroundColor3 = Color3.fromRGB(255, 130, 0)
TFix.BorderSizePixel = 0
TFix.ZIndex = 11
TFix.Parent = TitleBar

local TitleLbl = Instance.new("TextLabel")
TitleLbl.Text = "🖼️  Overlay Panel"
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
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 13
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 13
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- ============================================
-- PREVIEW BOX (TV Box — isinya Drawing layer)
-- ============================================
local PreviewBox = Instance.new("Frame")
PreviewBox.Size = UDim2.new(1, -20, 0, 160)
PreviewBox.Position = UDim2.new(0, 10, 0, 50)
PreviewBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
PreviewBox.BorderSizePixel = 0
PreviewBox.ZIndex = 11
PreviewBox.Parent = Panel
Instance.new("UICorner", PreviewBox).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", PreviewBox).Color = Color3.fromRGB(60, 60, 60)

-- Label preview info
local PreviewLbl = Instance.new("TextLabel")
PreviewLbl.Text = "📺 Preview Drawing Layer\n(Overlay tampil di luar panel)"
PreviewLbl.Size = UDim2.new(1, 0, 1, 0)
PreviewLbl.BackgroundTransparency = 1
PreviewLbl.TextColor3 = Color3.fromRGB(140, 140, 140)
PreviewLbl.TextSize = 12
PreviewLbl.Font = Enum.Font.Gotham
PreviewLbl.TextWrapped = true
PreviewLbl.ZIndex = 12
PreviewLbl.Parent = PreviewBox

-- ============================================
-- STATUS LABEL
-- ============================================
local StatusLbl = Instance.new("TextLabel")
StatusLbl.Text = "⏳ Memulai..."
StatusLbl.Size = UDim2.new(1, -20, 0, 36)
StatusLbl.Position = UDim2.new(0, 10, 0, 220)
StatusLbl.BackgroundTransparency = 1
StatusLbl.TextColor3 = Color3.fromRGB(255, 200, 80)
StatusLbl.TextSize = 12
StatusLbl.Font = Enum.Font.Gotham
StatusLbl.TextXAlignment = Enum.TextXAlignment.Left
StatusLbl.TextWrapped = true
StatusLbl.ZIndex = 11
StatusLbl.Parent = Panel

-- ============================================
-- HELPER TOMBOL
-- ============================================
local function makeBtn(text, posY, color)
    local b = Instance.new("TextButton")
    b.Text = text
    b.Size = UDim2.new(1, -20, 0, 40)
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

local ToggleBtn  = makeBtn("🟢  Overlay: ON",          264, Color3.fromRGB(30, 160, 60))
local FullBtn    = makeBtn("📐  Fullscreen",            312, Color3.fromRGB(60, 60, 180))
local ShrinkBtn  = makeBtn("🔲  Ukuran Normal",         360, Color3.fromRGB(100, 60, 160))

-- ============================================
-- SLIDER TRANSPARANSI
-- ============================================
local SldLabel = Instance.new("TextLabel")
SldLabel.Text = "Opacity: 100%"
SldLabel.Size = UDim2.new(1, -20, 0, 18)
SldLabel.Position = UDim2.new(0, 10, 0, 215)
SldLabel.BackgroundTransparency = 1
SldLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SldLabel.TextSize = 12
SldLabel.Font = Enum.Font.Gotham
SldLabel.TextXAlignment = Enum.TextXAlignment.Left
SldLabel.ZIndex = 11
SldLabel.Parent = Panel

-- (Reuse posY setelah status, shift semua tombol ke bawah)
-- Update layout posY:
StatusLbl.Position = UDim2.new(0, 10, 0, 218)
SldLabel.Position  = UDim2.new(0, 10, 0, 222)

-- Geser tombol
ToggleBtn.Position = UDim2.new(0, 10, 0, 262)
FullBtn.Position   = UDim2.new(0, 10, 0, 308)
ShrinkBtn.Position = UDim2.new(0, 10, 0, 354)

-- ============================================
-- DRAG PANEL
-- ============================================
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
        Panel.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
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
-- LOAD IMAGE VIA DRAWING API (pakai request)
-- ============================================
local function tryDrawingLoad(urlIndex)
    urlIndex = urlIndex or 1
    if urlIndex > #IMAGE_URLS then
        StatusLbl.Text = "❌ Semua URL gagal di Drawing API"
        StatusLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end

    local url = IMAGE_URLS[urlIndex]
    StatusLbl.Text = "⏳ Fetching URL " .. urlIndex .. "..."
    StatusLbl.TextColor3 = Color3.fromRGB(255, 200, 80)
    print("[Drawing] Mencoba URL: " .. url)

    task.spawn(function()
        local success, result = pcall(function()
            -- request() adalah fungsi executor bawaan untuk HTTP
            local response = request({
                Url    = url,
                Method = "GET",
            })
            return response.Body
        end)

        if success and result and #result > 0 then
            local imgOk = pcall(function()
                drawingImg.Data    = result
                drawingImg.Visible = true
            end)
            if imgOk then
                StatusLbl.Text = "✅ Berhasil! URL " .. urlIndex
                StatusLbl.TextColor3 = Color3.fromRGB(80, 255, 120)
                PreviewLbl.Text = "✅ Drawing Image aktif!\n(URL " .. urlIndex .. ")"
                PreviewLbl.TextColor3 = Color3.fromRGB(80, 255, 120)
                print("[Drawing] ✅ Image loaded dari URL " .. urlIndex)
            else
                print("[Drawing] ❌ Data ok tapi Drawing gagal render, coba URL berikutnya")
                tryDrawingLoad(urlIndex + 1)
            end
        else
            print("[Drawing] ❌ Fetch gagal URL " .. urlIndex .. ", coba berikutnya")
            tryDrawingLoad(urlIndex + 1)
        end
    end)
end

-- ============================================
-- TOGGLE OVERLAY
-- ============================================
local overlayOn = true
ToggleBtn.MouseButton1Click:Connect(function()
    overlayOn = not overlayOn
    drawingImg.Visible = overlayOn
    if overlayOn then
        ToggleBtn.Text = "🟢  Overlay: ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 160, 60)
    else
        ToggleBtn.Text = "🔴  Overlay: OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(160, 50, 50)
    end
end)

-- ============================================
-- FULLSCREEN / NORMAL
-- ============================================
FullBtn.MouseButton1Click:Connect(function()
    local vp = workspace.CurrentCamera.ViewportSize
    drawingImg.Size = Vector2.new(vp.X, vp.Y)
    drawingImg.Position = Vector2.new(0, 0)
    StatusLbl.Text = "📐 Fullscreen aktif"
end)

ShrinkBtn.MouseButton1Click:Connect(function()
    local vp = workspace.CurrentCamera.ViewportSize
    drawingImg.Size = Vector2.new(600, 340)
    drawingImg.Position = Vector2.new(vp.X/2 - 300, vp.Y/2 - 170)
    StatusLbl.Text = "🔲 Ukuran normal"
end)

-- ============================================
-- CLOSE PANEL (overlay tetap jalan)
-- ============================================
CloseBtn.MouseButton1Click:Connect(function()
    Panel.Visible = false
end)

-- ============================================
-- AUTO START
-- ============================================
task.delay(0.3, function()
    tryDrawingLoad(1)
end)

-- Cleanup saat GUI dihancurkan
ScreenGui.AncestryChanged:Connect(function()
    pcall(function() drawingImg:Remove() end)
end)

print("[Overlay Panel] ✅ Drawing API Mode aktif!")
