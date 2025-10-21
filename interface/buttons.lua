require("time")
require("config/diffconfig")
require("sfx/soundtrack")

buttons = {
    diffs = {
        ["easy"] = {text = "Easy", x = 20, y = 20, width = 200, height = 150, c = {0.15,0.85,0.15}, onClick = function()
            diffConfig.setConfig("easy")
            soundtrack.changeTrack("sfx/easy.mp3")
        end},
        ["medium"] = {text = "Medium", x = 20, y = 190, width = 200, height = 150, c = {0.30,0.15,0.85}, onClick = function()
            diffConfig.setConfig("medium")
            soundtrack.changeTrack("sfx/medium.mp3")
        end},
        ["hard"] = {text = "Hard", x = 20, y = 360, width = 200, height = 150, c = {0.85,0.15,0.30}, onClick = function() 
            diffConfig.setConfig("hard")
            soundtrack.changeTrack("sfx/hard.ogg")
        end}
    },
    selected = "medium",
    selectedOffset = {0.32, 0.3, 0.28}
}

function buttons.checkClickArea(x, y, button)
    if button == 1 then
        for k, btn in pairs(buttons.diffs) do
            if x >= btn.x and x <= btn.x + btn.width
            and y >= btn.y and y <= btn.y + btn.height then
                if btn.onClick then btn.onClick() end
                --print(diffConfig.config["maxEnemies"])
                buttons.selected = k
                return true
            end
        end
    end
    return false
end

function love.mousepressed(x, y, button)
    buttons.checkClickArea(x, y, button)
end

function buttons.update(dt)
    -- local x, y = love.mouse.getPosition()
    buttons.checkClickArea()
end

function buttons.draw()
    for k, btn in pairs(buttons.diffs) do
        -- Button rectangle
        local r, g, b = btn.c[1], btn.c[2], btn.c[3]
        if buttons.selected == k then
            r = r - buttons.selectedOffset[1]
            g = g - buttons.selectedOffset[2]
            b = b - buttons.selectedOffset[3]
        end
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle("fill", btn.x, btn.y, btn.width, btn.height, 10, 10)
        
        -- Button text
        love.graphics.setColor(1, 1, 1)
        local font = love.graphics.newFont(26)
        love.graphics.setFont(font)
        local textWidth = font:getWidth(btn.text)
        local textHeight = font:getHeight(btn.text)
        love.graphics.print(btn.text, btn.x + (btn.width - textWidth) / 2, btn.y + (btn.height - textHeight) / 2)
    end
end