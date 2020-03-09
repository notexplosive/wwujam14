local PlayerInput = {}

registerComponent(PlayerInput, "PlayerInput")

function PlayerInput:awake()
	self.inputState = {left = false, right = false}
end

function PlayerInput:getSpeed()
	return 300
end

function PlayerInput:onKeyPress(button, scancode, wasRelease)
	if button == "left" or button == "right" then
		self.inputState[button] = not wasRelease
	end
	if (button == "down" or button == "e") and not wasRelease then
		self.actor.CanInteract:interact()
	end
end

function PlayerInput:getInputState()
	return self.inputState
end

return PlayerInput
