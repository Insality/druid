return function()
	local mock_gui = nil
	local mock_time = nil
	local mock_input = nil
	local test_helper = nil
	local druid_system = nil

	local druid = nil
	local context = nil

	describe("Static Grid component", function()
		local parent = nil
		---@type druid.static_grid
		local grid = nil
		local prefab = nil

		before(function()
			mock_gui = require("deftest.mock.gui")
			mock_time = require("deftest.mock.time")
			mock_input = require("test.helper.mock_input")
			test_helper = require("test.helper.test_helper")
			druid_system = require("druid.druid")

			mock_gui.mock()
			mock_time.mock()
			mock_time.set(60)

			context = test_helper.get_context()
			druid = druid_system.new(context)

			parent = mock_gui.add_box("parent", 0, 0, 50, 50)
			prefab = mock_gui.add_box("prefab", 50, 50, 25, 25)
			grid = druid:new_static_grid(parent, prefab, 3)
		end)

		after(function()
			mock_gui.unmock()
			mock_time.unmock()
			druid:final(context)
			druid = nil
		end)

		it("Should add nodes", function()
			local nodes = {}
			for index = 1, 4 do
				local cloned = gui.clone(prefab)
				grid:add(cloned)
				table.insert(nodes, cloned)
			end
		end)
	end)
end
