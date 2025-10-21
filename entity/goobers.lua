require("lib/lib")
camera = require("lib/camera")
require("time")

enemy = {}
enemy.__index = enemy

deadEnemies = {}

windowX, windowY = love.graphics.getPixelDimensions()

function enemy:new(x, y, targetX, targetY, dx, dy, gfx, baseLerp, lifetime)
	local radius = math.random(500, 800)
	local theta = math.random() * 2*math.pi
	local obj = {
		x = targetX + radius * math.cos(theta),
		y = targetY + radius * math.sin(theta),
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
	if not rot then
		self.rot = self.rot + 0.1
		love.graphics.draw(self.gfx, self.x, self.y, math.sin(self.rot), self.scaling, self.scaling, self.gfxX, self.gfxY)
		return
	end
    love.graphics.draw(self.gfx, self.x, self.y, math.sin(rot), self.scaling, self.scaling, self.gfxX, self.gfxY)
end

function enemy:deathAnim()
	love.graphics.draw(self.gfx, self.x, self.y, math.rad(self.rot), self.scaling, self.scaling, self.gfxX, self.gfxY)
end

function enemy:move(dt, targetX, targetY)
	self.lifetime = self.lifetime - 1
	if self.lifetime <= 0 then return true end
	self.x = lerp(self.x, targetX, self.baseLerp)
	self.y = lerp(self.y, targetY, self.baseLerp)

	return false
end

function enemy:handleEnemyDeath(playerX, playerY, hitboxRadius)
    local distX = playerX - self.x
    local distY = playerY - self.y
    local distanceSq = distX * distX + distY * distY
    local radiusSum = hitboxRadius + self.hitboxRadius

    return distanceSq <= radiusSum * radiusSum
end

-- function enemy:closest()

-- end

function enemy:addToEndScreen()
	table.insert(deadEnemies, self)
	--print(self)
end