local game = {}

local button = require("gui/button")
local buttons = {}


game.board = {
    {0, 0, 0},
    {0, 0, 0},
    {0, 0, 0},
}

function game:CreateButtons(connection)
    for row, row_value in ipairs(game.board) do
        for column, value in ipairs(row_value) do
            --print(value[1], value[2])
            local btn = button:Create()
            btn:SetPos(250 * column, 100 * row)
            btn:SetSize(200, 50)
            btn:SetText(#buttons + 1)
            btn:SetColor(1, 0.5, 0)
            btn:SetIndex(#buttons + 1)

            btn:SetOnClick(function()
                print("Sending: " .. btn:GetIndex() .. " to Server")
                connection:Send(btn:GetIndex())
                btn:SetEnabled(false)
            end)

            table.insert(buttons, btn)
        end
    end
end

function game:HandleMessage(line)
    if line == "1" or line == "2" then
       love.window.setTitle("Player " .. line)
    elseif string.sub(line, 1, 5) == "Error" then
        -- Draw to Screen on player they shouldnt have console open
        print(line)
    elseif string.sub(line, 1, 6) == "Winner" then
        -- Draw to Screen on player they shouldnt have console open
        print(line)
    else
        local line_tbl = {}
        for i = 1, #line do
            line_tbl[i] = line:sub(i, i)
        end

        local index = tonumber(line_tbl[1])
        local client_id = tonumber(line_tbl[2])
        print("Received: " .. index .. " | Move from Client " .. client_id)
        local btn = buttons[index]
        if client_id == 1 then
            btn:SetColor(0, 1, 0)
            btn:SetEnabled(false)
        else
            btn:SetColor(0, 0, 1)
            btn:SetEnabled(false)
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