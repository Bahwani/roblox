_G.GAGConfig = _G.GAGConfig or {
    ["Harvest"] = {
        ["Sell At"]       = 80,      -- jual ketika tas/backpack kamu sudah berisi buah sebanyak ini
        ["Sell Every"]    = 30,      -- juga jual setiap N detik saat sedang memegang buah (uang stabil); 0 = mati/nonaktif
        ["Only Harvest"]  = {},      -- jika diisi, panen HANYA yang ini. contoh: { Watermelon = true }
        ["Don't Harvest"] = {},      -- jangan panen ini (biarkan tumbuh). contoh: { Carrot = true }
    },
    ["Planting"] = {
        ["Plant Plan"]  = {},
        ["Layout"]      = "compact",
        ["Don't Plant"] = { Rainbow = true, Gold = true },        -- jangan menanam ini. contoh: { Carrot = true }
        ["Keep Seeds"] = {
            ["Dragon's Breath"] = 5, ["Moon Bloom"] = 5,                                  -- bibit super langka (resale tinggi)
            ["Gold"] = 5, ["Rainbow"] = 5,      -- bibit event
        },
    },
    ["Money"] = {
        ["Keep Cash"]          = 15000,    -- selalu pertahankan uang minimal sebanyak ini
        ["Auto Expand Plot"]   = true,     -- beli perluasan lahan otomatis
        ["Max Expansions"]     = 3,        -- batasi berapa kali perluasan yang boleh dibeli otomatis. 0 = tanpa batas;
                                            -- default 3 = berhenti setelah 3 (naikkan kalau ingin lahan lebih besar)
        ["Expand If Over"]     = 1500000,  -- hanya belanjakan untuk ekspansi ketika uang kamu di atas nilai ini
        ["Auto Replace Plants"] = true,    -- ketika lahan penuh, cabut tanaman bernilai rendah lalu tanam yang lebih bagus
    },
    ["Never Sell"] = {               -- lindungi buah favorit agar tidak dijual (cukup simpan beberapa trofi saja — memenuhi tas)
        ["By Mutation"] = {},        -- simpan buah apa pun yang punya mutasi ini. contoh: { Rainbow = true, Gold = true }
        ["By Fruit"]    = {},        -- simpan buah ini, dengan mutasi apa pun. contoh: { ["Dragon Fruit"] = true }
        ["Exact"]       = {},        -- simpan tepat satu buah+mutasi tertentu.
                                      -- contoh: { { fruit = "Carrot", mut = "Gold" } }
    },
    ["Pets"] = {                     -- beli pet liar secara otomatis + lengkapi loadout terbaik kamu
        ["Buy"]   = { Raccoon = true, Unicorn = true },   -- Unicorn 2x Rainbow / -- GoldenDragonfly 2x Gold / Deer growth / Robin menghasilkan seed
        ["Equip"] = { Deer = 4 },   -- pet yang ingin selalu dipakai (auto-mengaktifkan yang kamu punya)
        ["Auto Buy Slots"] = true,   -- beli slot pet tambahan otomatis (3 -> 6, biaya 200k/1M/5M) agar cocok dengan Equip kamu
        ["Max Pet Slots"]  = 4,      -- jangan beli melebihi jumlah ini (3-6). lebih kecil = berhenti lebih cepat / hemat biaya
                                       -- (6 = full)
    },
    ["Gear"] = {
        ["Auto Buy"]           = true,             -- pengaturan utama: beli & pasang gear di bawah ini
        ["Keep Cash"]          = 15000,            -- hanya belanja gear jika uang kamu di atas nilai ini
        ["Sprinkler Coverage"] = "concentrate",    -- posisi sprinkler: "concentrate" (di tanaman terbaik) / "value" / "spread"
        ["Place Sprinklers"] = { ["best"] = 4 },
        ["Best Sprinkler Up To"] = "Rare Sprinkler",
        ["Keep Gear"] = { ["Supersize Mushroom"] = 1 },   -- gear untuk dibeli & disimpan (Supersize Mushroom = buah lebih besar)
        ["Buy Gear"]  = { ["Super Sprinkler"] = true },   -- gear tambahan yang ingin diambil saat ada di stok.
    },
    ["Event Seeds"] = {
        ["Auto Claim"] = true,       -- klaim otomatis paket bibit yang jatuh saat event
    },
    ["Mail"] = {
        ["Auto Claim"] = true,       -- klaim otomatis item yang dikirim ke mailbox (item gratis / hadiah)
        ["Send To"] = "voidisthebest79",            -- username tujuan. KOSONG = kirim dimatikan/off.
        ["Send"] = {
            -- contoh: kirim per-item dengan format Category + Item
            { Category = "Seeds", Item = "Moon Bloom" },
            { Category = "Seeds", Item = "Dragon's Breath" },
            { Category = "Seeds", Item = "Rainbow" },
            { Category = "Seeds", Item = "Gold" },

            { Category = "Pets",  Item = "Raccoon" },
            { Category = "Pets",  Item = "Unicorn" },

            { Category = "Sprinklers", Item = "Super Sprinkler" },
        },
    },
    ["Misc"] = {
        ["Auto Return To Garden"] = true,   
        ["Show Stats"]            = true,  
        ["Smart Travel"]          = true,   
                                            
    },
    ["Performance"] = {
        ["FPS Cap"]      = 30,   
        ["Low Graphics"] = true,   
        ["Remove Other Gardens"] = true,   
        ["Hide Crop Visuals"] = true,
    },
}
