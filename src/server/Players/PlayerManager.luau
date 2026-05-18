local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Events = ReplicatedStorage:WaitForChild("Events")
local Functions = ReplicatedStorage:WaitForChild("Functions")

local PlayerHandler = require(ServerScriptService.Server.ServerTypes.PlayerHandler)
local Types = require(ReplicatedStorage.Shared.SharedTypes.PlayerDataTypes)

local PlayerManager = {}

PlayerManager.PlayerHandlerList = {}
PlayerManager.PlayerData_Datastore = DataStoreService:GetDataStore("PlayerData")

--#region DataStoreConfig
PlayerManager.MaxSaveAttempts = 3

--#endregion DataStoreConfig

--#region Events & Functions
local AttributeAllocateRequest = Functions.AttributeAllocateRequest :: RemoteFunction
local StatAllocateRequest = Functions.StatAllocateRequest :: RemoteFunction
--#endregion

function PlayerManager.Init()
	Players.PlayerAdded:Connect(PlayerManager.OnPlayerAdded)
	Players.PlayerRemoving:Connect(PlayerManager.OnPlayerRemoving)

	AttributeAllocateRequest.OnServerInvoke = PlayerManager.OnPlayerAttributeAllocateRequest
	StatAllocateRequest.OnServerInvoke = PlayerManager.OnPlayerStatAllocateRequest
end

function PlayerManager.OnPlayerAdded(player: Player)
	--handle data loading
	local _, data = pcall(function()
		return PlayerManager.PlayerData_Datastore:GetAsync(player.UserId)
	end)
	local p_handler = PlayerHandler.New(player, if not RunService:IsStudio() then data else {})
	PlayerManager.PlayerHandlerList[player.UserId] = p_handler
end

function PlayerManager.OnPlayerRemoving(player: Player)
	if RunService:IsStudio() then
		return
	end

	--handle data saving
	local success, err = nil
	local curr_attempts = 0

	while not success and curr_attempts < PlayerManager.MaxSaveAttempts do
		success, err = pcall(function()
			PlayerManager.PlayerData_Datastore:SetAsync(
				player.UserId,
				PlayerManager.PlayerHandlerList[player.UserId]:RetrieveSaveData()
			)
		end)
		if not success then
			warn(err)
		end
		curr_attempts += 1
	end

	PlayerManager.PlayerHandlerList[player.UserId] = nil
end

function PlayerManager.OnPlayerAttributeAllocateRequest(player: Player, attr_type: Types.ATTRIBUTE)
	return PlayerManager.PlayerHandlerList[player.UserId]:TryAllocateAttributePoint(attr_type)
end

function PlayerManager.OnPlayerStatAllocateRequest(player: Player, stat_type: Types.STAT)
	return PlayerManager.PlayerHandlerList[player.UserId]:TryAllocateStatPoint(stat_type)
end

return PlayerManager
