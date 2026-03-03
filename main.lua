-- Image Overlay Script
-- Asset: rbxassetid://111580113698335

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Buat ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ImageOverlay"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

-- Buat ImageLabel (Overlay)
local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Name = "Overlay"
ImageLabel.Image = "rbxassetid://111580113698335"
ImageLabel.Size = UDim2.new(1, 0, 1, 0)       -- Full screen
ImageLabel.Position = UDim2.new(0, 0, 0, 0)    -- Pojok kiri atas
ImageLabel.BackgroundTransparency = 1           -- Background transparan
ImageLabel.ImageTransparency = 0                -- Opacity penuh (0 = opak, 1 = transparan)
ImageLabel.ScaleType = Enum.ScaleType.Stretch   -- Stretch ke full screen
ImageLabel.ZIndex = 10
ImageLabel.Parent = ScreenGui

-- Draggable (opsional)
local dragging = false
local dragStart, startPos

ImageLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or
       input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = ImageLabel.Position
    end
end)

ImageLabel.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or
       input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        ImageLabel.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

ImageLabel.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or
       input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("[Overlay] Berhasil dimuat!")
