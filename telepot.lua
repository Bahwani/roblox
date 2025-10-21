--// Services
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
local hrp = player.Character and player.Character:WaitForChild("HumanoidRootPart")

-- Flag global
local running = true

--// Data Teleport
local checkpoints = {
    PosisiAwal = {
        pos = Vector3.new(37.21, 17.03, 2844.50),
        dir = Vector3.new(-0.12, 0.00, -0.99)
    },
    Kohana = {
        {pos = Vector3.new(-653.98, 17.25, 448.92), dir = Vector3.new(0.99, -0.00, 0.13)},
        {pos = Vector3.new(-621.95, 19.25, 423.33), dir = Vector3.new(-0.16, -0.00, 0.99)},
        {pos = Vector3.new(-585.78, 17.25, 454.51), dir = Vector3.new(-0.96, -0.00, -0.27)},
        {pos = Vector3.new(-600.75, 17.25, 509.37), dir = Vector3.new(-0.95, -0.00, -0.32)},
        {pos = Vector3.new(-603.05, 3.10, 561.09), dir = Vector3.new(-0.77, -0.00, -0.64)},
        {pos = Vector3.new(-656.27, 2.83, 554.98), dir = Vector3.new(1.00, 0.00, 0.00)},
    },
    KohanaVolcano = {
    	{pos = Vector3.new(-636.94, 56.39, 204.01), dir = Vector3.new(-0.74, -0.00, -0.68)},
        {pos = Vector3.new(-673.39, 55.50, 182.27), dir = Vector3.new(1.00, -0.00, -0.03)},
        {pos = Vector3.new(-667.30, 46.98, 130.94), dir = Vector3.new(-0.15, -0.00, 0.99)},
        {pos = Vector3.new(-633.48, 21.44, 66.63), dir = Vector3.new(-0.97, -0.00, 0.26)},
    },
    Crater = {
        {pos = Vector3.new(990.54, 20.85, 5059.33), dir = Vector3.new(-0.59, 0.00, -0.81)},
        {pos = Vector3.new(979.06, 47.60, 5086.93), dir = Vector3.new(0.17, 0.00, 0.98)},
        {pos = Vector3.new(1066.27, 57.16, 5045.55), dir = Vector3.new(-0.56, 0.00, 0.83)},       
        {pos = Vector3.new(1059.03, 1.58, 5127.00), dir = Vector3.new(-0.65, 0.00, -0.76)},   
        {pos = Vector3.new(944.05, 1.84, 5069.29), dir = Vector3.new(0.89, 0.00, 0.45)},
    },
    Ocean = {
        {pos = Vector3.new(-2575.50, 5.69, -21.88), dir = Vector3.new(-0.55, -0.00, -0.84)},
        {pos = Vector3.new(-2646.18, 9.19, 44.03), dir = Vector3.new (0.49, 0.00, 0.87)},
        {pos = Vector3.new(-2749.14, 44.54, 15.74), dir = Vector3.new (-0.98, -0.00, -0.19)},
        {pos = Vector3.new(-2645.23, 124.88, -32.56), dir = Vector3.new (-0.59, -0.00, -0.80)},
    }	
}

--// Teleport
local function teleportAndLook(target, label)
    if hrp then
        hrp.CFrame = CFrame.new(target.pos, target.pos + target.dir)
        StarterGui:SetCore("SendNotification", {
            Title = "Teleport Success",
            Text = "Teleport to " .. label,
            Duration = 5
        })
    end
end

--// GUI Buatan
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local TitleBar = Instance.new("Frame", MainFrame)
local Title = Instance.new("TextLabel", TitleBar)
local CloseBtn = Instance.new("TextButton", TitleBar)
local MinBtn = Instance.new("TextButton", TitleBar)
local Scroll = Instance.new("ScrollingFrame", MainFrame)
local UIList = Instance.new("UIListLayout", Scroll)
local UIPadding = Instance.new("UIPadding", Scroll)

-- Frame Utama
MainFrame.Size = UDim2.new(0, 270, 0, 320)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.15 
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

-- Rounded corner & outline
local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(80, 80, 80)
MainStroke.Thickness = 1.5

-- Gradient
local MainGradient = Instance.new("UIGradient", MainFrame)
MainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
}
MainGradient.Rotation = 90

-- TitleBar
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleBar.BackgroundTransparency = 0.2 
TitleBar.BorderSizePixel = 0
local TitleCorner = Instance.new("UICorner", TitleBar)
TitleCorner.CornerRadius = UDim.new(0, 10)

Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Peto Mancing"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.Text = "✕"
CloseBtn.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
CloseBtn.BackgroundTransparency = 0.3 
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
local CloseCorner = Instance.new("UICorner", CloseBtn)
CloseCorner.CornerRadius = UDim.new(0, 6)

-- Minimize Button
MinBtn.Size = UDim2.new(0, 35, 0, 35)
MinBtn.Position = UDim2.new(1, -70, 0, 0)
MinBtn.Text = "–"
MinBtn.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
MinBtn.BackgroundTransparency = 0.3
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
local MinCorner = Instance.new("UICorner", MinBtn)
MinCorner.CornerRadius = UDim.new(0, 6)

-- Scroll Menu
Scroll.Size = UDim2.new(1, 0, 1, -35)
Scroll.Position = UDim2.new(0, 0, 0, 35)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 4
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 6)
UIPadding.PaddingTop = UDim.new(0, 8)
UIPadding.PaddingLeft = UDim.new(0, 8)
UIPadding.PaddingRight = UDim.new(0, 8)

-- Fungsi buat button biasa
local function createButton(name, target)
    local Btn = Instance.new("TextButton", Scroll)
    Btn.Size = UDim2.new(1, -10, 0, 36)
    Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 14
    Btn.Text = name

    local corner = Instance.new("UICorner", Btn)
    corner.CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", Btn)
    stroke.Color = Color3.fromRGB(90, 90, 90)
    stroke.Thickness = 1.2

    Btn.MouseEnter:Connect(function()
        Btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end)
    Btn.MouseLeave:Connect(function()
        Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)

    Btn.MouseButton1Click:Connect(function()
        teleportAndLook(target, name)
    end)
end

--// CONFIG SYSTEM
local HttpService = game:GetService("HttpService")
local folderPath = "Peto"
local filePath = folderPath.."/PetssMancing.json"

-- Default config
local config = {
    Kohana = false,
    KohanaVolcano = false,
    CraterIsland = false
}

-- Buat folder/file kalau belum ada
if not isfolder(folderPath) then
    makefolder(folderPath)
end

if not isfile(filePath) then
    writefile(filePath, HttpService:JSONEncode(config))
else
    -- load config kalau ada
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(filePath))
    end)
    if success and typeof(data) == "table" then
        config = data
    end
end

-- Fungsi save config
local function saveConfig()
    writefile(filePath, HttpService:JSONEncode(config))
end

--// Update toggle supaya auto-save
local function createToggle(name, teleportList, key)
    local Frame = Instance.new("Frame", Scroll)
    Frame.Size = UDim2.new(1, -10, 0, 36)
    Frame.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.TextXAlignment = Enum.TextXAlignment.Left

    -- Switch background
    local Switch = Instance.new("TextButton", Frame)
    Switch.Size = UDim2.new(0, 50, 0, 24)
    Switch.Position = UDim2.new(1, -60, 0.5, -12)
    Switch.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Switch.Text = ""

    local corner = Instance.new("UICorner", Switch)
    corner.CornerRadius = UDim.new(1, 0)

    local stroke = Instance.new("UIStroke", Switch)
    stroke.Color = Color3.fromRGB(100, 100, 100)
    stroke.Thickness = 1.2

    -- Bulatan
    local Knob = Instance.new("Frame", Switch)
    Knob.Size = UDim2.new(0, 20, 0, 20)
    Knob.Position = UDim2.new(0, 2, 0.5, -10)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    local knobCorner = Instance.new("UICorner", Knob)
    knobCorner.CornerRadius = UDim.new(1, 0)

    local active = config[key] or false -- load dari config

    -- Fungsi untuk update tampilan toggle
    local function updateToggleUI(state)
        if state then
            Switch.BackgroundColor3 = Color3.fromRGB(60, 160, 80)
            Knob.Position = UDim2.new(1, -22, 0.5, -10)
        else
            Switch.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Knob.Position = UDim2.new(0, 2, 0.5, -10)
        end
    end

    -- set UI sesuai config
    updateToggleUI(active)

    if active then
        task.spawn(function()
            while active and running do
                for _, checkpoint in ipairs(teleportList) do
                    if not active or not running then break end
                    teleportAndLook(checkpoint, name)
                    task.wait(10)
                end
            end
        end)
    end

    Switch.MouseButton1Click:Connect(function()
        active = not active
        config[key] = active
        saveConfig() -- simpan ke file

        if active then
            Switch.BackgroundColor3 = Color3.fromRGB(60, 160, 80)
            Knob:TweenPosition(UDim2.new(1, -22, 0.5, -10), "Out", "Sine", 0.2, true)
            StarterGui:SetCore("SendNotification", {
                Title = "Teleport Loop",
                Text = name .. " aktif",
                Duration = 3
            })
            task.spawn(function()
                while active and running do
                    for _, checkpoint in ipairs(teleportList) do
                        if not active or not running then break end
                        teleportAndLook(checkpoint, name)
                        task.wait(10)
                    end
                end
            end)
        else
            Switch.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Knob:TweenPosition(UDim2.new(0, 2, 0.5, -10), "Out", "Sine", 0.2, true)
            StarterGui:SetCore("SendNotification", {
                Title = "Teleport Loop",
                Text = name .. " nonaktif",
                Duration = 3
            })
        end
    end)
end

-- Tambah menu
createButton("Posisi Awal", checkpoints.PosisiAwal)
createToggle("Kohana", checkpoints.Kohana, "Kohana")
createToggle("Kohana Volcano", checkpoints.KohanaVolcano, "KohanaVolcano")
createToggle("Crater Island", checkpoints.Crater, "CraterIsland")
createToggle("Ocean", checkpoints.Ocean, "Ocean")

-- Fungsi tombol
CloseBtn.MouseButton1Click:Connect(function()
    running = false
    ScreenGui:Destroy()
end)

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    Scroll.Visible = not minimized
    MainFrame.Size = minimized and UDim2.new(0, 270, 0, 35) or UDim2.new(0, 270, 0, 320)
end)
