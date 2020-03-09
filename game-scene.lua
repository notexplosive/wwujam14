local Scene = require("nx/game/scene")
local Task = require("data/task")
local scene = Scene.new()

local world = scene:addActor()
world:addComponent(Components.Viewport, 1)
world:addComponent(Components.CloseOnEscape)

local itemShader = love.graphics.newShader( "assets/shaders/item_highlight_temp.glsl" )

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
	npc.shader = itemShader

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
	createRoom("Foyer", Vector.new(0, 0), Size.new(750, 300), "background-brick"), --1
	createRoom("Hallway Upstairs One", Vector.new(0, 500), Size.new(750, 300), "background-brick"), --2
	createRoom("Library", Vector.new(0, 1000), Size.new(500, 300), "background-brick"), --3
	createRoom("Balcony", Vector.new(0, 1500), Size.new(500, 300), "background-balcony"), --4
	createRoom("Hallway Upstairs Two", Vector.new(0, 2000), Size.new(1000, 300), "background-brick"), --5
	createRoom("Bathroom", Vector.new(0, 2500), Size.new(400, 300), "background-kitchen"), --6
	createRoom("Dining Room", Vector.new(0, 3000), Size.new(750, 300), "background-brick"), --7
	createRoom("Courtyard", Vector.new(0, 3500), Size.new(500, 300), "background-courtyard"), --8
	createRoom("Kitchen", Vector.new(0, 4000), Size.new(500, 300), "background-kitchen"), --9
	createRoom("Living Room", Vector.new(0, 4500), Size.new(500, 300), "background-brick"), --10
	createRoom("Hallway Downstairs Two", Vector.new(0, 5000), Size.new(500, 300), "background-brick"), --11
	createRoom("Rec Room", Vector.new(0, 5500), Size.new(750, 300), "background-brick"), --12
	createRoom("Hallway Downstairs Three", Vector.new(0, 6000), Size.new(750, 300), "background-brick"), --13
	createRoom("Hallway Downstairs One", Vector.new(0, 6500), Size.new(750, 300), "background-brick"), --14
	--Cult Room
	createRoom("NPC ONE", Vector.new(0, 7000), Size.new(5000, 300), "background-brick", true), --15
	createRoom("NPC TWO", Vector.new(0, 7500), Size.new(500, 300), "background-brick", true), --16
	createRoom("NPC THREE", Vector.new(0, 8000), Size.new(500, 300), "background-brick", true), --17
	createRoom("NPC FOUR", Vector.new(0, 8500), Size.new(500, 300), "background-brick", true) --18
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

local player = createPlayer(GLOBAL_ROOMS[10], 100)
--[[
	1 foyer 	2 hallway up1 	3 library	4 balcony	5 hallway up2	6 bathroom	7 dining room
	8 Courtyard 	9 Kitchen	10 living room 	11 hallway down2	12 rec room	13 hallway down 3	14 hallway down 1
]]
--item name, item image
createItem(GLOBAL_ROOMS[10], 350, "candle")
createItem(GLOBAL_ROOMS[7], 215, "candle")
createItem(GLOBAL_ROOMS[3], 370, "candle")
createItem(GLOBAL_ROOMS[3], 130, "candle")
createItem(GLOBAL_ROOMS[8], 430, "candle")
createItem(GLOBAL_ROOMS[8], 150, "candle")
createItem(GLOBAL_ROOMS[11], 245, "candle")
createItem(GLOBAL_ROOMS[12], 460, "holly", "holly")
createItem(GLOBAL_ROOMS[9], 370, "holly", "holly")
createItem(GLOBAL_ROOMS[4], 430, "holly", "holly")
createItem(GLOBAL_ROOMS[3], 250, "knife", "knife")
--sword
createItem(GLOBAL_ROOMS[9], 220, "knife", "knife")
createItem(GLOBAL_ROOMS[9], 150, "knife", "knife")
createItem(GLOBAL_ROOMS[13], 540, "chalk", "book")
createItem(GLOBAL_ROOMS[12], 560, "chalk", "book")
createItem(GLOBAL_ROOMS[9], 310, "organs", "cake")
createItem(GLOBAL_ROOMS[8], 465, "bunny", "card")

--createItem(GLOBAL_ROOMS[1], 160, "spork", "cake")

createItem(GLOBAL_ROOMS[4], 160, "plant", "holly")
createItem(GLOBAL_ROOMS[10], 150, "plant", "holly")
createItem(GLOBAL_ROOMS[8], 350, "plant", "holly")
createItem(GLOBAL_ROOMS[8], 210, "plant", "holly")
createItem(GLOBAL_ROOMS[12], 150, "plant", "holly")

createItem(GLOBAL_ROOMS[3], 350, "book", "book")

--[[
createItem(GLOBAL_ROOMS[1], 160, "plate", "cake")
createItem(GLOBAL_ROOMS[2], 250, "fork", "cake")
createItem(GLOBAL_ROOMS[2], 350, "spoon", "cake")
]]
--[[
local mary = createNPC(GLOBAL_ROOMS[1], 100, "Mary")
]]
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
--15 cult room
local taylor = createNPC(GLOBAL_ROOMS[15], 150, "Taylor", "taylor")
local josie = createNPC(GLOBAL_ROOMS[18], 150, "Josie", "josie")
local oldDude = createNPC(GLOBAL_ROOMS[1], 150, "Guy Jenkins Fury", "old-dude")
local adrian = createNPC(GLOBAL_ROOMS[1], 250, "Adrian", "adrian")
local frank = createNPC(GLOBAL_ROOMS[16], 250, "Frank", "frank")
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

josie.Plan:addAction(Components.GetItemInRoom, "candle")
josie.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[13])
josie.Plan:addAction(Components.DropItemInRoom)

--Plant theif

oldDude.Plan:addAction(Components.GetItemInRoom, "plant")
oldDude.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[15])
oldDude.Plan:addAction(Components.DropItemInRoom)

oldDude.Plan:addAction(Components.GetItemInRoom, "plant")
oldDude.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[18])
oldDude.Plan:addAction(Components.DropItemInRoom)

oldDude.Plan:addAction(Components.GetItemInRoom, "plant")
oldDude.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[18])
oldDude.Plan:addAction(Components.DropItemInRoom)

oldDude.Plan:addAction(Components.GetItemInRoom, "plant")
oldDude.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[15])
oldDude.Plan:addAction(Components.DropItemInRoom)

oldDude.Plan:addAction(Components.GetItemInRoom, "plant")
oldDude.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[15])
oldDude.Plan:addAction(Components.DropItemInRoom)

--spork hunter
adrian.Plan:addAction(Components.GetItemInRoom, "spork")
adrian.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[9])

--reader
frank.Plan:addAction(Components.GetItemInRoom, "book")
frank.Plan:addAction(Components.NPCWait, 5)
frank.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[16])
--wait

frank.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[3])
frank.Plan:addAction(Components.DropItemInRoom)
--wait
frank.Plan:addAction(Components.PathfindToRoom, GLOBAL_ROOMS[16])
--wait

return scene
