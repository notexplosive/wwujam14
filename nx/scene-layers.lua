local Scene = require("nx/game/scene")
local SceneLayers = {}

function SceneLayers.new()
    local self = newObject(SceneLayers)
    self.list = {}
    return self
end

function SceneLayers:eachInDrawOrder()
    return ipairs(self.list)
end

function SceneLayers:eachInReverseDrawOrder()
    local reversedList = copyReversed(self.list)
    return ipairs(reversedList)
end

function SceneLayers:add(scene)
    assert(scene:type() == Scene)
    append(self.list, scene)
end

function SceneLayers:set(index, scene)
    self.list[index] = scene
    return scene
end

function SceneLayers:get(index)
    assert(self.list[index], "No scene at layer " .. index)
    return self.list[index]
end

-- Singleton!
return SceneLayers.new()
