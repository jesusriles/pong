local physics = require("physics")
local Draw = {}

-- some variables
local screenW = display.contentWidth
local screenH = display.contentHeight
local halfW = display.contentWidth * 0.5
local halfH = display.contentHeight * 0.5


-- function that create/draw the pads
function Draw.createLeftPad(scene)

	local padOptions = {
		x = 0,
		y = halfH,
		width = 15,
		height = 80,
		cornerRadius = 5
	}

	local pad = display.newRoundedRect(scene, padOptions.x, padOptions.y, padOptions.width, padOptions.height, padOptions.cornerRadius)
	pad:setFillColor(.6, .1, .2)
	physics.addBody(pad, "static", {density = 1.0, friction = 0, bounce = 1, isSensor = false})
	pad.myName = "leftPad"

	return pad

end

-- function that create/draw the right pads
function Draw.createRightPad( scene )

	local padOptions = {
		x = screenW,
		y = halfH,
		width = 15,
		height = 80,
		cornerRadius = 5
	}

	local pad = display.newRoundedRect(scene, padOptions.x, padOptions.y, padOptions.width, padOptions.height, padOptions.cornerRadius)
	pad:setFillColor(.2, .5, .6)
	physics.addBody(pad, "static", {density = 1.0, friction = 0, bounce = 1, isSensor = false})
	pad.myName = "rightPad"

	return pad

end

-- function that create/draw the ball
function Draw.createBall( scene )

	local ball = display.newCircle(scene, halfW, halfH, 10)
	ball:setFillColor(180/255, 130/255, 195/255)
	physics.addBody(ball, "dynamic", {density = 1.0, friction = 0, bounce = 1, isSensor = false, radius = 15})
	ball:applyForce(200, 50)
	ball.myName = "ball"
	return ball

end

-- draw the left pad shadow (this is an invisible pad used to move the leftPad correctly)
function Draw.createLeftPadShadow( scene )

	local pad = display.newRoundedRect(scene, halfW, halfH, (halfW*2 + 50), (300*2), 5)
	pad:setFillColor(0, 0, 0)
	pad:toBack()
	pad.myName = "leftPadShadow"
	return pad

end

-- draw the score
function Draw.score( scene )

	local score = display.newText( scene, "0", 470, 30, native.systemFont, 20 )
	score:setFillColor(1, 1, 1)
	return score

end

-- draw the top wall
function Draw.topWall( scene )
	
	local wall = display.newRect( scene, halfW, 0, display.contentWidth + 60, 10 )
	physics.addBody(wall, "static", {density = 1.0, friction = 0, bounce = 1, isSensor = false})
	wall:setFillColor(0,0,0)
	return wall

end

-- draw the bottom wall
function Draw.bottomWall( scene )
	
	local wall = display.newRect( scene, halfW, screenH, display.contentWidth + 60, 10 )
	physics.addBody(wall, "static", {density = 1.0, friction = 0, bounce = 1, isSensor = false})
	wall:setFillColor(0,0,0)
	return wall

end

-- draw the left wall
function Draw.leftWall( scene )

	local wall = display.newRect( scene, -40, halfH, 10, display.contentHeight )
	physics.addBody(wall, "static", {density = 1.0, friction = 0, bounce = 1, isSensor = false})
	wall:setFillColor(.5,.5,.5)
	return wall

end

-- draw the right wall
function Draw.rightWall( scene )
	
	local wall = display.newRect( scene, display.contentWidth + 40, halfH, 10, display.contentHeight )
	physics.addBody(wall, "static", {density = 1.0, friction = 0, bounce = 1, isSensor = false})
	wall:setFillColor(100/255,50/255,100/255)
	return wall

end


return Draw

