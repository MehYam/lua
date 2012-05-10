function rand(min, max) 
	return math.floor(math.random() * (max - min + 1) + min) 
end
function readLines(filename)
	local retval = {}
	local file = assert(io.open(filename, "r"))
	for line in file:lines() do
		retval[line] = 1
	end
	return retval
end