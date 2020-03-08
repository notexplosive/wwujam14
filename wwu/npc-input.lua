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
			local direction = self.actor.PathfindToRoom:getDirection()

			if self.actor.PathfindToRoom:isAble() and not self.actor.PathfindToRoom:isFinished() then
				self:attemptInteract(dt)
				direction = 0
			end

			self:applyDirection(direction)
		end
	end

	if self.actor.GetItemInRoom then
		local direction = self.actor.GetItemInRoom:getDirection()

		-- TODO: replace math.abs etc with GetItemInRoom:isAble()
		if self.actor.GetItemInRoom:isAble() and not self.actor.GetItemInRoom:isFinished() then
			self:attemptInteract(dt)
			direction = 0
		end

		self:applyDirection(direction)
	end
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
