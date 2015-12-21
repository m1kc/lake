-- Copyright
print "Lake 1.0"
print "- written by m1kc"
print "- https://github.com/m1kc/lake"
print "- licensed under GNU GPLv3"

-- Lake API
local lake_libs = {
	awesome = awesome,
	mouse = mouse,
}
local lake_client_keys = nil
local lake_global_keys = nil
local lake_client_buttons = nil
local lake_global_buttons = nil
local lake_to_left = {}
local lake_to_middle = {}
local lake_to_right = {}
local lake_override_left = {}
local lake_override_middle = {}
local lake_override_right = {}
local lake_vars = {}

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

local checkScreen = function(x)
	assert(x ~= nil, "Invalid screen ID: nil")
	assert(x >= 1, "Invalid screen ID: "..x)
	assert(x <= screen.count(), "Invalid screen ID: "..x..", we have only "..screen.count().." screen(s)")
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
	add_to_left = function(widget, screen)
		checkScreen(screen)
		table.insert(lake_to_left, {
			widget = widget,
			screen = screen
		})
	end,
	add_to_middle = function(widget, screen)
		checkScreen(screen)
		table.insert(lake_to_middle, {
			widget = widget,
			screen = screen
		})
	end,
	add_to_right = function(widget, screen)
		checkScreen(screen)
		table.insert(lake_to_right, {
			widget = widget,
			screen = screen
		})
	end,
	-- big widgets
	override_left = function(widget, screen)
		table.insert(lake_override_left, {
			widget = widget,
			screen = screen
		})
	end,
	override_middle = function(widget, screen)
		table.insert(lake_override_middle, {
			widget = widget,
			screen = screen
		})
	end,
	override_right = function(widget, screen)
		table.insert(lake_override_right, {
			widget = widget,
			screen = screen
		})
	end,
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
	--[[
	client_key = function(k)
		local awful = ask "awful"
		if lake_client_keys == nil then
			lake_client_keys = awful.util.table.join()
		end
		lake_client_keys = awful.util.table.join(lake_client_keys, k)
	end,
	]]
}

-- Load Lake plugins
local lfs = require "lfs"  -- make sure that Lua Filesystem library is installed
list = {}
for f in lfs.dir(".") do
	table.insert(list, f)
end
table.sort(list)
for i,f in ipairs(list) do
	if string.find(f, "lake-", 1, true) == 1 then
		print("Loading plugin: "..f)
		local plugin = dofile(f)
		plugin(lake_api)
	end
end

-- Basic layout
local awful = ask "awful"
local wibox = ask "wibox"
mywibox = {}
for s = 1, screen.count() do
	print("For screen #" .. s .. ":")
	mywibox[s] = awful.wibox({ position = "top", screen = s })
	
	local left_layout = wibox.layout.fixed.horizontal()
	print("Processing left widgets (" .. #lake_to_left .. " total)...")
	for i, v in pairs(lake_to_left) do
		if v.screen == s then
			left_layout:add(v.widget)
		end
	end
	print(" ok")
	
	local middle_layout = wibox.layout.fixed.horizontal()
	print("Processing middle widgets (" .. #lake_to_middle .. " total)...")
	for i, v in pairs(lake_to_middle) do
		if v.screen == s then
			middle_layout:add(v.widget)
		end
	end
	print(" ok")
	
	local right_layout = wibox.layout.fixed.horizontal()
	print("Processing right widgets (" .. #lake_to_right .. " total)...")
	for i, v in pairs(lake_to_right) do
		if v.screen == s then
			right_layout:add(v.widget)
		end
	end
	print(" ok")
	
	local layout = wibox.layout.align.horizontal()
	layout:set_left(left_layout)
	--TODO
	--layout:set_middle(mytasklist[s])
	layout:set_middle(middle_layout)
	layout:set_right(right_layout)

	mywibox[s]:set_widget(layout)
end

-- Apply global hotkeys
root.keys(lake_global_keys)
root.buttons(lake_global_buttons)

--awful.util.spawn "xterm"
