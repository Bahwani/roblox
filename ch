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
            3706.87622,
            -1127.95703,
            -1090.40344,
            -0.736613691,
            -6.83706958e-08,
            -0.676313758,
            2.38866544e-08,
            1,
            -1.27109544e-07,
            0.676313758,
            -1.09785503e-07,
            -0.736613691
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
                "Enchant Relic",
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
            ["Enabled"] = true,
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
            },
        },
    }
