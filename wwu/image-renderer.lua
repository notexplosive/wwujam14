local ImageRenderer = {}

registerComponent(ImageRenderer, "ImageRenderer")

function ImageRenderer:setup(imageName, animated)
    assert(Assets.images[imageName], imageName)
    self.image = Assets.images[imageName].image
    self.animated = animated
    assert(self.image)

    self.color = {1, 1, 1, 1}
end

function ImageRenderer:awake()
    self.flip = false
    self.time = love.math.random() * math.pi * 2
end

function ImageRenderer:draw(x, y)
    local scale = 0.25
    local floatingHeight = 0
    if self.animated then
        floatingHeight = math.sin(self.time) * 5 - 20
    end

    if self.animated then
        self:itemDraw(x, y, floatingHeight, scale)
    else
        love.graphics.setColor(self.color)
        love.graphics.draw(
            self.image,
            x - self.image:getWidth() * scale / 2 * self:getNumberFromFlip(),
            y - self.image:getHeight() * scale + floatingHeight,
            0,
            scale * self:getNumberFromFlip(),
            scale
        )
    end
end

function ImageRenderer:itemDraw(x, y, floatingHeight, scale)
    --assert(self.shader, "item expected to have outline shader set")
    if not self.shader then
        self.shader = love.graphics.newShader( "assets/shaders/item_highlight_temp.glsl" )
    end

    
    love.graphics.setColor(self.color)
    love.graphics.draw(
        self.image,
        x - self.image:getWidth() * scale / 2 * self:getNumberFromFlip(),
        y - self.image:getHeight() * scale + floatingHeight,
        0,
        scale * self:getNumberFromFlip(),
        scale
    )

    --draw again with outline only.
    love.graphics.setShader( self.shader )
    	
    self.shader:send( "stepSize",{4/self.image:getWidth(),4/self.image:getHeight()} )
    love.graphics.draw(
        self.image,
        x - self.image:getWidth() * scale / 2 * self:getNumberFromFlip(),
        y - self.image:getHeight() * scale + floatingHeight,
        0,
        scale * self:getNumberFromFlip(),
        scale
    )

    love.graphics.setShader()
end

function ImageRenderer:update(dt)
    if self.actor.Movement then
        local dx = self.actor.Movement.velocity.x
        if dx > 0 then
            self.flip = false
        end
        if dx < 0 then
            self.flip = true
        end
    end

    self.time = self.time + dt
end

function ImageRenderer:getNumberFromFlip()
    if self.flip then
        return -1
    else
        return 1
    end
end

return ImageRenderer
