local Task = {}

function Task.new(verb, target, completionLambda)
	local self = newObject(Task, true)
	self.verb = verb
	self.target = target
	self.requirement = {}
	self.completionLambda = completionLambda

	return self
end

function Task:isPossible()
	return true
end

function Task:getName()
	return self.verb .. " " .. self.target
end

function Task:checkCompletion(actor)
	assert(actor, "Missing actor")
	self.completionLambda(actor, self.target)
end

return Task
