return function()
	describe("Data List Component", function()
		local mock_time
		local druid_system

		local druid
		local context

		local function create_data_list()
			local view = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(100, 200, 0))
			local content = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(100, 200, 0))
			gui.set_parent(content, view)

			local scroll = druid:new_scroll(view, content)
			local prefab = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(100, 40, 0))
			gui.set_enabled(prefab, false)
			local grid = druid:new_grid(content, prefab, 1)

			local created = {}
			local data_list = druid:new_data_list(scroll, grid, function(_, data, index)
				local node = gui.clone(prefab)
				gui.set_enabled(node, true)
				created[index] = { node = node, data = data }
				return node
			end)

			return data_list, created, scroll
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

		it("Should create data list and set data", function()
			local data_list = create_data_list()
			local data = {}
			for i = 1, 20 do
				data[i] = { id = i }
			end

			data_list:set_data(data)

			assert(#data_list:get_data() == 20)
			assert(data_list.top_index >= 1)
			assert(data_list.last_index >= data_list.top_index)
		end)

		it("Should not recreate visuals when scroll range is unchanged", function()
			local data_list, created, scroll = create_data_list()
			local data = {}
			for i = 1, 30 do
				data[i] = { id = i }
			end
			data_list:set_data(data)

			local first_visual = data_list:get_created_nodes()
			local first_count = 0
			for _ in pairs(first_visual) do
				first_count = first_count + 1
			end

			-- Tiny scroll that keeps the same visible index range
			scroll.position.y = scroll.position.y + 0.1
			scroll.on_scroll:trigger(context, scroll.position)

			local second_visual = data_list:get_created_nodes()
			local second_count = 0
			for index in pairs(second_visual) do
				second_count = second_count + 1
				assert(first_visual[index] == second_visual[index])
			end
			assert(first_count == second_count)
		end)

		it("Should support cache mode", function()
			local data_list = create_data_list()
			data_list:set_use_cache(true)

			local data = {}
			for i = 1, 10 do
				data[i] = { id = i }
			end
			data_list:set_data(data)
			assert(data_list._is_use_cache == true)
		end)

		it("Should keep every visible index filled with duplicated data values", function()
			local data_list = create_data_list()
			data_list:set_use_cache(true)

			-- Equal values compare as equal, so relocation must not steal a still valid element
			local data = {}
			for i = 1, 20 do
				data[i] = (i % 2 == 0) and "even" or "odd"
			end
			data_list:set_data(data)
			data_list:remove(1)

			local nodes = data_list:get_created_nodes()
			for index = data_list.top_index, data_list.last_index do
				assert(nodes[index] ~= nil)
			end
		end)

		it("Should add and remove data", function()
			local data_list = create_data_list()
			data_list:set_data({ { id = 1 }, { id = 2 } })
			data_list:add({ id = 3 })
			assert(#data_list:get_data() == 3)

			data_list:remove(2)
			assert(#data_list:get_data() == 2)
			assert(data_list:get_data()[1].id == 1)
			assert(data_list:get_data()[2].id == 3)
		end)
	end)
end
