
--[[
	This is a short example on how to set up simple scene management within love
	with Composer.lua and Scene.lua

	by: Michael Binder Nov-2017
]]


-- Import the composer and scene class
require("libs/Composer")
require("libs/Scene")

-- Import the  scenes
require("scenes/Scene1")
require("scenes/Scene2")
require("scenes/Welcome")
require("scenes/LevelMenu")
require("scenes/Levels/Level_1")



-- Reference to the composer
local composer

function love.load()
	-- creating a new composer object
	composer = Composer:new()
	-- set the scene to go to
	 love.window.setMode(0, 0, {fullscreen = true})
	composer:goToScene("Welcome")
end


function love.update(dt)
	-- update the current scene
	composer:updateCurrentScene(dt)
end


function love.draw()
	-- draw the current scene
	composer:drawCurrentScene()
end

-- change scene when hitting space bar
function love.keyreleased(key)
	if key == "space" then
		if composer:currentSceneName() == "Scene1" then
			composer:goToScene("Scene2")
		elseif composer:currentSceneName() == "Scene2" then
			composer:goToScene("Scene1")
		end
	end
end


function love.touchpressed( id, x, y, dx, dy, pressure )
    local touches = love.touch.getTouches()

		print("Touch Pressed")

		-- end

		touchPressed = true
		touchReleased = false

	

		local touches2 = love.touch.getTouches()
		for i, id in ipairs(touches2) do
			touch.x, touch.y = love.touch.getPosition(id)
		end


		-- print(touch.x)
		-- print(button.x + button.width)

		if (touch.x < button.x + button.width and touch.x > button.x and
			touch.y < button.y + button.height and touch.y > button.y) then
					print("Launch!")
					launchPressed = true
				else
					launchPressed = false

			end

		for i, id in ipairs(touches) do
			if composer:currentSceneName() == "Welcome" then
				composer:goToScene("LevelMenu")
			elseif composer:currentSceneName() == "LevelMenu" then
				composer:goToScene("Level_1")
			end

    end


		return launchPressed
end
