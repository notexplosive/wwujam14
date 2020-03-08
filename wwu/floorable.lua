local Floorable = {}

registerComponent(Floorable, "Floorable")

function Floorable:setup()
end

function Floorable:awake()
end

function Floorable:draw(x, y)
end

function Floorable:update(dt)
	local pos = self.actor:pos()
	self.actor:setPos(pos.x, 650)
end

return Floorable
