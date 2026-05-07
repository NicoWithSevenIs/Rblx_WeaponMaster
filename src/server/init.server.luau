local ServerScriptService = game:GetService("ServerScriptService")
local scripts = ServerScriptService.Server

local PlayerManager = require(scripts.Players.PlayerManager)

PlayerManager.Init()
