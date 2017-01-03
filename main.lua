-- load libraries
local physics = require("physics")
physics.start()
physics.setGravity(0, 0)


-- create background
local background = display.newImage("background.jpg")
background.x = display.contentCenterX
background.y = display.contentCenterY
background.xScale = .70
background.yScale = .25

-- variables that get information about the screen
local screenW = display.contentWidth
local screenH = display.contentHeight
local halfW = display.contentWidth * 0.5
local halfH = display.contentHeight * 0.5


-- kind of global variables
local speed = 9


-- function that draw the pad
function createPads(x, y)
	padOptions = {
		x = x,
		y = y,
		width = 15,
		height = 80,
		cornerRadius = 5
	}
	local padName = display.newRoundedRect( x, y, padOptions.width, padOptions.height, padOptions.cornerRadius )
	return padName
end


-- function that draw the ball
function createBall()
	local ballName = display.newCircle(halfW, halfH, 10)
	ballName:setFillColor(.3, .2, .5)
	return ballName
end


-- function that move the pad up
function moveLeftPadUp(object)
	object.y = object.y - speed
end


-- function that move the pad down
function moveLeftPadDown(object)
	object.y = object.y + speed
end


-- draw pads
local leftPad = createPads(0, halfH)
leftPad:setFillColor(.6, .1, .2)
physics.addBody(leftPad, "static", {density = 1.0, friction = 0, bounce = 1, isSensor = false})

local rightPad = createPads(screenW, halfH)
rightPad:setFillColor(.2, .5, .6)
physics.addBody(rightPad, "static", {density = 1.0, friction = 0, bounce = 1, isSensor = false})
--transition.to( rightPad, { time=2000, y=, iterations=2, delta=true} )


-- draw ball
local ball = createBall()
ball:setFillColor(0/255, 25/255, 51/255)
physics.addBody(ball, "dynamic", {density = 1, friction = 0, bounce = 1, isSensor = false, radius = 15})
ball.isBullet = false
ball:applyForce(200, 50)


-- use bird as animation
local birdSpriteSheet = graphics.newImageSheet("robin.png", {width=240, height=314, numFrames=22})
local birdSprite = display.newSprite(birdSpriteSheet, {name="birdFlying", start=1, count=22, time=1000})
birdSprite.x = halfW-30
birdSprite.y = halfH-30
birdSprite.xScale = .4
birdSprite.yScale = .4
birdSprite:play()

physics.addBody(birdSprite, "dynamic", {density = 1, friction = 0, bounce = 1, isSensor = false, radius = 15})
birdSprite.isBullet = false


-- draw scoreboard
local score = display.newText("0", 470, 30, native.systemFont, 20)
score:setFillColor(0, 0, 0)


-- collision to ball
local function onCollisionBall(event)
  print("onCollisionBall")
  score.text = score.text + 1
end


local function onCollisionBird(event)
	print("bird Collision")
end



-- create wall objects
local topWall = display.newRect( halfW, 0, display.contentWidth + 60, 10 )
topWall:setFillColor(0,0,0)

local bottomWall = display.newRect( halfW, screenH, display.contentWidth + 60, 10 )
bottomWall:setFillColor(0,0,0)

local leftWall = display.newRect( -40, halfH, 10, display.contentHeight )
leftWall:setFillColor(.5,.5,.5)

local rightWall = display.newRect( display.contentWidth + 40, halfH, 10, display.contentHeight )
rightWall:setFillColor(100/255,50/255,100/255)


-- make them physics bodies
physics.addBody(topWall, "static", {density = 1.0, friction = 0, bounce = 1, isSensor = false})
physics.addBody(bottomWall, "static", {density = 1.0, friction = 0, bounce = 1, isSensor = false})
physics.addBody(leftWall, "static", {density = 1.0, friction = 0, bounce = 1, isSensor = false})
physics.addBody(rightWall, "static", {density = 1.0, friction = 0, bounce = 1, isSensor = false})


-- left pad draggable
function leftPad:touch( event )
    if event.phase == "began" then
        self.markY = self.y

    elseif event.phase == "moved" then
        local y = (event.y - event.yStart) + self.markY
        self.y = y
    end
    return true
end


ball:addEventListener("collision", onCollisionBall)
birdSprite:addEventListener("collision", onCollisionBird)
leftPad:addEventListener( "touch", leftPad )

--[[ 

++ References ++

Title		 				Link
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Doing a ball bounce			http://www.ludicroussoftware.com/blog/2011/09/01/corona-physics-forced-bouncing/
Drag objects 				https://coronalabs.com/blog/2011/09/24/tutorial-how-to-drag-objects/
---------------------------------------------------------------------------------------------------------------------------------------------------------------------

]]--