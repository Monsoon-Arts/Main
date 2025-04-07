-- By Distracted Games

local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterPlayer = game:GetService("StarterPlayer")
local StarterPlayerScripts = StarterPlayer.StarterPlayerScripts

local isServer = RunService:IsServer()
local rootDirectory = if isServer then ServerScriptService else StarterPlayerScripts
local moduleDirectory: ServerScriptService | StarterPlayerScripts = if isServer
	then rootDirectory
	else rootDirectory:WaitForChild("Controllers")

local ATTEMPT_LIMIT = 3 -- How many attempts to initialize/initiate a script
local RETRY_DELAY = 1 -- Time betwqeen reattempting to initialize/initiate

local success: boolean, result -- pcall reesults for use outside of functions

local DEBUG = false -- When set to true, will print debug messages to console

----------------------
-- Functions
----------------------

-- Require the given `ModuleScript` and attempt to call it's Initialize function.
local function initializeModule(moduleScript: ModuleScript)
	local attemptIndex = 0
	-- Require the given ModuleScript
	local import = require(moduleScript)
	-- Check if the moduel is jsut returning a function
	if type(import) == "function" then
		if DEBUG then
			print(`Module: {moduleScript.Name} is a function.`)
		end
		return
	end

	-- Reference the `Initialize()` function of the ModuleScript
	local initialize = import.Initialize
	if not initialize then
		if DEBUG then
			print(`Module: {moduleScript.Name} has no Initialize fuction.`)
		end
		return
	end

	repeat
		success, result = pcall(initialize)
		attemptIndex += 1
		if not success then
			task.wait(RETRY_DELAY)
		end
	until success or attemptIndex >= ATTEMPT_LIMIT

	if not success then
		warn(`Module: {moduleScript.Name} \n {result}`)
	end

	return success, result
end

local function initiateModule(moduleScript: ModuleScript)
	local attemptIndex = 0
	-- Require the passed ModuleScript
	local import = require(moduleScript)
	-- Check if the moduel is jsut returning a function
	if type(import) == "function" then
		if DEBUG then
			print(`Module: {moduleScript.Name} is a function.`)
		end
		return
	end

	-- Reference the `Initiate()` function of the ModuleScript
	local initiate = import.Initiate
	if not initiate then
		if DEBUG then
			print(`Module: {moduleScript.Name} has no Initiate fuction.`)
		end
		return
	end

	repeat
		success, result = pcall(initiate)
		attemptIndex += 1
		if not success then
			task.wait(RETRY_DELAY)
		end
	until success or attemptIndex >= ATTEMPT_LIMIT

	if not success then
		warn(`Module: {moduleScript.Name} \n {result}`)
	end

	return success, result
end

----------------------
-- Main
----------------------

-- Loop through each ModuleScript, loading it into the system, then look for and
-- call any Initialize functions. After initializing, loop through a second time
-- looking for and calling any Initiate functions.
return function()
	for _, child in moduleDirectory:GetDescendants() do
		if not child:IsA("ModuleScript") then
			continue
		end
		if DEBUG then
			print(`Initializing Module: {child.Name}`)
		end

		task.spawn(initializeModule, child)
		if not success then
			continue
		end
		if DEBUG and success then
			print(`Module: {child.Name} Initialized!`)
		end

		-- reset pcall results
		success, result = nil, nil
		task.wait()
	end

	for _, child in moduleDirectory:GetDescendants() do
		if not child:IsA("ModuleScript") then
			continue
		end
		if DEBUG then
			print(`Initiating Module: {child.Name}`)
		end

		task.spawn(initiateModule, child)
		if not success then
			continue
		end
		if DEBUG and success then
			print(`Module: {child.Name} Initiated!`)
		end

		-- reset pcall results
		success, result = nil, nil
		task.wait()
	end
end
