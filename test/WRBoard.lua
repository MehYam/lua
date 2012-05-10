require "Array2D"
require "Util"

WRBoard = {}
function WRBoard:new(rows, cols)
	local object = { board = Array2D:new(rows, cols) }
	setmetatable(object, self)
	self.__index = self
	local function setRandom(row, col, val)
		object.board:put(row, col, string.char(string.byte("A") + rand(0, 25)))
	end
	object.board:foreach(setRandom)
	return object
end

-- these offsets make searching around our prospective letter easier to code
WRBoard.wordSearchOffsets = { { r=0, c=1 }, { r=1, c=1 }, { r=1, c=0 }, { r=1, c=-1}, { r=0, c=-1 }, { r=-1, c=-1 }, { r=-1, c=0 }, { r=-1, c=1} }
function WRBoard:hasWordImpl(word, wordIndex, foundLetterIndexes, startIndex)
	local char = string.sub(word, wordIndex, wordIndex)
	--print(wordIndex, char, startIndex, self.board:getByIndex(startIndex))
	if self.board:getByIndex(startIndex) == char then
		foundLetterIndexes:putByIndex(startIndex, wordIndex)
		if wordIndex == #word then 
			print("found it")
			print(foundLetterIndexes)
			return true -- we've found the entire word
		else
			-- try all of the adjacent letters to see if we can find anything
			local r, c = self.board:getRowColFromIndex(startIndex)
			for i,offset in pairs(WRBoard.wordSearchOffsets) do
				local newR, newC = r + offset.r, c + offset.c
				if self.board:validRowCol(newR, newC) and not foundLetterIndexes:get(newR, newC) then
					if self:hasWordImpl(word, wordIndex + 1, foundLetterIndexes, self.board:getIndexFromRowCol(newR, newC)) then
						return true
					end
				end
			end
		end
		-- we didn't find a complete match; scrub out the found letter
		foundLetterIndexes:putByIndex(startIndex, nil)
	end
	return false
end
function WRBoard:hasWord(word)
	local foundLetterIndexes = Array2D:new(self.board.rows, self.board.cols)
	for i = 0, self.board.size-1 do
		if (self:hasWordImpl(string.upper(word), 1, foundLetterIndexes, i)) then
			return true
		end
	end
	return false
end
function WRBoard:__tostring()
	return self.board:__tostring()
end