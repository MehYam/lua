require "lfs"
--require "xml"

dofile("xml.lua")

function generateHSCardsFromImages(dir)

	print('{')
	print('\t"cards":')
	print('\t[')
	for file in lfs.dir(dir) do
		if (string.match(file, '\.png$')) then
			print('\t\t{')
			print('\t\t\t"asset": "' .. file .. '",')
			print('\t\t\t"name": "",')
			print('\t\t\t"type": "minion/spell/weapon/hero",')
			print('\t\t\t"text": "",')
			print('\t\t\t"cost": "",')
			print('\t\t\t"actions":')
			print('\t\t\t{')
			print('\t\t\t}')
			print('\t\t}')
		end
	end
	print('\t]')
	print('}')
end

--generateHSCardsFromImages("C:/source/unity/HST/Assets/cards")

function showAll(obj)
	for i, v in pairs(obj) do
		print(i, v)
	end
end

function findChildTagByName(children, name)
	for i, v in ipairs(children) do
		if v.name == name then
			return v
		end
	end
	return nil
end
function findChildTagByProperty(children, propertyName, propertyValue)
	for i, v in ipairs(children) do
		if v.properties[propertyName] == propertyValue then
			return v
		end
	end
	return nil
end
function cardXMLToJSON(xml)

	local cardNameNode = findChildTagByProperty(xml.child, "name", "CardName")
	local cardName = findChildTagByName(cardNameNode.child, "enUS").value 
	local cost = findChildTagWithProperty(xml.child, "name", "Cost").properties["value"]
	local cardType = findChildTagWithProperty(xml.child, "name", "CardType").properties["value"]

	local function getOptionalTagValue(children, propertyName, propertyValue, subPropertyValue)  
		local tag = findChildTagWithProperty(children, propertyName, propertyValue)
		if tag then
			return tag.properties[subPropertyValue]
		end
		return nil
	end

	local cardClass = getOptionalTagValue(xml.child, "name", "Class", "value")
	local cardText = nil
	local cardTextInHandNode = findChildTagByProperty(xml.child, "name", "CardTextInHand")
	if cardTextInHandNode then
		cardText = findChildTagByName(cardTextInHandNode.child, "enUS").value
	end

	print('\t\t{')
	print('\t\t\t"name": "' .. cardName .. '",')
	print('\t\t\t"type": "' .. cardType .. '",')
	if cardText then
		print('\t\t\t"text": "' .. cardText .. '",')
	end
	print('\t\t\t"cost": "' .. cost ..'",')
	print('\t\t\t"asset": "",')
	print('\t\t},')

end
function oneCardTest(file)
	local xml = newXMLParser()
	local root = xml:loadFile(file)

	print('{')
	print('\t"cards":')
	print('\t[')
	-- for file in lfs.dir(dir) do
	-- 	if (string.match(file, '\.png$')) then
			cardXMLToJSON(root)
	-- 	end
	-- end
	print('\t]')
	print('}')

	return root
end

function generateHSCardsFromXML(file)
	local xml = newXMLParser()
	local root = xml:loadFile(file)

end

xml = oneCardTest("c:/source/unity/HST/extractedstuff/cardxml/CS1_025.txt")
xml = oneCardTest("c:/source/unity/HST/extractedstuff/cardxml/CS1_042.txt")
-- xml = generateHSCardsFromXML("c:/source/unity/HST/extractedstuff/cardxml")


