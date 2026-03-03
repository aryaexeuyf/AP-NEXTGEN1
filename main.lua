-- main.lua - G1 Loader
-- Image: https://i.ibb.co.com/ZR5QDJRJ/c16828dd-d8c9-4574-837c-614bb0730ec9.jpg

local CoreGui = game:GetService("CoreGui")

-- Hapus UI lama
if CoreGui:FindFirstChild("G1_Loader") then
    CoreGui:FindFirstChild("G1_Loader"):Destroy()
end

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "G1_Loader"
gui.Parent = CoreGui

-- Frame utama
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 350)
frame.Position = UDim2.new(0.5, -200, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- LOGO G1 DARI IMGBB
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 250, 0, 250)
logo.Position = UDim2.new(0.5, -125, 0, 20)
logo.BackgroundTransparency = 1
logo.Image = "https://i.ibb.co.com/ZR5QDJRJ/c16828dd-d8c9-4574-837c-614bb0730ec9.jpg"
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = frame

-- Status text
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 30)
status.Position = UDim2.new(0, 0, 0, 280)
status.BackgroundTransparency = 1
status.Text = "Loading G1..."
status.TextColor3 = Color3.fromRGB(100, 150, 255)
status.TextSize = 14
status.Font = Enum.Font.GothamBold
status.Parent = frame

-- Tombol Execute
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 200, 0, 40)
btn.Position = UDim2.new(0.5, -100, 1, -55)
btn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
btn.Text = "EXECUTE"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.TextSize = 16
btn.Font = Enum.Font.GothamBold
btn.Visible = false
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

-- Cek logo loaded
spawn(function()
    wait(2)
    
    if logo.IsLoaded then
        status.Text = "✅ Ready!"
        status.TextColor3 = Color3.fromRGB(100, 255, 150)
        btn.Visible = true
    else
        wait(2)
        if logo.IsLoaded then
            status.Text = "✅ Ready!"
            status.TextColor3 = Color3.fromRGB(100, 255, 150)
            btn.Visible = true
        else
            status.Text = "❌ Failed to load"
            status.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end
end)

-- Execute button
btn.MouseButton1Click:Connect(function()
    print("🔥 G1 Script Executed!")
    -- MASUKKAN SCRIPT UTAMA KAMU DI SINI
    -- loadstring(game:HttpGet("URL_SCRIPT_KAMU"))()
    gui:Destroy()
end)

-- Close button
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

print("🚀 G1 Loader Ready!")
print("🖼️ Image URL: https://i.ibb.co.com/ZR5QDJRJ/c16828dd-d8c9-4574-837c-614bb0730ec9.jpg")
