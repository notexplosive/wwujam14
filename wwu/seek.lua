local Seek = {}

registerComponent(Seek, "Seek", {"Floorable"})

function Seek:setup()
end

function Seek:awake()
	self.currentRoomIndex = 0

	for i, roomActor in ipairs(GLOBAL_ROOMS) do
		if self.actor.Floorable:getCurrentRoom() == roomActor then
			self.currentRoomIndex = i
			break
		end
	end

	self.pendingSeekComponent = self.actor:addComponent(Components.PathfindToRoom, self:getNextRoom())
end

function Seek:update(dt)
	if self:isOriginalPendingConditionMet() then
		self:destroy()
	end

	if self.pendingSeekComponent:isFinished() then
		self.pendingSeekComponent:assignTargetRoom(self:getNextRoom())
		self:incrementCurrentRoomIndex()
	end
end

function Seek:isOriginalPendingConditionMet()
	assert(self.actor.Plan:getRealPendingComponent(), self.actor.name .. " does not have a pending component from plan")
	assert(self.actor.Plan:getRealPendingComponent().isPossible, "component does not have :isPossible()")
	return self.actor.Plan:getRealPendingComponent():isPossible()
end

function Seek:getPendingComponent()
	return self.pendingSeekComponent
end

function Seek:onDestroy()
	self.pendingSeekComponent:destroy()
end

function Seek:incrementCurrentRoomIndex()
	local incrementedIndex = self.currentRoomIndex + 1
	if incrementedIndex > #GLOBAL_ROOMS - 4 then
		incrementedIndex = 1
	end
	self.currentRoomIndex = incrementedIndex
end

function Seek:getNextRoom()
	local incrementedIndex = self.currentRoomIndex + 1
	if incrementedIndex > #GLOBAL_ROOMS - 4 then
		incrementedIndex = 1
	end

	return GLOBAL_ROOMS[incrementedIndex]
end

return Seek
