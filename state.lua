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
