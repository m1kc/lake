return function(lake)
	local ifaces = {"enp0s20u2", "wlp2s0"}  -- change this to fit your needs
	local wibox = lake.ask "wibox"
	local widgets = lake.ask "vicious.widgets"
	local netwidget = wibox.widget.textbox()
	for s = 1, lake.screens() do
		lake.add_to_right(netwidget, s)
	end

	local to_s = function(x)
		if x == nil then
			return "..."
		end
		return x
	end

	lake.every_second(function()
		local data = widgets.net()

		local out = ""
		for i,v in ipairs(ifaces) do
			if i > 1 then out = out .. " " end
			out = out ..
				"↓"..to_s(data["{"..v.." down_kb}"]).."kbps"
				.." "..
				"↑"..to_s(data["{"..v.." up_kb}"]).."kbps"
		end

		netwidget:set_text(out)
	end)
end
