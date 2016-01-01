local cpus_number = 4
local cpu_temp_path = nil
local cpu_temp_paths = { -- because sometimes it changes after boot
	"/sys/devices/platform/coretemp.0/hwmon/hwmon1/temp1_input",
	"/sys/devices/platform/coretemp.0/hwmon/hwmon2/temp1_input",
}
for i, path in pairs(cpu_temp_paths) do
	local f = io.open(path, "r")
	if f then
		f:close()
		cpu_temp_path = path
		break
	end
end

function get_cpu_temp()
	local f = io.open(cpu_temp_path, "r")
	local temp = f:read()
	f:close()
	return math.floor(temp / 1000)
end

return function(lake)
	local wibox = lake.ask "wibox"
	
	local tempbox = wibox.widget.textbox()
	tempbox:set_text("---")
	
	for s = 1, lake.screens() do
		lake.add_to_right(tempbox, s)
	end
	
	lake.everySecond(function()
		tempbox:set_text(get_cpu_temp() .. "°C")
	end)
end

