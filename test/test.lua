Table2D = {}
function Table2D:new(rows, cols)
	local object = { rows = rows, cols = cols, items = {} }
	setmetatable(object, self)
	self.__index = self
	for i = 0, rows*cols do
		object.items[i] = nil
	end
	return object
end
function Table2D:get(r, c)
	return self.items[r * self.cols + c]
end
function Table2D:put(r, c, val)
	self.items[r * self.cols + c] = val
end
function Table2D:toString()
	local size = self.rows * self.cols
	for i = 0, size-1 do
		if i > 0 and (i % self.cols) == 0 then
			print()
		end
		if self.items[i] == nil then
			io.write("- ")
		else
			io.write(self.items[i], " ")
		end
	end
	print()
end
	
t = Table2D:new(4, 3)
t:toString()

-- test some simple things
local simpleArray = {}
for i=1, 20 do
	simpleArray[i] = 2^i
end

for i=1, #simpleArray do
	print(simpleArray[i])
end

