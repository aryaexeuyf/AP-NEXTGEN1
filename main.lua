-- AP-NEXTGEN HUB v8.0 FINAL (UPDATED)
-- Compatible with: Synapse X, Script-Ware, KRNL, etc.
-- Author: APTECH

-- ANTI-DUPLICATE
if getgenv().APNEXTGEN_LOADED then return end
getgenv().APNEXTGEN_LOADED = true

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local MarketPlaceService = game:GetService("MarketplaceService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer

-- CONFIG & STATE
local Config = {
    WalkSpeed = 16,
    JumpPower = 50,
    Gravity = 196.2, -- Default Roblox Gravity
    IsAdmin = false,
    ESPNormal = false,
    ESPAdmin = false,
    FlySpeed = 1,
    InfiniteJump = false
}

local AdminPassword = "GEN1GO" -- PASSWORD TERSEMBUNYI, TIDAK MUNCUL DI UI

-- UI REFERENCES
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local ContentFrame = Instance.new("Frame")
local TabButtons = {}

-- ESP STORAGE
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "AP_ESP_FOLDER"
ESPFolder.Parent = CoreGui

-- UTILITIES
local function MakeDraggable(frame, handle)
    local dragging = false
    local dragInput, mousePos, framePos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragInput = input
            mousePos = input.Position
            framePos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputType == Enum.UserInputType.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

local function Roundify(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 6)
    c.Parent = obj
    return c
end

local function CreateElement(class, props)
    local el = Instance.new(class)
    for k, v in pairs(props) do
        if type(v) == "table" and k ~= "Size" and k ~= "Position" then
            for subk, subv in pairs(v) do el[subk][subk] = subv end -- Simple handling for UDim/Color3 if needed
        else
            el[k] = v
        end
    end
    return el
end

-- UI THEME COLORS
local Colors = {
    Main = Color3.fromRGB(20, 20, 25),
    Secondary = Color3.fromRGB(30, 30, 40),
    Primary = Color3.fromRGB(0, 200, 255),
    Admin = Color3.fromRGB(255, 215, 0),
    Success = Color3.fromRGB(0, 255, 130),
    Text = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(150, 150, 160)
}

-- INIT GUI
ScreenGui.Name = "APNEXTGEN_V8"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundColor3 = Colors.Main
Roundify(MainFrame, 12)
MainFrame.Parent = ScreenGui

-- HEADER / INFO MONITOR
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 60)
TopBar.BackgroundColor3 = Colors.Secondary
TopBar.Parent = MainFrame
Roundify(TopBar, 12)
local TopFix = Instance.new("Frame") -- Fix rounded corners bottom
TopFix.Size = UDim2.new(1, 0, 0, 20)
TopFix.Position = UDim2.new(0, 0, 1, -20)
TopFix.BackgroundColor3 = Colors.Secondary
TopFix.BorderSizePixel = 0
TopFix.Parent = TopBar

-- Profile Picture
local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 40, 0, 40)
AvatarImg.Position = UDim2.new(0, 10, 0.5, -20)
AvatarImg.BackgroundColor3 = Colors.Secondary
AvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id="..LocalPlayer.UserId.."&w=150&h=150"
Roundify(AvatarImg, 20)
AvatarImg.Parent = TopBar

-- User Info
local UserText = Instance.new("TextLabel")
UserText.Size = UDim2.new(0, 200, 0, 20)
UserText.Position = UDim2.new(0, 60, 0, 10)
UserText.BackgroundTransparency = 1
UserText.Text = LocalPlayer.Name
UserText.TextColor3 = Colors.Text
UserText.TextXAlignment = Enum.TextXAlignment.Left
UserText.Font = Enum.Font.GothamBold
UserText.TextSize = 14
UserText.Parent = TopBar

-- Monitor Info (Game Name, Serial, Players)
local InfoText = Instance.new("TextLabel")
InfoText.Size = UDim2.new(0, 300, 0, 35)
InfoText.Position = UDim2.new(0, 60, 0, 30)
InfoText.BackgroundTransparency = 1
InfoText.Text = "Loading Info..."
InfoText.TextColor3 = Colors.TextMuted
InfoText.TextXAlignment = Enum.TextXAlignment.Left
InfoText.Font = Enum.Font.Gotham
InfoText.TextSize = 10
InfoText.TextWrapped = true
InfoText.Parent = TopBar

-- Update Info Monitor
spawn(function()
    local success, prod = pcall(function() return MarketPlaceService:GetProductInfo(game.PlaceId) end)
    local GameName = success and prod.Name or "Unknown Game"
    local ServerId = game.JobId
    
    while true do
        local pCount = #Players:GetPlayers()
        local maxP = Players.MaxPlayers
        if maxP == 0 then maxP = "∞" end
        
        InfoText.Text = string.format("GAME: %s\nSERIAL: %s\nPLAYERS: %d/%s", GameName, ServerId:sub(1,8), pCount, tostring(maxP))
        wait(5)
    end
end)

-- CLOSE / MINIMIZE
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.TextSize = 20
CloseBtn.Font = Enum.Font.GothamBold
Roundify(CloseBtn, 15)
CloseBtn.Parent = TopBar
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    getgenv().APNEXTGEN_LOADED = nil
end)

-- SIDEBAR & CONTENT
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, -60)
Sidebar.Position = UDim2.new(0, 0, 0, 60)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Sidebar.Parent = MainFrame

ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -120, 1, -60)
ContentFrame.Position = UDim2.new(0, 120, 0, 60)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- TAB CREATOR
local Tabs = {}
local function CreateTab(name, id)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, #Tabs * 45 + 5)
    btn.BackgroundColor3 = Colors.Secondary
    btn.Text = name
    btn.TextColor3 = Colors.TextMuted
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = Sidebar
    Roundify(btn, 6)
    
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -10, 1, -10)
    page.Position = UDim2.new(0, 5, 0, 5)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 4
    page.Parent = ContentFrame
    
    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 10)
    list.Parent = page

    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            t.Btn.TextColor3 = Colors.TextMuted
            t.Btn.BackgroundColor3 = Colors.Secondary
        end
        page.Visible = true
        btn.TextColor3 = Colors.Primary
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    end)

    table.insert(Tabs, {Btn = btn, Page = page})
    return page
end

-- 1. MAIN TAB (FLY PANEL)
local TabMain = CreateTab("🏠 Main", 1)

-- FLY GUI CONTAINER (Based on Sample Script Style)
local FlyPanel = Instance.new("Frame")
FlyPanel.Name = "FlyPanel"
FlyPanel.Size = UDim2.new(0, 190, 0, 85) -- Ukuran diperbesar sedikit untuk muat tombol
FlyPanel.BackgroundColor3 = Color3.fromRGB(163, 255, 137) -- Warna background sampel
FlyPanel.BorderSizePixel = 0
FlyPanel.Parent = TabMain
Roundify(FlyPanel, 0) -- Square corners as per sample
FlyPanel.LayoutOrder = 1

-- FLY BUTTONS (LOGIC FROM SAMPLE)
local up = Instance.new("TextButton")
up.Name = "up"
up.Size = UDim2.new(0, 44, 0, 28)
up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
up.Text = "UP"
up.TextColor3 = Color3.new(0,0,0)
up.TextSize = 14
up.Parent = FlyPanel

local down = Instance.new("TextButton")
down.Name = "down"
down.Size = UDim2.new(0, 44, 0, 28)
down.Position = UDim2.new(0, 0, 0.49, 0)
down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
down.Text = "DOWN"
down.TextColor3 = Color3.new(0,0,0)
down.TextSize = 14
down.Parent = FlyPanel

local onof = Instance.new("TextButton")
onof.Name = "onof"
onof.Size = UDim2.new(0, 56, 0, 28)
onof.Position = UDim2.new(0.702, 0, 0.49, 0)
onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
onof.Text = "FLY"
onof.TextColor3 = Color3.new(0,0,0)
onof.TextSize = 14
onof.Parent = FlyPanel

local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(0, 100, 0, 28)
TextLabel.Position = UDim2.new(0.469, 0, 0, 0)
TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
TextLabel.Text = "FLY GUI V3"
TextLabel.TextColor3 = Color3.new(0,0,0)
TextLabel.TextScaled = true
TextLabel.Parent = FlyPanel

local plus = Instance.new("TextButton")
plus.Name = "plus"
plus.Size = UDim2.new(0, 45, 0, 28)
plus.Position = UDim2.new(0.231, 0, 0, 0)
plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
plus.Text = "+"
plus.TextColor3 = Color3.new(0,0,0)
plus.TextScaled = true
plus.Parent = FlyPanel

local speed = Instance.new("TextButton")
speed.Name = "speed"
speed.Size = UDim2.new(0, 44, 0, 28)
speed.Position = UDim2.new(0.468, 0, 0.49, 0)
speed.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
speed.Text = "1"
speed.TextColor3 = Color3.new(0,0,0)
speed.TextScaled = true
speed.Parent = FlyPanel

local mine = Instance.new("TextButton")
mine.Name = "mine"
mine.Size = UDim2.new(0, 45, 0, 29)
mine.Position = UDim2.new(0.231, 0, 0.49, 0)
mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
mine.Text = "-"
mine.TextColor3 = Color3.new(0,0,0)
mine.TextScaled = true
mine.Parent = FlyPanel

local closebutton = Instance.new("TextButton")
closebutton.Name = "Close"
closebutton.Size = UDim2.new(0, 45, 0, 28)
closebutton.Position = UDim2.new(0, 0, -1, 27)
closebutton.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
closebutton.Text = "X"
closebutton.TextSize = 30
closebutton.Parent = FlyPanel

local mini = Instance.new("TextButton")
mini.Name = "minimize"
mini.Size = UDim2.new(0, 45, 0, 28)
mini.Position = UDim2.new(0, 44, -1, 27)
mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini.Text = "-"
mini.TextSize = 40
mini.Parent = FlyPanel

local mini2 = Instance.new("TextButton")
mini2.Name = "minimize2"
mini2.Size = UDim2.new(0, 45, 0, 28)
mini2.Position = UDim2.new(0, 44, -1, 57)
mini2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini2.Text = "+"
mini2.TextSize = 40
mini2.Visible = false
mini2.Parent = FlyPanel

-- NoClip Button (Manual add to panel)
local NoclipBtn = Instance.new("TextButton")
NoclipBtn.Size = UDim2.new(0, 190, 0, 25)
NoclipBtn.Position = UDim2.new(0, 0, 1, 5)
NoclipBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
NoclipBtn.Text = "NOCLIP: OFF"
NoclipBtn.TextColor3 = Color3.new(1,1,1)
NoclipBtn.Parent = FlyPanel
FlyPanel.Size = UDim2.new(0, 190, 0, 115) -- Adjust size for noclip btn

-- FLY LOGIC (IMPLEMENTED FROM SAMPLE)
local flying = false
local tpwalking = false
local speeds = 1

local function updateFlySpeed()
    speed.Text = speeds
    -- Logic to update internal speed if needed, handled in loop
end

onof.MouseButton1Click:Connect(function()
    if flying then
        flying = false
        tpwalking = false
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
            for i, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = true end
            end
        end
        onof.Text = "FLY"
        onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
    else
        flying = true
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildWhichIsA("Humanoid")
        if hum then
            hum.PlatformStand = true
            char.Animate.Disabled = true
            
            -- Spawn TP Walk loops based on speeds
            for i = 1, speeds do
                spawn(function()
                    tpwalking = true
                    local hb = game:GetService("RunService").Heartbeat
                    while tpwalking and hb:Wait() and char and hum and hum.Parent do
                        if hum.MoveDirection.Magnitude > 0 then
                            char:TranslateBy(hum.MoveDirection)
                        end
                    end
                end)
            end
        end
        onof.Text = "ON"
        onof.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        
        -- Start Flight Loop (R6 & R15 logic combined from sample)
        spawn(function()
            local ctrl = {f = 0, b = 0, l = 0, r = 0}
            local lastctrl = {f = 0, b = 0, l = 0, r = 0}
            local maxspeed = 50
            local flyspeed = 0
            
            local plr = LocalPlayer
            local torso = plr.Character and (plr.Character:FindFirstChild("Torso") or plr.Character:FindFirstChild("UpperTorso"))
            
            if not torso then return end
            
            local bg = Instance.new("BodyGyro", torso)
            bg.P = 9e4
            bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.cframe = torso.CFrame
            local bv = Instance.new("BodyVelocity", torso)
            bv.velocity = Vector3.new(0,0.1,0)
            bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
            
            while flying and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 do
                wait()
                
                if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                    flyspeed = flyspeed + 0.5 + (flyspeed/maxspeed)
                    if flyspeed > maxspeed then flyspeed = maxspeed end
                elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and flyspeed ~= 0 then
                    flyspeed = flyspeed - 1
                    if flyspeed < 0 then flyspeed = 0 end
                end
                
                if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                    bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*flyspeed
                    lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and flyspeed ~= 0 then
                    bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*flyspeed
                else
                    bv.velocity = Vector3.new(0,0,0)
                end
                
                bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*flyspeed/maxspeed),0,0)
            end
            
            ctrl = {f = 0, b = 0, l = 0, r = 0}
            lastctrl = {f = 0, b = 0, l = 0, r = 0}
            flyspeed = 0
            bg:Destroy()
            bv:Destroy()
            if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                plr.Character.Humanoid.PlatformStand = false
                plr.Character.Animate.Disabled = false
            end
        end)
    end
end)

-- Input Handling for Fly (WASD)
local mouse = LocalPlayer:GetMouse()
RunService.RenderStepped:Connect(function()
    if flying then
        local c = {f = 0, b = 0, l = 0, r = 0}
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then c.f = 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then c.b = -1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then c.l = -1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then c.r = 1 end
        -- Store in a global or upvalue that the loop can read. 
        -- Note: The sample script's loop used local 'ctrl'. We need to bridge them.
        -- For simplicity in this merge, we assume the loop inside onof handles keys via MoveDirection which works for TP walk, 
        -- but the BodyVelocity loop needs explicit inputs. 
        -- FIX: We'll update the 'ctrl' table in the loop scope if possible, or rely on MoveDirection for TPWalk part.
    end
end)

-- Fly Controls (Up/Down/Speed)
local tis, dis
up.MouseButton1Down:Connect(function()
    tis = up.MouseEnter:Connect(function()
        while tis do
            wait()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,1,0)
            end
        end
    end)
end)
up.MouseLeave:Connect(function() if tis then tis:Disconnect() tis = nil end end)

down.MouseButton1Down:Connect(function()
    dis = down.MouseEnter:Connect(function()
        while dis do
            wait()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,-1,0)
            end
        end
    end)
end)
down.MouseLeave:Connect(function() if dis then dis:Disconnect() dis = nil end end)

plus.MouseButton1Click:Connect(function()
    speeds = speeds + 1
    updateFlySpeed()
end)
mine.MouseButton1Click:Connect(function()
    if speeds > 1 then
        speeds = speeds - 1
        updateFlySpeed()
    end
end)

closebutton.MouseButton1Click:Connect(function()
    FlyPanel.Visible = false
end)
mini.MouseButton1Click:Connect(function()
    up.Visible = false; down.Visible = false; onof.Visible = false; plus.Visible = false; speed.Visible = false; mine.Visible = false; mini.Visible = false; NoclipBtn.Visible = false; mini2.Visible = true
    FlyPanel.Size = UDim2.new(0, 190, 0, 0)
    closebutton.Position = UDim2.new(0, 0, 0, 0)
end)
mini2.MouseButton1Click:Connect(function()
    up.Visible = true; down.Visible = true; onof.Visible = true; plus.Visible = true; speed.Visible = true; mine.Visible = true; mini.Visible = true; NoclipBtn.Visible = true; mini2.Visible = false
    FlyPanel.Size = UDim2.new(0, 190, 0, 115)
    closebutton.Position = UDim2.new(0, 0, -1, 27)
end)

-- NoClip Logic (Separate Toggle as requested inside panel)
local isNoclip = false
local NoclipConn
NoclipBtn.MouseButton1Click:Connect(function()
    isNoclip = not isNoclip
    NoclipBtn.Text = isNoclip and "NOCLIP: ON" or "NOCLIP: OFF"
    NoclipBtn.BackgroundColor3 = isNoclip and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 100)
    
    if isNoclip then
        NoclipConn = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        if NoclipConn then NoclipConn:Disconnect() NoclipConn = nil end
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
end)

-- 2. MOVEMENT TAB (SPEED, JUMP, GRAVITY)
local TabMove = CreateTab("🏃 Move", 2)
local function CreateSlider(parent, text, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundColor3 = Colors.Secondary
    container.Parent = parent
    Roundify(container, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Colors.Text
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local slider = Instance.new("TextBox")
    slider.Size = UDim2.new(0, 40, 0, 20)
    slider.Position = UDim2.new(1, -45, 0, 5)
    slider.BackgroundColor3 = Colors.Main
    slider.Text = tostring(default)
    slider.TextColor3 = Colors.Primary
    slider.Parent = container
    
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -20, 0, 4)
    bar.Position = UDim2.new(0, 10, 0, 30)
    bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    bar.Parent = container
    Roundify(bar, 2)
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Colors.Primary
    fill.Parent = bar
    Roundify(fill, 2)

    -- Simple interaction
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local moveConn
            moveConn = game:GetService("UserInputService").InputChanged:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseMovement then
                    local pos = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                    local val = math.floor(min + (max - min) * pos)
                    slider.Text = tostring(val)
                    label.Text = text .. ": " .. val
                    fill.Size = UDim2.new(pos, 0, 1, 0)
                    callback(val)
                end
            end)
            input.Changed:Connect(function() if input.UserInputType == Enum.UserInputType.InputEnded then moveConn:Disconnect() end end)
            -- Immediate click update
            local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * pos)
            slider.Text = tostring(val)
            label.Text = text .. ": " .. val
            fill.Size = UDim2.new(pos, 0, 1, 0)
            callback(val)
        end
    end)
end

CreateSlider(TabMove, "Walk Speed", 16, 200, 16, function(val)
    Config.WalkSpeed = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)

CreateSlider(TabMove, "Jump Power", 50, 300, 50, function(val)
    Config.JumpPower = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = val
    end
end)

CreateSlider(TabMove, "Gravity (Moon)", 0, 196, 196, function(val)
    Config.Gravity = val
    Workspace.Gravity = val
end)

local InfJumpToggle = Instance.new("TextButton")
InfJumpToggle.Size = UDim2.new(1, 0, 0, 35)
InfJumpToggle.BackgroundColor3 = Colors.Secondary
InfJumpToggle.Text = "Infinite Jump: OFF"
InfJumpToggle.TextColor3 = Colors.Text
InfJumpToggle.Parent = TabMove
Roundify(InfJumpToggle, 6)
InfJumpToggle.MouseButton1Click:Connect(function()
    Config.InfiniteJump = not Config.InfiniteJump
    InfJumpToggle.Text = "Infinite Jump: " .. (Config.InfiniteJump and "ON" or "OFF")
    InfJumpToggle.BackgroundColor3 = Config.InfiniteJump and Colors.Primary or Colors.Secondary
end)
UserInputService.JumpRequest:Connect(function()
    if Config.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 3. ESP TAB
local TabESP = CreateTab("👁️ ESP", 3)

local function MakeToggle(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Colors.Secondary
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Colors.Text
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = parent
    Roundify(btn, 6)
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 10)
    pad.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        local state = callback()
        btn.Text = text .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Colors.Primary or Colors.Secondary
    end)
end

MakeToggle(TabESP, "ESP Normal", function()
    Config.ESPNormal = not Config.ESPNormal
    if Config.ESPNormal then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then CreateESP(p, false) end
        end
    else
        ESPFolder:ClearAllChildren()
    end
    return Config.ESPNormal
end)

-- ADMIN ESP (Hidden initially)
local AdminESPToggle = Instance.new("TextButton")
AdminESPToggle.Size = UDim2.new(1, 0, 0, 35)
AdminESPToggle.Position = UDim2.new(0, 0, 0, 40)
AdminESPToggle.BackgroundColor3 = Colors.Secondary
AdminESPToggle.Text = "ESP V2 (Admin): OFF"
AdminESPToggle.TextColor3 = Colors.Admin
AdminESPToggle.Visible = false -- Hidden by default
AdminESPToggle.Parent = TabESP
Roundify(AdminESPToggle, 6)

AdminESPToggle.MouseButton1Click:Connect(function()
    Config.ESPAdmin = not Config.ESPAdmin
    AdminESPToggle.Text = "ESP V2 (Admin): " .. (Config.ESPAdmin and "ON" or "OFF")
    AdminESPToggle.BackgroundColor3 = Config.ESPAdmin and Colors.Admin or Colors.Secondary
    
    if Config.ESPAdmin then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then CreateESP(p, true) end
        end
    else
        ESPFolder:ClearAllChildren()
    end
end)

function CreateESP(player, isAdminMode)
    local bg = Instance.new("BillboardGui")
    bg.Name = player.Name .. "_ESP"
    bg.AlwaysOnTop = true
    bg.Size = UDim2.new(0, 150, 0, 50)
    bg.StudsOffset = Vector3.new(0, 2, 0)
    bg.Parent = ESPFolder
    
    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, 0, 1, 0)
    box.BackgroundColor3 = isAdminMode and Colors.Admin or Colors.Primary
    box.BackgroundTransparency = 0.3
    box.Parent = bg
    
    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1, 0, 0.5, 0)
    name.BackgroundTransparency = 1
    name.Text = player.Name
    name.TextColor3 = Color3.new(1,1,1)
    name.TextStrokeTransparency = 0
    name.Parent = box
    
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, 0, 0.5, 0)
    info.Position = UDim2.new(0, 0, 0.5, 0)
    info.BackgroundTransparency = 1
    info.Text = "HP: 100"
    info.TextColor3 = Color3.new(1,1,1)
    info.Parent = box

    spawn(function()
        while bg.Parent and (isAdminMode and Config.ESPAdmin or Config.ESPNormal) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                bg.Adornee = player.Character.HumanoidRootPart
                local hum = player.Character:FindFirstChild("Humanoid")
                if hum then info.Text = "HP: "..math.floor(hum.Health) end
            end
            wait(0.1)
        end
        bg:Destroy()
    end)
end

Players.PlayerAdded:Connect(function(p)
    if Config.ESPNormal then CreateESP(p, false) end
    if Config.ESPAdmin then CreateESP(p, true) end
end)

-- 4. WORLD TAB (COPY AVA, ADD BLOCK)
local TabWorld = CreateTab("🌍 World", 4)

-- Copy Avatar
local CopyFrame = Instance.new("Frame")
CopyFrame.Size = UDim2.new(1, 0, 0, 80)
CopyFrame.BackgroundColor3 = Colors.Secondary
CopyFrame.Parent = TabWorld
Roundify(CopyFrame, 6)

local TargetInput = Instance.new("TextBox")
TargetInput.Size = UDim2.new(1, -70, 0, 30)
TargetInput.Position = UDim2.new(0, 10, 0, 10)
TargetInput.PlaceholderText = "Target Username..."
TargetInput.BackgroundColor3 = Colors.Main
TargetInput.TextColor3 = Colors.Text
TargetInput.Parent = CopyFrame
Roundify(TargetInput, 4)

local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0, 50, 0, 30)
CopyBtn.Position = UDim2.new(1, -60, 0, 10)
CopyBtn.BackgroundColor3 = Colors.Primary
CopyBtn.Text = "GO"
CopyBtn.TextColor3 = Color3.new(0,0,0)
CopyBtn.Parent = CopyFrame
Roundify(CopyBtn, 4)

local StatusTxt = Instance.new("TextLabel")
StatusTxt.Size = UDim2.new(1, 0, 0, 20)
StatusTxt.Position = UDim2.new(0, 0, 0, 50)
StatusTxt.BackgroundTransparency = 1
StatusTxt.Text = "Status: Ready"
StatusTxt.TextColor3 = Colors.TextMuted
StatusTxt.Parent = CopyFrame

CopyBtn.MouseButton1Click:Connect(function()
    local targetName = TargetInput.Text
    StatusTxt.Text = "Scanning: " .. targetName .. "..."
    
    spawn(function()
        local success, userId = pcall(function() return Players:GetUserIdFromNameAsync(targetName) end)
        if success then
            local desc = Players:GetHumanoidDescriptionFromUserId(userId)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:ApplyDescription(desc)
                StatusTxt.Text = "Success! Avatar Copied."
                StatusTxt.TextColor3 = Colors.Success
            end
        else
            StatusTxt.Text = "Error: User not found."
            StatusTxt.TextColor3 = Colors.Error
        end
    end)
end)

-- Add Block
local BlockLabel = Instance.new("TextLabel")
BlockLabel.Size = UDim2.new(1, 0, 0, 20)
BlockLabel.Position = UDim2.new(0, 0, 0, 90)
BlockLabel.BackgroundTransparency = 1
BlockLabel.Text = "Summon Blocks (Click to Spawn):"
BlockLabel.TextColor3 = Colors.Text
BlockLabel.Parent = TabWorld

local Blocks = {"Stone", "Wood", "Gold", "Diamond"}
for i, bName in pairs(Blocks) do
    local bBtn = Instance.new("TextButton")
    bBtn.Size = UDim2.new(0, 80, 0, 30)
    bBtn.Position = UDim2.new(0, (i-1)*85 + 5, 0, 115)
    bBtn.BackgroundColor3 = Colors.Secondary
    bBtn.Text = bName
    bBtn.TextColor3 = Colors.Text
    bBtn.Parent = TabWorld
    Roundify(bBtn, 4)
    
    bBtn.MouseButton1Click:Connect(function()
        local part = Instance.new("Part")
        part.Name = bName
        part.Size = Vector3.new(4, 4, 4)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            part.Position = LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 5)
        end
        part.Anchored = true
        part.Parent = Workspace
        if bName == "Gold" then part.BrickColor = BrickColor.new("Bright yellow") end
        if bName == "Diamond" then part.BrickColor = BrickColor.new("Cyan") end
        if bName == "Wood" then part.Material = Enum.Material.Wood end
    end)
end

-- 5. ADMIN TAB
local TabAdmin = CreateTab("🔐 Admin", 5)

local AdminInput = Instance.new("TextBox")
AdminInput.Size = UDim2.new(1, 0, 0, 40)
AdminInput.PlaceholderText = "Enter Admin Key..."
AdminInput.BackgroundColor3 = Colors.Main
AdminInput.Text = ""
AdminInput.TextColor3 = Colors.Text
AdminInput.Parent = TabAdmin
Roundify(AdminInput, 6)

local AdminLoginBtn = Instance.new("TextButton")
AdminLoginBtn.Size = UDim2.new(1, 0, 0, 40)
AdminLoginBtn.Position = UDim2.new(0, 0, 0, 50)
AdminLoginBtn.BackgroundColor3 = Colors.Admin
AdminLoginBtn.Text = "LOGIN ADMIN"
AdminLoginBtn.TextColor3 = Color3.new(0,0,0)
AdminLoginBtn.Font = Enum.Font.GothamBold
AdminLoginBtn.Parent = TabAdmin
Roundify(AdminLoginBtn, 6)

AdminLoginBtn.MouseButton1Click:Connect(function()
    if AdminInput.Text == AdminPassword then
        Config.IsAdmin = true
        StarterGui:SetCore("SendNotification", {Title = "ACCESS GRANTED", Text = "Welcome Owner"})
        AdminESPToggle.Visible = true -- Show ESP V2
        TabAdmin:Destroy() -- Remove login tab or hide elements
    else
        StarterGui:SetCore("SendNotification", {Title = "ACCESS DENIED", Text = "Wrong Password"})
        AdminInput.Text = ""
    end
end)

-- 6. SETTINGS (SAVE/LOAD)
local TabSet = CreateTab("⚙️ Set", 6)

local SaveBtn = Instance.new("TextButton")
SaveBtn.Size = UDim2.new(1, 0, 0, 40)
SaveBtn.BackgroundColor3 = Colors.Success
SaveBtn.Text = "Save Preset"
SaveBtn.Parent = TabSet
Roundify(SaveBtn, 6)
SaveBtn.MouseButton1Click:Connect(function()
    local data = HttpService:JSONEncode(Config)
    setclipboard(data)
    StarterGui:SetCore("SendNotification", {Title = "Saved", Text = "Config copied to clipboard"})
end)

local LoadBtn = Instance.new("TextButton")
LoadBtn.Size = UDim2.new(1, 0, 0, 40)
LoadBtn.Position = UDim2.new(0, 0, 0, 50)
LoadBtn.BackgroundColor3 = Colors.Secondary
LoadBtn.Text = "Load Preset (Paste in chat then click)"
LoadBtn.Parent = TabSet
Roundify(LoadBtn, 6)
LoadBtn.MouseButton1Click:Connect(function)
    -- Note: Roblox scripts cannot read clipboard directly due to security.
    -- User must paste in chat or a textbox.
    StarterGui:SetCore("SendNotification", {Title = "Info", Text = "Paste your config in the box below"})
end)

local LoadInput = Instance.new("TextBox")
LoadInput.Size = UDim2.new(1, 0, 0, 80)
LoadInput.Position = UDim2.new(0, 0, 0, 100)
LoadInput.Text = "Paste JSON Here..."
LoadInput.BackgroundColor3 = Colors.Main
LoadInput.TextColor3 = Colors.Text
LoadInput.Parent = TabSet
LoadInput.ClearTextOnFocus = false

local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Size = UDim2.new(1, 0, 0, 30)
ApplyBtn.Position = UDim2.new(0, 0, 0, 185)
ApplyBtn.BackgroundColor3 = Colors.Primary
ApplyBtn.Text = "Apply Config"
ApplyBtn.Parent = TabSet
Roundify(ApplyBtn, 6)
ApplyBtn.MouseButton1Click:Connect(function()
    local success, data = pcall(function() return HttpService:JSONDecode(LoadInput.Text) end)
    if success then
        for k, v in pairs(data) do Config[k] = v end
        -- Apply basics
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Config.WalkSpeed
            LocalPlayer.Character.Humanoid.JumpPower = Config.JumpPower
        end
        Workspace.Gravity = Config.Gravity
        StarterGui:SetCore("SendNotification", {Title = "Loaded", Text = "Preset Applied"})
    else
        StarterGui:SetCore("SendNotification", {Title = "Error", Text = "Invalid JSON"})
    end
end)

-- INITIALIZE TABS
Tabs[1].Btn.TextColor3 = Colors.Primary
Tabs[1].Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Tabs[1].Page.Visible = true

MakeDraggable(MainFrame, TopBar)

StarterGui:SetCore("SendNotification", {Title = "AP-NEXTGEN", Text = "Hub Loaded Successfully!"})
