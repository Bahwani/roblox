sebelumnya kode yg ini bisa menghasilkan debug  nya
-- Ambil player
local player = game.Players.LocalPlayer

-- Buat ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DebugLogGui"
screenGui.Parent = player:WaitForChild("PlayerGui") -- pakai PlayerGui agar lebih kompatibel

-- Buat Frame untuk tempat log
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 200)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.8
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- ScrollFrame supaya bisa scroll kalau banyak pesan
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -10)
scrollFrame.Position = UDim2.new(0, 5, 0, 5)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = frame

-- UIListLayout supaya pesan tersusun rapih
local uiList = Instance.new("UIListLayout")
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Parent = scrollFrame

-- Fungsi untuk konversi tabel argumen ke string
local function argsToString(args)
    local parts = {}
    for i, v in ipairs(args) do
        parts[#parts + 1] = tostring(v)
    end
    return table.concat(parts, ", ")
end

-- Fungsi untuk menambahkan pesan ke log
local function addLog(message)
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -10, 0, 18)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Font = Enum.Font.SourceSans
    textLabel.TextSize = 16
    textLabel.Text = message
    textLabel.Parent = scrollFrame

    -- Update canvas size supaya bisa scroll
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y)
    
    -- Auto scroll ke bawah
    scrollFrame.CanvasPosition = Vector2.new(0, uiList.AbsoluteContentSize.Y)
end

addLog("Debug Log GUI ready!")

-- Hook remote call
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if method == "FireServer" then
        addLog("Remote fired: "..tostring(self.Name).." Args: "..argsToString(args))
    end
    return oldNamecall(self, ...)
end
