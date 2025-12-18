local socket = require("socket")

local tcp = assert(socket.connect("127.0.0.1", 22337))
tcp:settimeout(0)

local connection = {}

---Sends a Text to the Server via Socket - TCP
---@param text string
function connection:Send(text)
    tcp:settimeout(nil)
    tcp:send(text .. "\n")
    tcp:settimeout(0)
end

---Receives a Text from the Server via Socket - TCP
---@return string
---@return string
function connection:Receive()
    local line, err = tcp:receive()
    return line, err
end

return connection