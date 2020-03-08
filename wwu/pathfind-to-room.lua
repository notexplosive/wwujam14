local PathfindToRoom = {}

registerComponent(PathfindToRoom, "PathfindToRoom", {"Floorable"})

function PathfindToRoom:setup(targetRoom)
	self.targetRoom = targetRoom
	assert(self.targetRoom)
end

function PathfindToRoom:awake()
end

function PathfindToRoom:draw(x, y)
end

function PathfindToRoom:update(dt)
	local currentRoom = self.actor.Floorable:getCurrentRoom()
	local visitedRooms = {}
	visitedRooms[currentRoom.name] = true
	local path = {}

	local result = self:visit(currentRoom, visitedRooms, self.targetRoom, path)

	if result then
		self.path = copyReversed(path)
	end
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

return PathfindToRoom
