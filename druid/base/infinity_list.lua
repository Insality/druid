--- Manage data for huge dataset in scroll
--- It requires basic druid scroll and druid grid components
local const = require("druid.const")
local component = require("druid.component")

local M = component.create("infinity_list", { const.ON_UPDATE })


function M:init(data_list, scroll, grid, create_function)
    self.view_size = gui.get_size(scroll.view_node)
    self.prefab_size = grid.node_size
    self.druid = self:get_druid()
    self.scroll = scroll
    self.grid = grid
    self.grid:set_grid_mode(const.GRID_MODE.STATIC)

    self.data = data_list
    self.top_index = 1

    self.create_function = create_function

    self.nodes = {}
    self.components = {}

    self.elements_view_count = vmath.vector3(
        math.min(math.ceil(self.view_size.x / self.prefab_size.x), self.grid.in_row),
        math.ceil(self.view_size.y / self.prefab_size.y),
        0)

    self:_refresh()
    self.scroll.on_scroll:subscribe(function() self._check_elements(self) end)
end


function M:on_remove()
    -- TODO: make this work
    -- self.scroll.on_scroll:unsubscribe(self._check_elements)
end


function M:update(dt)
    if self.scroll.animate then
        self:_check_elements()
    end
end


function M:set_data(data_list)
    self.data = data_list
    self:_refresh()
end


function M:_add_at(index)
    if self.nodes[index] then
        self:_remove_at(index)
    end

    local node, instance = self.create_function(self.data[index], index)
    self.grid:add(node, index)
    self.nodes[index] = node
    self.components[index] = instance
end


function M:_remove_at(index)
    self.grid:remove(index)

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
    self:_recalc_scroll_size()
end


function M:_check_elements()
    local pos = gui.get_position(self.scroll.content_node)
    pos.y = -pos.y

    local top_index = self.grid:get_index(pos)
    local last_index = top_index + (self.elements_view_count.x * self.elements_view_count.y) + self.grid.in_row - 1

    -- Clear outside elements
    for index, _ in pairs(self.nodes) do
        if index < top_index or index > last_index then
            self:_remove_at(index)
        end
    end

    -- Spawn current elements
    for index = top_index, last_index do
        if self.data[index] and not self.nodes[index] then
            self:_add_at(index)
        end
    end
end


function M:_recalc_scroll_size()
    local element_size = self.grid:get_size_for_elements_count(#self.data)
    self.scroll:set_size(element_size)
end


return M
