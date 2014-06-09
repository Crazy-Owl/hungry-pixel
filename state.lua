require "util"
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
        objectAppearTimer = 0
    }, State)
    return state
end

function State:setMessage(message)
    self.message = message
end

function State:addObject(obj)
    table.insert(self.objects, obj)
end

function State:update(dt)
    if self.paused then
        return
    end
    self.objectAppearTimer = self.objectAppearTimer - dt
    if self.objectAppearTimer <= 0 then
        self:addObject(Point.random())
        self.objectAppearTimer = math.random(currentDifficulty['objectAppearRange'][1], currentDifficulty['objectAppearRange'][2])
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
    self.hero:draw()
    for i = 1, #self.objects do
        self.objects[i]:draw()
    end
    if self.paused then
        local font = love.graphics.getFont()
        local message = "PAUSED (shift-ESC to quit)"
        local size = font:getWidth(message)
        local height = font:getHeight()
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.print(message, gameWindow.x / 2 - size / 2, gameWindow.y / 2 - height / 2)
    end

end

function State:keypressed(key)
    if key == "escape" then
        if (love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")) and self.paused then -- два метода ввода с клавиатуры можно комбинировать
            love.event.quit()
        else
            self:togglePause()
        end
    end
end

function State:checkForFinish()
    return false
end
