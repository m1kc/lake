# Lake  [![Build Status](https://travis-ci.org/m1kc/lake.svg?branch=master)](https://travis-ci.org/m1kc/lake)

Custom `rc.lua` for Awesome WM, written with plugins in mind. Making the Awesome truly awesome.


## The Idea

Managing widgets in Awesome is a pain in the ass. It looks like "take this code, open your `rc.lua`, write some `require()` here, add this line here, create the widget, store it to some variable, then add it to some container, then define some hotkeys here and here and some timers here". Sometimes it feels like a bit too much friction, doesn't it?

Thankfully, Lake comes and saves your day by putting some auto-management on this stuff. You just put the plugin in `~/.config/awesome`, and voila! Widget appears in the right place, hotkeys, mouse bindings and other stuff work just as you might expect.


## So, how do I start?

Make sure that Lua Filesystem library is installed. Then, replace your old `rc.lua` with this brand new `lake.lua`, probably renaming it in the process. After that, fill your config folder with some nice plugins or write your own.

Please note that Lake has no way to detect its path, so it looks for plugins in cwd first and falls back to `/home/$USER/.config/awesome/` if that fails. Lake will attempt to load every file that starts with `lake-`. It doesn't process subdirs. Plugins are loaded in alphabetical order so you can control execution order and widget positions by renaming corresponding files.


## Opinionation and flexibility

Lake tries to make your life easier, not to stand in your way. Even basic features are implemented as plugins and can be turned off at any time. Other features (such as sloppy focus) are baked into Lake core but they can be turned off as well using vars API. The only hard-coded thing is the panel: Lake assumes you will need one and creates it automatically (its position is configurable as well). So, Lake is almost as flexible as usual `rc.lua` while introducing significantly less friction.


## API documentation

Here's the template for your plugin:

```lua
return function(lake)
	-- your code goes here
end
```

You interact with the rest of the world through the `lake` object.


### lake.ask(lib)

Use this instead of `require()`. You will also need this for accessing standard objects, such as `awesome` and `mouse`.


### lake.set_var(name, value)

Set lake variable. This variable will be globally visible.


### lake.get_var(name)

Get lake variable. These variables are globally visible.

Lake itself uses some vars as well:

* **sloppy_focus** (default: **true**) &mdash; if true, make windows active on hover;
* **titlebars** (default: **false**) &mdash; if true, show titlebar above every window;
* **panel_position** (default: **"top"**) &mdash; panel position;
* **modkey** (default: **"Mod4"**) &mdash; well, modkey;
* **terminal** (default: **"xterm"**), **editor** (default: **$EDITOR or "nano"**) &mdash; commandlines for standard programs.


### lake.screens()

Returns the number of available screens. Typical usage:

```lua
-- Create one taglist widget for every screen
for s = 1, lake.screens() do
	mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)
	lake.add_to_left(mytaglist[s], s)
end
```


### lake.add_to_left(widget, screen), lake.add_to_middle(widget, screen), lake.add_to_right(widget, screen)

Add widget to left, middle or right section of the panel of the given screen.


### lake.override_left(widget, screen), lake.override_middle(widget, screen), lake.override_right(widget, screen)

Override left, middle or right section of the panel of the given screen with the given widget. This will delete every widget from the section and prevent adding new ones.


### lake.global_key(key), lake.global_button(btn), lake.client_key(key), lake.client_button(btn)

Register a hotkey or button globally or for every window (making it window-specific).


### lake.rule(rule)

Register a rule.


### lake.every_second(function)

Run the given function at the beginning of every second. Use this and `lake.timer()` instead of usual timers.


### lake.timer(N, function)

Run the given function every N ticks (every tick is 0,1 second). Use this and `lake.every_second()` instead of usual timers. Prefer `lake.every_second()` when you need 1-second timers.
