# Creating custom components

## Overview

Druid allows you to create your custom components from druid basic components or other custom components.

Every component is the children of Basic Druid component. Read the [basic component API here].(https://insality.github.io/druid/modules/component.html), Methods of basic components you can call via self:{method_name}


## Custom components

Basic custom component template looks like this:
```lua
local component = require("druid.component")

local M = component.create("my_component")

-- Component constructor
function M.init(self, ...)
end

-- [OPTIONAL] If declared, will call this on script.update function
function M.update(self, dt)
end

-- [OPTIONAL] If declared, will call this on script.on_input function
function M.on_input(self, action_id, action)
end

-- [OPTIONAL] If declared, will call on component creation and on component:set_style() function
function M.on_style_change(self, style)
end

-- [OPTIONAL] If declared, will call this on script.on_message function
function M.on_message(self, message_id, message, sender)
end

-- [OPTIONAL] If declared, will call this on druid.on_language_change call
function M.on_language_change(self)
end

-- [OPTIONAL] If declared, will call this on const.ON_MESSAGE_INPUT message to Druid script instance
function M.on_message_input(self, node_id, message)
end

-- [OPTIONAL] If declared, will call this on layout changing
function M.on_layout_change(self)
end

-- [OPTIONAL] If declared, will call this on layout changing, if input was capturing before this component
-- Example: scroll is start scrolling, so you need unhover button
function M.on_input_interrupt(self)
end

-- [OPTIONAL] If declared, will call this if game lost focus
function M.on_focus_lost(self)
end

-- [OPTIONAL] If declared, will call this if game gained focus
function M.on_focus_gained(self)
end


-- [OPTIONAL] If declared, will call this if late init step (first frame on update)
function M.on_late_init(self)
end

-- [OPTIONAL] If declared, will call this on component remove from Druid instance
function M.on_remove(self)
end

return M
```


Add your custom component to druid via `druid.register`
```lua
local druid = require("druid.druid")
local my_component = require("my.amazing.component")

function init(self)
	druid.register("my_component", my_component)
end
```

Registering make new function with "new_{component_name}". In our example it will be: `druid:new_my_component()`.

Or you can create component without registering with `druid:create(my_component_module)`

As component registered, you can create your component with next code:
```lua
local druid = require("druid.druid")
local my_component = require("my.amazing.component")

function init(self)
	self.druid = druid.new(self)

	local my_component = self.druid:new_my_component(...)
	-- or --
	local my_component = self.druid:create(my_component, ...)
end
```

## Best practice on custom components
On each component recommended describe component scheme in next way:

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
	-- If component use template, setup it:
	self:set_template(template_name)

	-- If component was cloned with gui.clone_tree, pass his nodes
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
