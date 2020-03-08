local CameraIsOnMe = {}

registerComponent(CameraIsOnMe, "CameraIsOnMe", {"Floorable"})

function CameraIsOnMe:setup()
end

function CameraIsOnMe:awake()
    self.cameraActor = self.actor:scene():getFirstActorWith(Components.Viewport)
end

function CameraIsOnMe:draw(x, y)
end

function CameraIsOnMe:update(dt)
    local currentRoomActor = self.actor.Floorable:getCurrentRoom()
    if currentRoomActor then
        local roomWidth = currentRoomActor.BoundingBox:width()
        local scale = math.max(1, 1920 / roomWidth)
        self.cameraActor.Viewport:setScale(scale)

        local roomHeight = currentRoomActor.BoundingBox:height()
        local foo = (self.cameraActor.BoundingBox:height() - roomHeight) / 2
        local pos = currentRoomActor:pos()
        --if foo > 0 then
        pos.y = pos.y - foo
        --end
        self.cameraActor:setPos(pos)
    end
end

return CameraIsOnMe
