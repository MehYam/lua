

ScrollingBackground = {}
function ScrollingBackground:new(fileName)
	local object = 
	{ 
		pos = 0,
		tiles = {}
	}
	setmetatable(object, self)
	self.__index = self

	-- create enough copies of the tiled image to span the width of the display.
	local totalWidth = 0
	while totalWidth <= Aliases.dWidth do
		local image = display.newImage(fileName)

		image.anchorX = 0 -- anchor left
		image.anchorY = 1 -- anchor from the bottom (for now, this is convenient)
		image.y = Aliases.dHeight

		totalWidth = totalWidth + image.contentWidth
		table.insert(object.tiles, image)

		print("created image", #object.tiles)
	end

	object:setPos(0)
	return object
end

function ScrollingBackground:setPos(pos)
	self.pos = pos

	local tileWidth = self.tiles[1].contentWidth
	local moduloPos = pos % tileWidth

	for i, v in ipairs(self.tiles) do
		v.x = -moduloPos + (i - 1) * tileWidth
	end
end
