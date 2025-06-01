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
frame.Draggable = true

-- Frame kecil (minimized) jadi TextButton agar bisa klik
local miniFrame = Instance.new("TextButton")
miniFrame.Size = UDim2.new(0, 50, 0, 30)
miniFrame.Position = UDim2.new(0.5, -25, 0.5, -15)
miniFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
miniFrame.BorderSizePixel = 0
miniFrame.Parent = gui
miniFrame.Visible = false
miniFrame.Active = true
miniFrame.Draggable = true
miniFrame.Text = ""  -- Supaya kosong

-- Label di miniFrame sebagai logo kecil
local miniLabel = Instance.new("TextLabel")
miniLabel.Size = UDim2.new(1, 0, 1, 0)
miniLabel.BackgroundTransparency = 1
miniLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
miniLabel.Text = "P"
miniLabel.TextScaled = true
miniLabel.Parent = miniFrame
miniLabel.Active = false  -- supaya event di miniFrame tetap bisa jalan

-- Tombol Fly Toggle (ON/OFF)
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(1, -10, 0, 30)
flyButton.Position = UDim2.new(0, 5, 0, 35)
flyButton.Text = "Fly OFF"
flyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Parent = frame

local flyEnabled = false
local jumpConnection = nil

local UserInputService = game:GetService("UserInputService")

local function onJumpRequest()
    local player = game.Players.LocalPlayer
    local character = player and player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        -- Cek kalau bukan sedang jatuh bebas
        if humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end

flyButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    if flyEnabled then
        flyButton.Text = "Fly ON"
        -- Connect jump request jika belum terhubung
        if not jumpConnection then
            jumpConnection = UserInputService.JumpRequest:Connect(onJumpRequest)
        end
    else
        flyButton.Text = "Fly OFF"
        -- Disconnect jump request
        if jumpConnection then
            jumpConnection:Disconnect()
            jumpConnection = nil
        end
    end
end)

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

-- Title Label (opsional)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 0, 30)
title.Position = UDim2.new(0, 5, 0, 0)
title.Text = "List Menu"
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
    -- Disconnect connection dulu kalau ada supaya gak nempel eventnya
    if jumpConnection then
        jumpConnection:Disconnect()
        jumpConnection = nil
    end
    gui:Destroy()
end)
