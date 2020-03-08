local Scene = require("nx/game/scene")
local Task = require("wwu/data/task")
local Plan = require("wwu/data/plan")
local scene = Scene.new()

local world = scene:addActor()
world:addComponent(Components.Viewport, 1)

local function createRoom(x, y, w, h, floorHeight)
	assert(x and y and w and h)

	local room = scene:addActor()
	room:setPos(x, y)
	room:addComponent(Components.BoundingBox, w, h)
	room:addComponent(Components.BoundingBoxRenderer)
	room:addComponent(Components.Room, floorHeight or 250)

	return room
end

createRoom(100, 0, 500, 300, 250)
createRoom(800, 50, 500, 300, 250)

local door = scene:addActor()
door:setPos(125, 200)
door:addComponent(Components.Collider, 40)

local door2 = scene:addActor()
door2:setPos(900, 200)
door2:addComponent(Components.Collider, 40)

door:addComponent(Components.Door, door2)
door2:addComponent(Components.Door, door)

local player = scene:addActor()
player:setPos(300, 200)
player:addComponent(Components.PlayerInput)
player:addComponent(Components.Collider, 20)
player:addComponent(Components.Movement, player.PlayerInput)
player:addComponent(Components.CanTraverseDoors)
player:addComponent(Components.Inventory)

function createItem(x, y)
	assert(x and y)

	local item = scene:addActor()
	item:setPos(x, y)
	item:addComponent(Components.Collider, 20)
	item:addComponent(Components.CircleRenderer, 5)
	item:addComponent(Components.Item)
	return item
end

createItem(400, 200)

function createNPC()
end

local garyPlan = Plan.new()
local gary = scene:addActor()
gary:setPos(500, 200)
gary:addComponent(Components.NpcInput, garyPlan)
gary:addComponent(Components.Collider, 23)
gary:addComponent(Components.Movement, gary.NpcInput)

local johnPlan = Plan.new()
local john = scene:addActor()
john:setPos(250, 200)
john:addComponent(Components.NpcInput, johnPlan)
john:addComponent(Components.Collider, 23)
john:addComponent(Components.Movement, john.NpcInput)

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
