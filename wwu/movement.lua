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

	self.actor:move(inputVector)
end

return Movement
