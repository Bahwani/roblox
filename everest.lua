-- Everest Smart Replay + Fly/Speed/Instant GUI Fusion
-- Versi final yang menggabungkan smart adaptive replay + fitur GUI toggle
-- Folder log: /storage/emulated/0/Delta/Workspace/LogEverest

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

local folderPath = "/storage/emulated/0/Delta/Workspace/PetssLogEverest"
local replaying, recording = false, false
local recordConnection, lastRecordedPos = nil, nil
local minDistance = 1.5
local walkStep, fallbackStep = 8, 2
local speedEnabled, flyEnabled, instantEnabled = false, false, false
local normalSpeed, fastSpeed = 16, 36
local flyBodyVelocity = nil

-- === Utility ===
local function readLog(path)
	local ok, content = pcall(readfile, path)
	if not ok then return {} end
	local positions = {}
	for line in content:gmatch("[^\r\n]+") do
		local x, y, z = line:match("Posisi: Vector3.new%((%-?[%d%.]+), (%-?[%d%.]+), (%-?[%d%.]+)%)")
		if x and y and z then
			table.insert(positions, Vector3.new(tonumber(x), tonumber(y), tonumber(z)))
		end
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

local function findClosestPoint(logs, currentPos)
	local minDist, bestLog, bestStep = math.huge, 1, 1
	for i, log in ipairs(logs) do
		for j, pos in ipairs(log) do
			local d = (pos - currentPos).Magnitude
			if d < minDist then
				minDist, bestLog, bestStep = d, i, j
			end
		end
	end
	return bestLog, bestStep
end

local function walkTo(pos)
	humanoid:MoveTo(pos)
	local done, t = false, 0
	local conn = humanoid.MoveToFinished:Connect(function(ok) done = ok end)
	while not done and t < 3 do task.wait(0.1); t += 0.1 end
	conn:Disconnect()
	return done
end

local function smartReplay()
	replaying = true
	replayButton.Text = "⏹ Stop Replay"
	replayButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)

	local logs = getAllLogs()
	if #logs == 0 then return end

	local logIndex, stepIndex = findClosestPoint(logs, hrp.Position)

	while replaying and logIndex <= #logs do
		local log = logs[logIndex]
		local i = stepIndex

		while replaying and i <= #log do
			local pos = log[i]
			local success = walkTo(pos)

			if success then
				i += walkStep
			else
				local targetStep = math.min(i + fallbackStep, #log)
				local fallbackPos = log[targetStep]
				humanoid:MoveTo(fallbackPos)
				local done, elapsed = false, 0
				local moveConn = humanoid.MoveToFinished:Connect(function(ok) done = ok end)
				while not done and elapsed < 3.0 do task.wait(0.1); elapsed += 0.1 end
				moveConn:Disconnect()
				if not done then
					hrp.CFrame = CFrame.new(fallbackPos + Vector3.new(0,3,0))
					task.wait(0.2)
				end
				i = targetStep + 1
			end
		end

		logIndex += 1
		stepIndex = 1
	end

	replayButton.Text = "▶ Start Replay"
	replayButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	replaying = false
end

local function getUniqueFilename()
	local i = 1
	while isfile(folderPath.."/Log_"..i..".txt") do i += 1 end
	return folderPath.."/Log_"..i..".txt"
end

local function writePos(path, pos)
	appendfile(path, "Posisi: Vector3.new("..pos.X..", "..pos.Y..", "..pos.Z..")\n")
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
	recordConnection = RunService.Heartbeat:Connect(function()
		local pos = hrp.Position
		if not lastRecordedPos or (pos - lastRecordedPos).Magnitude >= minDistance then
			writePos(logPath, pos)
			lastRecordedPos = pos
		end
	end)
end

local function stopRecording()
	recording = false
	if recordConnection then recordConnection:Disconnect() end
	recordButton.Text = "⏺ Start Record"
	recordButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end

-- === GUI ===
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 270)
frame.Position = UDim2.new(0.5, -100, 0.5, -135)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local function createButton(name, y, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.Position = UDim2.new(0, 5, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 18
	btn.Text = name
	btn.MouseButton1Click:Connect(callback)
	return btn
end

replayButton = createButton("▶ Start Replay", 35, function()
	if not replaying then task.spawn(smartReplay) else replaying = false end
end)

recordButton = createButton("⏺ Start Record", 75, function()
	if not recording then startRecording() else stopRecording() end
end)

createButton("Fly: OFF", 115, function(btn)
	flyEnabled = not flyEnabled
	btn.Text = flyEnabled and "Fly: ON" or "Fly: OFF"
	if flyEnabled then
		flyBodyVelocity = Instance.new("BodyVelocity")
		flyBodyVelocity.Velocity = Vector3.new(0, 50, 0)
		flyBodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
		flyBodyVelocity.P = 1250
		flyBodyVelocity.Parent = hrp
	else
		if flyBodyVelocity then flyBodyVelocity:Destroy() end
	end
end)

createButton("Speed: OFF", 155, function(btn)
	speedEnabled = not speedEnabled
	btn.Text = speedEnabled and "Speed: ON" or "Speed: OFF"
	humanoid.WalkSpeed = speedEnabled and fastSpeed or normalSpeed
end)

createButton("Instant: OFF", 195, function(btn)
	instantEnabled = not instantEnabled
	btn.Text = instantEnabled and "Instant: ON" or "Instant: OFF"
end)

-- Instant Interaction hook
ProximityPromptService.PromptShown:Connect(function(prompt)
	if instantEnabled then prompt.HoldDuration = 0 end
end)

-- Tutup
createButton("Tutup", 235, function()
	if flyBodyVelocity then flyBodyVelocity:Destroy() end
	gui:Destroy()
end)
