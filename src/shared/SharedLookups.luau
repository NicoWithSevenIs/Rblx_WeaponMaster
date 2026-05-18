local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Shared.SharedTypes.PlayerDataTypes)

local lookups = {}

function lookups.StatAllocCosts(): { [Types.STAT]: Types.Attributes }
	return {
		["HP"] = {
			VITL = 2,
			MGHT = 0,
			ACTY = 0,
			RESL = 0,
			DEXT = 0,
		},
		["ATK"] = {
			VITL = 0,
			MGHT = 2,
			ACTY = 0,
			RESL = 0,
			DEXT = 0,
		},
		["DEF"] = {
			VITL = 0,
			MGHT = 1,
			ACTY = 0,
			RESL = 1,
			DEXT = 0,
		},
		["SPL_ATK"] = {
			VITL = 0,
			MGHT = 0,
			ACTY = 2,
			RESL = 0,
			DEXT = 0,
		},
		["SPL_DEF"] = {
			VITL = 0,
			MGHT = 0,
			ACTY = 1,
			RESL = 1,
			DEXT = 0,
		},
		["ATK_SPD"] = {
			VITL = 0,
			MGHT = 0,
			ACTY = 0,
			RESL = 0,
			DEXT = 2,
		},
		["MOVE_SPD"] = {
			VITL = 0,
			MGHT = 0,
			ACTY = 0,
			RESL = 0,
			DEXT = 2,
		},
		["CDR"] = {
			VITL = 0,
			MGHT = 0,
			ACTY = 1,
			RESL = 0,
			DEXT = 1,
		},
		["LUCK"] = {
			VITL = 0,
			MGHT = 1,
			ACTY = 0,
			RESL = 0,
			DEXT = 1,
		},
		["VAMP"] = {
			VITL = 1,
			MGHT = 0,
			ACTY = 0,
			RESL = 1,
			DEXT = 0,
		},
		["ATK_RANGE"] = {
			VITL = 0,
			MGHT = 0,
			ACTY = 0,
			RESL = 1,
			DEXT = 1,
		},
		["HEAL_AMP"] = {
			VITL = 1,
			MGHT = 0,
			ACTY = 0,
			RESL = 1,
			DEXT = 0,
		},
	}
end

return lookups
