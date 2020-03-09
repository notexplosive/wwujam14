local Door = {}

registerComponent(Door, "Door", {"Floorable"})

function Door:setup(destinationActor)
	self.destinationActor = destinationActor

	--local tr = self.actor:addComponent(Components.TextRenderer, self.destinationActor.Floorable:getCurrentRoom().name)
	--tr.offset.x = -20
	--tr.offset.y = -30
end

function Door:getDestination()
	return self.destinationActor:pos()
end

function Door:getDestinationRoom()
	return self.destinationActor.Floorable:getCurrentRoom()
end

function Door:getSourceRoom()
	return self.actor.Floorable:getCurrentRoom()
end

return Door
