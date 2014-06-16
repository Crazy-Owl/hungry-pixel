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
        type = "obstacle"
    }, Obstacle)
    return self
end

function Obstacle.random()
    local x = math.random(0, windowHeight)
    local y = math.random(0, windowHeight)
    return Obstacle.new(x, y, currentDifficulty.obstacleWidth, currentDifficulty.obstacleHeight)
end

function Obstacle:update()
    return
end

function Obstacle:draw()
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end