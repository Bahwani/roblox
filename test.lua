-- Buat GUI utama
local gui = Instance.new("ScreenGui")
gui.Name = "PetoGacorrawr"
gui.Parent = game.CoreGui

-- Frame utama (maximized)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0.5, -100, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Active = true
frame.Draggable = true  -- Biar bisa drag

-- Frame kecil (minimized)
local miniFrame = Instance.new("Frame")
miniFrame.Size = UDim2.new(0, 50, 0, 30)
miniFrame.Position = UDim2.new(0.5, -25, 0.5, -15)
miniFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
miniFrame.BorderSizePixel = 0
miniFrame.Parent = gui
miniFrame.Visible = false
miniFrame.Active = true
miniFrame.Draggable = true  -- Bisa drag juga

-- Label di miniFrame sebagai logo kecil
local miniLabel = Instance.new("TextLabel")
miniLabel.Size = UDim2.new(1, 0, 1, 0)
miniLabel.BackgroundTransparency = 1
miniLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
miniLabel.Text = "P"
miniLabel.TextScaled = true
miniLabel.Parent = miniFrame

-- Tombol Fly
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(1, -10, 0, 30)
flyButton.Position = UDim2.new(0, 5, 0, 35)
flyButton.Text = "Terbang"
flyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Parent = frame

flyButton.MouseButton1Click:Connect(function()
    print("Fly activated!")
    -- Tambahkan script fly di sini
end)

-- Tombol Minimize
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -65, 0, 0)
minimizeButton.Text = "-"
minimizeButton.Parent = frame

-- Tombol Close
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 0)
closeButton.Text = "X"
closeButton.Parent = frame

-- Title Label (opsional)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 0, 30)
title.Position = UDim2.new(0, 5, 0, 0)
title.Text = "My Cheat Menu"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- Logic minimize / maximize
minimizeButton.MouseButton1Click:Connect(function()
    frame.Visible = false
    miniFrame.Visible = true
end)

miniFrame.MouseButton1Click:Connect(function()
    miniFrame.Visible = false
    frame.Visible = true
end)

-- Close logic
closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
