# druid API

> at /druid/druid.lua

Entry point for Druid UI Framework.
Create a new Druid instance and adjust the Druid settings here.

## Functions

- [new](#new)
- [register](#register)
- [set_default_style](#set_default_style)
- [set_text_function](#set_text_function)
- [set_sound_function](#set_sound_function)
- [init_window_listener](#init_window_listener)
- [on_window_callback](#on_window_callback)
- [on_language_change](#on_language_change)
- [get_widget](#get_widget)
- [register_druid_as_widget](#register_druid_as_widget)
- [unregister_druid_as_widget](#unregister_druid_as_widget)



### new

---
```lua
druid.new(context, [style])
```

Create a new Druid instance for creating GUI components.

- **Parameters:**
	- `context` *(table)*: The Druid context. Usually, this is the self of the gui_script. It is passed into all Druid callbacks.
	- `[style]` *(table|nil)*: The Druid style table to override style parameters for this Druid instance.

- **Returns:**
	- `druid_instance` *(druid.instance)*: The new Druid instance

### register

---
```lua
druid.register(name, module)
```

Register a new external Druid component.
Register component just makes the druid:new_{name} function.
For example, if you register a component called "my_component", you can create it using druid:new_my_component(...).
This can be useful if you have your own "basic" components that you don't want to require in every file.
The default way to create component is `druid_instance:new(component_class, ...)`.

- **Parameters:**
	- `name` *(string)*: Module name
	- `module` *(table)*: Lua table with component

### set_default_style

---
```lua
druid.set_default_style(style)
```

Set the default style for all Druid instances.

- **Parameters:**
	- `style` *(table)*: Default style

### set_text_function

---
```lua
druid.set_text_function(callback)
```

Set the text function for the LangText component.

- **Parameters:**
	- `callback` *(fun(text_id: string):string)*: Get localized text function

### set_sound_function

---
```lua
druid.set_sound_function(callback)
```

Set the sound function to able components to play sounds.

- **Parameters:**
	- `callback` *(fun(sound_id: string))*: Sound play callback

### init_window_listener

---
```lua
druid.init_window_listener()
```

Subscribe Druid to the window listener. It will override your previous
window listener, so if you have one, you should call M.on_window_callback manually.

### on_window_callback

---
```lua
druid.on_window_callback(window_event)
```

Set the window callback to enable Druid window events.

- **Parameters:**
	- `window_event` *(constant)*: Event param from window listener

### on_language_change

---
```lua
druid.on_language_change()
```

Call this function when the game language changes.
It will notify all Druid instances to update the lang text components.

### get_widget

---
```lua
druid.get_widget(widget_class, gui_url)
```

Create a widget from the binded Druid GUI instance.
The widget will be created and all widget functions can be called from Game Object contexts.
This allow use only `druid_widget.gui_script` for GUI files and call this widget functions from Game Object script file.
Widget class here is a your lua file for the GUI scene (a widgets in Druid)

- **Parameters:**
	- `widget_class` *(<T:druid.widget>)*: The class of the widget to return
	- `gui_url` *(url)*: GUI url

- **Returns:**
	- `widget` *(<T:druid.widget>?)*: The new created widget,

- **Example Usage:**

```lua
msg.url(nil, nil, "gui_widget") -- current game object
msg.url(nil, object_url, "gui_widget") -- other game object
```
### register_druid_as_widget

---
```lua
druid.register_druid_as_widget(druid)
```

Bind a Druid GUI instance to the current game object.
This instance now can produce widgets from `druid.get_widget()` function.
Only one widget can be set per game object.

- **Parameters:**
	- `druid` *(druid.instance)*: The druid instance to register

### unregister_druid_as_widget

---
```lua
druid.unregister_druid_as_widget()
```

Should be called on final, where druid instance is destroyed.

