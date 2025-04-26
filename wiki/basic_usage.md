# Basic Usage

This guide will help you get started with **Druid** UI framework. We'll cover the basic setup and usage patterns.

## Initial Setup

To use **Druid**, you need to create a **Druid** instance in your GUI script. This instance will handle all component management and core functionality.

Create a new `*.gui_script` file with the following template:

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

function on_message(self, message_id, message, sender)
    self.druid:on_message(message_id, message, sender)
end

function on_input(self, action_id, action)
    return self.druid:on_input(action_id, action)
end
```

Add this script to your GUI scene. Now you can start creating **Druid** components.

> **Note:** When passing nodes to components, you can use node name strings instead of `gui.get_node()` function.

## Basic Components Example

Here's a simple example showing how to create and use basic **Druid** components:

```lua
local druid = require("druid.druid")

-- All component callbacks pass "self" as first argument
-- This "self" is a context data passed in `druid.new(context)`
local function on_button_callback(self)
    self.text:set_text("The button clicked!")
end

function init(self)
    self.druid = druid.new(self)
    -- We can use the node_id instead of gui.get_node():
    self.button = self.druid:new_button("button_node_id", on_button_callback)
    self.text = self.druid:new_text("text_node_id", "Hello, Druid!")
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

## Widgets

Widgets are reusable UI components that encapsulate multiple **Druid** components. Read more in the [Widgets](wiki/widgets.md) documentation.

### Creating a Widget

Create a new Lua file for your widget class. This file better to be placed near the corresponding GUI file with the same name. You can use the Druid's editor script to create a widget by right-clicking on the GUI file in the editor or in "Edit" menu panel, while GUI file is opened.

Define `init` function to initialize the widget.

Here's a basic widget example:

```lua
---@class best_widget_in_the_world: druid.widget
local M = {}

function M:init()
    self.root = self:get_node("root")

    -- Create a button and a text components inside your widget
    self.button = self.druid:new_button("button_node_id", self.on_click)
    self.text = self.druid:new_text("text_node_id", "Hello, Druid!")

    -- They are now accessible by self.button and self.text outside
end

---The "self" will be invoked correctly inside Druid's callbacks
function M:on_click()
    self.text:set_text("The button clicked!")
end


---Add your own functions to the widget
function M:say_hello()
    self.text:set_text("Hello, Druid!")
end


return M
```

### Using Widgets

You can create widgets in your GUI script:

```lua
local druid = require("druid.druid")
local best_widget_in_the_world = require("widgets.best_widget_in_the_world")

function init(self)
    self.druid = druid.new(self)

    local my_widget_template_id_on_gui_scene = "best_widget_in_the_world"
    self.my_widget = self.druid:new_widget(best_widget_in_the_world, my_widget_template_id_on_gui_scene)

    -- Now you can use the widget functions
    self.my_widget:say_hello()
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

## Widget Templates

Widgets can use templates defined in your GUI scene. Templates are collections of nodes that define the widget's structure.

### Using Templates

If you have a GUI template with ID `best_widget_in_the_world` containing `button_node_id` and `text_node_id` nodes, you can use it like this:

```lua
function init(self)
    self.druid = druid.new(self)
    self.my_widget = self.druid:new_widget(best_widget_in_the_world, "best_widget_in_the_world")

    self.my_widget.button.on_click:subscribe(function()
        print("my custom callback")
    end)
    self.my_widget.text:set_text("Hello, Widgets!")
end
```

### Dynamic Templates

For dynamically created GUI templates (from prefabs), you can pass nodes directly to the widget:

```lua
function init(self)
    self.druid = druid.new(self)
    self.prefab = gui.get_node("best_widget_in_the_world/root")
    local nodes = gui.clone_tree(self.prefab)
    self.my_widget = self.druid:new_widget(best_widget_in_the_world, "best_widget_in_the_world", nodes)
end
```

You can also use the root node ID or node directly, it will be cloned and used as a template:

```lua
self.my_widget = self.druid:new_widget(best_widget_in_the_world, "best_widget_in_the_world", "root")
-- or
self.my_widget = self.druid:new_widget(best_widget_in_the_world, "best_widget_in_the_world", self.prefab)
```



