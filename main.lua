-- main.lua
-- Menampilkan gambar dengan Asset ID: 127480462745832

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- Hapus UI lama jika ada
if CoreGui:FindFirstChild("MyImageUI") then
    CoreGui:FindFirstChild("MyImageUI"):Destroy()
end

-- Buat ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyImageUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Frame utama
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 350)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Corner radius biar modern
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Shadow effect
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.Size = UDim2.new(1, 47, 1, 47)
Shadow.ZIndex = -1
Shadow.Image = "rbxassetid://6014261993" -- Shadow asset
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
Shadow.Parent = MainFrame

-- GAMBAR UTAMA (Asset ID kamu)
local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Name = "DisplayImage"
ImageLabel.Size = UDim2.new(0, 300, 0, 200)
ImageLabel.Position = UDim2.new(0.5, -150, 0, 20)
ImageLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ImageLabel.BorderSizePixel = 0
-- ASSET ID KAMU DI SINI ↓↓↓
ImageLabel.Image = "rbxassetid://127480462745832"
ImageLabel.ScaleType = Enum.ScaleType.Fit -- Fit, Stretch, Crop, Slice
ImageLabel.Parent = MainFrame

-- Corner untuk gambar
local ImgCorner = Instance.new("UICorner")
ImgCorner.CornerRadius = UDim.new(0, 8)
ImgCorner.Parent = ImageLabel

-- Loading text (while image loads)
local LoadingText = Instance.new("TextLabel")
LoadingText.Size = UDim2.new(1, 0, 1, 0)
LoadingText.BackgroundTransparency = 1
LoadingText.Text = "Loading Image..."
LoadingText.TextColor3 = Color3.fromRGB(200, 200, 200)
LoadingText.TextSize = 14
LoadingText.Font = Enum.Font.Gotham
LoadingText.Parent = ImageLabel

-- Hilangkan loading text setelah gambar load
ImageLabel.Loaded:Connect(function()
    LoadingText:Destroy()
    -- Animasi fade in gambar
    ImageLabel.ImageTransparency = 1
    TweenService:Create(ImageLabel, TweenInfo.new(0.5), {
        ImageTransparency = 0
    }):Play()
end)

-- Jika gagal load
if not ImageLabel.IsLoaded then
    delay(5, function()
        if not ImageLabel.IsLoaded then
            LoadingText.Text = "Failed to load image"
            LoadingText.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
end

-- Judul/Teks di bawah gambar
local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -40, 0, 30)
TitleText.Position = UDim2.new(0, 20, 0, 230)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Image Viewer"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 18
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = MainFrame

-- Info Asset ID
local InfoText = Instance.new("TextLabel")
InfoText.Size = UDim2.new(1, -40, 0, 20)
InfoText.Position = UDim2.new(0, 20, 0, 260)
InfoText.BackgroundTransparency = 1
InfoText.Text = "Asset ID: 127480462745832"
InfoText.TextColor3 = Color3.fromRGB(150, 150, 150)
InfoText.TextSize = 12
InfoText.Font = Enum.Font.Gotham
InfoText.TextXAlignment = Enum.TextXAlignment.Left
InfoText.Parent = MainFrame

-- Tombol Close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    -- Animasi tutup
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    wait(0.3)
    ScreenGui:Destroy()
end)

-- Tombol Execute Script (contoh)
local ExecuteBtn = Instance.new("TextButton")
ExecuteBtn.Size = UDim2.new(0, 360, 0, 40)
ExecuteBtn.Position = UDim2.new(0.5, -180, 0, 290)
ExecuteBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ExecuteBtn.Text = "Execute Main Script"
ExecuteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecuteBtn.TextSize = 16
ExecuteBtn.Font = Enum.Font.GothamSemibold
ExecuteBtn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = ExecuteBtn

-- Hover effect
ExecuteBtn.MouseEnter:Connect(function()
    TweenService:Create(ExecuteBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(0, 150, 230)
    }):Play()
end)

ExecuteBtn.MouseLeave:Connect(function()
    TweenService:Create(ExecuteBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    }):Play()
end)

-- Jalankan script utama
ExecuteBtn.MouseButton1Click:Connect(function()
    print("Script executed!")
    -- Masukkan script utama kamu di sini
    -- loadstring(game:HttpGet("URL_SCRIPT_UTAMA"))()
end)

-- Dragging system (bisa geser UI)
local dragging = false
local dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement or 
       input.UserInputType == Enum.UserInputType.Touch then
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

TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 400, 0, 350),
    Position = UDim2.new(0.5, -200, 0.5, -175)
}):Play()

print("Image UI Loaded! Asset ID: 127480462745832")
