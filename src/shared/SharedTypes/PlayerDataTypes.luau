export type ProgressionData = {
	gold: number,
	level: number,
	experience: number,
}

export type ATTRIBUTE = "CONS" | "STR" | "INT" | "DEX" | "RES"
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
	| "HEAL AMP"

export type Stats = {
	HP: number,
	ATK: number,
	DEF: number,
	SPL: number,
	SDF: number,
	ASPD: number,
	MSPD: number,
	CSPD: number,
	CRT: number,
	CDM: number,
}

export type Attributes = {
	CONS: number,
	STR: number,
	INT: number,
	DEX: number,
	RES: number,
}
return {}
