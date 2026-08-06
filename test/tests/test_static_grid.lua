return function()
	describe("Static Grid Component", function()
		local mock_time
		local druid_system

		local druid
		local context

		local function create_grid(in_row)
			local parent = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(300, 300, 0))
			local prefab = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(50, 50, 0))
			gui.set_enabled(prefab, false)
			return druid:new_grid(parent, prefab, in_row or 3), parent, prefab
		end

		before(function()
			mock_time = require("deftest.mock.time")
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

		it("Should calculate index from position", function()
			local grid = create_grid(3)
			local node = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(50, 50, 0))
			grid:add(node)

			local pos = grid:get_pos(1)
			local index = grid:get_index(pos)
			assert(index == 1)
		end)

		it("Should return content size for count", function()
			local grid = create_grid(2)
			local size = grid:get_size_for(4)
			assert(size.x > 0)
			assert(size.y > 0)
		end)
	end)
end
