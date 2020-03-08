local NpcInput = {}

registerComponent(NpcInput, "NpcInput")

function NpcInput:setup()
end

function NpcInput:awake()
	self.inputState = {left = false, right = false}
	self.interactTimer = 0
end

function NpcInput:update(dt)
	if self.actor.PathfindToRoom then
		if self.actor.PathfindToRoom.path then
			self:calculateInputFromAction(self.actor.PathfindToRoom, dt)
		end
	end

	if self.actor.GetItemInRoom then
		self:calculateInputFromAction(self.actor.GetItemInRoom, dt)
	end
end

function NpcInput:calculateInputFromAction(actionComponent, dt)
	local direction = actionComponent:getDirection()

	if actionComponent:isAble() and not actionComponent:isFinished() then
		self:attemptInteract(dt)
		direction = 0
	end

	self:applyDirection(direction)
end

function NpcInput:getInputState()
	return self.inputState
end

function NpcInput:attemptInteract(dt)
	self.interactTimer = self.interactTimer + dt
	if self.interactTimer > 0.25 then
		self.actor.CanInteract:interact()
		self.interactTimer = 0
	end
end

function NpcInput:applyDirection(direction)
	self.inputState.left = direction > 0
	self.inputState.right = direction < 0
end

return NpcInput
