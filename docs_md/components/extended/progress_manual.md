# Druid Progress Component

## Description

The Progress component provides a way to visualize progress or completion status through various visual representations. It can be used to create progress bars, loading indicators, or any UI element that needs to display a value within a range.

## Features

- Visual representation of progress values
- Support for different visual styles (bar, radial, etc.)
- Customizable value range
- Smooth value transitions with animations
- Events for progress changes
- Support for fill nodes, size nodes, and slice nodes

## Basic Usage

```lua
-- Basic progress bar with a fill node
local progress = self.druid:new_progress("progress_node", druid.const.PROGRESS.FILL)

-- Set progress value (0 to 1)
progress:set_value(0.5) -- 50% progress
```

### Parameters

- **node**: The node or node_id of the progress container
- **mode**: (optional) The progress visualization mode (default: FILL)
  - `druid.const.PROGRESS.FILL`: Changes the fill of the node
  - `druid.const.PROGRESS.SIZE`: Changes the size of the node
  - `druid.const.PROGRESS.SLICE`: Changes the slice of a pie node

## Methods

```lua
-- Set progress value (0 to 1)
progress:set_value(0.75) -- 75% progress

-- Set progress value with animation
progress:set_to(0.75, 0.5) -- Animate to 75% over 0.5 seconds

-- Get current progress value
local value = progress:get_value()

-- Set custom value range
progress:set_range(0, 100)
progress:set_value(50) -- 50% progress (value 50 in range 0-100)

-- Set key points for non-linear progress
progress:set_key_points({
    { value = 0, percent = 0 },
    { value = 50, percent = 0.25 }, -- 50 is 25% of visual progress
    { value = 100, percent = 1 }
})

-- Set fill target node (for FILL mode)
progress:set_fill_node("fill_node")

-- Set size target node (for SIZE mode)
progress:set_size_node("size_node")

-- Set slice target node (for SLICE mode)
progress:set_slice_node("slice_node")

-- Reset to initial state
progress:reset()
```

## Events

```lua
-- Subscribe to progress value changes
progress.on_change:subscribe(function(self, value)
    print("Progress changed to: " .. value)
end)

-- Subscribe to progress completion
progress.on_complete:subscribe(function(self)
    print("Progress completed!")
end)
```

## Examples

```lua
-- Create a horizontal progress bar
local progress = self.druid:new_progress("bar_node", druid.const.PROGRESS.SIZE)
progress:set_size_node("fill_node")
progress:set_value(0.5)

-- Create a radial progress indicator
local progress = self.druid:new_progress("pie_node", druid.const.PROGRESS.SLICE)
progress:set_slice_node("slice_node")
progress:set_value(0.75)

-- Create a progress bar with custom range
local progress = self.druid:new_progress("health_bar", druid.const.PROGRESS.FILL)
progress:set_range(0, 100)
progress:set_value(75) -- 75/100 = 75% progress
```

## Notes

- The progress component can be used with different visual representations based on the mode
- For FILL mode, the component changes the x or y fill of the target node
- For SIZE mode, the component changes the size of the target node
- For SLICE mode, the component changes the inner or outer bounds of a pie node
- You can create non-linear progress visualization using key points
- The progress component supports smooth animations between values
- The default value range is 0 to 1, but you can customize it for your specific needs
