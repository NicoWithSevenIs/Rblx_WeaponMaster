local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local Types = require(ReplicatedStorage.Shared.SharedTypes.PlayerDataTypes)

local PlayerHandler = {}
PlayerHandler.__index = PlayerHandler

local OnProgressionDataUpdated = Events.OnProgressionDataUpdated :: RemoteEvent
local OnStatsUpdated = Events.OnStatsUpdated

--#region constants

local base_stats: Types.Stats = {
	HP = 100,
	ATK = 10,
	DEF = 15,
	SPL = 10,
	SDF = 15,
	ASPD = 0.625,
	MSPD = 16,
	CSPD = 0,
	CRT = 0.05,
	CDM = 1.5,
}

--#endregion

function PlayerHandler.New(player: Player, data)
	local self = setmetatable({}, PlayerHandler)

	self.character = nil
	self.id = player.UserId
	self.player = player

	self.progression_data = (
		data.progression or {
			gold = 100,
			level = 1,
			experience = 0,
		}
	) :: Types.ProgressionData

	self.base_stats = {} :: Types.Stats
	self.current_stats = {} :: Types.Stats

	self:_calculate_total_stats()
	self:_initialize_events(player)

	return self
end

function PlayerHandler:_initialize_events()
	self.player.CharacterAdded:Connect(function(character: Model)
		self.character = character
		OnProgressionDataUpdated:FireClient(self.player, self.progression_data)
		OnStatsUpdated:FireClient(self.player, self.base_stats, self.current_stats)
	end)
	self.player.CharacterRemoving:Connect(function(_: Model)
		self.character = nil
	end)

	OnProgressionDataUpdated:FireClient(self.player, self.progression_data)
	OnStatsUpdated:FireClient(self.player, self.base_stats, self.current_stats)
end

function PlayerHandler:SetStats(stats: Types.Stats)
	self.current_stats = stats
	OnStatsUpdated:FireClient(self.player, self.base_stats, self.current_stats)
end

function PlayerHandler:_calculate_total_stats()
	self.base_stats = base_stats
	self.current_stats = self.base_stats
end

return PlayerHandler
