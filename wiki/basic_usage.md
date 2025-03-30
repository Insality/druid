# Basic Usage

To use **Druid**, begin by creating a **Druid** instance to instantiate components and include the main functions of **Druid**: *update*, *final*, *on_message*, and *on_input*.

Create a new `*.gui_script` file and add the following code. It's a basic required template for **Druid** to work in your GUI scripts.

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

Now add this `*.gui_script` as a script to your GUI scene and now you can start creating **Druid** components.

Always, when you need to pass a node to a component, you can pass a node name string instead of `gui.get_node()` function.

All functions of **Druid** are invoked using the `:` operator, such as `self.druid:new_button()`.

Here is a basic example with a button and a text components created with **Druid**:

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


### Widgets

Read more in the [Widgets](wiki/widgets.md)

Create a new lua file to create a new widget class. This widget can be created with `self.druid:new_widget(widget_class, [template], [nodes])`

Usually this widget lua file is placed nearby with the `GUI` file it belong to and have the same name.

Here is a basic example of a widget class, which is the similar that we did in the previous example:
```lua
---@class your_widget_class: druid.widget
local M = {}

function M:init()
    self.root = self:get_node("root")
    self.button = self.druid:new_button("button_node_id", self.on_click)
	self.text = self.druid:new_text("text_node_id", "Hello, Druid!")
end

function M:on_click()
	self.text:set_text("The button clicked!")
end

return M
```

Now we have a widget class that we can use in our GUI script instead basic components. It's often used to create a reusable component that can be used in different parts of the GUI.

```lua
local druid = require("druid.druid")

function init(self)
    self.druid = druid.new(self)
	-- This one is created the button and text inside, taking the same nodes as in the previous example
    self.my_widget = self.druid:new_widget(your_widget_class)
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

## Widget Template

When you create a widget, you can pass a template to it. This template is a table that contains the nodes that will be used to create the widget.

Usually it's a main workflow. You create a widget lua file near the `GUI` file and pass the template to the widget.

So on your GUI scene, if we add the GUI template with template id `my_widget_example` with `button_node_id` and `text_node_id` nodes, we can use it in our script like this:

```lua
...
function init(self)
	self.druid = druid.new(self)
	-- It will take nodes from the template and use it to create the components
	self.my_widget = self.druid:new_widget(your_widget_class, "my_widget_example")

	-- You also now have access to the nodes from the template
	self.my_widget.button.on_click:subscribe(function()
		print("my custom callback")
	end)
	self.my_widget.text:set_text("Hello, Widgets!")
end
...
```

## Widgets Nodes

If your GUI templates are created dynamically, from the "prefab" you can pass the nodes to the widget.

```lua
...
function init(self)
	self.druid = druid.new(self)
	-- The root is a top level node in the template, we use it to clone the whole template
	self.prefab = gui.get_node("my_widget_prefab/root")
	local nodes = gui.clone_tree(self.prefab)
	self.my_widget = self.druid:new_widget(your_widget_class, "my_widget_example", nodes)

	-- Now my_widget created from a copy of template
end
...

```

You can use the root node id of prefab or the node itself instead of manually cloning the tree. It will do the same thing under the hood.

```lua
...
-- This options the same:
self.my_widget = self.druid:new_widget(your_widget_class, "my_widget_example", "my_widget_prefab/root")
-- or
self.my_widget = self.druid:new_widget(your_widget_class, "my_widget_example", self.prefab)
...
```



