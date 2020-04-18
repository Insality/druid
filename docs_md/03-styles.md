# Styles

## Overview
Styles - set of functions and parameters for components to customize their behavior.

Styles is a table, where key is name of component, and value is style table for this component.

In component API documentation, you can find the style API for this component. Or just lookup for existing styles and modify them.

## Usage
Setup default druid style for all druid instances via `druid.set_default_style`
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
