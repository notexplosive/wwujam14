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

function createItem(x, y, itemName)
	assert(x and y and itemName)

	local item = scene:addActor()
	item:setPos(x, y)
	item:addComponent(Components.Collider, 20)
	item:addComponent(Components.CircleRenderer, 5)
	item:addComponent(Components.Item, itemName)
	return item
end

function createPlayer(x, y)
	local player = scene:addActor()
	player:setPos(x, y)
	player.name = "Player"
	player:addComponent(Components.PlayerInput)
	player:addComponent(Components.Collider, 20)
	player:addComponent(Components.Movement, player.PlayerInput)
	player:addComponent(Components.CanTraverseDoors)
	player:addComponent(Components.Inventory)
end

function createNPC(x, y, name, plan)
	assert(x and y and name and plan)
	local npc = scene:addActor()
	npc.name = name
	npc:setPos(x, y)
	npc:addComponent(Components.NpcInput, plan)
	npc:addComponent(Components.Collider, 20)
	npc:addComponent(Components.Movement, npc.NpcInput)
	return npc
end

local room1 = createRoom(100, 0, 500, 300, 250)
local room2 = createRoom(800, 50, 500, 300, 250)

local door = scene:addActor()
door:setPos(125, 200)
door:addComponent(Components.Collider, 40)

local door2 = scene:addActor()
door2:setPos(900, 200)
door2:addComponent(Components.Collider, 40)

door:addComponent(Components.Door, door2)
door2:addComponent(Components.Door, door)

local player = createPlayer(300, 200)

createItem(400, 200, "plate")

local garyPlan = Plan.new()
local gary = createNPC(500, 200, "Gary", garyPlan)

local johnPlan = Plan.new()
local john = createNPC(250, 200, "John", johnPlan)

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
