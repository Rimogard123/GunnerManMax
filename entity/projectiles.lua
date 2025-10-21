projectiles = {
    active = {}
}
projectiles.__index = projectiles

function projectiles:new(gfx, x, y, targetX, targetY, lifetime, speed, rot)
    local angle = math.atan2(targetY - y, targetX - x)
    local dx = math.cos(angle) * speed
    local dy = math.sin(angle) * speed
    local obj = {
        gfx = gfx,
        x = x or 500,
        y = y or 500,
        dx = dx,
        dy = dy,
        lifetime = lifetime or 30,
        speed = speed or 2,
        rot = angle or 0
    }
    setmetatable(obj, projectiles)
    table.insert(self.active, obj)
    return obj
end

function projectiles:update(dt)
    for k, proj in pairs(self.active) do
        proj.lifetime = proj.lifetime - 1
        if proj.lifetime <= 0 then
            table.remove(self.active, k)
        end
        proj:move()
        for e, enemy in pairs(enemies) do
            if enemy:handleEnemyDeath(proj.x, proj.y, 4) then
                proj.lifetime = 0
                table.remove(enemies, e)
                break
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