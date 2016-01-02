return function(lake)
	local awful = lake.ask "awful"
	local wibox = lake.ask "wibox"
	local vicious = lake.ask "vicious"
	cpuwidget = awful.widget.graph()
	cpuwidget:set_width(50)
	cpuwidget:set_color("#8000FF")
	vicious.register(cpuwidget, vicious.widgets.cpu, "$1", 0.2)
	for s = 1, lake.screens() do
		lake.add_to_right(cpuwidget, s)
	end
end
