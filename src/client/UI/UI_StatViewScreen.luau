local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerGui = Players.LocalPlayer.PlayerGui

local Types = require(ReplicatedStorage.Shared.SharedTypes.PlayerDataTypes)

local UI_StatViewScreen = {}

local Stats = PlayerGui:WaitForChild("Stats")
local Functions = ReplicatedStorage:WaitForChild("Functions")

--#region UI References
local CloseButton = Stats.CloseFrame.Close

local Attributes = Stats.MainPanel.Attributes
local StatList = Stats.MainPanel.StatList
local CostIndicator = Stats.CostIndicator :: ImageLabel

local AttributeCostList = CostIndicator.Body.AttributeCostList :: Frame
local CostUILookup: { [Types.ATTRIBUTE]: Frame } = {
	["VITL"] = AttributeCostList.VITL,
	["MGHT"] = AttributeCostList.MGHT,
	["ACTY"] = AttributeCostList.ACTY,
	["RESL"] = AttributeCostList.RESL,
	["DEXT"] = AttributeCostList.DEXT,
}

--#endregion UI References

--#region Events & Functions
local AttributeAllocateRequest = Functions.AttributeAllocateRequest :: RemoteFunction
local StatAllocateRequest = Functions.StatAllocateRequest :: RemoteFunction
--#endregion

local stat_lookup = require(ReplicatedStorage.Shared.SharedLookups).StatAllocCosts()

local TextFormatCallbacks = {
	["Whole"] = function(n: number): string
		return `{math.round(n)}`
	end,
	["Decimal"] = function(n: number): string
		return `{math.round(n * 100) / 100}`
	end,
	["Percentage"] = function(n: number): string
		return `{math.round(n * 100) / 100} %`
	end,
}

function UI_StatViewScreen.OnProgressionDataUpdated(data: Types.ProgressionData) end

function UI_StatViewScreen.OnStatsUpdated(base_stats: Types.Stats, curr_stats: Types.Stats)
	for _, stat_block in pairs(StatList:GetChildren()) do
		if not stat_block:IsA("GuiObject") then
			continue
		end

		local type = stat_block:GetAttribute("Stat")
		local data = stat_block.Allocating
		data.Value.Text = TextFormatCallbacks[stat_block:GetAttribute("Format")](curr_stats[type])
	end
end

local function IsPurchasable(attribute_points: Types.Attributes, upgrade_cost: Types.Attributes): boolean
	for attr_type, points in pairs(attribute_points) do
		local cost = upgrade_cost[attr_type]
		if cost > 0 and points < cost then
			return false
		end
	end
	return true
end

function UI_StatViewScreen.OnBuildUpdated(build: Types.Player_Build)
	--update ui for attributes display
	for _, attrib_display in pairs(Attributes:GetChildren()) do
		--
		if not attrib_display:IsA("GuiObject") then
			continue
		end
		--
		local a = attrib_display :: GuiObject
		local type = a:GetAttribute("AttribType") :: Types.ATTRIBUTE
		--
		local upgrade_button = attrib_display.TopBar.Allocate
		local sp_counter = attrib_display.TopBar.RemainingValue
		local attrib_points = attrib_display.TotalValue
		--
		upgrade_button.Visible = build.unspent_level_points > 0
		sp_counter.Visible = build.unspent_attribute_points[type] > 0
		attrib_points.Text = build.allocated_attribute_points[type]
		sp_counter.Text = build.unspent_attribute_points[type]
	end

	for _, stat_block in pairs(StatList:GetChildren()) do
		if not stat_block:IsA("GuiObject") then
			continue
		end

		local type = stat_block:GetAttribute("Stat")
		local data = stat_block.Allocating

		data.UpgradeCount.Text = `[ {build.stat_upgrades[type]} ]`

		local purchasable = IsPurchasable(build.unspent_attribute_points, stat_lookup[type])

		data.Allocate.Interactable = purchasable
		data.Allocate.BackgroundColor3 = if purchasable
			then Color3.fromRGB(255, 255, 255)
			else Color3.fromRGB(125, 125, 125)
	end
end

--create a centralized ui invoker
function UI_StatViewScreen.SetWindowEnabled(value: boolean)
	Stats.MainPanel.Visible = value
	Stats.CloseFrame.Visible = value
end

function UI_StatViewScreen.IsVisible()
	return Stats.MainPanel.Visible
end

function UI_StatViewScreen._init()
	--initialize windows
	CostIndicator.Visible = false
	CloseButton.Activated:Connect(function()
		UI_StatViewScreen.SetWindowEnabled(false)
	end)
	UI_StatViewScreen.SetWindowEnabled(false)

	--initialize attribute buttons
	for _, attrib_display in pairs(Attributes:GetChildren()) do
		--
		if not attrib_display:IsA("GuiObject") then
			continue
		end
		--
		local a = attrib_display.TopBar.Allocate :: GuiButton
		a.Activated:Connect(function()
			local success = AttributeAllocateRequest:InvokeServer(attrib_display:GetAttribute("AttribType"))
			print(success)
		end)
	end

	for _, stat_block in pairs(StatList:GetChildren()) do
		if not stat_block:IsA("GuiObject") then
			continue
		end

		local type = stat_block:GetAttribute("Stat")
		local data = stat_block.Allocating

		local allocate = data.Allocate :: GuiButton

		allocate.MouseEnter:Connect(function()
			local size = allocate.AbsoluteSize
			local pos = allocate.AbsolutePosition
			local offset = 5

			CostIndicator.Visible = true
			CostIndicator.Position = UDim2.fromOffset(pos.X, pos.Y + size.Y + offset)

			for attribute_type, cost_ui in pairs(CostUILookup) do
				cost_ui.Visible = stat_lookup[type][attribute_type] > 0
				cost_ui.Cost.Text = stat_lookup[type][attribute_type]
			end
		end)

		allocate.MouseLeave:Connect(function()
			CostIndicator.Visible = false
		end)

		allocate.Activated:Connect(function()
			if CostIndicator.Visible then
				StatAllocateRequest:InvokeServer(type)
			end
		end)
	end
end

UI_StatViewScreen._init()

return UI_StatViewScreen
