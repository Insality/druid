return function()
	local mock_gui = require "deftest.mock.gui"
	local mock_time = require("deftest.mock.time")
	local mock_input = require("test.helper.mock_input")
	local test_helper = require("test.helper.test_helper")
	local druid_system = require("druid.druid")

	local druid = nil
	local context = test_helper.get_context()

	local function create_drag_instance(on_drag)
		local button = mock_gui.add_box("button", 0, 0, 20, 20)
		local instance = druid:new_drag(button, on_drag)
		instance.style.NO_USE_SCREEN_KOEF = true
		instance.style.DRAG_DEADZONE = 4
		return instance
	end

	describe("Drag component", function()
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

		it("Should call drag callback on node", function()
			local on_drag, on_drag_mock = test_helper.get_function()
			local instance = create_drag_instance(on_drag)

			druid:on_input(mock_input.click_pressed(10, 10))
			assert(instance.is_touch == true)

			druid:on_input(mock_input.input_empty(12, 10))
			assert(on_drag_mock.calls == 0)

			druid:on_input(mock_input.input_empty(14, 10))
			assert(on_drag_mock.calls == 1)
			assert(on_drag_mock.params[2] == 2) -- From the last input dx
			assert(on_drag_mock.params[3] == 0)
			assert(on_drag_mock.params[4] == 4) -- Total X from drag start point
			assert(on_drag_mock.params[5] == 0)
		end)


		it("Should call all included events", function()
			local on_drag, on_drag_mock = test_helper.get_function()
			local instance = create_drag_instance(on_drag)

			local on_touch_start, on_touch_start_mock = test_helper.get_function()
			instance.on_touch_start:subscribe(on_touch_start)
			local on_touch_end, on_touch_end_mock = test_helper.get_function()
			instance.on_touch_end:subscribe(on_touch_end)
			local on_drag_start, on_drag_start_mock = test_helper.get_function()
			instance.on_drag_start:subscribe(on_drag_start)
			local on_drag_end, on_drag_end_mock = test_helper.get_function()
			instance.on_drag_end:subscribe(on_drag_end)

			assert(on_touch_start_mock.calls == 0)
			druid:on_input(mock_input.click_pressed(10, 10))
			assert(on_touch_start_mock.calls == 1)
			assert(on_touch_end_mock.calls == 0)
			druid:on_input(mock_input.click_released(12, 10))
			assert(on_touch_end_mock.calls == 1)

			druid:on_input(mock_input.click_pressed(10, 10))
			assert(on_drag_start_mock.calls == 0)
			druid:on_input(mock_input.input_empty(15, 10))
			assert(on_drag_start_mock.calls == 1)
			assert(on_drag_mock.calls == 1)
			assert(on_drag_end_mock.calls == 0)
			druid:on_input(mock_input.click_released(15, 10))
			assert(on_drag_end_mock.calls == 1)
		end)

		it("Should work with set_enabled", function()
			local on_drag, on_drag_mock = test_helper.get_function()
			local instance = create_drag_instance(on_drag)

			instance:set_enabled(false)
			assert(instance:is_enabled() == false)

			druid:on_input(mock_input.click_pressed(10, 10))
			assert(instance.is_touch == false)

			druid:on_input(mock_input.input_empty(12, 10))
			assert(on_drag_mock.calls == 0)

			druid:on_input(mock_input.input_empty(15, 10))
			assert(on_drag_mock.calls == 0)

			instance:set_enabled(true)
			assert(instance:is_enabled() == true)

			druid:on_input(mock_input.click_pressed(10, 10))
			assert(instance.is_touch == true)

			druid:on_input(mock_input.input_empty(12, 10))
			assert(on_drag_mock.calls == 0)

			druid:on_input(mock_input.input_empty(15, 10))
			assert(on_drag_mock.calls == 1)
		end)

		it("Should work with click zone", function()
			local on_drag, on_drag_mock = test_helper.get_function()
			local instance = create_drag_instance(on_drag)
			local zone = mock_gui.add_box("zone", 10, 10, 10, 10)
			instance:set_click_zone(zone)

			druid:on_input(mock_input.click_pressed(5, 5))
			assert(instance.is_touch == false)

			druid:on_input(mock_input.input_empty(10, 5))
			assert(on_drag_mock.calls == 0)

			druid:on_input(mock_input.input_empty(15, 10))
			assert(on_drag_mock.calls == 0)

			druid:on_input(mock_input.click_pressed(15, 15))
			assert(instance.is_touch == true)

			druid:on_input(mock_input.input_empty(20, 15))
			assert(on_drag_mock.calls == 1)
		end)
	end)
end
