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
      function() return "Start new game" end,
      function()
            currentState = State.new();
            currentState:newGame();
      end
   },
   {
      function() return "Options" end,
      function()
         currentState = optionsMenu
      end
   },
   {
      function() return "Exit game" end,
      function()
            love.event.quit()
      end
   }
}

local optionsMenuItems = {
   {
      function() return "LEFT: " .. leftKey end,
      function()
         optionsMenu:capture("leftKey")
      end
   },
   {
      function() return "RIGHT: " .. rightKey end,
      function()
         optionsMenu:capture("rightKey")
      end
   },
   {
      function() return "UP: " .. upKey end,
      function()
         optionsMenu:capture("upKey")
      end
   },
   {
      function() return "DOWN: " .. downKey end,
      function()
         optionsMenu:capture("downKey")
      end
   },
   {
      function() return "Back to menu" end,
      function()
         currentState = mainMenu
      end
   }
}

mainMenu = Menu.new()
mainMenu:setItems(mainMenuItems)

optionsMenu = Menu.new()
optionsMenu:setItems(optionsMenuItems)

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
