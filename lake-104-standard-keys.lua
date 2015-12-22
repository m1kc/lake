return function(lake)
	local awful = lake.ask "awful"
	local modkey = lake.get_var "modkey"
	local awesome = lake.ask "awesome"
	
	-- Switching clients
	lake.global_key(awful.key({ modkey,           }, "j", function()
		awful.client.focus.byidx( 1)
		if client.focus then client.focus:raise() end
	end))
    lake.global_key(awful.key({ modkey,           }, "k", function()
		awful.client.focus.byidx(-1)
		if client.focus then client.focus:raise() end
	end))

	-- Layout manipulation
	lake.global_key(awful.key({ modkey, "Shift"   }, "j", function() awful.client.swap.byidx(  1)    end))
	lake.global_key(awful.key({ modkey, "Shift"   }, "k", function() awful.client.swap.byidx( -1)    end))
	lake.global_key(awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative( 1) end))
	lake.global_key(awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end))
	lake.global_key(awful.key({ modkey,           }, "u", awful.client.urgent.jumpto))
	lake.global_key(awful.key({ modkey,           }, "Tab", function()
		awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end)
	)

	-- Standard program
	lake.global_key(awful.key({ modkey,           }, "Return", function() awful.util.spawn(lake.get_var("terminal")) end))
	lake.global_key(awful.key({ modkey, "Control" }, "r", awesome.restart))
	lake.global_key(awful.key({ modkey, "Shift"   }, "q", awesome.quit))

	lake.global_key(awful.key({ modkey,           }, "l",     function() awful.tag.incmwfact( 0.05)    end))
	lake.global_key(awful.key({ modkey,           }, "h",     function() awful.tag.incmwfact(-0.05)    end))
	lake.global_key(awful.key({ modkey, "Shift"   }, "h",     function() awful.tag.incnmaster( 1)      end))
	lake.global_key(awful.key({ modkey, "Shift"   }, "l",     function() awful.tag.incnmaster(-1)      end))
	lake.global_key(awful.key({ modkey, "Control" }, "h",     function() awful.tag.incncol( 1)         end))
	lake.global_key(awful.key({ modkey, "Control" }, "l",     function() awful.tag.incncol(-1)         end))
	lake.global_key(awful.key({ modkey,           }, "space", function() awful.layout.inc(layouts,  1) end))
	lake.global_key(awful.key({ modkey, "Shift"   }, "space", function() awful.layout.inc(layouts, -1) end))

	lake.global_key(awful.key({ modkey, "Control" }, "n", awful.client.restore))
	
	-- Client keys
	lake.client_key(awful.key({ lake.get_var("modkey"),           }, "f",      function (c) c.fullscreen = not c.fullscreen  end))
	lake.client_key(awful.key({ lake.get_var("modkey"), "Shift"   }, "c",      function (c) c:kill()                         end))
	lake.client_key(awful.key({ lake.get_var("modkey"), "Control" }, "space",  awful.client.floating.toggle                     ))
	lake.client_key(awful.key({ lake.get_var("modkey"), "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end))
	lake.client_key(awful.key({ lake.get_var("modkey"),           }, "o",      awful.client.movetoscreen                        ))
	lake.client_key(awful.key({ lake.get_var("modkey"),           }, "t",      function (c) c.ontop = not c.ontop            end))

	lake.client_key(awful.key({ lake.get_var("modkey"),           }, "n", function(c)
		-- The client currently has the input focus, so it cannot be
		-- minimized, since minimized clients can't have the focus.
		c.minimized = true
	end))
    lake.client_key(awful.key({ lake.get_var("modkey"),           }, "m", function(c)
		c.maximized_horizontal = not c.maximized_horizontal
		c.maximized_vertical   = not c.maximized_vertical
	end))
	
	-- Client mouse bindings
	lake.client_button(awful.button({ }, 1, function (c) client.focus = c; c:raise() end))
	lake.client_button(awful.button({ modkey }, 1, awful.mouse.client.move))
	lake.client_button(awful.button({ modkey }, 3, awful.mouse.client.resize))
end
