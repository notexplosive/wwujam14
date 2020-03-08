local TextBox = {}

registerComponent(TextBox, "TextBox")

function TextBox:setup(text)
    self.text = text
end

function TextBox:awake()
    self.screenSize = Vector.new(love.graphics.getDimensions())
    self.desiredSize = Size.new(self.screenSize.x * 0.8, self.screenSize.y * 0.25)

    self.actor:addComponent(Components.BoundingBox, 32, 32, 16, 16)
    self.actor:setPos(self.screenSize / 2)
end

function TextBox:draw(x, y)
    local rect = self.actor.BoundingBox:getRect()
    love.graphics.setColor(0, 0, 1, 0.5)
    love.graphics.rectangle("fill", rect:xywh())
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("line", rect:xywh())
end

function TextBox:update(dt)
    local rect =
        self.actor.BoundingBox:getRect():inflate(
        (self.desiredSize.width - self.actor.BoundingBox:width()) * 0.5,
        (self.desiredSize.height - self.actor.BoundingBox:height()) * 0.5
    )
    self.actor.BoundingBox:setRect(rect)

    local diff = self.desiredSize.width - self.actor.BoundingBox:width()
    if diff < 1 and not self.actor.BoundedTextRenderer then
        local tr = self.actor:addComponent(Components.BoundedTextRenderer, self.text)
        tr:setFontSize(64)
    end
end

return TextBox
