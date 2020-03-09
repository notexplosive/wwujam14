local NpcInput = {}

registerComponent(NpcInput, "NpcInput")

function NpcInput:setup(speed)
	self.speed = speed
end

function NpcInput:awake()
	self.inputState = {left = false, right = false}
	self.interactTimer = 0
	self.waitTimer = 0
end

function NpcInput:update(dt)
	if self.waitTimer > 0 then
		self.waitTimer = self.waitTimer - dt
		return
	end

	if self.actor.Plan then
		local pendingComponent = self.actor.Plan:getPendingComponent()
		if pendingComponent then
			self:calculateInputFromAction(pendingComponent, dt)
		end
	end
end

function NpcInput:getSpeed()
	return self.speed or 150
end

-- actions need:
-- getDirection() -> signed integer, positive for right, negative for left, 0 for stopped
-- isReadyToInteract() -> boolean, true if the action could be completed this frame
-- isFinished() -> boolean, true if the action is satisfied
-- talkToResponse() -> string that the player sees when talking to the NPC
function NpcInput:calculateInputFromAction(actionComponent, dt)
	local direction = actionComponent:getDirection()

	if actionComponent:isReadyToInteract() and not actionComponent:isFinished() then
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
	if self.interactTimer > 0.5 then
		self.actor.CanInteract:interact()
		self.interactTimer = 0
		self.waitTimer = 0.5
	end
end

function NpcInput:applyDirection(direction)
	self.inputState.left = direction > 0
	self.inputState.right = direction < 0
end

return NpcInput
