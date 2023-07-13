
[![](media/druid_logo.png)](https://insality.github.io/druid/)

[![Github-sponsors](https://img.shields.io/badge/sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#EA4AAA)](https://github.com/sponsors/insality) [![Ko-Fi](https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/insality) [![BuyMeACoffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://www.buymeacoffee.com/insality)

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/insality/druid)](https://github.com/Insality/druid/releases)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/insality/druid/ci-workflow.yml?branch=master)](https://github.com/Insality/druid/actions)
[![codecov](https://codecov.io/gh/Insality/druid/branch/master/graph/badge.svg)](https://codecov.io/gh/Insality/druid)

**Druid** - powerful **Defold** component UI framework that empowers developers to create stunning and customizable GUIs by leveraging a wide range of embedded components or effortlessly designing their own game-specific components.

Try the [**HTML5 version**](https://insality.github.io/druid/druid/) of the **Druid** example app.

## Setup

### Dependency

To integrate the **Druid** extension into your own project, add this project as a [dependency](https://www.defold.com/manuals/libraries/) in your **Defold** game. Open your `game.project` file and add the following line to the dependencies field under the project section:

**Druid v0.11.0**

> [https://github.com/Insality/druid/archive/refs/tags/0.11.0.zip](https://github.com/Insality/druid/archive/refs/tags/0.11.0.zip)

Here is a list of [all releases](https://github.com/Insality/druid/releases).

Size: **68.73 KB**

> The size metrics exlcude the extended components, which are including only on demand.

### Input Bindings
**Druid** utilizes the `/builtins/input/all.input_binding` input bindings. For custom input bindings, refer to the Input Binding section in the  **_[Advanced Setup](docs_md/advanced-setup.md#input-bindings)_**.


## Usage

### Basic usage

To utilize **Druid**, begin by creating a **Druid** instance to instantiate components and include the main functions of **Druid**: *update*, *final*, *on_message*, and *on_input*.

When using **Druid** components, provide a node name string as an argument. If you don't have the node name available in some cases, you can pass `gui.get_node()` instead.

All **Druid** and component methods are invoked using the `:` operator, such as `self.druid:new_button()`.

```lua
local druid = require("druid.druid")

-- All component callbacks pass "self" as first argument
-- This "self" is a context data passed in `druid.new(context)`
local function on_button_callback(self)
    print("The button clicked!")
end

function init(self)
    self.druid = druid.new(self)
    self.button = self.druid:new_button("button_node_name", on_button_callback)
end

-- "final" is a required function for the correct Druid workflow
function final(self)
    self.druid:final()
end

-- "update" is used in progress bar, scroll, and timer basic components
function update(self, dt)
    self.druid:update(dt)
end

-- "on_message" is used for specific Druid events, like language change or layout change
function on_message(self, message_id, message, sender)
    self.druid:on_message(message_id, message, sender)
end

-- "on_input" is used in almost all Druid components
function on_input(self, action_id, action)
    return self.druid:on_input(action_id, action)
end

```

For all **Druid** instance functions, [see here](https://insality.github.io/druid/modules/DruidInstance.html).


### API Documentation

**Druid** offers a wide range of components and functions. To facilitate usage, **Druid** provides comprehensive API documentation with examples and annotations.

Start reading the API documentation [here](https://insality.github.io/druid/modules/Druid.html).


### EmmyLua Annotations [optional]

[EmmyLua](https://emmylua.github.io/annotation.html) is a Lua annotation library. It is a useful tool for enabling Lua code autocompletion in editors such as [VSCode](https://github.com/EmmyLua/VSCode-EmmyLua) and [IntelliJ IDEA](https://github.com/EmmyLua/IntelliJ-EmmyLua).

Since dependencies cannot be processed by external editors, to use the EmmyLua annotations, you should copy the _druid/annotations.lua_ file to your project.

Remember that you can restart the EmmyLua server to refresh the changes if something goes wrong.

After the annotations are processed, you should specify the type of "Druid" in the "require" statement:

```lua
---@type druid
local druid = require("druid.druid")

-- Now the autocomplete is working
```

<img src="media/emmy_lua_preview.png" width="700">


### Create custom components

If you want to create your own components, refer to the [Create Custom Components](docs_md/02-creating_custom_components.md) section in the documentation.

Custom components are one of the most powerful features of **Druid**. They allow you to create your own components effortlessly and utilize them in your game.


## Druid Components

Here is full **Druid** components list.

### Basic Components

> Basic components always included in the build and available for use.

| Name | Description | Example | <div style="width:200px">Preview</div> |
|------|-------------|---------|---------|
| **[Button](https://insality.github.io/druid/modules/Button.html)** | Logic over GUI Node. Handle the user click interactions: click, long click, double click, etc. | [Button Example](https://insality.github.io/druid/druid/?example=general_buttons) | <img src="media/preview/button.gif" width="200" height="100"> |
| **[Text](https://insality.github.io/druid/modules/Text.html)** | Logic over GUI Text. By default Text component fit the text inside text node size area with different adjust modes. | [Text Example](https://insality.github.io/druid/druid/?example=texts_general) | <img src="media/preview/text.gif" width="200" height="100"> |
| **[Scroll](https://insality.github.io/druid/modules/Scroll.html)** | Logic over two GUI Nodes: input and content. Provides basic behaviour for scrollable content. | [Scroll Example](https://insality.github.io/druid/druid/?example=general_scroll) | <img src="media/preview/scroll.gif" width="200" height="100"> |
| **[Blocker](https://insality.github.io/druid/modules/Blocker.html)** | Logic over GUI Node. Don't pass any user input below node area size. | ❌ | |
| **[Back Handler](https://insality.github.io/druid/modules/BackHandler.html)** | Call callback on user "Back" action. It's a Android back button or keyboard backspace key | ❌ | |
| **[Static Grid](https://insality.github.io/druid/modules/StaticGrid.html)** | Logic over GUI Node. Component to manage node positions with all equal node sizes. | [Static Gid Example](https://insality.github.io/druid/druid/?example=general_grid) | <img src="media/preview/static_grid.gif" width="200" height="100"> |
| **[Hover](https://insality.github.io/druid/modules/Hover.html)** | Logic over GUI Node. Handle hover action over node. For both: mobile touch and mouse cursor. | ❌ | <img src="media/preview/hover.gif" width="200" height="100"> |
| **[Swipe](https://insality.github.io/druid/modules/Swipe.html)** | Logic over GUI Node. Handle swipe gestures over node. | [Swipe Example](https://insality.github.io/druid/druid/?example=general_swipe) | <img src="media/preview/swipe.gif" width="200" height="100"> |
| **[Drag](https://insality.github.io/druid/modules/Drag.html)** | Logic over GUI Node. Handle drag input actions. Can be useful to make on screen controlls. | [Drag Example](https://insality.github.io/druid/druid/?example=general_drag) | <img src="media/preview/drag.gif" width="200" height="100"> |


### Extended components

> Extended components before usage should be registered in **Druid** with `druid.register()` function.
> On usage of unregistered **Druid** component the next log will be shown in the console.
```
local data_list = require("druid.extended.data_list")
druid.register("data_list", data_list)
```

| Name | Description | Example | <div style="width:200px">Preview</div> |
|------|-------------|---------|---------|
| **[Checkbox](https://insality.github.io/druid/modules/Checkbox.html)** | Switch node state on click event. | [Checkbox Example](https://insality.github.io/druid/druid/?example=general_checkboxes) | <img src="media/preview/checkbox.gif" width="200" height="100"> |
| **[Checkbox group](https://insality.github.io/druid/modules/CheckboxGroup.html)** | Group of checkbox components. | [Checkbox group Example](https://insality.github.io/druid/druid/?example=general_checkboxes) | <img src="media/preview/checkbox_group.gif" width="200" height="100"> |
| **[Radio group](https://insality.github.io/druid/modules/RadioGroup.html)** | Like checkbox group but with single choise only. | [Radio Group Example](https://insality.github.io/druid/druid/?example=general_checkboxes) | <img src="media/preview/radio_group.gif" width="200" height="100"> |
| **[Dynamic Grid](https://insality.github.io/druid/modules/DynamicGrid.html)** | Logic over GUI Node. Component to manage node positions with all different node sizes. Only one direction: horizontal or vertical. | [Dynamic Grid Example](https://insality.github.io/druid/druid/?example=general_grid) | <img src="media/preview/dynamic_grid.gif" width="200" height="100"> |
| **[Data List](https://insality.github.io/druid/modules/DataList.html)** | Logic over Scroll and Grid components. Create only visible GUI nodes or components to make "infinity" scroll befaviour | [Data List Example](https://insality.github.io/druid/druid/?example=general_data_list) | <img src="media/preview/data_list.gif" width="200" height="100"> |
| **[Input](https://insality.github.io/druid/modules/Input.html)** | Logic over GUI Node and GUI Text (or Text component). Provides basic user text input. | [Input Example](https://insality.github.io/druid/druid/?example=general_input) | <img src="media/preview/input.gif" width="200" height="100"> |
| **[Lang text](https://insality.github.io/druid/modules/LangText.html)** | Logic over Text component to handle localization. Can be translated in real-time with `druid.on_language_change` | ❌ | <img src="media/preview/lang_text.gif" width="200" height="100"> |
| **[Progress](https://insality.github.io/druid/modules/Progress.html)** | Logic over GUI Node. Handle node size and scale to handle progress node size. | [Progress Example](https://insality.github.io/druid/druid/?example=general_progress_bar) | <img src="media/preview/progress.gif" width="200" height="100"> |
| **[Slider](https://insality.github.io/druid/modules/Slider.html)** | Logic over GUI Node. Handle draggable node with position restrictions. | [Slider Example](https://insality.github.io/druid/druid/?example=general_sliders) | <img src="media/preview/slider.gif" width="200" height="100"> |
| **[Timer](https://insality.github.io/druid/modules/Timer.html)** | Logic over GUI Text. Handle basic timer functions. | ❌ | <img src="media/preview/timer.gif" width="200" height="100"> |
| **[Hotkey](https://insality.github.io/druid/modules/Hotkey.html)** | Allow to set callbacks for keyboard hotkeys with key modificators. | [Hotkey Example](https://insality.github.io/druid/druid/?example=general_hotkey) | <img src="media/preview/hotkey.gif" width="200" height="100"> |
| **[Layout](https://insality.github.io/druid/modules/Layout.html)** | Logic over GUI Node. Handle node size depends on layout mode and screen aspect ratio. Contains helpers to build more complex UI layout. | [Layout Example](https://insality.github.io/druid/druid/?example=general_layout) | <img src="media/preview/layout.gif" width="200" height="100"> |

For a complete overview, see: **_[components.md](docs_md/01-components.md)_**.


## Druid Events

Any **Druid** components as callbacks use [Druid Events](https://insality.github.io/druid/modules/DruidEvent.html). In component API ([button example](https://insality.github.io/druid/modules/Button.html#on_click)) pointed list of component events. You can manually subscribe to these events with the following API:

- **event:subscribe**(callback)

- **event:unsubscribe**(callback)

- **event:clear**()

You can subscribe several callbacks to a single event.

## Details

- **Druid** processes input in a stack-based manner. The most recently created button will be checked first. Create your input GUI components from back to front.
- Remember to include `return` in the `on_input` function: `return self.druid:on_input()`. This is necessary if you have multiple input sources (multiple Druid instances, other input systems, etc.).
- Druid automatically calls `acquire_input_focus` if you have input components. Therefore, manual calling of `acquire_input_focus` is not required.
- When deleting a **Druid** component node, make sure to remove it using `druid:remove(component)`.


## Examples

Try the [**HTML5 version**](https://insality.github.io/druid/druid/) of the **Druid** example app.

Each example page provides a direct link to the corresponding example code, making it easier for you to understand how to use **Druid**.

Or refer directly to the [**example folder**](https://github.com/Insality/druid/tree/develop/example) for code examples demonstrating how to use **Druid**.


## Documentation

To better understand **Druid**, read the following documentation:
- [How To GUI in Defold](https://forum.defold.com/t/how-to-gui-in-defold/73256)
- [Druid components](docs_md/01-components.md)
- [Create custom components](docs_md/02-creating_custom_components.md)
- [See FAQ article](docs_md/FAQ.md)
- [Druid styles](docs_md/03-styles.md)

You can find the full **Druid** [documentation here](https://insality.github.io/druid/modules/Druid.html).


## Licenses

- Developed and supported by [Insality](https://github.com/Insality)
- Original idea by [AGulev](https://github.com/AGulev)
- Assets from [Kenney](http://www.kenney.nl/)


## Issues and suggestions

If you have any issues, questions or suggestions please [create an issue](https://github.com/Insality/druid/issues) or contact me: [insality@gmail.com](mailto:insality@gmail.com)


## History
For a complete history of the development of **Druid**, please check the [changelog](docs_md/changelog.md).


## ❤️ Support project ❤️

Your donation helps me stay engaged in creating valuable projects for **Defold**. If you appreciate what I'm doing, please consider supporting me!

[![Github-sponsors](https://img.shields.io/badge/sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#EA4AAA)](https://github.com/sponsors/insality) [![Ko-Fi](https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/insality) [![BuyMeACoffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://www.buymeacoffee.com/insality)
