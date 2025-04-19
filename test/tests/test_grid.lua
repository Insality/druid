return function()
    describe("Grid Component", function()
        local mock_time
        local mock_input
        local druid_system

        local druid
        local context

        local function create_grid_instance(in_row)
            local parent_node = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(300, 300, 0))
            local item_node = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(50, 50, 0))
            gui.set_enabled(item_node, false)

            local instance = druid:new_grid(parent_node, item_node, in_row or 3)
            return instance, parent_node, item_node
        end

        local function create_item_nodes(count)
            local nodes = {}
            for i = 1, count do
                local node = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(50, 50, 0))
                table.insert(nodes, node)
            end
            return nodes
        end

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

        it("Should create grid component", function()
            local grid = create_grid_instance()

            assert(grid ~= nil)
            assert(grid.add ~= nil)
            assert(grid.remove ~= nil)
            assert(grid.clear ~= nil)
            assert(grid.set_in_row ~= nil)
        end)

        it("Should add nodes to grid", function()
            local grid = create_grid_instance()
            local node1 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(50, 50, 0))
            local node2 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(50, 50, 0))

            grid:add(node1)
            grid:add(node2)

            assert(#grid.nodes == 2)
        end)

        it("Should position nodes in a grid layout", function()
            local grid = create_grid_instance(3)
            local nodes = create_item_nodes(5)

            for i, node in ipairs(nodes) do
                grid:add(node)
            end

            -- After adding to grid, nodes should be positioned
            -- First row: nodes 1,2,3; Second row: nodes 4,5

            -- Get actual node positions
            local pos1 = gui.get_position(nodes[1])
            local pos2 = gui.get_position(nodes[2])
            local pos3 = gui.get_position(nodes[3])
            local pos4 = gui.get_position(nodes[4])

            -- Check row arrangement
            assert(math.abs(pos1.y - pos2.y) < 1) -- Same row (y position)
            assert(math.abs(pos2.y - pos3.y) < 1) -- Same row (y position)
            assert(pos1.y > pos4.y) -- Second row below first row

            -- Check column arrangement
            assert(pos1.x < pos2.x) -- Left to right
            assert(pos2.x < pos3.x) -- Left to right
        end)

        it("Should remove node from grid", function()
            local grid = create_grid_instance()
            local nodes = create_item_nodes(3)

            for i, node in ipairs(nodes) do
                grid:add(node)
            end

            assert(#grid.nodes == 3)

            grid:remove(2)
            assert(#grid.nodes == 2)
            assert(grid.nodes[1] == nodes[1])
            assert(grid.nodes[2] == nodes[3])
        end)

        it("Should clear all nodes", function()
            local grid = create_grid_instance()
            local nodes = create_item_nodes(5)

            for i, node in ipairs(nodes) do
                grid:add(node)
            end

            assert(#grid.nodes == 5)

            grid:clear()
            assert(#grid.nodes == 0)
        end)

        it("Should set new in_row value", function()
            local grid = create_grid_instance(2)
            local nodes = create_item_nodes(4)

            for i, node in ipairs(nodes) do
                grid:add(node)
            end

            -- With 2 items in row, the nodes should be arranged in 2 rows
            local pos1 = gui.get_position(nodes[1])
            local pos2 = gui.get_position(nodes[2])
            local pos3 = gui.get_position(nodes[3])
            local pos4 = gui.get_position(nodes[4])

            -- Initially 2 items per row: nodes 1,2 in first row; nodes 3,4 in second row
            assert(math.abs(pos1.y - pos2.y) < 1) -- Same row
            assert(math.abs(pos3.y - pos4.y) < 1) -- Same row
            assert(pos1.y > pos3.y) -- Second row below first row

            -- Change to 4 items in a row
            grid:set_in_row(4)

            -- Get updated positions
            pos1 = gui.get_position(nodes[1])
            pos2 = gui.get_position(nodes[2])
            pos3 = gui.get_position(nodes[3])
            pos4 = gui.get_position(nodes[4])

            -- All items should now be in one row
            assert(math.abs(pos1.y - pos2.y) < 1)
            assert(math.abs(pos2.y - pos3.y) < 1)
            assert(math.abs(pos3.y - pos4.y) < 1)
        end)

        it("Should set item size", function()
            local grid = create_grid_instance()
            local nodes = create_item_nodes(4)

            for i, node in ipairs(nodes) do
                grid:add(node)
            end

            -- Get initial positions
            local initial_pos1 = gui.get_position(nodes[1])
            local initial_pos2 = gui.get_position(nodes[2])
            local initial_distance = initial_pos2.x - initial_pos1.x

            -- Now set bigger size
            grid:set_item_size(100, 100)

            -- Get new positions
            local new_pos1 = gui.get_position(nodes[1])
            local new_pos2 = gui.get_position(nodes[2])
            local new_distance = new_pos2.x - new_pos1.x

            -- Nodes should be further apart with larger size
            assert(new_distance > initial_distance)
        end)

        it("Should set grid pivot", function()
            local grid = create_grid_instance()
            local nodes = create_item_nodes(4)

            for i, node in ipairs(nodes) do
                grid:add(node)
            end

            -- Get initial positions
            local initial_positions = {}
            for i, node in ipairs(nodes) do
                initial_positions[i] = vmath.vector3(gui.get_position(node))
            end

            -- Change pivot from default to different value
            grid:set_pivot(gui.PIVOT_NW)

            -- Get new positions
            local positions_changed = false
            for i, node in ipairs(nodes) do
                local new_pos = gui.get_position(node)
                if new_pos.x ~= initial_positions[i].x or new_pos.y ~= initial_positions[i].y then
                    positions_changed = true
                    break
                end
            end

            -- At least one node position should change
            assert(positions_changed)
        end)

        it("Should get grid size", function()
            local grid = create_grid_instance(2)
            local nodes = create_item_nodes(4)

            for i, node in ipairs(nodes) do
                grid:add(node)
            end

            local size = grid:get_size()

            -- Grid with 2x2 arrangement of 50x50 items should be around 100x100
            -- (with spacing and potential other factors)
            assert(size.x >= 100)
            assert(size.y >= 100)
        end)

        it("Should get index by node", function()
            local grid = create_grid_instance()
            local nodes = create_item_nodes(3)

            for i, node in ipairs(nodes) do
                grid:add(node)
            end

            local index = grid:get_index_by_node(nodes[2])
            assert(index == 2)

            -- Should return nil for node not in grid
            local outside_node = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(50, 50, 0))
            local outside_index = grid:get_index_by_node(outside_node)
            assert(outside_index == nil)
        end)

        it("Should adjust spacing when changing node size", function()
            local grid = create_grid_instance(3)
            local nodes = create_item_nodes(6)

            for i, node in ipairs(nodes) do
                grid:add(node)
            end

            -- Get initial distance between nodes
            local pos1 = gui.get_position(nodes[1])
            local pos2 = gui.get_position(nodes[2])
            local horizontal_spacing = pos2.x - pos1.x

            local pos1 = gui.get_position(nodes[1])
            local pos4 = gui.get_position(nodes[4])
            local vertical_spacing = pos1.y - pos4.y

            -- Change node size (this should affect spacing)
            grid:set_item_size(75, 75)

            -- Get new spacing
            local new_pos1 = gui.get_position(nodes[1])
            local new_pos2 = gui.get_position(nodes[2])
            local new_horizontal_spacing = new_pos2.x - new_pos1.x

            local new_pos1 = gui.get_position(nodes[1])
            local new_pos4 = gui.get_position(nodes[4])
            local new_vertical_spacing = new_pos1.y - new_pos4.y

            -- Both spacings should be larger with larger node size
            assert(new_horizontal_spacing > horizontal_spacing)
            assert(new_vertical_spacing > vertical_spacing)
        end)
    end)
end
