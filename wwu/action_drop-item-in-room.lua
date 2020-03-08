local DropItemInRoom = {}

registerComponent(DropItemInRoom, "DropItemInRoom", {"CanTraverseDoors", "Inventory", "Movement"})

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
    return self.actor.CanTraverseDoors:getCurrentDoor() ~= nil or self.actor.Inventory:getOverlappedItem() ~= nil
end

function DropItemInRoom:getDirection()
    assert(self.actor.Inventory:isHolding(), self.actor.name .. " had action DropItemInRoom, was not holding an item")
    return self.currentDirection
end

function DropItemInRoom:isReadyToInteract()
    return self.actor.Inventory:isHolding() and not self:isOverlappingDoorOrItem()
end

function DropItemInRoom:isFinished()
    return not self.actor.Inventory:isHolding()
end

return DropItemInRoom
