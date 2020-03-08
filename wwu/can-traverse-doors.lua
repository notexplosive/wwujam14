local CanTraverseDoors = {}

registerComponent(CanTraverseDoors, "CanTraverseDoors")

function CanTraverseDoors:getCurrentDoor(givenBounds)
	local myBounds = givenBounds or self.actor.BoundingBox:getRect()
	for i, actor in self.actor:scene():eachActorWith(Components.Door) do
		local doorBounds = actor.BoundingBox:getRect()
		if myBounds:getIntersection(doorBounds):area() >= math.min(myBounds:area(), doorBounds:area()) then
			return actor
		end
	end
	return nil
end

function CanTraverseDoors:onInteract()
	local door = self:getCurrentDoor()
	if door then
		self.actor:setPos(door.Door:getDestination())
		return true
	end
end

return CanTraverseDoors
