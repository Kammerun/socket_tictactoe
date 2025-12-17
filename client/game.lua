local game = {}

local button = require("gui/button")
local buttons = {}
local btn

game.conf = {
    {{1, 1, nil}, {2, 1, nil}, {3, 1, nil}},
    {{1, 2, nil}, {2, 2, nil}, {3, 2, nil}},
    {{1, 3, nil}, {2, 3, nil}, {3, 3, nil}}
}

function game:CreateButtons(connection)
    for row, row_value in ipairs(game.conf) do
        for column, value in ipairs(row_value) do
            --print(value[1], value[2])
            btn = button:Create()
            btn:SetPos(250 * column, 100 * row)
            btn:SetSize(200, 50)
            btn:SetText(value[1] .. ", " .. value[2])

            btn:SetOnClick(function()
                print("Sending: " .. value[1] .. ", " .. value[2] .. "" .. " to Server")
                connection:Send(value[1] .. ", " .. value[2])
            end)

            table.insert(buttons, btn)
        end
    end
end

function game:Update(dt)
    for i = #buttons, 1, -1 do
        buttons[i]:Update(dt)
    end
end

function game:Draw()
    for i = #buttons, 1, -1 do
        buttons[i]:Draw()
    end
end

function game:MousePressed(x, y, button)
    for i = #buttons, 1, -1 do
        if buttons[i]:MousePressed(x, y, button) then
            break
        end
    end
end




return game