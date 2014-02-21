require "Array2D"
require "Util"

WRBoard = {}
WRBoard.wordMinimum = 3
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
function WRBoard:fromFile(filename)
	-- read the .board file
	local lines = readFileLinesToArray(filename)
	
	-- create a board out of it
	local retval = WRBoard:new(#lines, #lines[1])
	for r=0, retval.board.rows-1 do
		for c=0, retval.board.cols-1 do
			--retval:put(r, c, lines[r+1]:sub(c+1,c+1))
			local tile = lines[r+1]:sub(c+1,c+1)
			if tile == "-" then
				retval.board:put(r, c, nil)
			elseif tonumber(tile) == nil then
				retval.board:put(r, c, tile)
			end
		end
	end
	return retval
end

-- these offsets make searching around our prospective letter easier to code
WRBoard.wordSearchOffsets = { { r=0, c=1 }, { r=1, c=1 }, { r=1, c=0 }, { r=1, c=-1}, { r=0, c=-1 }, { r=-1, c=-1 }, { r=-1, c=0 }, { r=-1, c=1} }
function WRBoard:hasWordImpl(word, wordIndex, foundLetterIndexes, startIndex)
	local char = word:sub(wordIndex, wordIndex)
	--print(wordIndex, char, startIndex, self.board:getByIndex(startIndex))
	if self.board:getByIndex(startIndex) == char then
		foundLetterIndexes:putByIndex(startIndex, wordIndex)
		if wordIndex == #word then 
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
function WRBoard:hasWordImplWithFoldedQU(word, wordIndex, foundLetterIndexes, startIndex)
	-- the user needs to type "QU" in order to match the word in the dictionary, but the
	-- board doesn't need to have an actual U adjacent to the Q, the letter comes for free.
	-- So, scan through the word, and try each combination of QU with it intact vs. folded
	-- into just the single Q letter
-- TBD
	return self:hasWordImpl(word, wordIndex, foundLetterIndexes, startIndex)
end
function WRBoard:hasWord(word)
	local foundLetterIndexes = Array2D:new(self.board.rows, self.board.cols)
	for i = 0, self.board.size-1 do
		if (self:hasWordImplWithFoldedQU(word:upper(), 1, foundLetterIndexes, i)) then
			return true
		end
	end
	return false
end
function WRBoard:findWordsImpl(dictionary, words, currentWord, traversedLetters, boardIndex)

	local letter = self.board:getByIndex(boardIndex)
	if not letter then return end
	
	currentWord = currentWord .. letter:lower();
	traversedLetters:putByIndex(boardIndex, #currentWord)
	
	local hasFragment, hasWholeWord = dictionary:has(currentWord)
	if hasFragment then
		if hasWholeWord and #currentWord >= WRBoard.wordMinimum then words[currentWord] = true end
		
		-- loop all the unused adjacent neighbors to build more words
		local r, c = self.board:getRowColFromIndex(boardIndex)
		for i, offset in pairs(WRBoard.wordSearchOffsets) do
			local newR, newC = r + offset.r, c + offset.c
			if self.board:validRowCol(newR, newC) and self.board:get(newR, newC) and not traversedLetters:get(newR, newC) then
				self:findWordsImpl(dictionary, words, currentWord, traversedLetters, self.board:getIndexFromRowCol(newR, newC))
			end
			-- second case:  automatic Q->QU unfolding, add a U automatically
			if letter == "Q" then
				self:findWordsImpl(dictionary, words, currentWord .. "u", traversedLetters, self.board:getIndexFromRowCol(newR, newC))
			end
		end
	end

	-- undo the new word
	traversedLetters:putByIndex(boardIndex, false)
end
function WRBoard:findAllWords(dictionary)

	local start = os.clock()
	local foundWords = {}
	local currentWord = ""
	local currentTraversal = Array2D:new(self.board.rows, self.board.cols)
	for i = 0, self.board.size-1 do
		self:findWordsImpl(dictionary, foundWords, currentWord, currentTraversal, i)
	end

	print("done in " .. (os.clock() - start))
	return foundWords
end
function WRBoard:__tostring()
	return self.board:__tostring()
end

--b = WRBoard:new(4, 4)
b = WRBoard:fromFile("round1.board")
print(b)
