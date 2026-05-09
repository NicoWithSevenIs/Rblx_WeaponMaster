local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Scripts = LocalPlayer.PlayerScripts

local Events = ReplicatedStorage:WaitForChild("Events")

--#region Script References
local Types = require(ReplicatedStorage.Shared.SharedTypes.PlayerDataTypes)

local UI = Scripts.Client.UI
local UI_HUD = require(UI.UI_HUD)
local UI_StatViewScreen = require(UI.UI_StatViewScreen)

--#endregion Script Reference

local DataReceiver = {}

Events.OnProgressionDataUpdated.OnClientEvent:Connect(function(data: Types.ProgressionData)
	UI_HUD.OnProgressionDataUpdated(data)
	UI_StatViewScreen.OnProgressionDataUpdated(data)
end)

Events.OnStatsUpdated.OnClientEvent:Connect(function(base_stats: Types.Stats, curr_stats: Types.Stats)
	UI_HUD.OnStatsUpdated(base_stats, curr_stats)
	UI_StatViewScreen.OnStatsUpdated(base_stats, curr_stats)
end)

return DataReceiver
