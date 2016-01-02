return function(lake)
	local awful = lake.ask "awful"
	local wibox = lake.ask "wibox"
	local vicious = lake.ask "vicious"
	wifiwidget = wibox.widget.textbox()
	vicious.register(wifiwidget, vicious.widgets.net, "↓${wlp2s0 down_kb}kbps ↑${wlp2s0 up_kb}kbps")
	for s = 1, lake.screens() do
		lake.add_to_right(wifiwidget, s)
	end
end
