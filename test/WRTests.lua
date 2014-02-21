-----------------------------------------
print("--- testing WRDictionary ---")
dofile("WRDictionary.lua")
t = Trie:new({ "latexes" })

print("has 'latexes': ", t:has("latexes"))
print("has 'latex': ", t:has("latex"))
print("has 'tex': ", t:has("tex"))

-----------------------------------------
print("\n--- testing WRBoard ---")
dofile("WRBoard.lua")
print("Random 4x4 board:")
b = WRBoard:new(4, 4)
print(b)

print("Loaded from file 'round1.board'")
b = WRBoard:fromFile("round1.board")
print(b)

-----------------------------------------
print("\n--- testing WRDictionary ---")

wordList = readFileLinesToArray("words.lst")
t = Trie:new(wordList)

w = b:findAllWords(t)
for key,value in pairs(w) do print(key) end

a = keysToArray(w)
print("words found:" .. #a)

-- to sort the results:
-- table.sort(a)
-- for i,n in ipairs do print(i, n) end

------------------------------------------
print("\n--- testing QU folding ---")
b = WRBoard:fromFile("qu.board")

print(b)
print("has QUAT: ", b:hasWord("quat"))
print("has QUOIT: ", b:hasWord("quoit"))
