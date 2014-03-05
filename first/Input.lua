
Input = { keysDown = {} }

Input.isKeyDown = function(key)

	return Input.keysDown[key] == true

end

Input.onKey = function(event)
	
	Input.keysDown[event.keyName] = event.phase == "down"

end