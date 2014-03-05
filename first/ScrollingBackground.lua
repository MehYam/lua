

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

	function wrap(obj, objOther)
		if (obj.x + obj.contentWidth) < 0 then
			obj.x = objOther.x + objOther.contentWidth
		print("wrapped")
		end
	end
	wrap(self.left, self.right)
	wrap(self.right, self.left)
end