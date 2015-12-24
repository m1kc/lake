return function(lake)
	local awful = lake.ask "awful"
	local wibox = lake.ask "wibox"
	local vicious = lake.ask "vicious"
	mywidget = wibox.widget.textbox()
	vicious.register(mywidget, vicious.widgets.bat, "[$1 $2%]", 2, "BAT0")
	for s = 1, lake.screens() do
		lake.add_to_right(mywidget, s)
	end
end
