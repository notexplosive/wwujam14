local NPCWait = {}

registerComponent(NPCWait, "NPCWait")

function NPCWait:setup(duration)
	self.duration = duration
end

function NPCWait:update(dt)
	self.duration = self.duration - dt
end

function NPCWait:isFinished()
	if self.duration <= 0 then
		return true
	else
		return false
	end
end

function NPCWait:talkToResponse()
	return self.actor.name .. " is hanging out."
end

function NPCWait:isReadyToInteract()
	return false
end

function NPCWait:getDirection()
	return 0
end
return NPCWait
