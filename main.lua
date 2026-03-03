-- main.lua - G1 Loader dengan Image Buffer
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- Hapus UI lama
if CoreGui:FindFirstChild("G1_Fixed") then
    CoreGui:FindFirstChild("G1_Fixed"):Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "G1_Fixed"
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 350)
frame.Position = UDim2.new(0.5, -200, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 30)
status.Position = UDim2.new(0, 0, 0, 10)
status.BackgroundTransparency = 1
status.Text = "Loading image..."
status.TextColor3 = Color3.fromRGB(100, 150, 255)
status.TextSize = 14
status.Font = Enum.Font.GothamBold
status.Parent = frame

-- Image container
local imgContainer = Instance.new("Frame")
imgContainer.Size = UDim2.new(0, 250, 0, 250)
imgContainer.Position = UDim2.new(0.5, -125, 0, 45)
imgContainer.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
imgContainer.Parent = frame

Instance.new("UICorner", imgContainer).CornerRadius = UDim.new(0, 10)

-- Image label
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(1, -10, 1, -10)
logo.Position = UDim2.new(0, 5, 0, 5)
logo.BackgroundTransparency = 1
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = imgContainer

-- URL ImgBB
local IMAGE_URL = "https://i.ibb.co.com/ZR5QDJRJ/c16828dd-d8c9-4574-837c-614bb0730ec9.jpg"

-- Coba load dengan pcall
spawn(function()
    local success, result = pcall(function()
        -- Coba request gambar
        logo.Image = IMAGE_URL
        return true
    end)
    
    if not success then
        print("Error: " .. tostring(result))
    end
    
    -- Tunggu load
    wait(3)
    
    if logo.IsLoaded then
        status.Text = "✅ Ready!"
        status.TextColor3 = Color3.fromRGB(100, 255, 150)
    else
        -- Coba method alternatif: rbxassetid
        status.Text = "Trying alternative..."
        
        -- Fallback ke placeholder yang pasti work
        logo.Image = "rbxassetid://17633214800"
        
        wait(2)
        if logo.IsLoaded then
            status.Text = "✅ Ready (Fallback)"
            status.TextColor3 = Color3.fromRGB(255, 200, 100)
        else
            status.Text = "❌ All methods failed"
            status.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end
end)

-- Tombol Execute
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 200, 0, 40)
btn.Position = UDim2.new(0.5, -100, 1, -55)
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
    print("Executed!")
    gui:Destroy()
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

print("Testing URL: " .. IMAGE_URL)
