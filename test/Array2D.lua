Array2D = {}
function Array2D:new(rows, cols)
	local object = { rows = rows, cols = cols, items = {} }
	setmetatable(object, self)
	self.__index = self
	return object
end
function Array2D:get(r, c)
	return self.items[r * self.cols + c]
end
function Array2D:put(r, c, val)
	self.items[r * self.cols + c] = val
end
function Array2D:foreach(fn)
	local size = self.rows * self.cols
	for i = 0, size-1 do
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
