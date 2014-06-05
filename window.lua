Window = {}
Window.__index = Window

function Window.new(w, h)
    local w = w or 800
    local h = h or 600
    local window = {
        x = w,
        y = h
    }
    setmetatable(window, Window)
    return window
end

function Window:setMode()
    love.window.setMode(self.x, self.y)
    love.window.setTitle("Hungry Pixel")
end
