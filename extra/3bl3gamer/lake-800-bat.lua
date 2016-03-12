local bat_powers = {0, 0, 0, 0, 0}

function get_bat_info()
	local bat = "/sys/class/power_supply/BAT0"
	local f = io.open(bat.."/capacity", "r")
	local capacity = f:read()
	f:close()
	local f = io.open(bat.."/power_now", "r")
	local power = f:read()
	f:close()
	local f = io.open(bat.."/status", "r")
	local status = f:read()
	f:close()
	return capacity, power/1000, status
end

return function(lake)
	local awful = lake.ask "awful"
	local wibox = lake.ask "wibox"

	local batbox = wibox.widget.textbox()
	batbox:set_text("---")

	for s = 1, lake.screens() do
		lake.add_to_right(batbox, s)
	end

	lake.every_second(function()
		capacity, power, status = get_bat_info()

		local flag = ""
		if status == "Charging" then flag = "+" end
		batbox:set_text("["..capacity.."% "..flag..(math.floor(power/100)/10).."W] ")

		for i = 2, 5 do
			bat_powers[i-1] = bat_powers[i]
		end
		bat_powers[5] = power
	end)
end
