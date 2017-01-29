local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
local physics = require("physics")

-- some variables
local screenW = display.contentWidth
local screenH = display.contentHeight
local halfW = display.contentWidth * 0.5
local halfH = display.contentHeight * 0.5

local speed = 250
local score = nil
local ball = nil
local leftPad, rightPad = nil, nil
local bottomWall, leftWall, topWall, rightWall = nil, nil, nil, nil


-- function that create/draw the pads
function createPads(sceneGroup, x, y)

	local padOptions = {
		x = x,
		y = y,
		width = 15,
		height = 80,
		cornerRadius = 5
	}
	local padName = display.newRoundedRect( sceneGroup, x, y, padOptions.width, padOptions.height, padOptions.cornerRadius )
	return padName

end


-- function that create/draw the ball
function createBall( sceneGroup )

	local ballName = display.newCircle(sceneGroup, halfW, halfH, 10)
	return ballName

end


-- function that move the right pad
function moveRightPad( object )

	if (ball ~= nil) then
		rightPad.y = ball.y
	end

end


-- collision to ball
local function onCollisionBall( event )

	-- update the score
	if (event.phase == "ended") then
		--score.text = score.text + 1
	end

end


local function incrementSpeed( )

	if (speed <= 500) then 
		speed = speed + 10 
	elseif (speed > 500 and speed <= 650) then
		speed = speed + 5
	else
		speed = speed + 3
	end

	speedText.text = speed
	return speed

end

-- collision left pad
local function onCollisionLeftPad( event )

	if (event.phase == "began") then
		score.text = score.text + 1
		composer.setVariable( "score", score.text )
	end

	if (event.phase == "ended") then
		ball:setLinearVelocity( incrementSpeed(), math.random( -350, 350 ) )
	end

end


-- collision right pad
local function onCollisionRightPad( event )

	if (event.phase == "ended") then
		ball:setLinearVelocity( (incrementSpeed() * -1 ), math.random( -350, 350 ) )
	end

end


local function goToMenu()
	composer.gotoScene( "menu" )
end


local function endTheGame()

	-- stop the ball and go back to menu
	ball:setLinearVelocity( 0, 0 )
	timer.performWithDelay( 1000, goToMenu )
end


-- collision left wall
local function onCollisionLeftWall( event )

	if (event.phase == "began") then
		endTheGame()		
	end

end


local function checkPadsLimits( event )

	if (leftPad.y <= 45) then leftPad.y = 45 leftPadShadow.y = 45 end
	if (leftPad.y >= 275) then leftPad.y = 275 leftPadShadow.y = 275 end

	if (rightPad.y <= 45) then rightPad.y = 45 end
	if (rightPad.y >= 275) then rightPad.y = 275 end

end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    physics.start()
 
    -- create background
	display.setDefault( sceneGroup, "background", 0, 0, 0 )

	-- draw ball
	ball = createBall(sceneGroup)
	ball:setFillColor(180/255, 130/255, 195/255)
	physics.addBody(ball, "dynamic", {density = 1.0, friction = 0, bounce = 1, isSensor = false, radius = 15})
	ball:applyForce(200, 50)
	ball.myName = "ball"

	-- draw pads
	rightPad = createPads(sceneGroup, screenW, halfH)
	rightPad:setFillColor(.2, .5, .6)
	physics.addBody(rightPad, "static", {density = 1.0, friction = 0, bounce = 1, isSensor = false})
	rightPad.myName = "rightPad"

	leftPadShadow = display.newRoundedRect( sceneGroup, halfW, halfH, halfW*2 + 50, 300*2, 5 )
	leftPadShadow:setFillColor(0, 0, 0)
	leftPadShadow:toBack()
	leftPadShadow.myName = "leftPadShadow"

	leftPad = createPads(sceneGroup, 0, halfH)
	leftPad:setFillColor(.6, .1, .2)
	physics.addBody(leftPad, "static", {density = 1.0, friction = 0, bounce = 1, isSensor = false})
	leftPad.myName = "leftPad"


	-- left pad draggable
	function leftPad:touch( event )

	    if event.phase == "began" then
	        self.markY = self.y
	        leftPadShadow.markY = leftPadShadow.y

	    elseif event.phase == "moved" then
	    	if(self.markY ~= nil) then
		        local y = (event.y - event.yStart) + self.markY
		        self.y = y
		        leftPadShadow.y = y
		    end
	    end
	    return true

	end


	-- left pad shadow draggable
	function leftPadShadow:touch( event )

	    if event.phase == "began" then
	        self.markY = self.y
	        leftPad.markY = leftPadShadow.y

	    elseif event.phase == "moved" then
	    	if(self.markY ~= nil) then
		        local y = (event.y - event.yStart) + self.markY
		        self.y = y
		        leftPad.y = y
		    end
	    end
	    return true

	end


	-- draw scoreboard
	score = display.newText( sceneGroup, "0", 470, 30, native.systemFont, 20 )
	speedText = display.newText( sceneGroup, speed, 470, 50, native.systemFont, 20 )
	score:setFillColor(1, 1, 1)

	-- create wall objects
	topWall = display.newRect( sceneGroup, halfW, 0, display.contentWidth + 60, 10 )
	topWall:setFillColor(0,0,0)

	bottomWall = display.newRect( sceneGroup, halfW, screenH, display.contentWidth + 60, 10 )
	bottomWall:setFillColor(0,0,0)

	leftWall = display.newRect( sceneGroup, -40, halfH, 10, display.contentHeight )
	leftWall:setFillColor(.5,.5,.5)

	rightWall = display.newRect( sceneGroup, display.contentWidth + 40, halfH, 10, display.contentHeight )
	rightWall:setFillColor(100/255,50/255,100/255)


	-- make them physics bodies
	physics.addBody(topWall, "static", {density = 1.0, friction = 0, bounce = 1, isSensor = false})
	physics.addBody(bottomWall, "static", {density = 1.0, friction = 0, bounce = 1, isSensor = false})
	physics.addBody(leftWall, "static", {density = 1.0, friction = 0, bounce = 1, isSensor = false})
	physics.addBody(rightWall, "static", {density = 1.0, friction = 0, bounce = 1, isSensor = false})

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        score.text = 0
        speed = 250

        physics.setGravity( 0, 0 )
 
    elseif ( phase == "did" ) then
       	ball:addEventListener("collision", onCollisionBall)
		leftPad:addEventListener( "touch", leftPad )
		Runtime:addEventListener( "enterFrame", moveRightPad )
		leftPad:addEventListener( "collision", onCollisionLeftPad )
		rightPad:addEventListener( "collision", onCollisionRightPad )
		leftWall:addEventListener( "collision", onCollisionLeftWall )
		leftPadShadow:addEventListener( "touch", leftPadShadow 	)
		Runtime:addEventListener( "enterFrame", checkPadsLimits )

    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

        -- remove listeners
        ball:removeEventListener( "collision", onCollisionBall ) 
        leftPad:removeEventListener( "touch",  leftPad)
        Runtime:removeEventListener( "enterFrame", moveRightPad )
        leftPad:removeEventListener( "collision", onCollisionLeftPad )
        rightPad:removeEventListener( "collision", onCollisionRightPad )
        leftWall:removeEventListener( "collision", onCollisionLeftWall )
        leftPadShadow:addEventListener( "touch", leftPadShadow	)
        Runtime:removeEventListener( "enterFrame", checkPadsLimits )

        -- this removes all the objects
        composer.removeScene( "game", true )
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene

