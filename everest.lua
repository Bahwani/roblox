--[[
Everest Replay System (Adaptif dan Tahan Nyangkut)
Fitur:
✅ Record Posisi ke File
✅ Smart Replay dari banyak log
✅ Fallback antar log jika gagal
✅ Looping hingga mencapai koordinat akhir
✅ GUI dengan tombol Start/Stop Record dan Replay
]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local logFolder = "/storage/emulated/0/Delta/Workspace/Config/EverestLogs"
local targetEndPos = Vector3.new(-5181, 8429, 1055)
local endReachedRadius = 5

local recording = false
local replaying = false
local logs = {} -- semua log
local currentLog = {} -- saat record

-- === Fungsi Simpan File ===
local function saveLog(log)
	local name = os.time() .. ".txt"
	local path = logFolder .. "/" .. name
	local data = ""
	for _, pos in ipairs(log) do
		data ..= "Posisi: Vector3.new(" .. pos.X .. ", " .. pos.Y .. ", " .. pos.Z .. ")\n"
	end
	writefile(path, data)
end

-- === Fungsi Load Semua Log ===
local function loadAllLogs()
	logs = {}
	local files = listfiles(logFolder)
	for _, file in ipairs(files) do
		local content = readfile(file)
		local log = {}
		for line in content:gmatch("Posisi: Vector3.new%((.-)%)") do
			local x, y, z = line:match("([^,]+), ([^,]+), ([^,]+)")
			if x and y and z then
				table.insert(log, Vector3.new(tonumber(x), tonumber(y), tonumber(z)))
			end
		end
		if #log > 0 then table.insert(logs, log) end
	end
end

-- === Fungsi Record ===
local function startRecording()
	recording = true
	currentLog = {}
	task.spawn(function()
		while recording do
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				table.insert(currentLog, char.HumanoidRootPart.Position)
			end
			task.wait(0.3)
		end
	end)
end

local function stopRecording()
	recording = false
	if #currentLog > 5 then
		saveLog(currentLog)
	end
end

-- === Fungsi Jalan ===
local function walkTo(pos)
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local human = char:WaitForChild("Humanoid")
	local timeout = 10
	local startTime = tick()
	local lastPos = hrp.Position
	local stuckTime = 0

	while (pos - hrp.Position).Magnitude > 2 and tick() - startTime < timeout do
		human:MoveTo(pos)
		task.wait(0.3)
		if (hrp.Position - lastPos).Magnitude < 0.2 then
			stuckTime += 0.3
			if stuckTime > 4 then
				return false
			end
		else
			stuckTime = 0
		end
		lastPos = hrp.Position
	end
	return true
end

-- === Fungsi Cari Titik Terdekat di Semua Log ===
local function getClosestStep(pos)
	local bestLog, bestIdx, bestDist = nil, nil, math.huge
	for _, log in ipairs(logs) do
		for i, step in ipairs(log) do
			local dist = (step - pos).Magnitude
			if dist < bestDist then
				bestLog, bestIdx, bestDist = log, i, dist
			end
		end
	end
	return bestLog, bestIdx
end

-- === Smart Replay ===
local function smartReplay()
	replaying = true
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")

	local mainLog, mainIdx = getClosestStep(hrp.Position)
	if not mainLog then return end

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
			-- fallback: cari titik mirip dari log lain
			local tried = {}
			local reached = false
			for _, altLog in ipairs(logs) do
				for i = 1, #altLog do
					local alt = altLog[i]
					if (alt - goal).Magnitude < 5 and not tried[i] then
						if walkTo(alt) then
							reached = true
							break
						end
						tried[i] = true
					end
				end
				if reached then break end
			end
			if not reached then
				break -- semua gagal
			end
		end

		if (hrp.Position - targetEndPos).Magnitude < endReachedRadius then
			break -- sudah sampai summit
		end
	end
	replaying = false
end

-- === GUI ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EverestGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 120)
frame.Position = UDim2.new(0, 20, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Parent = screenGui

local uiList = Instance.new("UIListLayout")
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Parent = frame

local function makeButton(text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.Position = UDim2.new(0, 5, 0, 0)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 16
	btn.Parent = frame
	btn.MouseButton1Click:Connect(callback)
	return btn
end

local recordBtn = makeButton("Start Record", function()
	if not recording then
		recordBtn.Text = "Stop Record"
		recordBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
		startRecording()
	else
		recordBtn.Text = "Start Record"
		recordBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		stopRecording()
	end
end)

local replayBtn = makeButton("Start Replay", function()
	if not replaying then
		replayBtn.Text = "Stop Replay"
		replayBtn.BackgroundColor3 = Color3.fromRGB(30, 60, 30)
		loadAllLogs()
		task.spawn(smartReplay)
	else
		replayBtn.Text = "Start Replay"
		replayBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		replaying = false
	end
end)
