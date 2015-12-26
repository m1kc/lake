function get_mem_info()
	local f = io.open('/proc/meminfo', 'r')
	-- 'MemTotal:        3952444 kB'
	-- numbers are between 14 and 25 characters
	local from, to = 14, 25
	local total = f:read():sub(from, to)
	local free = f:read():sub(from, to)
	f:read() -- available
	local buffers = f:read():sub(from, to)
	local cached = f:read():sub(from, to)
	f:close()
	return tonumber(total), tonumber(free), tonumber(buffers), tonumber(cached)
end

return function(lake)
	local awful = lake.ask "awful"
	
	local memgraph = awful.widget.graph()
	memgraph:set_width(50)
	--memgraph:set_background_color('#494B4F')
	memgraph:set_stack(true)
	memgraph:set_stack_colors({'#007799', '#FFFFFF', '#005577'})
	
	for s = 1, lake.screens() do
		lake.add_to_right(memgraph, s)
	end
	
	client.connect_signal("tick-5", function()
		total, free, buffers, cached = get_mem_info()
		memgraph:set_max_value(total)
		memgraph:add_value(total-free-buffers-cached, 1)
		memgraph:add_value(buffers, 2)
		memgraph:add_value(cached, 3)
	end)
end

