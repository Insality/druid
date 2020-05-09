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

local function init(self)
	druid.set_default_style(my_style)
end
```

Setup custom style to specific druid instance:
```lua
local druid = require("druid.druid")
local my_style = require("my.amazing.style")

local function init(self)
	-- This druid instance will be use my_style as default
	self.druid = druid.new(self, my_style)
end
```

Change component style with _set_style_ function
```lua
local druid = require("druid.druid")
local my_style = require("my.amazing.style")

local function init(self)
	self.druid = druid.new(self)
	self.button = self.druid:new_button(self, "node")
	-- Setup custom style for specific component
	self.button:set_style(my_style)
end
```


## Create your own styles

The most components have their styles. You can explore it on [Druid API](https://insality.github.io/druid/) in table style section ([button example](https://insality.github.io/druid/modules/druid.button.html#Style)). Or you can see, what fields component uses in code in function `on_style_change`

To create you style, create lua module, what return <_component_name_, _component_style_> table

Example: [default druid style](https://github.com/Insality/druid/blob/develop/druid/styles/default/style.lua)

Override all fields you want and set your style with one of next ways:

- Set your style as global via `druid.set_default_style`
- Set style for concrete druid instance via `druid = druid.new(self, style)`
- Set style for concrete instance via `component:set_style(style)`