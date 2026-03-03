-- Overlay + Panel Script
-- Asset: rbxassetid://111580113698335

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Hapus GUI lama kalau ada
if PlayerGui:FindFirstChild("ImageOverlayUI") then
    PlayerGui:FindFirstChild("ImageOverlayUI"):Destroy()
end

-- ========================
-- SCREEN GUI UTAMA
-- ========================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ImageOverlayUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

-- ========================
-- OVERLAY IMAGE
-- ========================
local Overlay = Instance.new("ImageLabel")
Overlay.Name = "Overlay"
Overlay.Image = "rbxassetid://111580113698335"
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.Position = UDim2.new(0, 0, 0, 0)
Overlay.BackgroundTransparency = 1
Overlay.ImageTransparency = 0
Overlay.ScaleType = Enum.ScaleType.Stretch
Overlay.ZIndex = 2
Overlay.Visible = true
Overlay.Parent = ScreenGui

-- ========================
-- PANEL UTAMA
-- ========================
local Panel = Instance.new("Frame")
Panel.Name = "Panel"
Panel.Size = UDim2.new(0, 260, 0, 200)
Panel.Position = UDim2.new(0.5, -130, 0.5, -100)
Panel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Panel.BackgroundTransparency = 0.2
Panel.BorderSizePixel = 0
Panel.ZIndex = 10
Panel.Active = true
Panel.Parent = ScreenGui

-- Corner panel
local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0, 10)
PanelCorner.Parent = Panel

-- Stroke panel
local PanelStroke = Instance.new("UIStroke")
PanelStroke.Color = Color3.fromRGB(255, 100, 0)
PanelStroke.Thickness = 2
PanelStroke.Parent = Panel

-- ========================
-- TITLE BAR
-- ========================
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 36)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 11
TitleBar.Parent = Panel

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

-- Fix corner bawah title bar
local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0.5, 0)
TitleFix.Position = UDim2.new(0, 0, 0.5, 0)
TitleFix.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
TitleFix.BorderSizePixel = 0
TitleFix.ZIndex = 11
TitleFix.Parent = TitleBar

-- Title Label
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "🎨 Overlay Panel"
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 12
TitleLabel.Parent = TitleBar

-- Tombol Close (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "✕"
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -32, 0, 4)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 13
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- ========================
-- TOMBOL SHOW / HIDE OVERLAY
-- ========================
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Text = "🟢 Overlay: ON"
ToggleBtn.Size = UDim2.new(1, -20, 0, 40)
ToggleBtn.Position = UDim2.new(0, 10, 0, 50)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 150, 60)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 14
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.BorderSizePixel = 0
ToggleBtn.ZIndex = 11
ToggleBtn.Parent = Panel

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleBtn

-- ========================
-- SLIDER TRANSPARANSI
-- ========================
local SliderLabel = Instance.new("TextLabel")
SliderLabel.Text = "Transparansi: 0%"
SliderLabel.Size = UDim2.new(1, -20, 0, 20)
SliderLabel.Position = UDim2.new(0, 10, 0, 102)
SliderLabel.BackgroundTransparency = 1
SliderLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
SliderLabel.TextSize = 13
SliderLabel.Font = Enum.Font.Gotham
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
SliderLabel.ZIndex = 11
SliderLabel.Parent = Panel

local SliderBg = Instance.new("Frame")
SliderBg.Size = UDim2.new(1, -20, 0, 14)
SliderBg.Position = UDim2.new(0, 10, 0, 128)
SliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SliderBg.BorderSizePixel = 0
SliderBg.ZIndex = 11
SliderBg.Parent = Panel

local SliderBgCorner = Instance.new("UICorner")
SliderBgCorner.CornerRadius = UDim.new(1, 0)
SliderBgCorner.Parent = SliderBg

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0, 0, 1, 0)
SliderFill.Position = UDim2.new(0, 0, 0, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
SliderFill.BorderSizePixel = 0
SliderFill.ZIndex = 12
SliderFill.Parent = SliderBg

local SliderFillCorner = Instance.new("UICorner")
SliderFillCorner.CornerRadius = UDim.new(1, 0)
SliderFillCorner.Parent = SliderFill

local SliderKnob = Instance.new("Frame")
SliderKnob.Size = UDim2.new(0, 18, 0, 18)
SliderKnob.Position = UDim2.new(0, -9, 0.5, -9)
SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderKnob.BorderSizePixel = 0
SliderKnob.ZIndex = 13
SliderKnob.Parent = SliderBg

local SliderKnobCorner = Instance.new("UICorner")
SliderKnobCorner.CornerRadius = UDim.new(1, 0)
SliderKnobCorner.Parent = SliderKnob

-- ========================
-- TOMBOL DESTROY
-- ========================
local DestroyBtn = Instance.new("TextButton")
DestroyBtn.Text = "🗑️ Hapus Semua"
DestroyBtn.Size = UDim2.new(1, -20, 0, 36)
DestroyBtn.Position = UDim2.new(0, 10, 0, 155)
DestroyBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
DestroyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DestroyBtn.TextSize = 13
DestroyBtn.Font = Enum.Font.GothamBold
DestroyBtn.BorderSizePixel = 0
DestroyBtn.ZIndex = 11
DestroyBtn.Parent = Panel

local DestroyCorner = Instance.new("UICorner")
DestroyCorner.CornerRadius = UDim.new(0, 8)
DestroyCorner.Parent = DestroyBtn

-- ========================
-- DRAG PANEL
-- ========================
local dragging, dragStart, startPos = false, nil, nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or
       input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Panel.Position
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or
       input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        Panel.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or
       input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- ========================
-- SLIDER LOGIC
-- ========================
local sliderDragging = false

SliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or
       input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliderDragging = true
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if sliderDragging and (input.UserInputType == Enum.UserInputType.Touch or
       input.UserInputType == Enum.UserInputType.MouseMovement) then
        local bgPos = SliderBg.AbsolutePosition.X
        local bgSize = SliderBg.AbsoluteSize.X
        local relX = math.clamp(input.Position.X - bgPos, 0, bgSize)
        local pct = relX / bgSize
        SliderFill.Size = UDim2.new(pct, 0, 1, 0)
        SliderKnob.Position = UDim2.new(pct, -9, 0.5, -9)
        Overlay.ImageTransparency = pct
        SliderLabel.Text = "Transparansi: " .. math.floor(pct * 100) .. "%"
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or
       input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliderDragging = false
    end
end)

-- ========================
-- TOGGLE OVERLAY
-- ========================
local overlayVisible = true
ToggleBtn.MouseButton1Click:Connect(function()
    overlayVisible = not overlayVisible
    Overlay.Visible = overlayVisible
    if overlayVisible then
        ToggleBtn.Text = "🟢 Overlay: ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 150, 60)
    else
        ToggleBtn.Text = "🔴 Overlay: OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    end
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

print("[Overlay Panel] Berhasil dimuat!")
