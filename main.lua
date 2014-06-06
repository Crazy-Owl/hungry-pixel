require "hero"
require "state"
require "window"
require "point"
require "math"
require "settings"

currentDifficulty = easyDifficulty

function provide_system_info(x, y)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print("SCORE: " .. hero.score, 10, 30)
    love.graphics.print("NEXT: " .. math.ceil(objectAppearTimer), 10, 45)
    --[[
        love.time.getTime() returns time in seconds
    ]]
end

function draw_current_text(x, y)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(stat.message, x, y)
end

function love.load()
    hero = Hero(math.random(100, 300), math.random(100, 300))
    controlTable = {
        left = {-1, 0},
        right = {1, 0},
        up = {0, -1},
        down = {0, 1}
    }
    hero:setControlTable(controlTable)
    gameWindow = Window.new(800, 600)
    gameWindow:setMode()
    state = State.new()
    love.keyboard.setKeyRepeat(true) -- setKeyRepeat enables or disables key repeat mode
    love.keyboard.setTextInput(false) -- setTextInput enables or disables input mode
    objectAppearTimer = 0
end

function love.update(dt)
    objectAppearTimer = objectAppearTimer - dt
    if objectAppearTimer <= 0 then
        state:addObject(Point.random())
        objectAppearTimer = math.random(currentDifficulty['objectAppearRange'][1], currentDifficulty['objectAppearRange'][2])
    end
    hero:update(dt)
    state:update(dt)
    hero:checkCollision(state.objects)
end

function love.draw()
    -- draw hero
    hero:draw()
    for i = 1, #state.objects do
        state.objects[i]:draw()
    end
    provide_system_info(10, 25)
end

function love.keypressed(key) -- love.keypressed работает, когда нажимается кнопка. key - нажатая кнопка
    if key == "escape" then
        if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then -- два метода ввода с клавиатуры можно комбинировать
            love.event.quit()
        end
   end
end
