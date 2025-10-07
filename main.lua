local tick = require("tick")
require("lib")
require("time")
require("gamestates/gamestate")
require("gamestates/gameover")
require("gamestates/ingame")
require("gamestates/menu")
require("score")
--require("config/diffconfig")
require("sfx/soundtrack")

math.randomseed(os.time())
love.graphics.setDefaultFilter("nearest", "nearest")

-- Game variables
local localScore = 0
local localScoreWobble = 0
local localScoreScaleFactor = 2
local gameDiff

local screenShake = false
local t, shakeDuration, magnitude = 0, 0.7, 5

--===-- TODO
-- recreate death animation
-- create gamestate reader accessable to all scripts or make it local somehow (harder)
-- remove all player and enemy* logic from main (DONE)

function love.load()  
    tick.framerate = 60
    gamestate.load()
    love.audio.setVolume(0.2)
end

function resetGame()
    time:reset()
    localScore = 0
end

lastState = ""
function love.update(dt)
    -- localScore needs to be seperate or find a way to alternatively reset localScore
    local state = gamestate.state
    if lastState ~= state then
        if state == "menu" then
            menu.load()
        end
    end

    -- Screenshare Stuff
    if localScore % 500 == 0 then
        screenShake = true
    end

    if gamestate.state == "menu" then
        menu.update()
    elseif gamestate.state == "ingame" then
        time:increment()
        localScore = time.time
        inGame.update(dt)

        --Super redundant
        score:set(localScore)
    end

    -- Screenshake timer for explosion and milestone
    if screenShake then
        t = t + dt
        localScoreWobble = localScoreWobble + 0.1 * dt
        localScoreScaleFactor = localScoreScaleFactor + 0.02
        if t >= shakeDuration then
            screenShake = false
            localScoreWobble = 0
            localScoreScaleFactor = 2
            t = 0
        end
    end
    lastState = state
end


function love.draw()
    if gamestate.state == "menu" then
        menu.draw()

    elseif gamestate.state == "ingame" then
        if screenShake then
            local dx = math.random(-magnitude, magnitude)
            local dy = math.random(-magnitude, magnitude)
            love.graphics.translate(dx, dy)
        end
        inGame.draw()
        love.graphics.print(localScore, 20, 20, localScoreWobble, localScoreScaleFactor, localScoreScaleFactor)

    elseif gamestate.state == "dead" then
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
