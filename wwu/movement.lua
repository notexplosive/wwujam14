local Movement = {}

registerComponent(Movement, "Movement")

function Movement:setup(inputComponent)
	self.inputComponent = inputComponent
	self.moveSpeed = inputComponent:getSpeed()
	self.hitWallThisFrame = false
	self.velocity = Vector.new()
end

function Movement:update(dt)
	self.hitWallThisFrame = false
	local inputState = self.inputComponent:getInputState()
	local inputVector = Vector.new()

	local directions = {"left", "right"}
	for i, direction in ipairs(directions) do
		if inputState[direction] then
			inputVector = inputVector + Vector.newCardinal(direction, 1)
		end
	end

	inputVector = inputVector:normalized() * self.moveSpeed * dt

	local room = self.actor.Floorable:getCurrentRoom()
	local rect = self.actor.BoundingBox:getRect()
	if room then
		rect:move(inputVector)

		if rect:left() < room:pos().x then
			inputVector = Vector.new()
			self.hitWallThisFrame = true
		end

		if rect:right() > room:pos().x + room.BoundingBox:width() then
			inputVector = Vector.new()
			self.hitWallThisFrame = true
		end

		self.actor:move(inputVector)
	end
	self.velocity = inputVector
end

function Movement:wasWallHitThisFrame()
	return self.hitWallThisFrame
end

return Movement
