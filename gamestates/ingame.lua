require("time")
require("lib")
require("gamestates/gamestate")
require("config/diffconfig")
require("entity/projectiles")
require("sfx/soundtrack")
require("score")
require("entity/goobers")
require("entity/player")


inGame = {}
enemies = {}

local windowX, windowY = love.graphics.getPixelDimensions()
local bulletGfx = love.graphics.newImage("gfx/bullet1.png")
local playerGfx = love.graphics.newImage("gfx/player.png")
local enemyGfx = love.graphics.newImage("gfx/enemy.png")
local spawningenemies = false
local playerObj = nil

function inGame.load()
    print("Config after load:")
    for k, v in pairs(diffConfig.config) do
        print(k, v)
    end
    playerObj = player:new(10, 10, playerGfx)
    return diffConfig.config["diff"]
end

function inGame.update(dt)
    --print(diffConfig.config["lifetime"])
    -- Mouse follow
    --print(config["maxEnemies"])

    if time.time % 15 == 0 then
        player:shoot(bulletGfx, playerObj.x, playerObj.y, math.random(15, 30), 0.5, 0)
    end

    local mouseX, mouseY = love.mouse.getPosition()
    playerObj.x = mouseX
    playerObj.y = mouseY

    -- Spawn enemies
    if time.time == 60 then spawningenemies = true end

    if spawningenemies then
        --print(config["maxEnemies"])
        if #enemies < diffConfig.config["maxEnemies"] then
            print("Spawning with:", diffConfig.config["baseLerp"], diffConfig.config["lifetime"])
            table.insert(enemies, enemy:new(
                math.random(1, windowX), math.random(1, windowY),
                targetX, targetY,
                nil, nil,
                enemyGfx,
                diffConfig.config["baseLerp"],
                diffConfig.config["lifetime"]
            ))
        end
        for k, enemy in pairs(enemies) do
            if enemy:move(dt, mouseX, mouseY) then
                table.remove(enemies, k)
                score:add(math.ceil(enemy.baseLerp*10))
            end
            if enemy:handleEnemyDeath(mouseX, mouseY, playerObj.hitboxRadius) then
                print("killed")
                score:log()
                enemies = {}
                spawningenemies = false
                gamestate.changeState("dead")
                soundtrack.stop()
                for _, enemy in pairs(enemies) do
                    enemy:addToEndScreen()
                end
                killed = true
            end
            --print(playerObj.x, playerObj.y, enemy:handleEnemyDeath(playerObj.x, playerObj.y, playerObj.gfxX*2, enemy.gfxX*2))
        end
    end

    score:increment()
end

function inGame.draw()
    playerObj:draw()
    for _, enemy in ipairs(enemies) do
        enemy:draw()
    end
end