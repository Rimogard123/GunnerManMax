projectiles = {
    active = {}
}
projectiles.__index = projectiles
projectiles.types = {["standard"]= love.graphics.newImage("gfx/bullet1.png"), ["goonerbullet"]=love.graphics.newImage("gfx/goonerbullet.png")}

function projectiles:new(gfx, x, y, targetX, targetY, lifetime, speed, rot)
    local angle = math.atan2(targetY - y, targetX - x)
    local dx = math.cos(angle) * speed
    local dy = math.sin(angle) * speed
local obj = {
    gfx = projectiles.types[gfx],
    x = x or 500,
    y = y or 500,
    dx = dx,
    dy = dy,
    lifetime = lifetime or 30,
    speed = speed or 2,
    rot = angle or 0,
    type = gfx
}
    setmetatable(obj, projectiles)
    table.insert(self.active, obj)
    return obj
end

function projectiles:update(dt,playerObj)
    for k, proj in pairs(self.active) do
        proj.lifetime = proj.lifetime - 1
        if proj.lifetime <= 0 then
            table.remove(self.active, k)
        else
            proj:move()

            -- PLAYER BULLETS: hit enemies
            if proj.type == "standard" then
                for e, enemy in pairs(enemies) do
                    if enemy:handleEnemyDeath(proj.x, proj.y, 4) then
                        proj.lifetime = 0
                        score:add(enemy.pointsValue)
                        table.remove(enemies, e)
                        break
                    end
                end
            end

            -- ENEMY BULLETS: hit player
            if proj.type == "goonerbullet" and not killed and playerObj then
                local dx = proj.x - playerObj.x
                local dy = proj.y - playerObj.y
                local distanceSq = dx * dx + dy * dy
                local hitRadius = playerObj.hitboxRadius

                if distanceSq <= (hitRadius * hitRadius) then
                    -- Player is hit — mark as killed
                    killed = true
                    soundtrack.stop()
                    for _, enemy in pairs(enemies) do
                        enemy:addToEndScreen()
                    end
                end
            end
        end
    end
end


function projectiles:move()
    self.x = self.x + self.dx
    self.y = self.y + self.dy
end

function projectiles:draw()
    --love.graphics.rectangle("line")
    if self.active[1] then
        for _, proj in pairs(self.active) do
            love.graphics.draw(proj.gfx, proj.x, proj.y, proj.rot)
        end
    end
end