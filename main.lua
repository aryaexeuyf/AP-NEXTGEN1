-- main.lua - G1 Loader
-- Asset ID: 74347325614985

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

-- LOGO DARI ASSET ID
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 250, 0, 250)
logo.Position = UDim2.new(0.5, -125, 0, 20)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://74347325614985" -- ASSET ID KAMU
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = frame

-- Status text
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 30)
status.Position = UDim2.new(0, 0, 0, 280)
status.BackgroundTransparency = 1
status.Text = "Loading..."
status.TextColor3 = Color3.fromRGB(100, 150, 255)
status.TextSize = 14
status.Font = Enum.Font.GothamBold
status.Parent = frame

-- Tombol Execute
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 200, 0, 40)
btn.Position = UDim2.new(0.5, -100, 0, 295)
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
            status.Text = "❌ Asset not found"
            status.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end
end)

-- Execute
btn.MouseButton1Click:Connect(function()
    print("🔥 G1 Executed!")
    -- loadstring(game:HttpGet("URL_SCRIPT"))()
    gui:Destroy()
end)

-- Close
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

print("🚀 G1 Loader - Asset ID: 74347325614985")
