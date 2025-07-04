-- === Everest Smart Adaptive Replay Script ===
-- Fitur: Replay mulus (5 stud), fallback 1 stud, mulai dari posisi terdekat, tombol record + replay

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local folderPath = "/storage/emulated/0/Delta/Workspace/LogEverest"

local replaying, paused, recording = false, false, false
local recordConnection, lastRecordedPos = nil, nil
local minDistance = 1.5
local replayButton, recordButton

-- === Utility Functions ===
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
				minDist = d
				bestLog, bestStep = i, j
			end
		end
	end
	return bestLog, bestStep
end

local function walkTo(pos)
	local char = player.Character or player.CharacterAdded:Wait()
	local human = char:WaitForChild("Humanoid")
	local done, timeout = false, 3

	human:MoveTo(pos)
	local conn = human.MoveToFinished:Connect(function(ok) done = ok end)
	local t = 0
	while not done and t < timeout do
		if paused then break end
		task.wait(0.1)
		t += 0.1
	end
	conn:Disconnect()
	return done
end

local function walkPath(log, start, step, fallbackLogs)
	local i = start
	while i <= #log do
		if not replaying then break end
		while paused do task.wait(0.2) end

		local success = walkTo(log[i])
		if not success then
			-- Try fallback logs with step 1
			local recovered = false
			for _, fallbackLog in ipairs(fallbackLogs) do
				if fallbackLog[i] and walkTo(fallbackLog[i]) then
					recovered = true
					break
				end
			end
			if not recovered then
				warn("Gagal mencapai langkah " .. i)
				return false
			end
			-- Setelah berhasil, lanjut dengan step normal lagi
		end
		i += step
	end
	return true
end

local function smartReplay()
	replaying = true
	paused = false
	replayButton.Text = "⏸ Pause Replay"
	replayButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)

	local logs = getAllLogs()
	if #logs == 0 then return end

	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local bestLogIndex, stepIndex = findClosestPoint(logs, hrp.Position)
	local mainLog = logs[bestLogIndex]

	walkPath(mainLog, stepIndex, 5, logs)

	replayButton.Text = "▶ Start Replay"
	replayButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	replaying = false
end

-- === RECORD ===
local function getUniqueFilename()
	local i = 1
	while isfile(folderPath.."/Log_"..i..".txt") do i += 1 end
	return folderPath.."/Log_"..i..".txt"
end

local function writePos(path, pos)
	appendfile(path, "Posisi: Vector3.new(" .. pos.X .. ", " .. pos.Y .. ", " .. pos.Z .. ")\n")
end

local function startRecording()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local logPath = getUniqueFilename()
	writefile(logPath, "")
	lastRecordedPos = nil

	recording = true
	recordButton.Text = "⏹ Stop Record"
	recordButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)

	recordConnection = RunService.Heartbeat:Connect(function()
		if not hrp or not recording then return end
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
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EverestGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 120)
frame.Position = UDim2.new(0, 20, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Parent = screenGui

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = frame

replayButton = Instance.new("TextButton")
replayButton.Size = UDim2.new(1, -10, 0, 40)
replayButton.Position = UDim2.new(0, 5, 0, 10)
replayButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
replayButton.TextColor3 = Color3.fromRGB(255, 255, 255)
replayButton.Font = Enum.Font.SourceSansBold
replayButton.TextSize = 18
replayButton.Text = "▶ Start Replay"
replayButton.Parent = frame

recordButton = Instance.new("TextButton")
recordButton.Size = UDim2.new(1, -10, 0, 40)
recordButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
recordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
recordButton.Font = Enum.Font.SourceSansBold
recordButton.TextSize = 18
recordButton.Text = "⏺ Start Record"
recordButton.Parent = frame

replayButton.MouseButton1Click:Connect(function()
	if not replaying then
		task.spawn(smartReplay)
	else
		paused = not paused
		replayButton.Text = paused and "▶ Resume Replay" or "⏸ Pause Replay"
		replayButton.BackgroundColor3 = paused and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(0, 170, 0)
	end
end)

recordButton.MouseButton1Click:Connect(function()
	if not recording then
		startRecording()
	else
		stopRecording()
	end
end)
