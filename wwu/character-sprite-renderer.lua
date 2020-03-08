local CharacterSpriteRenderer = {}

registerComponent(CharacterSpriteRenderer, "CharacterSpriteRenderer")

function CharacterSpriteRenderer:setup(imageName)
    assert(Assets.images[imageName], imageName)
    self.image = Assets.images[imageName].image
    assert(self.image)
end

function CharacterSpriteRenderer:awake()
end

function CharacterSpriteRenderer:draw(x, y)
    local scale = 0.25
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(
        self.image,
        x - self.image:getWidth() * scale / 2,
        y - self.image:getHeight() * scale,
        0,
        scale,
        scale
    )
end

function CharacterSpriteRenderer:update(dt)
end

return CharacterSpriteRenderer
