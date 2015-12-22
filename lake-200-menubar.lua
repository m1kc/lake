return function(lake)
	local menubar = lake.ask "menubar"
	local awful = lake.ask "awful"
	local modkey = lake.get_var "modkey"
	menubar.utils.terminal = lake.get_var("terminal")  -- Set the terminal for applications that require it
	lake.global_key(awful.key({ modkey }, "p", function() menubar.show() end))
end
