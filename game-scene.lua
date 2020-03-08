local Scene = require("nx/game/scene")
local Task = require("wwu/data/task")
local Plan = require("wwu/data/plan")
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

local room1 = createRoom(100, 200, 500, 300, 250)
local room2 = createRoom(800, 50, 500, 300, 250)

local door = scene:addActor()
door:setPos(125, 200)
door:addComponent(Components.Collider, 40)

local door2 = scene:addActor()
door2:setPos(900, 200)
door2:addComponent(Components.Collider, 40)

door:addComponent(Components.Door, door2)
door2:addComponent(Components.Door, door)

local player = createPlayer(room1, 300)

createItem(room1, 90, "plate")

local garyPlan = Plan.new()
local gary = createNPC(room1, 300, "Gary", garyPlan)

local johnPlan = Plan.new()
local john = createNPC(room1, 100, "John", johnPlan)

garyPlan:appendTask(
	Task.new(
		"wait",
		gary,
		function(actor, target)
			return false
		end
	)
)
johnPlan:appendTask(
	Task.new(
		"interact",
		gary,
		function(actor, target)
			if actor:pos():distanceTo(target:pos()) < 50 then
				return true
			else
				return false
			end
		end
	)
)

return scene
