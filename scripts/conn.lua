-- example script that demonstrates use of setup() to pass
-- a random server address to each thread

local addrs = nil

function connection_init(thread, conn, connection_index)
   print("Connection init, index: ", connection_index)
   addrs = wrk.lookup("127.0.42."..tostring(1+connection_index), wrk.port or "http")
   for i = #addrs, 1, -1 do
     print("addr: " .. tostring(addrs[i])) 
     if not wrk.connect(addrs[i]) then
        print("Remove address")
        table.remove(addrs, i)
     end
   end
   if #addrs > 0 then
     print("Setting connection address to ".. tostring(addrs[1]))
     conn.addr = addrs[1];
   else
     -- it will inherit from thread
   end

end
