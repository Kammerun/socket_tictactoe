local socket = require("socket")

local server = assert(socket.bind("*", 22337))
server:settimeout(0)
local ip, port = server:getsockname()

print("Please telnet to " .. ip .. " on port " .. port)

local clients = {}

---Sends a Text to all connected Clients
---@param text string
local function Broadcast(text)
    for i = 1, #clients do
        clients[i]:send(text .. "\n")
    end
end

local turn = 1
local board = {0, 0, 0, 0, 0, 0, 0, 0, 0}

---Checks if a player has won the Game
---@return boolean
local function CheckForWin()
    -- WOW this function is ugly, should definitly fix this mess
    if
        --horizontal
        board[1] ~= 0 and board[1] == board[2] and board[2] == board[3] or
        board[4] ~= 0 and board[4] == board[5] and board[5] == board[6] or
        board[7] ~= 0 and board[7] == board[8] and board[8] == board[9] or
        
        --vertical
        board[1] ~= 0 and board[1] == board[4] and board[4] == board[7] or
        board[2] ~= 0 and board[2] == board[5] and board[5] == board[8] or
        board[3] ~= 0 and board[3] == board[6] and board[6] == board[9] or

        --cross
        board[1] ~= 0 and board[1] == board[5] and board[5] == board[9] or
        board[3] ~= 0 and board[3] == board[5] and board[5] == board[7]
    then
        return true
    end

    return false
end

---Checks if a move is valid.
---@param line string
---@param client_id number
---@return boolean
---@return string?
local function CheckValidMove(line, client_id)
    local move = tonumber(line)
    if not move then
        return false, "Error: Cant make move!"
    end

    if turn == 0 then
        return false, "Error: Game is over"
    end

    if #clients < 2 then
        return false, "Error: Wait for opponent to connect"
    end

    if turn ~= client_id then
        return false, "Error: Not your turn!"
    end

    if board[move] ~= 0 then
        return false, "Error: Already played!"
    end

    board[move] = client_id
    turn = turn == 1 and 2 or 1

    return true
end

while true do
    local client = server:accept()
    if client then
        client:settimeout(0)
        table.insert(clients, client)
        print("Neuer Client verbunden (#" .. #clients .. ")")
    end

    for client_id = #clients, 1, -1 do
        local c = clients[client_id]
        local line, err = c:receive()
        if err then
            if err ~= "timeout" then
                print("Client getrennt (#" .. client_id .. ")")
                c:close()
                table.remove(clients, client_id)
                break
            end
        elseif line then
            if line == "quit" then
                c:close()
                table.remove(clients, client_id)
            elseif line == "Start of connection" then
                -- Sending Client index for window title
                c:send(client_id .. "\n")
            else
                local valid, error = CheckValidMove(line, client_id)
                if valid then
                    Broadcast(line .. client_id)
                    print("Received: " .. line .. " from Client (#" .. client_id .. ")")
                    if CheckForWin() then
                        local winner = turn == 1 and 2 or 1
                        print("Winner is Player " .. winner)
                        Broadcast("Winner is Player " .. winner)
                        turn = 0
                    end
                else
                    print(error)
                    c:send(error .. "\n")
                end
            end
        end
    end

    socket.sleep(0.01)
end
