getgenv().Settings = {
	["Version Script"] = "1.04",
	["Choose Build Style"] = "Luck", -- // "DMG" 
	["Trade Mode"] = {
		["Enabled"] = false,
		["Trade Settings"] = {
			["Main Account"] = "", -- // ชื่อรหัสที่จะยัดของเข้าตัว
			["Auto Change Account When Finish Trade"] = false, -- // เปลี่ยนไอดีออโต้ หลังจากเทรดเสร็จ
		},
	},
	["Player Stats"] = {
		["+10 Main Weapon"] = true,
		["Artifact"] = {
			["Enabled"] = true,
			["Upgrade Requirement"] = {
				["Rarity"] = "Legendary",
			},
		},
		["Race Reroll"] = {
			["Enabled"] = true,
			["List Name"] = {
				"Kitsune",
                "Servant",
                "Swordblessed",
                "Warlord",
			},
		},
		["Clan Reroll"] = {
			["Enabled"] = true,
			["List Name"] = "Pride",
		},
		["Passive Reroll"] = {
			["Enabled"] = true,
			["List Name"] = {
				["Strongest In History"] = "Fortune Chosen",
			},
		},
		["Trait Reroll"] = {
			["Enabled"] = true,
			["List Name"] = {
				"Celestial",
				"Cataclysm",
				"Singularity",
			},
		},
		["Stats Reroll"] = {
			["Enabled"] = true,
			["Requirements"] = {
				["Gryphon Sword"] = true,
				["Ichigo"] = true,
			},
			["Luck"] = { "Z", "SSS" },
		},
	},
	["Rank Quest"] = { --// ยัดเซ็ทแรงค์ก่อนเปิดไว้ก็ดี ถ้าไม่ยัดมันหาให้เองหมด Fully Rank 1-7
		["Enabled"] = true,
		["Hop Server"] = true,
		["Requirements"] = {
			["Ichigo"] = false,
			["Strongest In History"] = true,
			["Level"] = 11500,
			["Money"] = 1250000,
			["Gem"] = 5000,
		},
	},
	["Strongest In History Quest"] = { -- // มันจะหาของให้เองทุกอย่าง แต่ แนะนำ ให้ ยัดเซ็ทของไว้ดีกว่า จะเร็วขึ้นมาก
		["Enabled"] = true,
		["Hop Server"] = true,
		["Requirements"] = {
			["Level"] = 11500,
			["Money"] = 50,
			["Gem"] = 50,
		},
	},
	["Saber Alter Quest"] = { -- // มันจะหาของให้เองทุกอย่าง แต่ แนะนำ ให้ ยัดเซ็ทของไว้ดีกว่า จะเร็วขึ้นมาก
		["Enabled"] = true,
		["Hop Server"] = false,
		["Requirements"] = {
			["Level"] = 11500,
			["Money"] = 10000000,
			["Gem"] = 50000,
		},
	},
	["Ichigo Quest"] = { -- // ถ้ามันมี Boss Key หรือในเซิฟ มีเซเบอร์ เกิด มันจะไปตีให้ จน กว่าจะครบ 500 และ แลกดาบ อัตโนมัติ
		["Enabled"] = true,
		["Requirements"] = {
			["Level"] = 11500,
			["Money"] = 1000000,
			["Gem"] = 0,
		},
	},
	["Horst Manager"] = {
		["Enabled"] = false,
		["Change Account"] = {
			["Enabled"] = true,
			["Requirements"] = { -- // เงื่อนไขการสลับไอดี
				["Haki"] = true,
				["Ichigo"] = true, -- // เปิดถ้าจะทำอิจิโกะก่อน ไม่งั้นมันจะเปลี่ยนไอดีทันที
				["Saber Alter"] = false, -- // เปิดถ้าจะทำดาบใหม่นะก่อน ไม่งั้นมันจะเปลี่ยนไอดีทันที
				["Strongest In History"] = false, -- // เปิดถ้าจะทำสุคุนะก่อน ไม่งั้นมันจะเปลี่ยนไอดีทันที
				["Seventh Ascension"] = false, -- // เปิดถ้าจะทำแรงค์นะก่อน ไม่งั้นมันจะเปลี่ยนไอดีทันที Rank 7
				["Level"] = 11500,
			},
		},
		["Delay Update"] = 5, -- // Second
	},
}
