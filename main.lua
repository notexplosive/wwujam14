ALLOW_DEBUG = false
DEBUG = false

require("nx/util")
require("nx/input")
require("nx/debug-log")

-- Global classes, for better performance these should be require'd in each file as needed
Assets = require("nx/game/assets")
Vector = require("nx/vector")
Size = require("nx/size")
Rect = require("nx/rect")

local sceneLayers = require("nx/scene-layers")

require("nx/component-registry")

function love.update(dt)
	for _, scene in sceneLayers:eachInReverseDrawOrder() do
		scene:update(dt, true)
	end
end

function love.draw()
	for _, scene in sceneLayers:eachInDrawOrder() do
		scene:draw()
	end
end

local Test = require("nx/test")
Test.runComponentTests()

local Scene = require("nx/game/scene")
uiScene = Scene.fromPath("ui")
gameScene = require("game-scene")

sceneLayers:add(gameScene)
sceneLayers:add(uiScene)

love.graphics.setBackgroundColor(0, 0, 0)

local music = Assets.sounds["mainmusic"]:get()
music:setLooping(true)
music:play()
