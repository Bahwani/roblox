-- Layanan Roblox
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Variabel Fly
local flyEnabled = false
local flyBodyVelocity = nil

-- Buat GUI utama
local gui = Instance.new("ScreenGui")
gui.Name = "PetoGacorrawr"
gui.Parent = game.CoreGui

-- Frame utama
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0.5, -100, 0.5, -60)
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

-- Klik tombol Fly
flyButton.MouseButton1Click:Connect(toggleFly)

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

-- Tutup GUI
closeButton.MouseButton1Click:Connect(function()
    -- Jika fly masih aktif, matikan
    if flyEnabled then
        flyEnabled = false
        flyButton.Text = "Fly: OFF"
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
    end

    -- Hancurkan GUI
    gui:Destroy()
end)
