local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local DataStoreService = game:GetService("DataStoreService")

local PlayerHandler = require(ServerScriptService.Server.ServerTypes.PlayerHandler)

local PlayerManager = {}

PlayerManager.PlayerHandlerList = {}
PlayerManager.PlayerData_Datastore = DataStoreService:GetDataStore("PlayerData")

--#region DataStoreConfig
PlayerManager.MaxSaveAttempts = 3

--#endregion DataStoreConfig

function PlayerManager.Init()
	Players.PlayerAdded:Connect(PlayerManager.OnPlayerAdded)
	Players.PlayerRemoving:Connect(PlayerManager.OnPlayerRemoving)
end

function PlayerManager.OnPlayerAdded(player: Player)
	--handle data loading
	local _, data = pcall(function()
		return PlayerManager.PlayerData_Datastore:GetAsync(player.UserId)
	end)

	local p_handler = PlayerHandler.New(player, data)
	PlayerManager.PlayerHandlerList[player.UserId] = p_handler
end

function PlayerManager.OnPlayerRemoving(player: Player)
	--handle data saving
	local success, err = nil
	local curr_attempts = 0

	while not success and curr_attempts < PlayerManager.MaxSaveAttempts do
		success, err = pcall(function()
			PlayerManager.PlayerData_Datastore:SetAsync(
				player.UserId,
				PlayerManager.PlayerHandlerList[player.UserId].save_data
			)
		end)
		if not success then
			warn(err)
		end
		curr_attempts += 1
	end

	PlayerManager.PlayerHandlerList[player.UserId] = nil
end

return PlayerManager
