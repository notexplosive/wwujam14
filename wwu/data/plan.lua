local Task = require("wwu/data/task")
local Plan = {}

function Plan.new()
	local self = newObject(Plan, true)
	self.listOfTasks = {}
	self.currentTaskIndex = 1
	return self
end

function Plan:appendTask(task)
	assert(task:type() == Task, "appendTask not given a task")
	append(self.listOfTasks, task)
end

function Plan:getCurrentTask()
	local task = self.listOfTasks[self.currentTaskIndex]
	if not task then
		assert(false, "must have task.")
	end
	if not task:isPossible() then
		self:advanceToNextTask()
	end
	return task
end

function Plan:advanceToNextTask()
	self.currentTaskIndex = self.currentTaskIndex + 1
end

return Plan
