-- main.lua - G1 Loader (FIXED)
-- Asset ID: 111580113698335

local CoreGui = game:GetService("CoreGui")

-- Hapus UI lama
local old = CoreGui:FindFirstChild("G1_Simple")
if old then old:Destroy() end

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "G1_Simple"
gui.Parent = CoreGui

-- Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 350)
frame.Position = UDim2.new(0.5, -200, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- LOGO - Langsung set tanpa pengecekan
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 250, 0, 250)
logo.Position = UDim2.new(0.5, -125, 0, 20)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://111580113698335"
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = frame

-- Text Ready
local ready = Instance.new("TextLabel")
ready.Size = UDim2.new(1, 0, 0, 30)
ready.Position = UDim2.new(0, 0, 0, 280)
ready.BackgroundTransparency = 1
ready.Text = "G1 Ready"
ready.TextColor3 = Color3.fromRGB(100, 255, 150)
ready.TextSize = 14
ready.Font = Enum.Font.GothamBold
ready.Parent = frame

-- Tombol Execute
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 200, 0, 40)
btn.Position = UDim2.new(0.5, -100, 0, 310)
btn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
btn.Text = "EXECUTE"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.TextSize = 16
btn.Font = Enum.Font.GothamBold
btn.Parent = frame

Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

-- Tombol Close
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 35, 0, 35)
close.Position = UDim2.new(1, -45, 0, 10)
close.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.TextSize = 18
close.Font = Enum.Font.GothamBold
close.Parent = frame

Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)

-- Functions
btn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

print("G1 Loaded")
