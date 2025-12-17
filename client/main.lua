local connection


Game = require("game")


local btn_text = "Feld 1, 1"

function love.load()
    connection = require("luasocket")
    Game:CreateButtons(connection)

    connection:Send("Start of connection")
end

function love.update(dt)
    Game:Update(dt)
    local line, err = connection:Receive()
    if not line then return end
    if line == "1" or line == "2" then
       love.window.setTitle("Player " .. line)
    else
        local line_tbl = {}
        for i = 1, #line do
            line_tbl[i] = line:sub(i, i)
        end

        print("Received: " .. line .. " from Server")
    end
end

function love.draw()
    Game:Draw()
end

function love.mousepressed(x, y, button)
    Game:MousePressed(x, y, button)
end