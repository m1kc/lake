return function(lake)
	local awful = lake.ask "awful"
	awful.util.spawn "setxkbmap -option grp:caps_toggle us,ru"
end
