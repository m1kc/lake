return function(lake)
	local awful = lake.ask "awful"
	local mouse = lake.ask "mouse"
	local modkey = lake.get_var "modkey"
	
	local mypromptbox = {}
	for s = 1, lake.screens() do
		-- Create a promptbox for each screen
		mypromptbox[s] = awful.widget.prompt()
		lake.add_to_left(mypromptbox[s], s)
	end
		
	-- Prompt
    lake.global_key(awful.key({ modkey }, "r", function()
		mypromptbox[mouse.screen]:run()
	end))

    lake.global_key(awful.key({ modkey }, "x", function()
		awful.prompt.run({ prompt = "Run Lua code: " },
		mypromptbox[mouse.screen].widget,
		awful.util.eval, nil,
		awful.util.getdir("cache") .. "/history_eval")
	end))
end
