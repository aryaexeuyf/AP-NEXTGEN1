-- main.lua - G1 Script Loader
-- Logo from: https://raw.githubusercontent.com/aryaexeuyf/Image/main/logo_g1.png

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- Hapus UI lama jika ada
if CoreGui:FindFirstChild("G1_Loader") then
    CoreGui:FindFirstChild("G1_Loader"):Destroy()
end

-- Buat ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "G1_Loader"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame (Dark theme biar cocok sama logo)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 450, 0, 400)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 35) -- Biru tua gelap
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Corner radius
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = MainFrame

-- Shadow effect
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.Size = UDim2.new(1, 60, 1, 60)
Shadow.ZIndex = -1
Shadow.Image = "rbxassetid://6014261993"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.6
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
Shadow.Parent = MainFrame

-- LOGO G1 DARI GITHUB
local LogoImage = Instance.new("ImageLabel")
LogoImage.Name = "G1_Logo"
LogoImage.Size = UDim2.new(0, 250, 0, 250)
LogoImage.Position = UDim2.new(0.5, -125, 0, 30)
LogoImage.BackgroundTransparency = 1
LogoImage.Image = "https://raw.githubusercontent.com/aryaexeuyf/Image/main/logo_g1.png"
LogoImage.ScaleType = Enum.ScaleType.Fit
LogoImage.ImageTransparency = 1 -- Mulai transparan buat animasi
LogoImage.Parent = MainFrame

-- Loading text
local LoadingText = Instance.new("TextLabel")
LoadingText.Name = "Status"
LoadingText.Size = UDim2.new(1, 0, 0, 25)
LoadingText.Position = UDim2.new(0, 0, 0, 290)
LoadingText.BackgroundTransparency = 1
LoadingText.Text = "Loading G1 Resources..."
LoadingText.TextColor3 = Color3.fromRGB(100, 150, 255) -- Biru muda
LoadingText.TextSize = 14
LoadingText.Font = Enum.Font.GothamSemibold
LoadingText.Parent = MainFrame

-- Progress bar background
local ProgressBg = Instance.new("Frame")
ProgressBg.Name = "ProgressBg"
ProgressBg.Size = UDim2.new(0, 300, 0, 4)
ProgressBg.Position = UDim2.new(0.5, -150, 0, 320)
ProgressBg.BackgroundColor3 = Color3.fromRGB(40, 50, 70)
ProgressBg.BorderSizePixel = 0
ProgressBg.Parent = MainFrame

Instance.new("UICorner", ProgressBg).CornerRadius = UDim.new(0, 2)

-- Progress bar fill
local ProgressFill = Instance.new("Frame")
ProgressFill.Name = "ProgressFill"
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BackgroundColor3 = Color3.fromRGB(70, 130, 255) -- Biru terang
ProgressFill.BorderSizePixel = 0
ProgressFill.Parent = ProgressBg

Instance.new("UICorner", ProgressFill).CornerRadius = UDim.new(0, 2)

-- Tombol Execute (hidden dulu)
local ExecuteBtn = Instance.new("TextButton")
ExecuteBtn.Name = "Execute"
ExecuteBtn.Size = UDim2.new(0, 200, 0, 45)
ExecuteBtn.Position = UDim2.new(0.5, -100, 0, 340)
ExecuteBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
ExecuteBtn.Text = "EXECUTE"
ExecuteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecuteBtn.TextSize = 16
ExecuteBtn.Font = Enum.Font.GothamBold
ExecuteBtn.Visible = false
ExecuteBtn.Parent = MainFrame

Instance.new("UICorner", ExecuteBtn).CornerRadius = UDim.new(0, 8)

-- Gradient untuk tombol
local BtnGradient = Instance.new("UIGradient")
BtnGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 130, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 180, 255))
})
BtnGradient.Rotation = 90
BtnGradient.Parent = ExecuteBtn

-- Tombol Close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -45, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 24
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

-- Animasi loading
local loaded = false
local progress = 0

LogoImage.Loaded:Connect(function()
    loaded = true
    LoadingText.Text = "✅ G1 Resources Loaded!"
    LoadingText.TextColor3 = Color3.fromRGB(100, 255, 150)
    
    -- Fade in logo
    TweenService:Create(LogoImage, TweenInfo.new(0.8, Enum.EasingStyle.Quart), {
        ImageTransparency = 0
    }):Play()
    
    -- Progress complete
    TweenService:Create(ProgressFill, TweenInfo.new(0.5), {
        Size = UDim2.new(1, 0, 1, 0)
    }):Play()
    
    -- Show execute button
    delay(0.5, function()
        ExecuteBtn.Visible = true
        ExecuteBtn.Size = UDim2.new(0, 0, 0, 45)
        TweenService:Create(ExecuteBtn, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 200, 0, 45)
        }):Play()
    end)
end)

-- Simulasi progress bar
spawn(function()
    while not loaded and progress < 0.9 do
        progress = progress + 0.05
        ProgressFill.Size = UDim2.new(progress, 0, 1, 0)
        wait(0.1)
    end
end)

-- Timeout 8 detik
delay(8, function()
    if not loaded then
        LoadingText.Text = "⚠️ Using fallback..."
        LoadingText.TextColor3 = Color3.fromRGB(255, 200, 100)
        
        -- Fallback ke rbxassetid kalau GitHub gagal
        LogoImage.Image = "rbxassetid://17633214800"
        
        wait(1)
        if LogoImage.IsLoaded then
            loaded = true
            LoadingText.Text = "✅ Loaded (Fallback)"
            LoadingText.TextColor3 = Color3.fromRGB(100, 255, 150)
            ExecuteBtn.Visible = true
        end
    end
end)

-- Hover effect tombol execute
ExecuteBtn.MouseEnter:Connect(function()
    TweenService:Create(ExecuteBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(90, 150, 255),
        Size = UDim2.new(0, 210, 0, 48)
    }):Play()
    ExecuteBtn.Position = UDim2.new(0.5, -105, 0, 338)
end)

ExecuteBtn.MouseLeave:Connect(function()
    TweenService:Create(ExecuteBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(70, 130, 255),
        Size = UDim2.new(0, 200, 0, 45)
    }):Play()
    ExecuteBtn.Position = UDim2.new(0.5, -100, 0, 340)
end)

-- Execute script
ExecuteBtn.MouseButton1Click:Connect(function()
    -- Animasi klik
    TweenService:Create(ExecuteBtn, TweenInfo.new(0.1), {
        Size = UDim2.new(0, 190, 0, 42)
    }):Play()
    
    wait(0.1)
    
    -- GANTI INI DENGAN SCRIPT UTAMA KAMU
    print("🔥 G1 Script Executed!")
    -- loadstring(game:HttpGet("https://raw.githubusercontent.com/aryaexeuyf/..."))()
    
    -- Tutup UI dengan animasi
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Rotation = 360
    }):Play()
    
    wait(0.5)
    ScreenGui:Destroy()
end)

-- Close button
CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {
        Position = UDim2.new(0.5, -225, 1.5, 0)
    }):Play()
    wait(0.3)
    ScreenGui:Destroy()
end)

-- Dragging system
local dragging = false
local dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Animasi buka
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 450, 0, 400),
    Position = UDim2.new(0.5, -225, 0.5, -200)
}):Play()

print("🚀 G1 Loader Initialized")
print("🖼️ Loading logo from GitHub...")
