require "util"
require "obstacle"
require "point"
require "hero"
State = {}
State.__index = State
setmetatable(State, {
    __call = function(cls)
        return cls.new()
    end
})

function State.new()
    local state = setmetatable({
        input = false,
        paused = false,
        message = "",
        objects = {},
        hero = nil,
        objectAppearTimer = 0,
        obstacleAppearTimer = 20,
        finished = false
    }, State)
    return state
end

function State:setMessage(message)
    self.message = message
end

function State:addObject(obj)
    table.insert(self.objects, obj)
end

function State:prepareArena()
    self:addObject(Obstacle.new(-50, -50, 51, windowHeight + 100))
    self:addObject(Obstacle.new(-50, -50, windowWidth + 100, 51))
    self:addObject(Obstacle.new(windowWidth - 1, -50, 51, windowHeight + 100))
    self:addObject(Obstacle.new(-50, windowHeight - 1, windowWidth + 100, 51))
end

function State.getControlTable()
   local controlTable = {}
   controlTable[leftKey] = {-1, 0}
   controlTable[rightKey] = {1, 0}
   controlTable[upKey] = {0, -1}
   controlTable[downKey] = {0, 1}
   return controlTable
end

function State:newGame()
    local hero = Hero(math.random(100, 300), math.random(100, 300))
    hero:setControlTable(State.getControlTable())
    self.hero = hero
    self.objects = {}
    self.objectAppearTimer = 0
    self.finished = false
    self:prepareArena()
end

function State:update(dt)
    if self.paused or self.finished then
        return
    end
    self.objectAppearTimer = self.objectAppearTimer - dt
    if self.objectAppearTimer <= 0 then
        self:addObject(Point.random())
        self.objectAppearTimer = math.random(currentDifficulty['objectAppearRange'][1], currentDifficulty['objectAppearRange'][2])
    end
    self.obstacleAppearTimer = self.obstacleAppearTimer - dt
    if self.obstacleAppearTimer <= 0 then
        self:addObject(Obstacle.random())
        self.obstacleAppearTimer = math.random(currentDifficulty['obstacleAppearRange'][1], currentDifficulty['obstacleAppearRange'][2])
    end
    self.hero:update(dt)
    self.hero:checkCollision(self.objects)
    for i = 1, #self.objects do
        self.objects[i]:update(dt)
    end
    self.objects = filter(self.objects, function(obj) return (obj.alive or obj.type == "obstacle") end)
end

function State:togglePause()
    self.paused = not self.paused
end

function State:draw()
    if self.finished then
        local font = love.graphics.getFont()
        local message = "YOU LOST (" .. newGameKey .. " will begin new game)"
        local size = font:getWidth(message)
        local height = font:getHeight()
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.print(message, gameWindow.x / 2 - size / 2, gameWindow.y / 2 - height / 2)
        return
    end
    self.hero:draw()
    for i = 1, #self.objects do
        self.objects[i]:draw()
    end
    if self.paused then
        local font = love.graphics.getFont()
        local message = "PAUSED (shift-" .. pauseKey .. " to quit to menu)"
        local size = font:getWidth(message)
        local height = font:getHeight()
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.print(message, gameWindow.x / 2 - size / 2, gameWindow.y / 2 - height / 2)
    end

end

function State:keypressed(key)
    if key == pauseKey then
        if (love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")) and self.paused then -- два метода ввода с клавиатуры можно комбинировать
           currentState = mainMenu
        else
            self:togglePause()
        end
    elseif key == newGameKey then
        self:newGame()
    end
end

function State:checkForFinish()
    if self.hero.size <= 2 then
        return -1
    else
        return 0
    end
end
