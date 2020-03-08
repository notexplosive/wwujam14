local sceneLayers = require("nx/scene-layers")
local CanTalkToNpcs = {}

registerComponent(CanTalkToNpcs, "CanTalkToNpcs")

function CanTalkToNpcs:awake()
    self.cooldown = 0
end

function CanTalkToNpcs:update(dt)
    self.cooldown = self.cooldown - dt
end

function CanTalkToNpcs:getCurrentNpc()
    if self.cooldown > 0 then
        return nil
    end

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
        self.cooldown = 0.25
        local uiScene = sceneLayers:get(2)
        assert(uiScene)
        local dialog = uiScene:addActor()
        dialog:addComponent(Components.BlockingUI, self.actor:scene())
        dialog:addComponent(Components.DeferredComponent, Components.DestroyOnKeys, "down", "space")
        dialog:addComponent(Components.TextBox, npc.Plan:report())

        return true
    end

    return false
end

return CanTalkToNpcs
