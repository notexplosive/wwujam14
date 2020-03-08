local PlayerInput = {}

registerComponent(PlayerInput, "PlayerInput")

function PlayerInput:awake()
	self.inputState = {up = false, down = false, left = false, right = false}
end

function PlayerInput:onKeyPress(button, scancode, wasReleased)
	if button == "left" or button == "right" then
		self.inputState[button] = not wasReleased
	end
end

function PlayerInput:getInputState()
	return self.inputState
end

return PlayerInput
