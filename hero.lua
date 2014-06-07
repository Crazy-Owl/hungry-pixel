require "math"

Hero = {} -- table to hold all class variables
Hero.__index = Hero -- lookup in this table
setmetatable(Hero, {
    __call = function(cls, x, y)
        return cls.new(x, y)
    end
})

function Hero.new(x, y) -- constructor
    local self = setmetatable({
        x = x or 0,
        y = y or 0,
        w = currentDifficulty['startingHeroWidth'],
        h = currentDifficulty['startingHeroHeight'],
        speed = currentDifficulty['startingHeroSpeed'],
        velocity = currentDifficulty['heroVelocity'],
        slowing = currentDifficulty['heroSlowing'],
        score = 0,
        timeToShrink = currentDifficulty['heroTimeToShrink']
    }, Hero)
    return self
end

function Hero:move(dt)
    self.x = self.x + self.speed[1] * dt
    self.y = self.y + self.speed[2] * dt
end

function Hero:getSpeed()
    return self.speed
end

function Hero:truncate(minX, minY, maxX, maxY)
    local minX = minX or 0
    local maxX = maxX or 800
    local minY = minY or 0
    local maxY = maxY or 600
    if self.x < minX then
        self.x = minX
        self.speed[1] = 0
    end
    if self.x > maxX then
        self.x = maxX
        self.speed[1] = 0
    end
    if self.y < minY then
        self.y = minY
        self.speed[2] = 0
    end
    if self.y > maxY then
        self.y = maxY
        self.speed[2] = 0
    end
end

function Hero:truncateWindow(window)
    local window = window or gameWindow
    local minX = 0
    local maxX = window.x - self.w
    local minY = 0
    local maxY = window.y - self.h
    self:truncate(minX, minY, maxX, maxY)
end

function Hero:update(dt)
    local velocity = self.velocity
    if self.controlTable then
        for key, value in pairs(self.controlTable) do
            if love.keyboard.isDown(key) then
                local v1 = dt * velocity * value[1] + self.speed[1]
                local v2 = dt * velocity * value[2] + self.speed[2]
                self.speed = {v1, v2}
            end
        end
   end
    self:move(dt)
    self.speed[1] = self.speed[1] - self.speed[1] * self.slowing * dt
    self.speed[2] = self.speed[2] - self.speed[2] * self.slowing * dt
    self.timeToShrink = self.timeToShrink - dt
    if self.timeToShrink <= 0 then
       self.w = self.w - currentDifficulty['shrinkRate']
       self.h = self.h - currentDifficulty['shrinkRate']
       if self.w < currentDifficulty['minimumWidth'] then
          self.w = currentDifficulty['minimumWidth']
       end
       if self.h < currentDifficulty['minimumHeight'] then
          self.h = currentDifficulty['minimumHeight']
       end
       self.timeToShrink = currentDifficulty['heroTimeToShrink']
    end
    if gameWindow then
        self:truncateWindow()
    end
end

function Hero:draw()
    local tts = currentDifficulty['heroTimeToShrink']
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h) -- love.graphics.rectangle() рисует прямоугольник. Варианты первого аргумента fill, line, затем x, y от начала координат, затем ширина и высота
    love.graphics.setColor(128, 128, 128, 255)
    love.graphics.rectangle("fill", self.x + self.w / 2 + self.w * ((self.timeToShrink - tts) / tts) / 2, self.y + self.h / 2 + self.h * ((self.timeToShrink - tts) / tts) / 2, self.w * (tts - self.timeToShrink) / tts, self.h * (tts - self.timeToShrink) / tts)
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.line(self.x + self.w / 2, self.y + self.h / 2, self.x + self.w / 2 + self.speed[1], self.y + self.h / 2 + self.speed[2])
    love.graphics.setColor(0, 255, 0, 255)
end

function Hero:setControlTable(ct)
    self.controlTable = ct
end

function Hero:collide(obj)
    obj:die()
    self.score = self.score + 1
    self.w = self.w + currentDifficulty['growRate']
    self.h = self.h + currentDifficulty['growRate']
    self.timeToShrink = currentDifficulty['heroTimeToShrink']
    currentState.objectAppearTimer = currentState.objectAppearTimer - 1
end

function Hero:checkCollision(objectList)
    for i = 1, #objectList do
        local obj = objectList[i]
        if (self.x + self.w >= obj.x and self.x <= obj.x + obj.w) and (self.y + self.h >= obj.y and self.y <= obj.y + obj.h) then
            self:collide(obj)
        end
    end
end
