--==================
--==================
local RS      = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LP      = Players.LocalPlayer
local Net     = require(RS.SharedModules.Networking)

local CHECK_INTERVAL = 21600
local MAX_PER_BATCH = 20


local function waitConfig()
    local t = 0
    while not _G.GAG2Config do
        task.wait(0.5)
        t = t + 0.5
        if t > 10 then
            warn("[GAG2] _G.GAG2Config tidak ditemukan setelah 10 detik, stop.")
            return false
        end
    end
    return true
end

local function getUserId(username)
    local ok, uid = pcall(Players.GetUserIdFromNameAsync, Players, username)
    return ok and uid or nil
end

local function getCategoryKey(toolName, cfg)
    for _, name in ipairs(cfg.items.seeds or {}) do
        if toolName == name then return "Seeds", toolName end
    end
    for _, name in ipairs(cfg.items.gears or {}) do
        if toolName == name then return "Gear", toolName end
    end
    for _, name in ipairs(cfg.items.pets or {}) do
        if toolName:find(name) then
            return "Pets", toolName
        end
    end
    return nil, nil
end

local function collectItems(cfg)
    local batch = {}

    for _, tool in pairs(LP.Backpack:GetChildren()) do
        if not tool:IsA("Tool") then continue end

        local category, itemKey = getCategoryKey(tool.Name, cfg)
        if not category then continue end

        if category == "Pets" then
            local uuid = tool:GetAttribute("PetId")
                or tool:GetAttribute("Id")
                or tool:GetAttribute("UUID")
            if uuid then itemKey = uuid end
        end

        local stackCount = 1
        pcall(function()
            stackCount = tool:GetAttribute("Count")
                or tool:GetAttribute("Stack")
                or tool:GetAttribute("Amount")
                or tool:GetAttribute("Quantity")
                or 1
            stackCount = math.max(tonumber(stackCount) or 1, 1)
        end)

        print("[GAG2] Nemu: " .. tool.Name .. " [" .. category .. "] x" .. stackCount)

        table.insert(batch, {
            ItemKey  = itemKey,
            Count    = stackCount,
            Category = category,
        })
    end

    return batch
end

local function sendInChunks(userId, batch, cfg)
    local total = #batch
    local sent = 0

    for i = 1, total, MAX_PER_BATCH do
        local chunk = {}
        for j = i, math.min(i + MAX_PER_BATCH - 1, total) do
            table.insert(chunk, batch[j])
        end

        local ok, err = pcall(function()
            Net.Mailbox.SendBatch:Fire(userId, chunk, "")
        end)

        if ok then
            sent = sent + #chunk
            print(("[GAG2] ✓ Chunk terkirim %d/%d item"):format(sent, total))
        else
            warn("[GAG2] ✗ Gagal chunk: " .. tostring(err))
        end

        if i + MAX_PER_BATCH <= total then
            task.wait(1) 
        end
    end
end

local function main()
    if not waitConfig() then return end

    local cfg = _G.GAG2Config

    print("[GAG2] Recipient: " .. cfg.recipient)
    local userId = getUserId(cfg.recipient)
    if not userId then
        warn("[GAG2] Username tidak ketemu: " .. cfg.recipient)
        return
    end
    print("[GAG2] UserId: " .. userId)

    while true do
        cfg = _G.GAG2Config 

        local batch = collectItems(cfg)

        if #batch == 0 then
            print("[GAG2] Tidak ada item cocok di backpack, retry dalam " .. CHECK_INTERVAL .. "s...")
        else
            print("[GAG2] Mengirim " .. #batch .. " item ke " .. cfg.recipient .. "...")
            local ok, err = pcall(function()
                sendInChunks(userId, batch, cfg)
            end)
            if ok then
                print("[GAG2] ✓ Semua item terkirim!")
            else
                warn("[GAG2] ✗ Gagal: " .. tostring(err))
            end
        end

        task.wait(CHECK_INTERVAL)
    end
end

main()
