--[[
    Overlay Image Script untuk Delta Android
    Asset ID: rbxassetid://111580113698335
--]]

local ImageLabel = Instance.new("ImageLabel")
local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

-- Konfigurasi Properti ScreenGui
ScreenGui.Name = "DeltaOverlayGui"
ScreenGui.Parent = game:GetService("CoreGui") -- Menggunakan CoreGui agar tidak terhapus saat reset karakter
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Konfigurasi ImageLabel (Overlay)
ImageLabel.Name = "MainOverlay"
ImageLabel.Parent = ScreenGui
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel.BackgroundTransparency = 1.000 -- Transparan agar hanya gambar yang terlihat
ImageLabel.Position = UDim2.new(0.5, -100, 0.5, -100) -- Posisi tengah layar awal
ImageLabel.Size = UDim2.new(0, 200, 0, 200) -- Ukuran gambar (bisa kamu ubah)
ImageLabel.Image = "rbxassetid://111580113698335"
ImageLabel.Active = true
ImageLabel.Draggable = true -- Membuat gambar bisa digeser di layar Android

-- Menjaga Rasio Gambar agar tidak gepeng
UIAspectRatioConstraint.Parent = ImageLabel
UIAspectRatioConstraint.AspectRatio = 1.000 -- Sesuaikan jika gambar aslinya bukan kotak

-- Notifikasi Sederhana di Console
print("Overlay berhasil dimuat!")

-- Fungsi untuk menghapus overlay (Opsional - panggil jika ingin membersihkan)
-- ScreenGui:Destroy()
