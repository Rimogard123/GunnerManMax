require"globals"
require("sfx/soundtrack")
require("gamestates/gamestate")
require("interface/buttons")
require("config/diffconfig")

local tutorialGfx = love.graphics.newImage("gfx/tutorial.png")
local bg = love.graphics.newImage("gfx/gunnermanmm.png")
local bgSine = {}
local sineDuration = 180
local magnitude = 10
local timer = 0
menu = {}

function menu.load()
    diffConfig.load()
end

function menu.update(dt)
    timer = timer + 1
    local t = (timer % sineDuration) / sineDuration
    local angle = t * 2 * math.pi
    bgSine[1] = math.sin(angle) * magnitude / 2
    bgSine[2] = math.sin(angle) * magnitude
end

function menu.draw()
    love.graphics.push()
    love.graphics.translate(bgSine[1], bgSine[2])
    love.graphics.draw(bg, -100, -20, 0, 1.2, 1.2)
    love.graphics.printf("Press SPACE\nto start", 0, windowY/2 + 40, windowX - 90, "center")
    love.graphics.pop()

    love.graphics.draw(tutorialGfx, 0, G.window[2] - tutorialGfx:getHeight())
    buttons.draw()
    --love.graphics.printf("Press SPACE\nto start", 0, windowY/2, windowX - 40, "center")
end