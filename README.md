[![](media/druid_logo.png)](https://AGulev.github.io/druid/)
_travis/release bages_

**Druid** - powerful defold component UI library. Use standart components or make your own game-specific to make amazing GUI in your games.

## Setup
#### Dependency
You can use the druid extension in your own project by adding this project as a  [Defold library dependency](https://www.defold.com/manuals/libraries/). Open your game.project file and in the dependencies field under project add:

> [https://github.com/AGulev/druid/archive/master.zip](https://github.com/AGulev/druid/archive/master.zip)

Or point to the ZIP file of a  [specific release](https://github.com/AGulev/druid/releases).


#### Code
Adjust druid settings:
```lua
local druid = require("druid.druid")

--- Function should return localized string by lang_id
druid.set_text_function(function(lang_id)
	...
end)

-- Function should play sound by name
druid.set_sound_function(function(name)
	...
end)
```

## Usage

## Components
Druid provides next basic components:
_insert simple gif of each?_
_separate .md for each base component?_
- **Button** - basic game button
- **Text** - wrap on gui text node
- **Blocker** - block input in node zone
- **Back** Handler - handle back button (Android, backspace)
- **Locale** - localized text node
- **Timer** - run timer on defined time
- **Progress** - simple progress bar
- **Scroll** - general scroll component
- **Grid** - manage node positions
- **Slider** - simple slider (ex. volume adjust)
- **Checkbox** - simple checkbox
- **Checkbox group** - many checkbox
- **Radio group** - many checkbox with single choice

## Styles
You can setup default style for all druid module, for druid instance or any base druid component.
Setup default druid style via `druid.set_default_style`
```lua
local druid = require("druid.druid")
local my_style = require("my.amazing.style")

local function init(self)
	druid.set_default_style(my_style)
end
```
_TODO_

## Creating components
Any components creating via druid:
```lua
local druid = require("druid.druid")

local function init(self)
	self.druid = druid.new(self)
	local button = self.druid:new_button(node_name, callback)
	local text = self.druid:new_text(node_text_name)
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

## Custom components

Add your custom components via `druid.register`
```lua
local druid = require("druid.druid")
local my_component = require("my.amazing.component")

local function init(self)
	druid.register("my_component", my_component)
end
```

Basic custom component template looks like this:
```lua
local const = require("druid.const")
local component = require("druid.component")

local M = component.create("amazing_component", { const.ON_INPUT })

function M.init(self, ...)
	-- Component constructor
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

-- Call if input was interrupt by previous components (ex. scroll)
function M.on_input_interrupt(self)

end

return M
```

## Best practice on custom components
On each component recomended describe component schema in next way:

```lua
-- Component module
local helper = require("druid.helper")
local component = require("druid.component")

local M = component.create("new_component")

local SCHEME = {
	ROOT = "/root",
	ITEM = "/item",
	TITLE = "/title"
}

function M.init(self, template_name, node_table)
	-- If component use template, setup it:
	self:set_template(template_name)

	-- If component was cloned with gui.clone_tree, pass his nodes
	self:set_nodes(node_table)

	-- Component can get node from gui/template/table
	local root = self:get_node(self, SCHEME.ROOT)

	-- This component can spawn another druid components:
	local druid = self:get_druid(self)
	-- Button self on callback is self of _this_ component
	local button = druid:new_button(...)

	-- helper can return you the component style
	local my_style = self:get_style()
end

```

## Example
You can check our example here
_TODO_

## Reserver componeney keywords
- initialize
- init
- update
- on_input
- on_message
- on_input_interrupt
- setup_component
- get_style
- set_style
- set_template
- set_nodes
- get_context
- set_context
- get_druid

## API
_Link to ldoc_
[API](https://AGulev.github.io/druid/)

## Internal
Generate with `ldoc .` with `config.ld` file. [Instructions](https://github.com/stevedonovan/LDoc)

## Games powered by Druid:
_TODO_


## License
Using [middleclass by kikito](https://github.com/kikito/middleclass)
MIT License


## Issues and suggestions
If you have any issues, questions or suggestions please  [create an issue](https://github.com/AGulev/druid/issues) or contact me: [insality@gmail.com](mailto:insality@gmail.com)
