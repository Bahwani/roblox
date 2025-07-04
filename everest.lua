local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local logPath = "/storage/emulated/0/Delta/Workspace/Config/EverestLog.txt"

-- === GUI setup ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EverestGUI"
screenGui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 200)
frame.Position = UDim2.new(0, 10, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Parent = screenGui

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 6)
layout.Parent = frame

-- === State variables ===
local recording = false
local paused = false
local lastLoggedPosition = nil
local minDistance = 3
local replaying = false

-- === Log function ===
local function logToFile(text)
	appendfile(logPath, os.date("[%H:%M:%S] ") .. text .. "\n")
end

-- Fungsi jalan yang lebih halus
local function walkTo(pos)
	local char = player.Character or player.CharacterAdded:Wait()
	local humanoid = char:WaitForChild("Humanoid")
	if not humanoid then return end

	local reached = false
	local timeout = 3 -- maks 3 detik per titik

	humanoid:MoveTo(pos)

	local conn
	conn = humanoid.MoveToFinished:Connect(function(success)
		reached = true
	end)

	-- Tunggu hingga sampai atau timeout
	local elapsed = 0
	while not reached and elapsed < timeout do
		task.wait(0.1)
		elapsed += 0.1
	end

	if conn then conn:Disconnect() end

	-- Tambahan kecil untuk memastikan berhenti
	humanoid:MoveTo(char.HumanoidRootPart.Position)
end

-- === RECORD MODE ===
local function startRecording()
	writefile(logPath, "== Log Perjalanan Everest ==\n")
	recording = true
	paused = false
	logToFile("🚀 Start Recording")
end

local function pauseRecording()
	if recording and not paused then
		paused = true
		logToFile("⏸️ Recording Paused")
	end
end

local function stopRecording()
	if recording then
		recording = false
		logToFile("🛑 Recording Stopped")
	end
end

local function replayLog()
	if replaying then return end
	replaying = true

	local success, content = pcall(readfile, logPath)
	if not success then
		warn("Log tidak ditemukan!")
		replaying = false
		return
	end

	local positions = {}
	for line in content:gmatch("[^\r\n]+") do
		local x, y, z = line:match("Posisi: Vector3.new%((%-?[%d%.]+), (%-?[%d%.]+), (%-?[%d%.]+)%)")
		if x and y and z then
			table.insert(positions, Vector3.new(tonumber(x), tonumber(y), tonumber(z)))
		end
	end

	for _, pos in ipairs(positions) do
		if not replaying then break end
		walkTo(pos)
		task.wait(0.05) -- jeda kecil antar titik agar lancar
	end

	replaying = false
end

-- === Button Builder ===
local function createButton(text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.Position = UDim2.new(0, 5, 0, 0)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 16
	btn.Text = text
	btn.Parent = frame
	btn.MouseButton1Click:Connect(callback)
end

-- === Autologging if recording ===
RunService.RenderStepped:Connect(function()
	if recording and not paused then
		local char = player.Character
		if not char or not char:FindFirstChild("HumanoidRootPart") then return end

		local pos = char.HumanoidRootPart.Position
		if not lastLoggedPosition or (pos - lastLoggedPosition).Magnitude >= minDistance then
			lastLoggedPosition = pos
			logToFile("📍 Posisi: Vector3.new(" .. math.floor(pos.X) .. ", " .. math.floor(pos.Y) .. ", " .. math.floor(pos.Z) .. ")")
		end
	end
end)

-- === Add buttons ===
createButton("🚀 Start Record", startRecording)
createButton("⏸️ Pause", pauseRecording)
createButton("🛑 Stop", stopRecording)

-- Replay only if log exists
local hasLog = pcall(readfile, logPath)
if hasLog then
	createButton("🔁 Replay Jalur", replayLog)
end
