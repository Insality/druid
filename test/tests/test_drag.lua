return function()
	describe("Drag component", function()
		local mock_time
		local mock_input
		local druid_system

		local druid
		local context

		local function create_drag_instance(on_drag)
			local button = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(100, 100, 0))
			local instance = druid:new_drag(button, on_drag)
			instance.style.NO_USE_SCREEN_KOEF = true
			instance.style.DRAG_DEADZONE = 4
			return instance
		end

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

		it("Should call drag callback on node", function()
			local on_drag_calls = 0
			local drag_dx, drag_dy, drag_total_x, drag_total_y

			local function on_drag(_, dx, dy, total_x, total_y)
				on_drag_calls = on_drag_calls + 1
				drag_dx, drag_dy = dx, dy
				drag_total_x, drag_total_y = total_x, total_y
			end

			local instance = create_drag_instance(on_drag)

			druid:on_input(mock_input.click_pressed(10, 10))
			assert(instance.is_touch == true)

			druid:on_input(mock_input.input_empty(12, 10))
			assert(on_drag_calls == 0)

			druid:on_input(mock_input.input_empty(14, 10))
			assert(on_drag_calls == 1)
			assert(drag_dx == 2) -- From the last input dx
			assert(drag_dy == 0)
			assert(drag_total_x == 4) -- Total X from drag start point
			assert(drag_total_y == 0)
		end)

		it("Should call all included events", function()
			local on_drag_calls = 0
			local function on_drag() on_drag_calls = on_drag_calls + 1 end
			local instance = create_drag_instance(on_drag)

			local on_touch_start_calls = 0
			local function on_touch_start() on_touch_start_calls = on_touch_start_calls + 1 end
			instance.on_touch_start:subscribe(on_touch_start)

			local on_touch_end_calls = 0
			local function on_touch_end() on_touch_end_calls = on_touch_end_calls + 1 end
			instance.on_touch_end:subscribe(on_touch_end)

			local on_drag_start_calls = 0
			local function on_drag_start() on_drag_start_calls = on_drag_start_calls + 1 end
			instance.on_drag_start:subscribe(on_drag_start)

			local on_drag_end_calls = 0
			local function on_drag_end() on_drag_end_calls = on_drag_end_calls + 1 end
			instance.on_drag_end:subscribe(on_drag_end)

			assert(on_touch_start_calls == 0)
			druid:on_input(mock_input.click_pressed(10, 10))
			assert(on_touch_start_calls == 1)
			assert(on_touch_end_calls == 0)
			druid:on_input(mock_input.click_released(12, 10))
			assert(on_touch_end_calls == 1)

			druid:on_input(mock_input.click_pressed(10, 10))
			assert(on_drag_start_calls == 0)
			druid:on_input(mock_input.input_empty(15, 10))
			assert(on_drag_start_calls == 1)
			assert(on_drag_calls == 1)
			assert(on_drag_end_calls == 0)
			druid:on_input(mock_input.click_released(15, 10))
			assert(on_drag_end_calls == 1)
		end)

		it("Should work with set_enabled", function()
			local on_drag_calls = 0
			local function on_drag() on_drag_calls = on_drag_calls + 1 end
			local instance = create_drag_instance(on_drag)

			instance:set_enabled(false)
			assert(instance:is_enabled() == false)

			druid:on_input(mock_input.click_pressed(10, 10))
			assert(instance.is_touch == false)

			druid:on_input(mock_input.input_empty(12, 10))
			assert(on_drag_calls == 0)

			druid:on_input(mock_input.input_empty(15, 10))
			assert(on_drag_calls == 0)

			instance:set_enabled(true)
			assert(instance:is_enabled() == true)

			druid:on_input(mock_input.click_pressed(10, 10))
			assert(instance.is_touch == true)

			druid:on_input(mock_input.input_empty(12, 10))
			assert(on_drag_calls == 0)

			druid:on_input(mock_input.input_empty(15, 10))
			assert(on_drag_calls == 1)
		end)

		it("Should work with click zone", function()
			local on_drag_calls = 0
			local function on_drag() on_drag_calls = on_drag_calls + 1 end
			local instance = create_drag_instance(on_drag)
			local zone = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(10, 10, 0))
			instance:set_click_zone(zone)

			druid:on_input(mock_input.click_pressed(20, 20))
			assert(instance.is_touch == false)

			druid:on_input(mock_input.input_empty(10, 10))
			assert(on_drag_calls == 0)

			druid:on_input(mock_input.input_empty(15, 15))
			druid:on_input(mock_input.click_released(15, 15))
			assert(on_drag_calls == 0)

			mock_time.set(60)
			druid:on_input(mock_input.click_pressed(0, 0))
			assert(instance.is_touch == true)

			druid:on_input(mock_input.input_empty(5, 5))
			assert(on_drag_calls == 1)
		end)

		it("Should not trigger in deadzone", function()
			local on_drag_calls = 0
			local function on_drag() on_drag_calls = on_drag_calls + 1 end
			local instance = create_drag_instance(on_drag)

			instance.style.DRAG_DEADZONE = 10

			druid:on_input(mock_input.click_pressed(10, 10))
			assert(instance.is_touch == true)

			druid:on_input(mock_input.input_empty(15, 15))
			assert(on_drag_calls == 0)
		end)
	end)
end
