local connection

Game = require("game")

---Löve's Load function
function love.load()
    connection = require("luasocket")
    Game:CreateButtons(connection)

    connection:Send("Start of connection")
end

---Löve's Update function
function love.update(dt)
    Game:Update(dt)
    local line, err = connection:Receive()
    if not line then return end
    Game:HandleMessage(line)
end

---Löve's Doad function
function love.draw()
    Game:Draw()
end

---Calls MousePressed on the Game
---@param x number
---@param y number
---@param button table
function love.mousepressed(x, y, button)
    Game:MousePressed(x, y, button)
end