# Druid Scroll Component

## Description

The Scroll component handles scrollable content in your UI. It consists of two main parts: a static view node that captures user input, and a dynamic content node that moves in response to user interaction.

## Features

- Horizontal and vertical scrolling
- Inertial scrolling with customizable friction
- Points of interest for snap-to-position scrolling
- Scroll-to-position and scroll-to-percent functions
- Mouse wheel support
- Stretch effect for overscrolling
- Grid binding for automatic content size adjustment

## Basic Usage

```lua
local scroll = self.druid:new_scroll("view_node", "content_node")
```

### Parameters

- **view_node**: The node or node_id of the static view part (captures input)
- **content_node**: The node or node_id of the dynamic content part (moves when scrolling)

## Setup

The typical setup involves placing a view_node and adding a content_node as its child:

![Scroll Scheme](../../../media/scroll_scheme.png)

The view_node captures user input and defines the visible area, while the content_node contains all the scrollable content and moves in response to user interaction.

## Methods

```lua
-- Scroll to a specific position
scroll:scroll_to(vmath.vector3(100, 200, 0), false) -- Animated scroll
scroll:scroll_to(vmath.vector3(100, 200, 0), true)  -- Instant scroll

-- Scroll to a percentage of the content
scroll:scroll_to_percent(vmath.vector3(0.5, 0.5, 0), false) -- Scroll to middle

-- Get current scroll percentage
local percent = scroll:get_percent()

-- Set content size
scroll:set_size(vmath.vector3(500, 1000, 0))

-- Update view size if it changes
scroll:update_view_size()

-- Enable/disable inertial scrolling
scroll:set_inert(true)
scroll:set_inert(false)

-- Set points of interest for snap-to-position scrolling
scroll:set_points({
    vmath.vector3(0, 0, 0),
    vmath.vector3(0, 200, 0),
    vmath.vector3(0, 400, 0)
})

-- Scroll to a specific point of interest
scroll:scroll_to_index(2)

-- Enable/disable horizontal or vertical scrolling
scroll:set_horizontal_scroll(true)
scroll:set_vertical_scroll(true)

-- Check if a node is visible in the scroll view
local is_visible = scroll:is_node_in_view(node)

-- Bind a grid to automatically adjust scroll size
scroll:bind_grid(grid)
```

## Events

```lua
-- Subscribe to scroll movement
scroll.on_scroll:subscribe(function(self, position)
    print("Scroll position: " .. position.x .. ", " .. position.y)
end)

-- Subscribe to scroll_to events
scroll.on_scroll_to:subscribe(function(self, target, is_instant)
    print("Scrolling to: " .. target.x .. ", " .. target.y)
end)

-- Subscribe to point scroll events
scroll.on_point_scroll:subscribe(function(self, index, point)
    print("Scrolled to point: " .. index)
end)
```

## Notes

- The scroll component has customizable style parameters for friction, inertia, and stretch effects
- By default, scroll has inertia and a stretching effect, which can be adjusted via style settings
- You can set up "points of interest" to make the scroll always center on the closest point
- When using a stencil node with the scroll, buttons inside the scroll may be clickable outside the stencil bounds. Use `button:set_click_zone(scroll.view_node)` to restrict button clicks to the visible area
- The scroll component automatically detects the closest stencil node and sets it as the click zone if none is specified
- Mouse wheel scrolling is supported and can be customized or disabled via style settings
