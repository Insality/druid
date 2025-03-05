# Druid Slider Component

## Description

The Slider component provides an interactive way for users to select a value from a range by dragging a handle along a track. It's commonly used for settings like volume control, brightness adjustment, or any scenario where users need to select a value within a continuous range.

## Features

- Interactive value selection through dragging
- Customizable value range
- Support for horizontal and vertical orientations
- Smooth handle movement with animations
- Events for value changes and interactions
- Optional steps for discrete value selection
- Visual feedback through progress component integration

## Basic Usage

```lua
-- Basic horizontal slider
local slider = self.druid:new_slider("slider_node", "pin_node", vmath.vector3(1, 0, 0))

-- Set initial value (0 to 1)
slider:set_value(0.5) -- 50% of the slider range
```

### Parameters

- **node**: The node or node_id of the slider background/track
- **pin_node**: The node or node_id of the draggable handle/pin
- **axis**: The axis vector for the slider direction (e.g., vmath.vector3(1, 0, 0) for horizontal)

## Methods

```lua
-- Set slider value (0 to 1)
slider:set_value(0.75) -- 75% of the slider range

-- Set slider value with animation
slider:set_to(0.75, 0.5) -- Animate to 75% over 0.5 seconds

-- Get current slider value
local value = slider:get_value()

-- Set custom value range
slider:set_range(0, 100)
slider:set_value(50) -- 50% of the slider range (value 50 in range 0-100)

-- Set steps for discrete values
slider:set_steps(5) -- 5 steps: 0, 0.25, 0.5, 0.75, 1

-- Enable/disable the slider
slider:set_enabled(true)
slider:set_enabled(false)

-- Check if slider is enabled
local is_enabled = slider:is_enabled()

-- Set a progress component to visualize the slider value
local progress = self.druid:new_progress("progress_node")
slider:set_progress(progress)

-- Reset to initial state
slider:reset()
```

## Events

```lua
-- Subscribe to value changes
slider.on_change:subscribe(function(self, value)
    print("Slider value changed to: " .. value)
end)

-- Subscribe to drag start event
slider.on_drag_start:subscribe(function(self)
    print("Started dragging slider")
end)

-- Subscribe to drag end event
slider.on_drag_end:subscribe(function(self)
    print("Stopped dragging slider")
end)
```

## Examples

```lua
-- Create a horizontal slider with steps
local slider = self.druid:new_slider("slider_bg", "slider_pin", vmath.vector3(1, 0, 0))
slider:set_steps(10) -- 10 discrete steps
slider:set_value(0.3)

-- Create a vertical slider with custom range
local slider = self.druid:new_slider("volume_bg", "volume_pin", vmath.vector3(0, 1, 0))
slider:set_range(0, 100)
slider:set_value(75) -- 75/100 = 75% of the slider

-- Create a slider with visual progress feedback
local slider = self.druid:new_slider("slider_bg", "slider_pin", vmath.vector3(1, 0, 0))
local progress = self.druid:new_progress("progress_fill")
slider:set_progress(progress)
slider:set_value(0.5)
```

## Notes

- The slider component calculates the handle position based on the background node size and the specified axis
- For horizontal sliders, use axis vector (1, 0, 0); for vertical sliders, use (0, 1, 0)
- The slider component automatically adjusts the handle position when the value changes
- When using steps, the slider will snap to the nearest step value
- You can integrate a progress component to provide visual feedback of the current value
- The slider's drag behavior respects the bounds of the background node
- The default value range is 0 to 1, but you can customize it for your specific needs
