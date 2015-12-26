return function(lake)
	local wibox = lake.ask "wibox"
	local timer = lake.ask "timer"
	
	local timebox = wibox.widget.textbox()
	
	for s = 1, lake.screens() do
		lake.add_to_right(timebox, s)
	end
	
	local timer = timer({ timeout = 0.1 })
	local prev_time = os.time()
	timer:connect_signal("timeout", function()
		if prev_time ~= os.time() then
			timebox:set_text(os.date("%X"))
			prev_time = os.time()
		end
	end)
	timer:start()
end

