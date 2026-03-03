-- main.lua - MINIMAL VERSION
local cg = game:GetService("CoreGui")
if cg:FindFirstChild("G1") then cg:FindFirstChild("G1"):Destroy() end

local g = Instance.new("ScreenGui", cg)
g.Name = "G1"

local f = Instance.new("Frame", g)
f.Size = UDim2.new(0, 350, 0, 300)
f.Position = UDim2.new(0.5, -175, 0.5, -150)
f.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
f.Active = true
f.Draggable = true

Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)

local i = Instance.new("ImageLabel", f)
i.Size = UDim2.new(0, 200, 0, 200)
i.Position = UDim2.new(0.5, -100, 0, 10)
i.BackgroundTransparency = 1
i.Image = "https://raw.githubusercontent.com/aryaexeuyf/Image/main/logo_g1.png"

local b = Instance.new("TextButton", f)
b.Size = UDim2.new(0, 200, 0, 40)
b.Position = UDim2.new(0.5, -100, 1, -60)
b.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
b.Text = "EXECUTE"
b.TextColor3 = Color3.new(1, 1, 1)

Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

local c = Instance.new("TextButton", f)
c.Size = UDim2.new(0, 30, 0, 30)
c.Position = UDim2.new(1, -40, 0, 10)
c.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
c.Text = "X"
c.TextColor3 = Color3.new(1, 1, 1)

b.MouseButton1Click:Connect(function() g:Destroy() end)
c.MouseButton1Click:Connect(function() g:Destroy() end)
