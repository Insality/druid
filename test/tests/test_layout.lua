return function()
    describe("Layout Component", function()
        local mock_time
        local mock_input
        local druid_system

        local druid
        local context

        before(function()
            mock_time = require("deftest.mock.time")
            mock_input = require("test.helper.mock_input")
            druid_system = require("druid.druid")

            mock_time.mock()
            mock_time.set(0)

            context = vmath.vector3()
            druid = druid_system.new(context)
        end)

        after(function()
            mock_time.unmock()
            druid:final()
            druid = nil
        end)


        it("Should initialize layout with default settings", function()
            local layout_node = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(100, 100, 0))
            local layout = druid:new_layout(layout_node)

            assert(layout ~= nil)
            assert(layout.node == layout_node)
            assert(layout.type == "horizontal")
            assert(layout.is_dirty == true)
            assert(layout.entities ~= nil)
            assert(#layout.entities == 0)
            assert(layout.is_resize_width == false)
            assert(layout.is_resize_height == false)
            assert(layout.is_justify == false)

            druid:remove(layout)
            gui.delete_node(layout_node)
        end)

        it("Should add and remove nodes", function()
            local layout_node = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(100, 100, 0))
            local layout = druid:new_layout(layout_node)

            local child1 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(20, 20, 0))
            local child2 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(20, 20, 0))

            layout:add(child1)
            assert(#layout.entities == 1)
            assert(layout.entities[1] == child1)

            layout:add(child2)
            assert(#layout.entities == 2)
            assert(layout.entities[2] == child2)

            layout:remove(child1)
            assert(#layout.entities == 1)
            assert(layout.entities[1] == child2)

            layout:clear_layout()
            assert(#layout.entities == 0)

            druid:remove(layout)
            gui.delete_node(layout_node)
            gui.delete_node(child1)
            gui.delete_node(child2)
        end)

        it("Should set node index", function()
            local layout_node = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(100, 100, 0))
            local layout = druid:new_layout(layout_node)

            local child1 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(20, 20, 0))
            local child2 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(20, 20, 0))
            local child3 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(20, 20, 0))

            layout:add(child1)
            layout:add(child2)
            layout:add(child3)

            assert(layout.entities[1] == child1)
            assert(layout.entities[2] == child2)
            assert(layout.entities[3] == child3)

            layout:set_node_index(child3, 1)

            assert(layout.entities[1] == child3)
            assert(layout.entities[2] == child1)
            assert(layout.entities[3] == child2)

            druid:remove(layout)
            gui.delete_node(layout_node)
            gui.delete_node(child1)
            gui.delete_node(child2)
            gui.delete_node(child3)
        end)

        it("Should set layout type", function()
            local layout_node = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(100, 100, 0))
            local layout = druid:new_layout(layout_node)

            assert(layout.type == "horizontal")

            layout:set_type("vertical")
            assert(layout.type == "vertical")
            assert(layout.is_dirty == true)

            layout:set_type("horizontal_wrap")
            assert(layout.type == "horizontal_wrap")
            assert(layout.is_dirty == true)

            druid:remove(layout)
            gui.delete_node(layout_node)
        end)

        it("Should set margin", function()
            local layout_node = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(100, 100, 0))
            local layout = druid:new_layout(layout_node)

            local initial_margin_x = layout.margin.x
            local initial_margin_y = layout.margin.y

            layout:set_margin(10, 20)

            assert(layout.margin.x == 10)
            assert(layout.margin.y == 20)
            assert(layout.is_dirty == true)

            -- Test partial update
            layout:set_margin(15)
            assert(layout.margin.x == 15)
            assert(layout.margin.y == 20)

            druid:remove(layout)
            gui.delete_node(layout_node)
        end)

        it("Should set padding", function()
            local layout_node = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(100, 100, 0))
            local layout = druid:new_layout(layout_node)

            layout:set_padding(5, 10, 15, 20)

            assert(layout.padding.x == 5)  -- left
            assert(layout.padding.y == 10) -- top
            assert(layout.padding.z == 15) -- right
            assert(layout.padding.w == 20) -- bottom
            assert(layout.is_dirty == true)

            -- Test partial update
            layout:set_padding(25)
            assert(layout.padding.x == 25)
            assert(layout.padding.y == 10)
            assert(layout.padding.z == 15)
            assert(layout.padding.w == 20)

            druid:remove(layout)
            gui.delete_node(layout_node)
        end)

        it("Should set justify", function()
            local layout_node = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(100, 100, 0))
            local layout = druid:new_layout(layout_node)

            assert(layout.is_justify == false)

            layout:set_justify(true)
            assert(layout.is_justify == true)
            assert(layout.is_dirty == true)

            layout:set_justify(false)
            assert(layout.is_justify == false)
            assert(layout.is_dirty == true)

            druid:remove(layout)
            gui.delete_node(layout_node)
        end)

        it("Should set hug content", function()
            local layout_node = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(100, 100, 0))
            local layout = druid:new_layout(layout_node)

            assert(layout.is_resize_width == false)
            assert(layout.is_resize_height == false)

            layout:set_hug_content(true, false)
            assert(layout.is_resize_width == true)
            assert(layout.is_resize_height == false)
            assert(layout.is_dirty == true)

            layout:set_hug_content(false, true)
            assert(layout.is_resize_width == false)
            assert(layout.is_resize_height == true)
            assert(layout.is_dirty == true)

            layout:set_hug_content(true, true)
            assert(layout.is_resize_width == true)
            assert(layout.is_resize_height == true)
            assert(layout.is_dirty == true)

            druid:remove(layout)
            gui.delete_node(layout_node)
        end)

        it("Should fire on_size_changed event", function()
            local layout_node = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(100, 100, 0))
            local layout = druid:new_layout(layout_node)

            local on_size_changed_calls = 0
            local last_size = nil

            layout.on_size_changed:subscribe(function(new_size)
                on_size_changed_calls = on_size_changed_calls + 1
                last_size = new_size
            end)

            -- Set to hug content
            layout:set_hug_content(true, true)

            -- Add some nodes
            local child1 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(30, 20, 0))
            local child2 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(30, 20, 0))

            layout:add(child1)
            layout:add(child2)

            -- Force refresh to trigger the event
            layout:refresh_layout()

            assert(on_size_changed_calls >= 1)
            assert(last_size ~= nil)

            druid:remove(layout)
            gui.delete_node(layout_node)
            gui.delete_node(child1)
            gui.delete_node(child2)
        end)

        it("Should handle horizontal layout correctly", function()
            local layout_node = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(300, 100, 0))
            local layout = druid:new_layout(layout_node)
            layout:set_type("horizontal")
            layout:set_margin(10, 0)

            local child1 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(50, 30, 0))
            local child2 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(50, 30, 0))
            local child3 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(50, 30, 0))

            layout:add(child1)
            layout:add(child2)
            layout:add(child3)

            layout:refresh_layout()

            -- Check positions - in horizontal layout, nodes should be arranged left to right
            local pos1 = gui.get_position(child1)
            local pos2 = gui.get_position(child2)
            local pos3 = gui.get_position(child3)

            assert(pos2.x > pos1.x)
            assert(pos3.x > pos2.x)

            -- Y positions should be approximately the same
            assert(math.abs(pos1.y - pos2.y) < 0.001)
            assert(math.abs(pos2.y - pos3.y) < 0.001)

            druid:remove(layout)
            gui.delete_node(layout_node)
            gui.delete_node(child1)
            gui.delete_node(child2)
            gui.delete_node(child3)
        end)

        it("Should handle vertical layout correctly", function()
            local layout_node = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(100, 300, 0))
            local layout = druid:new_layout(layout_node)
            layout:set_type("vertical")
            layout:set_margin(0, 10)

            local child1 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(50, 30, 0))
            local child2 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(50, 30, 0))
            local child3 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(50, 30, 0))

            layout:add(child1)
            layout:add(child2)
            layout:add(child3)

            layout:refresh_layout()

            -- Check positions - in vertical layout, nodes should be arranged top to bottom
            local pos1 = gui.get_position(child1)
            local pos2 = gui.get_position(child2)
            local pos3 = gui.get_position(child3)

            assert(pos2.y < pos1.y)
            assert(pos3.y < pos2.y)

            -- X positions should be approximately the same
            assert(math.abs(pos1.x - pos2.x) < 0.001)
            assert(math.abs(pos2.x - pos3.x) < 0.001)

            druid:remove(layout)
            gui.delete_node(layout_node)
            gui.delete_node(child1)
            gui.delete_node(child2)
            gui.delete_node(child3)
        end)

        it("Should handle horizontal_wrap layout correctly", function()
            local layout_node = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(120, 200, 0))
            local layout = druid:new_layout(layout_node)
            layout:set_type("horizontal_wrap")
            layout:set_margin(10, 10)

            -- Create nodes that will need to wrap
            local child1 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(50, 30, 0))
            local child2 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(50, 30, 0))
            local child3 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(50, 30, 0))
            local child4 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(50, 30, 0))

            layout:add(child1)
            layout:add(child2)
            layout:add(child3)
            layout:add(child4)

            layout:refresh_layout()

            -- Check positions - in horizontal_wrap layout, nodes should wrap to new line
            local pos1 = gui.get_position(child1)
            local pos2 = gui.get_position(child2)
            local pos3 = gui.get_position(child3)
            local pos4 = gui.get_position(child4)

            -- First two nodes should be on the same row
            assert(math.abs(pos1.y - pos2.y) < 0.001)

            -- child3 should be on a new row
            assert(pos3.y < pos1.y)

            -- child3 and child4 should be on the same row
            assert(math.abs(pos3.y - pos4.y) < 0.001)

            -- X position should flow left to right on each row
            assert(pos2.x > pos1.x)
            assert(pos4.x > pos3.x)

            druid:remove(layout)
            gui.delete_node(layout_node)
            gui.delete_node(child1)
            gui.delete_node(child2)
            gui.delete_node(child3)
            gui.delete_node(child4)
        end)

        it("Should correctly calculate size with content hugging", function()
            local layout_node = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(100, 100, 0))
            local layout = druid:new_layout(layout_node)
            layout:set_type("vertical")
            layout:set_hug_content(true, true)
            layout:set_margin(0, 10)
            layout:set_padding(5, 5, 5, 5)

            local child1 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(60, 30, 0))
            local child2 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(70, 30, 0))

            layout:add(child1)
            layout:add(child2)

            layout:refresh_layout()

            -- Size should be adjusted to fit content plus padding
            local size = gui.get_size(layout_node)

            -- Expected width: width of widest child (70) + left and right padding (5+5)
            assert(math.abs(size.x - 80) < 1)

            -- Expected height: sum of child heights (30+30) + margin (10) + top and bottom padding (5+5)
            assert(math.abs(size.y - 80) < 1)

            druid:remove(layout)
            gui.delete_node(layout_node)
            gui.delete_node(child1)
            gui.delete_node(child2)
        end)

        it("Should justify content horizontally", function()
            local layout_node = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(300, 100, 0))
            local layout = druid:new_layout(layout_node)
            layout:set_type("horizontal")
            layout:set_justify(true)

            local child1 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(50, 30, 0))
            local child2 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(50, 30, 0))

            layout:add(child1)
            layout:add(child2)

            layout:refresh_layout()

            -- Check positions - in justified horizontal layout, nodes should be spaced far apart
            local pos1 = gui.get_position(child1)
            local pos2 = gui.get_position(child2)

            -- Get the layout size and calculate expected positions
            local size = gui.get_size(layout_node)

            -- In justified layout, the distance between nodes should be larger than with normal layout
            assert((pos2.x - pos1.x) > 100)

            druid:remove(layout)
            gui.delete_node(layout_node)
            gui.delete_node(child1)
            gui.delete_node(child2)
        end)

        it("Should handle disabled nodes", function()
            local layout_node = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(300, 100, 0))
            local layout = druid:new_layout(layout_node)
            layout:set_type("horizontal")
            layout:set_margin(10, 0)

            local child1 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(50, 30, 0))
            local child2 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(50, 30, 0))
            local child3 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(50, 30, 0))

            layout:add(child1)
            layout:add(child2)
            layout:add(child3)

            -- Disable the middle node
            gui.set_enabled(child2, false)

            layout:refresh_layout()

            -- Check positions - the disabled node should be ignored in the layout
            local pos1 = gui.get_position(child1)
            local pos3 = gui.get_position(child3)

            -- child3 should be positioned right after child1 (as if child2 doesn't exist)
            local node_width = gui.get_size(child1).x
            local expected_gap = node_width + layout.margin.x

            -- The distance should be approximately the width of a node plus margin
            assert(math.abs((pos3.x - pos1.x) - expected_gap) < 1)

            druid:remove(layout)
            gui.delete_node(layout_node)
            gui.delete_node(child1)
            gui.delete_node(child2)
            gui.delete_node(child3)
        end)

        it("Should handle text nodes correctly", function()
            local layout_node = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(300, 100, 0))
            local layout = druid:new_layout(layout_node)
            layout:set_type("horizontal")
            layout:set_margin(10, 0)

            local text_node = gui.new_text_node(vmath.vector3(0, 0, 0), "Hello World")
            gui.set_font(text_node, "druid_text_bold")

            local box_node = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(50, 30, 0))

            layout:add(text_node)
            layout:add(box_node)

            layout:refresh_layout()

            -- Check positions - the text node should be positioned based on its text size
            local pos_text = gui.get_position(text_node)
            local pos_box = gui.get_position(box_node)

            assert(pos_box.x > pos_text.x)

            druid:remove(layout)
            gui.delete_node(layout_node)
            gui.delete_node(text_node)
            gui.delete_node(box_node)
        end)
    end)
end
