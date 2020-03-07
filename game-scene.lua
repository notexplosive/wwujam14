local Scene = require("nx/game/scene")
local scene = Scene.new()

local player = scene:addActor()
player:addComponent(Components.PlayerInput)
player:addComponent(Components.BoundingBox)
player:addComponent(Components.BoundingBoxRenderer)
player:addComponent(Components.Movement, player.PlayerInput)

return scene
