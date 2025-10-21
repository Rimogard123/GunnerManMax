require("time")
require("lib/lib")
require("gamestates/gamestate")
require("config/diffconfig")
require("entity/projectiles")
require("sfx/soundtrack")
require("score")
require("entity/goobers")
require("entity/player")
local camera = require("lib/camera")
local cam = camera()

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


function inGame.load()
    print("Config after load:")
    for k, v in pairs(diffConfig.config) do
        print(k, v)
    end
    playerObj = player:new(10, 10, playerGfx)
    return diffConfig.config["diff"]
end

function inGame.update(dt)
    --print("player x/y: "..playerObj.x, playerObj.y)

    if time.time % 250 == 0 then
        diffConfig.config.maxEnemies = diffConfig.config.maxEnemies + 1
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
            player:shoot(bulletGfx, playerObj.x, playerObj.y, targetX, targetY, math.random(15, 30), 10, 0)
        end
    end

    local mouseX, mouseY = love.mouse.getPosition()
    -- playerObj.x = mouseX
    -- playerObj.y = mouseY
    playerObj:move()

    -- Spawn enemies
    if time.time == 60 then spawningenemies = true end

    if spawningenemies then
        --print(config["maxEnemies"])
        if #enemies < diffConfig.config["maxEnemies"] then
            --print("Spawning with:", diffConfig.config["baseLerp"], diffConfig.config["lifetime"])

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
                score:add(math.ceil(enemy.baseLerp*10))
            end
            if enemy:handleEnemyDeath(playerObj.x, playerObj.y, playerObj.hitboxRadius) then
                print("killed")
                spawningenemies = false
                soundtrack.stop()
                for _, enemy in pairs(enemies) do
                    enemy:addToEndScreen()
                end
                killed = true
            end
            --print(playerObj.x, playerObj.y, enemy:handleEnemyDeath(playerObj.x, playerObj.y, playerObj.gfxX*2, enemy.gfxX*2))
        end
    end
    --LOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOL
    if not killed then
        score:increment()
    end
    if killed then
        deathDuration = deathDuration - 1
        if deathDuration <= 0 then
            gameover.load()
            gamestate.changeState("dead")
            enemies = {}
            killed = false
            deathDuration = maxDeathDuration
        end
    end
    cam:lookAt(lerp(cam.x, playerObj.x, 0.3), lerp(cam.y, playerObj.y, 0.2))
    --cam:lookAt(100,100)
end

function inGame.draw()
    if not killed then
        cam:attach()
        projectiles:draw()
        --love.graphics.rectangle("line", playerObj.x, playerObj.y, 30, 30)
        --love.graphics.rectangle("line",playerWorldPosX, playerWorldPosY, 30, 30)
        playerObj:draw()
        for _, enemy in ipairs(enemies) do
            enemy:draw()
        end
        cam:detach()
    else
        cam:attach()
        for _, enemy in ipairs(enemies) do
            enemy.rot = enemy.rot + 3
            enemy:deathAnim()
        end
        cam:detach()
    end
end