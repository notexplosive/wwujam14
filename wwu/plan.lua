local Plan = {}

registerComponent(Plan, "Plan")

function Plan:setup()
end

function Plan:awake()
	self.listOfActions = {}
	self.currentActionIndex = 1
end

function Plan:update(dt)
	self:executeCurrentAction()
end

function Plan:addAction(component, ...)
	append(self.listOfActions, {component = component, args = {...}})
end

function Plan:executeCurrentAction()
	if not self.pendingComponent then
		local action = self.listOfActions[self.currentActionIndex]
		if action then
			self.pendingComponent = self.actor:addComponent(action.component, unpack(action.args))
		end
	else
		if self.pendingComponent:isFinished() then
			self:completeAction()
		end
	end
end

function Plan:getRealPendingComponent()
	return self.pendingComponent
end

function Plan:getPendingComponent()
	if self.actor.Seek then
		return self.actor.Seek:getPendingComponent()
	end

	return self.pendingComponent
end

function Plan:completeAction()
	self.pendingComponent:destroy()
	self.pendingComponent = nil
	self.currentActionIndex = self.currentActionIndex + 1
end

function Plan:report()
	if not self.pendingComponent then
		return self.actor.name .. " is standing perfectly still doing nothing"
	else
		return self.actor.name .. " " .. self.pendingComponent:talkToResponse()
	end
end

return Plan
