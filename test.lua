local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local following = false
local targetName = ""

-- === GUI ===
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "FollowGUI"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 250, 0, 140)
frame.Position = UDim2.new(0, 50, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Follow Player"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

local usernameBox = Instance.new("TextBox", frame)
usernameBox.PlaceholderText = "Username to follow"
usernameBox.Size = UDim2.new(1, -20, 0, 30)
usernameBox.Position = UDim2.new(0, 10, 0, 40)
usernameBox.Text = ""
usernameBox.Font = Enum.Font.SourceSans
usernameBox.TextSize = 16
usernameBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
usernameBox.TextColor3 = Color3.new(1, 1, 1)

local followButton = Instance.new("TextButton", frame)
followButton.Text = "Follow: OFF"
followButton.Size = UDim2.new(1, -20, 0, 30)
followButton.Position = UDim2.new(0, 10, 0, 80)
followButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
followButton.TextColor3 = Color3.new(1, 1, 1)
followButton.Font = Enum.Font.SourceSansBold
followButton.TextSize = 18

-- === Follow Logic ===
followButton.MouseButton1Click:Connect(function()
	following = not following
	targetName = usernameBox.Text
	followButton.Text = following and "Follow: ON" or "Follow: OFF"
	followButton.BackgroundColor3 = following and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
end)

task.spawn(function()
	while true do
		if following and targetName ~= "" then
			local target = Players:FindFirstChild(targetName)
			local char = localPlayer.Character
			local myHRP = char and char:FindFirstChild("HumanoidRootPart")

			if target and target.Character and myHRP then
				local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
				if targetHRP then
					local dist = (myHRP.Position - targetHRP.Position).Magnitude
					if dist > 10 then
						local hum = char:FindFirstChildOfClass("Humanoid")
						if hum then
							hum:MoveTo(targetHRP.Position)
						end
					end
				end
			end
		end
		task.wait(0.3)
	end
end)
