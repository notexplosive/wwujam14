local GetItemInRoom = {}

registerComponent(GetItemInRoom, "GetItemInRoom", {"Inventory"})

function GetItemInRoom:setup(itemName)
	self.targetItemName = itemName
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
	return self.actor.Inventory:isHolding()
end

function GetItemInRoom:isReadyToInteract()
	local item = self.actor.Inventory:getOverlappedItem()
	return item and item.Item.itemName == self.targetItemName
end

return GetItemInRoom