require("time")
require("lib")
require("gamestates/gamestate")
require("config/diffconfig")
require("score")
require("entity/goobers")
require("entity/player")


inGame = {}
enemies = {}

local windowX, windowY = love.graphics.getPixelDimensions()
local playerGfx = love.graphics.newImage("gfx/player.png")
local enemyGfx = love.graphics.newImage("gfx/enemy.png")
local bg = love.graphics.newImage("gfx/bg.png")
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
                --score:add(math.ceil(enemy.baseLerp*10))
            end
            if enemy:handleEnemyDeath(mouseX, mouseY, playerObj.hitboxRadius) then
                print("killed")
                --score:log()
                enemies = {}
                spawningenemies = false
                gamestate.changeState("dead")
                soundtrack.stop()
            end
            --print(playerObj.x, playerObj.y, enemy:handleEnemyDeath(playerObj.x, playerObj.y, playerObj.gfxX*2, enemy.gfxX*2))
        end
    end

    --score:increment()
end

function inGame.draw()
    love.graphics.draw(bg, 0, 0, 0, 3, 2)
    playerObj:draw()
    for _, enemy in ipairs(enemies) do
        enemy:draw()
    end
end