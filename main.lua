--[[
    REVISI TOTAL: OVERLAY IMAGE UNTUK DELTA EXECUTOR
    Asset ID: rbxassetid://111580113698335
--]]

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local ContentProvider = game:GetService("ContentProvider")

-- Hapus UI lama jika ada agar tidak menumpuk (mencegah lag/bug)
if CoreGui:FindFirstChild("DeltaOverlay_Official") then
    CoreGui:FindFirstChild("DeltaOverlay_Official"):Destroy()
end

-- 1. Membuat Container Utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaOverlay_Official"
ScreenGui.Parent = CoreGui
ScreenGui.DisplayOrder = 2147483647 -- Prioritas layar tertinggi (di atas menu Delta)
ScreenGui.IgnoreGuiInset = true -- Mengambil seluruh area layar HP
ScreenGui.ResetOnSpawn = false -- Tidak hilang saat karakter mati

-- 2. Membuat Gambar Overlay
local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Name = "MainOverlay"
ImageLabel.Parent = ScreenGui
ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0) -- Default di tengah layar
ImageLabel.Size = UDim2.new(0, 180, 0, 180) -- Ukuran gambar (Lebar, Tinggi)
ImageLabel.BackgroundTransparency = 1
ImageLabel.Image = "rbxassetid://111580113698335"
ImageLabel.Active = true -- Penting agar bisa disentuh/digeser

-- 3. Memastikan gambar terunduh dari server Roblox
task.spawn(function()
    pcall(function()
        ContentProvider:PreloadAsync({ImageLabel})
    end)
    print("Overlay: Gambar berhasil dimuat!")
end)

-- 4. Sistem Drag Manual (Lancar untuk Android/Mobile)
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    ImageLabel.Position = UDim2.new(
        startPos.X.Scale, 
        startPos.X.Offset + delta.X, 
        startPos.Y.Scale, 
        startPos.Y.Offset + delta.Y
    )
end

ImageLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ImageLabel.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

ImageLabel.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

print("Script Overlay Delta Berhasil Dijalankan!")
