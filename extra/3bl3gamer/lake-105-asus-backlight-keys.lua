function update_file(path, func)
	f = io.open(path, "r+")
	s = f:read()
	s = f:write(func(s))
	f:close()
end
function lcd_light_upd(func)
	update_file("/sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-eDP-1/intel_backlight/brightness", func)
end
function kbd_light_upd(func)
	update_file("/sys/devices/platform/asus-nb-wmi/leds/asus::kbd_backlight/brightness", func)
end
function lcd_light_inc()
	lcd_light_upd(function(s) return math.max(1, math.ceil(s*1.5)) end)
end
function lcd_light_dec()
	lcd_light_upd(function(s) return math.max(1, math.floor(s/1.5)) end)
end
function kbd_light_inc()
	kbd_light_upd(function(s) return s+1 end)
end
function kbd_light_dec()
	kbd_light_upd(function(s) return s-1 end)
end

return function(lake)
	local awful = lake.ask "awful"
	local modkey = lake.get_var "modkey"

	lake.global_key(awful.key({ modkey,         }, "0", lcd_light_dec))
	lake.global_key(awful.key({ modkey, "Shift" }, "0", lcd_light_inc))
	lake.global_key(awful.key({ }, "XF86KbdBrightnessDown", kbd_light_dec))
	lake.global_key(awful.key({ }, "XF86KbdBrightnessUp", kbd_light_inc))
end
