


[![](media/druid_logo.png)](https://insality.github.io/druid/)

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/insality/druid)](https://github.com/Insality/druid/releases)

**Druid** - powerful defold component UI library. Use basic **Druid** components or make your own game-specific components to make amazing GUI in your games.


## Setup

### Dependency

You can use the **Druid** extension in your own project by adding this project as a [Defold library dependency](https://www.defold.com/manuals/libraries/). Open your game.project file and in the dependencies field under project add:

> [https://github.com/Insality/druid/archive/master.zip](https://github.com/Insality/druid/archive/master.zip)

Or point to the ZIP file of a  [specific release](https://github.com/Insality/druid/releases).

### Input bindings

For **Druid** to work requires next input bindings:

-   Mouse trigger - `Button 1` -> `touch` _For basic input components_
-   Key trigger - `Backspace` -> `key_backspace`  _For back_handler component, input component_
-   Key trigger - `Back` -> `key_back`  _For back_handler component, Android back button, input component_
- Key trigger - `Enter` -> `key_enter` _For input component, optional_
- Key trigger - `Esc` -> `key_esc` _For input component, optional_

![](media/input_binding_2.png)
![](media/input_binding_1.png)


### Input capturing [optional]

By default, **Druid** will auto-capture input focus, if any input component will be created. So you don't need to call `msg.post(".", "acquire_input_focus)"`

If you not need this behaviour, you can disable it by settings `druid.no_auto_input` field in _game.project_:
```
[druid]
no_auto_input = 1
```

### Code [optional]

Adjust **Druid** settings, if needed:
```lua
local druid = require("druid.druid")

-- Used for button component and custom components
-- Callback should play sound by name
druid.set_sound_function(callback)

-- Used for lang_text component
-- Callback should return localized string by locale id
druid.set_text_function(callback)

-- Used for change default druid style
druid.set_default_style(your_style)

-- Call this function on language changing in the game,
-- to retranslate all lang_text components:
druid.on_languge_change()

-- Call this function on layout changing in the game,
-- to reapply layouts
druid.on_layout_change()

-- Call this function inside window.set_listener
-- to catch game focus lost/gained callbacks:
druid.on_window_callback(event)
```


## Components

**Druid** provides next basic components:

- **[Button](https://github.com/Insality/druid/blob/master/docs_md/01-components.md#button)** - Basic Druid input component

- **[Text](https://github.com/Insality/druid/blob/master/docs_md/01-components.md#text)** - Basic Druid text component

- **[Lang text](https://github.com/Insality/druid/blob/master/docs_md/01-components.md#lang-text)** - Wrap on Text component to handle localization

- **[Scroll](https://github.com/Insality/druid/blob/master/docs_md/01-components.md#scroll)** - Basic Druid scroll component

- **[Progress](https://github.com/Insality/druid/blob/master/docs_md/01-components.md#progress)** - Basic Druid progress bar component

- **[Slider](https://github.com/Insality/druid/blob/master/docs_md/01-components.md#slider)** - Basic Druid slider component

- **[Input](https://github.com/Insality/druid/blob/master/docs_md/01-components.md#input)** - Basic Druid text input component (unimplemented)

- **[Checkbox](https://github.com/Insality/druid/blob/master/docs_md/01-components.md#checkbox)** - Basic Druid checkbox component

- **[Checkbox group](https://github.com/Insality/druid/blob/master/docs_md/01-components.md#checkbox-group)** - Several checkboxes in one group

- **[Radio group](https://github.com/Insality/druid/blob/master/docs_md/01-components.md#radio-group)** - Several checkboxes in one group with single choice

- **[Blocker](https://github.com/Insality/druid/blob/master/docs_md/01-components.md#blocker)** - Block input in node zone component

- **[Back Handler](https://github.com/Insality/druid/blob/master/docs_md/01-components.md#back-handler)** - Handle back button (Android back, backspace)

- **[Timer](https://github.com/Insality/druid/blob/master/docs_md/01-components.md#timer)** - Handle timer work on gui text node

- **[Grid](https://github.com/Insality/druid/blob/master/docs_md/01-components.md#grid)** - Component for manage node positions 

- **[Hover](https://github.com/Insality/druid/blob/master/docs_md/01-components.md#hover)** - System Druid component, handle hover node state

- **[Swipe](https://github.com/Insality/druid/blob/master/docs_md/01-components.md#swipe)** - System Druid component, handle swipe gestures on node

Full info see on _[components.md](https://github.com/Insality/druid/blob/master/docs_md/01-components.md)_


## Basic usage

For using **Druid**, first you should create Druid instance to spawn components. Pass to new Druid instance main engine functions: *update*, *on_message* and *on_input*

All **Druid** components as arguments can apply node name string, you can don't do `gui.get_node()` before

All **Druid** and component methods calling with `:` like `self.druid:new_button()`

```lua
local druid = require("druid.druid")

local function button_callback(self)
	print("Button was clicked!")
end

function init(self)
	self.druid = druid.new(self)
	self.druid:new_button("button_node_name", button_callback)
end

function final(self)
	self.druid:final()
end

function on_input(self, action_id, action)
	return self.druid:on_input(action_id, action)
end
```

## Druid Events

Any **Druid** components as callbacks uses [Druid Events](https://insality.github.io/druid/modules/druid_event.html). In component API ([button example](https://insality.github.io/druid/modules/druid.button.html#Events)) pointed list of component events. You can manually subscribe on this events by next API:

- **event:subscribe**(callback)

- **event:unsubscribe**(callback)

- **event:clear**()

Any events can handle several callbacks, if needed.


## Druid lifecycle

Here is full druid lifecycle setup in your ***.gui_script** file:
```lua
local druid = require("druid.druid")

function init(self)
	self.druid = druid.new(self)
end

function final(self)
	self.druid:final()
end

function update(self, dt)
	self.druid:update(dt)
end

function on_input(self, action_id, action)
	return self.druid:on_input(action_id, action)
end

function on_message(self, message_id, message, sender)
	self.druid:on_message(message_id, message, sender)
end
```

- *on_input* used for almost all basic druid components
- *update* used for progress bar, scroll and timer base components
- *on_message* used for specific druid events, like language change or layout change (TODO: in future)
- *final* used for custom components, what have to do several action before destroy

Recommended is fully integrate al druid lifecycles functions


## Features

- Druid input goes as stack. Last created button will checked first. So create your GUI from back
- Don't forget about `return` in `on_input`: `return self.druid:on_input()`. It need, if you have more than 1 acquire inputs (several druid, other input system, etc)


## Examples

See the [example folder](https://github.com/Insality/druid/tree/develop/example) for examples of how to use **Druid**

See the [druid-assets repository](https://github.com/insality/druid-assets) for examples of how to create custom components and styles

Try the [HTML5 version](https://insality.github.io/druid/druid/) of the example app


## Documentation

To learn **Druid** better, read next documentation:
- [Druid components](https://github.com/Insality/druid/blob/master/docs_md/01-components.md)
- [Create custom components](https://github.com/Insality/druid/blob/master/docs_md/02-creating_custom_components.md)
- [Druid styles](https://github.com/Insality/druid/blob/master/docs_md/03-styles.md)
- [Druid asset store](https://github.com/Insality/druid/blob/master/docs_md/04-druid_assets.md)

Full **Druid** documentation you can find here:
https://insality.github.io/druid/


## Games powered by Druid

_Will fill later_


## License

Original created by [AGulev](https://github.com/AGulev)

Developed and supporting by [Insality](https://github.com/Insality)

Assets from [Kenney](http://www.kenney.nl/)

MIT License


## Issues and suggestions

If you have any issues, questions or suggestions please  [create an issue](https://github.com/Insality/druid/issues)  or contact me:  [insality@gmail.com](mailto:insality@gmail.com)
