# Druid Text Component

## Description

Text component is a basic component that provides various adjustment modes for text nodes. It allows text to be scaled down to fit within the size of the text node, trimmed, scrolled, or a combination of these adjustments. The component makes it easy to handle text display in different scenarios.

## Features

- Automatic text size adjustment
- Multiple text adjustment modes (downscale, trim, scroll, etc.)
- Text pivot control
- Text color and alpha management
- Text size and scale control
- Text metrics calculation
- Event-based architecture for text changes

## Basic Usage

```lua
local text = self.druid:new_text(node, [initial_value], [adjust_type])
```

### Parameters

- **node**: The node or node_id of the text node
- **initial_value**: (optional) Initial text value. Default is the text from the GUI node
- **adjust_type**: (optional) Adjustment type for text. Default is "DOWNSCALE". See adjustment types below

### Example

```lua
-- Simple text component
local text = self.druid:new_text("text_node")

-- Text with initial value
local text = self.druid:new_text("text_node", "Hello, World!")

-- Text with specific adjustment type
local text = self.druid:new_text("text_node", "Hello, World!", const.TEXT_ADJUST.TRIM)
```

## Text Adjustment Types

The Text component supports several adjustment types to handle different text display scenarios:

- **DOWNSCALE**: Scales down the text to fit within the text node's size
- **NO_ADJUST**: No adjustment, text displays as is
- **TRIM**: Trims the text with an ellipsis (...) if it doesn't fit
- **TRIM_LEFT**: Trims the text from the left with an ellipsis if it doesn't fit
- **DOWNSCALE_LIMITED**: Scales down the text but not below a minimum scale
- **SCROLL**: Shifts the text anchor when it doesn't fit
- **SCALE_THEN_SCROLL**: First scales down the text, then scrolls if needed
- **SCALE_THEN_TRIM**: First scales down the text, then trims if needed
- **SCALE_THEN_TRIM_LEFT**: First scales down the text, then trims from the left if needed

### Example

```lua
-- Import constants
local const = require("druid.const")

-- Create text with TRIM adjustment
local text = self.druid:new_text("text_node", "Long text that might not fit", const.TEXT_ADJUST.TRIM)

-- Change adjustment type later
text:set_text_adjust(const.TEXT_ADJUST.SCALE_THEN_TRIM)
```

## Events

The Text component provides several events you can subscribe to:

- **on_set_text**: Triggered when text is set or changed
- **on_update_text_scale**: Triggered when text scale is updated
- **on_set_pivot**: Triggered when text pivot is changed

### Example

```lua
-- Subscribe to text change event
text.on_set_text:subscribe(function(self, text_value)
    print("Text changed to: " .. text_value)
end)

-- Subscribe to scale update event
text.on_update_text_scale:subscribe(function(self, scale, metrics)
    print("Text scale updated to: " .. scale.x)
end)
```

## Methods

```lua
-- Set text content
text:set_text("New text content")

-- Get current text content
local current_text = text:get_text()

-- Set text area size
text:set_size(vmath.vector3(200, 100, 0))

-- Set text color
text:set_color(vmath.vector4(1, 0, 0, 1))  -- Red color

-- Set text alpha
text:set_alpha(0.5)  -- 50% opacity

-- Set text scale
text:set_scale(vmath.vector3(1.5, 1.5, 1))  -- 150% scale

-- Set text pivot
text:set_pivot(gui.PIVOT_CENTER)

-- Check if text is multiline
local is_multiline = text:is_multiline()

-- Set text adjustment type
text:set_text_adjust(const.TEXT_ADJUST.TRIM)

-- Set minimal scale for limited adjustment types
text:set_minimal_scale(0.5)  -- 50% minimum scale

-- Get current text adjustment type
local adjust_type = text:get_text_adjust()

-- Get text size (width and height)
local width, height = text:get_text_size()

-- Get text index by width (useful for cursor positioning)
local char_index = text:get_text_index_by_width(100)
```

## Notes

- Text component by default has auto-adjust text sizing. Text will never be bigger than the text node size, which you can set up in the GUI scene.
- Auto-adjustment can be disabled by setting the adjustment type to `NO_ADJUST`.
- Text pivot can be changed with `text:set_pivot()`, and the text will maintain its position inside the text size box.
- For multiline text, the component will try to fit the text within both width and height constraints.
- The trim postfix (default: "...") can be customized in the style settings.
- When using `DOWNSCALE_LIMITED` or `SCALE_THEN_SCROLL`, you can set a minimal scale to prevent text from becoming too small.
