return function()
	local mock_gui = nil
	local mock_time = nil
	local mock_input = nil
	local test_helper = nil
	local druid_system = nil

	local druid = nil
	local context = nil

	describe("Blocker component", function()
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
		end)

		after(function()
			mock_gui.unmock()
			mock_time.unmock()
			druid:final(context)
			druid = nil
		end)

		it("Should consume input", function()
			local button_node = mock_gui.add_box("button", 0, 0, 100, 50)
			local blocker_node = mock_gui.add_box("blocker", 20, 20, 20, 20)
			local on_click, on_click_mock = test_helper.get_function()

			druid:new_button(button_node, on_click)
			druid:new_blocker(blocker_node)

			druid:on_input(mock_input.click_pressed(10, 10))
			druid:on_input(mock_input.click_released(10, 10))
			assert(on_click_mock.calls == 1)

			-- Click should been consumed by blocker component
			druid:on_input(mock_input.click_pressed(20, 20))
			druid:on_input(mock_input.click_released(20, 20))
			assert(on_click_mock.calls == 1)

			-- If move from button to blocker, should consume too
			druid:on_input(mock_input.click_pressed(10, 10))
			druid:on_input(mock_input.click_released(20, 20))
			assert(on_click_mock.calls == 1)

			-- And from blocker to button too
			druid:on_input(mock_input.click_pressed(20, 20))
			druid:on_input(mock_input.click_released(10, 10))
			assert(on_click_mock.calls == 1)
		end)

		it("Should be disabled via node or set_enabled", function()
			local button_node = mock_gui.add_box("button", 0, 0, 100, 50)
			local blocker_node = mock_gui.add_box("blocker", 20, 20, 20, 20)
			local on_click, on_click_mock = test_helper.get_function()

			druid:new_button(button_node, on_click)
			local blocker = druid:new_blocker(blocker_node)

			-- Click should been consumed by blocker component
			druid:on_input(mock_input.click_pressed(20, 20))
			druid:on_input(mock_input.click_released(20, 20))
			assert(on_click_mock.calls == 0)

			-- Disable blocker component
			blocker:set_enabled(false)
			druid:on_input(mock_input.click_pressed(20, 20))
			druid:on_input(mock_input.click_released(20, 20))
			assert(gui.is_enabled(blocker_node) == true)
			assert(blocker:is_enabled() == false)
			assert(on_click_mock.calls == 1)

			-- Disable blocker node component
			blocker:set_enabled(true)
			gui.set_enabled(blocker_node, false)
			druid:on_input(mock_input.click_pressed(20, 20))
			druid:on_input(mock_input.click_released(20, 20))
			assert(gui.is_enabled(blocker_node) == false)
			assert(blocker:is_enabled() == true)
			assert(on_click_mock.calls == 2)

			-- Return state
			gui.set_enabled(blocker_node, true)
			druid:on_input(mock_input.click_pressed(20, 20))
			druid:on_input(mock_input.click_released(20, 20))
			assert(gui.is_enabled(blocker_node) == true)
			assert(blocker:is_enabled() == true)
			assert(on_click_mock.calls == 2)
		end)
	end)
end
