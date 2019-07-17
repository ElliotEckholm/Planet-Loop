Gamestate = require "gamestate"

screen = {}
screen.w = 568
screen.h = 320
touch = {}
lastTouch = {}
currentTouch = {}
local touches = {}
planetCollision = {
    delayParticles = 0
}

numTouches = {
  balance = 0,
}

moonCollision = {
    delayWin = 0,
    hit = false
}

loseDelay = 0



sun = {}
touchDistance = {}
launchConstant = {}
launchForce = {}

moon = {}

earth = {}
earthDistance = {}
earthConstant = {}
earthGravforce = {}

planet1 = {}
distance1 = {}
g1 = {}
gravforce1 = {}

planet2 = {}
distance2 = {}
g2 = {}
gravforce2 = {}

button = {}

-- pause gamestate
Pause = Gamestate.new()
LevelMenu = Gamestate.new()
Welcome = Gamestate.new()
Game = Gamestate.new()
Won = Gamestate.new()
Lose = Gamestate.new()



function Welcome:draw()
    love.graphics.setColor(0, 255, 50, 150)
    love.graphics.print("LEVEL Tap Screen to Play",screen.w / 2 - 70 , screen.h / 2)
end


function Welcome:update(dt)

  if (Gamestate.current() == Welcome) then

    local touches = love.touch.getTouches()
    for i, id in ipairs(touches) do
      --touch.x, touch.y = love.touch.getPosition(id)
      Gamestate.push(LevelMenu)
      numTouches.balance = numTouches.balance + 1

    end
  end

end

--function LevelMenu:enter(from)
--    self.from = from -- record previous state
--end

function LevelMenu:draw()
    love.graphics.setColor(0, 255, 50, 150)
    love.graphics.print("LEVEL SCREEN",screen.w / 2 - 70 , screen.h / 2)

    local touchSize = 0

    local touches = love.touch.getTouches()
    for i, id in ipairs(touches) do
      --touch.x, touch.y = love.touch.getPosition(id)
      --numTouches.balance = numTouches.balance + 1
      touchSize = touchSize + 1

      if (Gamestate.current() == LevelMenu and touchSize == 1) then

        Gamestate.switch(Game)
        print(touchSize)

      end

    end







end


function LevelMenu:enter()




    if (numTouches.balance > 0) then
      local touches = love.touch.getTouches()
      for i, id in ipairs(touches) do
        --touch.x, touch.y = love.touch.getPosition(id)
          numTouches.balance = numTouches.balance + 1
          --Gamestate.switch(Game)

      end



    end


end

function LevelMenu:update()




      local touchSize = 0

      local touches = love.touch.getTouches()
      for i, id in ipairs(touches) do
        --touch.x, touch.y = love.touch.getPosition(id)
        --numTouches.balance = numTouches.balance + 1
        touchSize = touchSize + 1

      end

    if (touchSize > 1) then

      Gamestate.switch(Game)

    end


end


function Pause:enter(from)
    self.from = from -- record previous state
end

function Pause:draw()
    local W, H = love.graphics.getWidth(), love.graphics.getHeight()
    -- draw previous screen
    --self.from:draw()
    -- overlay with pause message
    love.graphics.setColor(0,0,0, 100)
    love.graphics.rectangle('fill', 0,0, W,H)
    love.graphics.setColor(255,255,255)
    love.graphics.printf('PAUSE', 0, H/2, W, 'center')
end



function Won:draw()
    love.graphics.setColor(0, 255, 50, 150)
    love.graphics.print("You Won!",screen.w / 2 - 70 , screen.h / 2)
    love.graphics.print("Tap Screen To Play Next Level",screen.w / 2 - 140 , screen.h / 2 + 30)
end

function Won:update(dt)


  local touches = love.touch.getTouches()
  for i, id in ipairs(touches) do
    --touch.x, touch.y = love.touch.getPosition(id)
    Gamestate.switch(Game)
  end

end

function Lose:draw()
    love.graphics.setColor(0, 255, 50, 150)
    love.graphics.print("You Lost :(",screen.w / 2 - 70 , screen.h / 2)
    love.graphics.print("Tap Screen To Replay Level",screen.w / 2 - 140 , screen.h / 2 + 30)
end

function Lose:update(dt)

  local touches = love.touch.getTouches()
  for i, id in ipairs(touches) do
    --touch.x, touch.y = love.touch.getPosition(id)
    Gamestate.switch(Game)
  end

end

function Game:enter()

  moonCollision.hit = false

  planet1Collision = false
  planet2Collision = false
  planet1Looped = false
  planet2Looped = false

  button.x = screen.w - 80
  button.y = screen.h - 80
  button.width = 50
  button.height = 50

  world = love.physics.newWorld(0, 0, false)

      sun.b = love.physics.newBody(world, 50 ,screen.h /2 + 13, "dynamic")
      sun.b:setMass(10)
      sun.s = love.physics.newCircleShape(5)
      sun.f = love.physics.newFixture(sun.b, sun.s)
      sun.f:setRestitution(-1)    -- make it bouncy
      sun.f:setUserData("sun")

      moon.b = love.physics.newBody(world, 0, 0, "static")
      moon.b:setMass(10)
      --moon.s = love.physics.newRectangleShape(30, 60)
      --moon.s = love.physics.newPolygonShape( screen.w/2, screen.h /2,
      --screen.w/2 - 30, screen.h /2 - 30, screen.w/2 - 40, screen.h /2 + 40)
      moon.s = love.physics.newPolygonShape( screen.w - 40, screen.h /2,
      screen.w - 20, screen.h /2 + 10,   screen.w - 20, screen.h /2 + 30,
      screen.w - 40, screen.h /2 + 40, screen.w - 30, screen.h /2 + 30,
      screen.w - 30, screen.h /2 + 10)--]]
      moon.f = love.physics.newFixture(moon.b, moon.s)
      moon.f:setRestitution(-1)    -- make it bouncy
      moon.f:setUserData("moon")

      earth.b = love.physics.newBody(world, 50 ,screen.h /2 , "static")
      earth.b:setMass(20)
      earth.s = love.physics.newCircleShape(15)
      earth.f = love.physics.newFixture(earth.b, earth.s)
      earth.f:setRestitution(0)    -- make it bouncy
      --planet.b:setGravityScale( 0.0 )
      earth.f:setUserData("earth")


      planet1.b = love.physics.newBody(world, screen.w / 2 + 70 ,screen.h /2 , "static")
      planet1.b:setMass(20)
      planet1.s = love.physics.newCircleShape(10)
      planet1.f = love.physics.newFixture(planet1.b, planet1.s)
      planet1.f:setRestitution(-1)    -- make it bouncy
      --planet.b:setGravityScale( 0.0 )
      planet1.f:setUserData("planet1")

      planet2.b = love.physics.newBody(world, screen.w / 2 - 70 ,screen.h /2 - 50 , "static")
      planet2.b:setMass(20)
      planet2.s = love.physics.newCircleShape(10)
      planet2.f = love.physics.newFixture(planet2.b, planet2.s)
      planet2.f:setRestitution(-1)    -- make it bouncy
      --planet.b:setGravityScale( 0.0 )
      planet2.f:setUserData("planet2")



----[[
  bottomWall = {}
      bottomWall.b = love.physics.newBody(world, screen.w / 2,screen.h , "static")
      bottomWall.s = love.physics.newRectangleShape(screen.w,20)
      bottomWall.f = love.physics.newFixture(bottomWall.b, bottomWall.s)
      bottomWall.f:setUserData("bottomWall")
  topWall = {}
      topWall.b = love.physics.newBody(world, screen.w / 2,0 , "static")
      topWall.s = love.physics.newRectangleShape(screen.w,20)
      topWall.f = love.physics.newFixture(topWall.b, topWall.s)
      topWall.f:setUserData("topWall")
  leftWall = {}
      leftWall.b = love.physics.newBody(world, 0 , screen.h / 2 , "static")
      leftWall.s = love.physics.newRectangleShape(20,screen.h)
      leftWall.f = love.physics.newFixture(leftWall.b, leftWall.s)
      leftWall.f:setUserData("leftWall")
  rightWall = {}
      rightWall.b = love.physics.newBody(world, screen.w , screen.h / 2 , "static")
      rightWall.s = love.physics.newRectangleShape(20,screen.h)
      rightWall.f = love.physics.newFixture(rightWall.b, rightWall.s)
      rightWall.f:setUserData("rightWall")
--]]
    -- setup entities here


    local img = love.graphics.newImage('pictures/particle.png')

    	psystem = love.graphics.newParticleSystem(img, 32)
    	psystem:setParticleLifetime(4, 6) -- Particles live at least 2s and at most 5s.
    	psystem:setEmissionRate(5)
    	psystem:setSizeVariation(1)
    	psystem:setLinearAcceleration(-7, -7, 7, 7) -- Random movement in all directions.
    	psystem:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to transparency.

end

function Game:update(dt)





  planetCollision.delayParticles = planetCollision.delayParticles - dt

  moonCollision.delayWin = moonCollision.delayWin - dt

  psystem:update(dt)


  world:update(dt)
  world:setCallbacks( beginContact, endContact)

  ---------------------For Earth------------------------------------------

  earthDistance.x = earth.b:getX() - sun.b:getX()
  earthDistance.y = earth.b:getY() - sun.b:getY()

  earthRadius = math.sqrt( math.pow(earthDistance.x, 2) + math.pow(earthDistance.y, 2) )
  earthConstant.x = 3
  earthConstant.y = 3
  earthGravforce.x = (math.pow(earthConstant.x,6)  ) / (math.pow(earthRadius,2))
  earthGravforce.y = (math.pow(earthConstant.y,6) ) / (math.pow(earthRadius,2))

  if (earthDistance.x < 0) then
    earthGravforce.x = -1 * earthGravforce.x
  end
  if (earthDistance.y < 0) then
    earthGravforce.y = -1 * earthGravforce.y
  end

  sun.b:applyForce( earthGravforce.x, earthGravforce.y, sun.b:getX(),sun.b:getY() )

  -----------------------For Planet 1------------------------------------------
  distance1.x = planet1.b:getX() - sun.b:getX()
  distance1.y = planet1.b:getY() - sun.b:getY()
  radius1 = math.sqrt( math.pow(distance1.x, 2) + math.pow(distance1.y, 2) )
  g1.x = 5
  g1.y = 5
  gravforce1.x = (math.pow(g1.x,6)  ) / (math.pow(radius1,2))
  gravforce1.y = (math.pow(g1.y,6)) / (math.pow(radius1,2))

  if (distance1.x < 0) then
    gravforce1.x = -1 * gravforce1.x
  end
  if (distance1.y < 0) then
    gravforce1.y = -1 * gravforce1.y
  end

  sun.b:applyForce( gravforce1.x, gravforce1.y, sun.b:getX(),sun.b:getY() )

  ---------------------For Planet 2------------------------------------------
  distance2.x = planet2.b:getX() - sun.b:getX()
  distance2.y = planet2.b:getY() - sun.b:getY()
  radius2 = math.sqrt( math.pow(distance2.x, 2) + math.pow(distance2.y, 2) )
  g2.x = 5
  g2.y = 5
  gravforce2.x = (math.pow(g2.x,6)  ) / (math.pow(radius2,2))
  gravforce2.y = (math.pow(g2.y,6)) / (math.pow(radius2,2))

  if (distance2.x < 0) then
    gravforce2.x = -1 * gravforce2.x
  end
  if (distance2.y < 0) then
    gravforce2.y = -1 * gravforce2.y
  end

  sun.b:applyForce( gravforce2.x, gravforce2.y, sun.b:getX(),sun.b:getY() )

  local touches2 = love.touch.getTouches()
  for i, id in ipairs(touches2) do
    touch.x, touch.y = love.touch.getPosition(id)

  end




  if (radius1 <= 50) then
    planet1Looped = true
  elseif (radius2 <= 50) then
    planet2Looped = true
  end

----[[
  if love.keyboard.isDown("right") then
     sun.b:applyForce(10, 0)
  elseif love.keyboard.isDown("left") then
     sun.b:applyForce(-10, 0)
  end
  if love.keyboard.isDown("up") then
     sun.b:applyForce(0, -10)
  elseif love.keyboard.isDown("down") then
     sun.b:applyForce(0, 10)
  end
--]]
end

function Game:draw()
  --Line segment between sun and finger tap
  if (launchPressed == false) then
    love.graphics.setColor(255, 0, 0, 150)
    love.graphics.line( sun.b:getX(), sun.b:getY(), touch.x, touch.y)
  elseif (launchPressed == true and touchPressed == true) then
    love.graphics.setColor(255, 0, 0, 150)
    love.graphics.line( sun.b:getX(), sun.b:getY(), sun.b:getX(), sun.b:getY())
  end
  --love.graphics.line( sun.b:getX(), sun.b:getY(), planet.b:getX(), planet.b:getY())
  --Sun
  love.graphics.setColor(255, 255, 0, 150)
  love.graphics.circle("fill", sun.b:getX(),sun.b:getY(), sun.s:getRadius(), 40)
  --Moon
  love.graphics.setColor(255, 255, 255, 150)
  local vertices = {screen.w - 40, screen.h /2,
  screen.w - 20, screen.h /2 + 10,   screen.w - 20, screen.h /2 + 30,
  screen.w - 40, screen.h /2 + 40, screen.w - 30, screen.h /2 + 30,
  screen.w - 30, screen.h /2 + 10}

  --[[local vertices = {screen.w - 30, screen.h /2 + 10,
  screen.w - 30, screen.h /2 + 30,screen.w - 40, screen.h /2 + 40,
  screen.w - 20, screen.h /2 + 30, screen.w - 20, screen.h /2 + 10,
  screen.w - 40, screen.h /2}
--]]

--love.graphics.polygon( "line", vertices )
love.graphics.polygon( "line", moon.s:getPoints() )
  --earth
  love.graphics.setColor(0, 0, 255, 150)
  love.graphics.circle("line", earth.b:getX(),earth.b:getY(), earth.s:getRadius(), 40)

  --Planet1
  love.graphics.setColor(255, 0, 255, 150)
  love.graphics.circle("line", planet1.b:getX(),planet1.b:getY(), planet1.s:getRadius(), 40)
  --love.graphics.setColor(100, 100, 100, 150)
  --love.graphics.circle("line", planet1.b:getX(),planet1.b:getY(), 50, 40)
  --if (planet1Collision == true) then
    --love.graphics.setColor(255, 150, 0, 255)
    --love.graphics.circle("fill", planet1.b:getX(),planet1.b:getY(), planet1.s:getRadius(), 40)
  --end
  if (planet1Looped == true) then
    love.graphics.setColor(255, 150, 0, 255)
    love.graphics.circle("fill", planet1.b:getX(),planet1.b:getY(), planet2.s:getRadius(), 40)
  end
  --Planet2
  love.graphics.setColor(0, 255, 50, 150)
  love.graphics.circle("line", planet2.b:getX(),planet2.b:getY(), planet2.s:getRadius(), 40)
  --love.graphics.setColor(100, 100, 100, 150)
  --love.graphics.circle("line", planet2.b:getX(),planet2.b:getY(), 50, 40)
  --if (planet2Collision == true) then
    --love.graphics.setColor(255, 150, 0, 255)
    --love.graphics.circle("fill", planet2.b:getX(),planet2.b:getY(), planet2.s:getRadius(), 40)
  --end
  if (planet2Looped == true) then
    love.graphics.setColor(255, 150, 0, 255)
    love.graphics.circle("fill", planet2.b:getX(),planet2.b:getY(), planet2.s:getRadius(), 40)
  end
  love.graphics.setColor(100, 100, 100, 150)
----[[
  love.graphics.polygon("line", bottomWall.b:getWorldPoints(bottomWall.s:getPoints()))
  love.graphics.polygon("line", topWall.b:getWorldPoints(topWall.s:getPoints()))
  love.graphics.polygon("line", leftWall.b:getWorldPoints(leftWall.s:getPoints()))
  love.graphics.polygon("line", rightWall.b:getWorldPoints(rightWall.s:getPoints()))
  --]]

  --launch button
  love.graphics.setColor(200, 0, 0, 150)
  love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)
  love.graphics.setColor(255, 255, 255, 150)
  love.graphics.print("LAUNCH",button.x , button.y + 16)


if (planetCollision.delayParticles > 0) then
   	   love.graphics.draw(psystem, particleX, particleY)
end

if (moonCollision.delayWin <= 0 and moonCollision.hit == true) then
  Gamestate.switch(Won)
end

end

function love.touchpressed( id, x, y, dx, dy, pressure )
    touchPressed = true
    touchReleased = false

    local touches2 = love.touch.getTouches()
    for i, id in ipairs(touches2) do
      touch.x, touch.y = love.touch.getPosition(id)

    end

    if (Gamestate.current() == Game)  then

      if (touch.x < button.x + button.width and touch.x > button.x and
        touch.y < button.y + button.height and touch.y > button.y) then
            print("Launch!")
            launchPressed = true
          else
            launchPressed = false

          end
      end


--[[
      if Gamestate.current() ~= Pause and numTouches == 2  then
          return Gamestate.push(Pause)
      elseif numTouches == 2 then
          return Gamestate.pop() -- return to previous state
      end
--]]

end

function  love.touchreleased(id, x, y, dx, dy, pressure)
    touchReleased = true
    --touchPressed = false

if (Gamestate.current() == Game) then

    local t = {
    		id = id,
    		x = x,
    		y = y,
    		dx = dx,
    		dy = dy,
    		p = pressure
    	}
    	table.insert(touches, t)



    numTouches = 0


    for i, touch in ipairs(touches) do
      numTouches = numTouches + 1

      --touch.x, touch.y = love.touch.getPosition(touches[numTouches].id)
    end




    if (launchPressed == true ) then

      print(numTouches - 1)
      lastTouch.x = touches[numTouches - 1].x
      lastTouch.y = touches[numTouches - 1].y


      --print(lastTouch.x)

      touchDistance.x = lastTouch.x - sun.b:getX()
      touchDistance.y = lastTouch.y - sun.b:getY()

      launchConstant.x = .05
      launchConstant.y = .05

      launchForce.x = (launchConstant.x ) * (touchDistance.x)
      launchForce.y = (launchConstant.y ) * (touchDistance.y)


      sun.b:applyLinearImpulse(launchForce.x, launchForce.y, sun.b:getX(),sun.b:getY() )
      --]]

    end

  end

    --Applying force in direction that finger taps
  ----[[


end


function beginContact(a, b, coll)

  if (a:getUserData() == "moon" and b:getUserData() == "sun") then

    particleX = sun.b:getX()
    particleY = sun.b:getY()

    moonCollision.delayWin = .5

    moonCollision.hit = true


  elseif (b:getUserData() == "moon" and a:getUserData() == "sun") then

    particleX = sun.b:getX()
    particleY = sun.b:getY()

    moonCollision.delayWin = .5
    moonCollision.hit = true



    --vx, vy = coll:getVelocity()
  elseif (b:getUserData() == "planet1" and a:getUserData() == "sun") then

    planet1Collision = true
    planetCollision.delayParticles = 1
    particleX = sun.b:getX()
    particleY = sun.b:getY()



  elseif (b:getUserData() == "planet2" and a:getUserData() == "sun") then
    planetCollision.delayParticles = 1
    planet2Collision = true
    particleX = sun.b:getX()
    particleY = sun.b:getY()



  end
  if (a:getUserData() == "bottomWall" and b:getUserData() == "sun") then

    --Gamestate.switch(Lose)
  elseif (a:getUserData() == "topWall" and b:getUserData() == "sun") then
    --Gamestate.switch(Lose)
  elseif (a:getUserData() == "leftWall" and b:getUserData() == "sun") then
    --Gamestate.switch(Lose)
  elseif (a:getUserData() == "rightWall" and b:getUserData() == "sun") then
    --Gamestate.switch(Lose)
  end

end

function endContact(a, b, coll)
  if (a:getUserData() == "moon" and b:getUserData() == "sun") then



  end
  if (b:getUserData() == "moon" and a:getUserData() == "sun") then


  end
  if (b:getUserData() == "planet1" and a:getUserData() == "sun") then

    planet1Collision = false

  end
  if (b:getUserData() == "planet2" and a:getUserData() == "sun") then

    planet2Collision = false


  end
end


function love.load()

  Gamestate.registerEvents()
  Gamestate.switch(Welcome)

end

function love.update(dt)
  Gamestate.update(dt) -- pass dt to currentState:update(dt)
end

function love.draw()
    Gamestate.draw() -- <callback> is `draw'
end
