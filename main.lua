require "hero"
require "state"
require "window"
require "point"
require "math"
require "settings"

currentDifficulty = easyDifficulty
currentState = nil
local hero
local controlTable


function provide_system_info(x, y)
    love.graphics.setColor(255, 255, 255, 255)
    if currentState.hero then
        love.graphics.print("SCORE: " .. currentState.hero.score, 10, 30)
    end
    if currentState.objectAppearTimer then
        love.graphics.print("NEXT: " .. math.ceil(currentState.objectAppearTimer), 10, 45)
    end
    --[[
        love.time.getTime() returns time in seconds
    ]]
end

function draw_current_text(x, y)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(stat.message, x, y)
end

function love.load()
    local hero = Hero(math.random(100, 300), math.random(100, 300))
    controlTable = {
        left = {-1, 0},
        right = {1, 0},
        up = {0, -1},
        down = {0, 1}
    }
    hero:setControlTable(controlTable)
    gameWindow = Window.new(800, 600)
    gameWindow:setMode()
    currentState = State.new()
    currentState.hero = hero
    love.keyboard.setKeyRepeat(true) -- setKeyRepeat enables or disables key repeat mode
    love.keyboard.setTextInput(false) -- setTextInput enables or disables input mode
end

function love.update(dt)
    currentState:update(dt)
    local isGameFinished = currentState:checkForFinish()
    if isGameFinished then
        love.event.quit()
    end
end

function love.draw()
    currentState:draw()
    provide_system_info(10, 25)
end

function love.keypressed(key) -- love.keypressed работает, когда нажимается кнопка. key - нажатая кнопка
    currentState:keypressed(key)
end
