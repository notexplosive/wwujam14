local EndCondition = {}

registerComponent(EndCondition, "EndCondition")

function EndCondition:setup()
end

function EndCondition:awake()
    self.time = 0
end

function EndCondition:update(dt)
    self.time = self.time + dt

    if self.time > 0.25 then
        self.time = 0
        self:checkWinCondition()
    end
end

function EndCondition:checkWinCondition()
    local hollyCount = 0
    local organCount = 0
    local candleCount = 0
    local knifeCount = 0
    local chalkCount = 0

    for i, itemActor in ipairs(GLOBAL_ROOMS[15].Room:getAllActorsInRoom()) do
        if itemActor.Item then
            if itemActor.Item.itemName == "holly" then
                hollyCount = hollyCount + 1
            end

            if itemActor.Item.itemName == "organ" then
                organCount = organCount + 1
            end

            if itemActor.Item.itemName == "candle" then
                candleCount = candleCount + 1
            end

            if itemActor.Item.itemName == "knife" then
                knifeCount = knifeCount + 1
            end

            if itemActor.Item.itemName == "chalk" then
                chalkCount = chalkCount + 1
            end
        end
    end

    local sporkCondition = false
    for i, actor in ipairs(GLOBAL_ROOMS[9].Room:getAllActorsInRoom()) do
        if actor.CanHoldItems and actor.CanHoldItems:isHolding() then
            if actor.name == "Adrian" and actor.CanHoldItems:getHeldItemName() == "spork" then
                sporkCondition = true
            end
        end
    end

    if candleCount == 6 and organCount == 1 and knifeCount == 1 and chalkCount == 1 and hollyCount == 2 then
        debugLog("CULT HAS WON")
    end

    if sporkCondition then
        debugLog("ADRIAN HAS WON")
    end
end

return EndCondition
