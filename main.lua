require "hero"
require "state"
require "menu"
require "window"
require "point"
require "math"
require "settings"
require "obstacle"

currentDifficulty = easyDifficulty
currentState = nil
gameWindow = nil


function provide_system_info()
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

local mainMenuItems = {
   {
      "Start new game",
      function()
            currentState = State.new();
            currentState:newGame();
      end
   },
   {
      "Exit game",
      function()
            love.event.quit()
      end
   }
}

mainMenu = Menu.new()
mainMenu:setItems(mainMenuItems)

function love.load()
    gameWindow = Window.new(windowWidth, windowHeight)
    gameWindow:setMode()
    currentState = mainMenu
    love.keyboard.setKeyRepeat(true) -- setKeyRepeat enables or disables key repeat mode
    love.keyboard.setTextInput(false) -- setTextInput enables or disables input mode
end

function love.update(dt)
    currentState:update(dt)
    local isGameFinished = currentState:checkForFinish()
    if isGameFinished < 0 then
        currentState.finished = true
    end
end

function love.draw()
    currentState:draw()
    provide_system_info(10, 25)
end

function love.keypressed(key) -- love.keypressed работает, когда нажимается кнопка. key - нажатая кнопка
    currentState:keypressed(key)
end
