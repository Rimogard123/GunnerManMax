require("lib")
require("time")

enemy = {}
enemy.__index = enemy

deadEnemies = {}

windowX, windowY = love.graphics.getPixelDimensions()

function enemy:new(x, y, targetX, targetY, dx, dy, gfx, baseLerp, lifetime)
	local obj = {
		x = x or 400,
		y = y or 400,
		targetX = targetX,
		targetY = targetY,
		dx = dx or 0,
		dy = dy or 0,
		gfx = gfx or love.graphics.newImage("gfx/enemy.png"),
		movePattern = movePattern or "lerp",
		pointsValue = 100,
		lifetime = math.random(lifetime, lifetime*2),
		baseLerp= math.random() * baseLerp,
		scaling= randomFloat(3,4,5),
		gfxX = gfx:getWidth()/2,
        gfxY = gfx:getHeight()/2,
		hitboxRadius = gfx:getWidth()*2,
        rot= 0
	}
	setmetatable(obj, enemy)
	return obj
end

function enemy:draw(rot)
	rot = rot or self.rot + self.baseLerp + 0.02
    love.graphics.draw(self.gfx, self.x, self.y, math.sin(rot), self.scaling, self.scaling, self.gfxX, self.gfxY)
end

function enemy:move(dt, targetX, targetY)
	self.lifetime = self.lifetime - 1
	if self.lifetime <= 0 then return true end
	self.x = lerp(self.x, targetX, self.baseLerp)
	self.y = lerp(self.y, targetY, self.baseLerp)

	return false
end

-- function enemy:handleEnemyDeath(playerX, playerY, playerRadius)
-- 	return (
-- 		(playerX < self.x + self.gfxX^2) and
-- 		(playerX + playerRadius > self.x) and
-- 		(playerY < self.y + self.gfxY^2) and
-- 		(playerY + playerRadius > self.y)
-- 	)
-- end

function enemy:handleEnemyDeath(playerX, playerY, hitboxRadius)
    local dx = playerX - self.x
    local dy = playerY - self.y
    local distanceSq = dx * dx + dy * dy
    local radiusSum = hitboxRadius + self.hitboxRadius

    return distanceSq <= radiusSum * radiusSum
end

function enemy:addToEndScreen()
	table.insert(deadEnemies, self)
end