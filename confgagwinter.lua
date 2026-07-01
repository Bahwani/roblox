_G.GAGConfig = _G.GAGConfig or {
    ["Harvest"] = {
        ["Auto Harvest"]  = true,             -- true / false  (false = never harvest/sell)
        ["Sell At"]       = 95,               -- number
        ["Sell Every"]    = 20,               -- seconds (0 = off)
        ["Only Harvest"]  = {},               -- e.g. { "Watermelon", "Apple" }
        ["Don't Harvest"] = {},               -- e.g. { "Carrot", "Tomato" }
        ["Wait For Mutation"] = {},           -- e.g. { "Mushroom", "Bamboo" }  (don't harvest these until they get ANY mutation — wait for a weather event to mutate them; they're also kept from the shovel while waiting)
    },
    ["Planting"] = {
        ["Auto Plant"]  = true,               -- true / false  (false = never buy/plant; also stops expand/replace)
        ["Plant Plan"]  = {},                 -- e.g. { Apple = 50, ["Dragon Fruit"] = 20 }  (keep N planted, then auto-fill)
        ["Only Plant"]  = {},                 -- e.g. { "Bamboo", "Apple" }  (plant ONLY these)
        ["Minimum Seed"] = "",                -- e.g. "Bamboo"  (never BUY/PLANT a seed cheaper than this tier — stops it filling with Carrot/Strawberry/Blueberry junk. "" = no floor, fill with anything)
        ["Layout"]      = "compact",          -- "compact" / "spread"
        ["Don't Plant"] = { "Rainbow", "Mega", "Dragon's Breath", "Moon Bloom", "Hypno Bloom", "Strawberry", "Blueberry", "Tomato", "Apple", "Corn" },                 -- e.g. { "Cactus", "Pineapple", "Green Bean", "Banana", "Grape", "Coconut", "Mango", "Dragon Fruit", "Acorn", "Cherry" } 
        ["Don't Buy"]   = { "Strawberry", "Blueberry", "Tulip", "Tomato", "Apple", "Corn", "Cactus", "Pineapple", "Green Bean", "Banana", "Grape", "Coconut", "Mango" },                 -- e.g. { "Mango", "Coconut" }
        ["Keep Seeds"]  = {                   -- e.g. { ["Moon Bloom"] = 5, Gold = 15 }  (keep N UNPLANTED)
            ["Dragon's Breath"] = 5, ["Moon Bloom"] = 5, ["Venom Spitter"] = 5,
            ["Gold"] = 5, ["Rainbow"] = 5, ["Mega"] = 5,
        ["Plant Limit"] = 100,                  -- number (0 = off). Cap TOTAL plants at this: never plant past it, AND if you're ALREADY over (e.g. 800), shovel the lowest-tier plants DOWN to it to cut lag / stop the game force-closing. Set ~200. Never shovels mutated (Gold/Rainbow/Mega), Mega-size, Plant-Plan or never-sell plants.
        ["Never Shovel"] = {},                -- e.g. { "Dragon Fruit", "Mango" }  (extra plants the Plant Limit shovel must NEVER remove — for your high-tier crops)
        ["Shovel Up To"] = "Epic",                -- e.g. "Rare"  (a RARITY TIER — Common/Uncommon/Rare/Epic — removes ONLY that tier and below. "" = no extra ceiling. LEGENDARY/Mythic/Super are ALWAYS protected regardless. Single-harvest crops are HARVESTED when ripe, never shoveled — no wasted fruit)
        },
    },
    ["Money"] = {
        ["Keep Cash"]          = 15000,    -- always keep at least this much money
        ["Auto Expand Plot"]   = false,     -- buy plot expansions automatically
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
        ["Buy"]            = { "Raccoon" },   -- list = tame UNLIMITED; OR caps { Robin = 6, Deer = 6 } = stop once you OWN N of that species; mix ok { "Unicorn", Deer = 6 }
        ["Equip"]          = { Bunny = 6 },    -- e.g. { Deer = 4, Unicorn = 1 }  (name = how many)
        ["Auto Buy Slots"] = true,            -- true / false
        ["Max Pet Slots"]  = 4,               -- number 3..6
    },
    ["Gear"] = {
        ["Auto Buy"]             = true,            -- true / false
        ["Keep Cash"]            = 15000,           -- number
        ["Sprinkler Coverage"]   = "concentrate",   -- "concentrate" / "value" / "spread"
        ["Place Sprinklers"]     = { ["best"] = 4 },          -- e.g. { ["best"] = 4 } or { ["Rare Sprinkler"] = 2 }
        ["Best Sprinkler Up To"] = "Uncommon Sprinkler",          -- "Common/Uncommon/Rare/Super/Legendary Sprinkler"
        ["Keep Gear"]            = { ["Supersize Mushroom"] = 1 },   -- e.g. { ["Trowel"] = 1 }  (buy & hold N)
        ["Buy Gear"]             = { "Super Sprinkler", "Super Watering Can" },   -- e.g. { "Trowel" }  (buy & keep, never placed)
    },
    ["Event Seeds"] = {
        ["Auto Claim"] = true,       -- automatically grab seed packs that drop during events
    },
    ["Mail"] = {
        ["Auto Claim"] = true,                -- true / false
        ["Send To"]    = "voidisthebest79",                  -- username to funnel items to ("" = off)
        ["Send"]       = {                    -- e.g. { "Gold", "Deer", { Item = "Deer", Count = 5 } }  (equipped pets never sent) { Item = "Gold", Count = 10 },
            "Moon Bloom", "Dragon's Breath", "Rainbow", "Mega", "Hypno Bloom", { Item = "Gold", Count = 20 },
            "Unicorn", "Raccoon",
            "Super Sprinkler", "Legendary Sprinkler", "Super Watering Can",
        },
    },
    ["Misc"] = {
        ["Auto Return To Garden"] = true,     -- true / false
        ["Show Stats"]            = true,     -- true / false
        ["Show Console"]          = false,    -- true / false  (the left/right buy + shovel/plant feed panels; off by default so they don't crowd the stats on small screens — toggle live with the CONSOLE button)
        ["Smart Travel"]          = true,     -- true / false
        ["Auto Daily Deal"]       = true,     -- true / false
        ["Walk Speed"]            = 35,       -- number 16..35  (travel speed; 30 = stable. Lower toward 25 if Fast Travel ever snaps you back)
        ["Slide Speed"]           = 35,       -- number 10..150  (noclip SLIDE speed for Fast Travel excursions; default 30. Higher = faster but closer to the ~180/s anti-cheat snap ceiling)
        ["Fast Travel"]           = true,    -- true / false  (on = noclip-SLIDE travel: same speed at ANY fps; falls back to walking if yanked. off = plain walking)
        ["Teleport"]              = true,   -- true / false  (on = grab pets + event seeds by TELEPORTING straight onto each one and fast-firing — much faster than slide/walk. Separate from Fast Travel)
    },
    ["Friends"] = {
        ["Auto Accept"] = false,              -- true / false  (accept incoming friend requests from players in the server)
        ["Auto Send"]   = false,              -- true / false  (send friend requests to players in the server — some accounts must be friends to mail/trade)
    },
    ["Performance"] = {
        ["FPS Cap"]              = 30,        -- number (0 = uncapped; also the farm's logic/movement rate)
        ["Low Graphics"]         = true,      -- true / false
        ["Remove Other Gardens"] = true,      -- true / false  (needs Low Graphics)
        ["Hide Crop Visuals"]    = true,      -- true / false  (hide your own plants; they still grow & harvest)
    },
    ["Debug"] = {
        ["Log To File"] = false,   -- true / false  (writes GAG_LOG_<name>.txt — a timestamped log of what the farm did + WHY it skipped something)
        ["Console"]     = false,   -- true / false  (also print log lines to the executor console). Or a list to filter, e.g. { "REPLACE", "ERROR" }
    },
}
