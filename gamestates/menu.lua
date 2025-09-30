require("sfx/soundtrack")
require("gamestates/gamestate")
require("interface/buttons")
require("config/diffconfig")

menu = {}

function menu.load()
    diffConfig.load()
end

function menu.update(dt)

end

function menu.draw()
    buttons.draw()
    love.graphics.printf("Goober Game\nPress SPACE to Start", 0, windowY/2 - 40, windowX, "center")
end