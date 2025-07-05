-- Everest Smart Adaptive Replay Script v3 + GUI Fly/Speed/Instant
-- Digabung utuh tanpa menghilangkan fitur apa pun

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local folderPath = "/storage/emulated/0/Delta/Workspace/LogEverest"
local replaying, recording = false, false
local recordConnection, lastRecordedPos = nil, nil
local minDistance, walkStep, fallbackStep = 1.5, 8, 2

local flyEnabled, flyBodyVelocity = false, nil
local speedEnabled, normalSpeed, fastSpeed = false, 16, 36
local instantEnabled = false

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 270)
frame.Position = UDim2.new(0.5, -100, 0.5, -135)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active, frame.Draggable = true, true

local function createButton(text, y)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.Position = UDim2.new(0, 5, 0, y)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 16
	return btn
end

local flyButton = createButton("Fly: OFF", 35)
local speedButton = createButton("Speed: OFF", 75)
local instantButton = createButton("Instant: OFF", 115)
local replayButton = createButton("\226\151\128 Start Replay", 155)
local recordButton = createButton("\226\141\276 Start Record", 195)

-- Fly toggle
flyButton.MouseButton1Click:Connect(function()
	flyEnabled = not flyEnabled
	flyButton.Text = flyEnabled and "Fly: ON" or "Fly: OFF"
	if flyEnabled then
		flyBodyVelocity = Instance.new("BodyVelocity", humanoidRootPart)
		flyBodyVelocity.Velocity = Vector3.new(0, 50, 0)
		flyBodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
		flyBodyVelocity.P = 1250
	else
		if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
	end
end)

-- Speed toggle
speedButton.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	speedButton.Text = speedEnabled and "Speed: ON" or "Speed: OFF"
	humanoid.WalkSpeed = speedEnabled and fastSpeed or normalSpeed
end)

-- Instant interaction toggle
instantButton.MouseButton1Click:Connect(function()
	instantEnabled = not instantEnabled
	instantButton.Text = instantEnabled and "Instant: ON" or "Instant: OFF"
end)

ProximityPromptService.PromptShown:Connect(function(prompt)
	if instantEnabled then prompt.HoldDuration = 0 end
end)

-- Write to file
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
	recordButton.Text = "\226\141\276 Stop Record"
	recordButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
	recordConnection = RunService.Heartbeat:Connect(function()
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
	recordButton.Text = "\226\141\276 Start Record"
	recordButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end

recordButton.MouseButton1Click:Connect(function()
	if recording then stopRecording() else startRecording() end
end)

-- Replay logic
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
	local logs = {}
	local ok, files = pcall(listfiles, folderPath)
	if not ok then return {} end
	for _, f in ipairs(files) do
		if f:match("%.txt$") then
			local log = readLog(f)
			if #log > 0 then table.insert(logs, log) end
		end
	end
	return logs
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

local function walkTo(pos)
	humanoid:MoveTo(pos)
	local done = false
	local conn = humanoid.MoveToFinished:Connect(function(ok) done = ok end)
	local t = 0
	while not done and t < 3 do task.wait(0.1); t += 0.1 end
	conn:Disconnect()
	return done
end

local function smartReplay()
	replaying = true
	replayButton.Text = "\226\128\185 Stop Replay"
	replayButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)

	local logs = getAllLogs()
	if #logs == 0 then return end

	local currentLogIndex, currentStepIndex = findClosest(logs, humanoidRootPart.Position)
	while replaying and currentLogIndex <= #logs do
		local log = logs[currentLogIndex]
		local i = currentStepIndex
		while replaying and i <= #log do
			if not walkTo(log[i]) then
				local nextStep = math.min(i + fallbackStep, #log)
				humanoidRootPart.CFrame = CFrame.new(log[nextStep] + Vector3.new(0, 3, 0))
				task.wait(0.2)
				i = nextStep + 1
			else
				i += walkStep
			end
		end
		currentLogIndex += 1
		currentStepIndex = 1
	end

	replayButton.Text = "\226\151\128 Start Replay"
	replayButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	replaying = false
end

replayButton.MouseButton1Click:Connect(function()
	if replaying then
		replaying = false
		replayButton.Text = "\226\151\128 Start Replay"
		replayButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	else
		task.spawn(smartReplay)
	end
end)

-- RGB border animation (optional)
local border = Instance.new("Frame", frame)
border.Size = frame.Size + UDim2.new(0, 6, 0, 6)
border.Position = frame.Position - UDim2.new(0, 3, 0, 3)
border.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
border.BorderSizePixel = 0
border.ZIndex = -1

spawn(function()
	local hue = 0
	while true do
		hue = (hue + 1) % 360
		border.BackgroundColor3 = Color3.fromHSV(hue / 360, 1, 1)
		wait(0.03)
	end
end)
