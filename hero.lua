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
        timeToShrink = currentDifficulty['heroTimeToShrink'],
        size = currentDifficulty['startingHeroSize'],
        type = "hero"
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
      self:shrink()
      if self.w < currentDifficulty['minimumWidth'] then
         self.w = currentDifficulty['minimumWidth']
      end
      if self.h < currentDifficulty['minimumHeight'] then
         self.h = currentDifficulty['minimumHeight']
      end
      self.timeToShrink = currentDifficulty['heroTimeToShrink']
   end
   self:updateVelocity()
   --    if gameWindow then
   --        self:truncateWindow()
   --    end
end

function Hero:draw()
    local tts = currentDifficulty['heroTimeToShrink']
    local w = self.w + self.size
    local h = self.h + self.size
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.rectangle("fill", self.x, self.y, w, h) -- love.graphics.rectangle() рисует прямоугольник. Варианты первого аргумента fill, line, затем x, y от начала координат, затем ширина и высота
    love.graphics.setColor(128, 128, 128, 255)
    love.graphics.rectangle("fill", self.x + w / 2 + w * ((self.timeToShrink - tts) / tts) / 2, self.y + h / 2 + h * ((self.timeToShrink - tts) / tts) / 2, w * (tts - self.timeToShrink) / tts, h * (tts - self.timeToShrink) / tts)
    if currentDifficulty['displayRuler'] then
       love.graphics.setColor(255, 0, 0, 255)
       love.graphics.line(self.x + w / 2, self.y + h / 2, self.x + w / 2 + self.speed[1], self.y + h / 2 + self.speed[2])
    end
end

function Hero:setControlTable(ct)
    self.controlTable = ct
end

function Hero:shrink()
   self.size = self.size - currentDifficulty['shrinkRate']
   if self.size < 2 then self.size = 2 end
end

function Hero:collide(obj)
    if obj.type == "point" then
        obj:die()
        self.score = self.score + 1
        self.size = self.size + currentDifficulty['growRate']
        self.timeToShrink = currentDifficulty['heroTimeToShrink']
        currentState.objectAppearTimer = currentState.objectAppearTimer - 1
    elseif obj.type == "obstacle" then
        self:shrink()
        local x, y, w, h
        local selfW = self.w + self.size
        local selfH = self.h + self.size
        if self.x >= obj.x and self.x + selfW >= obj.x + obj.w then
            x = self.x
            w = obj.x + obj.w - self.x
        elseif obj.x >= self.x and obj.x + obj.w >= self.x + selfW then
            x = obj.x
            w = self.x + selfW - obj.x
        elseif self.x >= obj.x and self.x + selfW <= obj.x + obj.w then
            x = self.x
            w = selfW
        elseif obj.x >= self.x and obj.x + obj.w <= self.x + selfW then
            x = obj.x
            w = obj.w
        end
        if self.y >= obj.y and self.y + selfH >= obj.y + obj.h then
            y = self.y
            h = obj.y + obj.h - self.y
        elseif obj.y >= self.y and obj.y + obj.h >= self.y + selfH then
            y = obj.y
            h = self.y + selfH - obj.y
        elseif self.y >= obj.y and self.y + selfH <= obj.y + obj.h then
            y = self.y
            h = selfH
        elseif obj.y >= self.y and obj.y + obj.h <= self.y + selfH then
            y = obj.y
            h = obj.h
        end
        if h == w then
            self.speed = {-self.speed[1], -self.speed[2]}
        elseif h < w then
            self.speed = {self.speed[1], -self.speed[2]}
        else
            self.speed = {-self.speed[1], self.speed[2]}
        end
        self.x = self.x + sign(self.speed[1]) * w
        self.y = self.y + sign(self.speed[2]) * h
    end
end

function Hero:checkCollision(objectList)
   local w = self.w + self.size
   local h = self.h + self.size
   for i = 1, #objectList do
      local obj = objectList[i]
      if (self.x + w >= obj.x and self.x <= obj.x + obj.w) and (self.y + h >= obj.y and self.y <= obj.y + obj.h) then
         self:collide(obj)
      end
   end
end

function Hero:updateVelocity()
   local size = self.size
   local maxSize = currentDifficulty['maxSize']
   if size >  maxSize then size = maxSize end
   self.velocity = currentDifficulty["heroVelocity"] - currentDifficulty["heroMaxVelocityChange"] * (size / maxSize) -- TODO: add values from settings here
end
