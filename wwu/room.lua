local Room = {}

registerComponent(Room, "Room")

function Room:setup(floorY)
	self.floorY = floorY
end

function Room:getFloor()
	return self.actor:pos().y + self.floorY
end

function Room:getAllActorsInRoom()
	local roomRect = self.actor.BoundingBox:getRect()
	local result = {}

	for i, floorableActor in self.actor:scene():eachActorWith(Components.Floorable) do
		local floorableActorBounds = floorableActor.BoundingBox:getRect()

		if roomRect:getIntersection(floorableActorBounds):area() > 0 then
			append(result, floorableActor)
		end
	end

	return result
end

function Room:getAllDoors()
	local result = {}
	for i, actor in ipairs(self:getAllActorsInRoom()) do
		if actor.Door then
			append(result, actor)
		end
	end
	return result
end

function Room:getAdjacentRooms()
	local result = {}
	local allActorsInRoom = self:getAllActorsInRoom()
	for i, actor in ipairs(allActorsInRoom) do
		if actor.Door then
			append(result, actor.Door:getDestinationRoom())
		end
	end
	return result
end

return Room
