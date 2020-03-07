local NpcInput = {}

registerComponent(NpcInput, "NpcInput")

function NpcInput:setup(plan)
	self.plan = plan
end

function NpcInput:awake()
	self.inputState = {up = false, down = false, left = false, right = false}
end

function NpcInput:update(dt)
	local task = self.plan:getCurrentTask()
	while task:checkCompletion(self.actor) do
		self.plan:advanceToNextTask()
		task = self.plan:getCurrentTask()
	end
	local target = task.target
	local displacement = target:pos() - self.actor:pos()
	local direction = displacement:normalized()

	self.inputState.right = direction.x > 0

	self.inputState.left = direction.x < 0

	self.inputState.down = direction.y > 0

	self.inputState.up = direction.y < 0
end

function NpcInput:getInputState()
	return self.inputState
end

return NpcInput
