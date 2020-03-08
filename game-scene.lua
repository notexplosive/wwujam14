local Scene = require("nx/game/scene")
local Task = require("data/task")
local scene = Scene.new()

local world = scene:addActor()
world:addComponent(Components.Viewport, 1)
world:addComponent(Components.CloseOnEscape)

function createRoom(name, pos, size, floorHeight)
	assert(name and pos and size)

	local room = scene:addActor()
	room.name = name
	room:setPos(pos)
	room:addComponent(Components.BoundingBox, size:wh())
	room:addComponent(Components.BoundingBoxRenderer)
	room:addComponent(Components.Room, floorHeight or 250)
	room:addComponent(Components.TextRenderer, name)
	return room
end

function createItem(room, x, itemName)
	assert(room and x and itemName)

	local item = scene:addActor()
	item:setPos(room:pos().x + x, room:pos().y)
	item:addComponent(Components.Collider, 20)
	item:addComponent(Components.CircleRenderer, 5)
	item:addComponent(Components.Item, itemName)
	item.name = itemName
	return item
end

function createPlayer(room, x)
	assert(room and x)

	local player = scene:addActor()
	player:setPos(room:pos().x + x, room:pos().y)
	player.name = "Player"
	player:addComponent(Components.CanInteract)
	player:addComponent(Components.PlayerInput)
	player:addComponent(Components.Collider, 20)
	player:addComponent(Components.Movement, player.PlayerInput)
	player:addComponent(Components.CanTraverseDoors)
	player:addComponent(Components.Inventory)

	return player
end

function createNPC(room, x, name)
	assert(room and x and name)
	local npc = scene:addActor()
	npc.name = name
	npc:setPos(room:pos().x + x, room:pos().y)
	npc:addComponent(Components.CanInteract)
	npc:addComponent(Components.CanTraverseDoors)
	npc:addComponent(Components.NpcInput)
	npc:addComponent(Components.Collider, 20)
	npc:addComponent(Components.Movement, npc.NpcInput)
	npc:addComponent(Components.Inventory)

	return npc
end

function createDoorPair(room1, room1X, room2, room2X)
	local doorWidth = 40
	local door1 = scene:addActor()
	door1:setPos(room1:pos().x + room1X, room1:pos().y)
	door1:addComponent(Components.Collider, doorWidth)

	local door2 = scene:addActor()
	door2:setPos(room2:pos().x + room2X, room2:pos().y)
	door2:addComponent(Components.Collider, doorWidth)

	door1:addComponent(Components.Door, door2)
	door2:addComponent(Components.Door, door1)

	door1.name = room1.name .. " Door"
	door2.name = room2.name .. " Door"
end

--------------------------------------------
--------------------------------------------
--------------------------------------------
--------------------------------------------

local room1 = createRoom("Room1", Vector.new(100, 200), Size.new(500, 300), 250)
local room2 = createRoom("Room2", Vector.new(800, 50), Size.new(500, 300), 250)
local room3 = createRoom("Room3", Vector.new(800, 500), Size.new(500, 300), 250)
local room4 = createRoom("Room4", Vector.new(300, 500), Size.new(500, 300), 250)

createDoorPair(room1, 50, room2, 50)
createDoorPair(room2, 200, room3, 50)
createDoorPair(room2, 100, room4, 50)

local player = createPlayer(room1, 300)

createItem(room1, 90, "plate")
createItem(room2, 90, "fork")

local gary = createNPC(room1, 300, "Gary")
gary:addComponent(Components.PathfindToRoom, room3)

local john = createNPC(room2, 300, "John")
john:addComponent(Components.Plan)

local johnPlan = john.Plan
johnPlan:addAction(Components.PathfindToRoom, room1)
johnPlan:addAction(Components.GetItemInRoom, "plate")
johnPlan:addAction(Components.PathfindToRoom, room4)
--johnPlan:addAction(Components.DropItem)

--[[
	John is in room 2
	John goes to room 1
	John picks up the plate
	John puts the plate in room 4
]]
return scene
