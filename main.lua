local function CreateOverlay()
    pcall(function()
        -- Hapus yang lama dulu
        for _, ui in pairs(game:GetService("CoreGui"):GetChildren()) do
            if ui.Name == "DeltaOverlay" then
                ui:Destroy()
            end
        end
        
        -- Buat GUI baru
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "DeltaOverlay"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.Parent = game:GetService("CoreGui")
        
        -- Buat Image Label
        local Image = Instance.new("ImageLabel")
        Image.Name = "Overlay"
        Image.Parent = ScreenGui
        Image.BackgroundTransparency = 1
        Image.BorderSizePixel = 0
        Image.Size = UDim2.new(0, 400, 0, 400)
        Image.Position = UDim2.new(0.5, -200, 0.5, -200)
        Image.Image = "rbxassetid://111580113698335"
        Image.ScaleType = Enum.ScaleType.Fit
        Image.ZIndex = 999
    end)
end

CreateOverlay()
print("✓ Overlay berhasil dibuat!")
