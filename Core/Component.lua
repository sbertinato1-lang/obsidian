local Cleanup = require(script.Parent.Parent.Utils.Cleanup)

local Component = {}
Component.__index = Component

--[[
	Base class for all UI components.
	Provides consistent initialization and memory management.
]]

function Component.new()
	local self = setmetatable({
		_cleanup = Cleanup.new(),
		Instance = nil,
		Value = nil,
		Enabled = true,
		Visible = true,
	}, Component)
	
	return self
end

function Component:SetValue(value)
	self.Value = value
	-- To be overridden by subclass
end

function Component:GetValue()
	return self.Value
end

function Component:SetVisible(visible)
	self.Visible = visible
	if self.Instance then
		self.Instance.Visible = visible
	end
end

function Component:SetEnabled(enabled)
	self.Enabled = enabled
	-- To be overridden by subclass for visual state changes
end

function Component:Destroy()
	self._cleanup:Destroy()
	-- The _cleanup handles destroying self.Instance if we add it to the cleanup tasks
	setmetatable(self, nil)
end

return Component
