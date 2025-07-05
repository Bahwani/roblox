local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- === Variabel Utama ===
local folderPath = "/storage/emulated/0/Delta/Workspace/PetssLogEverest"
local flyEnabled, speedEnabled, instantEnabled = false, false, false
local flyBodyVelocity = nil
local normalSpeed, fastSpeed = 16, 36
local replaying, recording = false, false
local recordConnection, lastRecordedPos = nil, nil
local minDistance, walkStep, fallbackStep = 1.5, 8, 2

-- === GUI PetoGacorrawr ===
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "PetoGacorrawr"

local frame = Instance.new("Frame", gui)
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 220, 0, 260)
frame.Position = UDim2.new(0.5, -110, 0.5, -130)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local scrollContent = Instance.new("ScrollingFrame", frame)
scrollContent.Name = "ScrollContent"
scrollContent.Position = UDim2.new(0, 0, 0, 40) -- mulai setelah header
scrollContent.Size = UDim2.new(1, 0, 1, -40)    -- sisakan tempat buat header
scrollContent.BackgroundTransparency = 1
scrollContent.BorderSizePixel = 0
scrollContent.CanvasSize = UDim2.new(0, 0, 0, 500)
scrollContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollContent.ScrollBarThickness = 6
scrollContent.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

local layout = Instance.new("UIListLayout", scrollContent)
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -70, 0, 30)
title.Position = UDim2.new(0, 5, 0, 0)
title.Text = "PetoGacorrawr"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left

local minimizeButton = Instance.new("TextButton", frame)
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -65, 0, 0)
minimizeButton.Text = "-"

local closeButton = Instance.new("TextButton", frame)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 0)
closeButton.Text = "X"

local flyButton = Instance.new("TextButton", scrollContent)
flyButton.LayoutOrder = 1
flyButton.Size = UDim2.new(1, -10, 0, 30)
flyButton.Position = UDim2.new(0, 5, 0, 35)
flyButton.Text = "Fly: OFF"
flyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local speedButton = Instance.new("TextButton", scrollContent)
speedButton.LayoutOrder = 2
speedButton.Size = UDim2.new(1, -10, 0, 30)
speedButton.Position = UDim2.new(0, 5, 0, 75)
speedButton.Text = "Speed: OFF"
speedButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local instantInteractButton = Instance.new("TextButton", scrollContent)
instantInteractButton.LayoutOrder = 3
instantInteractButton.Size = UDim2.new(1, -10, 0, 30)
instantInteractButton.Position = UDim2.new(0, 5, 0, 115)
instantInteractButton.Text = "Instant: OFF"
instantInteractButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
instantInteractButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Tambahkan ini DI BAWAH instantInteractButton (masih dalam `frame`)
local replayButton = Instance.new("TextButton", scrollContent)
replayButton.LayoutOrder = 4
replayButton.Size = UDim2.new(1, -10, 0, 30)
replayButton.Position = UDim2.new(0, 5, 0, 155) -- Sesuaikan posisi (115 + 30 + 10)
replayButton.Text = "▶ Start Replay"
replayButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
replayButton.TextColor3 = Color3.fromRGB(255, 255, 255)
replayButton.Font = Enum.Font.SourceSansBold
replayButton.TextSize = 18

local recordButton = Instance.new("TextButton", scrollContent)
recordButton.LayoutOrder = 5
recordButton.Size = UDim2.new(1, -10, 0, 30)
recordButton.Position = UDim2.new(0, 5, 0, 195) -- Sesuaikan posisi (155 + 30 + 10)
recordButton.Text = "⏺ Start Record"
recordButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
recordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
recordButton.Font = Enum.Font.SourceSansBold
recordButton.TextSize = 18


-- === GUI Mini
local miniFrame = Instance.new("ImageButton", gui)
miniFrame.Size = UDim2.new(0, 50, 0, 50)
miniFrame.Position = UDim2.new(0.5, -25, 0.5, -25)
miniFrame.BackgroundTransparency = 1
miniFrame.Image = "rbxassetid://116056354483334"
miniFrame.Visible = false
miniFrame.Active = true
miniFrame.Draggable = true
miniFrame.ZIndex = 6

local corner = Instance.new("UICorner", miniFrame)
corner.CornerRadius = UDim.new(1, 0)

local borderFrame = Instance.new("Frame", miniFrame)
borderFrame.Size = UDim2.new(1, 6, 1, 6)
borderFrame.Position = UDim2.new(0, -3, 0, -3)
borderFrame.BackgroundColor3 = Color3.new(1, 0, 0)
borderFrame.BorderSizePixel = 0
borderFrame.ZIndex = 5
borderFrame.Visible = false

local borderCorner = Instance.new("UICorner", borderFrame)
borderCorner.CornerRadius = UDim.new(1, 0)

-- === Tombol Handler ===
flyButton.MouseButton1Click:Connect(function()
	flyEnabled = not flyEnabled
	flyButton.Text = flyEnabled and "Fly: ON" or "Fly: OFF"
	if flyEnabled then
		flyBodyVelocity = Instance.new("BodyVelocity")
		flyBodyVelocity.Velocity = Vector3.new(0, 50, 0)
		flyBodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
		flyBodyVelocity.P = 1250
		flyBodyVelocity.Parent = humanoidRootPart
	else
		if flyBodyVelocity then
			flyBodyVelocity:Destroy()
			flyBodyVelocity = nil
		end
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

minimizeButton.MouseButton1Click:Connect(function()
	frame.Visible = false
	borderFrame.Visible = true
	miniFrame.Visible = true
end)

miniFrame.MouseButton1Click:Connect(function()
	miniFrame.Visible = false
	borderFrame.Visible = false
	frame.Visible = true
end)

closeButton.MouseButton1Click:Connect(function()
	if flyEnabled and flyBodyVelocity then flyBodyVelocity:Destroy() end
	humanoid.WalkSpeed = normalSpeed

	-- Matikan recording dan replay
	recording = false
	replaying = false
	if recordConnection then recordConnection:Disconnect() end

	gui:Destroy()
end)


-- === Prompt Instant Interact ===
ProximityPromptService.PromptShown:Connect(function(prompt)
	if instantEnabled then
		prompt.HoldDuration = 0
		local mousePos = UserInputService:GetMouseLocation()
		if not (mousePos.X >= gui.AbsolutePosition.X and mousePos.X <= gui.AbsolutePosition.X + gui.AbsoluteSize.X and
		        mousePos.Y >= gui.AbsolutePosition.Y and mousePos.Y <= gui.AbsolutePosition.Y + gui.AbsoluteSize.Y) then
			prompt.ClickablePrompt = true
		else
			prompt.ClickablePrompt = false
		end
	end
end)

-- === Border RGB Animation ===
spawn(function()
	local hue = 0
	while true do
		hue = (hue + 1) % 360
		borderFrame.BackgroundColor3 = Color3.fromHSV(hue / 360, 1, 1)
		wait(0.03)
	end
end)

-- === Fungsi Record / Replay ===
local function ensureFolderExists(path)
	if not isfolder(path) then makefolder(path) end
end

local function getUniqueFilename()
	local i = 1
	while isfile(folderPath .. "/Log_" .. i .. ".txt") do i += 1 end
	return folderPath .. "/Log_" .. i .. ".txt"
end

local function writePos(path, pos)
	appendfile(path, string.format("Posisi: Vector3.new(%s, %s, %s)\n", pos.X, pos.Y, pos.Z))
end

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
	local minDist, bestLog, bestStep = math.huge, nil, nil
	for i, log in ipairs(logs) do
		for j, pos in ipairs(log) do
			if pos.X < currentPos.X then -- hanya titik yg lebih tinggi
				local d = (pos - currentPos).Magnitude
				if d < minDist then
					minDist = d
					bestLog, bestStep = i, j
				end
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

local function smartReplay()
	replaying = true
	replayButton.Text = "⏹ Stop Replay"
	replayButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)

	local logs = getAllLogs()
	if #logs == 0 then return end

	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

-- Cek semua log dan pilih yang POSISI awalnya lebih tinggi dari sekarang
local validLogs = {}
local currentPos = hrp.Position
for i, log in ipairs(logs) do
	local lastPos = log[#log]
	if lastPos.Y > currentPos.Y then
		table.insert(validLogs, {log = log, index = i})
	end
end

if #validLogs == 0 then
	warn("Tidak ada log lanjutan, replay selesai.")
	replayButton.Text = "▶ Start Replay"
	replayButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	replaying = false
	return
end
-- Pilih log valid yang paling dekat dari posisi sekarang
    local minDist, bestIndex, bestStep = math.huge, nil, 1
    for _, entry in ipairs(validLogs) do
    	for j, pos in ipairs(entry.log) do
    		if pos.Y > currentPos.Y then -- Hanya ambil titik di atas
    			local d = (pos - currentPos).Magnitude
	    		if d < minDist then
	    			minDist = d
	    			bestIndex = entry.index
	    			bestStep = j
	    		end
    		end
    	end
    end

    local currentLogIndex, currentStepIndex = bestIndex, bestStep

	while replaying and currentLogIndex <= #logs do
		local log = logs[currentLogIndex]
		local i = currentStepIndex

		while replaying and i <= #log do
			local pos = log[i]
			local success = walkTo(pos)

			if success then
				i += walkStep
			else
				local targetStep = math.min(i + fallbackStep, #log)
				local fallbackPos = log[targetStep]

				local char = player.Character or player.CharacterAdded:Wait()
				local hrp = char:WaitForChild("HumanoidRootPart")
				local humanoid = char:FindFirstChild("Humanoid")

				if humanoid and fallbackPos then
					print("[Fallback] Memanggil MoveTo ke langkah " .. targetStep)
					humanoid:MoveTo(fallbackPos)

					local done = false
					local moveConn = humanoid.MoveToFinished:Connect(function(ok)
						done = ok
					end)

					local elapsed = 0
					while not done and elapsed < 3.0 do
						task.wait(0.1)
						elapsed += 0.1
					end
					moveConn:Disconnect()

					if done then
						print("[Fallback] MoveTo berhasil ke langkah " .. targetStep)
					else
						print("[Fallback] MoveTo gagal/tidak selesai dalam 3 detik, teleport paksa dengan CFrame...")
						-- Teleport paksa via CFrame jika MoveTo gagal
						hrp.CFrame = CFrame.new(fallbackPos + Vector3.new(0, 3, 0))
						task.wait(0.2)
					end
				else
					print("[Fallback] Tidak bisa teleport karena Humanoid atau fallbackPos nil")
				end

				i = targetStep + 1
			end
		end

		currentLogIndex += 1
		currentStepIndex = 1
	end

	replayButton.Text = "▶ Start Replay"
	replayButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	replaying = false
end

local function startRecording()
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local logPath = getUniqueFilename()

	ensureFolderExists(folderPath)
	writefile(logPath, "")
	lastRecordedPos = nil
	recording = true

	recordButton.Text = "⏹ Stop Record"
	recordButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)

	recordConnection = RunService.Heartbeat:Connect(function()
		if not recording then return end
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

replayButton.MouseButton1Click:Connect(function()
	if not replaying then
		task.spawn(smartReplay)
	else
		replaying = false
	end
end)

recordButton.MouseButton1Click:Connect(function()
	if not recording then
		startRecording()
	else
		stopRecording()
	end
end)
