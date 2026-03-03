-- Overlay + Panel | Fixed Version
-- Asset: rbxassetid://111580113698335

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local ContentProvider = game:GetService("ContentProvider")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Hapus GUI lama
pcall(function()
    if CoreGui:FindFirstChild("ImageOverlayUI") then
        CoreGui:FindFirstChild("ImageOverlayUI"):Destroy()
    end
end)

-- ========================
-- SCREEN GUI UTAMA
-- ========================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ImageOverlayUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999

-- Coba parent ke CoreGui dulu, fallback ke PlayerGui
local success = pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not success then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ========================
-- OVERLAY IMAGE
-- ========================
local ASSET_ID = "rbxassetid://111580113698335"

local Overlay = Instance.new("ImageLabel")
Overlay.Name = "Overlay"
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.Position = UDim2.new(0, 0, 0, 0)
Overlay.BackgroundTransparency = 1
Overlay.ImageTransparency = 0
Overlay.ScaleType = Enum.ScaleType.Stretch
Overlay.ZIndex = 1
Overlay.Visible = true
Overlay.Parent = ScreenGui

-- Preload lalu set image
task.spawn(function()
    pcall(function()
        ContentProvider:PreloadAsync({ASSET_ID})
    end)
    Overlay.Image = ASSET_ID
    print("[Overlay] Image loaded: " .. ASSET_ID)
end)

-- ========================
-- PANEL UTAMA
-- ========================
local Panel = Instance.new("Frame")
Panel.Name = "Panel"
Panel.Size = UDim2.new(0, 260, 0, 210)
Panel.Position = UDim2.new(0.5, -130, 0.5, -105)
Panel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Panel.BackgroundTransparency = 0.1
Panel.BorderSizePixel = 0
Panel.ZIndex = 100
Panel.Active = true
Panel.Parent = ScreenGui

Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 12)

local PanelStroke = Instance.new("UIStroke", Panel)
PanelStroke.Color = Color3.fromRGB(255, 120, 0)
PanelStroke.Thickness = 2

-- ========================
-- TITLE BAR
-- ========================
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 38)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 101
TitleBar.Parent = Panel

Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

-- Fix rounded corner bawah title bar
local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0.5, 0)
TitleFix.Position = UDim2.new(0, 0, 0.5, 0)
TitleFix.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
TitleFix.BorderSizePixel = 0
TitleFix.ZIndex = 101
TitleFix.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "🎨  Overlay Panel"
TitleLabel.Size = UDim2.new(1, -45, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 15
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 102
TitleLabel.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "✕"
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 13
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 103
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- ========================
-- HELPER BUAT TOMBOL
-- ========================
local function makeButton(text, posY, color)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.new(1, -20, 0, 38)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.ZIndex = 101
    btn.Parent = Panel
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

-- ========================
-- TOMBOL TOGGLE OVERLAY
-- ========================
local ToggleBtn = makeButton("🟢  Overlay: ON", 48, Color3.fromRGB(30, 160, 60))

-- ========================
-- LABEL SLIDER
-- ========================
local SliderLabel = Instance.new("TextLabel")
SliderLabel.Text = "Transparansi: 0%"
SliderLabel.Size = UDim2.new(1, -20, 0, 18)
SliderLabel.Position = UDim2.new(0, 10, 0, 100)
SliderLabel.BackgroundTransparency = 1
SliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SliderLabel.TextSize = 12
SliderLabel.Font = Enum.Font.Gotham
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
SliderLabel.ZIndex = 101
SliderLabel.Parent = Panel

-- ========================
-- SLIDER BAR
-- ========================
local SliderBg = Instance.new("Frame")
SliderBg.Size = UDim2.new(1, -20, 0, 14)
SliderBg.Position = UDim2.new(0, 10, 0, 122)
SliderBg.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
SliderBg.BorderSizePixel = 0
SliderBg.ZIndex = 101
SliderBg.Parent = Panel
Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
SliderFill.BorderSizePixel = 0
SliderFill.ZIndex = 102
SliderFill.Parent = SliderBg
Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

local SliderKnob = Instance.new("Frame")
SliderKnob.Size = UDim2.new(0, 20, 0, 20)
SliderKnob.Position = UDim2.new(0, -10, 0.5, -10)
SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderKnob.BorderSizePixel = 0
SliderKnob.ZIndex = 103
SliderKnob.Parent = SliderBg
Instance.new("UICorner", SliderKnob).CornerRadius = UDim.new(1, 0)

-- ========================
-- TOMBOL RELOAD IMAGE
-- ========================
local ReloadBtn = makeButton("🔄  Reload Image", 150, Color3.fromRGB(40, 100, 200))

-- ========================
-- TOMBOL DESTROY
-- ========================
local DestroyBtn = makeButton("🗑️  Hapus Semua", 198, Color3.fromRGB(160, 30, 30))

-- ========================
-- DRAG PANEL LOGIC
-- ========================
local dragging, dragStart, startPos = false, nil, nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Panel.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement
    ) then
        local delta = input.Position - dragStart
        Panel.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- ========================
-- SLIDER LOGIC
-- ========================
local sliderDragging = false

SliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliderDragging = true
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if sliderDragging and (
        input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement
    ) then
        local bgX = SliderBg.AbsolutePosition.X
        local bgW = SliderBg.AbsoluteSize.X
        local rel = math.clamp(input.Position.X - bgX, 0, bgW)
        local pct = rel / bgW
        SliderFill.Size = UDim2.new(pct, 0, 1, 0)
        SliderKnob.Position = UDim2.new(pct, -10, 0.5, -10)
        Overlay.ImageTransparency = pct
        SliderLabel.Text = "Transparansi: " .. math.floor(pct * 100) .. "%"
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliderDragging = false
    end
end)

-- ========================
-- TOGGLE OVERLAY
-- ========================
local overlayOn = true
ToggleBtn.MouseButton1Click:Connect(function()
    overlayOn = not overlayOn
    Overlay.Visible = overlayOn
    if overlayOn then
        ToggleBtn.Text = "🟢  Overlay: ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 160, 60)
    else
        ToggleBtn.Text = "🔴  Overlay: OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(160, 50, 50)
    end
end)

-- ========================
-- RELOAD IMAGE
-- ========================
ReloadBtn.MouseButton1Click:Connect(function()
    ReloadBtn.Text = "⏳  Loading..."
    Overlay.Image = ""
    task.wait(0.5)
    pcall(function()
        ContentProvider:PreloadAsync({ASSET_ID})
    end)
    Overlay.Image = ASSET_ID
    ReloadBtn.Text = "🔄  Reload Image"
    print("[Overlay] Image reloaded!")
end)

-- ========================
-- CLOSE PANEL
-- ========================
CloseBtn.MouseButton1Click:Connect(function()
    Panel.Visible = false
end)

-- ========================
-- DESTROY SEMUA
-- ========================
DestroyBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("[Overlay Panel] ✅ Loaded ke CoreGui!")
