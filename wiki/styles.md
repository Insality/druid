# Styles

## Overview

Styles - set of functions and parameters for components to customize their behavior.

Styles is a table, where key is name of component, and value is style table for this component.

In component API documentation, you can find the style API for this component. Or just lookup for existing styles and modify them.

## Usage

Setup default druid style for all druid instances via `druid.set_default_style`
You can pass _nil_ or _empty_table_ to use default values for all components (no styles)

```lua
local druid = require("druid.druid")
local my_style = require("my.amazing.style")

function init(self)
    druid.set_default_style(my_style)
end
```

Setup custom style to specific druid instance:

```lua
local druid = require("druid.druid")
local my_style = require("my.amazing.style")

function init(self)
    -- This druid instance will be use my_style as default
    self.druid = druid.new(self, my_style)
end
```

Change component style with _set_style_ function

```lua
local druid = require("druid.druid")
local my_style = require("my.amazing.style")

function init(self)
	self.druid = druid.new(self)
	self.button = self.druid:new_button("node", function() end)
	-- Setup custom style for specific component
	self.button:set_style(my_style)
end
```

## Adjust styles in place

You can adjust styles params right after the component creation.

```lua
local druid = require("druid.druid")

function init(self)
	self.druid = druid.new(self)
	self.grid = self.druid:new_grid("node", "prefab", 1)
	self.grid.style.IS_ALIGN_LAST_ROW = true

	self.drag = self.druid:new_drag("node")
	self.drag.style.DRAG_DEADZONE = 0
end
```


## Create your own styles

Most components have styles. See style fields in each component’s `@class druid.*.style` annotations, the [Quick API Reference](../api/quick_api_reference.md), or [button API](../api/components/base/button_api.md). You can also inspect what fields a component uses in its `on_style_change` function.

To create your style, create a lua module that returns a `<component_name, component_style>` table.

Example: [default druid style](https://github.com/Insality/druid/blob/master/druid/styles/default/style.lua)

Override all fields you want and set your style with one of next ways:

- Set your style as global via `druid.set_default_style`
- Set style for concrete druid instance via `druid = druid.new(self, style)`
- Set style for concrete instance via `component:set_style(style)`
