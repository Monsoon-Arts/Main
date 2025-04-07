
local Template = {
	CharacterLevel = 1,
	Xp = 0,
	ReqXp = 1000,
	Col = 0,
	Health = 100,
	BaseHealth = 100,
	HealthBuff = 0,
	Attack = 0,
	Defense = 0,
	Equipped = {
		HandLeft = nil,
		HandRight = nil,
		Torso = nil,
		Legs = nil,
		Consumable = nil,
		Cosmetic = nil,
	},
	Hotbar = {
		[1] = nil,
		[2] = nil,
		[3] = nil,
		[4] = nil,
		[5] = nil,
	},
	Items = {
		Armor = {},
		Consumables = {},
		Cosmetics = {},
		OtherItems = {},
		QuestItems = {},
		Weapons = {},
	},
	New = true,
	OneHandedSkillLevel = 0,
	OneHandedSkillXp = 0,
	Skills = {
		OneHandedSword = {},
		TwoHandedSword = {},
	},
	TwoHandedSkillLevel = 0,
	TwoHandedSkillXp = 0,
	WalkSpeed = 15,
	ColorCursor = "Green",
	Location = {
		attribute = "TownOfBeginnings",
		coordinate = Vector3.new(2057.61, 729.952, -2374.985),
	}
}

export type PlayerData = typeof(Template)

return Template
