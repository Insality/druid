# Creating custom components

## Overview

Druid allows you to create your custom components which contains your custom logic, other Druid basic components or other custom components.

I wanna make a point that Druid is not only set of defined components to place buttons, scroll, etc. But mostly it's a way how to handle all your GUI elements in general. Custom components is most powerful way to separate logic and make higher abstraction in your code.

Every component is the children of Basic Druid component. Read the [basic component API here](https://insality.github.io/druid/modules/BaseComponent.html), Methods of basic components you can call via `self:{method_name}`


## Custom components

### Basic component template
Basic custom component template looks like this. It's good start to create your own component! (you can copy it from `/druid/templates/component.template.lua`)
```lua
local component = require("druid.component")

---@class component_name : druid.base_component
local Component = component.create("component_name")

local SCHEME = {
    ROOT = "root",
    BUTTON = "button",
}

-- Component constructor. Template name and nodes are optional. Pass it if you use it in your component
function Component:init(template, nodes)
    self:set_template(template)
    self:set_nodes(nodes)
    self.root = self:get_node(SCHEME.ROOT)
    self.druid = self:get_druid()

    self.button = self.druid:new_button(SCHEME.BUTTON, function() end)
end

-- [OPTIONAL] Call on component remove or on druid:final
function Component:on_remove() end

return Component
```

### Full component template

Full custom component template looks like this (you can copy it from `/druid/templates/component_full.template.lua`:
```lua
local component =  require("druid.component")

---@class component_name : druid.base_component
local Component = component.create("component_name")
-- Scheme of component gui nodes
local SCHEME = {
	ROOT =  "root",
	BUTTON =  "button",
}

-- Component constructor. Template name and nodes are optional. Pass it if you use it in your component
function Component:init(template, nodes)
	-- If your component is gui template, pass the template name and set it
	self:set_template(template)
	-- If your component is cloned my gui.clone_tree, pass nodes to component and set it
	self:set_nodes(nodes)

	-- self:get_node will auto process component template and nodes
	self.root =  self:get_node(SCHEME.ROOT)
	-- Use inner druid instance to create components inside this component
	self.druid =  self:get_druid()
end

-- [OPTIONAL] Call every update step
function Component:update(dt) end

-- [OPTIONAL] Call default on_input from gui script
function Component:on_input(action_id, action) return false end

-- [OPTIONAL] Call on component creation and on component:set_style() function
function Component:on_style_change(style) end

-- [OPTIONAL] Call default on_message from gui script
function Component:on_message(message_id, message, sender) end

-- [OPTIONAL] Call if druid has triggered on_language_change
function Component:on_language_change() end

-- [OPTIONAL] Call if game layout has changed and need to restore values in component
function Component:on_layout_change() end

-- [OPTIONAL] Call if game window size is changed
function Component:on_window_resized() end

-- [OPTIONAL] Call, if input was capturing before this component
-- Example: scroll is start scrolling, so you need unhover button
function Component:on_input_interrupt() end

-- [OPTIONAL] Call, if game lost focus
function Component:on_focus_lost() end

-- [OPTIONAL] Call, if game gained focus
function Component:on_focus_gained() end

-- [OPTIONAL] Call on component remove or on druid:final
function Component:on_remove() end

return Component
```


### Spawn custom component

After the creating your custom component, you now able to create it.

For example we made the component `my_component`. Now we able create it like this:
```lua
local druid = require("druid.druid")
local my_component = require("my.amazing.component")

function init(self)
	self.druid = druid.new(self)
	self.druid:new(my_component, "template_name", nodes)
end
```

The template name - is the name of GUI template file if you use it in your custom component.
The nodes - is table from `gui.clone_tree(node)`. If you spawn multiply nodes for component, pass it to component constructor.
Inside component you have to set template and nodes via
`self:set_template(template)` and `self:set_nodes(nodes)`


### Register custom component

You can register your custom component for use it without require component module in every file. Registering components is comfortable for very basic components in your game.

Add your custom component to druid via `druid.register

```lua
local druid = require("druid.druid")
local my_component = require("my.amazing.component")

function init(self)
	druid.register("my_component", my_component)
end
```

Registering make new function with "new_{component_name}". In our example it will be: `druid:new_my_component()`.

As component registered, you can create your component with next code:
```lua
local druid = require("druid.druid")
local my_component = require("my.amazing.component")

function init(self)
	self.druid = druid.new(self)
	self.my_component = self.druid:new_my_component(template, nodes)
end
```


## Create Druid Component editor script

The Druid has editor script to help you with creating lua file for your GUI scene.
The commands is available on *.gui scenes in menu `Edit -> Create Druid Component`

The script will check current GUI scene and generate lua file with all Druid component stubs. The output file will be named as current GUI scene and placed nearby. The *.lua file should be not exists, the script will not override any file. If you want to re-generate file, delete previous one first.

The script required `python3` with `deftree` installed. If `deftree` is not installed the instructions will be prompt in console.


### Auto layout components

The generator script also check current GUI scene for Druid components to make stubs for them. The script will check the node names and if it starts with special keyword it will make component stubs in generated lua file. It will generate component declaring, callback functions stubs and annotations.

Start your node names with one of next keyword to say parser make component stubs for your. For example for nodes `button` and `button_exit` will be generated two Druid Button components with callback stubs.

Available keywords:
- `button` - add [Druid Button](01-components.md#button) and generate callback stub
- `text` - add [Druid Text](01-components.md#text)
- `lang_text` - add Druid [Druid Lang Text](01-components.md#lang-text)
- `grid` or `static_grid` - add Druid [Druid Static Grid](01-components.md#static-grid). You should to setup Grid prefab for this component after file generation
- `dynamic_grid` - add Druid [Druid Dynamic Grid](01-components.md#dynamic-grid)
- `scroll_view` - add [Druid Scroll](01-components.md#scroll). It will add `scroll_content` node with the same postfix too. Check that is will correct node
- `blocker` - add [Druid Blocker](01-components.md#blocker)
- `slider` - add [Druid Slider](01-components.md#slider). You should to adjust end position of Slider after file generation
- `progress` - add [Druid Progress](01-components.md#progress)
- `timer` - add [Druid Timer](01-components.md#timer)



## Best practice on custom components

On each component recommended describe component scheme in next way:
To get this structure, Druid has editor script to help you with it. Select your GUI nodes in editor outline, right click and press "Print GUI Scheme". And copy the result from the output console.

```lua
-- Component module
local component = require("druid.component")

local M = component.create("your_component")

local SCHEME = {
	ROOT = "root",
	ITEM = "item",
	TITLE = "title"
}

function M.init(self, template_name, node_table)
	self:set_template(template_name)
	self:set_nodes(node_table)

	-- helper can get node from gui/template/table
	local root = self:get_node(SCHEME.ROOT)
	-- This component can spawn another druid components:
	local druid = self:get_druid()
	-- Button self on callback is self of _this_ component
	local button = druid:new_button(...)
end

```

## Power of using templates

You can use one component, but creating and customizing templates for them. Templates only requires to match the component scheme.

For example you have component `player_panel` and two GUI templates: `player_panel` and `enemy_panel` with different layout. But the same component script can be used for both of them.
