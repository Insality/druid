# Druid Button Component

## Description

Button component is a basic component that can be used to create a clickable button. It provides various interaction callbacks such as click, long click, double click, and more. The component makes any GUI node clickable and allows you to define different behaviors for various user interactions.

## Features

- Regular click handling
- Long click detection
- Double click detection
- Repeated click handling (while holding)
- Hold state callbacks
- Click outside detection
- Keyboard key triggering
- Custom animation node support
- Enabled/disabled states
- Customizable click zones
- HTML5 interaction support

## Basic Usage

```lua
local button = self.druid:new_button(node, [callback], [params], [anim_node])
```

### Parameters

- **node**: The node or node_id to make clickable
- **callback**: (optional) Function to call when button is clicked
- **params**: (optional) Custom arguments to pass to the callback
- **anim_node**: (optional) Node to animate instead of the trigger node

### Example

```lua
-- Simple button with callback
local button = self.druid:new_button("button_node", function(self, params, button_instance)
    print("Button clicked!")
end)

-- Button with custom parameters
local custom_args = "Any data to pass to callback"
local button = self.druid:new_button("button_node", on_button_click, custom_args)

-- Button with separate animation node
local button = self.druid:new_button("big_panel", callback, nil, "small_icon")
```

## HTML5 Interaction

The Button component supports HTML5 interaction mode, which allows you to define different behaviors for various user interactions. Use this mode when you need to use special interactions like copy/paste, keyboard, etc.

```lua
button:set_web_user_interaction(true)
```

## Events

The Button component provides several events you can subscribe to:

- **on_click**: Triggered when button is clicked
- **on_pressed**: Triggered when button is pressed down
- **on_repeated_click**: Triggered repeatedly while holding the button
- **on_long_click**: Triggered when button is held for a certain time
- **on_double_click**: Triggered when button is clicked twice in quick succession
- **on_hold_callback**: Triggered while holding the button, before long_click
- **on_click_outside**: Triggered when click is released outside the button

### Example

```lua
-- Subscribe to double click event
button.on_double_click:subscribe(function(self, params, button_instance, click_amount)
    print("Double clicked! Click amount: " .. click_amount)
end)

-- Subscribe to long click event
button.on_long_click:subscribe(function(self, params, button_instance, hold_time)
    print("Long press detected! Hold time: " .. hold_time)
end)
```

## Notes

- The click callback will not trigger if the cursor moves outside the node's area between pressed and released states
- If a button has a double click event and it is triggered, the regular click callback will not be invoked
- If you have a stencil on buttons and don't want to trigger them outside the stencil node, use `button:set_click_zone`
- Animation node can be used to animate a small icon on a big panel (trigger zone is the big panel, animation node is the small icon)
