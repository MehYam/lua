print("hello whorled")

local text = display.newText( "!@#$!#@$!", 160, 240, "Arial", 60 )
text:setFillColor( 0.5, 0.5, 0 )

function screenTap()
	local r, g, b = math.random(), math.random(), math.random()
	text:setFillColor(r, g, b)
end

display.currentStage:addEventListener( "tap", screenTap )
