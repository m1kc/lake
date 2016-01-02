return function(lake)
	local interface = "wlp2s0"  -- change this to fit your needs
	local wibox = lake.ask "wibox"
	local widgets = lake.ask "vicious.widgets"
	local netwidget = wibox.widget.textbox()
	for s = 1, lake.screens() do
		lake.add_to_right(netwidget, s)
	end
	lake.every_second(function()
		local data = widgets.net()
		netwidget:set_text(
			"↓"..data["{"..interface.." down_kb}"].."kbps"
			.." "..
			"↑"..data["{"..interface.." up_kb}"].."kbps"
		)
	end)
end
