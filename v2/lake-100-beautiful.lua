return function(lake)
	local beautiful = lake.ask "beautiful"
	local gears = lake.ask "gears"
	-- Themes define colours, icons, font and wallpapers.
	beautiful.init("/usr/share/awesome/themes/default/theme.lua")
	if beautiful.wallpaper then
		for s = 1, lake.screens() do
		    gears.wallpaper.maximized(beautiful.wallpaper, s, true)
		end
	end
end
