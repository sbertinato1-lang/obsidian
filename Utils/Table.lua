local TableUtils = {}

--[[
	Utility functions for table manipulation.
]]

function TableUtils.DeepCopy(original)
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = TableUtils.DeepCopy(v)
		end
		copy[k] = v
	end
	return copy
end

function TableUtils.Merge(target, source)
	for k, v in pairs(source) do
		if type(v) == "table" and type(target[k]) == "table" then
			TableUtils.Merge(target[k], v)
		else
			target[k] = v
		end
	end
	return target
end

return TableUtils
