local socket = require("socket")

local server = assert(socket.bind("*", 22337))
server:settimeout(0)
local ip, port = server:getsockname()

print("Please telnet to localhost on port " .. port)

local clients = {}

while true do
    local client = server:accept()
    if client then
        client:settimeout(0)
        table.insert(clients, client)
        print("Neuer Client verbunden (#" .. #clients .. ")")
    end

    for i = #clients, 1, -1 do
        local c = clients[i]
        local line, err = c:receive()
        if err then
            if err ~= "timeout" then
                print("Client getrennt (#" .. i .. ")")
                c:close()
                table.remove(clients, i)
                break
            end
        end

        if not line then break end

        c:send(line .. "\n")
        print("Received: " .. line .. " from Client (#" .. i .. ")")

        if line == "quit" then
            c:close()
            break
        end
    end

    socket.sleep(0.01)
end
