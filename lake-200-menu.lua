return function(lake)
	local awesome = lake.ask "awesome"
	local awful = lake.ask "awful"
	local beautiful = lake.ask "beautiful"
	local modkey = lake.get_var "modkey"

	-- Create a laucher widget and a main menu
	local myawesomemenu = {
		{ "manual", lake.get_var("terminal") .. " -e man awesome" },
		{ "edit config", lake.get_var("editor_cmd") .. " " .. awesome.conffile },
		{ "restart", awesome.restart },
		{ "quit", awesome.quit }
	}

	local mymainmenu = awful.menu({ items = {
		{ "awesome", myawesomemenu, beautiful.awesome_icon },
		{ "lxterminal", "lxterminal" },
		{ "screenshot", "gnome-screenshot -i" },
		{ "lock screen", "xscreensaver-command -lock" },
	}})

	local mylauncher = awful.widget.launcher({
		image = beautiful.awesome_icon,
		menu = mymainmenu
	})

	for s = 1, lake.screens() do
		lake.add_to_left(mylauncher, s)
	end

	lake.global_key(awful.key({ modkey,           }, "w", function()
		mymainmenu:show()
	end))

	lake.global_button(awful.button({ }, 3, function()
		mymainmenu:toggle()
	end))
end
