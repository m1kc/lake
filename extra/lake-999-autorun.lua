-- Original source: http://awesome.naquadah.org/wiki/Autostart#The_native_lua_way
-- {{{ Run program once
local function processwalker(lfs)
	local function yieldprocess()
		for dir in lfs.dir("/proc") do
			-- All directories in /proc containing a number, represent a process
			if tonumber(dir) ~= nil then
				local f, err = io.open("/proc/"..dir.."/cmdline")
				if f then
					local cmdline = f:read("*all")
					f:close()
					if cmdline ~= "" then
						coroutine.yield(cmdline)
					end
				end
			end
		end
	end
	return coroutine.wrap(yieldprocess)
end

local function run_once(awful, lfs, process, cmd)
	assert(type(process) == "string")
	local regex_killer = {
		["+"] = "%+", ["-"] = "%-",
		["*"] = "%*", ["?"] = "%?" }

	for p in processwalker(lfs) do
		if p:find(process:gsub("[-+?*]", regex_killer)) then
			return
		end
	end
	return awful.util.spawn(cmd or process)
end
-- }}}

-- Usage Example
--run_once("firefox")
--run_once("dropboxd")
-- Use the second argument, if the programm you wanna start,
-- differs from the what you want to search.
--run_once("redshift", "nice -n19 redshift -l 51:14 -t 5700:4500")
-- }}}



return function(lake)
	local awful = lake.ask "awful"
	local lfs = lake.ask "lfs"

	awful.util.spawn "setxkbmap -option grp:caps_toggle us,ru"
	run_once(awful, lfs, "volumeicon", "volumeicon")

	run_once(awful, lfs, "/usr/lib/gnome-settings-daemon/gnome-settings-daemon-localeexec")
	run_once(awful, lfs, "compton", "compton -o 0.15 --no-fading-openclose")
	run_once(awful, lfs, "xscreensaver", "xscreensaver -no-splash")
end
