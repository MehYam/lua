

ScrollingBackground = {}
function ScrollingBackground:new(image)
	local object = 
	{ 
		speed = 0,
		left = display.newImage(image),
		right = display.newImage(image)
	}
	setmetatable(object, self)
	self.__index = self

	object.left.anchorX = 0 -- anchor left
	object.left.x = 0
	object.left.y = Aliases.dHeight / 2

	object.right.anchorX = 0
	object.right.x = Aliases.dWidth
	object.right.y = Aliases.dHeight / 2
	return object
end

function ScrollingBackground:getSpeed() return self.speed end
function ScrollingBackground:setSpeed(speed) self.speed = speed end

function ScrollingBackground:onFrame(elapsed, tPrevious)

	local xOffset = ( -self.speed * elapsed )

	self.left.x = self.left.x + xOffset
	self.right.x = self.right.x + xOffset


	if (self.left.x + self.left.contentWidth) < 0 then
		self.left:translate( Aliases.dWidth * 2, 0)
	end
	if (self.right.x + self.right.contentWidth) < 0 then
		self.right:translate( Aliases.dWidth * 2, 0)
	end

end