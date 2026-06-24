_G.GAGConfig = _G.GAGConfig or {
    ["Harvest"] = {
        ["Auto Harvest"]  = true,             -- true / false  (false = never harvest/sell)
        ["Sell At"]       = 95,               -- number
        ["Sell Every"]    = 20,               -- seconds (0 = off)
        ["Only Harvest"]  = {},               -- e.g. { "Watermelon", "Apple" }
        ["Don't Harvest"] = {},               -- e.g. { "Carrot", "Tomato" }
    },
    ["Planting"] = {
        ["Auto Plant"]  = true,               -- true / false  (false = never buy/plant; also stops expand/replace)
        ["Plant Plan"]  = {},                 -- e.g. { Apple = 50, ["Dragon Fruit"] = 20 }  (keep N planted, then auto-fill)
        ["Only Plant"]  = {},                 -- e.g. { "Bamboo", "Apple" }  (plant ONLY these)
        ["Layout"]      = "compact",          -- "compact" / "spread"
        ["Don't Plant"] = { "Rainbow", "Gold", "Dragon's Breath", "Moon Bloom", "Venom Spitter" },                 -- e.g. { "Carrot", "Green Bean" }
        ["Don't Buy"]   = {},                 -- e.g. { "Mango", "Coconut" }
        ["Keep Seeds"]  = {                   -- e.g. { ["Moon Bloom"] = 5, Gold = 15 }  (keep N UNPLANTED)
            ["Dragon's Breath"] = 5, ["Moon Bloom"] = 5, ["Venom Spitter"] = 5,
            ["Gold"] = 15, ["Rainbow"] = 5,
        },
    },
    ["Money"] = {
        ["Keep Cash"]          = 15000,    -- always keep at least this much money
        ["Auto Expand Plot"]   = true,     -- buy plot expansions automatically
        ["Max Expansions"]     = 3,        -- cap how many expansions to auto-BUY this run. 0 = no limit; default 3 = stop after 3 (raise for a bigger plot)
        ["Expand If Over"]     = 1500000,  -- only spend on an expansion when your cash is above this
        ["Auto Replace Plants"] = true,    -- when the plot is full, dig up low-value plants and plant better ones
    },
    ["Never Sell"] = {                        -- protect fruit from being sold
        ["By Mutation"] = {},                 -- e.g. { "Rainbow", "Gold" }
        ["By Fruit"]    = {},                 -- e.g. { "Dragon Fruit" }
        ["Exact"]       = {},                 -- e.g. { { fruit = "Carrot", mut = "Gold" } }
    },
    ["Pets"] = {
        ["Buy"]            = { "Unicorn", "Raccoon" },   -- list = tame UNLIMITED; OR caps { Robin = 6, Deer = 6 } = stop once you OWN N of that species; mix ok { "Unicorn", Deer = 6 }
        ["Equip"]          = { Deer = 6 },    -- e.g. { Deer = 4, Unicorn = 1 }  (name = how many)
        ["Auto Buy Slots"] = true,            -- true / false
        ["Max Pet Slots"]  = 3,               -- number 3..6
    },
    ["Gear"] = {
        ["Auto Buy"]             = true,            -- true / false
        ["Keep Cash"]            = 15000,           -- number
        ["Sprinkler Coverage"]   = "concentrate",   -- "concentrate" / "value" / "spread"
        ["Place Sprinklers"]     = { ["best"] = 4 },          -- e.g. { ["best"] = 4 } or { ["Rare Sprinkler"] = 2 }
        ["Best Sprinkler Up To"] = "Rare Sprinkler",          -- "Common/Uncommon/Rare/Super/Legendary Sprinkler"
        ["Keep Gear"]            = { ["Supersize Mushroom"] = 1 },   -- e.g. { ["Trowel"] = 1 }  (buy & hold N)
        ["Buy Gear"]             = { "Super Sprinkler", "Super Watering Can", "Legendary Sprinkler" },   -- e.g. { "Trowel" }  (buy & keep, never placed)
    },
    ["Event Seeds"] = {
        ["Auto Claim"] = true,       -- automatically grab seed packs that drop during events
    },
    ["Mail"] = {
        ["Auto Claim"] = true,                -- true / false
        ["Send To"]    = "voidisthebest79",                  -- username to funnel items to ("" = off)
        ["Send"]       = {                    -- e.g. { "Gold", "Deer", { Item = "Deer", Count = 5 } }  (equipped pets never sent)
            "Moon Bloom", "Dragon's Breath", "Gold", "Rainbow", "Venom Spitter",
            "Unicorn", "Raccoon",
            "Super Sprinkler", "Legendary Sprinkler", "Super Watering Can",
        },
    },
    ["Misc"] = {
        ["Auto Return To Garden"] = true,     -- true / false
        ["Show Stats"]            = true,     -- true / false
        ["Smart Travel"]          = true,     -- true / false
        ["Auto Daily Deal"]       = true,     -- true / false
        ["Walk Speed"]            = 35,       -- number 16..35  (travel speed; 30 = stable. Lower toward 25 if Fast Travel ever snaps you back)
        ["Fast Travel"]           = false,    -- true / false  (on = noclip-SLIDE travel: same speed at ANY fps; falls back to walking if yanked. off = plain walking)
    },
    ["Performance"] = {
        ["FPS Cap"]              = 0,        -- number (0 = uncapped; also the farm's logic/movement rate)
        ["Low Graphics"]         = true,      -- true / false
        ["Remove Other Gardens"] = true,      -- true / false  (needs Low Graphics)
        ["Hide Crop Visuals"]    = true,      -- true / false  (hide your own plants; they still grow & harvest)
    },
    ["Debug"] = {
        ["Log To File"] = false,   -- true / false  (writes GAG_LOG_<name>.txt — a timestamped log of what the farm did + WHY it skipped something)
        ["Console"]     = true,   -- true / false  (also print log lines to the executor console). Or a list to filter, e.g. { "REPLACE", "ERROR" }
    },
}
