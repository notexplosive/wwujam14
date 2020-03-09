local DropItemInRoom = {}

registerComponent(DropItemInRoom, "DropItemInRoom", {"CanTraverseDoors", "CanHoldItems", "Movement"})

function DropItemInRoom:setup(startingDirection)
    self.currentDirection = startingDirection
end

function DropItemInRoom:awake()
    self.currentDirection = 1
end

function DropItemInRoom:update(dt)
    if self.actor.Movement:wasWallHitThisFrame() then
        self.currentDirection = -self.currentDirection
    end
end

function DropItemInRoom:isOverlappingDoorOrItem()
    local door = self.actor.CanTraverseDoors:isOverlappingDoor(self.actor.BoundingBox:getRect():inflate(100, 0))
    local item = self.actor.CanHoldItems:isOverlappingItem(self.actor.BoundingBox:getRect():inflate(100, 0))
    -- isOverlappingDoor
    -- isOverlappingItem
    return door or item
end

function DropItemInRoom:getDirection()
    assert(
        self.actor.CanHoldItems:isHolding(),
        self.actor.name .. " had action DropItemInRoom, was not holding an item"
    )
    return self.currentDirection
end

function DropItemInRoom:isReadyToInteract()
    return self.actor.CanHoldItems:isHolding() and not self:isOverlappingDoorOrItem()
end

function DropItemInRoom:isFinished()
    return not self.actor.CanHoldItems:isHolding()
end

function DropItemInRoom:talkToResponse()
    return "is setting down the " .. self.actor.CanHoldItems:getHeldItemName()
end

return DropItemInRoom
