require "Aliases"
require "Input"
require "ScrollingBackground"

local sky = display.newImage( "bkg_clouds.png" )

sky.x = Aliases.dWidth / 2
sky.y = Aliases.dHeight / 2
sky.xScale = Aliases.dWidth / sky.width
sky.yScale = Aliases.dHeight / sky.height

print("w,h: " .. Aliases.dWidth .. " x " .. Aliases.dHeight)

local scrollingBackground = ScrollingBackground:new("grass.png")

-- list of enter frame listeners
local enterFrameClients = {}
local tPrevious = system.getTimer()
local function onEnterFrame(event)
	local elapsed = event.time - tPrevious

	-- process input
	-- KAI: the background's scrolling shouldn't have "speed", it should really needs be set 
	-- KAI: also, seems like Box2D should have this accel/inertia thing covered
	-- by changes in the player's position
	local acceleration = 0
	local speed = scrollingBackground:getSpeed()
	if Input.isKeyDown("left") then 
		acceleration = -Aliases.ACCEL 
	elseif Input.isKeyDown("right") then 
		acceleration = Aliases.ACCEL 
	else
		-- inertia to stop
		if speed > 0 then
			acceleration = -Aliases.INERTIA
		elseif speed < 0 then
			acceleration = Aliases.INERTIA
		end
	end

	speed = speed + acceleration
	if speed > Aliases.MAX_SPEED then
		speed = Aliases.MAX_SPEED
	elseif speed < -Aliases.MAX_SPEED then
		speed = -Aliases.MAX_SPEED
	end

	scrollingBackground:setSpeed(speed)

	-- pump everyone's frames
	for i, v in pairs(enterFrameClients) do
		v:onFrame(elapsed, tPrevious)
	end
	tPrevious = event.time

end


table.insert(enterFrameClients, scrollingBackground)

Runtime:addEventListener("enterFrame", onEnterFrame)
Runtime:addEventListener("key", Input.onKey)



-- test code -----------------------------------------
local physics = require("physics")
physics.start( );

local parentGroup = display.newGroup()

local wheelRadius = 20;
local wheel = display.newCircle(Aliases.dWidth/2, Aliases.dHeight/2, wheelRadius)
wheel:setFillColor(0.5);
wheel.strokeWidth = 5
wheel:setStrokeColor(0.5, 0, 0)

parentGroup:insert(wheel)

physics.addBody(wheel, { density = 3, friction = 0.5, bounce = 0.5 })

--
local slope = 50
local groundY = Aliases.dHeight * 0.8
local ground = display.newLine(0, groundY, Aliases.dWidth, groundY + slope)
ground:setStrokeColor(1, 0, 0, 1)
ground.strokeWidth = 1

parentGroup:insert(ground)

physics.addBody(ground, "static", {friction = 0, bounce = 0})


local ground2 = display.newLine(0, groundY + slope * 2, Aliases.dWidth, groundY)
ground2:setStrokeColor(0, 1, 0, 1)
ground2.strokeWidth = 1

parentGroup:insert(ground2)

physics.addBody(ground2, "static", {friction = 0, bounce = 0})

local function playWithGroup(event)

	parentGroup.x = -wheel.x + Aliases.dWidth / 2
	parentGroup.y = -wheel.y + Aliases.dHeight / 2

end

Runtime:addEventListener("enterFrame", playWithGroup)