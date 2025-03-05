# Druid Hover Component

## Description

The Hover component handles hover interactions with nodes, providing callbacks for both touch hover and mouse hover states. It's useful for creating interactive UI elements that respond to user hover actions.

## Features

- Handles touch hover (with pressed action)
- Handles mouse hover (without pressing)
- Provides hover state tracking
- Customizable cursor styles (with defos)
- Optional click zone restriction

## Basic Usage

```lua
-- Basic hover with touch hover callback
local hover = self.druid:new_hover("node", function(self, is_hover)
    -- Handle hover state change
    local color = is_hover and vmath.vector4(1, 0.8, 0.8, 1) or vmath.vector4(1, 1, 1, 1)
    gui.animate(hover.node, "color", color, gui.EASING_LINEAR, 0.2)
end)

-- Hover with both touch and mouse hover callbacks
local hover = self.druid:new_hover("node", 
    function(self, is_hover)
        -- Handle touch hover
    end,
    function(self, is_hover)
        -- Handle mouse hover
    end
)
```

### Parameters

- **node**: The node or node_id of the hover node
- **on_hover_callback**: (optional) Function to call on touch hover state change
- **on_mouse_hover_callback**: (optional) Function to call on mouse hover state change

## Events

The Hover component provides two events you can subscribe to:

```lua
-- Subscribe to touch hover event
hover.on_hover:subscribe(function(self, is_hover)
    print("Touch hover state: " .. tostring(is_hover))
end)

-- Subscribe to mouse hover event
hover.on_mouse_hover:subscribe(function(self, is_hover)
    print("Mouse hover state: " .. tostring(is_hover))
end)
```

## Methods

```lua
-- Set hover state manually
hover:set_hover(true)
hover:set_hover(false)

-- Set mouse hover state manually
hover:set_mouse_hover(true)
hover:set_mouse_hover(false)

-- Check current hover states
local is_hovered = hover:is_hovered()
local is_mouse_hovered = hover:is_mouse_hovered()

-- Set a click zone to restrict hover area
hover:set_click_zone("stencil_node")
```

## Notes

- By default, hover handles the "hover event" with pressed touch action_id, meaning the mouse or touch has to be pressed
- On desktop platforms, there is an "on_mouse_hover" event that triggers on mouse hover without any action id
- By default, the component assumes the node is in a non-hovered state (both hover and mouse_hover)
- The hover component automatically detects the closest stencil node and sets it as the click zone if none is specified
- You can customize cursor styles for hover states if you're using the defos extension
- Hover state is automatically reset when input is interrupted or the node is disabled
