return function()
	describe("Button Component", function()
		local mock_gui = nil
		local mock_time = nil
		local mock_input = nil
		local test_helper = nil
		local druid_system = nil

		local druid = nil
		local context = nil

		before(function()
			mock_gui = require("deftest.mock.gui")
			mock_gui.mock()

			mock_time = require("deftest.mock.time")
			mock_input = require("test.helper.mock_input")
			test_helper = require("test.helper.test_helper")
			druid_system = require("druid.druid")

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

		it("Should do usual click", function()
			local button = mock_gui.add_box("button", 0, 0, 100, 50)
			local button_params = {}
			local on_click, on_click_mock = test_helper.get_function()
			local instance = druid:new_button(button, on_click, button_params)
			local is_clicked_pressed = druid:on_input(mock_input.click_pressed(10, 10))
			local is_clicked_released = druid:on_input(mock_input.click_released(20, 10))

			assert(is_clicked_pressed)
			assert(is_clicked_released)
			assert(on_click_mock.calls == 1)
			assert(on_click_mock.params[1] == context)
			assert(on_click_mock.params[2] == button_params)
			assert(on_click_mock.params[3] == instance)
		end)

		it("Should do long click if exists", function()
			local button = mock_gui.add_box("button", 0, 0, 100, 50)
			local button_params = {}
			local on_click, on_click_mock = test_helper.get_function()
			local on_long_click, on_long_click_mock = test_helper.get_function()

			local instance = druid:new_button(button, on_click, button_params)
			instance.on_long_click:subscribe(on_long_click)
			druid:on_input(mock_input.click_pressed(10, 10))
			mock_time.elapse(0.3)
			druid:on_input(mock_input.click_released(20, 10))

			assert(on_click_mock.calls == 1)
			assert(on_long_click_mock.calls == 0)

			druid:on_input(mock_input.click_pressed(10, 10))
			mock_time.elapse(1)
			druid:on_input(mock_input.click_released(20, 10))

			assert(on_click_mock.calls == 1)
			assert(on_long_click_mock.calls == 1)
			assert(on_long_click_mock.params[1] == context)
			assert(on_long_click_mock.params[2] == button_params)
			assert(on_long_click_mock.params[3] == instance)
		end)

		it("Should do not long click if not exists", function()
			local button = mock_gui.add_box("button", 0, 0, 100, 50)
			local button_params = {}
			local on_click, on_click_mock = test_helper.get_function()
			druid:new_button(button, on_click, button_params)
			druid:on_input(mock_input.click_pressed(10, 10))
			mock_time.elapse(0.5)
			druid:on_input(mock_input.click_released(20, 10))

			assert(on_click_mock.calls == 1)
		end)

		it("Should do double click if exists", function()
			local button = mock_gui.add_box("button", 0, 0, 100, 50)
			local button_params = {}
			local on_click, on_click_mock = test_helper.get_function()
			local on_double_click, on_double_click_mock = test_helper.get_function()

			local instance = druid:new_button(button, on_click, button_params)
			instance.on_double_click:subscribe(on_double_click)
			druid:on_input(mock_input.click_pressed(10, 10))
			druid:on_input(mock_input.click_released(20, 10))

			mock_time.elapse(0.1)
			druid:on_input(mock_input.click_pressed(10, 10))
			druid:on_input(mock_input.click_released(20, 10))

			assert(on_click_mock.calls == 1)
			assert(on_double_click_mock.calls == 1)
			assert(on_double_click_mock.params[1] == context)
			assert(on_double_click_mock.params[2] == button_params)
			assert(on_double_click_mock.params[3] == instance)

			mock_time.elapse(1)
			druid:on_input(mock_input.click_pressed(10, 10))
			druid:on_input(mock_input.click_released(20, 10))

			mock_time.elapse(0.5) -- The double click should not register, big time between clicks
			druid:on_input(mock_input.click_pressed(10, 10))
			druid:on_input(mock_input.click_released(20, 10))

			assert(on_click_mock.calls == 3)
			assert(on_double_click_mock.calls == 1)
		end)

		it("Should do not double click if not exists", function()
			local button = mock_gui.add_box("button", 0, 0, 100, 50)
			local button_params = {}
			local on_click, on_click_mock = test_helper.get_function()
			druid:new_button(button, on_click, button_params)

			druid:on_input(mock_input.click_pressed(10, 10))
			druid:on_input(mock_input.click_released(20, 10))
			mock_time.elapse(0.1)
			druid:on_input(mock_input.click_pressed(10, 10))
			druid:on_input(mock_input.click_released(20, 10))

			assert(on_click_mock.calls == 2)
		end)

		it("Should do hold click if exists", function()
			local button = mock_gui.add_box("button", 0, 0, 100, 50)
			local button_params = {}
			local on_click, on_click_mock = test_helper.get_function()
			local on_long_click, on_long_click_mock = test_helper.get_function()
			local on_hold_callback, on_hold_callback_mock = test_helper.get_function()
			local instance = druid:new_button(button, on_click, button_params)
			instance.on_long_click:subscribe(on_long_click) -- long click required for hold callback
			instance.on_hold_callback:subscribe(on_hold_callback)

			druid:on_input(mock_input.click_pressed(10, 10))
			mock_time.elapse(1) -- time between hold treshold and autorelease hold time
			druid:on_input(mock_input.input_empty(10, 10))

			pprint(on_long_click_mock)
			assert(on_click_mock.calls == 0)
			assert(on_long_click_mock.calls == 1)
			assert(on_long_click_mock.params[1] == context)
			assert(on_long_click_mock.params[2] == button_params)
			assert(on_long_click_mock.params[3] == instance)

			druid:on_input(mock_input.click_released(10, 10))

			assert(on_click_mock.calls == 0)
			assert(on_long_click_mock.calls == 1)
		end)

		it("Should do click outside if exists", function()
			local button = mock_gui.add_box("button", 0, 0, 100, 50)
			local button_params = {}
			local on_click = test_helper.get_function()
			local on_click_outside, on_click_outside_mock = test_helper.get_function()
			local instance = druid:new_button(button, on_click, button_params)
			instance.on_click_outside:subscribe(on_click_outside)

			druid:on_input(mock_input.click_pressed(-10, 10))
			druid:on_input(mock_input.click_released(-10, 10))

			assert(on_click_outside_mock.calls == 1)

			mock_time.elapse(1)
			druid:on_input(mock_input.click_pressed(10, 10))
			druid:on_input(mock_input.click_released(-10, 10))

			assert(on_click_outside_mock.calls == 2)
		end)

		it("Should not click if mouse was outside while clicking", function()
			local button = mock_gui.add_box("button", 0, 0, 100, 50)
			local button_params = {}
			local on_click, on_click_mock = test_helper.get_function()
			druid:new_button(button, on_click, button_params)

			druid:on_input(mock_input.click_pressed(10, 10))
			druid:on_input(mock_input.input_empty(-10, 10))
			druid:on_input(mock_input.click_released(20, 10))

			assert(on_click_mock.calls == 0)
		end)

		it("Should work with check function", function()
			local button = mock_gui.add_box("button", 0, 0, 100, 50)
			local button_params = {}
			local on_click, on_click_mock = test_helper.get_function()
			local instance = druid:new_button(button, on_click, button_params)
			local check_function, check_function_mock = test_helper.get_function(function() return false end)
			local failure_function, failure_function_mock = test_helper.get_function()
			instance:set_check_function(check_function, failure_function)

			druid:on_input(mock_input.click_pressed(10, 10))
			druid:on_input(mock_input.click_released(20, 10))

			assert(on_click_mock.calls == 0)
			assert(check_function_mock.calls == 1)
			assert(failure_function_mock.calls == 1)

			local check_true_function, check_function_true_mock = test_helper.get_function(function() return true end)
			instance:set_check_function(check_true_function, failure_function)

			mock_time.elapse(1)
			druid:on_input(mock_input.click_pressed(10, 10))
			druid:on_input(mock_input.click_released(20, 10))

			assert(on_click_mock.calls == 1)
			assert(check_function_true_mock.calls == 1)
			assert(failure_function_mock.calls == 1)
		end)

		it("Should have key trigger", function()
			local button = mock_gui.add_box("button", 0, 0, 100, 50)
			local button_params = {}
			local on_click, on_click_mock = test_helper.get_function()
			local instance = druid:new_button(button, on_click, button_params)
			instance:set_key_trigger("key_a")
			druid:on_input(mock_input.key_pressed("key_a"))
			druid:on_input(mock_input.key_released("key_a"))
			assert(on_click_mock.calls == 1)
			assert(instance:get_key_trigger() == hash("key_a"))
		end)

		it("Should work with click zone", function()
			local button = mock_gui.add_box("button", 0, 0, 100, 50)
			local zone = mock_gui.add_box("zone", 25, 25, 25, 25)
			local button_params = {}
			local on_click, on_click_mock = test_helper.get_function()
			local instance = druid:new_button(button, on_click, button_params)
			instance:set_click_zone(zone)
			druid:on_input(mock_input.click_pressed(10, 10))
			druid:on_input(mock_input.click_released(10, 10))
			assert(on_click_mock.calls == 0)

			druid:on_input(mock_input.click_pressed(25, 25))
			druid:on_input(mock_input.click_released(25, 25))
			assert(on_click_mock.calls == 1)
		end)

		it("Should work with set_enabled", function()
			local button = mock_gui.add_box("button", 0, 0, 100, 50)
			local button_params = {}
			local on_click, on_click_mock = test_helper.get_function()
			local instance = druid:new_button(button, on_click, button_params)

			instance:set_enabled(false)
			local is_clicked_pressed = druid:on_input(mock_input.click_pressed(10, 10))
			local is_clicked_released = druid:on_input(mock_input.click_released(10, 10))
			assert(is_clicked_pressed == true)
			assert(is_clicked_released == true)
			assert(on_click_mock.calls == 0)
			assert(instance:is_enabled() == false)

			instance:set_enabled(true)
			local is_clicked_pressed2 = druid:on_input(mock_input.click_pressed(10, 10))
			assert(is_clicked_pressed2 == true)
			local is_clicked_released2 = druid:on_input(mock_input.click_released(10, 10))
			assert(is_clicked_released2 == true)
			assert(on_click_mock.calls == 1)
			assert(instance:is_enabled() == true)
		end)
	end)
end
