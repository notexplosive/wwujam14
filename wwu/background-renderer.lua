local BackgroundRenderer = {}

registerComponent(BackgroundRenderer, "BackgroundRenderer")

local scale = 3

function BackgroundRenderer:setup(imageName)
    self.image = Assets.images[imageName].image

    local w, h = self.actor.BoundingBox:getDimensions()
    local sw, sh = self.image:getDimensions()
    self.quad = love.graphics.newQuad(0, (sh - h * scale) + 100, w * scale, h * scale, sw, sh)
end

function BackgroundRenderer:draw(x, y)
    love.graphics.draw(self.image, self.quad, x, y, 0, 1 / scale, 1 / scale)
end

return BackgroundRenderer
