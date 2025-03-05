# Druid Layout Component

## Description

The Layout component provides automatic positioning and sizing of UI elements based on predefined layout rules. It helps create responsive UIs that adapt to different screen sizes and orientations.

## Features

- Automatic positioning of nodes based on layout rules
- Support for different layout types (static, dynamic, fixed)
- Anchoring nodes to different parts of the screen
- Automatic adjustment when screen size changes
- Pivot-based positioning
- Margin and padding support

## Basic Usage

```lua
local layout = self.druid:new_layout("layout_node")
```

### Parameters

- **node**: The node or node_id of the layout container

## Layout Types

The Layout component supports several layout types:

- **Static Layout**: Fixed position relative to parent
- **Dynamic Layout**: Position based on parent size and node anchor
- **Fixed Layout**: Position based on screen size and node anchor

## Methods

```lua
-- Set layout type
layout:set_static_layout() -- Fixed position relative to parent
layout:set_dynamic_layout() -- Position based on parent size
layout:set_fixed_layout() -- Position based on screen size

-- Update layout size
layout:set_size(width, height)

-- Set node anchor (position relative to parent)
layout:set_anchor(anchor_type)
-- Available anchor types: ANCHOR.CENTER, ANCHOR.TOP, ANCHOR.BOTTOM, etc.

-- Set node pivot (position relative to node itself)
layout:set_pivot(pivot_type)
-- Available pivot types: PIVOT.CENTER, PIVOT.N, PIVOT.S, etc.

-- Set margins (distance from anchor point)
layout:set_margin(left, top, right, bottom)

-- Set padding (internal spacing)
layout:set_padding(left, top, right, bottom)

-- Manually update layout
layout:update()

-- Reset to initial state
layout:reset()
```

## Events

```lua
-- Subscribe to layout changes
layout.on_layout_change:subscribe(function(self)
    print("Layout changed")
end)
```

## Example

```lua
-- Create a layout that anchors to the top right of the screen
local layout = self.druid:new_layout("panel")
layout:set_fixed_layout()
layout:set_anchor(druid.const.ANCHOR.TOP_RIGHT)
layout:set_pivot(druid.const.PIVOT.NE)
layout:set_margin(0, 50, 50, 0) -- 50px from top, 50px from right

-- Create a dynamic layout that centers in its parent
local layout = self.druid:new_layout("content")
layout:set_dynamic_layout()
layout:set_anchor(druid.const.ANCHOR.CENTER)
layout:set_pivot(druid.const.PIVOT.CENTER)
```

## Notes

- The layout component automatically adjusts when the screen size changes
- You can nest layouts to create complex UI structures
- The layout component works well with other components like Grid and Scroll
- For responsive UIs, use fixed layouts for screen-anchored elements and dynamic layouts for elements that should adapt to their parent's size
- The layout component respects the node's initial position as an offset from the calculated position
