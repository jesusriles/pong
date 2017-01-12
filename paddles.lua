-- move up
local moveUp = false

local function handleEnterFrame( event )
	if( moveUp == true) then
		moveLeftPadUp(leftPad)
	end
end
Runtime:addEventListener( "enterFrame", handleEnterFrame)

local function handleUpButton ( event )
	if (event.phase == "began") then
		moveUp = true
	elseif( event.phase == "ended" and moveUp == true) then
		moveUp = false
	end
	return true
end
upperRect:addEventListener( "touch", handleUpButton)

-- move down
local moveDown = false

local function handleEnterFrameDown( event )
	if( moveDown == true) then
		moveLeftPadDown(leftPad)
	end
end
Runtime:addEventListener( "enterFrame", handleEnterFrameDown)

local function handleDownButton ( event )
	if (event.phase == "began") then
		moveDown = true
	elseif( event.phase == "ended" and moveDown == true) then
		moveDown = false
	end
	return true
end
lowerRect:addEventListener( "touch", handleDownButton)