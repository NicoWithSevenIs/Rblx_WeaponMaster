local PlayerHandler = {}
PlayerHandler.__index = PlayerHandler

export type player_data = {
	gold: number,
	level: number,
	experience: number,
	--equipped_gear: {},
	--weapons: {},
	--gear: {},
}

function PlayerHandler.New(player: Player, data: player_data)
	local self = setmetatable({}, PlayerHandler)

	self.character = nil
	self.id = player.UserId
	self.save_data = (
		data
		or {
			gold = 100,
			level = 1,
			experience = 0,
			--main_hand = nil,
			--off_hand = nil,
			--weapons = {},
			--equipped_gear = {}
			--gear = {},
		}
	) :: player_data

	self:_initialize_events(player)

	return self
end

function PlayerHandler:_initialize_events(player: Player)
	player.CharacterAdded:Connect(function(character: Model)
		self.character = character
	end)
	player.CharacterRemoving:Connect(function(_: Model)
		self.character = nil
	end)
end

return PlayerHandler
