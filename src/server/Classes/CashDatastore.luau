--[[
    Script: DatastoreSystem
    By: Sean_Developer
    Last Updated : 28/05/25 12:37
    Managed by Rojo with Selene linter, and formatted with StyLua
]]

local datastoreScript = {}

local DTS = game:GetService("DataStoreService")
local datastore = DTS:GetOrderedDataStore("__DEV-TEMP_DATASTORE")

function datastoreScript.playerJoined(plr)
	local leaderstats = Instance.new("Folder")
	leaderstats.Parent = plr
	leaderstats.Name = "leaderstats"

	local cash = Instance.new("IntValue")
	cash.Parent = leaderstats
	cash.Name = "Cash"

	local data
	local success, _err = pcall(function()
		data = datastore:GetAsync(plr.UserId)
	end)

	if success and data then
		print("Player had data - Loading")
		cash.Value = data
	else
		warn("Player had no data. Initalizing with 10.")
		cash.Value = 10
	end
end

function datastoreScript.serverClosed()
	for _, player in pairs(game.Players:GetPlayers()) do
		datastoreScript.saveData(player) -- Save everyone's data before the server closes.
	end
end

function datastoreScript.saveData(plr)
	local dataToSave = plr.leaderstats.Cash.Value

	local success, err = pcall(function()
		datastore:SetAsync(plr.UserId, dataToSave)
	end)

	if success then
		print("Data has been saved successfully.")
	else
		warn("Data failed to save with the following information: ", err)
	end
end

function datastoreScript.leaderboard()
	local Leaderboard = game.Workspace.Leaderboard
	local RankTemplate = Leaderboard.SurfaceGui.Main.Template
	RankTemplate.Parent = nil

	local RefreshTime = 60
	local NumTopPlayers = 100

	for Rank = 1, NumTopPlayers do
		local NewRank = RankTemplate:Clone()
		NewRank.Parent = Leaderboard.SurfaceGui.Main

		NewRank.Name = Rank
	end

	while true do
		local Ascending = false
		local NumPlayers = NumTopPlayers

		local Pages = datastore:GetSortedAsync(Ascending, NumPlayers)
		local TopPlayers = Pages:GetCurrentPage()

		for Rank, PlayerData in ipairs(TopPlayers) do
			local UserId = PlayerData.key
			local Name
			if tonumber(UserId) < 0 then
				Name = UserId
			else
				Name = game.Players:GetNameFromUserIdAsync(UserId)
			end
			local Cash = PlayerData.value

			local LeaderboardRank = Leaderboard.SurfaceGui.Main[Rank]
			LeaderboardRank.Rank.Text = Rank
			LeaderboardRank.Player.Text = Name
			LeaderboardRank.Cash.Text = Cash
		end
		task.wait(RefreshTime)
	end
end

return datastoreScript
