local Collider = {}

registerComponent(Collider, "Collider")

function Collider:setup(width)
	self.actor:addComponent(Components.Floorable)
	self.actor:addComponent(Components.BoundingBox, width, 10)
	self.actor.BoundingBox.offset.x = width / 2
	self.actor:addComponent(Components.BoundingBoxRenderer)
end

function Collider:getCurrentRoom()
	local myRect = self.actor.BoundingBox:getRect()

	for i, roomActor in self.actor:scene():eachActorWith(Components.Room) do
		local roomBounds = roomActor.BoundingBox:getRect()

		if myRect:getIntersection(roomBounds):area() > 0 then
			return roomActor
		end
	end

	assert(false, "you are not in a room :(")
end

return Collider
