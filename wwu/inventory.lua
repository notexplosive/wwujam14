local Inventory = {}

registerComponent(Inventory, "Inventory")

function Inventory:awake()
	self.currentHeldItem = nil
end

function Inventory:draw()
end

function Inventory:isHolding()
	return self.currentHeldItem ~= nil
end

function Inventory:pickUp(item)
	self.currentHeldItem = item
end

return Inventory
