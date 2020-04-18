# Creating custom components

## Overview

Druid allows you to create your custom components from druid basic components or other custom components.

Every component is the children of Basic Druid component. Read the [basic component API here].(https://insality.github.io/druid/modules/component.html), Methods of basic components you can call via self:{method_name}


## Custom components

Basic custom component template looks like this:
```lua
local const = require("druid.const")
local component = require("druid.component")

local M = component.create("my_component")

-- Component constructor
function M.init(self, ...)
end

-- Call only if exist interest: const.ON_UPDATE
function M.update(self, dt)
end

-- Call only if exist interest: const.ON_INPUT or const.ON_INPUT_HIGH
function M.on_input(self, action_id, action)
end

-- Call only if exist interest: const.ON_MESSAGE
function M.on_message(self, message_id, message, sender)
end

-- Call only if component with ON_LANGUAGE_CHANGE interest
function M.on_language_change(self)
end

-- Call only if component with ON_LAYOUT_CHANGE interest
function M.on_layout_change(self)
end

-- Call, if input was capturing before this component
-- Example: scroll is start scrolling, so you need unhover button
function M.on_input_interrupt(self)
end

-- Call, if game lost focus. Need ON_FOCUS_LOST intereset
function M.on_focus_lost(self)
end

-- Call, if game gained focus. Need ON_FOCUS_GAINED intereset
function M.on_focus_gained(self)
end

-- Call on component remove or on druid:final
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

### Interest
Interest - is a way to indicate what events your component will respond to.
There is next interests in druid:
- **ON_MESSAGE** - component will receive messages from on_message

- **ON_UPDATE** - component will be updated from update

- **ON_INPUT_HIGH** - component will receive input from on_input, before other components with ON_INPUT

- **ON_INPUT** - component will receive input from on_input, after other components with ON_INPUT_HIGH

- **ON_LANGUAGE_CHANGE** - will call _on_language_change_ function on language change trigger

- **ON_LAYOUT_CHANGE** will call _on_layout_change_ function on layout change trigger

- **ON_FOCUS_LOST** will call _on_focust_lost_ function in on focus lost event. You need to pass window_callback to global `druid:on_window_callback`

- **ON_FOCUS_GAINED** will call _on_focust_gained_ function in on focus gained event. You need to pass window_callback to global `druid:on_window_callback`

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

	-- helper can return you the component style for current component
	-- It return by component name from 
	local my_style = self:get_style()
end

```


## Power of using templates

You can use one component, but creating and customizing templates for them. Templates only requires to match the component scheme.