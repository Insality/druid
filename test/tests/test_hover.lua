return function()
	describe("Hover component", function()
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

		it("Should fire callback on touch hover and unhover", function()
			local button = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(100, 50, 0))
			local is_hovered = false

			local function on_hover(_, state)
				is_hovered = state
			end

			local instance = druid:new_hover(button, on_hover)
			druid:on_input(mock_input.input_empty(10, 10))
			assert(is_hovered == true)
			assert(instance:is_hovered() == true)
			assert(instance:is_mouse_hovered() == false)

			druid:on_input(mock_input.input_empty(100, 100))
			assert(is_hovered == false)
			assert(instance:is_hovered() == false)
			assert(instance:is_mouse_hovered() == false)
		end)

		it("Should fire callback on mouse hover and unhover", function()
			local button = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(100, 50, 0))
			local is_hovered = false

			local function on_hover(_, state)
				is_hovered = state
			end

			local instance = druid:new_hover(button)
			instance.on_mouse_hover:subscribe(on_hover)
			druid:on_input(mock_input.input_empty_action_nil(10, 10))
			assert(is_hovered == true)
			assert(instance:is_hovered() == false)
			assert(instance:is_mouse_hovered() == true)

			druid:on_input(mock_input.input_empty_action_nil(100, 100))
			assert(is_hovered == false)
			assert(instance:is_hovered() == false)
			assert(instance:is_mouse_hovered() == false)
		end)

		it("Should work with click zone", function()
			local button = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(100, 50, 0))
			local zone = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(20, 20, 0))

			local on_hover_calls = 0
			local function on_hover()
				on_hover_calls = on_hover_calls + 1
			end

			local instance = druid:new_hover(button, on_hover)
			instance:set_click_zone(zone)
			druid:on_input(mock_input.input_empty(20, 20))
			assert(instance:is_hovered() == false)

			druid:on_input(mock_input.input_empty(0, 0))
			assert(instance:is_hovered() == true)

			druid:on_input(mock_input.input_empty(18, 18))
			assert(instance:is_hovered() == false)
		end)

		it("Should have set_enabled function", function()
			local button = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(100, 50, 0))

			local on_hover_calls = 0
			local function on_hover()
				on_hover_calls = on_hover_calls + 1
			end

			local instance = druid:new_hover(button, on_hover)

			druid:on_input(mock_input.input_empty(10, 10))
			assert(instance:is_hovered() == true)

			instance:set_enabled(false)
			assert(instance:is_enabled() == false)
			assert(instance:is_hovered() == false)
			druid:on_input(mock_input.input_empty(10, 10))
			assert(instance:is_hovered() == false)

			instance:set_enabled(true)
			druid:on_input(mock_input.input_empty(10, 10))
			assert(instance:is_enabled() == true)
			assert(instance:is_hovered() == true)

			druid:on_input(mock_input.input_empty(100, 100))
			assert(instance:is_hovered() == false)
		end)
	end)
end
