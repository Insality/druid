local mock_gui = require("deftest.mock.gui")
local mock_time = require("deftest.mock.time")
local mock_input = require("test.helper.mock_input")
local test_helper = require("test.helper.test_helper")
local druid_system = require("druid.druid")


return function()
	local druid = nil
	local context = test_helper.get_context()
	describe("Druid Button", function()
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
			mock_time.elapse(0.5)
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

			print(on_click_mock.calls, on_double_click_mock.calls)
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
	end)
end
