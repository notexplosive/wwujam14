local Floorable = {}

registerComponent(Floorable, "Floorable", {"BoundingBox"})

function Floorable:setup()
end

function Floorable:awake()
	self:updateCache()
end

function Floorable:update(dt)
	local pos = self.actor:pos()
	local currentRoom = self:updateCache()

	if currentRoom then
		self.actor:setPos(pos.x, currentRoom.Room:getFloor())
	end
end

function Floorable:updateCache()
	local currentRoom = self:getCurrentRoom() or self:calculateCurrentRoom()
	if self.actor.BoundingBox:getRect():getIntersection(currentRoom.BoundingBox:getRect()) == 0 then
		currentRoom = self:calculateCurrentRoom()
	end

	self.cachedCurrentRoom = currentRoom

	return currentRoom
end

function Floorable:getCurrentRoom()
	return self.cachedCurrentRoom
end

function Floorable:invalidateCache()
	self.cachedCurrentRoom = nil
end

function Floorable:calculateCurrentRoom()
	local myRect = self.actor.BoundingBox:getRect()

	for i, roomActor in self.actor:scene():eachActorWith(Components.Room) do
		local roomBounds = roomActor.BoundingBox:getRect()

		if myRect:getIntersection(roomBounds):area() > 0 then
			return roomActor
		end
	end

	--assert(false, "you are not in a room :(")
	return nil
end

return Floorable
