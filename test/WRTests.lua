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

------------------------------------------
print("\n--- testing QU unfolding ---")
b = WRBoard:fromFile("qu.board")
print(b)

print("word list:")
w = b:findAllWords(t)
a = keysToArray(w)
table.sort(a)
for i,n in ipairs(a) do print(i, n) end
print("found correct number of words: ", #a == 163, "found QUIT: ", a[101] == "quit")

print("QU folding when hittesting words: ")
print("WRBoard:hasWord QUOIT (normal):  ", b:hasWord("quoit"))
print("WRBoard:hasWord QUIT (folded U): ", b:hasWord("quit"))
