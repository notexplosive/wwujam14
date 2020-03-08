local GetItemInRoom = {}

registerComponent(GetItemInRoom, "GetItemInRoom", {"CanHoldItems"})

function GetItemInRoom:setup(itemName)
	self.targetItemName = itemName
end

function GetItemInRoom:update(dt)
	local item = self:findItemInRoom()
	if not item and not self.actor.Seek and not self.actor.CanHoldItems:isHolding() then
		self.actor:addComponent(Components.Seek)
	end
end

function GetItemInRoom:getDirection()
	local item = self:findItemInRoom()
	if item then
		local dx = self.actor:pos().x - item:pos().x
		return dx
	end

	return 0
end

function GetItemInRoom:findItemInRoom()
	local itemList = self.actor.Floorable:getCurrentRoom().Room:getAllItems()
	for i, item in ipairs(itemList) do
		if item.Item.itemName == self.targetItemName then
			return item
		end
	end

	return nil
end

function GetItemInRoom:isFinished()
	return self.actor.CanHoldItems:isHolding()
end

function GetItemInRoom:isReadyToInteract()
	local item = self.actor.CanHoldItems:getOverlappedItem()
	return item and item.Item.itemName == self.targetItemName
end

function GetItemInRoom:talkToResponse()
	if self:findItemInRoom() then
		return "is grabbing a " .. self.targetItemName
	else
		return "is looking for a " .. self.targetItemName
	end
end

return GetItemInRoom
