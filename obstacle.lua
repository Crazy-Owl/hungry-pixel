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
    if state > 1 then
       local obst = Obstacle.new(x, y, currentDifficulty.obstacleWidth, currentDifficulty.obstacleHeight)
       obst.kind = "moving"
       obst:setRandomDestination()
       return obst
    end
    return Obstacle.new(x, y, currentDifficulty.obstacleWidth, currentDifficulty.obstacleHeight)
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
   if dx >= dy then
      self.speed = {sign(dx) * 1, sign(dy) * math.abs(dy / dx)}
   else
      self.speed = {sign(dy) * math.abs(dx / dy), sign(dy) * 1}
   end
end

function Obstacle:update(dt)
   if self.kind == "stationary" then
      return
   end
   if self.destination ~= nil then
      self.x = self.x + self.speed[1] * dt * currentDifficulty["obstacleBaseSpeed"] -- TODO: speed should be set in settings
      self.y = self.y + self.speed[2] * dt * currentDifficulty["obstacleBaseSpeed"]
   end
   if self.kind == "moving" then
      self.dt = self.dt + dt
      if self.dt > currentDifficulty["obstacleBaseTime"] then -- TODO: threshold should be set in settings
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
