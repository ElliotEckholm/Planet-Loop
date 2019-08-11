
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

---Levels---
require("scenes/Levels/Level_1")
require("scenes/Levels/Level_2")



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

		print("Touch Pressed")

		local touches = love.touch.getTouches()
		for i, id in ipairs(touches) do
			touch.x, touch.y = love.touch.getPosition(id)
		end

		for i, id in ipairs(touches) do
			if composer:currentSceneName() == "Welcome" then
				composer:goToScene("LevelMenu")
			elseif composer:currentSceneName() == "LevelMenu" then

				---LEVEL 1---
				if (touch.x < level1_button.x + level1_button.width and touch.x > level1_button.x and
					touch.y < level1_button.y + level1_button.height and touch.y > level1_button.y) then
							print("Level 1 Selected")
							composer:goToScene("Level_1")
				end

				---LEVEL 2---
				if (touch.x < level2_button.x + level2_button.width and touch.x > level2_button.x and
					touch.y < level2_button.y + level2_button.height and touch.y > level2_button.y) then
							print("Level 2 Selected")
							composer:goToScene("Level_2")

				end



			elseif composer:currentSceneName() == "Level_1" then
				if (touch.x < level1_launch_button.x + level1_launch_button.width and touch.x > level1_launch_button.x and
					touch.y < level1_launch_button.y + level1_launch_button.height and touch.y > level1_launch_button.y) then
							print("Launch!")
							launchPressed = true
						else
							launchPressed = false
				end



				if (touch.x < pause_button.x + pause_button.width and touch.x > pause_button.x and
					touch.y < pause_button.y + pause_button.height and touch.y > pause_button.y) then
						print("restart!")
						print(restartPressed)
						restartPressed = true
						composer:goToScene("LevelMenu")

						composer:goToScene("Level_1")
						-- love.load()
						-- composer:drawCurrentScene()
						Level_1:initialize()
				else
					restartPressed = false

				end

			elseif composer:currentSceneName() == "Level_2" then
				if (touch.x < level2_launch_button.x + level2_launch_button.width and touch.x > level2_launch_button.x and
					touch.y < level2_launch_button.y + level2_launch_button.height and touch.y > level2_launch_button.y) then
							print("Launch!")
							launchPressed = true
						else
							launchPressed = false
				end
			end

    end


		return launchPressed
end
