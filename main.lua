-- Overlay Panel v6 | Zero Chain Build
-- ============================================

local Players          = game:GetService("Players")
local CoreGui          = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer      = Players.LocalPlayer

-- ============================================
-- HAPUS GUI LAMA
-- ============================================
pcall(function()
    local old = CoreGui:FindFirstChild("OvUI6")
    if old then old:Destroy() end
end)
pcall(function()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then
        local old = pg:FindFirstChild("OvUI6")
        if old then old:Destroy() end
    end
end)

-- ============================================
-- DETEKSI HTTP
-- ============================================
local httpFunc = nil
if syn and syn.request then
    httpFunc = syn.request
elseif http_request then
    httpFunc = http_request
elseif http and http.request then
    httpFunc = http.request
elseif request then
    httpFunc = request
end

-- Cek Drawing.Image
local hasDrawImg = false
pcall(function()
    local t = Drawing.new("Image")
    t:Remove()
    hasDrawImg = true
end)

-- ============================================
-- SCREEN GUI
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "OvUI6"
ScreenGui.ResetOnSpawn   = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder   = 9999

local parentOk = pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not parentOk then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ============================================
-- PANEL UTAMA
-- ============================================
local Panel = Instance.new("Frame")
Panel.Name                   = "Panel"
Panel.Size                   = UDim2.new(0, 280, 0, 370)
Panel.Position               = UDim2.new(0, 20, 0.5, -185)
Panel.BackgroundColor3       = Color3.fromRGB(14, 14, 14)
Panel.BackgroundTransparency = 0
Panel.BorderSizePixel        = 0
Panel.ZIndex                 = 100
Panel.Active                 = true
Panel.Parent                 = ScreenGui

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0, 12)
PanelCorner.Parent       = Panel

local PanelStroke = Instance.new("UIStroke")
PanelStroke.Color     = Color3.fromRGB(255, 140, 0)
PanelStroke.Thickness = 2
PanelStroke.Parent    = Panel

-- ============================================
-- TITLE BAR
-- ============================================
local TitleBar = Instance.new("Frame")
TitleBar.Name             = "TitleBar"
TitleBar.Size             = UDim2.new(1, 0, 0, 40)
TitleBar.Position         = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
TitleBar.BorderSizePixel  = 0
TitleBar.ZIndex           = 101
TitleBar.Parent           = Panel

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 12)
TitleBarCorner.Parent       = TitleBar

local TitleBarFix = Instance.new("Frame")
TitleBarFix.Size             = UDim2.new(1, 0, 0.5, 0)
TitleBarFix.Position         = UDim2.new(0, 0, 0.5, 0)
TitleBarFix.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
TitleBarFix.BorderSizePixel  = 0
TitleBarFix.ZIndex           = 101
TitleBarFix.Parent           = TitleBar

local TitleLbl = Instance.new("TextLabel")
TitleLbl.Text               = "Overlay Panel"
TitleLbl.Size               = UDim2.new(1, -44, 1, 0)
TitleLbl.Position           = UDim2.new(0, 12, 0, 0)
TitleLbl.BackgroundTransparency = 1
TitleLbl.TextColor3         = Color3.fromRGB(255, 255, 255)
TitleLbl.TextSize           = 14
TitleLbl.Font               = Enum.Font.GothamBold
TitleLbl.TextXAlignment     = Enum.TextXAlignment.Left
TitleLbl.ZIndex             = 102
TitleLbl.Parent             = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text             = "X"
CloseBtn.Size             = UDim2.new(0, 28, 0, 28)
CloseBtn.Position         = UDim2.new(1, -34, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize         = 13
CloseBtn.Font             = Enum.Font.GothamBold
CloseBtn.BorderSizePixel  = 0
CloseBtn.ZIndex           = 103
CloseBtn.Parent           = TitleBar

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 6)
CloseBtnCorner.Parent       = CloseBtn

-- ============================================
-- STATUS LABEL
-- ============================================
local StatusLbl = Instance.new("TextLabel")
StatusLbl.Text               = "Panel loaded! Tekan tombol Load."
StatusLbl.Size               = UDim2.new(1, -20, 0, 22)
StatusLbl.Position           = UDim2.new(0, 10, 0, 48)
StatusLbl.BackgroundTransparency = 1
StatusLbl.TextColor3         = Color3.fromRGB(80, 255, 120)
StatusLbl.TextSize           = 12
StatusLbl.Font               = Enum.Font.Gotham
StatusLbl.TextXAlignment     = Enum.TextXAlignment.Left
StatusLbl.TextWrapped        = true
StatusLbl.ZIndex             = 101
StatusLbl.Parent             = Panel

local LogLbl = Instance.new("TextLabel")
LogLbl.Text               = "HTTP: " .. (httpFunc and "OK" or "NOT FOUND") .. " | Drawing: " .. tostring(hasDrawImg)
LogLbl.Size               = UDim2.new(1, -20, 0, 36)
LogLbl.Position           = UDim2.new(0, 10, 0, 72)
LogLbl.BackgroundTransparency = 1
LogLbl.TextColor3         = Color3.fromRGB(140, 140, 140)
LogLbl.TextSize           = 11
LogLbl.Font               = Enum.Font.Gotham
LogLbl.TextXAlignment     = Enum.TextXAlignment.Left
LogLbl.TextWrapped        = true
LogLbl.ZIndex             = 101
LogLbl.Parent             = Panel

-- ============================================
-- TOMBOL 1: LOAD GITHUB
-- ============================================
local BtnGithub = Instance.new("TextButton")
BtnGithub.Text             = "Load GitHub PNG"
BtnGithub.Size             = UDim2.new(1, -20, 0, 42)
BtnGithub.Position         = UDim2.new(0, 10, 0, 116)
BtnGithub.BackgroundColor3 = Color3.fromRGB(30, 120, 200)
BtnGithub.TextColor3       = Color3.fromRGB(255, 255, 255)
BtnGithub.TextSize         = 13
BtnGithub.Font             = Enum.Font.GothamBold
BtnGithub.BorderSizePixel  = 0
BtnGithub.ZIndex           = 101
BtnGithub.AutoButtonColor  = true
BtnGithub.Parent           = Panel

local BtnGithubCorner = Instance.new("UICorner")
BtnGithubCorner.CornerRadius = UDim.new(0, 8)
BtnGithubCorner.Parent       = BtnGithub

-- ============================================
-- TOMBOL 2: LOAD IMGBB
-- ============================================
local BtnIbb = Instance.new("TextButton")
BtnIbb.Text             = "Load ImgBB JPG"
BtnIbb.Size             = UDim2.new(1, -20, 0, 42)
BtnIbb.Position         = UDim2.new(0, 10, 0, 166)
BtnIbb.BackgroundColor3 = Color3.fromRGB(30, 100, 170)
BtnIbb.TextColor3       = Color3.fromRGB(255, 255, 255)
BtnIbb.TextSize         = 13
BtnIbb.Font             = Enum.Font.GothamBold
BtnIbb.BorderSizePixel  = 0
BtnIbb.ZIndex           = 101
BtnIbb.AutoButtonColor  = true
BtnIbb.Parent           = Panel

local BtnIbbCorner = Instance.new("UICorner")
BtnIbbCorner.CornerRadius = UDim.new(0, 8)
BtnIbbCorner.Parent       = BtnIbb

-- ============================================
-- TOMBOL TOGGLE
-- ============================================
local BtnToggle = Instance.new("TextButton")
BtnToggle.Text             = "Overlay: Belum Load"
BtnToggle.Size             = UDim2.new(1, -20, 0, 42)
BtnToggle.Position         = UDim2.new(0, 10, 0, 216)
BtnToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
BtnToggle.TextColor3       = Color3.fromRGB(255, 255, 255)
BtnToggle.TextSize         = 13
BtnToggle.Font             = Enum.Font.GothamBold
BtnToggle.BorderSizePixel  = 0
BtnToggle.ZIndex           = 101
BtnToggle.AutoButtonColor  = true
BtnToggle.Parent           = Panel

local BtnToggleCorner = Instance.new("UICorner")
BtnToggleCorner.CornerRadius = UDim.new(0, 8)
BtnToggleCorner.Parent       = BtnToggle

-- ============================================
-- TOMBOL FULLSCREEN
-- ============================================
local BtnFull = Instance.new("TextButton")
BtnFull.Text             = "Fullscreen Toggle"
BtnFull.Size             = UDim2.new(1, -20, 0, 42)
BtnFull.Position         = UDim2.new(0, 10, 0, 266)
BtnFull.BackgroundColor3 = Color3.fromRGB(80, 60, 180)
BtnFull.TextColor3       = Color3.fromRGB(255, 255, 255)
BtnFull.TextSize         = 13
BtnFull.Font             = Enum.Font.GothamBold
BtnFull.BorderSizePixel  = 0
BtnFull.ZIndex           = 101
BtnFull.AutoButtonColor  = true
BtnFull.Parent           = Panel

local BtnFullCorner = Instance.new("UICorner")
BtnFullCorner.CornerRadius = UDim.new(0, 8)
BtnFullCorner.Parent       = BtnFull

-- ============================================
-- TOMBOL HAPUS
-- ============================================
local BtnClear = Instance.new("TextButton")
BtnClear.Text             = "Hapus Overlay"
BtnClear.Size             = UDim2.new(1, -20, 0, 42)
BtnClear.Position         = UDim2.new(0, 10, 0, 316)
BtnClear.BackgroundColor3 = Color3.fromRGB(160, 30, 30)
BtnClear.TextColor3       = Color3.fromRGB(255, 255, 255)
BtnClear.TextSize         = 13
BtnClear.Font             = Enum.Font.GothamBold
BtnClear.BorderSizePixel  = 0
BtnClear.ZIndex           = 101
BtnClear.AutoButtonColor  = true
BtnClear.Parent           = Panel

local BtnClearCorner = Instance.new("UICorner")
BtnClearCorner.CornerRadius = UDim.new(0, 8)
BtnClearCorner.Parent       = BtnClear

-- ============================================
-- DRAWING STATE
-- ============================================
local drawImg   = nil
local overlayOn = false
local isFullscr = false
local VP        = workspace.CurrentCamera.ViewportSize

local function destroyDraw()
    if drawImg ~= nil then
        pcall(function()
            drawImg:Remove()
        end)
        drawImg   = nil
        overlayOn = false
    end
end

local function setStatus(msg, r, g, b)
    StatusLbl.Text       = msg
    StatusLbl.TextColor3 = Color3.fromRGB(r or 255, g or 220, b or 80)
    print("[OvUI6] " .. msg)
end

-- ============================================
-- LOAD IMAGE
-- ============================================
local function loadImage(url, label)
    if not httpFunc then
        setStatus("GAGAL: Tidak ada HTTP func!", 255, 80, 80)
        LogLbl.Text = "Executor tidak support request()"
        return
    end
    if not hasDrawImg then
        setStatus("GAGAL: Drawing.Image tidak support!", 255, 80, 80)
        LogLbl.Text = "Update Delta ke versi terbaru"
        return
    end

    setStatus("Fetching: " .. label .. "...", 255, 220, 80)
    LogLbl.Text = url

    task.spawn(function()
        -- Coba HTTPS dulu
        local fetchOk, fetchRes = pcall(function()
            return httpFunc({
                Url     = url,
                Method  = "GET",
                Headers = { ["User-Agent"] = "Mozilla/5.0" }
            })
        end)

        -- Fallback HTTP jika HTTPS gagal
        if not fetchOk or not fetchRes or not fetchRes.Body or #fetchRes.Body == 0 then
            local httpUrl = url:gsub("^https://", "http://")
            fetchOk, fetchRes = pcall(function()
                return httpFunc({
                    Url     = httpUrl,
                    Method  = "GET",
                    Headers = { ["User-Agent"] = "Mozilla/5.0" }
                })
            end)
        end

        if not fetchOk then
            setStatus("GAGAL fetch: " .. label, 255, 80, 80)
            LogLbl.Text = tostring(fetchRes):sub(1, 100)
            return
        end

        if not fetchRes or not fetchRes.Body or #fetchRes.Body == 0 then
            setStatus("GAGAL: Body kosong", 255, 80, 80)
            LogLbl.Text = "Response tidak ada isi"
            return
        end

        -- Hancurkan drawing lama
        destroyDraw()

        -- Buat drawing baru (tanpa chaining sama sekali)
        local newImg = Drawing.new("Image")

        local setOk, setErr = pcall(function()
            newImg.Data     = fetchRes.Body
            newImg.Size     = Vector2.new(VP.X, VP.Y)
            newImg.Position = Vector2.new(0, 0)
            newImg.ZIndex   = 1
            newImg.Visible  = true
        end)

        if setOk then
            drawImg   = newImg
            overlayOn = true
            BtnToggle.Text             = "Overlay: ON"
            BtnToggle.BackgroundColor3 = Color3.fromRGB(30, 160, 60)
            setStatus("BERHASIL: " .. label, 80, 255, 120)
            LogLbl.Text = "Ukuran: " .. math.floor(#fetchRes.Body / 1024) .. " KB"
        else
            pcall(function() newImg:Remove() end)
            setStatus("GAGAL render Drawing", 255, 80, 80)
            LogLbl.Text = tostring(setErr):sub(1, 100)
        end
    end)
end

-- ============================================
-- EVENTS
-- ============================================
BtnGithub.MouseButton1Click:Connect(function()
    loadImage(
        "https://raw.githubusercontent.com/aryaexeuyf/Image/main/logo_g1.png",
        "GitHub PNG"
    )
end)

BtnIbb.MouseButton1Click:Connect(function()
    loadImage(
        "https://i.ibb.co/ZR5QDJRJ/c16828dd-d8c9-4574-837c-614bb0730ec9.jpg",
        "ImgBB JPG"
    )
end)

BtnToggle.MouseButton1Click:Connect(function()
    if drawImg == nil then
        setStatus("Load image dulu!", 255, 180, 0)
        return
    end
    overlayOn = not overlayOn
    drawImg.Visible = overlayOn
    if overlayOn then
        BtnToggle.Text             = "Overlay: ON"
        BtnToggle.BackgroundColor3 = Color3.fromRGB(30, 160, 60)
    else
        BtnToggle.Text             = "Overlay: OFF"
        BtnToggle.BackgroundColor3 = Color3.fromRGB(160, 50, 50)
    end
end)

BtnFull.MouseButton1Click:Connect(function()
    if drawImg == nil then
        setStatus("Load image dulu!", 255, 180, 0)
        return
    end
    isFullscr = not isFullscr
    if isFullscr then
        drawImg.Size     = Vector2.new(VP.X, VP.Y)
        drawImg.Position = Vector2.new(0, 0)
        BtnFull.Text     = "Ukuran Normal"
    else
        drawImg.Size     = Vector2.new(800, 450)
        drawImg.Position = Vector2.new(VP.X/2 - 400, VP.Y/2 - 225)
        BtnFull.Text     = "Fullscreen Toggle"
    end
end)

BtnClear.MouseButton1Click:Connect(function()
    destroyDraw()
    BtnToggle.Text             = "Overlay: Kosong"
    BtnToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    setStatus("Overlay dihapus", 180, 180, 180)
    LogLbl.Text = ""
end)

CloseBtn.MouseButton1Click:Connect(function()
    destroyDraw()
    ScreenGui:Destroy()
end)

-- ============================================
-- DRAG
-- ============================================
local drag, dS, dO = false, nil, nil

TitleBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch
    or inp.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = true
        dS   = inp.Position
        dO   = Panel.Position
    end
end)

UserInputService.InputChanged:Connect(function(inp)
    if not drag then return end
    if inp.UserInputType == Enum.UserInputType.Touch
    or inp.UserInputType == Enum.UserInputType.MouseMovement then
        local d = inp.Position - dS
        Panel.Position = UDim2.new(
            dO.X.Scale, dO.X.Offset + d.X,
            dO.Y.Scale, dO.Y.Offset + d.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch
    or inp.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = false
    end
end)

ScreenGui.AncestryChanged:Connect(function()
    pcall(destroyDraw)
end)

print("[OvUI6] Ready!")
