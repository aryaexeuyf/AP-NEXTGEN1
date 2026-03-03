-- main.lua - G1 Loader (FIXED VERSION)
-- Simple, ringan, anti crash

local CoreGui = game:GetService("CoreGui")

-- Hapus UI lama
local old = CoreGui:FindFirstChild("G1_Simple")
if old then old:Destroy() end

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "G1_Simple"
gui.Parent = CoreGui

-- Frame utama
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 350)
frame.Position = UDim2.new(0.5, -200, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
frame.BorderSizePixel = 0
frame.Active = true -- Penting buat draggable
frame.Draggable = true -- Draggable bawaan Roblox (simple)
frame.Parent = gui

-- Corner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- LOGO DARI GITHUB
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 200, 0, 200)
logo.Position = UDim2.new(0.5, -100, 0, 20)
logo.BackgroundTransparency = 1
logo.Image = "https://raw.githubusercontent.com/aryaexeuyf/Image/main/logo_g1.png"
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = frame

-- Status text
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 30)
status.Position = UDim2.new(0, 0, 0, 230)
status.BackgroundTransparency = 1
status.Text = "Loading..."
status.TextColor3 = Color3.fromRGB(100, 150, 255)
status.TextSize = 14
status.Font = Enum.Font.Gotham
status.Parent = frame

-- Tombol Execute
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 250, 0, 45)
btn.Position = UDim2.new(0.5, -125, 0, 280)
btn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
btn.Text = "EXECUTE"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.TextSize = 16
btn.Font = Enum.Font.GothamBold
btn.Visible = false -- Hidden dulu
btn.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = btn

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

-- Logic sederhana
local loaded = false

-- Cek logo load
spawn(function()
    wait(2) -- Tunggu 2 detik
    
    if logo.IsLoaded then
        loaded = true
        status.Text = "Ready!"
        status.TextColor3 = Color3.fromRGB(100, 255, 150)
        btn.Visible = true
    else
        -- Fallback
        logo.Image = "rbxassetid://17633214800"
        wait(1)
        
        if logo.IsLoaded then
            status.Text = "Ready (Fallback)"
            status.TextColor3 = Color3.fromRGB(255, 200, 100)
            btn.Visible = true
        else
            status.Text = "Failed to load"
            status.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end
end)

-- Timeout 5 detik
delay(5, function()
    if not loaded and btn.Visible == false then
        status.Text = "Timeout - Try again"
        status.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- Tombol execute
btn.MouseButton1Click:Connect(function()
    print("Executed!")
    -- loadstring(game:HttpGet("URL_SCRIPT"))()
    gui:Destroy()
end)

-- Tombol close
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

print("G1 Loader Ready")
