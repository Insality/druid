# Druid Swipe Component

## Description

The Swipe component detects swipe gestures on a specified node or across the entire screen. It provides information about swipe direction, speed, and distance, allowing you to implement gesture-based interactions in your UI.

## Features

- Detection of swipe gestures in 8 directions
- Customizable swipe sensitivity and threshold
- Information about swipe speed and distance
- Support for both touch and mouse input
- Optional click zone restriction
- Events for swipe detection

## Basic Usage

```lua
-- Basic swipe detection across the entire screen
local swipe = self.druid:new_swipe(function(self, swipe_info)
    -- Handle swipe action
    print("Swipe detected in direction: " .. swipe_info.direction)
end)

-- Swipe detection on a specific node
local swipe = self.druid:new_swipe(function(self, swipe_info)
    -- Handle swipe action
    print("Swipe detected in direction: " .. swipe_info.direction)
end, "swipe_area_node")
```

### Parameters

- **callback**: (optional) Function to call when a swipe is detected
- **node**: (optional) The node or node_id to detect swipes on (default: entire screen)

## Swipe Info

The swipe callback provides a `swipe_info` table with the following information:

```lua
{
    direction = druid.const.SWIPE.RIGHT, -- Direction constant
    distance = 150, -- Distance in pixels
    time = 0.2, -- Time taken for the swipe in seconds
    speed = 750, -- Speed in pixels per second
    x = 150, -- X distance
    y = 0, -- Y distance
    touch = hash("touch") -- Touch that triggered the swipe
}
```

## Methods

```lua
-- Set minimum swipe distance threshold
swipe:set_minimum_distance(50)

-- Set maximum swipe time threshold
swipe:set_maximum_time(0.5)

-- Set a click zone to restrict swipe area
swipe:set_click_zone("stencil_node")

-- Enable or disable swipe detection
swipe:set_enabled(true)
swipe:set_enabled(false)

-- Check if swipe detection is enabled
local is_enabled = swipe:is_enabled()
```

## Events

```lua
-- Subscribe to swipe event
swipe.on_swipe:subscribe(function(self, swipe_info)
    print("Swipe detected in direction: " .. swipe_info.direction)
    print("Swipe distance: " .. swipe_info.distance)
    print("Swipe speed: " .. swipe_info.speed)
end)
```

## Swipe Directions

The component provides constants for swipe directions:

```lua
druid.const.SWIPE = {
    UP = "up",
    DOWN = "down",
    LEFT = "left",
    RIGHT = "right",
    UP_LEFT = "up_left",
    UP_RIGHT = "up_right",
    DOWN_LEFT = "down_left",
    DOWN_RIGHT = "down_right"
}
```

## Examples

```lua
-- Create a swipe detector with custom thresholds
local swipe = self.druid:new_swipe(function(self, swipe_info)
    if swipe_info.direction == druid.const.SWIPE.LEFT then
        -- Handle left swipe
        print("Left swipe detected")
    elseif swipe_info.direction == druid.const.SWIPE.RIGHT then
        -- Handle right swipe
        print("Right swipe detected")
    end
end)
swipe:set_minimum_distance(100) -- Require at least 100px of movement
swipe:set_maximum_time(0.3) -- Must complete within 0.3 seconds

-- Create a swipe detector for a specific area
local swipe = self.druid:new_swipe(nil, "swipe_area")
swipe.on_swipe:subscribe(function(self, swipe_info)
    if swipe_info.speed > 1000 then
        print("Fast swipe detected!")
    else
        print("Slow swipe detected")
    end
end)
```

## Notes

- The swipe component detects gestures based on both distance and time thresholds
- By default, a swipe must be at least 50 pixels in distance and completed within 0.4 seconds
- The component determines the direction based on the angle of the swipe
- You can restrict the swipe detection area by setting a click zone, which is useful for stencil nodes
- The swipe component automatically detects the closest stencil node and sets it as the click zone if none is specified
- Swipe detection works with both touch and mouse input
- The component provides detailed information about each swipe, allowing you to implement velocity-based interactions
