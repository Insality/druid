# Memory and FPS Panel Widgets

The `Druid 1.1` comes with widgets and two included widgets are `Memory Panel` and `FPS Panel` which allow you to monitor memory and FPS in your game.

Widgets in Druid usually consists from two files: GUI, which is used to placed as a template on your GUI scene and Lua script, which is used to be created with Druid.

<!-- Video -->

## Memory Panel

The `Memory Panel` is a widget which allows you to monitor memory of your game. It displays the last 3 seconds of memory allocations in graph, largest memory allocation step, total Lua memory and memory per second.

When you see an empty space in graphs - it means the garbage collector is working at this moment.

### How to add:

- Add `/druid/widget/memory_panel/memory_panel.gui` to your `*.gui` scene

![](/wiki/manuals/media/memory_fps_panel_add.png)
![](/wiki/manuals/media/memory_fps_panel_select.png)

- You can adjust a scale of the template if required
- Add Druid and widget setup to your `*.gui_script`
```lua
local druid = require("druid.druid")
local memory_panel = require("druid.widget.memory_panel.memory_panel")

function init(self)
	self.druid = druid.new(self)
	-- "memory_panel" is a name of the template in the GUI scene, often it matches the name of the template file
	self.memory_panel = self.druid:new_widget(memory_panel, "memory_panel")
end

function final(self)
	self.druid:final()
end

function update(self, dt)
	self.druid:update(dt)
end

function on_message(self, message_id, message, sender)
	self.druid:on_message(message_id, message, sender)
end

function on_input(self, action_id, action)
	return self.druid:on_input(action_id, action)
end
```

And make sure of:
- The `*.gui_script` is attached to your `*.gui` scene
- The GUI component is added to your game scene


## FPS Panel

The `FPS Panel` is a widget which allows you to monitor FPS of your game. It displays the last 3 seconds of FPS graph, lowest and current FPS values

### How to add:

- Add `/druid/widget/fps_panel/fps_panel.gui` to your `*.gui` scene
- You can adjust a scale of the template if required
- Add Druid and widget setup to your `*.gui_script`
```lua
local druid = require("druid.druid")
local fps_panel = require("druid.widget.fps_panel.fps_panel")

function init(self)
	self.druid = druid.new(self)
	-- "fps_panel" is a name of the template in the GUI scene, often it matches the name of the template file
	self.fps_panel = self.druid:new_widget(fps_panel, "fps_panel")
end

function final(self)
	self.druid:final()
end

function update(self, dt)
	self.druid:update(dt)
end

function on_message(self, message_id, message, sender)
	self.druid:on_message(message_id, message, sender)
end

function on_input(self, action_id, action)
	return self.druid:on_input(action_id, action)
end
```

And make sure of:
- The `*.gui_script` is attached to your `*.gui` scene
- The GUI component is added to your game scene

These widgets not only can be useful for development and profiling your game, but also as an example of how to create custom widgets with Druid and use them in your game.

Thanks for reading!
