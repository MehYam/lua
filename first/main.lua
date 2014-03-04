require "Aliases"
require "ScrollingBackground"

local sky = display.newImage( "bkg_clouds.png" )

sky.x = Aliases.dWidth / 2
sky.y = Aliases.dHeight / 2
sky.xScale = Aliases.dWidth / sky.width
sky.yScale = Aliases.dHeight / sky.height

print("w,h: " .. Aliases.dWidth .. " x " .. Aliases.dHeight)

-- list of enter frame listeners
local enterFrameClients = {}
local tPrevious = system.getTimer()
local function onEnterFrame(event)
	local elapsed = event.time - tPrevious

	for i, v in pairs(enterFrameClients) do
		v:onFrame(elapsed, tPrevious)
	end
	tPrevious = event.time
end

local scrollingBackground = ScrollingBackground:new("grass.png")
local acceleration = 0.01
local function onKey(event)
	if event.keyName == "left" then
		scrollingBackground:setSpeed(scrollingBackground:getSpeed() - acceleration)
	elseif event.keyName == "right" then
		scrollingBackground:setSpeed(scrollingBackground:getSpeed() + acceleration)
	end
end

table.insert(enterFrameClients, scrollingBackground)

Runtime:addEventListener("enterFrame", onEnterFrame)
Runtime:addEventListener("key", onKey)



-- test code -----------------------------------------
local physics = require("physics")
physics.start( );

local wheelRadius = 20;
local wheel = display.newCircle(Aliases.dWidth/2, Aliases.dHeight/2, wheelRadius)
wheel:setFillColor(0.5);
wheel.strokeWidth = 5
wheel:setStrokeColor(0.5, 0, 0)

physics.addBody(wheel, { density = 3, friction = 0.5, bounce = 0.5 })

--
local slope = 50
local groundY = Aliases.dHeight * 0.8
local ground = display.newLine(0, groundY, Aliases.dWidth, groundY + slope)
ground:setStrokeColor(1, 0, 0, 1)
ground.strokeWidth = 1

physics.addBody(ground, "static", {friction = 0, bounce = 0})


local ground2 = display.newLine(0, groundY + slope * 2, Aliases.dWidth, groundY)
ground2:setStrokeColor(0, 1, 0, 1)
ground2.strokeWidth = 1

physics.addBody(ground2, "static", {friction = 0, bounce = 0})

