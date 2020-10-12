[![](media/druid_logo.png)](https://insality.github.io/druid/)

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/insality/druid)](https://github.com/Insality/druid/releases)

**Druid** - powerful Defold component UI library. Use basic and extended **Druid** components or make your own game-specific components to make amazing GUI in your games.


## Setup

### Dependency

You can use the **Druid** extension in your own project by adding this project as a [Defold library dependency](https://www.defold.com/manuals/libraries/). Open your game.project file and in the dependencies field under project add:

> [https://github.com/Insality/druid/archive/master.zip](https://github.com/Insality/druid/archive/master.zip)

Or point to the ZIP file of a [specific release](https://github.com/Insality/druid/releases).

### Input bindings

**Druid** requires the following input bindings:

- Mouse trigger - `Button 1` -> `touch` _For basic input components_
- Key trigger - `Backspace` -> `key_backspace`  _For back_handler component, input component_
- Key trigger - `Back` -> `key_back`  _For back_handler component, Android back button, input component_
- Key trigger - `Enter` -> `key_enter` _For input component, optional_
- Key trigger - `Esc` -> `key_esc` _For input component, optional_
- Touch triggers - `Touch multi` -> `multitouch` _For scroll component_

![](media/input_binding_2.png)
![](media/input_binding_1.png)


### Input capturing [optional]

By default, **Druid** will auto-capture input focus, if any input component will be created. So you don't need to call `msg.post(".", "acquire_input_focus")`

If you don't need this behaviour, you can disable it by settings `druid.no_auto_input` field in _game.project_:
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
druid.on_language_change()

-- Call this function inside window.set_listener
-- to catch game focus lost/gained callbacks:
druid.on_window_callback(event)
```


## Components

**Druid** provides the following *basic* components:

- **[Button](docs_md/01-components.md#button)** - Basic Druid button input component. Handles all types of interactions (tap, long-tap, hold-tap, double-tap, simple key triggers, etc)

- **[Text](docs_md/01-components.md#text)** - Basic Druid text component. Wrap on gui text node, handle text size adjusting.

- **[Scroll](docs_md/01-components.md#scroll)** - Basic Druid scroll component

- **[Blocker](docs_md/01-components.md#blocker)** - Block input in node zone component

- **[Back Handler](docs_md/01-components.md#back-handler)** - Handle back button (Android back button, backspace key)

- **[Static Grid](docs_md/01-components.md#static-grid)** - Component to manage node positions with equal sizes

- **[Hover](docs_md/01-components.md#hover)** - System Druid component, handle hover node state

- **[Swipe](docs_md/01-components.md#swipe)** - System Druid component, handle swipe gestures on node

- **[Drag](docs_md/01-components.md#drag)** - System Druid component, handle drag input on node 

**Druid** also provides the following *extended* components:

***Note**: In the future, to use extended components, you should register them first. This is required to make **Druid** modular - to exclude unused components from builds*

- **[Checkbox](docs_md/01-components.md#checkbox)** - Checkbox component

- **[Checkbox group](docs_md/01-components.md#checkbox-group)** - Several checkboxes in one group

- **[Dynamic Grid](docs_md/01-components.md#dynamic-grid)** - Component to manage node positions with different sizes. Only in one row or column

- **[Input](docs_md/01-components.md#input)** - User text input component

- **[Lang text](docs_md/01-components.md#lang-text)** - Wrap on Text component to handle localization

- **[Progress](docs_md/01-components.md#progress)** - Progress bar component

- **[Radio group](docs_md/01-components.md#radio-group)** - Several checkboxes in one group with a single choice

- **[Slider](docs_md/01-components.md#slider)** - Slider component

- **[Timer](docs_md/01-components.md#timer)** - Handle timer work on gui text node

For a complete overview, see: _[components.md](docs_md/01-components.md)_.


## Basic usage

To use **Druid**, first you should create a Druid instance to spawn components and add Druids main engine functions: *update*, *final*, *on_message* and *on_input*.

All **Druid** components take node name string as arguments, don't do `gui.get_node()` before.

All **Druid** and component methods are called with `:` like `self.druid:new_button()`.

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

function on_message(self, message_id, message, sender)
    self.druid:on_message(message_id, message, sender)
end


function on_input(self, action_id, action)
    return self.druid:on_input(action_id, action)
end

```

For all **Druid** instance functions, [see here](https://insality.github.io/druid/modules/druid_instance.html).

## Druid Events

Any **Druid** components as callbacks use [Druid Events](https://insality.github.io/druid/modules/druid_event.html). In component API ([button example](https://insality.github.io/druid/modules/druid.button.html#Events)) pointed list of component events. You can manually subscribe to those events with the following API:

- **event:subscribe**(callback)

- **event:unsubscribe**(callback)

- **event:clear**()

You can subscribe several callbacks to a single event.

## Druid Lifecycle

Here is full Druid lifecycle setup for your ***.gui_script** file:
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

- *final* is a **required** function for a correct Druid lifecycle
- *on_input* is used in almost all Druid components
- *update* in used in progress bar, scroll and timer base components
- *on_message* is used for specific Druid events, like language change or layout change

It is recommended to fully integrate all **Druid** lifecycles functions.


## Details

- Druid input goes as stack. Last created button will checked first. So create your GUI from back
- Don't forget about `return` in `on_input`: `return self.druid:on_input()`. It is needed if you have more than 1 acquire inputs (several Druid, other input system, etc)
- By default, Druid will automatically _acquire_input_focus_. So you don't need do it manually. But only if you have components which require _on_input_
- If you want to delete a node which has a Druid component, don't forget to remove it via `druid:remove(component)`

[See full FAQ here](docs_md/FAQ.md)


## Examples

See the [example folder](https://github.com/Insality/druid/tree/develop/example) for examples of how to use **Druid**

See the [druid-assets repository](https://github.com/insality/druid-assets) for examples of how to create custom components and styles

Try the [HTML5 version](https://insality.github.io/druid/druid/) of the example app


## Documentation

To better understand **Druid**, read the following documentation:
- [Druid components](docs_md/01-components.md)
- [Create custom components](docs_md/02-creating_custom_components.md)
- [See FAQ article](docs_md/FAQ.md)
- [Druid styles](docs_md/03-styles.md)
- [Druid asset store](docs_md/04-druid_assets.md)

You can fund the full **Druid** documentation here:
https://insality.github.io/druid/


## Games powered by Druid

_You published your game and you using Druid? Note me!_


## License

- Developed and supported by [Insality](https://github.com/Insality)
- Original idea by [AGulev](https://github.com/AGulev)
- Assets from [Kenney](http://www.kenney.nl/)

**MIT** License


## Issues and suggestions

If you have any issues, questions or suggestions please [create an issue](https://github.com/Insality/druid/issues) or contact me: [insality@gmail.com](mailto:insality@gmail.com)
