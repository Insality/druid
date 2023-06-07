## Input bindings

**Druid** requires the following input bindings:

- Mouse trigger - `Button 1` -> `touch` _For basic input components_
- Mouse trigger - `Wheel up` -> `mouse_wheel_up` _For scroll component_
- Mouse trigger - `Wheel down` -> `mouse_wheel_down` _For scroll component_
- Key trigger - `Backspace` -> `key_backspace`  _For back_handler component, input component_
- Key trigger - `Back` -> `key_back`  _For back_handler component, Android back button, input component_
- Key trigger - `Enter` -> `key_enter` _For input component, optional_
- Key trigger - `Esc` -> `key_esc` _For input component, optional_
- Touch triggers - `Touch multi` -> `touch_multi` _For scroll component_

![](media/input_binding_2.png)
![](media/input_binding_1.png)

## Change key bindings [optional]
If you have to use your own key bindings (and key name), you can change it in your *game.project* file.

Here is current default values for key bindings:
```
[druid]
input_text = text
input_touch = touch
input_marked_text = marked_text
input_key_esc = key_esc
input_key_back = key_back
input_key_enter = key_enter
input_key_backspace = key_backspace
input_multitouch = touch_multi
input_scroll_up = mouse_wheel_up
input_scroll_down = mouse_wheel_down
```


## Input capturing [optional]

By default, **Druid** will auto-capture input focus, if any input component will be created. So you don't need to call `msg.post(".", "acquire_input_focus")`

If you don't need this behaviour, you can disable it by setting `druid.no_auto_input` field in _game.project_:
```
[druid]
no_auto_input = 1
```


## Template name check [optional]

By default, **Druid** will auto check the parent component template name to build the full template name for component.

If for some reason you want to pass the full template name by yourself, you can disable it by setting `druid.no_auto_template` field in _game.project_:

```
[druid]
no_auto_template = 1
```


## Stencil check [optional]

When creating input components inside stencil nodes, **Druid** automatically setup `component:set_click_zone()` on _late_init_ component step to restrict input clicks outside this stencil zone.
To disable this feature add next field in your _game.project_ file
```
[druid]
no_stencil_check = 1
```


## Code [optional]

Adjust **Druid** settings, if needed:
```lua
local druid = require("druid.druid")

-- Used for button component and custom components
-- Callback should play sound by name: function(sound_id) ... end
druid.set_sound_function(callback)

-- Used for lang_text component
-- Callback should return localized string by locale id: function(locale_id) ... end
druid.set_text_function(callback)

-- Used for change default Druid style
druid.set_default_style(your_style)

-- Call this function on language changing in the game,
-- to retranslate all lang_text components:
druid.on_language_change()

-- Call this function inside window.set_listener
-- to catch game focus lost/gained callbacks:
-- window.set_listener(function(self, event, data) druid.on_window_callback(event, data) end))
druid.on_window_callback(event)
```
