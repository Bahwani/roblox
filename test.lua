-- Buat GUI utama
local gui = Instance.new("ScreenGui")
gui.Name = "MyCheatGui"
gui.Parent = game.CoreGui

-- Frame utama
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0.5, -100, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = gui

-- Tombol Fly
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(1, -10, 0, 30)
flyButton.Position = UDim2.new(0, 5, 0, 35)
flyButton.Text = "Fly"
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

-- Minimize logic
local isMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    flyButton.Visible = not isMinimized
end)

-- Close logic
closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
