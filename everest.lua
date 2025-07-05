local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- === Variabel ===
local folderPath = "/storage/emulated/0/Delta/Workspace/PetssLogEverest"
local flyEnabled, speedEnabled, instantEnabled = false, false, false
local flyBodyVelocity = nil
local normalSpeed, fastSpeed = 16, 36
local replaying, recording = false, false
local recordConnection, lastRecordedPos = nil, nil
local minDistance, walkStep, fallbackStep = 1.5, 8, 2

-- === GUI Utama ===
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "PetoGacorrawr"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 270)
frame.Position = UDim2.new(0.5, -100, 0.5, -135)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active, frame.Draggable = true, true

local miniFrame = Instance.new("ImageButton", gui)
miniFrame.Size = UDim2.new(0, 50, 0, 50)
miniFrame.Position = UDim2.new(0.5, -25, 0.5, -25)
miniFrame.BackgroundTransparency = 1
miniFrame.Image = "rbxassetid://116056354483334"
miniFrame.Visible, miniFrame.Active, miniFrame.Draggable, miniFrame.ZIndex = false, true, true, 6
Instance.new("UICorner", miniFrame).CornerRadius = UDim.new(1, 0)

local borderFrame = Instance.new("Frame", miniFrame)
borderFrame.Size = UDim2.new(1, 6, 1, 6)
borderFrame.Position = UDim2.new(0, -3, 0, -3)
borderFrame.BackgroundColor3 = Color3.new(1, 0, 0)
borderFrame.BorderSizePixel = 0
borderFrame.ZIndex = 5
borderFrame.Visible = false
Instance.new("UICorner", borderFrame).CornerRadius = UDim.new(1, 0)

local function createButton(text, y, parent)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.Position = UDim2.new(0, 5, 0, y)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	return btn
end

local flyButton = createButton("Fly: OFF", 35, frame)
local speedButton = createButton("Speed: OFF", 75, frame)
local instantInteractButton = createButton("Instant: OFF", 115, frame)
local replayButton = createButton("▶ Start Replay", 155, frame)
local recordButton = createButton("⏺ Start Record", 195, frame)

local minimizeButton = Instance.new("TextButton", frame)
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -65, 0, 0)
minimizeButton.Text = "-"

local closeButton = Instance.new("TextButton", frame)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 0)
closeButton.Text = "X"

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -70, 0, 30)
title.Position = UDim2.new(0, 5, 0, 0)
title.Text = "PetoGacorrawr"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left

-- === Fungsi Fitur ===
flyButton.MouseButton1Click:Connect(function()
	flyEnabled = not flyEnabled
	flyButton.Text = flyEnabled and "Fly: ON" or "Fly: OFF"
	if flyEnabled then
		flyBodyVelocity = Instance.new("BodyVelocity", humanoidRootPart)
		flyBodyVelocity.Name = "FlyVelocity"
		flyBodyVelocity.Velocity = Vector3.new(0, 50, 0)
		flyBodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
		flyBodyVelocity.P = 1250
	elseif flyBodyVelocity then
		flyBodyVelocity:Destroy()
	end
end)

speedButton.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	speedButton.Text = speedEnabled and "Speed: ON" or "Speed: OFF"
	humanoid.WalkSpeed = speedEnabled and fastSpeed or normalSpeed
end)

instantInteractButton.MouseButton1Click:Connect(function()
	instantEnabled = not instantEnabled
	instantInteractButton.Text = instantEnabled and "Instant: ON" or "Instant: OFF"
end)

ProximityPromptService.PromptShown:Connect(function(prompt)
	if instantEnabled then
		prompt.HoldDuration = 0
	end
end)

minimizeButton.MouseButton1Click:Connect(function()
	frame.Visible = false
	borderFrame.Visible = true
	miniFrame.Visible = true
end)

miniFrame.MouseButton1Click:Connect(function()
	frame.Visible = true
	borderFrame.Visible = false
	miniFrame.Visible = false
end)

closeButton.MouseButton1Click:Connect(function()
	if flyBodyVelocity then flyBodyVelocity:Destroy() end
	humanoid.WalkSpeed = normalSpeed
	gui:Destroy()
end)

-- === Fitur Record dan Replay ===
local function writePos(path, pos)
	appendfile(path, "Posisi: Vector3.new("..pos.X..","..pos.Y..","..pos.Z..")\n")
end

local function getUniqueFilename()
	local i = 1
	while isfile(folderPath.."/Log_"..i..".txt") do i += 1 end
	return folderPath.."/Log_"..i..".txt"
end

local function ensureFolderExists(path)
	if not isfolder(path) then makefolder(path) end
end

local function startRecording()
	ensureFolderExists(folderPath)
	local logPath = getUniqueFilename()
	writefile(logPath, "")
	lastRecordedPos = nil
	recording = true
	recordButton.Text = "⏹ Stop Record"
	recordButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
	recordConnection = game:GetService("RunService").Heartbeat:Connect(function()
		local pos = humanoidRootPart.Position
		if not lastRecordedPos or (pos - lastRecordedPos).Magnitude >= minDistance then
			writePos(logPath, pos)
			lastRecordedPos = pos
		end
	end)
end

local function stopRecording()
	if recordConnection then recordConnection:Disconnect() end
	recording = false
	recordButton.Text = "⏺ Start Record"
	recordButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end

recordButton.MouseButton1Click:Connect(function()
	if not recording then startRecording() else stopRecording() end
end)

local function readLog(path)
	local ok, content = pcall(readfile, path)
	if not ok then return {} end
	local positions = {}
	for line in content:gmatch("[^\r\n]+") do
		local x, y, z = line:match("Vector3.new%((%-?[%d%.]+),(%-?[%d%.]+),(%-?[%d%.]+)%)")
		if x then table.insert(positions, Vector3.new(tonumber(x), tonumber(y), tonumber(z))) end
	end
	return positions
end

local function getAllLogs()
	local logs, ok = {}, pcall(listfiles, folderPath)
	if not ok then return {} end
	for _, f in ipairs(listfiles(folderPath)) do
		if f:match("%.txt$") then
			local log = readLog(f)
			if #log > 0 then table.insert(logs, log) end
		end
	end
	return logs
end

local function walkTo(pos)
	local done, t = false, 0
	humanoid:MoveTo(pos)
	local conn = humanoid.MoveToFinished:Connect(function(ok) done = ok end)
	while not done and t < 3 do task.wait(0.1); t += 0.1 end
	conn:Disconnect()
	return done
end

local function findClosest(logs, pos)
	local minDist, bestLog, bestStep = math.huge, 1, 1
	for i, log in ipairs(logs) do
		for j, p in ipairs(log) do
			local d = (p - pos).Magnitude
			if d < minDist then minDist, bestLog, bestStep = d, i, j end
		end
	end
	return bestLog, bestStep
end

replayButton.MouseButton1Click:Connect(function()
	if replaying then
		replaying = false
		replayButton.Text = "▶ Start Replay"
		replayButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		return
	end

	replaying = true
	replayButton.Text = "⏹ Stop Replay"
	replayButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)

	local logs = getAllLogs()
	if #logs == 0 then return end

	local logIndex, stepIndex = findClosest(logs, humanoidRootPart.Position)

	while replaying and logIndex <= #logs do
		local log = logs[logIndex]
		local i = stepIndex
		while replaying and i <= #log do
			if not walkTo(log[i]) then
				local nextStep = math.min(i + fallbackStep, #log)
				local fallback = log[nextStep]
				humanoidRootPart.CFrame = CFrame.new(fallback + Vector3.new(0, 3, 0))
				task.wait(0.2)
				i = nextStep + 1
			else
				i += walkStep
			end
		end
		logIndex += 1
		stepIndex = 1
	end

	replayButton.Text = "▶ Start Replay"
	replayButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	replaying = false
end)

-- Animasi RGB Border
spawn(function()
	local hue = 0
	while true do
		hue = (hue + 1) % 360
		borderFrame.BackgroundColor3 = Color3.fromHSV(hue / 360, 1, 1)
		wait(0.03)
	end
end)
