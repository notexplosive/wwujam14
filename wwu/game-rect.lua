local GameRect = {}

registerComponent(GameRect, "GameRect")

function GameRect:setup(width, height)
	self.actor:addComponent(Components.RectangleShape, width, height, 1)
	self.actor:addComponent(Components.RectRenderer, width, height)
end

return GameRect
