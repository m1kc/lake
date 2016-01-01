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
	
	local batgraph = awful.widget.graph()
	batgraph:set_width(50)
	batgraph:set_max_value(10000)
	batgraph:set_stack(true)
	batgraph:set_stack_colors({"#FF3388", "#49CC35"})
	
	for s = 1, lake.screens() do
		lake.add_to_right(batbox, s)
		lake.add_to_right(batgraph, s)
	end
	
	lake.everySecond(function()
		capacity, power, status = get_bat_info()
		
		local flag = ""
		if status == "Charging" then flag = "+" end
		batbox:set_text(capacity.."% "..flag..(math.floor(power/100)/10).."W")
		
		for i = 2, 5 do
			bat_powers[i-1] = bat_powers[i]
		end
		bat_powers[5] = power
	end)
	
	lake.timer(50, function()
		local power_avg = 0
		for i = 1, 5 do
			power_avg = power_avg + bat_powers[i]
		end
		power_avg = power_avg / 5
		
		if power_avg < 10000 then
			batgraph:add_value(0, 1)
			batgraph:add_value(power_avg, 2)
		else
			batgraph:add_value(power_avg/5, 1)
			batgraph:add_value(10000-power_avg/5, 2)
		end
	end)
	
end

