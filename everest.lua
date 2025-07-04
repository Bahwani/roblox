-- === Everest Smart Adaptive Replay Script v2 ===
-- Fitur: Adaptive fallback berdasarkan posisi dunia
-- Replay halus, otomatis lanjut log utama setelah fallback
-- Record dan Replay GUI dengan status dinamis

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local folderPath = "/storage/emulated/0/Delta/Workspace/LogEverest"

local replaying, recording = false, false
local recordConnection, lastRecordedPos = nil, nil
local minDistance = 1.5
local replayButton, recordButton

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
		task.wait(0.1)
		t += 0.1
	end
	conn:Disconnect()
	return done
end

local function adaptiveFallback(targetPos, fallbackLogs)
	for _, log in ipairs(fallbackLogs) do
		local closestIdx, minDist = nil, math.huge
		for i, pos in ipairs(log) do
			local d = (targetPos - pos).Magnitude
			if d < minDist then
				minDist = d
				closestIdx = i
			end
		end
		if closestIdx and minDist < 10 then
			if walkTo(log[closestIdx]) then
				return true, log, closestIdx + 1
			end
		end
	end
	return false
end

local function smartReplay()
	replaying = true
	replayBtn.Text = "🟥 Stop Replay"
	replayBtn.BackgroundColor3 = Color3.fromRGB(30, 60, 30)

	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")

	local mainLog, mainIdx = getClosestStep(hrp.Position)
	if not mainLog then
		replaying = false
		replayBtn.Text = "▶️ Start Replay"
		replayBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		return
	end

	while replaying do
		local goal = mainLog[mainIdx]
		if not goal then break end
		if (goal - hrp.Position).Magnitude < 2 then
			mainIdx += 1
			continue
		end

		local success = walkTo(goal)
		if success then
			mainIdx += 1
		else
			-- fallback: coba terus log lain hingga berhasil
			local reached = false
			for _, altLog in ipairs(logs) do
				for _, alt in ipairs(altLog) do
					if (alt - goal).Magnitude < 5 then
						if walkTo(alt) then
							mainLog, mainIdx = getClosestStep(hrp.Position)
							reached = true
							break
						end
					end
				end
				if reached then break end
			end
			if not reached then
				task.wait(0.5)
			end
		end

		if (hrp.Position - targetEndPos).Magnitude < endReachedRadius then
			break
		end
	end

	replayBtn.Text = "▶️ Start Replay"
	replayBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	replaying = false
end

-- === Record ===
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
		replaying = false
		replayButton.Text = "▶ Start Replay"
		replayButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	end
end)

recordButton.MouseButton1Click:Connect(function()
	if not recording then
		startRecording()
	else
		stopRecording()
	end
end)
