local composer = require( "composer" )
local PersistentData = require( "persistence" )
local Draw = require( "draw" )

-- Activate multitouch
system.activate( "multitouch" )

local scene = composer.newScene()
 
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
local speedInScreen = nil


-- function that moves the right pad
function moveRightPad( object )

	if (ball ~= nil) then
		rightPad.y = ball.y
	end

end

-- funciton that increments the speed of the ball
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

	speedInScreen.text = speed
	return speed

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

-- ball collision
local  function onCollisionBall( event )

	if( event.phase =="began") then
		-- collision with the left wall
		if( event.other.myName == "leftWall" ) then
			endTheGame()
		end

		-- collision with the left pad
		if( event.other.myName == "leftPad" ) then
			score.text = score.text + 1
			ball:setLinearVelocity( incrementSpeed(), math.random( -350, 350 ) )
		end

		-- collision with the right pad
		if( event.other.myName == "rightPad" ) then
			ball:setLinearVelocity( (incrementSpeed() * -1 ), math.random( -350, 350 ) )
		end

		-- collision with coin
		if( event.other.myName == "coin") then
			display.remove( event.other )
			event.other = nil
		end
	end	

end

-- remove coin
local function removeCoin( event )
	
	display.remove( event )
	event = nil

end

-- remove diamond when touched
local function onTouchDiamond( event )

	print(event)
	for k, v in pairs(event) do
		print (k, v)
	end
	display.remove( event.target )
	event = nil

end

-- remove diamond
local function removeDiamond( event )

	display.remove( event )
	event = nil

end 

-- add coins randomly
local function dropItem( event )

	local chose = math.random(0, 1)

	-- spam a coin
	if( chose == 0 ) then 
		local coin = Draw.coin()
		coin.x = math.random( 40, screenW-40 )
		coin.y = -50

		local coinOptions = {
			time = ( math.random( 1000, 10000 )),
			y = ( screenH + 50 ),
			x = ( math.random( 40, screenW-40 )),
			onComplete = removeCoin
		}
		transition.to(coin, coinOptions)
	end

	-- spam a diamond
	if( chose == 1) then
		local diamond = Draw.diamond()
		diamond.x = math.random( 40, screenW-40 )
		diamond.y = math.random( 40, screenH-40 )
		transition.fadeOut( diamond, { delay=1000, time=2000, onComplete = removeDiamond })
		diamond:addEventListener( "touch", onTouchDiamond )
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
	speedInScreen = Draw.speedInScreen( sceneGroup )

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
       	ball:addEventListener("collision", onCollisionBall )
		leftPad:addEventListener( "touch", leftPad )
		leftPadShadow:addEventListener( "touch", leftPadShadow 	)

		Runtime:addEventListener( "enterFrame", moveRightPad )
		Runtime:addEventListener( "enterFrame", checkPadsLimits )

		dropItemTimer = timer.performWithDelay( 5000, dropItem, -1 )
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
        leftPad:removeEventListener( "touch",  leftPad )
        leftPadShadow:addEventListener( "touch", leftPadShadow	)

        Runtime:removeEventListener( "enterFrame", moveRightPad )
        Runtime:removeEventListener( "enterFrame", checkPadsLimits )

        timer.cancel(dropItemTimer)

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

