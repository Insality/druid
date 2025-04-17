return function()
	describe("Button Component", function()
		local mock_time
		local mock_input
		local druid_system

		local druid
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

		it("Should do usual click", function()
			local button = gui.new_box_node(vmath.vector3(50, 25, 0), vmath.vector3(100, 50, 0))
			local button_params = {}

			local on_click_calls = 0
			local on_click_params = {}
			local function on_click(self, params, button_instance)
				on_click_calls = on_click_calls + 1
				on_click_params[1] = self
				on_click_params[2] = params
				on_click_params[3] = button_instance
			end

			local instance = druid:new_button(button, on_click, button_params)
			local is_clicked_pressed = druid:on_input(mock_input.click_pressed(10, 10))
			local is_clicked_released = druid:on_input(mock_input.click_released(20, 10))

			assert(is_clicked_pressed)
			assert(is_clicked_released)
			assert(on_click_calls == 1)
			assert(on_click_params[1] == context)
			assert(on_click_params[2] == button_params)
			assert(on_click_params[3] == instance)
		end)

		it("Should do long click if exists", function()
			local button = gui.new_box_node(vmath.vector3(50, 25, 0), vmath.vector3(100, 50, 0))
			local button_params = {}

			local on_click_calls = 0
			local function on_click()
				on_click_calls = on_click_calls + 1
			end

			local on_long_click_calls = 0
			local on_long_click_params = {}
			local function on_long_click(self, params, button_instance)
				on_long_click_calls = on_long_click_calls + 1
				on_long_click_params[1] = self
				on_long_click_params[2] = params
				on_long_click_params[3] = button_instance
			end

			local instance = druid:new_button(button, on_click, button_params)
			instance.on_long_click:subscribe(on_long_click)
			druid:on_input(mock_input.click_pressed(10, 10))
			mock_time.elapse(0.3)
			druid:on_input(mock_input.click_released(20, 10))

			assert(on_click_calls == 1)
			assert(on_long_click_calls == 0)

			druid:on_input(mock_input.click_pressed(10, 10))
			mock_time.elapse(1)
			druid:on_input(mock_input.click_released(20, 10))

			assert(on_click_calls == 1)
			assert(on_long_click_calls == 1)
			assert(on_long_click_params[1] == context)
			assert(on_long_click_params[2] == button_params)
			assert(on_long_click_params[3] == instance)
		end)

		it("Should do not long click if not exists", function()
			local button = gui.new_box_node(vmath.vector3(50, 25, 0), vmath.vector3(100, 50, 0))
			local button_params = {}

			local on_click_calls = 0
			local function on_click()
				on_click_calls = on_click_calls + 1
			end

			druid:new_button(button, on_click, button_params)
			druid:on_input(mock_input.click_pressed(10, 10))
			mock_time.elapse(0.5)
			druid:on_input(mock_input.click_released(20, 10))

			assert(on_click_calls == 1)
		end)

		it("Should do double click if exists", function()
			--TODO:  At zero it thinks it is double click
			-- Need to fix it in button
			mock_time.set(10)
			local button = gui.new_box_node(vmath.vector3(50, 25, 0), vmath.vector3(100, 50, 0))
			local button_params = {}

			local on_click_calls = 0
			local function on_click()
				on_click_calls = on_click_calls + 1
			end

			local on_double_click_calls = 0
			local on_double_click_params = {}
			local function on_double_click(self, params, button_instance)
				on_double_click_calls = on_double_click_calls + 1
				on_double_click_params[1] = self
				on_double_click_params[2] = params
				on_double_click_params[3] = button_instance
			end

			local instance = druid:new_button(button, on_click, button_params)
			instance.on_double_click:subscribe(on_double_click)
			druid:on_input(mock_input.click_pressed(50, 25))
			druid:on_input(mock_input.click_released(50, 25))

			-- DOUBLETAP_TIME by default is 0.4
			mock_time.elapse(0.2)
			druid:on_input(mock_input.click_pressed(50, 25))
			druid:on_input(mock_input.click_released(50, 25))

			assert(on_click_calls == 1)
			assert(on_double_click_calls == 1)
			assert(on_double_click_params[1] == context)
			assert(on_double_click_params[2] == button_params)
			assert(on_double_click_params[3] == instance)

			mock_time.elapse(1)
			druid:on_input(mock_input.click_pressed(10, 10))
			druid:on_input(mock_input.click_released(20, 10))

			mock_time.elapse(0.5) -- The double click should not register, big time between clicks
			druid:on_input(mock_input.click_pressed(10, 10))
			druid:on_input(mock_input.click_released(20, 10))

			assert(on_click_calls == 3)
			assert(on_double_click_calls == 1)
		end)

		it("Should do not double click if not exists", function()
			local button = gui.new_box_node(vmath.vector3(50, 25, 0), vmath.vector3(100, 50, 0))
			local button_params = {}

			local on_click_calls = 0
			local function on_click()
				on_click_calls = on_click_calls + 1
			end

			druid:new_button(button, on_click, button_params)

			druid:on_input(mock_input.click_pressed(10, 10))
			druid:on_input(mock_input.click_released(20, 10))
			mock_time.elapse(0.1)
			druid:on_input(mock_input.click_pressed(10, 10))
			druid:on_input(mock_input.click_released(20, 10))

			assert(on_click_calls == 2)
		end)

		it("Should do hold click if exists", function()
			local button = gui.new_box_node(vmath.vector3(50, 25, 0), vmath.vector3(100, 50, 0))
			local button_params = {}

			local on_click_calls = 0
			local function on_click()
				on_click_calls = on_click_calls + 1
			end

			local on_long_click_calls = 0
			local on_long_click_params = {}
			local function on_long_click(self, params, button_instance)
				on_long_click_calls = on_long_click_calls + 1
				on_long_click_params[1] = self
				on_long_click_params[2] = params
				on_long_click_params[3] = button_instance
			end

			local on_hold_callback_calls = 0
			local function on_hold_callback()
				on_hold_callback_calls = on_hold_callback_calls + 1
			end

			local instance = druid:new_button(button, on_click, button_params)
			instance.on_long_click:subscribe(on_long_click) -- long click required for hold callback
			instance.on_hold_callback:subscribe(on_hold_callback)

			druid:on_input(mock_input.click_pressed(10, 10))
			mock_time.elapse(1) -- time between hold treshold and autorelease hold time
			druid:on_input(mock_input.input_empty(10, 10))

			assert(on_click_calls == 0)
			assert(on_long_click_calls == 1)
			assert(on_long_click_params[1] == context)
			assert(on_long_click_params[2] == button_params)
			assert(on_long_click_params[3] == instance)

			druid:on_input(mock_input.click_released(10, 10))

			assert(on_click_calls == 0)
			assert(on_long_click_calls == 1)
		end)

		it("Should do click outside if exists", function()
			local button = gui.new_box_node(vmath.vector3(50, 25, 0), vmath.vector3(100, 50, 0))
			local button_params = {}

			local on_click_calls = 0
			local function on_click()
				on_click_calls = on_click_calls + 1
			end

			local on_click_outside_calls = 0
			local function on_click_outside()
				on_click_outside_calls = on_click_outside_calls + 1
			end

			local instance = druid:new_button(button, on_click, button_params)
			instance.on_click_outside:subscribe(on_click_outside)

			druid:on_input(mock_input.click_pressed(120, 10))
			druid:on_input(mock_input.click_released(120, 10))

			assert(on_click_outside_calls == 1)

			mock_time.elapse(1)
			druid:on_input(mock_input.click_pressed(10, 10))
			druid:on_input(mock_input.click_released(120, 10))

			assert(on_click_outside_calls == 2)
		end)

		it("Should not click if mouse was outside while clicking", function()
			local button = gui.new_box_node(vmath.vector3(50, 25, 0), vmath.vector3(100, 50, 0))
			local button_params = {}

			local on_click_calls = 0
			local function on_click()
				on_click_calls = on_click_calls + 1
			end

			druid:new_button(button, on_click, button_params)

			druid:on_input(mock_input.click_pressed(10, 10))
			druid:on_input(mock_input.input_empty(120, 10))
			druid:on_input(mock_input.click_released(20, 10))

			assert(on_click_calls == 0)
		end)

		it("Should work with check function", function()
			local button = gui.new_box_node(vmath.vector3(50, 25, 0), vmath.vector3(100, 50, 0))
			local button_params = {}

			local on_click_calls = 0
			local function on_click()
				on_click_calls = on_click_calls + 1
			end

			local instance = druid:new_button(button, on_click, button_params)

			local check_function_calls = 0
			local function check_function()
				check_function_calls = check_function_calls + 1
				return false
			end

			local failure_function_calls = 0
			local function failure_function()
				failure_function_calls = failure_function_calls + 1
			end

			instance:set_check_function(check_function, failure_function)

			druid:on_input(mock_input.click_pressed(10, 10))
			druid:on_input(mock_input.click_released(20, 10))

			assert(on_click_calls == 0)
			assert(check_function_calls == 1)
			assert(failure_function_calls == 1)

			local check_true_function_calls = 0
			local function check_true_function()
				check_true_function_calls = check_true_function_calls + 1
				return true
			end

			instance:set_check_function(check_true_function, failure_function)

			mock_time.elapse(1)
			druid:on_input(mock_input.click_pressed(10, 10))
			druid:on_input(mock_input.click_released(20, 10))

			assert(on_click_calls == 1)
			assert(check_true_function_calls == 1)
			assert(failure_function_calls == 1)
		end)

		it("Should have key trigger", function()
			local button = gui.new_box_node(vmath.vector3(50, 25, 0), vmath.vector3(100, 50, 0))
			local button_params = {}

			local on_click_calls = 0
			local function on_click()
				on_click_calls = on_click_calls + 1
			end

			local instance = druid:new_button(button, on_click, button_params)
			instance:set_key_trigger("key_a")
			druid:on_input(mock_input.key_pressed("key_a"))
			druid:on_input(mock_input.key_released("key_a"))
			assert(on_click_calls == 1)
			assert(instance:get_key_trigger() == hash("key_a"))
		end)

		it("Should work with click zone", function()
			local button = gui.new_box_node(vmath.vector3(50, 25, 0), vmath.vector3(100, 50, 0))
			local zone = gui.new_box_node(vmath.vector3(50, 50, 0), vmath.vector3(50, 50, 0))
			local button_params = {}

			local on_click_calls = 0
			local function on_click()
				on_click_calls = on_click_calls + 1
			end

			local instance = druid:new_button(button, on_click, button_params)
			instance:set_click_zone(zone)
			druid:on_input(mock_input.click_pressed(10, 10))
			druid:on_input(mock_input.click_released(10, 10))
			assert(on_click_calls == 0)

			druid:on_input(mock_input.click_pressed(50, 50))
			druid:on_input(mock_input.click_released(50, 50))
			assert(on_click_calls == 1)
		end)

		it("Should work with set_enabled", function()
			local button = gui.new_box_node(vmath.vector3(50, 25, 0), vmath.vector3(100, 50, 0))
			local button_params = {}

			local on_click_calls = 0
			local function on_click()
				on_click_calls = on_click_calls + 1
			end

			local instance = druid:new_button(button, on_click, button_params)

			instance:set_enabled(false)
			local is_clicked_pressed = druid:on_input(mock_input.click_pressed(10, 10))
			local is_clicked_released = druid:on_input(mock_input.click_released(10, 10))
			assert(is_clicked_pressed == true)
			assert(is_clicked_released == true)
			assert(on_click_calls == 0)
			assert(instance:is_enabled() == false)

			instance:set_enabled(true)
			local is_clicked_pressed2 = druid:on_input(mock_input.click_pressed(10, 10))
			assert(is_clicked_pressed2 == true)
			local is_clicked_released2 = druid:on_input(mock_input.click_released(10, 10))
			assert(is_clicked_released2 == true)
			assert(on_click_calls == 1)
			assert(instance:is_enabled() == true)
		end)
	end)
end
