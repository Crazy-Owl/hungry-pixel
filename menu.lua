Menu = {}
Menu.__index = Menu
setmetatable(Menu, {
    __call = function(cls)
        return cls.new()
    end
})

function Menu.new()
    local menuState = setmetatable({
        items = {},
        currentIndex = 0
    }, Menu)
    return menuState
end

function Menu:setItems(itemsTable)
    self.items = itemsTable
end

function Menu:draw()
    return
end

function Menu:update(dt)
    return
end
