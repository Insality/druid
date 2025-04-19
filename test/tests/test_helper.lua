return function()
	describe("Helper Module", function()
		local helper = nil
		local const = nil
		local node1 = nil
		local node2 = nil

		before(function()
			helper = require("druid.helper")
			const = require("druid.const")

			-- Create actual GUI nodes for testing
			node1 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(100, 50, 0))
			node2 = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(60, 40, 0))
		end)

		after(function()
			-- Clean up nodes
			if node1 then gui.delete_node(node1) end
			if node2 then gui.delete_node(node2) end
		end)

		it("Should clamp values correctly", function()
			assert(helper.clamp(5, 0, 10) == 5)
			assert(helper.clamp(-5, 0, 10) == 0)
			assert(helper.clamp(15, 0, 10) == 10)
			assert(helper.clamp(5, 10, 0) == 5) -- Should swap min and max
			assert(helper.clamp(5, nil, 10) == 5) -- Should handle nil min
			assert(helper.clamp(15, nil, 10) == 10) -- Should handle nil min
			assert(helper.clamp(5, 0, nil) == 5) -- Should handle nil max
			assert(helper.clamp(-5, 0, nil) == 0) -- Should handle nil max
		end)

		it("Should calculate distance correctly", function()
			assert(helper.distance(0, 0, 3, 4) == 5)
			assert(helper.distance(1, 1, 4, 5) == 5)
			assert(helper.distance(0, 0, 0, 0) == 0)
		end)

		it("Should return sign correctly", function()
			assert(helper.sign(5) == 1)
			assert(helper.sign(-5) == -1)
			assert(helper.sign(0) == 0)
		end)

		it("Should round numbers correctly", function()
			assert(helper.round(5.5) == 6)
			assert(helper.round(5.4) == 5)
			assert(helper.round(5.55, 1) == 5.6)
			assert(helper.round(5.54, 1) == 5.5)
		end)

		it("Should lerp correctly", function()
			assert(helper.lerp(0, 10, 0) == 0)
			assert(helper.lerp(0, 10, 1) == 10)
			assert(helper.lerp(0, 10, 0.5) == 5)
		end)

		it("Should check if value is in array", function()
			local array = {1, 2, 3, 4, 5}
			assert(helper.contains(array, 3) == 3)
			assert(helper.contains(array, 6) == nil)
			assert(helper.contains({}, 1) == nil)
		end)

		it("Should deep copy tables", function()
			local original = {a = 1, b = {c = 2, d = {e = 3}}}
			local copy = helper.deepcopy(original)

			-- Test that it's a deep copy
			assert(copy.a == original.a)
			assert(copy.b.c == original.b.c)
			assert(copy.b.d.e == original.b.d.e)

			-- Modify the copy and check the original remains intact
			copy.a = 100
			copy.b.c = 200
			copy.b.d.e = 300

			assert(original.a == 1)
			assert(original.b.c == 2)
			assert(original.b.d.e == 3)
		end)

		it("Should add all elements from source array to target array", function()
			local target = {1, 2, 3}
			local source = {4, 5, 6}

			helper.add_array(target, source)
			assert(#target == 6)
			assert(target[4] == 4)
			assert(target[5] == 5)
			assert(target[6] == 6)

			-- Test with nil source
			local target2 = {1, 2, 3}
			helper.add_array(target2, nil)
			assert(#target2 == 3)
		end)

		it("Should insert with shift policy correctly", function()
			-- Test basic functionality
			-- RIGHT shift
			local array1 = {1, 2, 3, 4, 5}
			local result1 = helper.insert_with_shift(array1, 10, 3, const.SHIFT.RIGHT)
			assert(result1 == 10) -- Should return the inserted item
			assert(#array1 == 6) -- Size should increase
			assert(array1[3] == 10) -- Item should be at the specified position

			-- LEFT shift
			local array2 = {1, 2, 3, 4, 5}
			local result2 = helper.insert_with_shift(array2, 20, 3, const.SHIFT.LEFT)
			assert(result2 == 20) -- Should return the inserted item
			assert(#array2 >= 5) -- Size should be at least original size

			-- NO_SHIFT
			local array3 = {1, 2, 3, 4, 5}
			local result3 = helper.insert_with_shift(array3, 30, 3, const.SHIFT.NO_SHIFT)
			assert(result3 == 30) -- Should return the inserted item
			assert(array3[3] == 30) -- Should replace the value at the specified position
		end)

		it("Should remove with shift policy correctly", function()
			-- Test basic functionality
			-- RIGHT shift
			local array1 = {1, 2, 3, 4, 5}
			local removed1 = helper.remove_with_shift(array1, 3, const.SHIFT.RIGHT)
			assert(removed1 == 3) -- Should return the removed item
			assert(#array1 == 4) -- Size should decrease

			-- LEFT shift
			local array2 = {1, 2, 3, 4, 5}
			local removed2 = helper.remove_with_shift(array2, 3, const.SHIFT.LEFT)
			assert(removed2 == 3) -- Should return the removed item

			-- NO_SHIFT
			local array3 = {1, 2, 3, 4, 5}
			local removed3 = helper.remove_with_shift(array3, 3, const.SHIFT.NO_SHIFT)
			assert(removed3 == 3) -- Should return the removed item
			assert(array3[3] == nil) -- Position should be nil
			assert(array3[1] == 1 and array3[2] == 2 and array3[4] == 4 and array3[5] == 5) -- Other positions should be unchanged
		end)

		it("Should step values correctly", function()
			assert(helper.step(0, 10, 2) == 2)
			assert(helper.step(2, 10, 2) == 4)
			assert(helper.step(9, 10, 2) == 10)
			assert(helper.step(10, 0, 2) == 8)
			assert(helper.step(2, 0, 2) == 0)
			assert(helper.step(1, 0, 2) == 0)
		end)

		it("Should get node correctly", function()
			-- Create a node using real GUI function
			local test_node = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(100, 50, 0))
			gui.set_id(test_node, "test_node_unique_id")

			-- Test with node directly
			local result1 = helper.get_node(test_node)
			assert(result1 == test_node)

			-- Note: Dynamically created nodes can't be reliably retrieved by ID in tests
			-- but we can verify the function accepts string IDs
			-- local result3 = helper.get_node("some_id")
			-- We don't assert anything about result2, just make sure the function doesn't error

			-- Test with nodes table
			local dummy_node = {}
			local nodes_table = { ["template/test_node3"] = dummy_node }
			local result4 = helper.get_node("test_node3", "template", nodes_table)
			assert(result4 == dummy_node)

			-- Clean up
			gui.delete_node(test_node)
		end)

		it("Should get pivot offset correctly", function()
			-- Test with pivot constant
			local center_offset = helper.get_pivot_offset(gui.PIVOT_CENTER)
			assert(center_offset.x == 0)
			assert(center_offset.y == 0)

			-- Test North pivot
			local n_offset = helper.get_pivot_offset(gui.PIVOT_N)
			assert(n_offset.x == 0)
			assert(n_offset.y == 0.5)
		end)

		it("Should get scaled size correctly", function()
			local test_node = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(100, 50, 0))
			gui.set_scale(test_node, vmath.vector3(2, 3, 1))

			local scaled_size = helper.get_scaled_size(test_node)
			assert(scaled_size.x == 200)
			assert(scaled_size.y == 150)

			-- Clean up
			gui.delete_node(test_node)
		end)

		it("Should get scene scale correctly", function()
			local parent_node = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(100, 50, 0))
			gui.set_scale(parent_node, vmath.vector3(2, 2, 1))

			local child_node = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(50, 25, 0))
			gui.set_parent(child_node, parent_node)
			gui.set_scale(child_node, vmath.vector3(1.5, 1.5, 1))

			-- Without including the passed node scale
			local scale1 = helper.get_scene_scale(child_node, false)
			assert(scale1.x == 2)
			assert(scale1.y == 2)

			-- Including the passed node scale
			local scale2 = helper.get_scene_scale(child_node, true)
			assert(scale2.x == 3)
			assert(scale2.y == 3)

			-- Clean up
			gui.delete_node(child_node)
			gui.delete_node(parent_node)
		end)

		it("Should check if value is desktop/mobile/web correctly", function()
			-- These tests depend on the current system, so we just make sure the functions exist
			local is_desktop = helper.is_desktop()
			local is_mobile = helper.is_mobile()
			local is_web = helper.is_web()

			-- They should be boolean values
			assert(type(is_desktop) == "boolean")
			assert(type(is_mobile) == "boolean")
			assert(type(is_web) == "boolean")
		end)

		it("Should get border correctly", function()
			local test_node = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(100, 50, 0))
			gui.set_pivot(test_node, gui.PIVOT_CENTER)

			local border = helper.get_border(test_node)
			assert(border.x == -50) -- left
			assert(border.y == 25)  -- top
			assert(border.z == 50)  -- right
			assert(border.w == -25) -- bottom

			-- Test with offset
			local offset = vmath.vector3(10, 20, 0)
			local border_with_offset = helper.get_border(test_node, offset)
			assert(border_with_offset.x == -40) -- left + offset.x
			assert(border_with_offset.y == 45)  -- top + offset.y
			assert(border_with_offset.z == 60)  -- right + offset.x
			assert(border_with_offset.w == -5)  -- bottom + offset.y

			-- Clean up
			gui.delete_node(test_node)
		end)

		it("Should centrate nodes correctly", function()
			local total_width = helper.centrate_nodes(10, node1, node2)

			-- The total width should be node1 width + node2 width + margin
			assert(total_width == 170)

			-- The first node should be positioned at -total_width/2 + node1_width/2
			local pos1 = gui.get_position(node1)
			assert(pos1.x == -35) -- -170/2 + 100/2

			-- The second node should be positioned at pos1.x + node1_width/2 + margin + node2_width/2
			local pos2 = gui.get_position(node2)
			assert(pos2.x == 55) -- -35 + 100/2 + 10 + 60/2
		end)
	end)
end
