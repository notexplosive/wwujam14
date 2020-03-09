local CanDropItems = {}

registerComponent(CanDropItems, "CanDropItems", {"CanHoldItems"})

function CanDropItems:onInteract()
	if self.actor.CanHoldItems:isHolding() then
		self.actor.CanHoldItems:dropItem()
		return true
	end
end

return CanDropItems
