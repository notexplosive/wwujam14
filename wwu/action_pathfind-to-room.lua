local PathfindToRoom = {}

registerComponent(PathfindToRoom, "PathfindToRoom", {"Floorable", "CanTraverseDoors"})

function PathfindToRoom:setup(targetRoom)
	self:assignTargetRoom(targetRoom)
end

function PathfindToRoom:update(dt)
	assert(self.targetRoom)
	self:calculatePath()

	local nextRoom = self.actor.PathfindToRoom:getNextRoom()
	local currentRoom = self.actor.Floorable:getCurrentRoom()

	if nextRoom == currentRoom then
		deleteAt(self.path, 2)
	end
end

function PathfindToRoom:assignTargetRoom(targetRoom)
	self.hasCachedPath = false
	self.targetRoom = targetRoom
	self.path = {}
	self:calculatePath()

	local pathString = ""
	for i, v in ipairs(self.path) do
		pathString = pathString .. v.name .. " -> "
	end
	debugLog("DESTINATION:", targetRoom.name)
	debugLog(pathString)

	assert(self.targetRoom)
end

function PathfindToRoom:calculatePath()
	if self.hasCachedPath then
		return
	end

	local currentRoom = self.actor.Floorable:getCurrentRoom()
	local visitedRooms = {}
	visitedRooms[currentRoom.name] = true
	local path = {}

	local result = self:visit(currentRoom, visitedRooms, self.targetRoom, path)

	if result then
		self.path = copyReversed(path)
	end

	self.hasCachedPath = true
end

function PathfindToRoom:visit(currentRoom, visitedRooms, destination, path)
	if currentRoom == destination then
		append(path, currentRoom)
		return true
	end

	local adjacentRooms = currentRoom.Room:getAdjacentRooms()
	local roomsToVisit = {}
	for i, room in ipairs(adjacentRooms) do
		if not visitedRooms[room.name] then
			visitedRooms[room.name] = true
			append(roomsToVisit, room)
		end
	end

	for i, room in ipairs(roomsToVisit) do
		local result = self:visit(room, visitedRooms, destination, path)
		if result then
			append(path, currentRoom)
			return true
		end
	end
end

function PathfindToRoom:getNextRoom()
	if #self.path > 1 then
		return self.path[2]
	end
end

function PathfindToRoom:isInTargetRoom()
	return self.actor.Floorable:getCurrentRoom() == self.targetRoom
end

function PathfindToRoom:getTargetDoor()
	local nextRoom = self.actor.PathfindToRoom:getNextRoom()
	local currentRoom = self.actor.Floorable:getCurrentRoom()
	for i, door in ipairs(currentRoom.Room:getAllDoors()) do
		if door.Door:getDestinationRoom() == nextRoom then
			return door
		end
	end

	return nil
end

function PathfindToRoom:getDirection()
	local targetDoor = self:getTargetDoor()
	if targetDoor then
		return self.actor:pos().x - targetDoor:pos().x
	end

	return 0
end

function PathfindToRoom:isFinished()
	return self:isInTargetRoom()
end

function PathfindToRoom:isReadyToInteract()
	local door = self.actor.CanTraverseDoors:getCurrentDoor()
	local direction = self:getDirection()
	return door == self:getTargetDoor() and math.abs(direction) < 5
end

function PathfindToRoom:talkToResponse()
	return "is going to " .. self.targetRoom.name
end

return PathfindToRoom
