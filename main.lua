-- Overlay Panel v7 | writefile + getcustomasset fix
-- ============================================

local Players          = game:GetService("Players")
local CoreGui          = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer      = Players.LocalPlayer

-- Hapus GUI lama
pcall(function()
    local old = CoreGui:FindFirstChild("OvUI7")
    if old then old:Destroy() end
end)
pcall(function()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then
        local old = pg:FindFirstChild("OvUI7")
        if old then old:Destroy() end
    end
end)

-- ============================================
-- DETEKSI FUNGSI EXECUTOR
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

-- Deteksi getcustomasset / getsynasset
local getAsset = nil
if getcustomasset then
    getAsset = getcustomasset
    print("[OK] getcustomasset tersedia")
elseif getsynasset then
    getAsset = getsynasset
    print("[OK] getsynasset tersedia")
else
    print("[WARN] getcustomasset tidak tersedia")
end

-- Deteksi writefile
local canWrite = (writefile ~= nil)
print("[OK] writefile: " .. tostring(canWrite))
print("[OK] httpFunc: " .. tostring(httpFunc ~= nil))

-- ============================================
-- SCREEN GUI
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "OvUI7"
ScreenGui.ResetOnSpawn   = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder   = 9999

local pOk = pcall(function() ScreenGui.Parent = CoreGui end)
if not pOk then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ============================================
-- OVERLAY IMAGE LABEL (fullscreen, di belakang)
-- ============================================
local OverlayImg = Instance.new("ImageLabel")
OverlayImg.Name                 = "OverlayImg"
OverlayImg.Size                 = UDim2.new(1, 0, 1, 0)
OverlayImg.Position             = UDim2.new(0, 0, 0, 0)
OverlayImg.BackgroundTransparency = 1
OverlayImg.ImageTransparency    = 0
OverlayImg.ScaleType            = Enum.ScaleType.Stretch
OverlayImg.ZIndex               = 1
OverlayImg.Visible              = false
OverlayImg.Image                = ""
OverlayImg.Parent               = ScreenGui

-- ============================================
-- PANEL FRAME
-- ============================================
local Panel = Instance.new("Frame")
Panel.Name                   = "Panel"
Panel.Size                   = UDim2.new(0, 280, 0, 390)
Panel.Position               = UDim2.new(0, 20, 0.5, -195)
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
TitleLbl.Text               = "Overlay Panel v7"
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
-- STATUS & LOG
-- ============================================
local StatusLbl = Instance.new("TextLabel")
StatusLbl.Text               = "Siap. Tekan Load."
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
LogLbl.Text               = "HTTP:" .. tostring(httpFunc~=nil) .. " | Write:" .. tostring(canWrite) .. " | Asset:" .. tostring(getAsset~=nil)
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
-- TOMBOL-TOMBOL
-- ============================================
local function makeBtn(txt, y, r, g, b)
    local btn = Instance.new("TextButton")
    btn.Text             = txt
    btn.Size             = UDim2.new(1, -20, 0, 42)
    btn.Position         = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(r, g, b)
    btn.TextColor3       = Color3.fromRGB(255, 255, 255)
    btn.TextSize         = 13
    btn.Font             = Enum.Font.GothamBold
    btn.BorderSizePixel  = 0
    btn.ZIndex           = 101
    btn.AutoButtonColor  = true
    btn.Parent           = Panel

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent       = btn

    return btn
end

local BtnGithub = makeBtn("Load GitHub PNG",     116, 30,  120, 200)
local BtnIbb    = makeBtn("Load ImgBB JPG",      166, 30,  100, 170)
local BtnToggle = makeBtn("Overlay: Belum Load", 216, 80,  80,  80)
local BtnFull   = makeBtn("Fullscreen Toggle",   266, 80,  60,  180)
local BtnOpaq   = makeBtn("Opacity: 100%",       316, 100, 80,  30)
local BtnClear  = makeBtn("Hapus Overlay",       366, 160, 30,  30)

-- ============================================
-- STATE
-- ============================================
local overlayOn  = false
local isFullscr  = false
local opacityVal = 0
local loadedFile = ""

local function setStatus(msg, r, g, b)
    StatusLbl.Text       = msg
    StatusLbl.TextColor3 = Color3.fromRGB(r or 255, g or 220, b or 80)
    print("[OvUI7] " .. msg)
end

local function clearOverlay()
    OverlayImg.Image   = ""
    OverlayImg.Visible = false
    overlayOn          = false
    loadedFile         = ""
    BtnToggle.Text             = "Overlay: Kosong"
    BtnToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
end

-- ============================================
-- CORE: DOWNLOAD + WRITEFILE + GETCUSTOMASSET
-- ============================================
local function loadImage(url, filename, label)
    if not httpFunc then
        setStatus("GAGAL: Tidak ada HTTP func!", 255, 80, 80)
        return
    end

    setStatus("Downloading: " .. label .. "...", 255, 220, 80)
    LogLbl.Text = url

    task.spawn(function()
        -- Download bytes
        local fetchOk, fetchRes = pcall(function()
            return httpFunc({
                Url     = url,
                Method  = "GET",
                Headers = { ["User-Agent"] = "Mozilla/5.0" }
            })
        end)

        -- Fallback HTTP
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

        if not fetchOk or not fetchRes or not fetchRes.Body or #fetchRes.Body == 0 then
            setStatus("GAGAL download: " .. label, 255, 80, 80)
            LogLbl.Text = tostring(fetchRes):sub(1, 100)
            return
        end

        local bodySize = #fetchRes.Body
        setStatus("Downloaded " .. math.floor(bodySize/1024) .. " KB. Menyimpan...", 255, 220, 80)

        -- ==============================
        -- METODE 1: writefile + getcustomasset
        -- ==============================
        if canWrite and getAsset then
            local writeOk, writeErr = pcall(function()
                writefile(filename, fetchRes.Body)
            end)

            if writeOk then
                local assetOk, assetId = pcall(function()
                    return getAsset(filename)
                end)

                if assetOk and assetId and assetId ~= "" then
                    OverlayImg.Image   = assetId
                    OverlayImg.Visible = true
                    overlayOn          = true
                    loadedFile         = filename
                    BtnToggle.Text             = "Overlay: ON"
                    BtnToggle.BackgroundColor3 = Color3.fromRGB(30, 160, 60)
                    setStatus("BERHASIL [writefile]: " .. label, 80, 255, 120)
                    LogLbl.Text = "Asset: " .. tostring(assetId):sub(1, 40)
                    return
                else
                    setStatus("getcustomasset gagal, coba Drawing...", 255, 200, 0)
                    LogLbl.Text = tostring(assetId):sub(1, 80)
                end
            else
                setStatus("writefile gagal, coba Drawing...", 255, 200, 0)
                LogLbl.Text = tostring(writeErr):sub(1, 80)
            end
        end

        -- ==============================
        -- METODE 2: Drawing.new("Image")
        -- ==============================
        local VP = workspace.CurrentCamera.ViewportSize

        local drawOk = pcall(function()
            -- Hapus drawing lama jika ada
            if ScreenGui:FindFirstChild("DrawingFrame") then
                ScreenGui:FindFirstChild("DrawingFrame"):Destroy()
            end
        end)

        -- Buat ImageLabel fallback dengan Drawing data
        -- Simpan sebagai EditableImage jika tersedia
        if Drawing then
            local newDraw = Drawing.new("Image")

            local setOk, setErr = pcall(function()
                newDraw.Data     = fetchRes.Body
                newDraw.Size     = Vector2.new(VP.X, VP.Y)
                newDraw.Position = Vector2.new(0, 0)
                newDraw.ZIndex   = 1
                newDraw.Visible  = true
            end)

            if setOk then
                -- Simpan referensi di attribute ScreenGui
                ScreenGui:SetAttribute("DrawingActive", true)

                -- Karena Drawing tidak bisa di-toggle via ImageLabel,
                -- buat wrapper agar bisa dikontrol
                overlayOn = true
                loadedFile = "__drawing__"
                BtnToggle.Text             = "Overlay: ON"
                BtnToggle.BackgroundColor3 = Color3.fromRGB(30, 160, 60)
                setStatus("BERHASIL [Drawing]: " .. label, 80, 255, 120)
                LogLbl.Text = "Mode: Drawing API | " .. math.floor(bodySize/1024) .. " KB"

                -- Simpan drawing ke upvalue untuk toggle
                _G["OvUI7_Drawing"] = newDraw
                return
            else
                pcall(function() newDraw:Remove() end)
                setStatus("GAGAL [Drawing]: " .. tostring(setErr):sub(1,60), 255, 80, 80)
                LogLbl.Text = "Semua metode gagal"
            end
        end
    end)
end

-- ============================================
-- BUTTON EVENTS
-- ============================================
BtnGithub.MouseButton1Click:Connect(function()
    loadImage(
        "https://raw.githubusercontent.com/aryaexeuyf/Image/main/logo_g1.png",
        "overlay_img.png",
        "GitHub PNG"
    )
end)

BtnIbb.MouseButton1Click:Connect(function()
    loadImage(
        "https://i.ibb.co/ZR5QDJRJ/c16828dd-d8c9-4574-837c-614bb0730ec9.jpg",
        "overlay_img.jpg",
        "ImgBB JPG"
    )
end)

BtnToggle.MouseButton1Click:Connect(function()
    if not overlayOn and loadedFile == "" then
        setStatus("Load image dulu!", 255, 180, 0)
        return
    end

    overlayOn = not overlayOn

    -- Toggle ImageLabel
    if OverlayImg.Image ~= "" then
        OverlayImg.Visible = overlayOn
    end

    -- Toggle Drawing jika aktif
    if _G["OvUI7_Drawing"] then
        pcall(function()
            _G["OvUI7_Drawing"].Visible = overlayOn
        end)
    end

    if overlayOn then
        BtnToggle.Text             = "Overlay: ON"
        BtnToggle.BackgroundColor3 = Color3.fromRGB(30, 160, 60)
    else
        BtnToggle.Text             = "Overlay: OFF"
        BtnToggle.BackgroundColor3 = Color3.fromRGB(160, 50, 50)
    end
end)

BtnFull.MouseButton1Click:Connect(function()
    isFullscr = not isFullscr
    local VP  = workspace.CurrentCamera.ViewportSize

    if OverlayImg.Image ~= "" then
        if isFullscr then
            OverlayImg.Size     = UDim2.new(1, 0, 1, 0)
            OverlayImg.Position = UDim2.new(0, 0, 0, 0)
        else
            OverlayImg.Size     = UDim2.new(0, 400, 0, 300)
            OverlayImg.Position = UDim2.new(0.5, -200, 0.5, -150)
        end
    end

    if _G["OvUI7_Drawing"] then
        pcall(function()
            if isFullscr then
                _G["OvUI7_Drawing"].Size     = Vector2.new(VP.X, VP.Y)
                _G["OvUI7_Drawing"].Position = Vector2.new(0, 0)
            else
                _G["OvUI7_Drawing"].Size     = Vector2.new(400, 300)
                _G["OvUI7_Drawing"].Position = Vector2.new(VP.X/2-200, VP.Y/2-150)
            end
        end)
    end

    BtnFull.Text = isFullscr and "Ukuran Normal" or "Fullscreen Toggle"
end)

-- Tombol opacity (gelap / terang)
local opacSteps = {0, 0.25, 0.5, 0.75}
local opacIdx   = 1
BtnOpaq.MouseButton1Click:Connect(function()
    opacIdx = (opacIdx % #opacSteps) + 1
    local val = opacSteps[opacIdx]
    OverlayImg.ImageTransparency = val
    if _G["OvUI7_Drawing"] then
        pcall(function()
            _G["OvUI7_Drawing"].Transparency = 1 - val
        end)
    end
    BtnOpaq.Text = "Opacity: " .. math.floor((1 - val) * 100) .. "%"
end)

BtnClear.MouseButton1Click:Connect(function()
    clearOverlay()
    if _G["OvUI7_Drawing"] then
        pcall(function() _G["OvUI7_Drawing"]:Remove() end)
        _G["OvUI7_Drawing"] = nil
    end
    setStatus("Overlay dihapus", 180, 180, 180)
    LogLbl.Text = ""
end)

CloseBtn.MouseButton1Click:Connect(function()
    clearOverlay()
    if _G["OvUI7_Drawing"] then
        pcall(function() _G["OvUI7_Drawing"]:Remove() end)
        _G["OvUI7_Drawing"] = nil
    end
    ScreenGui:Destroy()
end)

-- ============================================
-- DRAG PANEL
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
    pcall(function()
        if _G["OvUI7_Drawing"] then
            _G["OvUI7_Drawing"]:Remove()
            _G["OvUI7_Drawing"] = nil
        end
    end)
end)

print("[OvUI7] Ready!")
