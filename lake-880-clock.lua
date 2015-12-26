return function(lake)
	local wibox = lake.ask "wibox"
	
	local timebox = wibox.widget.textbox()
	timebox:set_text("--:--:--")
	
	for s = 1, lake.screens() do
		lake.add_to_right(timebox, s)
	end
	
	client.connect_signal("tick", function()
		timebox:set_text(os.date("%X"))
	end)
end

