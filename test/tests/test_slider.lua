return function()
	describe("Slider Component", function()
		local mock_time
		local druid_system

		local druid
		local context

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

		it("Should create slider and set value", function()
			local pin = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(20, 20, 0))
			local end_pos = vmath.vector3(100, 0, 0)
			local values = {}
			local slider = druid:new_slider(pin, end_pos, function(_, value)
				table.insert(values, value)
			end)

			slider:set(0.5)
			assert(math.abs(slider.value - 0.5) < 0.001)
			assert(#values == 1)
			assert(math.abs(values[1] - 0.5) < 0.001)
		end)

		it("Should support silent set", function()
			local pin = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(20, 20, 0))
			local calls = 0
			local slider = druid:new_slider(pin, vmath.vector3(100, 0, 0), function()
				calls = calls + 1
			end)

			slider:set(0.25, true)
			assert(math.abs(slider.value - 0.25) < 0.001)
			assert(calls == 0)
		end)

		it("Should set steps", function()
			local pin = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(20, 20, 0))
			local slider = druid:new_slider(pin, vmath.vector3(100, 0, 0))
			slider:set_steps({ 0, 0.5, 1 })
			assert(#slider.steps == 3)
			assert(slider.steps[2] == 0.5)
		end)

		it("Should set end position", function()
			local pin = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(20, 20, 0))
			local slider = druid:new_slider(pin, vmath.vector3(100, 0, 0))
			slider:set(1)
			slider:set_end_pos(vmath.vector3(200, 0, 0))
			assert(slider.end_pos.x == 200)
		end)

		it("Should enable and disable", function()
			local pin = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(20, 20, 0))
			local slider = druid:new_slider(pin, vmath.vector3(100, 0, 0))
			slider:set_enabled(false)
			assert(slider:is_enabled() == false)
			slider:set_enabled(true)
			assert(slider:is_enabled() == true)
		end)
	end)
end
