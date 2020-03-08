local Collider = {}

registerComponent(Collider, "Collider")

function Collider:setup(width)
	self.actor:addComponent(Components.Floorable)
	self.actor:addComponent(Components.BoundingBox, width, 10)
	self.actor.BoundingBox.offset.x = width / 2
end

return Collider
