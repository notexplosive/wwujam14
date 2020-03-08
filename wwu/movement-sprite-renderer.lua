local MovementSpriteRenderer = {}

registerComponent(MovementSpriteRenderer, "MovementSpriteRenderer")

function MovementSpriteRenderer:setup(spriteName)
    self.actor:addComponent(Components.SpriteRenderer, spriteName, "all", 0.25, {1, 1, 1, 1})
    self.actor.SpriteRenderer.offset.y =
        self.actor.SpriteRenderer.sprite.gridHeight * self.actor.SpriteRenderer:getScaleY() * 2
end

function MovementSpriteRenderer:update(dt)
    if self.actor.Movement then
        local dx = self.actor.Movement.velocity.x
        if dx > 0 then
            self.actor.SpriteRenderer:setFlipX(false)
        end
        if dx < 0 then
            self.actor.SpriteRenderer:setFlipX(true)
        end

        if dx == 0 then
            self.actor.SpriteRenderer:pause()
        else
            self.actor.SpriteRenderer:play()
        end
    end
end

return MovementSpriteRenderer
