--[[ 

TODO: this is my first Lua file, probably needs to be scoped to a type and all kinds of other stuff.  
The WR* classes have dependency on this currently.

]]

function foreachFileLine(fn, filename)
	local file = assert(io.open(filename, "r"))
	for line in file:lines() do fn(line) end
end
function readFileLinesToArray(filename)
	local lines = {}
	foreachFileLine(function(line) table.insert(lines, line) end, filename)
	return lines
end
-- KAI: this should really be "map", like in Haskell
function keysToArray(t)
	local retval = {}
	for i, v in pairs(t) do
		table.insert(retval, i)
	end
	return retval
end
function rand(min, max) 
	return math.floor(math.random() * (max - min + 1) + min) 
end
function binarySearch(t, value)
	local first, last, mid = 1, #t, 0
	while first <= last do
		mid = math.floor( (first + last) / 2 )
		if (value == t[mid]) then
			return mid
		end
		if (value < t[mid]) then
			last = mid - 1
		else
			first = mid + 1
		end
	end
	return nil
end

