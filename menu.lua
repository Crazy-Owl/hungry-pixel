require "settings"

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
        currentIndex = 1
    }, Menu)
    return menuState
end

function Menu:setItems(itemsTable)
    self.items = itemsTable
    self.currentIndex = 1
end

function Menu:draw()
   love.graphics.setColor(255, 255, 255, 255)
   local font = love.graphics.getFont()
   local height = font:getHeight() * #self.items
   local maxSize = 0
   for i = 1, #self.items do
      local messageSize = font:getWidth(self.items[i][1])
      if maxSize < messageSize then
         maxSize = messageSize
      end
   end
   local x = (windowWidth - maxSize) / 2
   local y = (windowHeight - height) / 2
   for i = 1, #self.items do
      if self.currentIndex == i then
         love.graphics.setColor(128, 128, 128, 255)
         love.graphics.rectangle("fill", x, y + (i - 1) * font:getHeight(), maxSize, font:getHeight())
         love.graphics.setColor(255, 255, 255, 255)
      end
      love.graphics.print(self.items[i][1], x, y + (i - 1) * font:getHeight())
   end
end

function Menu:update(dt)
   return
end

function Menu:keypressed(key)
   if key == "down" then
      self.currentIndex = self.currentIndex + 1
      if self.currentIndex > #self.items then
         self.currentIndex = 1
      end
   elseif key == "up" then
      self.currentIndex = self.currentIndex - 1
      if self.currentIndex <= 0 then
         self.currentIndex = #self.items
      end
   elseif key == "return" then
      fn = self.items[self.currentIndex][2]
      fn()
   end
end

function Menu:checkForFinish()
   return 0
end
