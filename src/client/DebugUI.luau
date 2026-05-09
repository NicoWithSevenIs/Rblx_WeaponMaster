local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DebugUI = {}

local PlayerGui = Players.LocalPlayer.PlayerGui

PlayerGui:WaitForChild("DebugGUI").DisplayData.Activated:Connect(function()
	local data = ReplicatedStorage.Functions.Debug:InvokeServer("Display Player Data")
	print(data)
end)

return DebugUI
