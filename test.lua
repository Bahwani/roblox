local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local followEnabled = false
local targetName = ""
local followLoop = nil

-- === GUI ===
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FollowGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 180)
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

local teleportButton = Instance.new("TextButton", frame)
teleportButton.Size = UDim2.new(1, -10, 0, 30)
teleportButton.Position = UDim2.new(0, 5, 0, 120)
teleportButton.Text = "Teleport to Player"
teleportButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
teleportButton.TextColor3 = Color3.fromRGB(1, 1, 1)

-- === Fungsi Utama ===
local function findTargetByName(name)
	for _, p in pairs(Players:GetPlayers()) do
		if p.Name:lower() == name:lower() then
			return p
		end
	end
	return nil
end

local function teleportTo(position)
	local char = player.Character or player.CharacterAdded:Wait()
	char:MoveTo(position)
end

local function followTarget()
	if followLoop then followLoop:Disconnect() end

	followLoop = RunService.Heartbeat:Connect(function()
		if not followEnabled then
			if followLoop then
				followLoop:Disconnect()
				followLoop = nil
			end
			return
		end

		local target = findTargetByName(targetName)
		if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
			warn("❌ Target not found or invalid.")
			followEnabled = false
			followButton.Text = "Follow: OFF"
			followButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			return
		end

		local myChar = player.Character or player.CharacterAdded:Wait()
		local myHumanoid = myChar:WaitForChild("Humanoid")
		local targetPos = target.Character.HumanoidRootPart.Position

		myHumanoid:MoveTo(targetPos)
	end)
end

-- === Button Handler ===
followButton.MouseButton1Click:Connect(function()
	if not followEnabled then
		targetName = usernameBox.Text
		if targetName == "" then return end

		followEnabled = true
		followButton.Text = "Follow: ON"
		followButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
		followTarget()
	else
		followEnabled = false
		followButton.Text = "Follow: OFF"
		followButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

		local char = player.Character
		if char and char:FindFirstChild("Humanoid") then
			-- Stop movement instantly
			char.Humanoid:Move(Vector3.zero, false)
		end

		if followLoop then
			followLoop:Disconnect()
			followLoop = nil
		end
	end
end)

teleportButton.MouseButton1Click:Connect(function()
	local target = findTargetByName(usernameBox.Text)
	if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
		warn("❌ Target not found or invalid.")
		return
	end

	local targetPos = target.Character.HumanoidRootPart.Position
	teleportTo(targetPos)
end)
