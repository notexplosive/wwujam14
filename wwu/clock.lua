local Clock = {}

registerComponent(Clock, "Clock")

function Clock:setup()
end

function Clock:awake()
    self.time = 0
end

function Clock:draw(x, y)
    Assets.images["clock-base"]:draw(1, x, y)
    Assets.images["hour-hand"]:draw(1, x, y, nil, nil, self.time / 12)
    Assets.images["minute-hand"]:draw(1, x, y, nil, nil, self.time)
end

function Clock:update(dt)
    self.time = self.time + dt / 2
end

return Clock
