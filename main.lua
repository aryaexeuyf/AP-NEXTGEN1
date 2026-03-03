-- Objek UI
local ScreenGui = Instance.new("ScreenGui")
local ImageLabel = Instance.new("ImageLabel")

-- Pengaturan ScreenGui
ScreenGui.Name = "DeltaOverlay"
ScreenGui.Parent = game:GetService("CoreGui") -- Menggunakan CoreGui agar tetap muncul di atas UI game
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Pengaturan ImageLabel
ImageLabel.Name = "MainOverlay"
ImageLabel.Parent = ScreenGui
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel.BackgroundTransparency = 1.000 -- Transparan agar hanya gambar yang terlihat
ImageLabel.Position = UDim2.new(0.5, -150, 0.5, -150) -- Mengatur posisi ke tengah layar
ImageLabel.Size = UDim2.new(0, 300, 0, 300) -- Ukuran gambar (bisa kamu ubah)
ImageLabel.Image = "rbxassetid://111580113698335" -- ID Asset kamu
ImageLabel.ScaleType = Enum.ScaleType.Fit -- Memastikan gambar tidak terpotong

-- Fungsi opsional: Menghapus UI jika script dijalankan ulang
for _, oldUi in pairs(game:GetService("CoreGui"):GetChildren()) do
    if oldUi.Name == "DeltaOverlay" and oldUi ~= ScreenGui then
        oldUi:Destroy()
    end
end
