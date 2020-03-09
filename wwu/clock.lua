local sceneLayers = require("nx/scene-layers")
local Clock = {}

registerComponent(Clock, "Clock")

function Clock:draw(x, y)
    local time = sceneLayers:get(1):getFirstBehavior(Components.PlayerInput).time
    Assets.images["clock-base"]:draw(1, x, y)
    Assets.images["hour-hand"]:draw(1, x, y, nil, nil, time / 12)
    Assets.images["minute-hand"]:draw(1, x, y, nil, nil, time)
end

return Clock
