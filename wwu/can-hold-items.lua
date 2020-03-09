local CanHoldItems = {}

registerComponent(CanHoldItems, "CanHoldItems")

function CanHoldItems:awake()
	self.currentHeldItem = nil
	self.time = 0
end

function CanHoldItems:update(dt)
	self.time = self.time + dt
end

function CanHoldItems:draw(x, y)
	if self:isHolding() then
		self.currentHeldItem:draw(x, y - 160)
	end
end

function CanHoldItems:getOverlappedItem(givenBounds)
	local myBounds = givenBounds or self.actor.BoundingBox:getRect()
	for i, itemActor in self.actor:scene():eachActorWith(Components.Item) do
		local itemBounds = itemActor.BoundingBox:getRect()
		if myBounds:getIntersection(itemBounds):area() > 0 then
			return itemActor
		end
	end

	return nil
end

function CanHoldItems:onInteract()
	local item = self:getOverlappedItem()
	if item then
		if not self:isHolding() then
			self:pickUp(item)
			return true
		end
	end
end

function CanHoldItems:isHolding()
	return self.currentHeldItem ~= nil
end

function CanHoldItems:getHeldItemName()
	return self.currentHeldItem.Item.name
end

function CanHoldItems:pickUp(item)
	self.currentHeldItem = item
	self.currentHeldItem:removeFromScene()
end

function CanHoldItems:dropItem()
	self.currentHeldItem:setPos(self.actor:pos())
	self.actor:scene():addActor(self.currentHeldItem)
	self.currentHeldItem = nil
end

return CanHoldItems
