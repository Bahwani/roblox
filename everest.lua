local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 320)
frame.Position = UDim2.new(0, 20, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Parent = screenGui

local uiList = Instance.new("UIListLayout")
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 6)
uiList.Parent = frame

-- === Lokasi utama ===
local locations = {
	Camp1 = Vector3.new(-1075, 941, 1268),
	Camp2 = Vector3.new(-2121, 1781, 793),
	Camp3 = Vector3.new(-3942, 5005, 866),
	Camp4 = Vector3.new(-4630, 6616, 913),
	Summit = Vector3.new(-5181, 8429, 1055),
}

-- === Lokasi checkpoint (berurutan) ===
local checkpointPositions = {
	Vector3.new(-3804, 4977, 1172),
	Vector3.new(-3803, 4980, 611),
	Vector3.new(-3802, 4978, 610),
	Vector3.new(-3801, 4978, 612),
}

local order = {"Camp1", "Camp2", "Camp3", "Camp4", "Summit", "Checkpoint", "Stop"}

local stopRequested = false

-- === Fungsi jalan dengan Pathfinding ===
local function walkToWithPathfinding(targetPos)
	local char = player.Character or player.CharacterAdded:Wait()
	local humanoid = char:WaitForChild("Humanoid")
	local hrp = char:WaitForChild("HumanoidRootPart")

	stopRequested = false

	local path = PathfindingService:CreatePath({
		AgentRadius = 2,
		AgentHeight = 5,
		AgentCanJump = true,
		AgentJumpHeight = 15,
		AgentMaxSlope = 45,
	})

	path:ComputeAsync(hrp.Position, targetPos)

	if path.Status == Enum.PathStatus.Complete then
		for _, waypoint in ipairs(path:GetWaypoints()) do
			if stopRequested then
				humanoid:MoveTo(hrp.Position)
				break
			end

			humanoid:MoveTo(waypoint.Position)

			local reached = false
			local conn
			conn = humanoid.MoveToFinished:Connect(function(success)
				reached = true
				conn:Disconnect()
			end)

			local timer = 0
			while not reached and timer < 10 do
				if stopRequested then
					humanoid:MoveTo(hrp.Position)
					break
				end
				task.wait(0.1)
				timer += 0.1
			end
		end
	else
		warn("Gagal menghitung path ke:", targetPos)
	end
end

-- === Jalan ke semua checkpoint pakai Pathfinding ===
local function walkThroughCheckpoints()
	for _, pos in ipairs(checkpointPositions) do
		if stopRequested then break end
		walkToWithPathfinding(pos)
	end
end

-- === Buat tombol ===
local function createButton(name)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 18
	btn.Text = name == "Stop" and "🛑 Stop Jalan" or "Jalan ke " .. name
	btn.Parent = frame

	btn.MouseButton1Click:Connect(function()
		if name == "Checkpoint" then
			walkThroughCheckpoints()
		elseif name == "Stop" then
			stopRequested = true
		else
			local destination = locations[name]
			if destination then
				walkToWithPathfinding(destination)
			end
		end
	end)
end

-- === Buat semua tombol ===
for _, name in ipairs(order) do
	createButton(name)
end
