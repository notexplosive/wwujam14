local PlayerMovement = {}

registerComponent(PlayerMovement, "PlayerMovement")

function PlayerMovement:awake()
	self.inputState = {up = false, down = false, left = false, right = false}
end

function PlayerMovement:update(dt)
	debugLog(self.inputState.up, self.inputState.down, self.inputState.left, self.inputState.right)
end

function PlayerMovement:onKeyPress(button, scancode, wasReleased)
	if button == "up" or button == "down" or button == "left" or button == "right" then
		self.inputState[button] = not wasReleased
	end
end

function PlayerMovement:getInputState()
	return self.inputState
end

return PlayerMovement
