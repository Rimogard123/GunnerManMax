local tick = require("tick")
require("time")
require("gamestates/gamestate")
require("gamestates/gameover")
require("gamestates/ingame")
require("entity/projectiles")
require("config/diffconfig")
require("gamestates/menu")
require("score")
require("sfx/soundtrack")

math.randomseed(os.time())
love.graphics.setDefaultFilter("nearest", "nearest")

-- Game variables
local menubg = love.graphics.newImage("gfx/gunnermanmm.png")
local bg = love.graphics.newImage("gfx/bg.png")
local deadbg = love.graphics.newImage("gfx/youdied.png")

local scoreWobble = 0
local scoreScaleFactor = 2
local gameDiff

local screenShake = false
local t, shakeDuration, magnitude = 0, 0.7, 5

--===-- TODO
-- create gamestate reader accessable to all scripts or make it local somehow (harder)

function love.load()
    tick.framerate = 60 
    gamestate.load()
    love.audio.setVolume(0.05)
end

function resetGame()
    diffConfig.load()
    score:reset()
    time:reset()
end

lastState = ""
function love.update(dt)
    local state = gamestate.state
    if lastState ~= state then
        if state == "menu" then
            menu.load()
        end
    end

    -- Screenshare Stuff
    if score.score % 500 == 0 then
        screenShake = true
    end

    if gamestate.state == "menu" then
        menu.update()
    elseif gamestate.state == "ingame" then
        time:increment()
        inGame.update(dt)
        projectiles:update(dt)
    end

    -- Screenshake timer for explosion and milestone
    if screenShake then
        t = t + dt
        scoreWobble = scoreWobble + 0.1 * dt
        scoreScaleFactor = scoreScaleFactor + 0.02
        if t >= shakeDuration then
            screenShake = false
            scoreWobble = 0
            scoreScaleFactor = 2
            t = 0
        end
    end
    lastState = state
end


function love.draw()
    if gamestate.state == "menu" then
        love.graphics.draw(menubg)
        menu.draw()

    elseif gamestate.state == "ingame" then
        love.graphics.draw(bg, 0, 0, 0, 3, 2)
        if screenShake then
            local dx = math.random(-magnitude, magnitude)
            local dy = math.random(-magnitude, magnitude)
            love.graphics.translate(dx, dy)
        end

        inGame.draw()
        local font = love.graphics.newFont(20)
        love.graphics.setFont(font)
        love.graphics.print(score.score, 20, 20, scoreWobble, scoreScaleFactor, scoreScaleFactor)

    elseif gamestate.state == "dead" then
        love.graphics.draw(deadbg)
        gameover.draw()
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if gamestate.state == "menu" and key == "space" then
        resetGame()
        gameDiff = inGame.load()
        gamestate.changeState("ingame")
        soundtrack.play(soundtrack.musicOptions.diffs[gameDiff])
        print(soundtrack.musicOptions.diffs[gameDiff])
    end
    if gamestate.state == "dead" then
        if key == "r" then
            resetGame()
            gameDiff = inGame.load()
            gamestate.changeState("ingame")
            soundtrack.play(soundtrack.musicOptions.diffs[gameDiff])
            
        elseif key == "m" then
            gamestate.changeState("menu")
        end
    end
end