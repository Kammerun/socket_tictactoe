local connection
local button = require("gui/button")
local btn

local conf = {
    {1, 1, nil}, {2, 1, nil}, {3, 1, nil},
    {1, 2, nil}, {2, 2, nil}, {3, 2, nil},
    {1, 3, nil}, {2, 3, nil}, {3, 3, nil}
}
local btn_text = "Feld 1, 1"

function love.load()
    connection = require("luasocket")
    btn = button:Create()
    btn:SetPos(100, 100)
    btn:SetSize(200, 50)
    btn:SetText(btn_text)

    connection:Send("Start of connection")

    btn:SetOnClick(function()
        print("Button wurde geklickt!")
        connection:Send("Hey")
    end)
end

function love.update()
    btn:Update()
    local line, err = connection:Receive()
    if line then
        print("Server:", line)
    end
end

function love.draw()
    btn:Draw()
end

function love.mousepressed(x, y, button)
    btn:MousePressed(x, y, button)
end