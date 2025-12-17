local game = {}

local button = require("gui/button")
local buttons = {}


game.conf = {
    {0, 0, 0},
    {0, 0, 0},
    {0, 0, 0},
}

function game:CreateButtons(connection)
    for row, row_value in ipairs(game.conf) do
        for column, value in ipairs(row_value) do
            --print(value[1], value[2])
            local btn = button:Create()
            btn:SetPos(250 * column, 100 * row)
            btn:SetSize(200, 50)
            btn:SetText(#buttons + 1)
            btn:SetColor(1, 0.5, 0)
            btn:SetIndex(#buttons + 1)

            btn:SetOnClick(function()
                print("Sending: " .. #buttons + 1 .. " to Server")
                connection:Send(btn:GetIndex())
                btn:SetEnabled(false)
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