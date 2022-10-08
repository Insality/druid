local mock_gui = require "deftest.mock.gui"
local mock_time = require("deftest.mock.time")
local mock_input = require("test.helper.mock_input")
local test_helper = require("test.helper.test_helper")
local druid_system = require("druid.druid")

return function()
	local druid = nil
	local context = test_helper.get_context()
	describe("Hover component", function()
		before(function()
			mock_gui.mock()
			mock_time.mock()
			mock_time.set(60)
			druid = druid_system.new(context)
		end)

		after(function()
			mock_gui.unmock()
			mock_time.unmock()
			druid:final(context)
			druid = nil
		end)

		it("Should fire callback on touch hover and unhover", function()
			local button = mock_gui.add_box("button", 0, 0, 100, 50)
			local is_hovered = false
			local on_hover, on_hover_mock = test_helper.get_function(function(_, state)
				is_hovered = state
			end)
			local instance = druid:new_hover(button, on_hover)
			druid:on_input(mock_input.input_empty(10, 10))
			assert(is_hovered == true)
			assert(instance:is_hovered() == true)
			assert(instance:is_mouse_hovered() == false)

			druid:on_input(mock_input.input_empty(-10, 10))
			assert(is_hovered == false)
			assert(instance:is_hovered() == false)
			assert(instance:is_mouse_hovered() == false)
		end)

		it("Should fire callback on mouse hover and unhover", function()
			local button = mock_gui.add_box("button", 0, 0, 100, 50)
			local is_hovered = false
			local on_hover, on_hover_mock = test_helper.get_function(function(_, state)
				is_hovered = state
			end)

			local instance = druid:new_hover(button)
			instance.on_mouse_hover:subscribe(on_hover)
			druid:on_input(mock_input.input_empty_action_nil(10, 10))
			assert(is_hovered == true)
			assert(instance:is_hovered() == false)
			assert(instance:is_mouse_hovered() == true)

			druid:on_input(mock_input.input_empty_action_nil(-10, 10))
			assert(is_hovered == false)
			assert(instance:is_hovered() == false)
			assert(instance:is_mouse_hovered() == false)
		end)

		it("Should work with click zone", function()
			local button = mock_gui.add_box("button", 0, 0, 100, 50)
			local zone = mock_gui.add_box("zone", 25, 25, 25, 25)
			local on_hover, on_hover_mock = test_helper.get_function()
			local instance = druid:new_hover(button, on_hover)
			instance:set_click_zone(zone)
			druid:on_input(mock_input.input_empty(10, 10))
			assert(instance:is_hovered() == false)

			druid:on_input(mock_input.input_empty(25, 25))
			assert(instance:is_hovered() == true)

			druid:on_input(mock_input.input_empty(24, 24))
			assert(instance:is_hovered() == false)
		end)

		it("Should have set_enabled function", function()
			local button = mock_gui.add_box("button", 0, 0, 100, 50)
			local on_hover, on_hover_mock = test_helper.get_function()
			local instance = druid:new_hover(button, on_hover)

			druid:on_input(mock_input.input_empty(10, 10))
			assert(instance:is_hovered() == true)

			instance:set_enabled(false)
			assert(instance:is_hovered() == false)
			druid:on_input(mock_input.input_empty(12, 12))
			assert(instance:is_hovered() == false)

			instance:set_enabled(true)
			druid:on_input(mock_input.input_empty(12, 12))
			assert(instance:is_hovered() == true)

			druid:on_input(mock_input.input_empty(-10, 10))
			assert(instance:is_hovered() == false)
		end)
	end)
end
