--- Manage data for huge dataset in scroll
--- It requires basic druid scroll and druid grid components
local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")

local M = component.create("infinity_list")


function M:init(data_list, scroll, grid, create_function)
    self.view_size = gui.get_size(scroll.view_node)
    self.prefab_size = grid.node_size
    self.druid = self:get_druid()
    self.scroll = scroll
    self.grid = grid
    self.scroll:bind_grid(grid)

    self.data = data_list
    self.top_index = 1
    self.last_index = 1

    self.create_function = create_function

    self.nodes = {}
    self.components = {}

    self:_refresh()
    self.scroll.on_scroll:subscribe(self._check_elements, self)
end


function M:on_remove()
    self.scroll.on_scroll:unsubscribe(self._check_elements, self)
end


function M:set_data(data_list)
    self.data = data_list
    self:_refresh()
end


function M:add(data, index)
    table.insert(self.data, index, data)
    self:_refresh()
end


function M:remove(index, shift_policy)
    table.remove(self.data, index)
    self:_refresh()
end


function M:clear()
    self.data = {}
    self:_refresh()
end


function M:get_first_index()
    return self.top_index
end


function M:get_last_index()
    return self.last_index
end


function M:get_index(data)
    for index, value in pairs(self.data) do
        if value == data then
            return index
        end
    end
    return nil
end


function M:scroll_to_index(index)
    self.top_index = helper.clamp(index, 1, #self.data)
    self:_refresh()
    self.scroll.on_scroll:trigger(self:get_context(), self)
end


function M:_add_at(index)
    if self.nodes[index] then
        self:_remove_at(index)
    end

    local node, instance = self.create_function(self.data[index], index)
    self.grid:add(node, index, const.SHIFT.NO_SHIFT)
    self.nodes[index] = node
    self.components[index] = instance
end


function M:_remove_at(index)
    self.grid:remove(index, const.SHIFT.NO_SHIFT)

    local node = self.nodes[index]
    gui.delete_node(node)
    self.nodes[index] = nil

    if self.components[index] then
        self.druid:remove(self.components[index])
        self.components[index] = nil
    end
end


function M:_refresh()
    for index, _ in pairs(self.nodes) do
        self:_remove_at(index)
    end
    self:_check_elements()
end


function M:_check_elements()
    for index, node in pairs(self.nodes) do
        if self.scroll:is_node_in_view(node) then
            self.top_index = index
            self.last_index = index
        end
    end

    self:_check_elements_from(self.top_index - 1, -1)
    self:_check_elements_from(self.top_index, 1)

    for index, node in pairs(self.nodes) do
        self.top_index = math.min(self.top_index or index, index)
        self.last_index = math.max(self.last_index or index, index)
    end
end


function M:_check_elements_from(index, step)
    local is_outside = false
    while not is_outside do
        if not self.data[index] then
            break
        end

        if not self.nodes[index] then
            self:_add_at(index)
        end

        if not self.scroll:is_node_in_view(self.nodes[index]) then
            is_outside = true

            -- remove nexts:
            local remove_index = index
            while self.nodes[remove_index] do
                self:_remove_at(remove_index)
                remove_index = remove_index + step
            end
        end

        index = index + step
    end
end


return M
