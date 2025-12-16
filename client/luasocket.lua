local socket = require("socket")

local tcp = assert(socket.connect("127.0.0.1", 22337))
tcp:settimeout(0)

local connection = {}

function connection:Send(text)
    tcp:settimeout(nil)
    tcp:send(text .. "\n")
    tcp:settimeout(0)
end

function connection:Receive()
    local line, err = tcp:receive()
    return line, err
end

return connection