local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Scripts = LocalPlayer.PlayerScripts

local UI_StatViewScreen = require(Scripts.Client.UI.UI_StatViewScreen)

UserInputService.InputEnded:Connect(function(input: InputObject, processed: boolean)
	if processed then
		return
	end
	if input.KeyCode == Enum.KeyCode.C then
		UI_StatViewScreen.SetWindowEnabled(not UI_StatViewScreen.IsVisible())
	end
end)

return {}
