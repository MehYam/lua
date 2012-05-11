function rand(min, max) 
	return math.floor(math.random() * (max - min + 1) + min) 
end
function foreachFileLine(fn, filename)
	local file = assert(io.open(filename, "r"))
	for line in file:lines() do fn(line) end
end
