local GameRect = {}

registerComponent(GameRect, "GameRect")

function GameRect:setup(width, height, bodyType)
	self.actor:addComponent(Components.Body, bodyType)
	self.actor:addComponent(Components.RectangleShape, width, height, 1)
	self.actor:addComponent(Components.RectRenderer, width, height)
end

return GameRect
