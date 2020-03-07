local NpcInput = {}

registerComponent(NpcInput, "NpcInput")

function NpcInput:setup()
end

function NpcInput:awake()
	self.inputState = {up = false, down = false, left = false, right = false}
end

function NpcInput:draw(x, y)
end

function NpcInput:update(dt)
	self.inputState.up = love.math.random() < 0.5
	self.inputState.down = love.math.random() < 0.5
	self.inputState.left = love.math.random() < 0.5
	self.inputState.right = love.math.random() < 0.5
end

function NpcInput:getInputState()
	return self.inputState
end

return NpcInput
