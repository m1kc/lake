local timer = timer({ timeout = 0.1 })
local prev_time = os.time()
local count = 0

client.add_signal("tick")
client.add_signal("tick-5")

timer:connect_signal("timeout", function()
	if prev_time ~= os.time() then
		client.emit_signal("tick", count)
		if count % 5 == 0 then
			client.emit_signal("tick-5", count)
		end
		prev_time = os.time()
		count = count + 1
	end
end)

timer:start()
return timer
