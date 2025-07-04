local Players = game:GetService("Players")
local player = Players.LocalPlayer
local folderPath = "/storage/emulated/0/Delta/Workspace/LogEverest"

local replaying = false
local paused = false
local recording = false
local recordConnection = nil
local lastRecordedPos = nil
local minDistance = 1.5

-- Generate nama file unik
local function getUniqueFilename()
	local index = 1
	while isfile(folderPath.."/Log_"..index..".txt") do
		index += 1
	end
	return folderPath.."/Log_"..index..".txt"
end

-- Fungsi tulis posisi
local function writePosToFile(path, pos)
	appendfile(path, "Posisi: Vector3.new(" .. pos.X .. ", " .. pos.Y .. ", " .. pos.Z .. ")\n")
end

-- Fungsi mulai record
local function startRecording()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local logPath = getUniqueFilename()

	writefile(logPath, "") -- buat file baru
	lastRecordedPos = nil
	recording = true
	recordButton.Text = "⏹ Stop Record"
	recordButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)

	recordConnection = game:GetService("RunService").Heartbeat:Connect(function()
		if not hrp or not recording then return end
		local currentPos = hrp.Position
		if not lastRecordedPos or (currentPos - lastRecordedPos).Magnitude >= minDistance then
			writePosToFile(logPath, currentPos)
			lastRecordedPos = currentPos
		end
	end)
end

-- Fungsi stop record
local function stopRecording()
	recording = false
	recordButton.Text = "⏺ Start Record"
	recordButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	if recordConnection then recordConnection:Disconnect() end
end

-- Fungsi membaca log
local function readLog(path)
	local success, content = pcall(readfile, path)
	if not success then return {} end

	local positions = {}
	for line in content:gmatch("[^\r\n]+") do
		local x, y, z = line:match("Posisi: Vector3.new%((%-?[%d%.]+), (%-?[%d%.]+), (%-?[%d%.]+)%)")
		if x and y and z then
			table.insert(positions, Vector3.new(tonumber(x), tonumber(y), tonumber(z)))
		end
	end
	return positions
end

-- Fungsi ambil semua log
local function getAllLogs()
	local logs = {}
	local success, fileList = pcall(listfiles, folderPath)
	if not success then
		warn("Folder log gagal dibaca.")
		return {}
	end

	for _, file in ipairs(fileList) do
		if file:match("%.txt$") then
			local log = readLog(file)
			if #log > 0 then
				table.insert(logs, log)
			end
		end
	end

	return logs
end

-- Fungsi jalan
local function walkTo(pos)
	local char = player.Character or player.CharacterAdded:Wait()
	local humanoid = char:WaitForChild("Humanoid")
	if not humanoid then return end

	local reached = false
	local timeout = 3
	humanoid:MoveTo(pos)

	local conn
	conn = humanoid.MoveToFinished:Connect(function(success)
		reached = success
	end)

	local elapsed = 0
	while not reached and elapsed < timeout do
		if paused then break end
		task.wait(0.1)
		elapsed += 0.1
	end

	if conn then conn:Disconnect() end
	return reached
end

-- Fungsi replay adaptif
local function smartReplay()
	if replaying then return end
	replaying = true
	paused = false
	replayButton.Text = "⏸ Pause Replay"
	replayButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)

	local logs = getAllLogs()
	if #logs == 0 then
		warn("Log tidak ditemukan.")
		replaying = false
		replayButton.Text = "▶ Start Replay"
		replayButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		return
	end

	local stepCount = math.huge
	for _, log in ipairs(logs) do
		if #log < stepCount then
			stepCount = #log
		end
	end

	for i = 1, stepCount do
		if not replaying then break end
		while paused do task.wait(0.2) end

		local success = false
		for _, log in ipairs(logs) do
			local pos = log[i]
			if pos then
				local ok = walkTo(pos)
				if ok then
					success = true
					break
				end
			end
		end

		if not success then
			warn("Langkah " .. i .. " gagal.")
			break
		end
	end

	replaying = false
	paused = false
	replayButton.Text = "▶ Start Replay"
	replayButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end

-- === GUI ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdaptiveReplayGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 120)
frame.Position = UDim2.new(0, 15, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Parent = screenGui

local uiLayout = Instance.new("UIListLayout")
uiLayout.Parent = frame
uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiLayout.Padding = UDim.new(0, 8)

-- Tombol Replay
replayButton = Instance.new("TextButton")
replayButton.Size = UDim2.new(1, -10, 0, 40)
replayButton.Position = UDim2.new(0, 5, 0, 10)
replayButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
replayButton.TextColor3 = Color3.fromRGB(255, 255, 255)
replayButton.Font = Enum.Font.SourceSansBold
replayButton.TextSize = 18
replayButton.Text = "▶ Start Replay"
replayButton.Parent = frame

-- Tombol Record
recordButton = Instance.new("TextButton")
recordButton.Size = UDim2.new(1, -10, 0, 40)
recordButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
recordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
recordButton.Font = Enum.Font.SourceSansBold
recordButton.TextSize = 18
recordButton.Text = "⏺ Start Record"
recordButton.Parent = frame

-- Event tombol replay
replayButton.MouseButton1Click:Connect(function()
	if not replaying then
		task.spawn(smartReplay)
	else
		paused = not paused
		if paused then
			replayButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			replayButton.Text = "▶ Resume Replay"
		else
			replayButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
			replayButton.Text = "⏸ Pause Replay"
		end
	end
end)

-- Event tombol record
recordButton.MouseButton1Click:Connect(function()
	if not recording then
		startRecording()
	else
		stopRecording()
	end
end)
