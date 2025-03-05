# Druid Data List Component

## Description

The Data List component provides an efficient way to display and manage large collections of data in a scrollable list. It creates and reuses a limited number of visual items to represent potentially unlimited data, optimizing performance for large datasets.

## Features

- Efficient display of large data collections
- Item recycling for optimal performance
- Integration with Grid and Scroll components
- Support for different item visual representations
- Dynamic data updates
- Customizable item creation and binding

## Basic Usage

```lua
-- Create a data list with a grid
local grid = self.druid:new_grid("grid_node", "item_prefab", 1)
local scroll = self.druid:new_scroll("view_node", "content_node")
scroll:bind_grid(grid)

-- Create a data list with the grid
local data_list = self.druid:new_data_list(grid, function(self, data, index, node)
    -- Bind data to visual item
    local text_node = gui.get_node(node .. "/text")
    gui.set_text(text_node, data.text)
end)

-- Set data to the list
local data = {
    { text = "Item 1" },
    { text = "Item 2" },
    { text = "Item 3" },
    -- ... more items
}
data_list:set_data(data)
```

### Parameters

- **grid**: The grid component to use for item layout
- **bind_function**: Function to bind data to visual items with parameters (self, data, index, node)

## Methods

```lua
-- Set data to the list
data_list:set_data(data_array)

-- Get current data
local data = data_list:get_data()

-- Update specific data item
data_list:update_item(5, { text = "Updated Item 5" })

-- Add new items to the list
data_list:add(new_data_array)

-- Remove items from the list
data_list:remove(5) -- Remove item at index 5
data_list:remove(5, 3) -- Remove 3 items starting from index 5

-- Clear all data
data_list:clear()

-- Get visual item node by data index
local node = data_list:get_node_by_index(10)

-- Get data index by visual item node
local index = data_list:get_index_by_node(node)

-- Set in-flight items (number of items created beyond visible area)
data_list:set_in_flight(2)
```

## Events

```lua
-- Subscribe to data changes
data_list.on_data_changed:subscribe(function(self)
    print("Data list data changed")
end)

-- Subscribe to item creation
data_list.on_create_item:subscribe(function(self, node, index, data)
    print("Created item at index: " .. index)
end)

-- Subscribe to item removal
data_list.on_remove_item:subscribe(function(self, node, index)
    print("Removed item at index: " .. index)
end)

-- Subscribe to item binding
data_list.on_bind_item:subscribe(function(self, node, index, data)
    print("Bound data to item at index: " .. index)
end)
```

## Examples

```lua
-- Create a data list with custom item creation
local grid = self.druid:new_grid("grid_node", "item_prefab", 1)
local scroll = self.druid:new_scroll("view_node", "content_node")
scroll:bind_grid(grid)

local data_list = self.druid:new_data_list(grid, function(self, data, index, node)
    -- Bind data to visual item
    local text_node = gui.get_node(node .. "/text")
    local icon_node = gui.get_node(node .. "/icon")
    
    gui.set_text(text_node, data.title)
    gui.set_texture(icon_node, data.icon_texture)
    
    -- Set up item interaction
    local button = self.druid:new_button(node, function()
        print("Clicked on item: " .. data.title)
    end)
end)

-- Set data with different item types
local data = {
    { title = "Item 1", icon_texture = "icon1" },
    { title = "Item 2", icon_texture = "icon2" },
    { title = "Item 3", icon_texture = "icon3" },
}
data_list:set_data(data)

-- Add new items dynamically
function add_new_item()
    data_list:add({ { title = "New Item", icon_texture = "new_icon" } })
end
```

## Notes

- The Data List component requires a Grid component for layout and typically a Scroll component for scrolling
- It creates only enough visual items to fill the visible area plus a few extra for smooth scrolling
- As the user scrolls, the component reuses existing items and rebinds them with new data
- This approach is much more efficient than creating one visual item per data entry
- The bind function is called whenever an item needs to be updated with data
- You can customize the appearance and behavior of each item in the bind function
- The component supports dynamic data updates, allowing you to add, remove, or modify items at runtime
- For best performance, keep your bind function efficient and avoid expensive operations
- The in-flight parameter controls how many extra items are created beyond the visible area
