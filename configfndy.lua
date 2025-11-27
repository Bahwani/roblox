_G.FishItConfig = _G.FishItConfig or {
    ["Fishing"] = {
        ["Auto Perfect"] = true,
    },
    ["Auto Trade"] = {
        ["Enabled"] = true,
        ["Whitelist Username"] = {"PetsSave_1"},
        ["Category Fish"] = { -- Only Select one, fill in the fish category or fish name
            "Secret",
            "Mythic",
        },
        ["Fish Name"] = {
        },
    },
    ["Farm Coin Only"] = {
        ["Enabled"] = false, -- Farm coins only [ cant buy rod, bait, enchant, weather ]
        ["Target"] = 190000,
    },
    ["Selling"] = {
        ["Auto Sell"] = true,
        ["Auto Sell Threshold"] = "Legendary",
        ["Auto Sell Every"] = 100,
    },
    ["Doing Quest"] = {
        ["Auto Ghostfinn Rod"] = true,
        ["Auto Element Rod"] = false,
        ["Allowed Sacrifice"] = {
            "Blob Shark",
            "Ghost Shark",
        },
        ["FARM_LOC_SECRET_SACRIFICE"] = "Ocean",

        ["Minimum Rod"] = "Astral Rod",
    },
    ["WebHook"] = {
        ["Link Webhook"] = "https://discord.com/api/webhooks/1297761458108633148/9m7xOS7kRZ-xfA36X6pnJ47fWritQPr0hdU_4AvzciIoacuNAwUbP3S09T5E2zNbJLTG",
        ["Auto Sending"] = true,
        ["Category"] = {"Secret"},

        ["Link Webhook Quest Complete"] = "",
    },
    ["Weather"] = {
        ["Auto Buying"] = false,
        ["Minimum Rod"] = "Astral Rod",
        ["Weather List"] = {
            "Wind",
        },
    },
    ["Event"] = {
        ["Start Farm"] = true,
        ["Minimum Rod"] = "Angler Rod",
        ["Event List"] = {
            "Megalodon Hunt",
            "Ghost Shark Hunt",
            "Shark Hunt",
        },
    },
    ["Enchant"] = {
        ["Auto Enchant"] = false,
        ["Roll Enchant"] = false, -- Roll enchant until get Leprechaun II
        ["Minimum Rod"] = "Astral Rod",
        ["Enchant List"] = {
            "Leprechaun II",
            "Mutation Hunter II",
            "Prismatic I",
        },
    },
    ["Bait List"] = {
        ["Auto Buying"] = true,
        ["Buy List"] = {
            "Midnight Bait",
            "Chroma Bait",
            "Corrupt Bait",
            "Aether Bait",
        },
    },
    ["Rod List"] = {
        ["Auto Buying"] = true,
        ["Buy List"] = {
            "Grass Rod",
            "Midnight Rod",
            "Astral Rod",
            "Ares Rod",
            "Angler Rod",
        },
        ["Location Rods"] = { -- Farm location and minimum rod to start on that location, also only 1 rod and only 1 location
            ["Fisherman Island"] = {"Starter Rod"},
            ["Kohana Volcano"] = {"Grass Rod", "Midnight Rod"},
            ["Tropical Grove"] = {"Astral Rod"},
            ["Crater Island"] = {"Element Rod", "Ghostfinn Rod", "Angler Rod", "Ares Rod"},
        },
    },

    ["ExtremeFpsBoost"] = true,
    ["UltimatePerformance"] = false,
    ["Disable3DRender"] = true,
    ["AutoRemovePlayer"] = true,

    ["AutoReconnect"] = true,
    ["HideGUI"] = true,
}
