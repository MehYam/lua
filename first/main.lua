require "Aliases"
require "Input"
require "ScrollingBackground"

MainScene = {}

function MainScene:new()
	local object = 
	{
		scrollingBackground = nil,
		frameListeners = {},
		timePrevious = system.getTimer()
	}
	setmetatable(object, self)
	self.__index = self

	-- this is cool - it's called a "table listener", and sort of lets you
	-- do what bound methods acheive in AS3
	Runtime:addEventListener("enterFrame", object)

	object:initSky()
	object:initScrollingBackground()
	object:testMockup1()

	Runtime:addEventListener("key", Input.onKey)
	return object
end

function MainScene:initSky()
	-- sky
	local sky = display.newImage( "bkg_clouds.png" )

	sky.x = Aliases.centerX
	sky.y = Aliases.centerY
	sky.xScale = Aliases.dWidth / sky.width
	sky.yScale = Aliases.dHeight / sky.height

	print("w,h: " .. Aliases.dWidth .. " x " .. Aliases.dHeight)
end
function MainScene:initScrollingBackground()

	self.scrollingBackground = ScrollingBackground:new("grass.png")

end
function MainScene:enterFrame(event)

	local elapsed = event.time - self.timePrevious

	-- pump everyone's frames
	for i, v in pairs(self.frameListeners) do
		v:onFrame(elapsed, self.timePrevious)
	end
	self.timePrevious = event.time
end

function MainScene:testMockup0()
	local physics = require("physics")
	physics.start( );

	-- in order to keep the hero at the centerpoint of the screen, we parent everything to
	-- parentGroup, and move it around the screen
	local parentGroup = display.newGroup()

	self:createFloor(parentGroup)
end

function MainScene:createFloor(parentGroup)
	local lastY = Aliases.dHeight
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
		local ground = display.newLine(i*SEGMENT - 5000, lastY, (i+1)*SEGMENT - 5000, groundY)
		ground:setStrokeColor(1, math.random(), math.random(), 1)
		ground.strokeWidth = 10

		lastY = groundY

		parentGroup:insert(ground)

		physics.addBody(ground, "static", {friction = 0, bounce = 0})
	end
end

function MainScene:testMockup1()

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

	self:createFloor(parentGroup)

	local function enterFrame(event)

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

		self.scrollingBackground:setPos(wheel.x)
	end

	Runtime:addEventListener("enterFrame", enterFrame)
end

-- start the scene
local mainScene = MainScene:new()

