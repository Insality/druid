
[![](media/druid_logo.png)](https://insality.github.io/druid/)

[![Github-sponsors](https://img.shields.io/badge/sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#EA4AAA)](https://github.com/sponsors/insality) [![Ko-Fi](https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/insality) [![BuyMeACoffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://www.buymeacoffee.com/insality)

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/insality/druid)](https://github.com/Insality/druid/releases)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/insality/druid/ci-workflow.yml?branch=master)](https://github.com/Insality/druid/actions)
[![codecov](https://codecov.io/gh/Insality/druid/branch/master/graph/badge.svg)](https://codecov.io/gh/Insality/druid)

**Druid** - powerful Defold component UI library. Use basic and extended **Druid** components or make your own game-specific components to make amazing GUI in your games.


## Overview



## Setup

### Dependency

You can use the **Druid** extension in your own project by adding this project as a [Defold library dependency](https://www.defold.com/manuals/libraries/). Open your `game.project` file and in the dependencies field under project add:

**Druid v0.10.3**
> [https://github.com/Insality/druid/archive/refs/tags/0.10.3.zip](https://github.com/Insality/druid/archive/refs/tags/0.10.3.zip)

Here is a list of [all releases](https://github.com/Insality/druid/releases).

### Input Bindings
Druid uses `/builtins/input/all.input_binding` input bindins. For advanced setup see the Input Binding section in Advanced Setup.


## Usage

Here only basic usage.
How to read this doc.
Annotations.
Example of advanced usage - different doc.
Example of custom components - different doc.

## Components

Here is full **Druid** components list:

### Basic Components

| Name | Description | Example | <div style="width:200px">Preview</div> |
|------|-------------|---------|---------|
| **[Button](https://insality.github.io/druid/modules/Button.html)** | Basic input component. Handles all types of interactions: click, long click, hold click, double click, etc | [Button Example](https://insality.github.io/druid/druid/?example=general_buttons) | <img src="media/preview/button.gif" width="200" height="100"> |
| **[Text](https://insality.github.io/druid/modules/Text.html)** | Wrap on GUI text node, handle different text size adjusting, providing additional text API | [Text Example](https://insality.github.io/druid/druid/?example=texts_general) | <img src="media/preview/text.gif" width="200" height="100"> |
| **[Scroll](https://insality.github.io/druid/modules/Scroll.html)** | Scroll component | [Scroll Example](https://insality.github.io/druid/druid/?example=general_scroll) | <img src="media/preview/scroll.gif" width="200" height="100"> |
| **[Blocker](https://insality.github.io/druid/modules/Blocker.html)** | Block user input in node zone area | ❌ | |
| **[Back Handler](https://insality.github.io/druid/modules/BackHandler.html)** | Handle back button (Android back button, backspace key) | ❌ | |
| **[Static Grid](https://insality.github.io/druid/modules/StaticGrid.html)** | Component to manage node positions with equal sizes | [Static Gid Example](https://insality.github.io/druid/druid/?example=general_grid) | <img src="media/preview/static_grid.gif" width="200" height="100"> |
| **[Hover](https://insality.github.io/druid/modules/Hover.html)** | Handle hover node state on node | ❌ | <img src="media/preview/hover.gif" width="200" height="100"> |
| **[Swipe](https://insality.github.io/druid/modules/Swipe.html)** | Handle swipe gestures on node | [Swipe Example](https://insality.github.io/druid/druid/?example=general_swipe) | <img src="media/preview/swipe.gif" width="200" height="100"> |
| **[Drag](https://insality.github.io/druid/modules/Drag.html)** | Handle drag input on node | [Drag Example](https://insality.github.io/druid/druid/?example=general_drag) | <img src="media/preview/drag.gif" width="200" height="100"> |


### Extended components
> Extended components before usage should be registered in **Druid** with `druid.register()` function.

| Name | Description | Example | <div style="width:200px">Preview</div> |
|------|-------------|---------|---------|
| **[Checkbox](https://insality.github.io/druid/modules/Checkbox.html)** | Checkbox component | [Checkbox Example](https://insality.github.io/druid/druid/?example=general_checkboxes) | <img src="media/preview/checkbox.gif" width="200" height="100"> |
| **[Checkbox group](https://insality.github.io/druid/modules/CheckboxGroup.html)** | Several checkboxes in one group | [Checkbox group Example](https://insality.github.io/druid/druid/?example=general_checkboxes) | <img src="media/preview/checkbox_group.gif" width="200" height="100"> |
| **[Radio group](https://insality.github.io/druid/modules/RadioGroup.html)** | Several checkboxes in one group with a single choice | [Radio Group Example](https://insality.github.io/druid/druid/?example=general_checkboxes) | <img src="media/preview/radio_group.gif" width="200" height="100"> |
| **[Dynamic Grid](https://insality.github.io/druid/modules/DynamicGrid.html)** | Component to manage node positions with different sizes. Only in one row or column | [Dynamic Grid Example](https://insality.github.io/druid/druid/?example=general_grid) | <img src="media/preview/dynamic_grid.gif" width="200" height="100"> |
| **[Data List](https://insality.github.io/druid/modules/DataList.html)** | Component to manage data for huge datasets in scroll | [Data List Example](https://insality.github.io/druid/druid/?example=general_data_list) | <img src="media/preview/data_list.gif" width="200" height="100"> |
| **[Input](https://insality.github.io/druid/modules/Input.html)** | User text input component | [Input Example](https://insality.github.io/druid/druid/?example=general_input) | <img src="media/preview/input.gif" width="200" height="100"> |
| **[Lang text](https://insality.github.io/druid/modules/LangText.html)** | Wrap on Text component to handle localization | ❌ | <img src="media/preview/lang_text.gif" width="200" height="100"> |
| **[Progress](https://insality.github.io/druid/modules/Progress.html)** | Progress bar component | [Progress Example](https://insality.github.io/druid/druid/?example=general_progress_bar) | <img src="media/preview/progress.gif" width="200" height="100"> |
| **[Slider](https://insality.github.io/druid/modules/Slider.html)** | Slider component | [Slider Example]() | <img src="media/preview/slider.gif" width="200" height="100"> |
| **[Timer](https://insality.github.io/druid/modules/Timer.html)** | Handle timers on GUI text node | ❌ | <img src="media/preview/timer.gif" width="200" height="100"> |
| **[Hotkey](https://insality.github.io/druid/modules/Hotkey.html)** | Handle keyboard hotkeys with key modificators | [Hotkey Example](https://insality.github.io/druid/druid/?example=general_hokey) | <img src="media/preview/hotkey.gif" width="200" height="100"> |
| **[Layout](https://insality.github.io/druid/modules/Layout.html)** | Handle node size depends on layout mode and screen aspect ratio | [Layout Example](https://insality.github.io/druid/druid/?example=general_layout) | <img src="media/preview/layout.gif" width="200" height="100"> |

For a complete overview, see: **_[components.md](docs_md/01-components.md)_**.


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

For all **Druid** instance functions, [see here](https://insality.github.io/druid/modules/DruidInstance.html).

## Druid Events

Any **Druid** components as callbacks use [Druid Events](https://insality.github.io/druid/modules/DruidEvent.html). In component API ([button example](https://insality.github.io/druid/modules/Button.html#on_click)) pointed list of component events. You can manually subscribe to those events with the following API:

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

See the [**example folder**](https://github.com/Insality/druid/tree/develop/example) for examples of how to use **Druid**

Try the [**HTML5 version**](https://insality.github.io/druid/druid/) of the **Druid** example app


## Documentation

To better understand **Druid**, read the following documentation:
- [Druid components](docs_md/01-components.md)
- [Create custom components](docs_md/02-creating_custom_components.md)
- [See FAQ article](docs_md/FAQ.md)
- [Druid styles](docs_md/03-styles.md)

You can fund the full **Druid** documentation here:
https://insality.github.io/druid/


## License

- Developed and supported by [Insality](https://github.com/Insality)
- Original idea by [AGulev](https://github.com/AGulev)
- Assets from [Kenney](http://www.kenney.nl/)


## Issues and suggestions

If you have any issues, questions or suggestions please [create an issue](https://github.com/Insality/druid/issues) or contact me: [insality@gmail.com](mailto:insality@gmail.com)


## ❤️ Support project ❤️

Your donation helps me stay engaged in creating valuable projects for **Defold**. If you appreciate what I'm doing, please consider supporting me!

[![Github-sponsors](https://img.shields.io/badge/sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#EA4AAA)](https://github.com/sponsors/insality) [![Ko-Fi](https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/insality) [![BuyMeACoffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://www.buymeacoffee.com/insality)
