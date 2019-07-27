--[[
	This is a short example of how to create a scene class that is inheriting from Scene

	by: Michael Binder Nov-2017
]]


-- importing the class lib for making classes available in lua
local class = require("libs/middleclass")

-- importing the composer and scene class
require("libs/Composer")
require("libs/Scene")

Gamestate = require "gamestate"
require ("objects/stars")
require ("objects/comets")


--Globals
screen = {}

screen.w = love.graphics.getWidth()
screen.h = love.graphics.getHeight()
bigFont = love.graphics.newFont(50)
medFont = love.graphics.newFont(30)
nasaRed = {252 /255, 61/255, 33/255, 1}
nasaBlue = {11 /255, 61/255, 145/255, 1}

cometTimer = 1

-- inheriting from Scene
Welcome = Scene:subclass("Welcome")

-- every scene must have an initialize function
-- here goes everything that has to be done once and before the scene is shown
function Welcome:initialize()
	-- call super.initialize is crucial, so are the arguments self and name (Scene1)
	-- each scene must have a unique name
	Scene.initialize(self, "Welcome")
end

-- here goes the code that would normally go in love.update()
-- eg. game logic ... etc.
function Welcome:update(dt)
		stars:update()

		--create new comet every frame update
		cometTimer = cometTimer - dt
	   if cometTimer <= 0 then
	     comet:new()
	     local leftover = math.abs(cometTimer)
	     cometTimer = 1 - leftover
	   end


		if comet.e then comet:update(dt) end



end

-- here goes the code that would normally go in love.draw()
-- eg. drawing images
function Welcome:draw()

	--draw stars
	stars:draw()

	--draw comets
	if comet.e then comet:draw() end

	--Draw title
	love.graphics.setFont(bigFont)
	love.graphics.setColor(unpack(nasaRed))
	love.graphics.print("Planet         ",screen.w / 2 - (bigFont:getWidth("Planet         ")/2) , screen.h / 2 - (bigFont:getHeight("Planet         ")/2))
	love.graphics.setColor(unpack(nasaBlue))
	love.graphics.print("         Loop",screen.w / 2 - (bigFont:getWidth("         Loop")/2) , screen.h / 2 - (bigFont:getHeight("         Loop")/2))

end

-- if there is another scene than this one going to be shown, then this function
-- will automatically be called by the composer
-- so code to make this scene ready to be hidden goes here
-- eg. stop playing sounds etc...
function Welcome:hide()
end


-- Creating a new instance
-- this can be called everywhere as long as it is legit to love
Welcome:new()
