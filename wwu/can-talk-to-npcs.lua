local CanTalkToNpcs = {}

registerComponent(CanTalkToNpcs, "CanTalkToNpcs")

function CanTalkToNpcs:getCurrentNpc()
    local myBounds = self.actor.BoundingBox:getRect()
    for i, actor in self.actor:scene():eachActorWith(Components.NpcInput) do
        local npcBounds = actor.BoundingBox:getRect()

        if npcBounds:getIntersection(myBounds):area() > 0 then
            return actor
        end
    end
    return nil
end

function CanTalkToNpcs:onInteract()
    local npc = self:getCurrentNpc()
    if npc then
        debugLog("talked to ", npc.name)
        return true
    end

    return false
end

return CanTalkToNpcs
