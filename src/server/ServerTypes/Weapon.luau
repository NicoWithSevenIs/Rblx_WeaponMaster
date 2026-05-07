local Weapon = {}
Weapon.__index = Weapon

export type Attribute = ""
export type Class = ""

function Weapon.New()
	local self = setmetatable({}, Weapon)

	return self
end

return Weapon
