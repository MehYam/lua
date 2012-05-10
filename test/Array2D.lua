Array2D = {}
function Array2D:new(rows, cols)
	local object = { rows = rows, cols = cols, size = rows*cols, items = {} }
	setmetatable(object, self)
	self.__index = self
	return object
end
function Array2D:get(r, c)
	return self.items[r * self.cols + c]
end
function Array2D:getByIndex(i)
	return self.items[i]
end
function Array2D:put(r, c, val)
	self.items[r * self.cols + c] = val
end
function Array2D:putByIndex(i, val)
	self.items[i] = val
end
function Array2D:getRowColFromIndex(i)
	return math.floor(i / self.cols), i % self.cols
end
function Array2D:getIndexFromRowCol(r, c)
	return r * self.cols + c
end
function Array2D:validRowCol(r, c)
	return r >= 0 and r < self.rows and c >= 0 and c < self.cols
end
function Array2D:foreach(fn)
	for i = 0, self.size-1 do
		fn(math.floor(i / self.cols), i % self.cols, self.items[i])
	end
end
function Array2D:__tostring()
	local result = ""
	local function concatCell(row, col, val)
		if col == 0 and row > 0 then result = result .. "\n" end
		result = result .. (val or "-") .. " "
	end
	self:foreach(concatCell)
	return result
end
