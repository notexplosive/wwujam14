local CharacterSpriteRenderer = {}

registerComponent(CharacterSpriteRenderer, "CharacterSpriteRenderer")

function CharacterSpriteRenderer:setup(imageName)
    assert(Assets.images[imageName], imageName)
    self.image = Assets.images[imageName].image
    assert(self.image)
end

function CharacterSpriteRenderer:awake()
    self.flip = false
end

function CharacterSpriteRenderer:draw(x, y)
    local scale = 0.25
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(
        self.image,
        x - self.image:getWidth() * scale / 2 * self:getNumberFromFlip(),
        y - self.image:getHeight() * scale,
        0,
        scale * self:getNumberFromFlip(),
        scale
    )
end

function CharacterSpriteRenderer:update(dt)
    if self.actor.Movement then
        local dx = self.actor.Movement.velocity.x
        if dx > 0 then
            self.flip = false
        end
        if dx < 0 then
            self.flip = true
        end
    end
end

function CharacterSpriteRenderer:getNumberFromFlip()
    if self.flip then
        return -1
    else
        return 1
    end
end

return CharacterSpriteRenderer
