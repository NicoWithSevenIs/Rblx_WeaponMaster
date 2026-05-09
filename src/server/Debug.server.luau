local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local PlayerManager = require(ServerScriptService.Server.Players.PlayerManager)

local task_lookup = {
	["Display Player Data"] = function(player: Player)
		return PlayerManager.PlayerHandlerList[player.UserId]
	end,
}

ReplicatedStorage.Functions.Debug.OnServerInvoke = function(player, task)
	return task_lookup[task](player)
end

task.wait(10)

for _, player in pairs(PlayerManager.PlayerHandlerList) do
	local curr = table.clone(player.current_stats)
	curr.HP -= 50
	player:SetStats(curr)
end
