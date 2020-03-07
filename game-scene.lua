local Scene = require("nx/game/scene")
local scene = Scene.new()

local world = scene:addActor()
world:addComponent(Components.World)

local player = scene:addActor()
player:addComponent(Components.PlayerInput)
player:addComponent(Components.Body, "dynamic")
player:addComponent(Components.RectangleShape, 20, 20, 1)
player:addComponent(Components.RectRenderer, 20, 20)
player:addComponent(Components.Movement, player.PlayerInput)
player:setPos(300, 300)

local wall = scene:addActor()
wall:addComponent(Components.Body, "static")
wall:addComponent(Components.RectangleShape, 199, 199, 1)
wall:addComponent(Components.RectRenderer, 199, 199)
wall:setPos(800, 800)

local npc = scene:addActor()
npc:addComponent(Components.NpcInput)
npc:addComponent(Components.Body, "dynamic")
npc:addComponent(Components.RectangleShape, 23, 23, 1)
npc:addComponent(Components.RectRenderer, 23, 23)
npc:addComponent(Components.Movement, npc.NpcInput)
npc:setPos(500, 500)

return scene
