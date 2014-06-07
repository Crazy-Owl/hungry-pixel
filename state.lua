require "util"
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
        objects = {}
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
    for i = 1, #self.objects do
        self.objects[i]:update(dt)
    end
    self.objects = filter(self.objects, function(obj) return obj.alive end)
end

function State:togglePause()
    self.paused = not self.paused
end

function State:keypressed(key)
    if key == "escape" then
        if (love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")) and state.paused then -- два метода ввода с клавиатуры можно комбинировать
            love.event.quit()
        else
            self:togglePause()
        end
    end
end
