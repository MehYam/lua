require "Array2D"
require "Util"

WRBoard = {}
function WRBoard:new(rows, cols)
	local object = { board = Array2D:new(rows, cols) }
	setmetatable(object, self)
	self.__index = self
	local function setRandom(row, col, val)
		object.board:put(row, col, string.char(string.byte("A") + rand(0, 26)))
	end
	object.board:foreach(setRandom)
	return object
end
function WRBoard:__tostring()
	return self.board:__tostring()
end