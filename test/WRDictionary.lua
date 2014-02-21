require "Util"

-- TODO: cleanup, turn this inta a type

Trie = {}
function Trie:new(words)
	local object = { top = {} }
	setmetatable(object, self)
	self.__index = self

local pre = os.clock()
	for i=1, #words do
		object:add(words[i])
	end
print("Trie constructed in " .. math.floor((os.clock() - pre)*100)/100 .. " seconds");
	return object
end
function Trie:add(word)
	local node = self.top
	local index = 1
	while index <= #word do
		--local letter = word:sub(index, index)
		local letter = word:byte(index)
		if node[letter] == nil then
			node[letter] = {}
		end
		node = node[letter]
		index = index + 1
	end
	node.word = true
end
-- this is about four times as slow as :hasNodeImpl, kept for educational purposes.  Is this tail recursive?
function Trie:hasNodeRecursiveImpl(node, word, index)
	--local letter = word:sub(index, index)
	local letter = word:byte(index)
	if node[letter] then
		if index < #word then
			return self:hasNodeRecursiveImpl(node[letter], word, index + 1)
		end
		return true, node[letter].word ~= nil
	end
	return false
end
function Trie:hasNodeImpl(word)
	local node = self.top
	for index = 1, #word do
		--local letter = word:sub(index, index)
		local letter = word:byte(index)
		if node[letter] then
			node = node[letter]
		else
			break
		end
		if index == #word then
			return true, node.word ~= nil
		end
	end
	return false
end
-- returns two bools, first true if the word fragment exists, second true if it's also a complete word
function Trie:has(word)
	--return self:hasNodeRecursiveImpl(self.top, word, 1)
	return self:hasNodeImpl(word)
end

d = readFileLinesToArray("words.lst")
t = Trie:new(d)
--t = Trie:new({ "latexes" })

function perfTest()
	tcalls = 0
	local pre = os.clock()
	for i=1, 1000000 do
		local w = d[rand(1, #d)]
		if not t:has(w) then
			print("t doesn't have " .. w)
			return
		end
	end
	print("done in " .. (os.clock() - pre) .. " over " .. tcalls);
end
function perfTestBSearch()
	tcalls = 0
	local pre = os.clock()
	for i=1, 1000000 do
		local w = d[rand(1, #d)]
		if not binarySearch(d, w) then
			print("t doesn't have " .. w)
			return
		end
	end
	print("done in " .. (os.clock() - pre) .. " over " .. tcalls);
end
function perfTestHashLookup()
	tcalls = 0
	local pre = os.clock()
	for i=1, 1000000 do
		local w = d[rand(1, #d)]
		if not rlookup[w] then
			print("t doesn't have " .. w)
			return
		end
	end
	print("done in " .. (os.clock() - pre) .. " over " .. tcalls);
end