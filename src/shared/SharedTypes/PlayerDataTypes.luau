export type ProgressionData = {
	gold: number,
	level: number,
	experience: number,
}

export type ATTRIBUTE = "VITL" | "MGHT" | "ACTY" | "RESL" | "DEXT"
export type STAT =
	"HP"
	| "ATK"
	| "DEF"
	| "SPL_ATK"
	| "SPL_DEF"
	| "ATK_SPD"
	| "MOVE_SPD"
	| "CDR"
	| "LUCK"
	| "VAMP"
	| "ATK_RANGE"
	| "HEAL_AMP"

export type Stats = {
	HP: number,
	ATK: number,
	DEF: number,
	SPL_ATK: number,
	SPL_DEF: number,
	ATK_SPD: number,
	MOVE_SPD: number,
	CDR: number,
	LUCK: number,
	VAMP: number,
	ATK_RANGE: number,
	HEAL_AMP: number,
}

export type Attributes = {
	VITL: number,
	MGHT: number,
	ACTY: number,
	RESL: number,
	DEXT: number,
}

export type Player_Build = {
	allocated_attribute_points: Attributes,
	stat_upgrades: Stats,
	unspent_attribute_points: Attributes,
	unspent_level_points: number,
}

local constants = {}

constants.base_stats = function(): Stats
	return {
		HP = 100,
		ATK = 10,
		DEF = 20,
		SPL_ATK = 0,
		SPL_DEF = 20,
		ATK_SPD = 0.625,
		MOVE_SPD = 16,
		CDR = 0,
		LUCK = 0,
		VAMP = 0,
		ATK_RANGE = 3,
		HEAL_AMP = 0,
	} :: Stats
end

constants.zero_stats = function(): Stats
	return {
		HP = 0,
		ATK = 0,
		DEF = 0,
		SPL_ATK = 0,
		SPL_DEF = 0,
		ATK_SPD = 0,
		MOVE_SPD = 0,
		CDR = 0,
		LUCK = 0,
		VAMP = 0,
		ATK_RANGE = 0,
		HEAL_AMP = 0,
	} :: Stats
end

constants.zero_attribs = function(): Attributes
	return {
		VITL = 0,
		MGHT = 0,
		ACTY = 0,
		RESL = 0,
		DEXT = 0,
	}
end

return constants
