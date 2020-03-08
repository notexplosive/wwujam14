local Character = {}

registerComponent(Character, "Character")

function Character:setup(width, height)
	self.actor:addComponent(Components.RectRenderer, width, height)
	self.actor.RectRenderer.offset.y = height / 2
	self.actor:addComponent(Components.Floorable)
	self.actor:addComponent(Components.BoundingBox, width, 10)
	self.actor.BoundingBox.offset.x = width / 2
	self.actor:addComponent(Components.BoundingBoxRenderer)
end

return Character
