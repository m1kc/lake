-- Copyright
print "Lake 1.0"
print "- written by m1kc"
print "- https://github.com/m1kc/lake"
print "- licensed under GNU GPLv3"

-- Lake API
local lake_libs = {
	awesome = awesome,
}
local lake_client_keys = {}
local lake_global_keys = {}
local lake_to_left = {}
local lake_to_right = {}
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
		table.insert(lake_to_left, {
			widget = widget,
			screen = screen
		})
	end,
	add_to_right = function(widget, screen)
		table.insert(lake_to_right, {
			widget = widget,
			screen = screen
		})
	end,
	-- hotkeys
	global_key = function(k)
		table.insert(lake_global_keys, k)
	end,
	client_key = function(k)
		table.insert(lake_client_keys, k)
	end,
}

-- Load Lake plugins
local lfs = require "lfs"
list = {}
for f in lfs.dir(".") do
	table.insert(list, f)
end
table.sort(list)
for i,f in ipairs(list) do
	if string.find(f, "lake-", 1, true) == 1 then
		print("Loading lake plugin: "..f)
		local plugin = dofile(f)
		print(" running...")
		plugin(lake_api)
		print(" ok")
	end
end

-- Basic layout
local awful = ask "awful"
local wibox = ask "wibox"
mywibox = {}
for s = 1, screen.count() do
	mywibox[s] = awful.wibox({ position = "top", screen = s })
	
	local left_layout = wibox.layout.fixed.horizontal()
	print("Adding left widgets (" .. #lake_to_left .. ")...")
	for i, v in pairs(lake_to_left) do
		if v.screen == s then
			left_layout:add(v.widget)
		end
	end
	print(" ok")
	
	local right_layout = wibox.layout.fixed.horizontal()
	print("Adding right widgets (" .. #lake_to_right .. ")...")
	for i, v in pairs(lake_to_right) do
		if v.screen == s then
			right_layout:add(v.widget)
		end
	end
	print(" ok")
	
	local layout = wibox.layout.align.horizontal()
	layout:set_left(left_layout)
	--layout:set_middle(mytasklist[s])
	layout:set_right(right_layout)

	mywibox[s]:set_widget(layout)
end

--awful.util.spawn "xterm"
