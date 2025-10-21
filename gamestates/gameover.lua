require("sfx/soundtrack")
require("gamestates/gamestate")
require("score")
require("time")

gameover = {}

function gameover.load()
    score:log()
end

function gameover.update()
    
end

function gameover.draw()
    love.graphics.printf("You Died!\nPress R to Restart\nPress M for Menu\n\nFinal Score: "..score.score.."\nSession highest: "..score.sessionHighest, 0, windowY/2 - 220, windowX, "center")
end