-- Ambil service dan player
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ========== BUAT GUI LOG ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DebugLogGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 200)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Parent = screenGui

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -10)
scrollFrame.Position = UDim2.new(0, 5, 0, 5)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = frame

local uiList = Instance.new("UIListLayout")
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Parent = scrollFrame

-- ========== FUNGSI TAMPILKAN LOG ==========
local function logMessage(msg)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -5, 0, 20)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.Code
	label.TextSize = 14
	label.Text = msg
	label.Parent = scrollFrame
	
	-- Update tinggi canvas
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y + 10)
end

-- ========== FUNGSI AMBIL POSISI ==========
local function logPosition()
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")
	local pos = hrp.Position
	local x = math.floor(pos.X + 0.5)
	local y = math.floor(pos.Y + 0.5)
	local z = math.floor(pos.Z + 0.5)

	local output = "Vector3.new(" .. x .. ", " .. y .. ", " .. z .. ")"
	logMessage(output)
end

-- ========== JALANKAN ==========
logMessage("📍 Logger koordinat aktif.")
logPosition()
