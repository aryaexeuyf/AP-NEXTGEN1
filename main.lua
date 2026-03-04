--[[
    PREMIUM ULTRA OVERLAY UI - DELTA EXECUTOR
    Fitur: Cinematic Opening, Glassmorphism, Smooth Drag, Pro Design
    Assets: Custom Github (New Background)
--]]

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ContentProvider = game:GetService("ContentProvider")

-- Pembersihan UI lama agar tidak terjadi penumpukan
if CoreGui:FindFirstChild("UltraPremiumUI") then
    CoreGui.UltraPremiumUI:Destroy()
end

-- Inisialisasi ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraPremiumUI"
ScreenGui.Parent = CoreGui
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Asset Configuration
local LOGO_URL = "https://raw.githubusercontent.com/aryaexeuyf/Image/main/logo_g1.png"
local BG_URL = "https://raw.githubusercontent.com/aryaexeuyf/Image/main/background.jpg"
local FALLBACK_ID = "rbxassetid://111580113698335"

-- 1. CONTAINER UTAMA (MODERN PANEL)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 0, 0, 0) -- Mulai dari 0 untuk animasi opening
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BackgroundTransparency = 0.3 -- Setengah transparan mewah
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ClipsDescendants = true

-- Background Image (Full Cover & Professional)
local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Name = "BackgroundImage"
BackgroundImage.Parent = MainFrame
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.Image = BG_URL -- MENGGUNAKAN LINK BACKGROUND BARU
BackgroundImage.ImageTransparency = 0.5 -- Transparansi image BG agar profesional
BackgroundImage.ScaleType = Enum.ScaleType.Crop -- Menutup full tanpa gepeng
BackgroundImage.ZIndex = 0

-- Styling Corners & Border
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 24) -- Lebih bulat & modern
UICorner.Parent = MainFrame

local UICornerBG = Instance.new("UICorner")
UICornerBG.CornerRadius = UDim.new(0, 24)
UICornerBG.Parent = BackgroundImage

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2.5
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Transparency = 0.75
UIStroke.Parent = MainFrame

-- 2. ICON MINIMIZE (LOGO G1)
local MinimizeBtn = Instance.new("ImageButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = ScreenGui
MinimizeBtn.AnchorPoint = Vector2.new(0.5, 0.5)
MinimizeBtn.Position = UDim2.new(0.12, 0, 0.12, 0)
MinimizeBtn.Size = UDim2.new(0, 65, 0, 65)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Image = LOGO_URL
MinimizeBtn.Visible = false

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(1, 0) -- Menjadi lingkaran sempurna
LogoCorner.Parent = MinimizeBtn

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Thickness = 2
LogoStroke.Color = Color3.fromRGB(255, 255, 255)
LogoStroke.Parent = MinimizeBtn

-- 3. LOADING ELEMENTS (CINEMATIC)
local LoadingLogo = Instance.new("ImageLabel")
LoadingLogo.Name = "LoadingLogo"
LoadingLogo.Parent = ScreenGui
LoadingLogo.AnchorPoint = Vector2.new(0.5, 0.5)
LoadingLogo.Position = UDim2.new(0.5, 0, 0.5, -20)
LoadingLogo.Size = UDim2.new(0, 0, 0, 0)
LoadingLogo.BackgroundTransparency = 1
LoadingLogo.Image = LOGO_URL
LoadingLogo.ImageTransparency = 1

local LoadingText = Instance.new("TextLabel")
LoadingText.Name = "LoadingText"
LoadingText.Parent = ScreenGui
LoadingText.AnchorPoint = Vector2.new(0.5, 0.5)
LoadingText.Position = UDim2.new(0.5, 0, 0.5, 60)
LoadingText.Size = UDim2.new(0, 400, 0, 40)
LoadingText.BackgroundTransparency = 1
LoadingText.Font = Enum.Font.GothamBold
LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingText.TextSize = 22
LoadingText.Text = "MEMUAT ASET PREMIUM..."
LoadingText.TextTransparency = 1

-- SISTEM DRAG (MOBILE OPTIMIZED)
local function MakeDraggable(ui)
    local dragging, dragInput, dragStart, startPos
    ui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = ui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    ui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            ui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

MakeDraggable(MainFrame)
MakeDraggable(MinimizeBtn)

-- ANIMASI OPENING & LOGIKA IMAGE FIX
task.spawn(function()
    -- Mencoba preload aset
    pcall(function() ContentProvider:PreloadAsync({LoadingLogo, BackgroundImage, MinimizeBtn}) end)
    
    -- Fade In Cinematic Opening
    TweenService:Create(LoadingLogo, TweenInfo.new(1.2, Enum.EasingStyle.Back), {Size = UDim2.new(0, 150, 0, 150), ImageTransparency = 0}):Play()
    TweenService:Create(LoadingText, TweenInfo.new(1.5), {TextTransparency = 0}):Play()
    
    task.wait(2.5)
    
    -- Fade Out Loading
    TweenService:Create(LoadingLogo, TweenInfo.new(0.7, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 0, 0, 0), ImageTransparency = 1}):Play()
    TweenService:Create(LoadingText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    
    task.wait(0.7)
    
    -- Membuka Panel Utama dengan animasi membal (bouncy)
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 420, 0, 260)}):Play()
    
    -- Pengecekan jika gambar gagal load (Delta butuh refresh image terkadang)
    task.wait(0.5)
    if BackgroundImage.ContentImageSize == Vector2.new(0,0) then
        -- Jika link eksternal diblokir, gunakan fallback agar UI tidak kosong
        BackgroundImage.Image = FALLBACK_ID
    end

    LoadingLogo:Destroy()
    LoadingText:Destroy()
end)

-- TOMBOL CLOSE / MINIMIZE (MODERN STYLE)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = MainFrame
CloseBtn.AnchorPoint = Vector2.new(0.5, 0.5)
CloseBtn.Position = UDim2.new(1, -30, 0, 30)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.BackgroundTransparency = 0.4
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 28
CloseBtn.Font = Enum.Font.GothamBold

local CBCorner = Instance.new("UICorner")
CBCorner.CornerRadius = UDim.new(1, 0)
CBCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.6)
    MainFrame.Visible = false
    MinimizeBtn.Visible = true
    MinimizeBtn.ImageTransparency = 1
    TweenService:Create(MinimizeBtn, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    MinimizeBtn.Visible = false
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 420, 0, 260)}):Play()
end)

print("Ultra Premium Overlay System Executed Successfully with New Background.")
