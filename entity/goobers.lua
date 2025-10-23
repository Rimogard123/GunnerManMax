local lib = require("lib/lib")
camera = require("lib/camera")
require("time")
require("entity/projectiles")

enemy = {}
enemy.__index = enemy

local types = {"enemy1", "crawler", "zoomer","gooner"}
local typeConfig = {
	["enemy1"] = {
		gfx = love.graphics.newImage("gfx/enemy.png"),
		baseLerp = 1,
		scaling = 1,
		lifetime = 1,
		pointsValue = 1
	},
	["crawler"] = {
		gfx = love.graphics.newImage("gfx/crawler.png"),
		baseLerp = 0.1,
		scaling = 1.6,
		lifetime = 3,
		pointsValue = 10
	},
	["zoomer"] = {
		gfx = love.graphics.newImage("gfx/zoomer.png"),
		baseLerp = 3.5,
		scaling = 0.8,
		lifetime = 0.35,
		pointsValue = 1.5
	},
["gooner"] = {
		gfx = love.graphics.newImage("gfx/gooner.png"),
		baseLerp = 0.8,
		scaling = 1.2,
		lifetime = 0.6,
		pointsValue = 7.5,
		shotspeed= 2,
		shotsper= 2
	}
}
deadEnemies = {}
totalSpawned = 0

windowX, windowY = love.graphics.getPixelDimensions()

function enemy:new(x, y, targetX, targetY, dx, dy, gfx, baseLerp, lifetime)
	totalSpawned = totalSpawned + 1
	local rng = math.random()
	local chosen
	if rng > 0.9 or totalSpawned % 10 == 0 and totalSpawned ~= 0 then
		chosen = types[math.random(2, #types)]
	else
		chosen = "enemy1"
	end
	local radius = math.random(500, 800)
	local theta = math.random() * 2*math.pi
	local obj = {
		type= chosen,
		x = targetX + radius * math.cos(theta),
		y = targetY + radius * math.sin(theta),
		dx = dx or 0,
		dy = dy or 0,
		gfx = gfx or love.graphics.newImage("gfx/enemy.png"),
		pointsValue = 10,
		lifetime = math.random(lifetime, lifetime*2),
		baseLerp= lib.clamp(math.random() * baseLerp, 0.01, 1),
		scaling= lib.randomFloat(3,4,5),
		gfxX = gfx:getWidth()/2,
        gfxY = gfx:getHeight()/2,
		hitboxRadius = gfx:getWidth()*2,
        rot= 0,
        shotspeed= 0,
        shotsper= 0,
        spawnPos= 0,
        radius= radius,
        theta= theta
	}
	for k, v in pairs(typeConfig[chosen]) do
		if k == "gfx" then
			obj[k] = v
		elseif type(v) == "number" then
			obj[k] = obj[k] * v
		else
			obj[k] = v
		end
	end
	obj.hitboxRadius = obj.hitboxRadius * typeConfig[chosen].scaling
	obj.baseLerp = lib.clamp(obj.baseLerp, 0, 0.09)
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

	if self.type== "gooner" then
			self.lifetime = self.lifetime - 1
	if self.lifetime <= 0 then return true end
	self.x = targetX + self.radius *0.7 * math.cos(self.theta)
	self.y = targetY  + self.radius *0.7 * math.sin(self.theta)

		projectiles:new("goonerbullet", self.x, self.y, targetX, targetY, 60, 10, angle)
	else
	self.lifetime = self.lifetime - 1
	if self.lifetime <= 0 then return true end
	self.x = lib.lerp(self.x, targetX, self.baseLerp)
	self.y = lib.lerp(self.y, targetY, self.baseLerp)
end
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