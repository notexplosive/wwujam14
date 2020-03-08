local CanInteract = {}

registerComponent(CanInteract, "CanInteract")

function CanInteract:interact()
	local components = copyList(self.actor.components)
	for i, component in ipairs(components) do
		if component["onInteract"] and not components._isDestroyed then
			local b = component["onInteract"](component)
			if b then
				break
			end
		end
	end
end

return CanInteract
