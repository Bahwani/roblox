local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")

local ESPEnabled = false
local ShowNames = true -- Status awal nama player (true = muncul, false = sembunyi)
local isMobile = UserInputService.TouchEnabled

-- ==========================================
-- 1. FUNGSI DETEKSI ROLE (KILLER/SURVIVOR)
-- ==========================================
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
-- 2. CORE ESP SYSTEM
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
    bill.Size = UDim2.new(0, 150, 0, 30)
    bill.StudsOffset = Vector3.new(0, 3, 0)
    bill.AlwaysOnTop = true
    bill.Parent = head

    local text = bill:FindFirstChild("ESPText") or Instance.new("TextLabel")
    text.Name = "ESPText"
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextScaled = true
    text.Font = Enum.Font.SourceSansBold
    text.TextStrokeTransparency = 0
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
                
                -- Cek format teks (sembunyikan nama jika ShowNames = false)
                local nameDisplay = ShowNames and player.Name or ""
                local separator = ShowNames and "\n" or ""

                if myRoot and targetRoot then
                    local dist = math.floor((myRoot.Position - targetRoot.Position).Magnitude)
                    text.Text = nameDisplay .. separator .. "[" .. role .. "] " .. dist .. "m"
                else
                    text.Text = nameDisplay .. separator .. "[" .. role .. "]"
                end
            else
                hl.Enabled = false
                bill.Enabled = false
            end
            task.wait(0.3) -- Update tiap 0.3s agar perubahan nama langsung terasa responsif
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
-- 3. GUI TOGGLE (CROSSHAIR KECIL + KEYBIND)
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

-- Garis Vertikal (Ketebalan 1px)
local v = Instance.new("Frame", button)
v.AnchorPoint = Vector2.new(0.5, 0.5)
v.Size = UDim2.new(0, 1, 1, 0)
v.Position = UDim2.new(0.5, 0, 0.5, 0)
v.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
v.BorderSizePixel = 0

-- Garis Horizontal (Ketebalan 1px)
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
end

-- Fungsi Toggle Tampilan Nama
local function toggleNames()
    ShowNames = not ShowNames
end

button.MouseButton1Click:Connect(toggle)

-- ==========================================
-- 4. KHUSUS MOBILE: TOMBOL HIDE/SHOW NAMA
-- ==========================================
if isMobile then
    local nameToggleButton = Instance.new("TextButton")
    nameToggleButton.Name = "MobileNameToggle"
    nameToggleButton.Size = UDim2.new(0, 90, 0, 35)
    -- Diletakkan di kanan bawah layar agar tidak mengganggu pandangan tengah
    nameToggleButton.Position = UDim2.new(0.85, -45, 0.8, -17)
    nameToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    nameToggleButton.BackgroundTransparency = 0.3
    nameToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameToggleButton.Text = "Nama: ON"
    nameToggleButton.Font = Enum.Font.SourceSansBold
    nameToggleButton.TextSize = 14
    nameToggleButton.Parent = gui

    -- Efek Sudut Melengkung (Biar Aesthetic)
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = nameToggleButton

    -- Event Klik Tombol Mobile
    nameToggleButton.MouseButton1Click:Connect(function()
        toggleNames()
        if ShowNames then
            nameToggleButton.Text = "Nama: ON"
            nameToggleButton.TextColor3 = Color3.fromRGB(80, 255, 80) -- Hijau saat menyala
        else
            nameToggleButton.Text = "Nama: OFF"
            nameToggleButton.TextColor3 = Color3.fromRGB(255, 80, 80) -- Merah saat mati
        end
    end)
end

-- ==========================================
-- 5. DETEKSI KEYBOARD (UNTUK PC)
-- ==========================================
UserInputService.InputBegan:Connect(function(input, proc)
    if proc then return end
    
    if input.KeyCode == Enum.KeyCode.K then 
        toggle() 
    elseif input.KeyCode == Enum.KeyCode.L then 
        toggleNames() 
    end
end)

print("ESP Loaded!")
