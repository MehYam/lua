require "Array2D"
require "Util"

--[[

WRBoard - a class that implements a WordRacer/Boggle word game.

WRBoard.implicitUafterQ:	because Q almost always requires a U to be useful in a word,
we fold QU together so that a word like QUIT matches on a board that only has QIT.  If
the board actually has QUIT, that matches too. 
	
]]

WRBoard = {}
WRBoard.wordMinimum = 3
function WRBoard:new(rows, cols)
	local object = { board = Array2D:new(rows, cols), implicitUafterQ = true}
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

-- KAI: we make a lot of temporary strings in the next function - could be more efficient if we used the byte values of 
-- characters (string.byte(...)) and used that everywhere instead

-- these offsets make rotating and testing for the next letter easier to code as a loop
WRBoard.wordSearchOffsets = { { r=0, c=1 }, { r=1, c=1 }, { r=1, c=0 }, { r=1, c=-1}, { r=0, c=-1 }, { r=-1, c=-1 }, { r=-1, c=0 }, { r=-1, c=1} }
function WRBoard:hasWordImpl(word, wordIndex, foundLetterIndexes, startIndex)
	local letter = word:sub(wordIndex, wordIndex)
	--print(wordIndex, char, startIndex, self.board:getByIndex(startIndex))

	if self.board:getByIndex(startIndex) == letter then
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
function WRBoard:hasWord(word)
	local foundLetterIndexes = Array2D:new(self.board.rows, self.board.cols)
	local wordUpper = word:upper()

	for i = 0, self.board.size-1 do
		if (self:hasWordImpl(wordUpper, 1, foundLetterIndexes, i)) then
			return true
		end
	end

	-- make Q equivalent to QU on the board
	if self.implicitUafterQ and wordUpper:find("QU") then
		-- there are words with more than one Q, this catches all cases and combinations because loops over all
		-- QU instances and is recursive (more exhaustive than it really needs to be, multiple Q words are rare)
		for i = 1, #wordUpper do
			if wordUpper:sub(i, i+1) == "QU" then
				local folded = wordUpper:sub(1, i) .. wordUpper:sub(i+2)
				if (self:hasWord(folded)) then return true end
			end
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
			-- check for implicit U after Q
			if self.implicitUafterQ and letter == "Q" then
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
