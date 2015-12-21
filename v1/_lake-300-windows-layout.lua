return function(lake)
	local awful = lake.ask "awful"
	-- Table of layouts to cover with awful.layout.inc, order matters.
	local layouts = {
		awful.layout.suit.floating,
		awful.layout.suit.tile,
		awful.layout.suit.tile.left,
		awful.layout.suit.tile.bottom,
		awful.layout.suit.tile.top,
		awful.layout.suit.fair,
		awful.layout.suit.fair.horizontal,
		awful.layout.suit.spiral,
		awful.layout.suit.spiral.dwindle,
		awful.layout.suit.max,
		awful.layout.suit.max.fullscreen,
		awful.layout.suit.magnifier
	}
	-- Create an imagebox widget which will contains an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	local mylayoutbox = {}
	for s = 1, lake.screens() do
		mylayoutbox[s] = awful.widget.layoutbox(s)
		mylayoutbox[s]:buttons(awful.util.table.join(
			awful.button({ }, 1, function () awful.layout.inc(layouts,  1) end),
			awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
			awful.button({ }, 4, function () awful.layout.inc(layouts,  1) end),
			awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
		))
		lake.add_to_left(mylayoutbox[s], s)
	end
	-- Hotkeys
	lake.global_key(awful.key({ lake.get_var("modkey"),           }, "space", function()
		awful.layout.inc(layouts,  1)
	end))
	lake.global_key(awful.key({ lake.get_var("modkey"), "Shift"   }, "space", function()
		awful.layout.inc(layouts, -1)
	end))
end

