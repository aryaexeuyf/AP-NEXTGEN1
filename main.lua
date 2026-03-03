pcall(function()
    local gui = Instance.new("ScreenGui")
    gui.Parent = game:GetService("CoreGui")
    gui.ResetOnSpawn = false
    
    local img = Instance.new("ImageLabel")
    img.Parent = gui
    img.Image = "rbxassetid://111580113698335"
    img.BackgroundTransparency = 1
    img.Size = UDim2.new(1, 0, 1, 0)
    img.Position = UDim2.new(0, 0, 0, 0)
    img.ZIndex = 999
end)
