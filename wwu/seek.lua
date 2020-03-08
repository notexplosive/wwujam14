local Seek = {}

registerComponent(Seek, "Seek")

function Seek:setup()
end

function Seek:awake()
    self.actor:addComponent(Components.PathfindToRoom, GLOBAL_ROOMS[3])
end

function Seek:draw(x, y)
end

function Seek:update(dt)
    if self:isOriginalPendingConditionMet() then
        self:destroy()
    end
end

function Seek:isOriginalPendingConditionMet()
    assert(self.actor.Plan:getRealPendingComponent().isPossible, "component does not have :isPossible()")
    return self.actor.Plan:getRealPendingComponent():isPossible()
end

function Seek:getPendingComponent()
    return self.actor.PathfindToRoom
end

function Seek:onDestroy()
end

return Seek
