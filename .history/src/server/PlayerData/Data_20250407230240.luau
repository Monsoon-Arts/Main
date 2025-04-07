local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Character = require(ServerScriptService.Character.CharacterClass)
local CharacterList = require(ServerScriptService.Character.CharacterClass.Characters)
local DataTemplate = require(ReplicatedStorage.PlayerData.Template)
local Weapons = require(ServerScriptService.Items.Weapons)
local Armor = require(ServerScriptService.Items.Armor)
local Cosmetics = require(ServerScriptService.Items.Cosmetics)
local Skills = require(ServerScriptService.Items.ItemClass.WeaponClass.SkillClass.WeaponSkills)

-- Leaderstats Keys
local keys = {}

local DEBUG = false -- setting to `true` will print debug statements to console

---------------------
-- Functions
---------------------

-- When the player leaves, server shuts down, or we otherwise need to release
-- the player's character data.
local function releaseProfile(player: Player)
	-- Datastore stuff goes here

	CharacterList[player.UserId] = nil

	if DEBUG then
		print(CharacterList)
	end
end

---------------------
-- Leaderstats
---------------------
local function createLeaderstats(player: Player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	for _, name in keys do
		local intValue = Instance.new("IntValue")
		intValue.Name = name
		intValue.Parent = leaderstats
	end
end

--------------------
-- Character Added
--------------------
local function onCharacterAdded(player: Player, character:Model, data: DataTemplate.PlayerData)
	character.Parent = workspace.PlayerCharacters
	Character.AddCharacter(player, character, data)

	repeat
		task.wait()
	until CharacterList[player.UserId].IsLoaded

	-- Add any starting equipment to new characters.
	if CharacterList[player.UserId].Data.New then
		Weapons.GiveWeapon(player, "Simple Shortsword")
		Weapons.GiveWeapon(player, "Steel Greatsword")
		-- For testing
		Armor.GiveArmor(player, "Leather Kit Torso")
		Armor.GiveArmor(player, "Leather Kit Legs")
		Armor.GiveArmor(player, "Bone Set Torso")
		Weapons.GiveWeapon(player,'Darksteel Katana')
		Armor.GiveArmor(player, "Bone Set Legs")
		Armor.GiveArmor(player, "Wolf Set Torso")
		Armor.GiveArmor(player, "Wolf Set Legs")
		Armor.GiveArmor(player, "Starlight Set Torso")
		Armor.GiveArmor(player, "Starlight Set Legs")
		Weapons.GiveWeapon(player, "Anneal Blade")
		Weapons.GiveWeapon(player, "Berserk Sword")
		Weapons.GiveWeapon(player, "Leather Sword")
		Weapons.GiveWeapon(player, "Ripper Sword")
		Weapons.GiveWeapon(player, "Kobold Greataxe")
		Weapons.GiveWeapon(player, "Starlight Greataxe")
		-- Weapons.GiveWeapon(player, "Spear")
		Weapons.GiveWeapon(player, "Rebel's Blade")
		Weapons.GiveWeapon(player, "Emerald Dagger")
		Cosmetics.GiveCosmetic(player, "Phantom Cloak")
		Cosmetics.GiveCosmetic(player, "Gamemaster Cloak")
		Skills.UnlockSkill(player, "OneHandedSword", "Horizontal Strike")
		CharacterList[player.UserId].Data.Skills.OneHandedSword["Horizontal Strike"].Slotted = 1
	end

	if DEBUG then
		print(CharacterList[player.UserId])
	end
end

-- When a player is first added to the game, we load their individual data and
-- create their session character.
local function loadProfile(player: Player)
	-- Datastore stuff goes here

	-- Once DataStore is established, we check if the player has existing data.
	-- If so, we would create their character data based on that, otherwise we
	-- create the character session data as the default template data.
	-- local data: DataTemplate.PlayerData = DataStore:GetAsync(`User_{player.UserId}`) or DataTemplate

	-- Setting to default template for now.
	local data: DataTemplate.PlayerData = DataTemplate

	createLeaderstats(player)

	-- Catch the player's character and place it in the PlayerCharacters folder
	-- within Workspace, then create a Caracter Class for them using their data.
	player.CharacterAdded:Connect(function(character)
		onCharacterAdded(player, character, data)
	end)

	--[[   Use this space for any overrides playerwide   ]]--


	--[[ ^ Use this space for any overrides playerwide ^ ]]--
end

---------------------
-- Main
---------------------

local Data = {}

Data.Initialize = function()
	-- In case script loads after players are in the game, loop through each player
	-- calling the LoadProfile function.
	for _, player: Player in Players:GetPlayers() do
		task.spawn(loadProfile, player)
	end

	--[[ Events ]]--
	Players.PlayerAdded:Connect(loadProfile)
	Players.PlayerRemoving:Connect(releaseProfile)
	game:BindToClose(function()
		for _, player in Players:GetPlayers() do
			releaseProfile(player)
		end
	end)
end

return Data
