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

local instantEnabled = false

-- Buat GUI utama
local gui = Instance.new("ScreenGui")
gui.Name = "PetoGacorrawr"
gui.Parent = game.CoreGui

-- Frame utama
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 160) -- ditambah tinggi untuk tombol speed
frame.Position = UDim2.new(0.5, -100, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Active = true
frame.Draggable = true

-- Buat miniFrame dulu
local miniFrame = Instance.new("ImageButton")
miniFrame.Size = UDim2.new(0, 50, 0, 50)
miniFrame.Position = UDim2.new(0.5, -25, 0.5, -25)
miniFrame.BackgroundTransparency = 1
miniFrame.Image = "rbxassetid://116056354483334" -- ganti sesuai gambar kamu
miniFrame.Parent = gui
miniFrame.Visible = false
miniFrame.Active = true
miniFrame.Draggable = true
miniFrame.ZIndex = 6

local corner = Instance.new("UICorner", miniFrame)
corner.CornerRadius = UDim.new(1, 0)

-- Baru buat borderFrame dan masukkan ke dalam miniFrame
local borderFrame = Instance.new("Frame")
borderFrame.Size = UDim2.new(1, 6, 1, 6)
borderFrame.Position = UDim2.new(0, -3, 0, -3)
borderFrame.BackgroundColor3 = Color3.new(1, 0, 0)
borderFrame.BorderSizePixel = 0
borderFrame.ZIndex = 5
borderFrame.Visible = false
borderFrame.Parent = miniFrame

local borderCorner = Instance.new("UICorner")
borderCorner.CornerRadius = UDim.new(1, 0)
borderCorner.Parent = borderFrame

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

local ProximityPromptService = game:GetService("ProximityPromptService")

ProximityPromptService.PromptShown:Connect(function(prompt)
	if instantEnabled then
		task.spawn(function()
			wait(0.1)
			if prompt and prompt:IsDescendantOf(workspace) and prompt.Enabled then
				prompt.HoldDuration = 0
				prompt.ClickablePrompt = true
			end
		end)
	end
end)


-- Tombol toggle Instant Interaction
local instantInteractButton = Instance.new("TextButton")
instantInteractButton.Size = UDim2.new(1, -10, 0, 30)
instantInteractButton.Position = UDim2.new(0, 5, 0, 115)
instantInteractButton.Text = "Instant: OFF"
instantInteractButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
instantInteractButton.TextColor3 = Color3.fromRGB(255, 255, 255)
instantInteractButton.Parent = frame

-- Event klik tombol untuk toggle ON/OFF
instantInteractButton.MouseButton1Click:Connect(function()
    instantEnabled = not instantEnabled
    instantInteractButton.Text = instantEnabled and "Instant: ON" or "Instant: OFF"
end)

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

-- Event klik tombol
flyButton.MouseButton1Click:Connect(toggleFly)
speedButton.MouseButton1Click:Connect(toggleSpeed)

-- Minimalkan GUI
minimizeButton.MouseButton1Click:Connect(function()
    frame.Visible = false
    borderFrame.Visible = true
    miniFrame.Visible = true
end)

-- Maksimalkan GUI
miniFrame.MouseButton1Click:Connect(function()
    miniFrame.Visible = false
    borderFrame.Visible = false
    frame.Visible = true
end)

-- Tutup GUI
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

    -- Reset kecepatan ke normal jika speed aktif
    if speedEnabled then
        speedEnabled = false
        speedButton.Text = "Speed: OFF"
        humanoid.WalkSpeed = normalSpeed
    end

    -- Matikan Instant Interaction
    if instantEnabled then
        instantEnabled = false
        instantInteractButton.Text = "Instant: OFF"
    end	

    -- Hancurkan GUI
    gui:Destroy()
end)

-- Animasi RGB untuk border frame
spawn(function()
    local hue = 0
    while true do
        hue = (hue + 1) % 360
        local color = Color3.fromHSV(hue / 360, 1, 1)
        borderFrame.BackgroundColor3 = color
        wait(0.03)
    end
end)
