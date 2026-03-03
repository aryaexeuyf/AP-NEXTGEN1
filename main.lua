-- main.lua - Versi Debug Lengkap

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer

-- Hapus UI lama
if CoreGui:FindFirstChild("DebugImageUI") then
    CoreGui:FindFirstChild("DebugImageUI"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DebugImageUI"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 400)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Info Panel
local InfoPanel = Instance.new("TextLabel")
InfoPanel.Size = UDim2.new(1, -20, 0, 60)
InfoPanel.Position = UDim2.new(0, 10, 0, 10)
InfoPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
InfoPanel.Text = "Asset ID: 127480462745832\nStatus: Checking..."
InfoPanel.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoPanel.TextSize = 14
InfoPanel.Font = Enum.Font.Gotham
InfoPanel.TextWrapped = true
InfoPanel.Parent = MainFrame

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 8)
InfoCorner.Parent = InfoPanel

-- Container Gambar
local ImgContainer = Instance.new("Frame")
ImgContainer.Size = UDim2.new(0, 300, 0, 200)
ImgContainer.Position = UDim2.new(0.5, -150, 0, 80)
ImgContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ImgContainer.Parent = MainFrame

local ContainerCorner = Instance.new("UICorner")
ContainerCorner.CornerRadius = UDim.new(0, 8)
ContainerCorner.Parent = ImgContainer

-- Loading Text
local LoadingText = Instance.new("TextLabel")
LoadingText.Size = UDim2.new(1, 0, 1, 0)
LoadingText.BackgroundTransparency = 1
LoadingText.Text = "Loading..."
LoadingText.TextColor3 = Color3.fromRGB(200, 200, 200)
LoadingText.TextSize = 16
LoadingText.Font = Enum.Font.GothamBold
LoadingText.Parent = ImgContainer

-- GAMBAR UTAMA
local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Name = "TestImage"
ImageLabel.Size = UDim2.new(1, -10, 1, -10)
ImageLabel.Position = UDim2.new(0, 5, 0, 5)
ImageLabel.BackgroundTransparency = 1
ImageLabel.Image = "rbxassetid://127480462745832"
ImageLabel.ScaleType = Enum.ScaleType.Fit
ImageLabel.ImageTransparency = 1 -- Mulai transparan
ImageLabel.Parent = ImgContainer

-- Cek apakah gambar load
local startTime = tick()
local loaded = false

ImageLabel.Loaded:Connect(function()
    loaded = true
    local loadTime = tick() - startTime
    LoadingText:Destroy()
    
    InfoPanel.Text = string.format(
        "Asset ID: 127480462745832\nStatus: LOADED (%.2f detik)", 
        loadTime
    )
    InfoPanel.TextColor3 = Color3.fromRGB(100, 255, 100)
    
    -- Fade in
    TweenService:Create(ImageLabel, TweenInfo.new(0.5), {
        ImageTransparency = 0
    }):Play()
    
    print("✅ Gambar berhasil dimuat dalam " .. loadTime .. " detik")
end)

-- Timeout cek (10 detik)
delay(10, function()
    if not loaded then
        LoadingText.Text = "❌ FAILED"
        InfoPanel.Text = "Asset ID: 127480462745832\nStatus: FAILED TO LOAD"
        InfoPanel.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        print("❌ Gagal load gambar setelah 10 detik")
        
        -- Coba method alternatif
        tryAlternativeMethods()
    end
end)

-- Fungsi cek info asset (pcall untuk safety)
spawn(function()
    local success, info = pcall(function()
        return MarketplaceService:GetProductInfo(127480462745832)
    end)
    
    if success and info then
        print("Asset Info ditemukan:")
        print("Name: " .. (info.Name or "Unknown"))
        print("Type: " .. (info.AssetTypeId or "Unknown"))
        print("Creator: " .. (info.Creator and info.Creator.Name or "Unknown"))
        
        InfoPanel.Text = InfoPanel.Text .. "\nName: " .. (info.Name or "Unknown")
    else
        print("❌ Asset tidak ditemukan di Marketplace")
        InfoPanel.Text = InfoPanel.Text .. "\n⚠️ Asset mungkin private atau tidak ada"
    end
end)

-- Tombol Close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 80, 0, 30)
CloseBtn.Position = UDim2.new(0.5, -40, 1, -40)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseBtn.Text = "Close"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Fungsi Alternatif jika gagal
function tryAlternativeMethods()
    local AltFrame = Instance.new("Frame")
    AltFrame.Size = UDim2.new(0, 400, 0, 150)
    AltFrame.Position = UDim2.new(0.5, -200, 0.5, 50)
    AltFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    AltFrame.Parent = ScreenGui
    
    local AltText = Instance.new("TextLabel")
    AltText.Size = UDim2.new(1, -20, 1, -20)
    AltText.Position = UDim2.new(0, 10, 0, 10)
    AltText.BackgroundTransparency = 1
    AltText.Text = "Mencoba method alternatif...\nCoba pakai Decal ID atau URL lain"
    AltText.TextColor3 = Color3.fromRGB(255, 255, 100)
    AltText.TextSize = 14
    AltText.TextWrapped = true
    AltText.Parent = AltFrame
    
    -- Opsi 1: Coba Decal ID (kadang berbeda dengan Image ID)
    -- Opsi 2: Gunakan placeholder sementara
    delay(2, function()
        ImageLabel.Image = "rbxassetid://17633214800" -- Placeholder yang pasti work
        AltText.Text = "Menggunakan placeholder image...\nAsset ID asli mungkin private"
    end)
end

print("🔍 Memulai pengecekan asset...")
