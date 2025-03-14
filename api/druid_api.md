# druid API

> at /druid/druid.lua

Entry point for Druid UI Framework.
Create a new Druid instance and adjust the Druid settings here.

## Table of Contents


## Functions
- [new](#new)
- [set_default_style](#set_default_style)
- [set_text_function](#set_text_function)
- [set_sound_function](#set_sound_function)
- [init_window_listener](#init_window_listener)
- [on_window_callback](#on_window_callback)
- [on_language_change](#on_language_change)



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
