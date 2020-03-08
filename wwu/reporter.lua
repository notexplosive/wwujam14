local sceneLayers = require("nx/scene-layers")
local Reporter = {}

local font = love.graphics.newFont(16)

registerComponent(Reporter, "Reporter")

function Reporter:awake()
    self.string = ""
end

function Reporter:draw(x, y)
    if DEBUG then
        love.graphics.setFont(font)
        love.graphics.print(self.string, x, y)
    end
end

function Reporter:update(dt)
    local gameScene = sceneLayers:get(1)
    self.string = ""
    for i, actor in gameScene:eachActorWith(Components.Plan) do
        self.string = self.string .. actor.Plan:report() .. "\n"
    end
end

return Reporter
