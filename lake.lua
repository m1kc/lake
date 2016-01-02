-- Copyright
print "Lake 1.0"
print "- written by m1kc"
print "- https://github.com/m1kc/lake"
print "- licensed under GNU GPLv3"

-- Lake API
local lake_libs = {
	awesome = awesome,
	mouse = mouse,
	timer = timer,
}
local lake_client_keys = nil
local lake_global_keys = nil
local lake_client_buttons = nil
local lake_global_buttons = nil
local lake_to = {left = {}, middle = {}, right = {}}
local lake_override = {left = {}, middle = {}, right = {}}
local lake_rules = {}
local lake_vars = {
	sloppy_focus = true,
	titlebars = false,
	panel_position = "top",
}

local ask = function(name)
	if lake_libs[name] ~= nil then
		return lake_libs[name]
	else
		lib = require(name)
		lake_libs[name] = lib
		return lib
	end
end

local get_var = function(i)
	return lake_vars[i]
end

local set_var = function(i, v)
	lake_vars[i] = v
end

local check_screen = function(x)
	assert(x ~= nil, "Invalid screen ID: nil")
	assert(x >= 1, "Invalid screen ID: "..x)
	assert(x <= screen.count(), "Invalid screen ID: "..x..", we have only "..screen.count().." screen(s)")
end

function make_adder_to(side)
	return function(widget, screen)
		check_screen(screen)
		table.insert(lake_to[side], {
			widget = widget,
			screen = screen
		})
	end
end

function make_overrider_at(side)
	return function(widget, screen)
		check_screen(screen)
		table.insert(lake_override[side], {
			widget = widget,
			screen = screen
		})
	end
end

lake_api = {
	-- utils
	ask = ask,
	screens = function()
		return screen.count()
	end,
	get_var = get_var,
	set_var = set_var,
	-- widgets
	add_to_left = make_adder_to("left"),
	add_to_middle = make_adder_to("middle"),
	add_to_right = make_adder_to("right"),
	-- big widgets
	override_left = make_overrider_at("left"),
	override_middle = make_overrider_at("middle"),
	override_right = make_overrider_at("right"),
	-- hotkeys
	global_key = function(k)
		local awful = ask "awful"
		if lake_global_keys == nil then
			lake_global_keys = awful.util.table.join()
		end
		lake_global_keys = awful.util.table.join(lake_global_keys, k)
	end,
	global_button = function(k)
		local awful = ask "awful"
		if lake_global_buttons == nil then
			lake_global_buttons = awful.util.table.join()
		end
		lake_global_buttons = awful.util.table.join(lake_global_buttons, k)
	end,
	client_key = function(k)
		local awful = ask "awful"
		if lake_client_keys == nil then
			lake_client_keys = awful.util.table.join()
		end
		lake_client_keys = awful.util.table.join(lake_client_keys, k)
	end,
	client_button = function(k)
		local awful = ask "awful"
		if lake_client_buttons == nil then
			lake_client_buttons = awful.util.table.join()
		end
		lake_client_buttons = awful.util.table.join(lake_client_buttons, k)
	end,
	-- etc
	rule = function(r)
		table.insert(lake_rules, r)
	end,
	timer = function(n, func)
		if timer_intervals[n] then
			table.insert(timer_intervals[n], func)
		else
			timer_intervals[n] = {func}
		end
	end,
	every_second = function(func)
		client.connect_signal("every-second", func)
	end
}


main_timer = timer({ timeout = 0.1 })
timer_intervals = {}
timer_count = 0
prev_time = os.time()

client.add_signal("every-second")

main_timer:connect_signal("timeout", function()
	local cur_time = os.time()
	if prev_time ~= cur_time then
		client.emit_signal("every-second")
		prev_time = cur_time
	end

	for n, listeners in pairs(timer_intervals) do
		if timer_count % n == 0 then
			for i, func in pairs(listeners) do func() end
		end
	end
	timer_count = timer_count + 1
end)
main_timer:start()


-- Deps
local awful = ask "awful"
local wibox = ask "wibox"
local beautiful = ask "beautiful"
awful.rules = ask "awful.rules"
local naughty = ask "naughty"
local lfs = ask "lfs"  -- make sure that Lua Filesystem library is installed


-- Load Lake plugins

local detectDir = function()
	local path = lfs.currentdir().."/"
	print("Trying dir: "..path)
	for f in lfs.dir(path) do
		if (f == "lake.lua") or (f == "rc.lua") then
			print " seems good"
			return path
		end
	end
	path = "/home/"..os.getenv("USER").."/.config/awesome/"
	print("Falling back to "..path)
	return path
end

local list = {}
local path = detectDir()  -- "./"
for f in lfs.dir(path) do
	table.insert(list, f)
end
table.sort(list)
local count = 0
for i,f in ipairs(list) do
	if string.find(f, "lake-", 1, true) == 1 then
		count = count+1
		print("Loading plugin: "..f)
		local plugin = dofile(path..f)
		plugin(lake_api)
	end
end

if count == 0 then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "No Lake plugins found",
		text = "That usually means that Lake failed to detect plugins dir.\n"..
			"If nothing helps, edit lake.lua and set 'path' variable to absolute path to the plugins dir\n"..
			"(usually /home/username/.config/awesome).\n"..
			"Scanned dir was: "..path
	})
end

-- Basic layout
mywibox = {}
for s = 1, screen.count() do
	print("For screen #" .. s .. ":")
	mywibox[s] = awful.wibox({ position = get_var("panel_position"), screen = s })
	layout = {left = nil, middle = nil, right = nil}

	-- Process widgets
	for i, side in pairs({'left', 'middle', 'right'}) do
		layout[side] = wibox.layout.fixed.horizontal()
		print("Processing " .. side .. " widgets (" .. #lake_to[side] .. " total)...")
		for i, v in pairs(lake_to[side]) do
			if v.screen == s then
				layout[side]:add(v.widget)
			end
		end
		print(" ok")
	end

	-- Overrides
	for i, side in pairs({'left', 'middle', 'right'}) do
		print("Processing " .. side .. " overrides (" .. #lake_override[side] .. " total)...")
		for i, v in pairs(lake_override[side]) do
			if v.screen == s then
				print(" Overriding left")
				layout[side] = v.widget
			end
		end
		print(" ok")
	end

	-- Bring it all together
	local main_layout = wibox.layout.align.horizontal()
	main_layout:set_left(layout.left)
	main_layout:set_middle(layout.middle)
	main_layout:set_right(layout.right)
	mywibox[s]:set_widget(main_layout)
end

-- Apply global hotkeys
if lake_global_keys ~= nil then root.keys(lake_global_keys) end
if lake_global_buttons ~= nil then root.buttons(lake_global_buttons) end

-- Apply rules
_rules = {
	-- All clients will match this rule.
	{
		rule = { },
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = lake_client_keys,
			buttons = lake_client_buttons
		}
	}
}
for i, v in ipairs(lake_rules) do
	table.insert(_rules, v)
end
awful.rules.rules = _rules


-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
	-- Enable sloppy focus
	if get_var("sloppy_focus") then
		c:connect_signal("mouse::enter", function(c)
			if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c) then
				client.focus = c
			end
		end)
	end

	if not startup then
		-- Set the windows at the slave,
		-- i.e. put it at the end of others instead of setting it master.
		-- awful.client.setslave(c)

		-- Put windows in a smart way, only if they does not set an initial position.
		if not c.size_hints.user_position and not c.size_hints.program_position then
			awful.placement.no_overlap(c)
			awful.placement.no_offscreen(c)
		end
	end

	local titlebars_enabled = get_var("titlebars")
	if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
		-- buttons for the titlebar
		local buttons = awful.util.table.join(
				awful.button({ }, 1, function()
					client.focus = c
					c:raise()
					awful.mouse.client.move(c)
				end),
				awful.button({ }, 3, function()
					client.focus = c
					c:raise()
					awful.mouse.client.resize(c)
				end)
				)

		-- Widgets that are aligned to the left
		local left_layout = wibox.layout.fixed.horizontal()
		left_layout:add(awful.titlebar.widget.iconwidget(c))
		left_layout:buttons(buttons)

		-- Widgets that are aligned to the right
		local right_layout = wibox.layout.fixed.horizontal()
		right_layout:add(awful.titlebar.widget.floatingbutton(c))
		right_layout:add(awful.titlebar.widget.maximizedbutton(c))
		right_layout:add(awful.titlebar.widget.stickybutton(c))
		right_layout:add(awful.titlebar.widget.ontopbutton(c))
		right_layout:add(awful.titlebar.widget.closebutton(c))

		-- The title goes in the middle
		local middle_layout = wibox.layout.flex.horizontal()
		local title = awful.titlebar.widget.titlewidget(c)
		title:set_align("center")
		middle_layout:add(title)
		middle_layout:buttons(buttons)

		-- Now bring it all together
		local layout = wibox.layout.align.horizontal()
		layout:set_left(left_layout)
		layout:set_right(right_layout)
		layout:set_middle(middle_layout)

		awful.titlebar(c):set_widget(layout)
	end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
