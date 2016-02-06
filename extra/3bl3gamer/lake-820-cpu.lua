local cpus_number = 0
local f = io.open("/proc/stat", "r")
f:read() -- skipping first line with whole CPU info
while f:read():sub(1, 3) == "cpu" do
	cpus_number = cpus_number + 1
end
f:close()

local colors = {"#FF6E00", "#CB0C29", "#49CC35", "#0077FF"}
while #colors < cpus_number do
	table.insert(colors, colors[#colors-3])
end


function new_stat()
	return {["idle"]=0, ["total"]=0}
end

local percents = {0, 0, 0, 0}
local prev_stats = {new_stat(), new_stat(), new_stat(), new_stat()}
local stats = {new_stat(), new_stat(), new_stat(), new_stat()}

function parse_cpu_line(line, stat)
	line = line:sub(6) -- cut off 'cpuN '
	local m = string.gmatch(line, "%d+")
	local user, nice, system, idle, iowait, irq, softirq = m(), m(), m(), m(), m(), m(), m()
	stat.idle = idle -- mb add more fields?
	stat.total = user + nice + system + idle + iowait + irq + softirq
end

function update_cpu_percents()
	local f = io.open("/proc/stat", "r")
	f:read() -- skipping first line with whole CPU info
	for i = 1, cpus_number do
		parse_cpu_line(f:read(), stats[i])
		local idle  = stats[i].idle  - prev_stats[i].idle
		local total = stats[i].total - prev_stats[i].total
		local percent = (1 - idle/total) * 100
		percents[i] = percent
	end
	f:close()
	local t=stats; stats=prev_stats; prev_stats=t
end

return function(lake)
	local awful = lake.ask "awful"

	local cpugraph = awful.widget.graph()
	cpugraph:set_width(50)
	cpugraph:set_stack(true)
	cpugraph:set_stack_colors(colors)
	cpugraph:set_max_value(100 * cpus_number)

	for s = 1, lake.screens() do
		lake.add_to_right(cpugraph, s)
	end

	lake.timer(2, function()
		update_cpu_percents()
		for i = 1, cpus_number do
			cpugraph:add_value(percents[i], i)
		end
	end)
end

