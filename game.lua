local composer = require( "composer" )
local PersistentData = require( "persistence" )
local Draw = require( "draw" )

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

local leftPadShadow = nil
local speedText = nil


-- function that move the right pad
function moveRightPad( object )

	if (ball ~= nil) then
		rightPad.y = ball.y
	end

end

-- increment the speed of the ball
local function incrementSpeed( )

	if (speed <= 400) then 
		speed = speed + 10 
	elseif (speed > 400 and speed <= 550) then
		speed = speed + 5
	elseif (speed > 550 and speed <= 650) then
		speed = speed + 3
	else
		speed = speed + 1
	end

	speedText.text = speed
	return speed

end

-- collision left pad
local function onCollisionLeftPad( event )

	if (event.phase == "began") then
		score.text = score.text + 1
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

	-- stop the ball
	ball:setLinearVelocity( 0, 0 )

	-- if high score is better, save it
	local oldScore = PersistentData.getScore()

	if( tonumber(score.text) > tonumber(oldScore) ) then
		PersistentData.setScore(score.text)
	end
	timer.performWithDelay( 1000, goToMenu )

end


-- collision left wall
local function onCollisionLeftWall( event )

	if (event.phase == "began") then
		endTheGame()
	end

end


-- limits for pads at top and bottom
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
	ball = Draw.createBall(sceneGroup)

	rightPad = Draw.createRightPad( sceneGroup )
	leftPadShadow = Draw.createLeftPadShadow( sceneGroup )
	leftPad = Draw.createLeftPad( sceneGroup )


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

	score = Draw.score( sceneGroup )
	speedText = display.newText( sceneGroup, speed, 470, 50, native.systemFont, 20 )

	-- create wall objects
	topWall = Draw.topWall( sceneGroup )
	bottomWall = Draw.bottomWall( sceneGroup )
	leftWall = Draw.leftWall( sceneGroup )
	rightWall = Draw.rightWall( sceneGroup )

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
--       	ball:addEventListener("collision", onCollisionBall)
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
--        ball:removeEventListener( "collision", onCollisionBall ) 
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

