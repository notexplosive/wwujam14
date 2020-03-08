local NpcInput = {}

registerComponent(NpcInput, "NpcInput")

function NpcInput:setup(plan)
	self.plan = plan
end

function NpcInput:awake()
	self.inputState = {left = false, right = false}
end

function NpcInput:update(dt)
	-- the following is bad code :(
	if self.actor.PathfindToRoom then
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
					self.actor.CanInteract:interact()
				end
			end
		end
	end

	if self.actor.GetItemInRoom then
		local direction = self.actor.GetItemInRoom:getDirection()
		self.inputState.left = direction > 0
		self.inputState.right = direction < 0

		if math.abs(direction) < 5 and not self.actor.Inventory:isHolding() then
			self.actor.CanInteract:interact()
		end
	end
end

function NpcInput:getInputState()
	return self.inputState
end

return NpcInput
