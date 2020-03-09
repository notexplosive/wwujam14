local Scene = require("nx/game/scene")
local Task = require("data/task")
local scene = Scene.new()

local world = scene:addActor()
world:addComponent(Components.Viewport, 1)
world:addComponent(Components.CloseOnEscape)

local itemShader = love.graphics.newShader("assets/shaders/item_highlight_temp.glsl")

function createRoom(name, pos, size, imageName, lockedToPlayer)
	assert(name and pos and size)

	local room = scene:addActor()
	room.name = name
	room:setPos(pos)
	room:addComponent(Components.BoundingBox, size:wh())
	room:addComponent(Components.Room, 250, lockedToPlayer)
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
	item:addComponent(Components.ImageRenderer, imageNameIfDifferent or itemName, true)
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
	player:addComponent(Components.MovementSpriteRenderer, "dave")
	player:addComponent(Components.CameraIsOnMe)

	return player
end

function createNPC(room, x, name, spriteName, optionalSpeed)
	assert(room and x and name)
	local npc = scene:addActor()
	npc.name = name
	npc:setPos(room:pos().x + x, room:pos().y)
	npc:addComponent(Components.CanInteract)
	npc:addComponent(Components.CanHoldItems)
	npc:addComponent(Components.CanTraverseDoors)
	npc:addComponent(Components.CanDropItems)
	npc:addComponent(Components.NpcInput, optionalSpeed)
	npc:addComponent(Components.Collider, 20)
	npc:addComponent(Components.Movement, npc.NpcInput)
	npc:addComponent(Components.Plan)
	npc:addComponent(Components.MovementSpriteRenderer, spriteName or "adrian")
	npc.shader = itemShader

	return npc
end
function createBackgroundObject(room, x, y, spriteName)
	assert(room and x and spriteName)
	local object = scene:addActor()
	object:setPos(room:pos().x + x, room:pos().y + y + 150)
	object:addComponent(Components.ImageRenderer, spriteName)
end
function createDoorPair(room1, room1X, room2, room2X, imageName)
	local doorWidth = 100
	local door1 = scene:addActor()
	door1:setPos(room1:pos().x + room1X, room1:pos().y)
	door1:addComponent(Components.Collider, doorWidth)
	door1:addComponent(Components.ImageRenderer, imageName or "door")

	local door2 = scene:addActor()
	door2:setPos(room2:pos().x + room2X, room2:pos().y)
	door2:addComponent(Components.Collider, doorWidth)
	door2:addComponent(Components.ImageRenderer, imageName or "door")

	door1:addComponent(Components.Door, door2)
	door2:addComponent(Components.Door, door1)

	door1.name = room2.name .. " Door"
	door2.name = room1.name .. " Door"
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
	createRoom("Foyer", Vector.new(0, 0), Size.new(1000, 300), "background-wood"), --1
	createRoom("Hallway Upstairs One", Vector.new(0, 1000), Size.new(600, 300), "background-brick"), --2
	createRoom("Library", Vector.new(0, 2000), Size.new(750, 300), "background-wood"), --3
	createRoom("Balcony", Vector.new(0, 3000), Size.new(750, 300), "background-balcony"), --4
	createRoom("Hallway Upstairs Two", Vector.new(0, 4000), Size.new(1000, 300), "background-brick"), --5
	createRoom("Bathroom", Vector.new(0, 5000), Size.new(500, 300), "background-kitchen"), --6
	createRoom("Dining Room", Vector.new(0, 6000), Size.new(1000, 300), "background-wood"), --7
	createRoom("Courtyard", Vector.new(0, 7000), Size.new(750, 300), "background-courtyard"), --8
	createRoom("Kitchen", Vector.new(0, 8000), Size.new(750, 300), "background-kitchen"), --9
	createRoom("Living Room", Vector.new(0, 9000), Size.new(750, 300), "background-wood"), --10
	createRoom("Hallway Downstairs Two", Vector.new(0, 10000), Size.new(750, 300), "background-brick"), --11
	createRoom("Rec Room", Vector.new(0, 11000), Size.new(1000, 300), "background-wood"), --12
	createRoom("Hallway Downstairs Three", Vector.new(0, 120000), Size.new(800, 300), "background-brick"), --13
	createRoom("Hallway Downstairs One", Vector.new(0, 13000), Size.new(800, 300), "background-brick"), --14
	--Cult Room
	createRoom("NPC ONE", Vector.new(0, 14000), Size.new(5000, 300), "background-brick", true), --15
	createRoom("NPC TWO", Vector.new(0, 15000), Size.new(500, 300), "background-brick", true), --16
	createRoom("NPC THREE", Vector.new(0, 16000), Size.new(500, 300), "background-brick", true), --17
	createRoom("NPC FOUR", Vector.new(0, 17000), Size.new(500, 300), "background-brick", true) --18
}
validateRooms(GLOBAL_ROOMS)

createDoorPair(GLOBAL_ROOMS[1], 50, GLOBAL_ROOMS[2], 50, "stair")
createDoorPair(GLOBAL_ROOMS[1], 700, GLOBAL_ROOMS[14], 50)
createDoorPair(GLOBAL_ROOMS[2], 450, GLOBAL_ROOMS[4], 50, "door-outside")
createDoorPair(GLOBAL_ROOMS[2], 275, GLOBAL_ROOMS[3], 50)
createDoorPair(GLOBAL_ROOMS[3], 450, GLOBAL_ROOMS[5], 50)
createDoorPair(GLOBAL_ROOMS[5], 350, GLOBAL_ROOMS[15], 50, "door-blocked")
createDoorPair(GLOBAL_ROOMS[5], 650, GLOBAL_ROOMS[6], 50)
createDoorPair(GLOBAL_ROOMS[5], 950, GLOBAL_ROOMS[7], 50, "stair")
createDoorPair(GLOBAL_ROOMS[7], 375, GLOBAL_ROOMS[8], 50, "door-outside")
createDoorPair(GLOBAL_ROOMS[7], 700, GLOBAL_ROOMS[9], 50)
createDoorPair(GLOBAL_ROOMS[9], 450, GLOBAL_ROOMS[10], 50)
createDoorPair(GLOBAL_ROOMS[10], 450, GLOBAL_ROOMS[11], 50)
createDoorPair(GLOBAL_ROOMS[11], 450, GLOBAL_ROOMS[12], 50)
createDoorPair(GLOBAL_ROOMS[12], 375, GLOBAL_ROOMS[14], 700)
createDoorPair(GLOBAL_ROOMS[12], 700, GLOBAL_ROOMS[13], 50)
createDoorPair(GLOBAL_ROOMS[13], 375, GLOBAL_ROOMS[16], 50, "door-blocked")
createDoorPair(GLOBAL_ROOMS[13], 700, GLOBAL_ROOMS[17], 50, "door-blocked")
createDoorPair(GLOBAL_ROOMS[14], 375, GLOBAL_ROOMS[18], 50, "door-blocked")

-- BACKGROUND ITEMS
createBackgroundObject(GLOBAL_ROOMS[10], 250, 110, "couch")
createBackgroundObject(GLOBAL_ROOMS[6], 375, 100, "bathtub")
createBackgroundObject(GLOBAL_ROOMS[6], 150, 100, "sink")
createBackgroundObject(GLOBAL_ROOMS[9], 150, 100, "sink")
createBackgroundObject(GLOBAL_ROOMS[3], 200, 110, "bookcase")
createBackgroundObject(GLOBAL_ROOMS[3], 600, 110, "bookcase")
createBackgroundObject(GLOBAL_ROOMS[9], 285, 100, "table")
createBackgroundObject(GLOBAL_ROOMS[9], 635, 100, "table")
createBackgroundObject(GLOBAL_ROOMS[7], 535, 100, "table")
createBackgroundObject(GLOBAL_ROOMS[12], 220, 100, "pool-table")
createBackgroundObject(GLOBAL_ROOMS[13], 540, 000, "chalkboard")

createBackgroundObject(GLOBAL_ROOMS[1], 375, 0, "painting-1")
createBackgroundObject(GLOBAL_ROOMS[11], 200, 0, "painting-2")
createBackgroundObject(GLOBAL_ROOMS[14], 200, 0, "painting-3")
createBackgroundObject(GLOBAL_ROOMS[1], 200, 0, "window")
createBackgroundObject(GLOBAL_ROOMS[1], 550, 0, "window")
createBackgroundObject(GLOBAL_ROOMS[11], 600, 0, "window")
createBackgroundObject(GLOBAL_ROOMS[14], 525, 0, "window")

-- /BACKGROUND ITEMS

local player = createPlayer(GLOBAL_ROOMS[9], 100)
--Items
createItem(GLOBAL_ROOMS[10], 350, "candle")
createItem(GLOBAL_ROOMS[7], 215, "candle")
createItem(GLOBAL_ROOMS[3], 370, "candle")
createItem(GLOBAL_ROOMS[3], 130, "candle")
createItem(GLOBAL_ROOMS[8], 430, "candle")
createItem(GLOBAL_ROOMS[8], 150, "candle")
createItem(GLOBAL_ROOMS[11], 245, "candle")
createItem(GLOBAL_ROOMS[12], 460, "holly", "holly")
createItem(GLOBAL_ROOMS[9], 370, "holly", "holly")
createItem(GLOBAL_ROOMS[4], 500, "holly", "holly")
createItem(GLOBAL_ROOMS[3], 300, "knife", "sword")

createItem(GLOBAL_ROOMS[9], 220, "knife", "knife")
createItem(GLOBAL_ROOMS[9], 150, "knife", "knife")
createItem(GLOBAL_ROOMS[13], 540, "chalk", "chalk")
createItem(GLOBAL_ROOMS[12], 150, "chalk", "chalk")
createItem(GLOBAL_ROOMS[9], 310, "organ", "liver")
createItem(GLOBAL_ROOMS[8], 650, "organ", "bunny")

createItem(GLOBAL_ROOMS[14], 200, "spork", "spork")

createItem(GLOBAL_ROOMS[4], 280, "plant", "pot-plant")
createItem(GLOBAL_ROOMS[10], 150, "plant", "pot-plant")
createItem(GLOBAL_ROOMS[8], 350, "plant", "pot-plant")
createItem(GLOBAL_ROOMS[8], 210, "plant", "pot-plant")
createItem(GLOBAL_ROOMS[12], 560, "plant", "pot-plant")

createItem(GLOBAL_ROOMS[3], 600, "book", "book")

--junk items
createItem(GLOBAL_ROOMS[10], 710, "junk", "globe")
createItem(GLOBAL_ROOMS[9], 625, "junk", "cake")
createItem(GLOBAL_ROOMS[6], 250, "junk", "mirror")
createItem(GLOBAL_ROOMS[7], 570, "junk", "plate")
--items

--15 cult room
local taylor = createNPC(GLOBAL_ROOMS[15], 150, "Taylor", "taylor")
local josie = createNPC(GLOBAL_ROOMS[18], 150, "Josie", "josie", 175)
local oldDude = createNPC(GLOBAL_ROOMS[1], 150, "Guy Jenkins Fury", "old-dude", 150)
local adrian = createNPC(GLOBAL_ROOMS[1], 250, "Adrian", "adrian", 75)
local frank = createNPC(GLOBAL_ROOMS[16], 250, "Frank", "frank")
local kate = createNPC(GLOBAL_ROOMS[16], 250, "Kate", "kate", 125)
--
taylor.Plan:addAction(Components.GetItemInRoom, "candle")
taylor.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[15])
taylor.Plan:addAction(Components.DropItemInRoom)

taylor.Plan:addAction(Components.GetItemInRoom, "knife")
taylor.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[15])
taylor.Plan:addAction(Components.DropItemInRoom)

taylor.Plan:addAction(Components.GetItemInRoom, "candle")
taylor.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[15])
taylor.Plan:addAction(Components.DropItemInRoom)

taylor.Plan:addAction(Components.GetItemInRoom, "holly")
taylor.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[15])
taylor.Plan:addAction(Components.DropItemInRoom)

taylor.Plan:addAction(Components.GetItemInRoom, "candle")
taylor.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[15])
taylor.Plan:addAction(Components.DropItemInRoom)

taylor.Plan:addAction(Components.GetItemInRoom, "organ")
taylor.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[15])
taylor.Plan:addAction(Components.DropItemInRoom)

taylor.Plan:addAction(Components.GetItemInRoom, "candle")
taylor.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[15])
taylor.Plan:addAction(Components.DropItemInRoom)

taylor.Plan:addAction(Components.GetItemInRoom, "chalk")
taylor.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[15])
taylor.Plan:addAction(Components.DropItemInRoom)

taylor.Plan:addAction(Components.GetItemInRoom, "candle")
taylor.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[15])
taylor.Plan:addAction(Components.DropItemInRoom)

taylor.Plan:addAction(Components.GetItemInRoom, "holly")
taylor.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[15])
taylor.Plan:addAction(Components.DropItemInRoom)

taylor.Plan:addAction(Components.GetItemInRoom, "candle")
taylor.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[15])
taylor.Plan:addAction(Components.DropItemInRoom)

--random Candle mover

josie.Plan:addAction(Components.GetItemInRoom, "candle")
josie.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[4])
josie.Plan:addAction(Components.DropItemInRoom)

josie.Plan:addAction(Components.GetItemInRoom, "candle")
josie.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[8])
josie.Plan:addAction(Components.DropItemInRoom)

josie.Plan:addAction(Components.GetItemInRoom, "candle")
josie.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[12])
josie.Plan:addAction(Components.DropItemInRoom)

josie.Plan:addAction(Components.GetItemInRoom, "candle")
josie.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[12])
josie.Plan:addAction(Components.DropItemInRoom)

josie.Plan:addAction(Components.NPCWait, 5)

josie.Plan:addAction(Components.GetItemInRoom, "candle")
josie.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[1])
josie.Plan:addAction(Components.DropItemInRoom)

josie.Plan:addAction(Components.GetItemInRoom, "candle")
josie.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[6])
josie.Plan:addAction(Components.DropItemInRoom)

josie.Plan:addAction(Components.GetItemInRoom, "candle")
josie.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[9])
josie.Plan:addAction(Components.DropItemInRoom)

josie.Plan:addAction(Components.GetItemInRoom, "candle")
josie.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[9])
josie.Plan:addAction(Components.DropItemInRoom)

josie.Plan:addAction(Components.NPCWait, 5)

josie.Plan:addAction(Components.GetItemInRoom, "candle")
josie.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[7])
josie.Plan:addAction(Components.DropItemInRoom)

josie.Plan:addAction(Components.GetItemInRoom, "candle")
josie.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[4])
josie.Plan:addAction(Components.DropItemInRoom)

josie.Plan:addAction(Components.GetItemInRoom, "candle")
josie.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[5])
josie.Plan:addAction(Components.DropItemInRoom)

josie.Plan:addAction(Components.GetItemInRoom, "candle")
josie.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[1])
josie.Plan:addAction(Components.DropItemInRoom)

josie.Plan:addAction(Components.NPCWait, 5)

josie.Plan:addAction(Components.GetItemInRoom, "candle")
josie.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[13])
josie.Plan:addAction(Components.DropItemInRoom)

--Plant theif

oldDude.Plan:addAction(Components.GetItemInRoom, "plant")
oldDude.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[15])
oldDude.Plan:addAction(Components.DropItemInRoom)
oldDude.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[5])

oldDude.Plan:addAction(Components.GetItemInRoom, "plant")
oldDude.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[18])
oldDude.Plan:addAction(Components.DropItemInRoom)
oldDude.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[14])

oldDude.Plan:addAction(Components.NPCWait, 5)

oldDude.Plan:addAction(Components.GetItemInRoom, "plant")
oldDude.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[18])
oldDude.Plan:addAction(Components.DropItemInRoom)
oldDude.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[14])

oldDude.Plan:addAction(Components.GetItemInRoom, "plant")
oldDude.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[15])
oldDude.Plan:addAction(Components.DropItemInRoom)
oldDude.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[5])

oldDude.Plan:addAction(Components.NPCWait, 5)

oldDude.Plan:addAction(Components.GetItemInRoom, "plant")
oldDude.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[15])
oldDude.Plan:addAction(Components.DropItemInRoom)
oldDude.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[5])

--spork hunter
adrian.Plan:addAction(Components.GetItemInRoom, "spork")
adrian.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[9])

--reader
frank.Plan:addAction(Components.GetItemInRoom, "book")
frank.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[16])
frank.Plan:addAction(Components.NPCWait, 30)
frank.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[3])
frank.Plan:addAction(Components.NPCWait, 5)
frank.Plan:addAction(Components.DropItemInRoom)
frank.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[16])
frank.Plan:addAction(Components.NPCWait, 60)

--kate
local kateRooms = {7, 3, 2, 1, 5, 6, 8, 10, 14, 13, 4, 9, 12, 11}
for i, v in ipairs(kateRooms) do
	kate.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[kateRooms[i]])
	kate.Plan:addAction(Components.GetItemInRoom, "junk")
	kate.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[i])
	kate.Plan:addAction(Components.NPCWait, 5)
	kate.Plan:addAction(Components.DropItemInRoom)
end
return scene
