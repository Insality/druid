    local M = {}


local function create_infinity_instance(self, record, index)
    local instance = gui.clone_tree(self.infinity_prefab)
    gui.set_enabled(instance["infinity_prefab"], true)
    gui.set_text(instance["infinity_text"], "Infinity record " .. index)

    local button = self.druid:new_button(instance["infinity_prefab"], function()
        print("Infinity click on", index)
    end)

    return instance["infinity_prefab"], button
end


local function create_infinity_instance_small(self, record, index)
    local instance = gui.clone_tree(self.infinity_prefab_small)
    gui.set_enabled(instance["infinity_prefab_small"], true)
    gui.set_text(instance["infinity_text_3"], index)

    local button = self.druid:new_button(instance["infinity_prefab_small"], function()
        print("Infinity click on", index)
    end)

    return instance["infinity_prefab_small"], button
end



local function setup_infinity_list(self)
    local data = {}
    for i = 1, 50 do
        table.insert(data, i)
    end

    self.infinity_list = self.druid:new_infinity_list(data, self.infinity_scroll, self.infinity_grid, function(record, index)
        -- function should return gui_node, [druid_component]
        return create_infinity_instance(self, record, index)
    end)

    -- scroll to some index
    local pos = self.infinity_grid:get_pos(25)
    self.infinity_scroll:scroll_to(pos, true)


    self.infinity_list_small = self.druid:new_infinity_list(data, self.infinity_scroll_3, self.infinity_grid_3, function(record, index)
        -- function should return gui_node, [druid_component]
        return create_infinity_instance_small(self, record, index)
    end)
end


function M.setup_page(self)
    self.infinity_scroll = self.druid:new_scroll("infinity_scroll_stencil", "infinity_scroll_content")
        :set_horizontal_scroll(false)
    self.infinity_grid = self.druid:new_static_grid("infinity_scroll_content", "infinity_prefab", 1)
    self.infinity_prefab = gui.get_node("infinity_prefab")
    gui.set_enabled(self.infinity_prefab, false)

    self.infinity_scroll_3 = self.druid:new_scroll("infinity_scroll_3_stencil", "infinity_scroll_3_content")
        :set_horizontal_scroll(false)
    self.infinity_grid_3 = self.druid:new_static_grid("infinity_scroll_3_content", "infinity_prefab_small", 3)
    self.infinity_prefab_small = gui.get_node("infinity_prefab_small")
    gui.set_enabled(self.infinity_prefab_small, false)

    setup_infinity_list(self)
end


return M
