local Item = {}

registerComponent(Item, "Item")

function Item:setup(itemName)
	self.itemName = itemName
end

function Item:awake()
end

function Item:draw(x, y)
end

function Item:update(dt)
end

return Item
