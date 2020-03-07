local PlayerInput = {}

registerComponent(PlayerInput, "PlayerInput")

function PlayerInput:awake()
	self.inputState = {up = false, down = false, left = false, right = false}
end

function PlayerInput:update(dt)
	debugLog(self.inputState.up, self.inputState.down, self.inputState.left, self.inputState.right)
end

function PlayerInput:onKeyPress(button, scancode, wasReleased)
	if button == "up" or button == "down" or button == "left" or button == "right" then
		self.inputState[button] = not wasReleased
	end
end

function PlayerInput:getInputState()
	return self.inputState
end

return PlayerInput
