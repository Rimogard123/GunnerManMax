require("time")
local lib = require("lib/lib")
require("gamestates/gamestate")
require("config/diffconfig")
require("entity/projectiles")
require("sfx/soundtrack")
require("score")
require("entity/goobers")
require("entity/player")
local camera = require("lib/camera")
local cam = camera()
local bg = love.graphics.newImage("gfx/bg.png")

inGame = {}
enemies = {}

local windowX, windowY = love.graphics.getPixelDimensions()
local bulletGfx = love.graphics.newImage("gfx/bullet1.png")
local playerGfx = love.graphics.newImage("gfx/player.png")
local enemyGfx = love.graphics.newImage("gfx/enemy.png")
local spawningenemies = false
local playerObj = nil
local maxDeathDuration = 90
local deathDuration = maxDeathDuration
local afkTimer = 210
local afkRadius = 1350
local afkPoint


function inGame.load()
    print("Config after load:")
    for k, v in pairs(diffConfig.config) do
        print(k, v)
    end
    playerObj = player:new(10, 10, playerGfx)
    afkPoint = {playerObj.x, playerObj.y}
    return diffConfig.config["diff"]
end

function inGame.update(dt)
    --print("player x/y: "..playerObj.x, playerObj.y)

    if time.time % 250 == 0 then
        diffConfig.config.maxEnemies = diffConfig.config.maxEnemies * 1.2
    end
    if time.time % afkTimer == 0 then
        if lib.distance(playerObj.x, playerObj.y, afkPoint[1], afkPoint[2]) <= afkRadius then
            soundtrack.stop()
            killed = true
        end
        afkPoint = {playerObj.x, playerObj.y}
    end
    if time.time % playerObj.shootDelay == 0 and not killed then
        local difX, difY
        local closest = math.huge
        local targetX, targetY
        for _, enemy in pairs(enemies) do
            difX = playerObj.x - enemy.x
            difY = playerObj.y - enemy.y
            local dist = math.sqrt(difX * difX + difY * difY)
            if dist < closest then
                closest = dist
                targetX = enemy.x
                targetY = enemy.y
            end
        end
        if targetX then
            player:shoot("standard", playerObj.x, playerObj.y, targetX, targetY, math.random(30, 90), 15, 0)
        end
        projectiles:update(dt,playerObj)
    end

    --local mouseX, mouseY = love.mouse.getPosition()

    if not killed then
        playerObj:move()
    end

    -- Spawn enemies
    if time.time == 60 then spawningenemies = true end

    if spawningenemies then
        if #enemies < diffConfig.config["maxEnemies"] then

            table.insert(enemies, enemy:new(
                math.random(1, windowX), math.random(1, windowY),
                playerObj.x, playerObj.y,
                nil, nil,
                enemyGfx,
                diffConfig.config["baseLerp"],
                diffConfig.config["lifetime"]
            ))
        end
        for k, enemy in pairs(enemies) do
            local targetX, targetY = playerObj.x, playerObj.y
            if enemy:move(dt, targetX, targetY) then
                table.remove(enemies, k)
                score:add(enemy.pointsValue)
            end
            if enemy:handleEnemyDeath(playerObj.x, playerObj.y, playerObj.hitboxRadius) then
                for _, enemy in pairs(enemies) do
                    enemy:addToEndScreen()
                end
                soundtrack.stop()
                killed = true
            end
        end
    end
    if killed then
        deathDuration = deathDuration - 1
        if deathDuration <= 0 then
            spawningenemies = false
            gameover.load()
            gamestate.changeState("dead")
            enemies = {}
            killed = false
            deathDuration = maxDeathDuration
        end
    end
    cam:lookAt(lib.lerp(cam.x, playerObj.x, 0.2), lib.lerp(cam.y, playerObj.y, 0.1))
end

function inGame.draw()
    local font
    if not killed then
        love.graphics.draw(bg, 0, 0, 0, 3, 2)
        cam:attach()
        love.graphics.setColor(0.8, 0.3, 0.3, 0.15)
        love.graphics.circle("fill", afkPoint[1], afkPoint[2], afkRadius)
        love.graphics.setColor(1, 0.6, 0.6, 0.75)
        love.graphics.circle("line", afkPoint[1], afkPoint[2], afkRadius)
        love.graphics.setColor(1,1,1,1)
        local sampletext = love.graphics.getFont()
        local offsetX = sampletext:getWidth("You will die within the Circle")
        local offsetY = sampletext:getHeight("You will die within the Circle")
        font = love.graphics.newFont(32)
        love.graphics.setColor(0.8, 0.2, 0.2, 0.75)
        love.graphics.setFont(font)
        if lib.distance(playerObj.x, playerObj.y, afkPoint[1], afkPoint[2]) <= afkRadius then
            love.graphics.print("              !WARNING!\nYou will die within the Circle", afkPoint[1] - offsetX, afkPoint[2] - offsetY)
        end
        love.graphics.setColor(1,1,1,1)
        projectiles:draw()
        --love.graphics.rectangle("line", playerObj.x, playerObj.y, 30, 30)
        --love.graphics.rectangle("line",playerWorldPosX, playerWorldPosY, 30, 30)
        playerObj:draw()
        for _, enemy in ipairs(enemies) do
            enemy:draw()
        end
        cam:detach()
    else
        love.graphics.draw(bg, 0, 0, 0, 3, 2)
        cam:attach()
        for _, enemy in ipairs(enemies) do
            enemy.rot = enemy.rot + 3
            enemy:deathAnim()
        end
        cam:detach()
    end
end