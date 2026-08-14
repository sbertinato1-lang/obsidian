local InstanceUtils = {}

--[[
	Wrapper for creating UI instances with properties and children cleanly.
]]

function InstanceUtils.Create(className, properties, children)
	local instance = Instance.new(className)
	
	if properties then
		for k, v in pairs(properties) do
			if k ~= "Parent" then
				instance[k] = v
			end
		end
		
		-- Apply Parent last to avoid unnecessary rendering calculations during setup
		if properties.Parent then
			instance.Parent = properties.Parent
		end
	end
	
	if children then
		for _, child in pairs(children) do
			child.Parent = instance
		end
	end
	
	return instance
end

function InstanceUtils.ApplyCorner(instance, radius)
	return InstanceUtils.Create("UICorner", {
		CornerRadius = UDim.new(0, radius),
		Parent = instance
	})
end

function InstanceUtils.ApplyStroke(instance, color, thickness, transparency)
	return InstanceUtils.Create("UIStroke", {
		Color = color or Color3.fromRGB(0, 0, 0),
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = instance
	})
end

return InstanceUtils
