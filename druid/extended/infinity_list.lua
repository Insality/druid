--- Manage data for huge dataset in scroll
--- It requires basic druid scroll and druid grid components
local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")

local M = component.create("infinity_list", { const.ON_UPDATE })


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
    self:_recalc_scroll_size()
end


function M:_check_elements_old()
    local pos = gui.get_position(self.scroll.content_node)
    pos.y = -pos.y

    local top_index = self.grid:get_index(pos) - self.grid.in_row
    local last_index = (top_index - 1) + (self.elements_view_count.x * self.elements_view_count.y) + self.grid.in_row

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


function M:_check_elements()
    local top_index = self.top_index
    self.last_index = self.top_index

    for index, node in pairs(self.nodes) do
        if self.scroll:is_node_in_view(node) then
            top_index = index
            break
        end
    end

    -- make items from (top_index upside
    local is_top_outside = false
    local cur_index = top_index - 1
    while not is_top_outside do
        if not self.data[cur_index] then
            break
        end

        if not self.nodes[cur_index] then
            self:_add_at(cur_index)
        end

        if not self.scroll:is_node_in_view(self.nodes[cur_index]) then
            is_top_outside = true

            -- remove nexts:
            local remove_index = cur_index - 1
            while self.nodes[remove_index] do
                self:_remove_at(remove_index)
                remove_index = remove_index - 1
            end
        end

        cur_index = cur_index - 1
    end

    -- make items from [top_index downsize
    local is_bot_outside = false
    cur_index = top_index
    while not is_bot_outside do
        if not self.data[cur_index] then
            break
        end

        if not self.nodes[cur_index] then
            self:_add_at(cur_index)
        end
        if not self.scroll:is_node_in_view(self.nodes[cur_index]) then
            is_bot_outside = true

            -- remove nexts:
            local remove_index = cur_index + 1
            while self.nodes[remove_index] do
                self:_remove_at(remove_index)
                remove_index = remove_index + 1
            end
        else
            self.last_index = cur_index
        end

        cur_index = cur_index + 1
    end

    self.top_index = top_index
end


function M:_recalc_scroll_size()
    local element_size = self.grid:get_size_for(#self.data)
    self.scroll:set_size(element_size)
end


return M
