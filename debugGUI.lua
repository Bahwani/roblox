-- Layanan Roblox
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Variabel Fly
local flyEnabled = false
local flyBodyVelocity = nil

-- Variabel Speed
local speedEnabled = false
local normalSpeed = 16
local fastSpeed = 36

-- Variabel Debug Log
local debugEnabled = false
local debugGui = nil

-- Buat GUI utama
local gui = Instance.new("ScreenGui")
gui.Name = "PetoGacorrawr"
gui.Parent = game.CoreGui

-- Frame utama
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 200) -- tambah tinggi untuk tombol debug
frame.Position = UDim2.new(0.5, -100, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Active = true
frame.Draggable = true

-- Frame kecil (minimized)
local miniFrame = Instance.new("TextButton")
miniFrame.Size = UDim2.new(0, 50, 0, 30)
miniFrame.Position = UDim2.new(0.5, -25, 0.5, -15)
miniFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
miniFrame.BorderSizePixel = 0
miniFrame.Parent = gui
miniFrame.Visible = false
miniFrame.Active = true
miniFrame.Draggable = true
miniFrame.Text = ""

-- Label logo kecil di miniFrame
local miniLabel = Instance.new("TextLabel")
miniLabel.Size = UDim2.new(1, 0, 1, 0)
miniLabel.BackgroundTransparency = 1
miniLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
miniLabel.Text = "P"
miniLabel.TextScaled = true
miniLabel.Parent = miniFrame
miniLabel.Active = false

-- Tombol Fly Toggle
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(1, -10, 0, 30)
flyButton.Position = UDim2.new(0, 5, 0, 35)
flyButton.Text = "Fly: OFF"
flyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Parent = frame

-- Tombol Speed Toggle
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(1, -10, 0, 30)
speedButton.Position = UDim2.new(0, 5, 0, 75)
speedButton.Text = "Speed: OFF"
speedButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.Parent = frame

-- Tombol Debug Toggle
local debugButton = Instance.new("TextButton")
debugButton.Size = UDim2.new(1, -10, 0, 30)
debugButton.Position = UDim2.new(0, 5, 0, 115)
debugButton.Text = "Debug Log: OFF"
debugButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
debugButton.TextColor3 = Color3.fromRGB(255, 255, 255)
debugButton.Parent = frame

-- Tombol Minimize
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -65, 0, 0)
minimizeButton.Text = "-"
minimizeButton.Parent = frame
minimizeButton.Active = true

-- Tombol Close
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 0)
closeButton.Text = "X"
closeButton.Parent = frame
closeButton.Active = true

-- Label Judul
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 0, 30)
title.Position = UDim2.new(0, 5, 0, 0)
title.Text = "PetoGacorrawr"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- Fungsi toggle fly
local function toggleFly()
    flyEnabled = not flyEnabled
    flyButton.Text = flyEnabled and "Fly: ON" or "Fly: OFF"

    if flyEnabled then
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.Name = "FlyVelocity"
        flyBodyVelocity.Velocity = Vector3.new(0, 50, 0)
        flyBodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        flyBodyVelocity.P = 1250
        flyBodyVelocity.Parent = humanoidRootPart
    else
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
    end
end

-- Fungsi toggle speed jalan cepat
local function toggleSpeed()
    speedEnabled = not speedEnabled
    speedButton.Text = speedEnabled and "Speed: ON" or "Speed: OFF"

    if speedEnabled then
        humanoid.WalkSpeed = fastSpeed
    else
        humanoid.WalkSpeed = normalSpeed
    end
end

-- Fungsi untuk buat debug GUI
local function createDebugGui()
    -- Jika sudah ada, jangan buat ulang
    if debugGui then return end

    debugGui = Instance.new("ScreenGui")
    debugGui.Name = "DebugLogGui"
    debugGui.Parent = player:WaitForChild("PlayerGui")

    local frameDebug = Instance.new("Frame")
    frameDebug.Size = UDim2.new(0, 400, 0, 200)
    frameDebug.Position = UDim2.new(0, 10, 0, 10)
    frameDebug.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frameDebug.BackgroundTransparency = 0.8
    frameDebug.BorderSizePixel = 0
    frameDebug.Parent = debugGui

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -10, 1, -10)
    scrollFrame.Position = UDim2.new(0, 5, 0, 5)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.Parent = frameDebug

    local uiList = Instance.new("UIListLayout")
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Parent = scrollFrame

    -- Fungsi internal untuk convert args ke string
    local function argsToString(args)
        local parts = {}
        for i, v in ipairs(args) do
            parts[#parts + 1] = tostring(v)
        end
        return table.concat(parts, ", ")
    end

    -- Fungsi untuk tambah log pesan
    local function addLog(message)
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, -10, 0, 18)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.new(1, 1, 1)
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.Font = Enum.Font.SourceSans
        textLabel.TextSize = 16
        textLabel.Text = message
        textLabel.Parent = scrollFrame

        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y)
        scrollFrame.CanvasPosition = Vector2.new(0, uiList.AbsoluteContentSize.Y)
    end

    -- Simpan fungsi ini supaya bisa dipakai hook
    debugGui.AddLog = addLog
    debugGui.ArgsToString = argsToString
end

-- Hook remote call (disiapkan tapi aktif sesuai debugEnabled)
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

local function enableDebugHook()
    mt.__namecall = function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        if method == "FireServer" and tostring(self) == "Remote" then
            if debugGui and debugGui.AddLog then
                debugGui.AddLog("Remote FireServer called with args: " .. debugGui.ArgsToString(args))
            end
        end
        return oldNamecall(self, ...)
    end
end

local function disableDebugHook()
    mt.__namecall = oldNamecall
end

-- Toggle debug
local function toggleDebug()
    debugEnabled = not debugEnabled
    debugButton.Text = debugEnabled and "Debug Log: ON" or "Debug Log: OFF"

    if debugEnabled then
        createDebugGui()
        enableDebugHook()
    else
        if debugGui then
            debugGui:Destroy()
            debugGui = nil
        end
        disableDebugHook()
    end
end

-- Event tombol
flyButton.MouseButton1Click:Connect(toggleFly)
speedButton.MouseButton1Click:Connect(toggleSpeed)
debugButton.MouseButton1Click:Connect(toggleDebug)

-- Minimizing / restoring frame
minimizeButton.MouseButton1Click:Connect(function()
    frame.Visible = false
    miniFrame.Visible = true
end)

miniFrame.MouseButton1Click:Connect(function()
    frame.Visible = true
    miniFrame.Visible = false
end)

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
    if debugGui then
        debugGui:Destroy()
    end
    -- Disable hook biar gak error
    disableDebugHook()
end)

-- Set default speed
humanoid.WalkSpeed = normalSpeed
