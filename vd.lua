local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ESPEnabled = false
local ShowNames = true -- Status awal nama player (true = muncul, false = sembunyi)
local ShowRoles = true -- Status awal role player (true = muncul, false = sembunyi)
local isMobile = UserInputService.TouchEnabled

-- Forward declaration untuk tombol mobile agar bisa diakses di fungsi toggle
local nameToggleButton = nil 
local roleToggleButton = nil

local function getRole(player)
    local channels = TextChatService:FindFirstChild("TextChannels")
    if not channels then return "Spectator" end
    
    local killer = channels:FindFirstChild("RBXTeamCrimson")
    local survivor = channels:FindFirstChild("RBXTeamDeep blue")
    
    if killer and killer:FindFirstChild(player.Name) then return "Killer" end
    if survivor and survivor:FindFirstChild(player.Name) then return "Survivor" end
    return "Spectator"
end

-- ==========================================
-- 3. CORE ESP SYSTEM
-- ==========================================
local function applyESP(player, char)
    if player == LocalPlayer then return end
    
    local head = char:WaitForChild("Head", 15)
    if not head then return end

    -- Buat Highlight (Efek X-Ray Tembus Tembok)
    local hl = char:FindFirstChild("ESPHighlight") or Instance.new("Highlight")
    hl.Name = "ESPHighlight"
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.Parent = char

    -- Buat BillboardGui (Nama & Jarak)
    local bill = head:FindFirstChild("ESPBill") or Instance.new("BillboardGui")
    bill.Name = "ESPBill"
    bill.Size = UDim2.new(0, 150, 0, 45) -- Ditinggikan sedikit agar aman untuk多line
    bill.StudsOffset = Vector3.new(0, 3, 0)
    bill.AlwaysOnTop = true
    bill.Parent = head

    local text = bill:FindFirstChild("ESPText") or Instance.new("TextLabel")
    text.Name = "ESPText"
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextScaled = false
    text.TextSize = 13
    text.Font = Enum.Font.SourceSansBold
    text.TextStrokeTransparency = 0
    text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    text.RichText = true
    text.Parent = bill

    -- Loop Update Status & Jarak
    task.spawn(function()
        while char and char.Parent do
            if ESPEnabled then
                local role = getRole(player)
                local color = (role == "Killer" and Color3.fromRGB(255, 40, 40)) or (role == "Survivor" and Color3.fromRGB(40, 255, 40)) or Color3.fromRGB(200, 200, 200)
                
                hl.Enabled = true
                bill.Enabled = true
                hl.FillColor = color
                text.TextColor3 = color
                
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local targetRoot = char:FindFirstChild("HumanoidRootPart")
                
                -- Kalkulasi Jarak
                local distText = ""
                if myRoot and targetRoot then
                    local dist = math.floor((myRoot.Position - targetRoot.Position).Magnitude)
                    distText = " " .. dist .. "m"
                end

                -- Sistem teks adaptif berdasarkan toggle Nama & Role
                local displayText = ""
                if ShowNames then
                    displayText = player.Name
                end

                if ShowRoles then
                    if displayText ~= "" then
                        displayText = displayText .. "\n" -- Kasih baris baru jika nama aktif
                    end
                    displayText = displayText .. "[" .. role .. "]" .. distText
                elseif not ShowRoles and distText ~= "" then
                    -- Jika role disembunyikan tapi tetap ingin memunculkan jarak
                    if displayText ~= "" then
                        displayText = displayText .. "\n"
                    end
                    displayText = displayText .. "[" .. distText:sub(2) .. "]"
                end
                
                text.Text = displayText
            else
                hl.Enabled = false
                bill.Enabled = false
            end
            task.wait(0.3)
        end
    end)
end

-- Monitor Player yang masuk atau respawn
local function setupPlayer(player)
    if player.Character then applyESP(player, player.Character) end
    player.CharacterAdded:Connect(function(char)
        applyESP(player, char)
    end)
end

for _, p in pairs(Players:GetPlayers()) do setupPlayer(p) end
Players.PlayerAdded:Connect(setupPlayer)

-- ==========================================
-- 4. GUI TOGGLE (CROSSHAIR KECIL + KEYBIND)
-- ==========================================
local gui = Instance.new("ScreenGui")
gui.Name = "ESPToggleUI"
gui.ResetOnSpawn = false
gui.Parent = (game:GetService("CoreGui") or LocalPlayer.PlayerGui)

-- Tombol Crosshair (Tengah Layar)
local button = Instance.new("TextButton")
button.Size = isMobile and UDim2.new(0, 20, 0, 20) or UDim2.new(0, 12, 0, 12)
button.AnchorPoint = Vector2.new(0.5, 0.5)
button.Position = UDim2.new(0.5, 0, 0.5, 0)
button.BackgroundTransparency = 1
button.Text = ""
button.Parent = gui

-- Garis Vertikal
local v = Instance.new("Frame", button)
v.AnchorPoint = Vector2.new(0.5, 0.5)
v.Size = UDim2.new(0, 1, 1, 0)
v.Position = UDim2.new(0.5, 0, 0.5, 0)
v.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
v.BorderSizePixel = 0

-- Garis Horizontal
local h = Instance.new("Frame", button)
h.AnchorPoint = Vector2.new(0.5, 0.5)
h.Size = UDim2.new(1, 0, 0, 1)
h.Position = UDim2.new(0.5, 0, 0.5, 0)
h.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
h.BorderSizePixel = 0

-- Fungsi Toggle ESP Utama
local function toggle()
    ESPEnabled = not ESPEnabled
    local col = ESPEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    v.BackgroundColor3 = col
    h.BackgroundColor3 = col
    
    if nameToggleButton then nameToggleButton.Visible = ESPEnabled end
    if roleToggleButton then roleToggleButton.Visible = ESPEnabled end
end

local function toggleNames()
    ShowNames = not ShowNames
end

local function toggleRoles()
    ShowRoles = not ShowRoles
end

button.MouseButton1Click:Connect(toggle)

-- ==========================================
-- 5. KHUSUS MOBILE: TOMBOL HIDE/SHOW NAMA & ROLE (DRAGGABLE)
-- ==========================================
if isMobile then
    -- Fungsi pembantu untuk membuat tombol draggable secara otomatis
    local function makeDraggable(targetButton)
        local dragging = false
        local dragInput, dragStart, startPos

        targetButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = targetButton.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        targetButton.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                targetButton.Position = UDim2.new(
                    startPos.X.Scale, 
                    startPos.X.Offset + delta.X, 
                    startPos.Y.Scale, 
                    startPos.Y.Offset + delta.Y
                )
            end
        end)
    end

    -- 1. Tombol Toggle Nama
    nameToggleButton = Instance.new("TextButton")
    nameToggleButton.Name = "MobileNameToggle"
    nameToggleButton.Size = UDim2.new(0, 90, 0, 35)
    nameToggleButton.AnchorPoint = Vector2.new(0, 0.5)
    nameToggleButton.Position = UDim2.new(0, 15, 0.5, -40)
    nameToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    nameToggleButton.BackgroundTransparency = 0.3
    nameToggleButton.TextColor3 = Color3.fromRGB(80, 255, 80)
    nameToggleButton.Text = "Nama: ON"
    nameToggleButton.Font = Enum.Font.SourceSansBold
    nameToggleButton.TextSize = 14
    nameToggleButton.Visible = false
    nameToggleButton.Parent = gui

    local corner1 = Instance.new("UICorner", nameToggleButton)
    corner1.CornerRadius = UDim.new(0, 8)

    nameToggleButton.MouseButton1Click:Connect(function()
        toggleNames()
        if ShowNames then
            nameToggleButton.Text = "Nama: ON"
            nameToggleButton.TextColor3 = Color3.fromRGB(80, 255, 80)
        else
            nameToggleButton.Text = "Nama: OFF"
            nameToggleButton.TextColor3 = Color3.fromRGB(255, 80, 80)
        end
    end)
    makeDraggable(nameToggleButton)

    -- 2. Tombol Toggle Role
    roleToggleButton = Instance.new("TextButton")
    roleToggleButton.Name = "MobileRoleToggle"
    roleToggleButton.Size = UDim2.new(0, 90, 0, 35)
    roleToggleButton.AnchorPoint = Vector2.new(0, 0.5)
    roleToggleButton.Position = UDim2.new(0, 15, 0.5, 5) -- Diletakkan di bawah tombol nama sedikit
    roleToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    roleToggleButton.BackgroundTransparency = 0.3
    roleToggleButton.TextColor3 = Color3.fromRGB(80, 255, 80)
    roleToggleButton.Text = "Role: ON"
    roleToggleButton.Font = Enum.Font.SourceSansBold
    roleToggleButton.TextSize = 14
    roleToggleButton.Visible = false
    roleToggleButton.Parent = gui

    local corner2 = Instance.new("UICorner", roleToggleButton)
    corner2.CornerRadius = UDim.new(0, 8)

    roleToggleButton.MouseButton1Click:Connect(function()
        toggleRoles()
        if ShowRoles then
            roleToggleButton.Text = "Role: ON"
            roleToggleButton.TextColor3 = Color3.fromRGB(80, 255, 80)
        else
            roleToggleButton.Text = "Role: OFF"
            roleToggleButton.TextColor3 = Color3.fromRGB(255, 80, 80)
        end
    end)
    makeDraggable(roleToggleButton)
end

-- ==========================================
-- 6. DETEKSI KEYBOARD (UNTUK PC)
-- ==========================================
UserInputService.InputBegan:Connect(function(input, proc)
    if proc then return end
    
    if input.KeyCode == Enum.KeyCode.K then 
        toggle() 
    elseif input.KeyCode == Enum.KeyCode.L then 
        toggleNames() 
    elseif input.KeyCode == Enum.KeyCode.J then 
        toggleRoles() 
    end
end)
