-- Buat GUI utama
local gui = Instance.new("ScreenGui")
gui.Name = "PetoGacorrawr"
gui.Parent = game.CoreGui

-- Frame utama
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 160) -- tambah tinggi biar muat tombol tambahan
frame.Position = UDim2.new(0.5, -100, 0.5, -80)
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

-- Tombol Speed Boost Toggle
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(1, -10, 0, 30)
speedButton.Position = UDim2.new(0, 5, 0, 75)
speedButton.Text = "Speed: OFF"
speedButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.Parent = frame

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
title.Text = "List Menu"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- Minimalkan GUI
minimizeButton.MouseButton1Click:Connect(function()
    frame.Visible = false
    miniFrame.Visible = true
end)

-- Maksimalkan GUI
miniFrame.MouseButton1Click:Connect(function()
    miniFrame.Visible = false
    frame.Visible = true
end)

-- Fly dan Speed Logic
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local flyEnabled = false
local speedEnabled = false
local flyBodyVelocity = nil

local normalWalkSpeed = humanoid.WalkSpeed
local boostedWalkSpeed = normalWalkSpeed * 2.5 -- kecepatan jalan saat speed boost

local function toggleFly()
    flyEnabled = not flyEnabled
    flyButton.Text = flyEnabled and "Fly: ON" or "Fly: OFF"

    if flyEnabled then
        -- Buat BodyVelocity untuk terbang
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        flyBodyVelocity.P = 1250
        flyBodyVelocity.Parent = humanoidRootPart
    else
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
        -- Reset kecepatan berjalan ke normal jika speed tidak aktif
        if not speedEnabled then
            humanoid.WalkSpeed = normalWalkSpeed
        end
    end
end

local function toggleSpeed()
    speedEnabled = not speedEnabled
    speedButton.Text = speedEnabled and "Speed: ON" or "Speed: OFF"

    if speedEnabled then
        humanoid.WalkSpeed = boostedWalkSpeed
    else
        if not flyEnabled then
            humanoid.WalkSpeed = normalWalkSpeed
        end
    end
end

-- Update gerakan saat fly aktif
game:GetService("RunService").RenderStepped:Connect(function()
    if flyEnabled and flyBodyVelocity then
        local moveDirection = humanoid.MoveDirection
        local speed = 50
        -- Tambah gerakan vertikal dengan tombol space
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        -- Tambah gerakan turun dengan tombol left shift
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection + Vector3.new(0, -1, 0)
        end
        flyBodyVelocity.Velocity = moveDirection.Unit * speed
    end
end)

-- Tombol toggle
flyButton.MouseButton1Click:Connect(toggleFly)
speedButton.MouseButton1Click:Connect(toggleSpeed)

-- Close GUI dan reset state
closeButton.MouseButton1Click:Connect(function()
    -- Matikan fly jika aktif
    if flyEnabled then
        flyEnabled = false
        flyButton.Text = "Fly: OFF"
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
    end

    -- Reset kecepatan jalan jika speed aktif
    if speedEnabled then
        speedEnabled = false
        speedButton.Text = "Speed: OFF"
        humanoid.WalkSpeed = normalWalkSpeed
    end

    gui:Destroy()
end)
