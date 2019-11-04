saturn_small = {}
saturn_small_Collision = false
saturn_small_Looped = false


screen.w = love.graphics.getWidth()
screen.h = love.graphics.getHeight()


function saturn_small:new(world)

	self.e = true

	-- world = love.physics.newWorld(0, 0, false)

	self.b = love.physics.newBody(world, screen.w / 2 + 70 ,screen.h /2 , "static")
	self.b:setMass(20)
	self.s = love.physics.newCircleShape(10)
	self.f = love.physics.newFixture(self.b, self.s)
	self.f:setRestitution(-1)    -- make it bouncy
	--planet.b:setGravityScale( 0.0 )
	self.f:setUserData("saturn_small")

	return self
end

-- function saturn_small:update(dt)
--
-- 	self.x = self.x + self.dx * dt * 0x40
-- 	self.y = self.y + self.dy * dt * 0x40
--
-- 	if self.x < - love.graphics.getWidth()	or self.x > love.graphics.getWidth() * 2
-- 	or self.y < - love.graphics.getWidth()	or self.y > love.graphics.getHeight() * 2 then
--
-- 		self.e = nil
-- 	end
-- end

function saturn_small:draw()

	self.e = true

	world = love.physics.newWorld(0, 0, false)

	self.b = love.physics.newBody(world, screen.w / 2 + 70 ,screen.h /2 , "static")
	self.b:setMass(20)
	self.s = love.physics.newCircleShape(10)
	self.f = love.physics.newFixture(self.b, self.s)
	self.f:setRestitution(-1)    -- make it bouncy
	--planet.b:setGravityScale( 0.0 )
	self.f:setUserData("saturn_small")



	-- if (self ~= nil) then

		if (saturn_small_Looped == true) then
			love.graphics.setColor(255, 150, 0, 255)
			love.graphics.circle("fill", self.b:getX(),self.b:getY(), self.s:getRadius(), 40)
		else
			love.graphics.setColor(255, 0, 255, 150)
			love.graphics.circle("line", self.b:getX(),self.b:getY(), self.s:getRadius(), 40)
		end
	-- end

end
