return function(lake)
	awful = lake.ask "awful"
	lake.client_key(awful.key({ lake.get_var("modkey"),           }, "f",      function (c) c.fullscreen = not c.fullscreen  end))
    lake.client_key(awful.key({ lake.get_var("modkey"), "Shift"   }, "c",      function (c) c:kill()                         end))
    lake.client_key(awful.key({ lake.get_var("modkey"), "Control" }, "space",  awful.client.floating.toggle                     ))
    lake.client_key(awful.key({ lake.get_var("modkey"), "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end))
    lake.client_key(awful.key({ lake.get_var("modkey"),           }, "o",      awful.client.movetoscreen                        ))
    lake.client_key(awful.key({ lake.get_var("modkey"),           }, "t",      function (c) c.ontop = not c.ontop            end))
    lake.client_key(awful.key({ lake.get_var("modkey"),           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end))
    lake.client_key(awful.key({ lake.get_var("modkey"),           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end))
end
