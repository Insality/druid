# Druid Container Component

## Description

The Container component provides a way to group and manage multiple UI elements as a single entity. It allows you to show, hide, enable, or disable a collection of nodes together, and provides events for container state changes.

## Features

- Group multiple nodes under a single container
- Show/hide all container nodes together
- Enable/disable all container nodes together
- Animation support for transitions
- Events for container state changes
- Optional animation callbacks

## Basic Usage

```lua
-- Create a container with a single node
local container = self.druid:new_container("container_node")

-- Create a container with multiple nodes
local container = self.druid:new_container({"node1", "node2", "node3"})
```

### Parameters

- **nodes**: A node, node_id, or array of nodes/node_ids to include in the container

## Methods

```lua
-- Add nodes to the container
container:add("new_node")
container:add({"node4", "node5"})

-- Remove nodes from the container
container:remove("node1")
container:remove({"node2", "node3"})

-- Show the container (all nodes)
container:show()

-- Hide the container (all nodes)
container:hide()

-- Show with animation
container:show(function(self)
    -- Animation complete callback
    print("Container shown")
end)

-- Hide with animation
container:hide(function(self)
    -- Animation complete callback
    print("Container hidden")
end)

-- Enable the container (all nodes)
container:set_enabled(true)

-- Disable the container (all nodes)
container:set_enabled(false)

-- Check if container is visible
local is_visible = container:is_visible()

-- Check if container is enabled
local is_enabled = container:is_enabled()
```

## Events

```lua
-- Subscribe to visibility change event
container.on_visibility_changed:subscribe(function(self, is_visible)
    print("Container visibility changed to: " .. tostring(is_visible))
end)

-- Subscribe to enabled state change event
container.on_enabled_changed:subscribe(function(self, is_enabled)
    print("Container enabled state changed to: " .. tostring(is_enabled))
end)
```

## Animation

The container component supports custom animations for show and hide operations:

```lua
-- Set custom show animation
container:set_show_animation(function(self, callback)
    -- Animate container nodes
    for _, node in ipairs(self.nodes) do
        gui.animate(node, "color.w", 1, gui.EASING_OUTSINE, 0.5, 0, callback)
    end
end)

-- Set custom hide animation
container:set_hide_animation(function(self, callback)
    -- Animate container nodes
    for _, node in ipairs(self.nodes) do
        gui.animate(node, "color.w", 0, gui.EASING_OUTSINE, 0.5, 0, callback)
    end
end)
```

## Examples

```lua
-- Create a panel container with multiple elements
local panel = self.druid:new_container({
    "panel_bg",
    "panel_title",
    "panel_content",
    "close_button"
})

-- Set custom show animation
panel:set_show_animation(function(self, callback)
    local bg = gui.get_node("panel_bg")
    local content = gui.get_node("panel_content")
    
    -- Animate background
    gui.set_scale(bg, vmath.vector3(0.8, 0.8, 1))
    gui.animate(bg, "scale", vmath.vector3(1, 1, 1), gui.EASING_OUTBACK, 0.4)
    
    -- Animate content
    gui.set_alpha(content, 0)
    gui.animate(content, "color.w", 1, gui.EASING_OUTSINE, 0.3, 0.1, callback)
end)

-- Show the panel with animation
panel:show(function()
    print("Panel animation completed")
end)

-- Create a tab system with multiple containers
local tab1 = self.druid:new_container("tab1_content")
local tab2 = self.druid:new_container("tab2_content")
local tab3 = self.druid:new_container("tab3_content")

local function switch_to_tab(tab_index)
    tab1:hide()
    tab2:hide()
    tab3:hide()
    
    if tab_index == 1 then tab1:show() end
    if tab_index == 2 then tab2:show() end
    if tab_index == 3 then tab3:show() end
end

-- Switch to tab 1
switch_to_tab(1)
```

## Notes

- The container component does not create or delete nodes, it only manages their visibility and enabled state
- When a container is hidden, all its nodes are disabled by default to prevent input
- You can customize the show and hide animations to create smooth transitions
- Containers are useful for organizing UI elements into logical groups like panels, windows, or tabs
- The container component respects the node's initial state when it's added to the container
- You can nest containers to create complex UI hierarchies
- The container component is often used with other components like buttons, texts, and layouts to create complete UI panels
