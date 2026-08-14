local Cleanup = {}
Cleanup.__index = Cleanup

--[[
	A robust memory management class (similar to Maid/Trove).
	Handles cleaning up RBXScriptConnections, Instances, Threads, and functions.
]]

function Cleanup.new()
	local self = setmetatable({
		_tasks = {}
	}, Cleanup)
	return self
end

function Cleanup:Add(task)
	if not task then return end
	table.insert(self._tasks, task)
	return task
end

function Cleanup:Clean()
	for i = #self._tasks, 1, -1 do
		local task = self._tasks[i]
		
		if type(task) == "function" then
			task()
		elseif typeof(task) == "RBXScriptConnection" then
			task:Disconnect()
		elseif typeof(task) == "Instance" then
			task:Destroy()
		elseif type(task) == "thread" then
			task.cancel(task)
		elseif type(task) == "table" and type(task.Destroy) == "function" then
			task:Destroy()
		elseif type(task) == "table" and type(task.Clean) == "function" then
			task:Clean()
		end
		
		self._tasks[i] = nil
	end
end

function Cleanup:Destroy()
	self:Clean()
end

return Cleanup
