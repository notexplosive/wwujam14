local Scene = require("nx/game/scene")
local Task = require("data/task")
local Plan = require("data/plan")
local scene = Scene.new()

local world = scene:addActor()
world:addComponent(Components.Viewport, 1)

function createRoom(x, y, w, h, floorHeight)
	assert(x and y and w and h)

	local room = scene:addActor()
	room:setPos(x, y)
	room:addComponent(Components.BoundingBox, w, h)
	room:addComponent(Components.BoundingBoxRenderer)
	room:addComponent(Components.Room, floorHeight or 250)

	return room
end

function createItem(room, x, itemName)
	assert(room and x and itemName)

	local item = scene:addActor()
	item:setPos(room:pos().x + x, room:pos().y)
	item:addComponent(Components.Collider, 20)
	item:addComponent(Components.CircleRenderer, 5)
	item:addComponent(Components.Item, itemName)
	return item
end

function createPlayer(room, x)
	assert(room and x)

	local player = scene:addActor()
	player:setPos(room:pos().x + x, room:pos().y)
	player.name = "Player"
	player:addComponent(Components.PlayerInput)
	player:addComponent(Components.Collider, 20)
	player:addComponent(Components.Movement, player.PlayerInput)
	player:addComponent(Components.CanTraverseDoors)
	player:addComponent(Components.Inventory)
end

function createNPC(room, x, name, plan)
	assert(room and x and name and plan)
	local npc = scene:addActor()
	npc.name = name
	npc:setPos(room:pos().x + x, room:pos().y)
	npc:addComponent(Components.NpcInput, plan)
	npc:addComponent(Components.Collider, 20)
	npc:addComponent(Components.Movement, npc.NpcInput)
	return npc
end

function createDoorPair(room1, room1X, room2, room2X)
	local doorWidth = 40
	local door = scene:addActor()
	door:setPos(room1:pos().x + room1X, room1:pos().y)
	door:addComponent(Components.Collider, doorWidth)

	local door2 = scene:addActor()
	door2:setPos(room2:pos().x + room2X, room2:pos().y)
	door2:addComponent(Components.Collider, doorWidth)

	door:addComponent(Components.Door, door2)
	door2:addComponent(Components.Door, door)
end

--------------------------------------------
--------------------------------------------
--------------------------------------------
--------------------------------------------

local room1 = createRoom(100, 200, 500, 300, 250)
local room2 = createRoom(800, 50, 500, 300, 250)

createDoorPair(room1, 50, room2, 50)

local player = createPlayer(room1, 300)

createItem(room1, 90, "plate")

local garyPlan = Plan.new()
local gary = createNPC(room1, 300, "Gary", garyPlan)

local johnPlan = Plan.new()
local john = createNPC(room2, 100, "John", johnPlan)

return scene
