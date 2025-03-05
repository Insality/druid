# Druid Static Grid Component

## Description

The Static Grid component handles the positioning of UI elements in a grid layout with rows and columns. It provides a way to organize nodes in a structured grid with consistent spacing.

## Features

- Automatic positioning of nodes in rows and columns
- Customizable number of elements per row
- Dynamic addition and removal of nodes
- Node sorting capabilities
- Events for grid changes
- Automatic size calculation

## Basic Usage

```lua
local grid = self.druid:new_grid("parent_node", "item_prefab", 3)

-- Add nodes to the grid
local node1 = gui.clone(prefab)
local node2 = gui.clone(prefab)
grid:add(node1)
grid:add(node2)
```

### Parameters

- **parent_node**: The node or node_id of the parent container where grid items will be placed
- **item_prefab**: The node or node_id of the item prefab (used to determine item size)
- **in_row**: (optional) Number of items per row (default: 1)

## Methods

```lua
-- Add a node to the grid
local node = gui.clone(prefab)
grid:add(node)

-- Add multiple nodes
grid:add_many({node1, node2, node3})

-- Remove a node from the grid
grid:remove(node)

-- Clear all nodes from the grid
grid:clear()

-- Get node position by index
local position = grid:get_pos(5)

-- Get grid size for a specific number of elements
local size = grid:get_size_for(10)

-- Get current grid borders
local borders = grid:get_borders()

-- Get all node positions
local positions = grid:get_all_pos()

-- Set custom position function
grid:set_position_function(function(node, pos)
    -- Custom positioning logic
    gui.set_position(node, pos)
end)

-- Change items per row
grid:set_in_row(4)

-- Set item size
grid:set_item_size(100, 50)

-- Sort grid nodes
grid:sort_nodes(function(a, b)
    -- Custom sorting logic
    return gui.get_id(a) < gui.get_id(b)
end)
```

## Events

```lua
-- Subscribe to node addition
grid.on_add_item:subscribe(function(self, node)
    print("Node added to grid")
end)

-- Subscribe to node removal
grid.on_remove_item:subscribe(function(self, node)
    print("Node removed from grid")
end)

-- Subscribe to grid changes
grid.on_change_items:subscribe(function(self)
    print("Grid items changed")
end)

-- Subscribe to grid clear
grid.on_clear:subscribe(function(self)
    print("Grid cleared")
end)

-- Subscribe to position updates
grid.on_update_positions:subscribe(function(self)
    print("Grid positions updated")
end)
```

## Notes

- The grid component calculates positions based on the size of the item prefab
- The grid's pivot point affects how items are positioned within the grid
- You can customize the grid's behavior with style settings:
  - `IS_DYNAMIC_NODE_POSES`: If true, always centers grid content based on the grid's pivot
  - `IS_ALIGN_LAST_ROW`: If true, always aligns the last row of the grid based on the grid's pivot
- The grid component does not automatically delete GUI nodes when cleared or when nodes are removed
- The grid can be used with the Scroll component to create scrollable lists
- When used with DataList, the grid can efficiently handle large collections of data
