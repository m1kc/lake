return function(lake)
	local awful = lake.ask "awful"
	local wibox = lake.ask "wibox"
	lake.add_to_right(wibox.widget.systray(), 1)
end
