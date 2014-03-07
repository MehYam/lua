require "Aliases"
require "Input"
require "ScrollingBackground"

local sky = display.newImage( "bkg_clouds.png" )

sky.x = Aliases.centerX
sky.y = Aliases.centerY
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

	-- KAI: could potentially solve the layers of parallax scrolling just by using groups that have scales set on them
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
local wheel = display.newCircle(Aliases.centerX, Aliases.centerY, wheelRadius)
--local wheel = display.newRect( Aliases.centerX - wheelRadius, Aliases.centerY - wheelRadius, wheelRadius*2, wheelRadius*2 )
wheel:setFillColor(0.5);
wheel.strokeWidth = 5
wheel:setStrokeColor(0.5, 0, 0)

parentGroup:insert(wheel)

physics.addBody(wheel, { density = 3, friction = 0.5, bounce = 0 })

--

local lastY = Aliases.dHeight * 0.8
local SEGMENT = 10
local slope = 0
local slopeStart = 0
for i = 0,10000 do
	if i % 20 == 0 then
		slope = SEGMENT * (math.random() - 0.5) / 2
		slopeStart = i
	end
	local groundY = 0 
	if slope < 0 then 
		groundY = lastY + slope * (i - slopeStart)
	else
		groundY = lastY + slope * (20 - (i - slopeStart))
	end
	local ground = display.newLine(i*SEGMENT, lastY, (i+1)*SEGMENT, groundY)
	ground:setStrokeColor(1, math.random(), math.random(), 1)
	ground.strokeWidth = 10

	lastY = groundY

	parentGroup:insert(ground)

	physics.addBody(ground, "static", {friction = 0, bounce = 0})
end

local function playWithGroup(event)

	parentGroup.x = -wheel.x + Aliases.centerX
	parentGroup.y = -wheel.y + Aliases.centerY

	local force = 2
	local MAX_VEL = 300
	local vx, vy = wheel:getLinearVelocity( )

	if Input.isKeyDown("left") and vx > -MAX_VEL then 
		wheel:applyLinearImpulse( -force, 0, wheel.x, wheel.y )
	elseif Input.isKeyDown("right") and vx < MAX_VEL then 
		wheel:applyLinearImpulse( force, 0, wheel.x, wheel.y )
	end

	if Input.isKeyDown("up") and vy > -MAX_VEL then 
		wheel:applyLinearImpulse( 0, -force * 2, 0, 0 )
	elseif Input.isKeyDown("down") then 
		wheel:applyLinearImpulse( 0, force, 0, 0)
	end

end

Runtime:addEventListener("enterFrame", playWithGroup)