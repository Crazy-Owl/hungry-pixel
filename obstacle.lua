require "util"

Obstacle = {}
Obstacle.__index = Obstacle
setmetatable(Obstacle, {
    __call = function(cls, x, y, w, h)
        return cls.new(x, y, w, h)
    end
})

function Obstacle.new(x, y, w, h)
    local self = setmetatable({
        x = x,
        y = y,
        w = w,
        h = h,
        type = "obstacle",
        kind = "stationary",
        speed = {0, 0},
        destination = nil,
        dt = 0
    }, Obstacle)
    return self
end

function Obstacle.random()
    local x = math.random(0, windowHeight)
    local y = math.random(0, windowHeight)
    local state = math.random(2)
    local size = math.random(currentDifficulty["obstacleMinSize"], currentDifficulty["obstacleMaxSize"])
    if state > 1 then
       local obst = Obstacle.new(x, y, size, size)
       obst.kind = "moving"
       obst:setRandomDestination()
       return obst
    end
    return Obstacle.new(x, y, size, size)
end

function Obstacle:setRandomDestination()
   local dx = 0
   local dy = 0
   local x, y
   while (math.abs(dx) < 10) and (math.abs(dy) < 10) do
      x = math.random(0, windowHeight)
      y = math.random(0, windowHeight)
      dx = x - self.x
      dy = y - self.y
   end
   self.destination = {x, y}
   self.speed[1] = dx / currentDifficulty["obstacleBaseTime"]
   self.speed[2] = dy / currentDifficulty["obstacleBaseTime"]
end

function Obstacle:update(dt)
   if self.kind == "stationary" then
      return
   end
   if self.destination ~= nil then
      self.x = self.x + self.speed[1] * dt
      self.y = self.y + self.speed[2] * dt
   end
   if self.kind == "moving" then
      self.dt = self.dt + dt
      if self.dt > currentDifficulty["obstacleBaseTime"] then
         self.dt = 0
         self:setRandomDestination()
      end
   end
   return
end

function Obstacle:draw()
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end
