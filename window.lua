require "settings"
Window = {}
Window.__index = Window

function Window.new(w, h)
    local w = w or windowWidth
    local h = h or windowHeight
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
