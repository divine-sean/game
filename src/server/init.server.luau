--[[
    Script: Server
    By: Sean_Developer
    Last Updated : 28/05/25 12:37
    Managed by Rojo with Selene linter, and formatted with StyLua
]]

local datastoreSystem = require(script.Classes.CashDatastore)

local players = game:GetService("Players")

function playerJoined(plr)
	datastoreSystem.playerJoined(plr)
end

function playerLeft(plr)
	datastoreSystem.saveData(plr)
end

function serverCloses()
	datastoreSystem.serverClosed()
end

players.PlayerAdded:Connect(playerJoined)
players.PlayerRemoving:Connect(playerLeft)
game:BindToClose(serverCloses)
datastoreSystem.leaderboard()
