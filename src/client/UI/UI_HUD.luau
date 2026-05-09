local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerGui = Players.LocalPlayer.PlayerGui
local HUD = PlayerGui:WaitForChild("HUD")

local Types = require(ReplicatedStorage.Shared.SharedTypes.PlayerDataTypes)

local UI_HUD = {}

local level_label = HUD.PlayerBar.ViewportFrame.Level
local coins_label = HUD.PlayerBar.Coins.Value
local hp_bar = HUD.PlayerBar.HPBar

function UI_HUD.OnProgressionDataUpdated(data: Types.ProgressionData)
	level_label.Text = data.level
	coins_label.Text = data.gold
end

function UI_HUD.OnStatsUpdated(base_stats: Types.Stats, curr_stats: Types.Stats)
	local hp_ratio = curr_stats.HP / base_stats.HP
	print(hp_ratio)
	hp_bar.Value.Size = UDim2.fromScale(hp_ratio, 1)
end

return UI_HUD
