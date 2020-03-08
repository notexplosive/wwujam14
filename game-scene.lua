local Scene = require("nx/game/scene")
local Task = require("data/task")
local scene = Scene.new()

local world = scene:addActor()
world:addComponent(Components.Viewport, 1)
world:addComponent(Components.CloseOnEscape)

function createRoom(name, pos, size, imageName)
	assert(name and pos and size)

	local room = scene:addActor()
	room.name = name
	room:setPos(pos)
	room:addComponent(Components.BoundingBox, size:wh())
	room:addComponent(Components.BoundingBoxRenderer)
	room:addComponent(Components.Room, 250)
	room:addComponent(Components.TextRenderer, name)
	room:addComponent(Components.BackgroundRenderer, imageName or "background-brick")

	return room
end

function createItem(room, x, itemName, imageNameIfDifferent)
	assert(room and x and itemName)

	local item = scene:addActor()
	item:setPos(room:pos().x + x, room:pos().y)
	item:addComponent(Components.Collider, 20)
	item:addComponent(Components.Item, itemName)
	item:addComponent(Components.ImageRenderer, imageNameIfDifferent or itemName)
	item.name = itemName
	return item
end

function createPlayer(room, x)
	assert(room and x)

	local player = scene:addActor()
	player:setPos(room:pos().x + x, room:pos().y)
	player.name = "Player"
	player:addComponent(Components.CanInteract)
	player:addComponent(Components.CanHoldItems)
	player:addComponent(Components.CanTraverseDoors)
	player:addComponent(Components.CanTalkToNpcs)
	player:addComponent(Components.CanDropItems)
	player:addComponent(Components.PlayerInput)
	player:addComponent(Components.Collider, 20)
	player:addComponent(Components.Movement, player.PlayerInput)
	player:addComponent(Components.MovementSpriteRenderer, "adrian")
	player:addComponent(Components.CameraIsOnMe)

	return player
end

function createNPC(room, x, name, spriteName)
	assert(room and x and name)
	local npc = scene:addActor()
	npc.name = name
	npc:setPos(room:pos().x + x, room:pos().y)
	npc:addComponent(Components.CanInteract)
	npc:addComponent(Components.CanHoldItems)
	npc:addComponent(Components.CanTraverseDoors)
	npc:addComponent(Components.CanDropItems)
	npc:addComponent(Components.NpcInput)
	npc:addComponent(Components.Collider, 20)
	npc:addComponent(Components.Movement, npc.NpcInput)
	npc:addComponent(Components.Plan)
	npc:addComponent(Components.MovementSpriteRenderer, spriteName or "adrian")

	return npc
end

function createDoorPair(room1, room1X, room2, room2X)
	local doorWidth = 100
	local door1 = scene:addActor()
	door1:setPos(room1:pos().x + room1X, room1:pos().y)
	door1:addComponent(Components.Collider, doorWidth)
	door1:addComponent(Components.ImageRenderer, "door")

	local door2 = scene:addActor()
	door2:setPos(room2:pos().x + room2X, room2:pos().y)
	door2:addComponent(Components.Collider, doorWidth)
	door2:addComponent(Components.ImageRenderer, "door")

	door1:addComponent(Components.Door, door2)
	door2:addComponent(Components.Door, door1)

	door1.name = room1.name .. " Door"
	door2.name = room2.name .. " Door"
end

function validateRooms(roomList)
	for i, roomActor1 in ipairs(roomList) do
		local r1 = roomActor1.BoundingBox:getRect()
		for j, roomActor2 in ipairs(roomList) do
			if i ~= j then
				local r2 = roomActor2.BoundingBox:getRect()
				assert(r1:getIntersection(r2):area() == 0, roomActor1.name .. " overlaps with " .. roomActor2.name)
			end
		end
	end
end

--------------------------------------------
--------------------------------------------
--------------------------------------------
--------------------------------------------

GLOBAL_ROOMS = {
	-------------------------------------------------------------------
	createRoom("Foyer", Vector.new(0, 0), Size.new(750, 300), "background-brick"), --1
	createRoom("Hallway Upstairs One", Vector.new(0, 500), Size.new(750, 300), "background-brick"), --2
	createRoom("Library", Vector.new(0, 1000), Size.new(500, 300), "background-brick"), --3
	createRoom("Balcony", Vector.new(0, 1500), Size.new(500, 300), "background-brick"), --4
	createRoom("Hallway Upstairs Two", Vector.new(0, 2000), Size.new(1000, 300), "background-brick"), --5
	createRoom("Bathroom", Vector.new(0, 2500), Size.new(400, 300), "background-brick"), --6
	createRoom("Dining Room", Vector.new(0, 3000), Size.new(750, 300), "background-brick"), --7
	createRoom("Courtyard", Vector.new(0, 3500), Size.new(500, 300), "background-brick"), --8
	createRoom("Kitchen", Vector.new(0, 4000), Size.new(500, 300), "background-brick"), --9
	createRoom("Living Room", Vector.new(0, 4500), Size.new(500, 300), "background-brick"), --10
	createRoom("Hallway Downstairs Three", Vector.new(0, 5000), Size.new(500, 300), "background-brick"), --11
	createRoom("Rec Room", Vector.new(0, 5500), Size.new(750, 300), "background-brick"), --12
	createRoom("Hallway Downstairs Five", Vector.new(0, 6000), Size.new(750, 300), "background-brick"), --13
	createRoom("Hallway Downstairs One", Vector.new(0, 6500), Size.new(750, 300), "background-brick"), --14
	--Cult Room
	createRoom("NPC ONE", Vector.new(0, 7000), Size.new(5000, 300), "background-brick"), --15
	createRoom("NPC TWO", Vector.new(0, 7500), Size.new(500, 300), "background-brick"), --16
	createRoom("NPC THREE", Vector.new(0, 8000), Size.new(500, 300), "background-brick"), --17
	createRoom("NPC FOUR", Vector.new(0, 8500), Size.new(500, 300), "background-brick") --18
}
validateRooms(GLOBAL_ROOMS)

createDoorPair(GLOBAL_ROOMS[1], 50, GLOBAL_ROOMS[2], 50)
createDoorPair(GLOBAL_ROOMS[1], 700, GLOBAL_ROOMS[14], 50)
createDoorPair(GLOBAL_ROOMS[2], 450, GLOBAL_ROOMS[4], 50)
createDoorPair(GLOBAL_ROOMS[2], 275, GLOBAL_ROOMS[3], 50)
createDoorPair(GLOBAL_ROOMS[3], 450, GLOBAL_ROOMS[5], 50)
createDoorPair(GLOBAL_ROOMS[5], 350, GLOBAL_ROOMS[15], 50)
createDoorPair(GLOBAL_ROOMS[5], 650, GLOBAL_ROOMS[6], 50)
createDoorPair(GLOBAL_ROOMS[5], 950, GLOBAL_ROOMS[7], 50)
createDoorPair(GLOBAL_ROOMS[7], 375, GLOBAL_ROOMS[8], 50)
createDoorPair(GLOBAL_ROOMS[7], 700, GLOBAL_ROOMS[9], 50)
createDoorPair(GLOBAL_ROOMS[9], 450, GLOBAL_ROOMS[10], 50)
createDoorPair(GLOBAL_ROOMS[10], 450, GLOBAL_ROOMS[11], 50)
createDoorPair(GLOBAL_ROOMS[11], 450, GLOBAL_ROOMS[12], 50)
createDoorPair(GLOBAL_ROOMS[12], 375, GLOBAL_ROOMS[14], 700)
createDoorPair(GLOBAL_ROOMS[12], 700, GLOBAL_ROOMS[13], 50)
createDoorPair(GLOBAL_ROOMS[13], 375, GLOBAL_ROOMS[16], 50)
createDoorPair(GLOBAL_ROOMS[13], 700, GLOBAL_ROOMS[17], 50)
createDoorPair(GLOBAL_ROOMS[14], 375, GLOBAL_ROOMS[18], 50)

local player = createPlayer(GLOBAL_ROOMS[1], 100)

--[[
createItem(GLOBAL_ROOMS[1], 160, "plate", "cake")
createItem(GLOBAL_ROOMS[2], 250, "fork", "cake")
createItem(GLOBAL_ROOMS[2], 350, "spoon", "cake")
]]
--[[
local mary = createNPC(GLOBAL_ROOMS[1], 100, "Mary")
]]
local gary = createNPC(GLOBAL_ROOMS[1], 150, "Gary")
gary.Plan:addAction(Components.GetItemInRoom, "spork")
gary.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[4])
--[[
local john = createNPC(GLOBAL_ROOMS[2], 300, "John")

local johnPlan = john.Plan
johnPlan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[1])
johnPlan:addAction(Components.GetItemInRoom, "plate")
johnPlan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[4])
johnPlan:addAction(Components.DropItemInRoom)
johnPlan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[2])
johnPlan:addAction(Components.GetItemInRoom, "fork")
johnPlan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[4])
johnPlan:addAction(Components.DropItemInRoom)
]]
return scene
