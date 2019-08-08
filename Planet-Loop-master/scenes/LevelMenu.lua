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
smallFont = love.graphics.newFont(10)
nasaRed = {252 /255, 61/255, 33/255, 1}
nasaBlue = {11 /255, 61/255, 145/255, 1}


cometTimer = 1

level1_button = {}
level1_button.x = screen.w/4
level1_button.y = screen.h/3
level1_button.width = 50
level1_button.height = 50

-- inheriting from Scene
LevelMenu = Scene:subclass("LevelMenu")

-- every scene must have an initialize function
-- here goes everything that has to be done once and before the scene is shown
function LevelMenu:initialize()
	-- call super.initialize is crucial, so are the arguments self and name (Scene1)
	-- each scene must have a unique name
	Scene.initialize(self, "LevelMenu")
end

-- here goes the code that would normally go in love.update()
-- eg. game logic ... etc.
function LevelMenu:update(dt)
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
function LevelMenu:draw()

	--draw stars
	stars:draw()

	--draw comets
	if comet.e then comet:draw() end

	--Draw title
	love.graphics.setFont(bigFont)
	love.graphics.setColor(1,1,1)
	love.graphics.print("Level         ",screen.w / 2 - (bigFont:getWidth("Level         ")/2) , screen.h / 6 - (bigFont:getHeight("Level         ")/2))
	love.graphics.setColor(1,1,1)
	love.graphics.print("         Menu",screen.w / 2 - (bigFont:getWidth("         Menu")/2) , screen.h / 6 - (bigFont:getHeight("         Menu")/2))


	--launch level1_button
  love.graphics.setColor(unpack(nasaBlue))
  love.graphics.rectangle("fill", level1_button.x, level1_button.y, level1_button.width, level1_button.height)
	love.graphics.setFont(medFont)
	love.graphics.setColor(1,1,1)
  love.graphics.print("1",level1_button.x + 16, level1_button.y +  10)

end

-- if there is another scene than this one going to be shown, then this function
-- will automatically be called by the composer
-- so code to make this scene ready to be hidden goes here
-- eg. stop playing sounds etc...
function LevelMenu:hide()
end


-- Creating a new instance
-- this can be called everywhere as long as it is legit to love
LevelMenu:new()
