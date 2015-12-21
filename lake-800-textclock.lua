return function(lake)
	local awful = lake.ask "awful"
	local mytextclock = awful.widget.textclock()
	for s = 1, lake.screens() do
		lake.add_to_right(mytextclock, s)
	end
end

