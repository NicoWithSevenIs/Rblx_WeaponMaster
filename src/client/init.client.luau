local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Scripts = LocalPlayer.PlayerScripts

require(Scripts.Client.TestUI)
print("Hello world, from client!")
