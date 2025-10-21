require("lib/lib")
require("time")
require("config/diffconfig")
require("entity/projectiles")

player = {}
player.__index = player

function player:new(x, y, gfx)
	local obj = {
		x = x or 100,
		y = y or 100,
		dx = 0,
		dy = 0,
		speed = 21,
		gfx = gfx or love.graphics.newImage("gfx/player.png"),
		gfxX = gfx:getWidth()/2,
        gfxY = gfx:getHeight()/2,
		hitboxRadius = gfx:getWidth(),
		shootDelay = 4, --frames
		shootCount = 3,
		inputs = {
			["up"] = false,
			["down"] = false,
			["left"] = false,
			["right"] = false,
			["shoot"] = false
		}
	}
	setmetatable(obj, player)
	return obj
end

-- function player:moveX(start, targetX, t)
-- 	self.x = lerp(self.x, targetX, t)
-- end

function player:move()
	local dx, dy = 0, 0
	if love.keyboard.isDown("w") or love.keyboard.isDown("up") then dy = dy - 1 end
	if love.keyboard.isDown("s") or love.keyboard.isDown("down") then dy = dy + 1 end
	if love.keyboard.isDown("a") or love.keyboard.isDown("left") then dx = dx - 1 end
	if love.keyboard.isDown("d") or love.keyboard.isDown("right") then dx = dx + 1 end
	if dx ~= 0 and dy ~= 0 then
		dx = dx * 0.7071
		dy = dy * 0.7071
	end
	self.x = self.x + self.speed * dx
	self.y = self.y + self.speed * dy
end

function player:shoot(gfx, x, y, targetX, targetY, lifetime, speed, rot)
	print("projectile start: "..x, y)
	projectiles:new(gfx, x, y, targetX, targetY, lifetime, speed, rot)
end

function player:draw()
	print(self.x, self.y)
	love.graphics.draw(self.gfx, self.x, self.y, 0, 2, 2, self.gfxX, self.gfxY)
end