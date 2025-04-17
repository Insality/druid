return function()
	describe("Blocker component", function()
		local mock_time
		local mock_input
		local druid_system

		local druid ---@type druid.instance
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

		it("Should consume input", function()
			local button_node = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(100, 100, 0))
			local blocker_node = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(20, 20, 0))
			local on_click_calls = 0

			druid:new_button(button_node, function()
				on_click_calls = on_click_calls + 1
			end)
			druid:new_blocker(blocker_node)

			druid:on_input(mock_input.click_pressed(40, 40))
			druid:on_input(mock_input.click_released(40, 40))
			assert(on_click_calls == 1)

			-- Click should been consumed by blocker component
			druid:on_input(mock_input.click_pressed(0, 0))
			druid:on_input(mock_input.click_released(0, 0))
			assert(on_click_calls == 1)

			-- If move from button to blocker, should consume too
			druid:on_input(mock_input.click_pressed(40, 40))
			druid:on_input(mock_input.click_released(0, 0))
			assert(on_click_calls == 1)

			-- And from blocker to button too
			druid:on_input(mock_input.click_pressed(0, 0))
			druid:on_input(mock_input.click_released(40, 40))
			assert(on_click_calls == 1)

			-- Usual click after that should work
			druid:on_input(mock_input.click_pressed(40, 40))
			druid:on_input(mock_input.click_released(40, 40))
			assert(on_click_calls == 2)
		end)

		it("Should be disabled via set_enabled", function()
			local button_node = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(100, 100, 0))
			local blocker_node = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(20, 20, 0))
			local on_click_calls = 0

			druid:new_button(button_node, function()
				on_click_calls = on_click_calls + 1
			end)
			local blocker = druid:new_blocker(blocker_node)

			-- Click should been consumed by blocker component
			druid:on_input(mock_input.click_pressed(0, 0))
			druid:on_input(mock_input.click_released(0, 0))
			assert(on_click_calls == 0)

			-- Disable blocker component
			blocker:set_enabled(false)
			druid:on_input(mock_input.click_pressed(0, 0))
			druid:on_input(mock_input.click_released(0, 0))
			assert(blocker:is_enabled() == false)
			assert(on_click_calls == 1)

			-- Enable blocker component again
			blocker:set_enabled(true)
			druid:on_input(mock_input.click_pressed(0, 0))
			druid:on_input(mock_input.click_released(0, 0))
			assert(blocker:is_enabled() == true)
			assert(on_click_calls == 1)
		end)
	end)
end
