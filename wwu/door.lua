local Door = {}

registerComponent(Door, "Door")

function Door:setup(destinationActor)
	self.destinationActor = destinationActor
end

function Door:getDestination()
	return self.destinationActor:pos()
end

function Door:getDestinationRoom()
	return destinationActor.Floorable:getCurrentRoom()
end

return Door
