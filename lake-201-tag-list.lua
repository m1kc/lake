return function(lake)
	local modkey = lake.get_var "modkey"
	local awful = lake.ask "awful"
	
	mytaglist = {}
	mytaglist.buttons = awful.util.table.join(
		awful.button({ }, 1, awful.tag.viewonly),
		awful.button({ modkey }, 1, awful.client.movetotag),
		awful.button({ }, 3, awful.tag.viewtoggle),
		awful.button({ modkey }, 3, awful.client.toggletag),
		awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
		awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
	)
	
	for s = 1, lake.screens() do
		mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)
		lake.add_to_left(mytaglist[s], s)
	end
end
