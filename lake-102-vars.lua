return function(lake)
	local awful = lake.ask "awful"
	
	-- Variable definitions
	
	-- This is used later as the default terminal and editor to run.
	lake.set_var("terminal", "xterm")
	lake.set_var("editor", (os.getenv("EDITOR") or "nano"))
	lake.set_var("editor_cmd", lake.get_var("terminal") .. " -e " .. lake.get_var("editor"))

	-- Default modkey.
	-- Usually, Mod4 is the key with a logo between Control and Alt.
	-- If you do not like this or do not have such a key,
	-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
	-- However, you can use another modifier like Mod1, but it may interact with others.
	lake.set_var("modkey", "Mod4")

	lake.set_var("layouts", {
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
	})
end
