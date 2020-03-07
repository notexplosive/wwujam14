local Scene = require("nx/game/scene")
local Task = require("wwu/data/task")
local Plan = require("wwu/data/plan")
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

local garyPlan = Plan.new()
local gary = scene:addActor()
gary:addComponent(Components.NpcInput, garyPlan)
gary:addComponent(Components.GameRect, 23, 23, "dynamic")
gary:addComponent(Components.Movement, gary.NpcInput)
gary:setPos(500, 500)

local johnPlan = Plan.new()
local john = scene:addActor()
john:addComponent(Components.NpcInput, johnPlan)
john:addComponent(Components.GameRect, 23, 23, "dynamic")
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
