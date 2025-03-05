# Druid Back Handler Component

## Description

The Back Handler component is designed to handle back button actions, including the Android back button and the Backspace key. It provides a simple way to implement back navigation or other actions when the user presses the back button.

## Features

- Handles Android back button and Backspace key presses
- Customizable callback function
- Optional parameters to pass to the callback
- Event-based architecture

## Basic Usage

```lua
local callback = function(self, params)
    -- Handle back action here
    print("Back button pressed!")
end

local params = { custom_data = "value" }
local back_handler = self.druid:new_back_handler(callback, params)
```

### Parameters

- **callback**: (optional) Function to call when back button is pressed
- **params**: (optional) Custom data to pass to the callback

## Events

The Back Handler component provides an event you can subscribe to:

```lua
-- Subscribe to back event
back_handler.on_back:subscribe(function(self, params)
    print("Back button was pressed!")
end)
```

## Notes

- The Back Handler component requires proper key triggers setup in your `input.binding` file for correct operation
- Back Handler is recommended to be placed in every game window to handle closing or in the main screen to call settings windows
- Multiple Back Handlers can be active at the same time, but only the first one that processes the input will trigger its callback
- Back Handler reacts on release action of ACTION_BACK or ACTION_BACKSPACE
