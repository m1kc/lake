return function(lake)
	local awful = lake.ask "awful"
	local tags = {}
	for s = 1, lake.screens() do
		-- Each screen has its own tag table.
		tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, lake.get_var("layouts")[1])
	end
end
