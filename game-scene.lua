local Scene = require("nx/game/scene")
local scene = Scene.new()

local world = scene:addActor()
world:addComponent(Components.World)

local player = scene:addActor()
player:addComponent(Components.PlayerInput)
player:addComponent(Components.GameRect, 20, 20, "dynamic")
player:addComponent(Components.Movement, player.PlayerInput)
player:setPos(300, 300)

local wall = scene:addActor()
wall:addComponent(Components.GameRect, 199, 199, "static")
wall:setPos(800, 800)

local npc = scene:addActor()
npc:addComponent(Components.NpcInput)
npc:addComponent(Components.GameRect, 23, 23, "dynamic")
npc:addComponent(Components.Movement, npc.NpcInput)
npc:setPos(500, 500)

return scene
