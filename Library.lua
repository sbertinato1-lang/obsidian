local Library = {}
Library.__index = Library

local Theme = require(script.Parent.Theme)
local Cleanup = require(script.Parent.Utils.Cleanup)
local Window = require(script.Parent.Core.Window)
local Notifications = require(script.Parent.Systems.Notifications)
local Config = require(script.Parent.Systems.Config)
local UserInputService = game:GetService("UserInputService")

--[[
	Core UI Manager for Obsidian.
]]

function Library.new()
	local self = setmetatable({
		_cleanup = Cleanup.new(),
		Windows = {},
		ToggleKey = Enum.KeyCode.RightControl,
		Visible = true
	}, Library)

	-- Global Visibility Toggle
	UserInputService.InputBegan:Connect(function(input, processed)
		if not processed and input.KeyCode == self.ToggleKey then
			self:Toggle()
		end
	end)

	return self
end

function Library:CreateWindow(options)
	options = options or {}
	options.Title = options.Title or "Obsidian"
	options.Badge = options.Badge or ""
	options.Version = options.Version or ""
	
	local window = Window.new(options)
	self._cleanup:Add(window)
	table.insert(self.Windows, window)
	return window
end

function Library:Notify(options)
	Notifications.Notify(options)
end

function Library:CreateConfig(options)
	return Config.new(self, options)
end

function Library:SetToggleKey(key)
	self.ToggleKey = key
end

function Library:Toggle()
	self.Visible = not self.Visible
	for _, window in pairs(self.Windows) do
		window:SetVisible(self.Visible)
	end
end

function Library:SetTheme(themeConfig)
	Theme.Set(themeConfig)
end

function Library:Destroy()
	self._cleanup:Destroy()
end

-- Create a singleton instance for global access if needed, or return the class
return Library.new()
