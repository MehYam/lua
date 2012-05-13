function rand(min, max) 
	return math.floor(math.random() * (max - min + 1) + min) 
end
function foreachFileLine(fn, filename)
	local file = assert(io.open(filename, "r"))
	for line in file:lines() do fn(line) end
end
function readFileLinesToArray(filename)
	local lines = {}
	foreachFileLine(function(line) table.insert(lines, line) end, filename)
	return lines
end
