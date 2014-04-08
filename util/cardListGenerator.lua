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

	local function getOptionalTagValue(children, propertyValue)  
		local tag = findChildTagByProperty(children, "name", propertyValue)
		if tag then
			return tag.properties.value
		end
		return nil
	end
	local function getCardText(children, parentName)
		local parent = findChildTagByProperty(children, "name", parentName)
		if parent then
			return findChildTagByName(parent.child, "enUS").value
		end
	end

	local cardName = getCardText(xml.child, "CardName")
	local cost = getOptionalTagValue(xml.child, "Cost")

	if not cost then return nil end

	local cardType = findChildTagByProperty(xml.child, "name", "CardType").properties["value"]
	local cardClass = getOptionalTagValue(xml.child, "Class")
	local cardText = getCardText(xml.child, "CardTextInHand")

	local cardAtk = getOptionalTagValue(xml.child, "Atk")
	local cardHealth = getOptionalTagValue(xml.child, "Health")
	local durability = getOptionalTagValue(xml.child, "Durability")

	local battlecry = getOptionalTagValue(xml.child, "Battlecry")
	local taunt = getOptionalTagValue(xml.child, "Taunt")
	local stealth = getOptionalTagValue(xml.child, "Stealth")
	local freeze = getOptionalTagValue(xml.child, "Freeze")
	local charge = getOptionalTagValue(xml.child, "Charge")
	local divineShield = getOptionalTagValue(xml.child, "Divine Shield")
	local windFury = getOptionalTagValue(xml.child, "Windfury")
	local combo = getOptionalTagValue(xml.child, "Combo")
	local overload = getOptionalTagValue(xml.child, "Recall")
	local targetingText = getCardText(xml.child, "TargetingArrowText")

	--------------------------
	local function addOptionalTrait(trait, value)
		if value then
			local quoteEscape = string.gsub(value, '"', "'")
			print('\t\t\t"' .. trait .. '": "' .. quoteEscape .. '",')
		end
	end
	print('\t\t{')
	print('\t\t\t"name": "' .. cardName .. '",')
	print('\t\t\t"cost": "' .. cost ..'",')
	print('\t\t\t"type": "' .. cardType .. '",')
	addOptionalTrait("class", cardClass)
	addOptionalTrait("atk", cardAtk)
	addOptionalTrait("health", cardHealth)
	addOptionalTrait("durability", durability)
	addOptionalTrait("battlecry", battlecry)
	addOptionalTrait("taunt", taunt)
	addOptionalTrait("stealth", stealth)
	addOptionalTrait("freeze", freeze)
	addOptionalTrait("charge", charge)
	addOptionalTrait("divineShield", divineShield)
	addOptionalTrait("windFury", windFury)
	addOptionalTrait("combo", combo)
	addOptionalTrait("overload", overload)

	addOptionalTrait("text", cardText)
	addOptionalTrait("targetingText", targetingText)
	print('\t\t\t"asset": "",')
	print('\t\t},')

end
function oneCardTest(file)
	local xml = newXMLParser()
	local root = xml:loadFile(file)

	cardXMLToJSON(root)

	return root
end

function generateHSCardsFromXML(dir)
	print('{')
	print('\t"cards":')
	print('\t[')
	for file in lfs.dir(dir) do
		if (string.match(file, '\.txt$')) then
			local xml = newXMLParser()
			local root = xml:loadFile(dir .. "/" .. file)

			if root then
				cardXMLToJSON(root)
			end
		end
	end
	print('\t]')
	print('}')
end

-- xml = oneCardTest("c:/source/unity/HST/extractedstuff/cardxml/ex1_133.txt")
-- xml = oneCardTest("c:/source/unity/HST/extractedstuff/cardxml/new1_010.txt")
-- xml = oneCardTest("c:/source/unity/HST/extractedstuff/cardxml/ex1_248.txt")
generateHSCardsFromXML("c:/source/unity/HST/extractedstuff/cardxml")
