local Players = game:GetService("Players")
local player = Players.LocalPlayer
local folderPath = "/storage/emulated/0/Delta/Workspace/LogEverest"
local replaying = false
local paused = false

-- === GUI ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdaptiveReplayGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 160, 0, 60)
frame.Position = UDim2.new(0, 15, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Parent = screenGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -10, 0, 40)
button.Position = UDim2.new(0, 5, 0, 10)
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 18
button.Text = "▶ Start Replay"
button.Parent = frame

-- === Fungsi Membaca Log ===
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

-- === Fungsi Jalan ===
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

-- === Replay Adaptif ===
local function smartReplay()
	if replaying then return end
	replaying = true
	paused = false
	button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	button.Text = "⏸ Pause Replay"

	local logs = getAllLogs()
	if #logs == 0 then
		warn("Log tidak ditemukan.")
		replaying = false
		button.Text = "▶ Start Replay"
		button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
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
			warn("Langkah " .. i .. " gagal, semua jalur tidak berhasil.")
			break
		end
	end

	replaying = false
	paused = false
	button.Text = "▶ Start Replay"
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end

-- === Toggle Start/Pause Replay ===
button.MouseButton1Click:Connect(function()
	if not replaying then
		task.spawn(smartReplay)
	else
		paused = not paused
		if paused then
			button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			button.Text = "▶ Resume Replay"
		else
			button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
			button.Text = "⏸ Pause Replay"
		end
	end
end)
