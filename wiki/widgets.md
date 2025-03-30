# Widgets

Widgets are reusable UI components that simplify the creation and management of user interfaces in your game.

## What is widget

Before widgets, there were "custom components". Widgets replace custom components. Basically, they're the same thing, with the only difference being how they're initialized.

Let's see a basic custom component template:

```lua
local component = require("druid.component")

---@class my_component: druid.component
local M = component.create("my_component")

function M:init(template, nodes, output_string)
    self:set_template(template)
    self:set_nodes(nodes)
    self.druid = self:get_druid()

    self.druid:new_button("button_node_name", print, output_string)
end
```

Basic components are created with the `druid:new()` function:

```lua
local template = "my_component" -- The template name on GUI scene, if nil will take nodes directly by gui.get_node()
local nodes = gui.clone_tree(gui.get_node("my_component/root")) -- We can clone component nodes and init over cloned nodes

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

That's all! The same functionality but without any boilerplate code, just a Lua table. The Druid instance, templates and nodes are already created and available.

And you can create your own widgets like this:

```lua
local druid = require("druid.druid")
local my_widget = require("widgets.my_widget.my_widget")

function init(self)
    self.druid = druid.new(self)
    self.my_widget = self.druid:new_widget(my_widget, template, nodes, "Hello world!")
end
```

So now creating UI components with widgets is much easier and cleaner than using custom components.

## Create a new widget

Let's start from the beginning. Widgets usually consist of 2 parts:

1. GUI scene
2. Widget Lua module

Make a GUI scene of your widget (user portrait avatar panel, shop window, game panel menu, etc). Design it as you wish, but it's recommended to add one `root` node with the id `root` and make all your other nodes children of this node. This makes working with the widget much easier. Also ofter this root will represent the widget size, so it's recommended to set it's size to the desired size of the widget.

Let's create a new widget by creating a new file next to our GUI scene file:

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

That's the basic creation process. Now we have a widget where we access the root node and use the "button_open" node as a button.

Now, let's create a widget inside your game scene.

Place a widget (GUI template) on your main scene. Then import Druid and create a new widget instance using this GUI template placed on the scene:

```lua
local druid = require("druid.druid")
local my_widget = require("widgets.my_widget.my_widget")

function init(self)
    self.druid = druid.new(self)
    self.my_widget = self.druid:new_widget(my_widget, "my_widget")

    -- In case we want to clone it and use several times we can pass the nodes table
    local array_of_widgets = {}
    for index = 1, 10 do
        -- For widgets now we can use a root node directly instead of manually cloning the nodes
        local widget = self.druid:new_widget(my_widget, "my_widget", "my_widget/root")
        table.insert(array_of_widgets, widget)
    end
end
```
