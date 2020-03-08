local NpcInput = {}

registerComponent(NpcInput, "NpcInput")

function NpcInput:setup(plan)
	self.plan = plan
end

function NpcInput:awake()
	self.inputState = {left = false, right = false}
end

function NpcInput:update(dt)
	--[[
	local task = self.plan:getCurrentTask()
	while task:checkCompletion(self.actor) do
		self.plan:advanceToNextTask()
		task = self.plan:getCurrentTask()
	end
	local target = task.target
	local displacement = target:pos() - self.actor:pos()
	local direction = displacement:normalized()

	self.inputState.right = direction.x > 0

	self.inputState.left = direction.x < 0
	]]
	local path = self.actor.PathfindToRoom.path
	if path then
		local nextRoom = self.actor.PathfindToRoom:getNextRoom()
		local currentRoom = self.actor.Floorable:getCurrentRoom()
		local targetDoor = nil
		for i, door in ipairs(currentRoom.Room:getAllDoors()) do
			if door.Door:getDestinationRoom() == nextRoom then
				targetDoor = door
				break
			end
		end

		if targetDoor then
			local dx = self.actor:pos().x - targetDoor:pos().x
			self.inputState.left = dx > 0
			self.inputState.right = dx < 0

			if math.abs(dx) < 5 then
				--debugLog("interacting")
				self.actor.CanInteract:interact()
			end
		end
	end
end

function NpcInput:getInputState()
	return self.inputState
end

return NpcInput
