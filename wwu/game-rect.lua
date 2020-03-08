local GameRect = {}

registerComponent(GameRect, "GameRect")

function GameRect:setup(width, height)
	self.actor:addComponent(Components.RectRenderer, width, height)
	self.actor:addComponent(Components.Floorable)
end

return GameRect
