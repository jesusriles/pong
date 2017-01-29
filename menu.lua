local composer = require( "composer" )

local scene = composer.newScene()

local halfW = display.contentWidth * 0.5
local halfH = display.contentHeight * 0.5
local highScore = nil

local function gotoGame()
	composer.gotoScene( "game" )
end

local function gotoEnhancements()
	composer.gotoScene( "enhancements" )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    display.setDefault(sceneGroup, "background", 0, 0, 0 )
    local gameName = display.newText(sceneGroup, "Pong", halfW, halfH-50, native.systemFont, 100)
    gameName:setFillColor( 0.66, 0.99, .52 )

    highScore = display.newText( sceneGroup, "High score:", display.contentCenterX+190, halfH-140, native.systemFont, 15 )
    local pointsEarned = display.newText( sceneGroup, "Points earned:", display.contentCenterX+190, halfH-120, native.systemFont, 15 )

    local playButton = display.newText( sceneGroup, "Play", display.contentCenterX, 200, native.systemFont, 44 )
    playButton:setFillColor( 0.82, 0.86, 1 )

    local enhancementsButton = display.newText( sceneGroup, "Enhancements", display.contentCenterX, 250, native.systemFont, 44 )
    enhancementsButton:setFillColor( 0.75, 0.78, 1 )

    playButton:addEventListener( "tap", gotoGame )
    enhancementsButton:addEventListener( "tap", gotoEnhancements )

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		local score = composer.getVariable( "score" )

		if ( score ~= nil) then
			print ("score is: " .. score)
			highScore.text = ("High score: " ..  score)
		end

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

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

