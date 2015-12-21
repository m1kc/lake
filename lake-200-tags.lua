return function(lake)
	local awful = lake.ask "awful"
	-- Define a tag table which hold all screen tags.
	local tags = {}
	for s = 1, lake.screens() do
		-- Each screen has its own tag table.
		tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, lake.get_var("default_layout"))
	end
	-- Create tag list
	local mytaglist = {}
	mytaglist.buttons = awful.util.table.join(
		awful.button({                        }, 1, awful.tag.viewonly),
		awful.button({ lake.get_var("modkey") }, 1, awful.client.movetotag),
		awful.button({                        }, 3, awful.tag.viewtoggle),
		awful.button({ lake.get_var("modkey") }, 3, awful.client.toggletag),
		awful.button({                        }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
		awful.button({                        }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
	)
	for s = 1, lake.screens() do
    	mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)
    	lake.add_to_left(mytaglist[s], s)
	end
end
