local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local Types = require(ReplicatedStorage.Shared.SharedTypes.PlayerDataTypes)

local StatAllocCosts = require(ReplicatedStorage.Shared.SharedLookups).StatAllocCosts()

local PlayerHandler = {}
PlayerHandler.__index = PlayerHandler

local OnProgressionDataUpdated = Events.OnProgressionDataUpdated :: RemoteEvent
local OnStatsUpdated = Events.OnStatsUpdated
local OnBuildUpdated = Events.OnBuildUpdated

--#region constants

local sample: Types.Attributes = {
	VITL = 0,
	MGHT = 1,
	ACTY = 2,
	RESL = 3,
	DEXT = 99,
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
			level = 3,
			experience = 0,
		}
	) :: Types.ProgressionData

	self.base_stats = {} :: Types.Stats
	self.current_stats = {} :: Types.Stats
	self.total_attribute_points = Types.zero_attribs() :: Types.Attributes

	self.player_build = (
		data.player_build
		or {
			allocated_attribute_points = Types.zero_attribs(),
			stat_upgrades = Types.zero_stats(),
			unspent_attribute_points = Types.zero_attribs(),
			unspent_level_points = self.progression_data.level,
		}
	) :: Types.Player_Build

	self:_initialize_events(player)

	return self
end

function PlayerHandler:TryAllocateAttributePoint(attr_type: Types.ATTRIBUTE)
	if self.player_build.unspent_level_points > 0 then
		self.player_build.allocated_attribute_points[attr_type] += 1
		self.player_build.unspent_attribute_points[attr_type] += 1
		self.player_build.unspent_level_points -= 1
		self:UpdateBuild()
		return true
	end
	return false
end

function PlayerHandler:TryAllocateStatPoint(stat_type: Types.STAT)
	local upgrade_attr_costs = StatAllocCosts[stat_type]

	for attr_type, cost in pairs(upgrade_attr_costs) do
		local points = self.player_build.unspent_attribute_points[attr_type]
		if points < cost then
			print("not enough points")
			return false
		end
	end

	for attr_type, points in pairs(upgrade_attr_costs) do
		self.player_build.unspent_attribute_points[attr_type] -= points
	end

	self.player_build.stat_upgrades[stat_type] += 1
	self:_calculate_total_stats()
	self:UpdateBuild()
	return true
end

function PlayerHandler:RetrieveSaveData()
	return {
		progression_data = self.progression_data,
		player_build = self.player_build,
	}
end

--#region Initialization Helpers
function PlayerHandler:_calculate_total_stats()
	self.base_stats = Types.base_stats()
	self.current_stats = self.base_stats

	for stat_type, value in pairs(self.current_stats) do
		local allocated = self.player_build.stat_upgrades[stat_type]
		local multiplier = 1 + (96 * allocated) / (allocated + 64)
		value *= multiplier
		self.current_stats[stat_type] = value
	end
end

function PlayerHandler:_initialize_events()
	self.player.CharacterAdded:Connect(function(character: Model)
		self.character = character
		self:UpdateProgression()
	end)
	self.player.CharacterRemoving:Connect(function(_: Model)
		self.character = nil
	end)

	self:UpdateProgression()
end
--#endregion

--#region Event Helpers
function PlayerHandler:UpdateProgression()
	OnProgressionDataUpdated:FireClient(self.player, self.progression_data)
	self:UpdateBuild()
end

function PlayerHandler:UpdateBuild()
	OnBuildUpdated:FireClient(self.player, self.player_build)
	self:UpdateStats()
end

function PlayerHandler:UpdateStats()
	self:_calculate_total_stats()
	OnStatsUpdated:FireClient(self.player, self.base_stats, self.current_stats)
end
--#endregion

return PlayerHandler
