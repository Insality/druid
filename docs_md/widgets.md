# Widgets

What are widgets

## What is widget
Before widget, there are a "custom components". Widgets goes to replace custom components. Basically, it's totally the same thing, only the difference to initialize it.

Let's see at basic custom component template:
```lua
local component = require("druid.component")

local M = component.create("my_component")

function M:init(template, nodes, output_string)
	self:set_template(template)
	self:set_nodes(nodes)
	self.druid = self:get_druid()

	self.druid:new_button("button_node_name", print, output_string)
end
```

So the basic components we created with `druid:new()` function.

```lua
local my_component = druid:new("my_component", template, nodes, "Hello world!")
```

Now, let's see how to do it with widgets:
```lua
---@type my_widget: druid.widget
local M = {}

function M:init(output_string)
	self.druid:new_button("button_node_name", print, output_string)
end

return M
```

That's all! The same thing, but no any boilerplate code, just a lua table. The druid instance, the templates and nodes are already created.

And you can create your own widgets like this:
```lua
local druid = require("druid.druid")
local my_widget = require("widgets.my_widget.my_widget")

function init(self)
	self.druid = druid.new(self)
	self.my_widget = self.druid:new_widget(my_widget, template, nodes, "Hello world!")
end
```

So now the creation of "custom components" called as widgets is much easier and cleaner.


## Create a new widget

Let's start from beginning. Widgets usually consist from 2 parts:
1. GUI scene
2. Widget lua module

Make a GUI scene of your widget (user portrait avatar panel, shop window, game panel menu, etc). Make it as you wish, but recomment to add a one `root` node with `name` `root` and make all your nodes as children of this node. This will make much easier to work with the widget.

Let's create a new widget by creating a new file nearby the our GUI scene file.

```lua
-- my_widget.lua
local M = {}

function M:init()
	self.root = self:get_node("root")
	self.button = self.druid:new_button("button_open", self.open_widget, self)
end

function M:open_widget()
	print("Open widget pressed")
end

return M
```

that's a basic about creation. Now we have a widget, where we ask for the root node and use node "button_open" as a button.

Now, let's create a widget inside you game scene.

Place a widget (GUI template) on your main scene. Then you need to import druid and create a new widget instance over this GUI template placed on the scene.

```lua
local druid = require("druid.druid")
local my_widget = require("widgets.my_widget.my_widget")

function init(self)
	self.druid = druid.new(self)
	self.my_widget = self.druid:new_widget(my_widget, "my_widget")

	-- In case we want to clone it and use several times we can pass the nodes table
	local array_of_widgets = {}
	for index = 1, 10 do
		local nodes = gui.clone_tree(self.my_widget.root)
		local widget = self.druid:new_widget(my_widget, "my_widget", nodes)
		table.insert(array_of_widgets, widget)
	end
end
```






