local Floorable = {}

registerComponent(Floorable, "Floorable")

function Floorable:setup()
end

function Floorable:awake()
end

function Floorable:update(dt)
	local pos = self.actor:pos()
	if self:getCurrentRoom() then
		self.actor:setPos(pos.x, self:getCurrentRoom().Room:getFloor())
	end
end

function Floorable:getCurrentRoom()
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
