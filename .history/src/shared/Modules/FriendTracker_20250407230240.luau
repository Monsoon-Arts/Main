-- FriendTracker ModuleScript
local FriendTracker = {}
local Players = game:GetService("Players")

-- Utility function to iterate through pages of friends
local function iterPageItems(pages)
	return coroutine.wrap(function()
		local pagenum = 1
		while true do
			for _, item in ipairs(pages:GetCurrentPage()) do
				coroutine.yield(item, pagenum)
			end
			if pages.IsFinished then
				break
			end
			pages:AdvanceToNextPageAsync()
			pagenum = pagenum + 1
		end
	end)
end

-- Function to retrieve friend statuses for a specific player
function FriendTracker:GetFriendStatuses(player)
	local friendStatuses = {
		offlineFriends = {},
		onlineFriends = {},
		inGameFriends = {},
		inCurrentGameFriends = {}
	}

	-- Get all player's friends
	local friendPages = Players:GetFriendsAsync(player.UserId)
	for item, _pageNo in iterPageItems(friendPages) do
		friendStatuses.offlineFriends[item.Username] = true
	end

	-- Get online friend statuses
	local success, result = pcall(player.GetFriendsOnline, player)
	if success then
		for _, friend in pairs(result) do
			if friend.IsOnline == false then
				friendStatuses.offlineFriends[friend.UserName] = true
			else
				friendStatuses.offlineFriends[friend.UserName] = nil

				if not friend.PlaceId then
					friendStatuses.onlineFriends[friend.UserName] = true
				else
					if friend.PlaceId ~= game.PlaceId then
						friendStatuses.inGameFriends[friend.UserName] = true
					else
						friendStatuses.inCurrentGameFriends[friend.UserName] = true
					end
				end
			end
		end
	else
		warn("Failed to get online players: " .. result)
	end

	return friendStatuses
end

return FriendTracker
