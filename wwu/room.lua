local Room = {}

registerComponent(Room, "Room")

function Room:setup(floorY)
	self.floorY = floorY
end

function Room:getFloor()
	return self.actor:pos().y + self.floorY
end

return Room
