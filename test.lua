local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- === Buat GUI ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 250)
frame.Position = UDim2.new(0, 20, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Parent = screenGui

local uiList = Instance.new("UIListLayout")
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 6)
uiList.Parent = frame

-- === Lokasi & urutan ===
local locations = {
	Camp1 = Vector3.new(-1075, 941, 1268),
	Camp2 = Vector3.new(-2121, 1781, 793),
	Camp3 = Vector3.new(-3942, 5005, 866),
	Camp4 = Vector3.new(-4630, 6616, 913),
	Summit = Vector3.new(-5181, 8429, 1055),
}

-- Urutan tampil
local order = {"Camp1", "Camp2", "Camp3", "Camp4", "Summit"}

-- === Fungsi teleport ===
local function teleportTo(position)
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	hrp.CFrame = CFrame.new(position)
end

-- === Fungsi buat tombol ===
local function createButton(name)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 18
	btn.Text = "Teleport ke " .. name
	btn.Parent = frame

	btn.MouseButton1Click:Connect(function()
		local destination = locations[name]
		if destination then
			teleportTo(destination)
		end
	end)
end

-- === Buat tombol secara urut ===
for _, name in ipairs(order) do
	createButton(name)
end
