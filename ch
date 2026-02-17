getgenv().RAM = {
    ["Roblox Account Manager"] = {
        ["Enabled"] = false,
        ["Port"] = 7963,
        ["Password"] = "",
    },
    ["Custom Horst Manager Log"] = {
        ["Enabled"] = false,
        ["Description"] =  [[
        ⚡ Cash : [MONEY], 💎 Level : [LEVEL], 🎣 Rod Inventory : [RODSCOUNT], 🐟 Equipped Rod : [RODNOW] 
        ]],
        ["Delay Update"] = 5, -- // Second
    },
}  
getgenv().Configuration
    = {
        ["Fishing Location"] = CFrame.new(
            -950.61, 141.85, -1113.21
        ),
        ["Current Version"] = "12",
        ["Auto Rejoin"] = true,
        ["Safe Mode"] = true,
        Daily_Shop = {
            ["Enabled"] = true,
            Level_Requirement = 1000,
            Item_List = {
                "Aurora Totem",
                "Random Rod", --// ถ้าสุ่มเจอ ในร้านโคตรโชคดีเบ็ตแม่งอย่างโหด โอกาส ออก 0.02%
                "Bloop Whistle", --// เอาไปรับเปิดได้
                "Exalted Relic",
                "Megalodon Hunt Totem",
            },
        },
        Aurora_Available = {
            ["Aurora Totem"] = {
                ["Enabled"] = true,
                Level_Requirement = 250,
                Money_Requirement = 2750000,
                Rod_Requirement = "Great Rod of Oscar",
            },
            ["Sundial Totem"] = {
                ["Enabled"] = true,
                Level_Requirement = 250,
                Money_Requirement = 2750000,
                Rod_Requirement = "Great Rod of Oscar",
            },
        },
        Enchant = {
            ["Enabled"] = false,
            Money_Requirement = 75000,
            Relic_Data = {},
            Select_Enchant = {
                ["Great Rod of Oscar"] = {
                    "Clever",
                },
            },
        },
        Default_Data = {
            Necessity_Rod = {
                ["Carbon Rod"] = false,
                ["Rapid Rod"] = false,
                ["Treasure Rod"] = true,
                ["Carrot Rod"] = false,
                ["Destiny Rod"] = false,
                ["Luminescent Oath"] = false, -- // Req level 500
                ["Great Rod of Oscar"] = true,
                ["Ethereal Prism Rod"] = true,
            },
            Equipment_List = {
                "Original No-Life Rod",
                "Treasure Rod",
                "Great Rod of Oscar",
                "Tryhard Rod",
            },
        },
    }
