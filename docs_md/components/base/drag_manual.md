# Druid Drag Component

## Description

The Drag component handles drag actions on a node, allowing users to move UI elements by dragging them. It provides proper handling for multitouch and swap touches while dragging.

## Features

- Handles drag actions on nodes
- Supports multitouch and touch swapping
- Provides drag start, drag, and drag end events
- Customizable drag deadzone
- Optional click zone restriction

## Basic Usage

```lua
local drag = self.druid:new_drag("drag_node", function(self, dx, dy, x, y, touch)
    -- Handle drag action
    local position = gui.get_position(drag.node)
    gui.set_position(drag.node, vmath.vector3(position.x + dx, position.y + dy, position.z))
end)
```

### Parameters

- **node**: The node or node_id of the draggable node
- **on_drag_callback**: (optional) Function to call during drag with parameters (self, dx, dy, total_x, total_y, touch)

## Events

The Drag component provides several events you can subscribe to:

```lua
-- Subscribe to drag start event
drag.on_drag_start:subscribe(function(self, touch)
    print("Drag started")
end)

-- Subscribe to drag end event
drag.on_drag_end:subscribe(function(self, x, y, touch)
    print("Drag ended, total movement: " .. x .. ", " .. y)
end)

-- Subscribe to touch start/end events
drag.on_touch_start:subscribe(function(self, touch)
    print("Touch started")
end)

drag.on_touch_end:subscribe(function(self, touch)
    print("Touch ended")
end)
```

## Methods

```lua
-- Set a click zone to restrict drag area
drag:set_click_zone("stencil_node")

-- Enable or disable drag
drag:set_enabled(true)  -- Enable
drag:set_enabled(false) -- Disable

-- Check if drag is enabled
local is_enabled = drag:is_enabled()

-- Set drag cursor appearance (requires defos)
drag:set_drag_cursors(true)  -- Enable custom cursors
drag:set_drag_cursors(false) -- Disable custom cursors
```

## Notes

- Drag will be processed even if the cursor is outside of the node, as long as the drag has already started
- The component has a configurable deadzone (default: 10 pixels) before drag is triggered
- You can restrict the drag area by setting a click zone, which is useful for stencil nodes
- The drag component automatically detects the closest stencil node and sets it as the click zone if none is specified
- The drag component can be configured to use screen aspect ratio for drag values
