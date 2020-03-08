local CanDropItems = {}

registerComponent(CanDropItems, "CanDropItems", {"CanHoldItems"})

function CanDropItems:onInteract()
	if self.actor.CanHoldItems:isHolding() then
		debugLog(self.actor:pos().x - self.actor.Floorable:getCurrentRoom():pos().x)
		self.actor.CanHoldItems:dropItem()
		return true
	end
end

return CanDropItems
