local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local StartButton = Instance.new("TextButton", ScreenGui)
StartButton.Size = UDim2.new(0, 200, 0, 50)
StartButton.Position = UDim2.new(0.5, -100, 0.5, -25)
StartButton.Text = "Start"
StartButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
StartButton.TextScaled = true

-- Fungsi teleport
local function teleportTo(position)
	local char = player.Character or player.CharacterAdded:Wait()
	char:MoveTo(position)
end

-- Fungsi interpolasi
local function interpolate(startVec, endVec, t)
	return startVec + (endVec - startVec) * t
end

-- Titik utama
local points = {
	Vector3.new(-1075, 941, 1268),
	Vector3.new(-2121, 1781, 793),
	Vector3.new(-3942, 5005, 866),
	Vector3.new(-4630, 6616, 913),
	Vector3.new(-5181, 8429, 1055)
}

-- Bagi 720 titik di antara 4 lintasan
local totalSteps = 720
local stepsPerSegment = totalSteps / (#points - 1) -- 720 / 4 = 180

-- Ketika tombol diklik
StartButton.MouseButton1Click:Connect(function()
	StartButton.Visible = false

	for i = 1, #points - 1 do
		local startPos = points[i]
		local endPos = points[i + 1]

		for step = 1, stepsPerSegment do
			local t = step / stepsPerSegment
			local interpolatedPos = interpolate(startPos, endPos, t)
			teleportTo(interpolatedPos)
			task.wait(1) -- 1 detik per teleport
		end
	end

	print("Teleportasi selesai.")
end)
