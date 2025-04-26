# Creating Custom Components

# Deprecated
Custom compomnents from 1.1 release are deprecated. Now we have a new way to create custom components - widgets.

Custom components are will exists for more system things like basic components. You don't have to migrate to widgets.

The editor script for creating custom components is removed. Now you can create widgets with the new editor script.

Read more about widgets in [widgets.md](widgets.md)

## Overview

Druid offers the flexibility to create custom components that contain your own logic, as well as other Druid basic components or custom components. While Druid provides a set of predefined components like buttons and scrolls, it goes beyond that and provides a way to handle all your GUI elements in a more abstract manner. Custom components are a powerful way to separate logic and create higher levels of abstraction in your code.

Every component is a child of the Basic Druid component. You can call methods of basic components using `self:{method_name}`.

## Custom Components

### Basic Component Template

A basic custom component template looks like this (you can copy it from `/druid/templates/component.lua.template`):

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

A full custom component template looks like this (you can copy it from `/druid/templates/component_full.lua.template`):

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

## The Power of Using Templates

With Druid, you can use a single component but create and customize templates for it. Templates only need to match the component scheme. For example, you can have a component named `player_panel` and two GUI templates named `player_panel` and `enemy_panel` with different layouts. The same component script can be used for both templates.
