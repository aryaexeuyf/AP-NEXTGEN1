-- main.lua - Image Overlay di Script
-- Logo nempel di atas UI script yang sudah jalan

local CoreGui = game:GetService("CoreGui")

-- Hapus overlay lama
if CoreGui:FindFirstChild("G1_Overlay") then
    CoreGui:FindFirstChild("G1_Overlay"):Destroy()
end

-- Buat overlay ScreenGui
local overlay = Instance.new("ScreenGui")
overlay.Name = "G1_Overlay"
overlay.Parent = CoreGui
overlay.ResetOnSpawn = false

-- LOGO OVERLAY (Pojok Kanan Atas)
local logo = Instance.new("ImageLabel")
logo.Name = "G1_Logo"
logo.Size = UDim2.new(0, 80, 0, 80) -- Ukuran kecil
logo.Position = UDim2.new(1, -90, 0, 10) -- Pojok kanan atas
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://74347325614985" -- Ganti dengan asset ID yang work
logo.ScaleType = Enum.ScaleType.Fit
logo.ImageTransparency = 0.2 -- Transparan dikit biar keren
logo.Parent = overlay

-- Tambah shadow/glow
local glow = Instance.new("ImageLabel")
glow.Size = UDim2.new(1.2, 0, 1.2, 0)
glow.Position = UDim2.new(-0.1, 0, -0.1, 0)
glow.BackgroundTransparency = 1
glow.Image = "rbxassetid://74347325614985"
glow.ScaleType = Enum.ScaleType.Fit
glow.ImageTransparency = 0.8
glow.ImageColor3 = Color3.fromRGB(70, 130, 255) -- Glow biru
glow.ZIndex = -1
glow.Parent = logo

-- Script utama kamu di sini
-- ============================================
print("🔥 G1 Script Running...")
-- loadstring(game:HttpGet("URL_SCRIPT_UTAMA"))()
-- ============================================

print("✅ G1 Overlay Active")
