local Item = {}

registerComponent(Item, "Item")

function Item:setup(itemName)
	self.itemName = itemName
end

return Item
