-- ============================================
-- MY SCRIPT HUB
-- Version: 1.0
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ============================================
-- FITUR: TELEPORT
-- ============================================
local Teleport = {}

function Teleport.ToPlayer(targetName)
    local target = Players:FindFirstChild(targetName)
    if not target or not target.Character then
        warn("Player tidak ditemukan!")
        return
    end
    
    local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if targetHRP and myHRP then
        myHRP.CFrame = targetHRP.CFrame + Vector3.new(0, 5, 0)
        print("Teleported to: " .. targetName)
    end
end

function Teleport.ToPosition(position)
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if myHRP then
        myHRP.CFrame = CFrame.new(position)
    end
end

-- ============================================
-- GUI Sederhana
-- ============================================
local function CreateGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MyScriptHub"
    ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 300, 0, 400)
    Main.Position = UDim2.new(0.5, -150, 0.5, -200)
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    Title.Text = "MY SCRIPT HUB"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Main
    
    -- Teleport Section
    local TPText = Instance.new("TextLabel")
    TPText.Size = UDim2.new(0.9, 0, 0, 25)
    TPText.Position = UDim2.new(0.05, 0, 0.15, 0)
    TPText.Text = "TELEPORT TO PLAYER"
    TPText.TextColor3 = Color3.new(1, 1, 1)
    TPText.BackgroundTransparency = 1
    TPText.Parent = Main
    
    -- Input Nama
    local Input = Instance.new("TextBox")
    Input.Name = "PlayerInput"
    Input.Size = UDim2.new(0.9, 0, 0, 35)
    Input.Position = UDim2.new(0.05, 0, 0.25, 0)
    Input.PlaceholderText = "Nama player..."
    Input.TextColor3 = Color3.new(1, 1, 1)
    Input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Input.Parent = Main
    
    -- Tombol Teleport
    local TPButton = Instance.new("TextButton")
    TPButton.Size = UDim2.new(0.9, 0, 0, 40)
    TPButton.Position = UDim2.new(0.05, 0, 0.38, 0)
    TPButton.Text = "TELEPORT"
    TPButton.TextColor3 = Color3.new(1, 1, 1)
    TPButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    TPButton.Parent = Main
    
    TPButton.MouseButton1Click:Connect(function()
        Teleport.ToPlayer(Input.Text)
    end)
    
    -- Tombol Close
    local Close = Instance.new("TextButton")
    Close.Size = UDim2.new(0, 30, 0, 30)
    Close.Position = UDim2.new(1, -35, 0, 5)
    Close.Text = "X"
    Close.TextColor3 = Color3.new(1, 1, 1)
    Close.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    Close.Parent = Main
    
    Close.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    print("GUI Loaded!")
end

-- ============================================
-- JALANKAN
-- ============================================
CreateGUI()
print("Script berhasil di-load!")
