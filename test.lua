local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local followEnabled = false
local targetName = ""

-- === GUI ===
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FollowGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 140)
frame.Position = UDim2.new(0, 50, 0, 200)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Follow Player"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local usernameBox = Instance.new("TextBox", frame)
usernameBox.Size = UDim2.new(1, -10, 0, 30)
usernameBox.Position = UDim2.new(0, 5, 0, 40)
usernameBox.PlaceholderText = "Enter Player Username"
usernameBox.Text = ""
usernameBox.ClearTextOnFocus = false
usernameBox.TextColor3 = Color3.new(1, 1, 1)
usernameBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local followButton = Instance.new("TextButton", frame)
followButton.Size = UDim2.new(1, -10, 0, 30)
followButton.Position = UDim2.new(0, 5, 0, 80)
followButton.Text = "Follow: OFF"
followButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
followButton.TextColor3 = Color3.fromRGB(1, 1, 1)

-- === Fungsi Utama ===
local function findTargetByName(name)
	for _, p in pairs(Players:GetPlayers()) do
		if p.Name:lower() == name:lower() then
			return p
		end
	end
	return nil
end

local function followTarget()
	while followEnabled do
		local target = findTargetByName(targetName)
		if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
			print("❌ Target not found or invalid.")
			followEnabled = false
			followButton.Text = "Follow: OFF"
			followButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			break
		end

		local myChar = player.Character or player.CharacterAdded:Wait()
		local myHumanoid = myChar:WaitForChild("Humanoid")
		local targetPos = target.Character.HumanoidRootPart.Position

		myHumanoid:MoveTo(targetPos)
		wait(0.2)
	end
end

-- === Button Handler ===
followButton.MouseButton1Click:Connect(function()
	if not followEnabled then
		targetName = usernameBox.Text
		if targetName == "" then return end

		followEnabled = true
		followButton.Text = "Follow: ON"
		followButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)

		task.spawn(followTarget)
	else
		followEnabled = false
		followButton.Text = "Follow: OFF"
		followButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	end
end)
