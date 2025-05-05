return function()
    describe("Container Component", function()
        local mock_time
        local mock_input
        local druid_system
        local const

        local druid
        local context

        before(function()
            mock_time = require("deftest.mock.time")
            mock_input = require("test.helper.mock_input")
            druid_system = require("druid.druid")
            const = require("druid.const")

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


        it("Should initialize container with default settings", function()
            local container_node = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(100, 100, 0))
            local container = druid:new_container(container_node)

            assert(container ~= nil)
            assert(container.node == container_node)
            assert(container.origin_size.x == 100)
            assert(container.origin_size.y == 100)
            assert(container.size.x == 100)
            assert(container.size.y == 100)
            assert(container.mode == const.LAYOUT_MODE.FIT)
            assert(container.min_size_x == 0)
            assert(container.min_size_y == 0)
            assert(container.max_size_x == nil)
            assert(container.max_size_y == nil)
            assert(container._containers ~= nil)
            assert(#container._containers == 0)

            druid:remove(container)
            gui.delete_node(container_node)
        end)

        it("Should get and set size", function()
            local container_node = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(100, 100, 0))
            local container = druid:new_container(container_node)

            local size = container:get_size()
            assert(size.x == 100)
            assert(size.y == 100)

            container:set_size(200, 150)

            size = container:get_size()
            assert(size.x == 200)
            assert(size.y == 150)

            local node_size = gui.get_size(container_node)
            assert(node_size.x == 200)
            assert(node_size.y == 150)

            druid:remove(container)
            gui.delete_node(container_node)
        end)

        it("Should get and set position", function()
            local container_node = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(100, 100, 0))
            local container = druid:new_container(container_node)

            local position = container:get_position()
            assert(position.x == 50)
            assert(position.y == 50)

            container:set_position(100, 200)

            position = container:get_position()
            assert(position.x == 100)
            assert(position.y == 200)

            local node_position = gui.get_position(container_node)
            assert(node_position.x == 100)
            assert(node_position.y == 200)

            druid:remove(container)
            gui.delete_node(container_node)
        end)

        it("Should set pivot", function()
            local container_node = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(100, 100, 0))
            local container = druid:new_container(container_node)

            -- Default pivot is typically PIVOT_CENTER
            local initial_pivot = gui.get_pivot(container_node)

            container:set_pivot(gui.PIVOT_NW)
            assert(gui.get_pivot(container_node) == gui.PIVOT_NW)

            container:set_pivot(gui.PIVOT_SE)
            assert(gui.get_pivot(container_node) == gui.PIVOT_SE)

            druid:remove(container)
            gui.delete_node(container_node)
        end)

        it("Should set min size", function()
            local container_node = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(100, 100, 0))
            local container = druid:new_container(container_node)

            assert(container.min_size_x == 0)
            assert(container.min_size_y == 0)

            container:set_min_size(50, 75)

            assert(container.min_size_x == 50)
            assert(container.min_size_y == 75)

            -- Should respect min size when setting smaller size
            container:set_size(25, 25)
            local size = container:get_size()
            assert(size.x == 50)
            assert(size.y == 75)

            -- Should allow larger size
            container:set_size(200, 200)
            size = container:get_size()
            assert(size.x == 200)
            assert(size.y == 200)

            druid:remove(container)
            gui.delete_node(container_node)
        end)

        it("Should set max size", function()
            local container_node = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(100, 100, 0))
            local container = druid:new_container(container_node)

            assert(container.max_size_x == nil)
            assert(container.max_size_y == nil)

            container:set_max_size(150, 200)

            assert(container.max_size_x == 150)
            assert(container.max_size_y == 200)

            -- Should respect max size when setting larger size
            container:set_size(300, 300)
            local size = container:get_size()
            assert(size.x == 150)
            assert(size.y == 200)

            -- Should allow smaller size
            container:set_size(100, 100)
            size = container:get_size()
            assert(size.x == 100)
            assert(size.y == 100)

            druid:remove(container)
            gui.delete_node(container_node)
        end)
        
        it("Should fire on_size_changed event", function()
            local container_node = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(100, 100, 0))
            local container = druid:new_container(container_node)

            local on_size_changed_calls = 0
            local last_size = nil

            container.on_size_changed:subscribe(function(instance, new_size)
                on_size_changed_calls = on_size_changed_calls + 1
                last_size = new_size
            end)

            container:set_size(200, 150)

            assert(on_size_changed_calls == 1)
            assert(last_size ~= nil)
            assert(last_size.x == 200)
            assert(last_size.y == 150)

            druid:remove(container)
            gui.delete_node(container_node)
        end)

        it("Should fit into custom size", function()
            local container_node = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(100, 100, 0))
            local container = druid:new_container(container_node, const.LAYOUT_MODE.STRETCH)

            local fit_size = vmath.vector3(200, 150, 0)
            container:fit_into_size(fit_size)

            assert(container.fit_size == fit_size)

            -- The exact result will depend on the implementation and screen aspect ratio,
            -- but we can at least verify it changes the size
            local size = container:get_size()
            assert(size.x > 100 or size.y > 100)

            druid:remove(container)
            gui.delete_node(container_node)
        end)

        it("Should create and manage parent-child container relationships", function()
            local parent_node = gui.new_box_node(vmath.vector3(400, 300, 0), vmath.vector3(800, 600, 0))
            local child_node = gui.new_box_node(vmath.vector3(100, 100, 0), vmath.vector3(200, 200, 0))

            local parent_container = druid:new_container(parent_node)

            -- Add a child container through the parent
            local child_container = parent_container:add_container(child_node)

            assert(child_container ~= nil)
            assert(child_container.node == child_node)
            assert(child_container._parent_container == parent_container)
            assert(#parent_container._containers == 1)
            assert(parent_container._containers[1] == child_container)

            -- Verify the child's node has been parented correctly
            assert(gui.get_parent(child_node) == parent_node)

            -- Remove the child container
            parent_container:remove_container_by_node(child_node)

            assert(#parent_container._containers == 0)

            druid:remove(parent_container)
            gui.delete_node(parent_node)
            gui.delete_node(child_node)
        end)

        it("Should handle different layout modes", function()
            local parent_node = gui.new_box_node(vmath.vector3(400, 300, 0), vmath.vector3(800, 600, 0))
            local child_node = gui.new_box_node(vmath.vector3(100, 100, 0), vmath.vector3(200, 200, 0))

            local parent_container = druid:new_container(parent_node)

            -- Test FIT mode
            local child_fit = parent_container:add_container(child_node, const.LAYOUT_MODE.FIT)
            assert(child_fit.mode == const.LAYOUT_MODE.FIT)

            local size_fit = child_fit:get_size()
            local original_size = vmath.vector3(200, 200, 0)

            -- Size should remain the same in FIT mode
            assert(math.abs(size_fit.x - original_size.x) < 0.001)
            assert(math.abs(size_fit.y - original_size.y) < 0.001)

            -- Set to STRETCH mode
            parent_container:remove_container_by_node(child_node)
            local child_stretch = parent_container:add_container(child_node, const.LAYOUT_MODE.STRETCH)
            assert(child_stretch.mode == const.LAYOUT_MODE.STRETCH)

            -- Set to STRETCH_X mode
            parent_container:remove_container_by_node(child_node)
            local child_stretch_x = parent_container:add_container(child_node, const.LAYOUT_MODE.STRETCH_X)
            assert(child_stretch_x.mode == const.LAYOUT_MODE.STRETCH_X)

            -- Set to STRETCH_Y mode
            parent_container:remove_container_by_node(child_node)
            local child_stretch_y = parent_container:add_container(child_node, const.LAYOUT_MODE.STRETCH_Y)
            assert(child_stretch_y.mode == const.LAYOUT_MODE.STRETCH_Y)

            druid:remove(parent_container)
            gui.delete_node(parent_node)
            gui.delete_node(child_node)
        end)

        it("Should create and clear draggable corners", function()
            local container_node = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(100, 100, 0))
            local container = druid:new_container(container_node)

            container:create_draggable_corners()

            assert(#container._draggable_corners > 0)

            container:clear_draggable_corners()

            assert(#container._draggable_corners == 0)

            druid:remove(container)
            gui.delete_node(container_node)
        end)

        it("Should set size and maintain anchor pivot position", function()
            local container_node = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(100, 100, 0))
            local container = druid:new_container(container_node)

            -- Set pivot to NW corner
            container:set_pivot(gui.PIVOT_NW)
            local initial_position = gui.get_position(container_node)

            -- Change size with anchor_pivot=PIVOT_NW - the NW corner should stay at the same position
            container:set_size(200, 150, gui.PIVOT_NW)

            local new_position = gui.get_position(container_node)
            assert(math.abs(new_position.x - initial_position.x) < 0.001)
            assert(math.abs(new_position.y - initial_position.y) < 0.001)

            -- Set pivot to SE corner
            container:set_pivot(gui.PIVOT_SE)
            initial_position = gui.get_position(container_node)

            -- Change size with anchor_pivot=PIVOT_SE - the SE corner should stay at the same position
            container:set_size(300, 250, gui.PIVOT_SE)

            new_position = gui.get_position(container_node)
            assert(math.abs(new_position.x - initial_position.x) < 0.001)
            assert(math.abs(new_position.y - initial_position.y) < 0.001)

            druid:remove(container)
            gui.delete_node(container_node)
        end)

        it("Should refresh origins", function()
            local container_node = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(100, 100, 0))
            local container = druid:new_container(container_node)

            -- Change the node size and position directly
            gui.set_size(container_node, vmath.vector3(200, 150, 0))
            gui.set_position(container_node, vmath.vector3(75, 75, 0))

            -- The container's internal origin values should not have updated yet
            assert(container.origin_size.x == 100)
            assert(container.origin_size.y == 100)
            assert(container.origin_position.x == 50)
            assert(container.origin_position.y == 50)

            -- Refresh origins
            container:refresh_origins()

            -- Now the origin values should match the node
            assert(container.origin_size.x == 200)
            assert(container.origin_size.y == 150)
            assert(container.origin_position.x == 75)
            assert(container.origin_position.y == 75)

            druid:remove(container)
            gui.delete_node(container_node)
        end)
    end)
end
