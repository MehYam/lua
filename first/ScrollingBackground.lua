

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
	object.left.anchorY = 1 -- anchor from the bottom
	object.left.x = 0
	object.left.y = Aliases.dHeight

	object.right.anchorX = 0
	object.right.anchorY = 1
	object.right.x = Aliases.dWidth
	object.right.y = Aliases.dHeight
	return object
end

function ScrollingBackground:getSpeed() return self.speed end
function ScrollingBackground:setSpeed(speed) self.speed = speed end

function ScrollingBackground:onFrame(elapsed, tPrevious)

	local xOffset = ( -self.speed * elapsed )

	self.left.x = self.left.x + xOffset
	self.right.x = self.right.x + xOffset

	if self.speed > 0 then
		function wrapRight(obj, objOther)
			if (obj.x + obj.contentWidth) < 0 then
				obj.x = objOther.x + objOther.contentWidth
				print("wrapRight")
			end
		end
		wrapRight(self.left, self.right)
		wrapRight(self.right, self.left)
	elseif self.speed < 0 then
		function wrapLeft(obj, objOther)
			if (obj.x > Aliases.dWidth) then
				obj.x = objOther.x - obj.contentWidth
				print("wrapLeft")
			end
		end
		wrapLeft(self.left, self.right)
		wrapLeft(self.right, self.left)
	end
end