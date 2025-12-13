local socket = require("socket")

local connection = socket.connect("127.0.0.1", 22337)
if not connection then error("Cant connect to Server") end

connection:send("Test!" .. "\n")

local line, err = connection:receive()
if not err then print(line) end

os.execute("sleep 5")

connection:send("Test!" .. "\n")

local line, err = connection:receive()
print(err)
if not err then print(line) end