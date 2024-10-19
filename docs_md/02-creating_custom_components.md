# Creating Custom Components

## Overview

Druid offers the flexibility to create custom components that contain your own logic, as well as other Druid basic components or custom components. While Druid provides a set of predefined components like buttons and scrolls, it goes beyond that and provides a way to handle all your GUI elements in a more abstract manner. Custom components are a powerful way to separate logic and create higher levels of abstraction in your code.

Every component is a child of the Basic Druid component. You can call methods of basic components using `self:{method_name}`.

## Custom Components

### Basic Component Template
A basic custom component template looks like this (you can copy it from `/druid/templates/component.template.lua`):

```lua
local component = require("druid.component")

---@class component_name: druid.base_component
local M = component.create("component_name")

function M:init(template, nodes)
    self.druid = self:get_druid(template, nodes)
    self.root = self:get_node("root")

    self.button = self.druid:new_button("button", function() end)
end

function M:hello()
    print("Hello from custom component")
end

return M
```

Then you can create your custom component with Druid:
```lua
local druid = require("druid.druid")

local my_component = require("my.amazing.component")

function init(self)
    self.druid = druid.new(self)

    -- We pass a GUI template "template_name" and skip nodes due it already on the scene
    self.my_component = self.druid:new(my_component, "template_name")
    self.my_component:hello() -- Hello from custom component


end

```

### Full Component Template

A full custom component template looks like this (you can copy it from `/druid/templates/component_full.template.lua`):

```lua
local component =  require("druid.component")

---@class component_name: druid.base_component
local M = component.create("component_name")

function M:init(template, nodes)
    self.druid = self:get_druid(template, nodes)
    self.root = self:get_node("root")
end

function M:update(dt) end

function M:on_input(action_id, action) return false end

function M:on_style_change(style) end

function M:on_message(message_id, message, sender) end

function M:on_language_change() end

function M:on_layout_change() end

function M:on_window_resized() end

function M:on_input_interrupt() end

function M:on_focus_lost() end

function M:on_focus_gained() end

function M:on_remove() end

return M
```

### Spawning a Custom Component

After creating your custom component, you can spawn it in your code. For example, if you have a component named `my_component`, you can create it like this:

```lua
local druid = require("druid.druid")
local my_component = require("my.amazing.component")

function init(self)
    self.druid = druid.new(self)
    self.druid:new(my_component, "template_name")
end
```

In the code above, `template_name` refers to the name of the GUI template file if you're using it in your custom component. `nodes` is a table obtained from `gui.clone_tree(node)`. If you're spawning multiple nodes for the component, pass the table to the component constructor. Inside the component, you need to set the template and nodes using `self:set_template(template)` and `self:set_nodes(nodes)`.

### Registering a Custom Component

You can register your custom component to use it without requiring the component module in every file. Registering components is convenient for very basic components in your game. Here's how you can register a custom component in Druid:

```lua
local druid = require("druid.druid")
local my_component = require("my.amazing.component")

function init(self)
    -- Register makes a "druid:new_{component_name}" function available
    druid.register("my_component", my_component)
end
```

Once the component is registered, a new function will be available with the name "new_{component_name}". In our example, it will be `druid:new_my_component()`. With the component registered, you can create an instance of it using the following code:

```lua
local druid = require("druid.druid")
local my_component = require("my.amazing.component")

function init(self)
    self.druid = druid.new(self)
    self.my_component = self.druid:new_my_component(template, nodes)
end
```

## Create Druid Component Editor Script

Druid provides an editor script to assist you in creating Lua files for your GUI scenes. You can find the commands under the menu `Edit -> Create Druid Component` when working with *.gui scenes.

The script analyzes the current GUI scene and generates a Lua file with stubs for all Druid components found. The output file is named after the current GUI scene and placed in the same directory. Note that the script does not override any existing *.lua files. If you want to regenerate a file, delete the previous version first.

The script requires `python` with `deftree` installed. If `deftree` is not installed, the instructions will be displayed in the console.

### Auto-Layout Components

The generator script also checks the current GUI scene for Druid components and creates stubs for them. If a node name starts with a specific keyword, the script generates component stubs in the Lua file. For example, nodes named `button` and `button_exit` will result in the generation of two Druid Button components with callback stubs.

Available keywords:
- `button`: Adds a [Druid Button](01-components.md#button) component and generates the callback stub.
- `text`: Adds a [Druid Text](01-components.md#text) component.
- `lang_text`: Adds a [Druid Lang Text](01-components.md#lang-text) component.
- `grid` or `static_grid`: Adds a [Druid Static Grid](01-components.md#static-grid) component. You should set up the Grid prefab for this component after generating the file.
- `dynamic_grid`: Adds a [Druid Dynamic Grid](01-components.md#dynamic-grid) component.
- `scroll_view`: Adds a [Druid Scroll](01-components.md#scroll) component. It also adds a `scroll_content` node with the same postfix. Ensure that it's the correct node.
- `blocker`: Adds a [Druid Blocker](01-components.md#blocker) component.
- `slider`: Adds a [Druid Slider](01-components.md#slider) component. You should adjust the end position of the Slider after generating the file.
- `progress`: Adds a [Druid Progress](01-components.md#progress) component.
- `timer`: Adds a [Druid Timer](01-components.md#timer) component.

## The Power of Using Templates

With Druid, you can use a single component but create and customize templates for it. Templates only need to match the component scheme. For example, you can have a component named `player_panel` and two GUI templates named `player_panel` and `enemy_panel` with different layouts. The same component script can be used for both templates.
