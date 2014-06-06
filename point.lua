require "math"
require "settings"

Point = {}
Point.__index = Point
setmetatable(Point, {
    __call = function(cls, x, y, w, h, t)
        return cls.new(x, y, t)
    end
})

function Point.new(x, y, w, h, t)
    local self = setmetatable({
        x = x or 0,
        y = y or 0,
        w = w or objectWidth,
        h = h or objectHeight,
        t = t or 5,
        alive = true
    }, Point)
   return self
end

function Point.random()
    local x = 0
    local y = 0
    local w = 15
    local h = 15
    local t = math.random(objectLifespan[1], objectLifespan[2])
    if gameWindow then
        x = math.random(0, gameWindow.x - w)
        y = math.random(0, gameWindow.y - h)
    end
    return Point.new(x, y, w, h, t)
end

function Point:draw()
    if self.alive then
        love.graphics.setColor(255, 0, 255, 255)
        love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
        local str = string.format("%i", self.t)
        love.graphics.print(str, self.x, self.y)
    end
end

function Point:die()
    self.alive = false
end

function Point:update(dt)
    self.t = self.t - dt
    if self.t <= 0 then
        self:die()
    end
end
