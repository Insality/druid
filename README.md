[![](media/druid_logo.png)](https://insality.github.io/druid/)

**Druid** - powerful defold component UI library. Use basic druid components or make your own game-specific components to make amazing GUI in your games.


## Setup

### Dependency

You can use the druid extension in your own project by adding this project as a  [Defold library dependency](https://www.defold.com/manuals/libraries/). Open your game.project file and in the dependencies field under project add:

> [https://github.com/Insality/druid/archive/master.zip](https://github.com/Insality/druid/archive/master.zip)

Or point to the ZIP file of a  [specific release](https://github.com/Insality/druid/releases).


### Code

Adjust druid settings, if needed:
```lua
local druid = require("druid.druid")

-- Used for button component and custom components
druid.set_sound_function(callback)

-- Used for lang_text component
druid.set_text_function(callback)

-- Used for change default druid style
druid.set_default_style(your_style)
```


## Components

Druid provides next basic components:
- **Button** - Basic game button

- **Text** - Wrap on text node with text size adjusting

- **Blocker** - Block input in node zone

- **Back Handler** - Handle back button (Android, backspace)

- **Lang text** - Text component with handle localization system

- **Timer** - Run timer on text node

- **Progress** - Basic progress bar

- **Scroll** - Basic scroll component

- **Grid** - Component for manage node positions

- **Slider** - Basic slider component

- **Checkbox** - Basic checkbox component

- **Checkbox group** - Several checkboxes in one group

- **Radio group** - Several checkboxes in one group with single choice

- **Hover** - Trigger component for check node hover state

- **Input** - Component to process user text input

Full info see on _components.md_


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
	self.druid:on_input(action_id, action)
end
```


## Examples

See the [example folder](https://github.com/insality/druid/tree/develop/example/kenney) for examples of how to use Druid

See the [druid-assets repository](https://github.com/insality/druid-assets) for examples of how to create custom components and styles

Try the [HTML5 version](https://insality.github.io/druid/druid/) of the example app


## Documentation

To learn druid better, read next documentation:
- Druid components
- Create custom components
- Druid asset store
- Druid Styles

Full druid documentation you can find here:
https://insality.github.io/druid/


## Games powered by Druid

_Will fill later_


## Future plans

- Basic input component

- Add on_layout_change support (to keep gui data between layout change)

- Add on_change_language support (call single function to update all druid instance)

- Better documentation and examples

- Add more comfortable gamepad support for GUI (ability to select button with DPAD and other stuff)


## License

Original created by [AGulev](https://github.com/AGulev)

Developed and supporting by [Insality](https://github.com/Insality)

MIT License


## Issues and suggestions

If you have any issues, questions or suggestions please  [create an issue](https://github.com/Insality/druid/issues)  or contact me:  [insality@gmail.com](mailto:insality@gmail.com)
