-- By Distracted Games

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataTemplate = require(ReplicatedStorage.PlayerData.Template)
type PlayerData = DataTemplate.PlayerData

local events = ReplicatedStorage.Events

local isDataLoaded = false
local playerData: PlayerData
-- Get the player's data from the server-side player data manager.
local function loadData()
	if isDataLoaded then
		return
	end

	local success, err
	local attemptIndex, attemptlimit, retryDelay = 0, 10, 1
	repeat
		success, err = pcall(function()
			playerData = events.Player.GetAllData:InvokeServer()
		end)
		attemptIndex += 1
		task.wait(retryDelay)
	until success or attemptIndex == attemptlimit

	if not success then
		error(`Unable to retrieve playerData after {attemptIndex} tries:\n{err}`)
	end

	isDataLoaded = true
end

loadData()

local StateManager = {}

function StateManager.GetData(): PlayerData
	while not isDataLoaded do
		task.wait(0.5)
	end
	return playerData
end

----------------------
-- Events
----------------------

events.Player.LevelUp.OnClientEvent:Connect(function(char: Model, level: number, baseHealth: number)
	if Players:GetPlayerFromCharacter(char) == Players.LocalPlayer then
		playerData.CharacterLevel = level
		playerData.BaseHealth = baseHealth
	end

	local levelUpEffect: Model = ReplicatedStorage.Effects.LevelUp:Clone()
	levelUpEffect:PivotTo(char.PrimaryPart.CFrame * CFrame.Angles(math.rad(90), 0, 0))
	-- Weld effect to character to move with them.
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = levelUpEffect.PrimaryPart
	weld.Part1 = char.PrimaryPart
	weld.Parent = levelUpEffect
	-- Add effect to Debris.
	levelUpEffect.Parent = workspace.Debris
	Debris:AddItem(levelUpEffect, 1)
end)

events.Player.SkillLevelUp.OnClientEvent:Connect(function(skill: string, level: number)
	if skill == "OneHanded" then
		playerData.OneHandedSkillLevel = level
	elseif skill == "TwoHanded" then
		playerData.TwoHandedSkillLevel = level
	end
end)

events.Items.GiveWeapon.OnClientEvent:Connect(function(weapon)
	playerData.Items.Weapons[weapon.Name] = weapon
	-- print(`{weapon.Name} given!`)
end)

events.Items.DeleteWeapon.OnClientEvent:Connect(function(weaponName: string)
	playerData.Items.Weapon[weaponName] = nil
	-- print(`{weaponName} removed!`)
end)

events.Items.GiveArmor.OnClientEvent:Connect(function(armor)
	playerData.Items.Armor[armor.Name] = armor
	-- print(`{armor.Name} given!`)
end)

events.Items.DeleteArmor.OnClientEvent:Connect(function(armorName: string)
	playerData.Items.Weapon[armorName] = nil
	-- print(`{armorName} removed!`)
end)

events.Items.GiveCosmetic.OnClientEvent:Connect(function(cosmetic)
	playerData.Items.Cosmetics[cosmetic.Name] = cosmetic
	-- print(`{cosmetic.Name} given!`)
end)

events.Items.DeleteCosmetic.OnClientEvent:Connect(function(cosmeticName)
	playerData.Items.Cosmetics[cosmeticName] = nil
	-- print(`{cosmeticName} removed!`)
end)

events.Items.Equip.OnClientEvent:Connect(function(itemName: string, slot: string, category: string, twoHand: boolean?)
	if twoHand then
		playerData.Equipped.HandLeft, playerData.Equipped.HandRight = itemName, itemName
	else
		playerData.Equipped[slot] = itemName
	end

	if category == "OneHanded" or category == "TwoHanded" then
		playerData.Items.Weapons[itemName].Equipped = true
	elseif category == "Cosmetic" or category == "Consumable" then
		playerData.Items[`{category}s`][itemName].Equipped = true
	else
		playerData.Items[category][itemName].Equipped = true
	end
end)

events.Items.Unequip.OnClientEvent:Connect(function(itemName: string, slot: string, category: string, twoHand: boolean?)
	if twoHand then
		playerData.Equipped.HandLeft, playerData.Equipped.HandRight = nil, nil
	else
		playerData.Equipped[slot] = nil
	end

	if category == "OneHanded" or category == "TwoHanded" then
		playerData.Items.Weapons[itemName].Equipped = false
	elseif category == "Cosmetic" or category == "Consumable" then
		playerData.Items[`{category}s`][itemName].Equipped = false
	else
		playerData.Items[category][itemName].Equipped = false
	end
end)

events.Skills.UnlockSkill.OnClientEvent:Connect(function(weaponCategory: string, skill: table)
	playerData.Skills[weaponCategory][skill.Name] = skill
end)

events.Combat.SkillXp.OnClientEvent:Connect(function(skill: string, xp: number)
	if skill == "OneHanded" then
		playerData.OneHandedSkillXp = xp
	elseif skill == "TwoHanded" then
		playerData.TwoHandedSkillXp = xp
	end
end)

-- Used only for testing while respawns active.
events.Player.CharacterLoaded.OnClientEvent:Connect(function()
	task.wait(0.1)
	for _, ownedItems in playerData.Items do
		for _, item in ownedItems do
			item.Equipped = false
		end
	end
end)

return StateManager
