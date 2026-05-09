local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerGui = Players.LocalPlayer.PlayerGui

local Types = require(ReplicatedStorage.Shared.SharedTypes.PlayerDataTypes)

local UI_StatViewScreen = {}

local Stats = PlayerGui:WaitForChild("Stats")

--#region UI References
local CloseButton = Stats.CloseFrame.Close

local Attributes = Stats.MainPanel.Attributes
local StatList = Stats.MainPanel.StatList
local CostIndicator = Stats.MainPanel.CostIndicator

--#endregion UI References

function UI_StatViewScreen.OnProgressionDataUpdated(data: Types.ProgressionData) end

function UI_StatViewScreen.OnStatsUpdated(base_stats: Types.Stats, curr_stats: Types.Stats) end

--create a centralized ui invoker
function UI_StatViewScreen.SetWindowEnabled(value: boolean)
	Stats.MainPanel.Visible = value
	Stats.CloseFrame.Visible = value
end

function UI_StatViewScreen.Visible()
	return Stats.MainPanel.Visible
end

function UI_StatViewScreen._init()
	CostIndicator.Visible = false
	CloseButton.Activated:Connect(function()
		UI_StatViewScreen.SetWindowEnabled(false)
	end)
	UI_StatViewScreen.SetWindowEnabled(false)
end

UI_StatViewScreen._init()

return UI_StatViewScreen
