return function(lake)
	local modkey = lake.get_var "modkey"
	local awful = lake.ask "awful"
	local tags = {}
	for s = 1, lake.screens() do
		-- Each screen has its own tag table.
		tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, lake.get_var("layouts")[1])
	end

	-- Bind all key numbers to tags.
	-- Be careful: we use keycodes to make it works on any keyboard layout.
	-- This should map on the top row of your keyboard, usually 1 to 9.
	for i = 1, 9 do
		-- View tag only.
		lake.global_key(awful.key({ modkey }, "#" .. i + 9, function()
			local screen = mouse.screen
			local tag = awful.tag.gettags(screen)[i]
			if tag then
				awful.tag.viewonly(tag)
			end
		end))
		-- Toggle tag.
		lake.global_key(awful.key({ modkey, "Control" }, "#" .. i + 9, function()
			local screen = mouse.screen
			local tag = awful.tag.gettags(screen)[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end))
		-- Move client to tag.
		lake.global_key(awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = awful.tag.gettags(client.focus.screen)[i]
				if tag then
					awful.client.movetotag(tag)
				end
			end
		end))
		-- Toggle tag.
		lake.global_key(awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = awful.tag.gettags(client.focus.screen)[i]
				if tag then
					awful.client.toggletag(tag)
				end
			end
		end))
	end
end
