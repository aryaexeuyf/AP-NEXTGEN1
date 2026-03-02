local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function KillAllPlayers()
    for _, player in pairs(Players:GetPlayers()) do
        -- Pastikan bukan diri sendiri
        if player ~= LocalPlayer then
            local character = player.Character
            if character and character:FindFirstChild("Humanoid") then
                -- Ini hanya bekerja jika game mengizinkan client mengubah health pemain lain
                -- Kebanyakan game modern akan memblokir ini.
                character.Humanoid.Health = 0 
            end
        end
    end
end

-- Memanggil fungsi
KillAllPlayers()
