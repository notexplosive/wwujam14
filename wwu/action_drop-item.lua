local DropItemInRoom = {}

registerComponent(DropItemInRoom, "DropItemInRoom", {"CanTraverseDoors", "Inventory"})

function DropItemInRoom:setup()
end

function DropItemInRoom:awake()
end

function DropItemInRoom:update(dt)
end

function DropItemInRoom:isOverlappingDoor()
    return self.actor.CanTraverseDoors:getCurrentDoor() ~= nil
end

function DropItemInRoom:getDirection()
    assert(self.actor.Inventory:isHolding(), self.actor.name .. " had action DropItemInRoom, was not holding an item")

    return 0
end

function DropItemInRoom:isReadyToInteract()
    return self.actor.Inventory:isHolding() and not self:isOverlappingDoor()
end

function DropItemInRoom:isFinished()
    return not self.actor.Inventory:isHolding()
end

return DropItemInRoom
