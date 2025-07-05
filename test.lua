local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- GUI Setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "FlyToSummitGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 100)
frame.Position = UDim2.new(0.5, -110, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local startButton = Instance.new("TextButton", frame)
startButton.Size = UDim2.new(1, -10, 0.5, -5)
startButton.Position = UDim2.new(0, 5, 0, 5)
startButton.Text = "Start Fly"
startButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
startButton.TextScaled = true

local closeButton = Instance.new("TextButton", frame)
closeButton.Size = UDim2.new(1, -10, 0.5, -5)
closeButton.Position = UDim2.new(0, 5, 0.5, 5)
closeButton.Text = "Close"
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.TextScaled = true

-- Fungsi interpolasi posisi
local function interpolateVector3(startPos, endPos, t)
	return startPos + (endPos - startPos) * t
end

-- Konfigurasi
local totalTime = 720 -- 12 menit
local steps = 720
local delayPerStep = totalTime / steps

local startPos = Vector3.new(-3942, 5005, 866)
local endPos = Vector3.new(-5181, 8429, 1055)

-- Fungsi fly ke summit
local function startFly()
	frame.Visible = false
	hrp.Anchored = true
	print("Mulai fly ke summit...")

	for step = 1, steps do
		local t = step / steps
		local targetPos = interpolateVector3(startPos, endPos, t)
		hrp.CFrame = CFrame.new(targetPos)
		task.wait(delayPerStep)
	end

	hrp.Anchored = false
	print("Selesai fly. Sampai Summit.")
end

-- Tombol start
startButton.MouseButton1Click:Connect(function()
	startFly()
end)

-- Tombol close
closeButton.MouseButton1Click:Connect(function()
	gui:Destroy()
end)
