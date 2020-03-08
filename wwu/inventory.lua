local Inventory = {}

registerComponent(Inventory, "Inventory")

function Inventory:awake()
	self.currentHeldItem = nil
end

function Inventory:draw(x, y)
	if self:isHolding() then
		self.currentHeldItem:draw(x, y - 25)
	end
end

function Inventory:getOverlappedItem()
	local myBounds = self.actor.BoundingBox:getRect()
	for i, itemActor in self.actor:scene():eachActorWith(Components.Item) do
		local itemBounds = itemActor.BoundingBox:getRect()
		if myBounds:getIntersection(itemBounds):area() > 0 then
			return itemActor
		end
	end

	return nil
end

function Inventory:onInteract()
	local item = self:getOverlappedItem()
	if item then
		if not self:isHolding() then
			self:pickUp(item)
			return true
		end
	else
		if self:isHolding() then
			self:dropItem()
			return true
		end
	end
end

function Inventory:isHolding()
	return self.currentHeldItem ~= nil
end

function Inventory:pickUp(item)
	debugLog(self.actor.name .. " picked up " .. item.Item.itemName)
	self.currentHeldItem = item
	self.currentHeldItem:removeFromScene()
end

function Inventory:dropItem()
	self.currentHeldItem:setPos(self.actor:pos())
	self.actor:scene():addActor(self.currentHeldItem)
	self.currentHeldItem = nil
end

return Inventory
