local Scene = require("nx/game/scene")
local Task = require("wwu/data/task")
local Plan = require("wwu/data/plan")
local scene = Scene.new()

local world = scene:addActor()
world:addComponent(Components.Viewport, 1)

local room = scene:addActor()
room:addComponent(Components.BoundingBox, 500, 300)
room:addComponent(Components.BoundingBoxRenderer)
room:addComponent(Components.Room)
room:setPos(100, 500)

local player = scene:addActor()
player:addComponent(Components.PlayerInput)
player:addComponent(Components.Character, 20, 60)
player:addComponent(Components.Movement, player.PlayerInput)
player:setPos(300, 300)

local garyPlan = Plan.new()
local gary = scene:addActor()
gary:addComponent(Components.NpcInput, garyPlan)
gary:addComponent(Components.Character, 23, 23)
gary:addComponent(Components.Movement, gary.NpcInput)
gary:setPos(500, 500)

local johnPlan = Plan.new()
local john = scene:addActor()
john:addComponent(Components.NpcInput, johnPlan)
john:addComponent(Components.Character, 23, 23)
john:addComponent(Components.Movement, john.NpcInput)
john:setPos(250, 250)

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
