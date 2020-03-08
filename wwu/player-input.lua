local PlayerInput = {}

registerComponent(PlayerInput, "PlayerInput")

function PlayerInput:awake()
	self.inputState = {up = false, down = false, left = false, right = false}
end

function PlayerInput:onKeyPress(button, scancode, wasRelease)
	if button == "left" or button == "right" then
		self.inputState[button] = not wasRelease
	end
	if button == "down" and not wasRelease then
		local components = copyList(self.actor.components)
		for i, component in ipairs(components) do
			if component["onInteract"] and not components._isDestroyed then
				local b = component["onInteract"](component)
				if b then
					break
				end
			end
		end
	end
end

function PlayerInput:getInputState()
	return self.inputState
end

return PlayerInput
