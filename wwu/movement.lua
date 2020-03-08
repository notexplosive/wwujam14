local Movement = {}

registerComponent(Movement, "Movement")

function Movement:setup(inputComponent)
	self.inputComponent = inputComponent

	self.velocity = Vector.new()
	self.moveSpeed = 600 -- per second
end

function Movement:update(dt)
	local inputState = self.inputComponent:getInputState()
	local inputVector = Vector.new()

	local directions = {"left", "right"}
	for i, direction in ipairs(directions) do
		if inputState[direction] then
			inputVector = inputVector + Vector.newCardinal(direction, 1)
		end
	end

	inputVector = inputVector:normalized() * self.moveSpeed * dt

	local room = self:getCurrentRoom()
	local rect = self.actor.BoundingBox:getRect()
	rect:move(inputVector)

	if rect:left() < room:pos().x then
		inputVector = Vector.new()
	end

	if rect:right() > room:pos().x + room.BoundingBox:width() then
		inputVector = Vector.new()
	end

	self.actor:move(inputVector)
end

function Movement:getCurrentRoom()
	local myRect = self.actor.BoundingBox:getRect()

	for i, roomActor in self.actor:scene():eachActorWith(Components.Room) do
		local roomBounds = roomActor.BoundingBox:getRect()

		if myRect:getIntersection(roomBounds):area() > 0 then
			return roomActor
		end
	end

	assert(false, "you are not in a room :(")
end

return Movement
