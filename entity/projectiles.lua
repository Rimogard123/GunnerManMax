projectiles = {
    active = {}
}
projectiles.__index = projectiles

function projectiles:new(gfx, x, y, lifetime, speed, rot)
    local obj = {
        gfx = gfx,
        x = x or 100,
        y = y or 100,
        lifetime = lifetime or 30,
        speed = speed or 1,
        rot = rot or 0
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
    end
end

function projectiles:draw()
    if self.active[1] then
        for _, proj in pairs(self.active) do
            love.graphics.draw(proj.gfx, proj.x, proj.y, proj.rot)
        end
    end
end