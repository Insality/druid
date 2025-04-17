return function()
	describe("Input Component", function()
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

		it("Should create input component", function()
			local button_node = gui.new_box_node(vmath.vector3(50, 25, 0), vmath.vector3(100, 50, 0))
			local text_node = gui.new_text_node(vmath.vector3(50, 25, 0), "Initial Text")
			gui.set_font(text_node, "druid_text_bold")

			local input = druid:new_input(button_node, text_node)

			assert(input ~= nil)
			assert(input.button ~= nil)
			assert(input.text ~= nil)
			assert(input:get_text() == "Initial Text")

			druid:remove(input)
			gui.delete_node(button_node)
			gui.delete_node(text_node)
		end)

		it("Should select and unselect input", function()
			local button_node = gui.new_box_node(vmath.vector3(50, 25, 0), vmath.vector3(100, 50, 0))
			local text_node = gui.new_text_node(vmath.vector3(50, 25, 0), "Text")
			gui.set_font(text_node, "druid_text_bold")

			local input = druid:new_input(button_node, text_node)

			local on_input_select_calls = 0
			local on_input_unselect_calls = 0

			input.on_input_select:subscribe(function()
				on_input_select_calls = on_input_select_calls + 1
			end)

			input.on_input_unselect:subscribe(function()
				on_input_unselect_calls = on_input_unselect_calls + 1
			end)

			-- Select input
			druid:on_input(mock_input.click_pressed(50, 25))
			druid:on_input(mock_input.click_released(50, 25))

			assert(input.is_selected == true)
			assert(on_input_select_calls == 1)

			-- Unselect input
			druid:on_input(mock_input.click_pressed(200, 200))
			druid:on_input(mock_input.click_released(200, 200))

			assert(input.is_selected == false)
			assert(on_input_unselect_calls == 1)

			druid:remove(input)
			gui.delete_node(button_node)
			gui.delete_node(text_node)
		end)

		it("Should handle text input", function()
			local button_node = gui.new_box_node(vmath.vector3(50, 25, 0), vmath.vector3(100, 50, 0))
			local text_node = gui.new_text_node(vmath.vector3(50, 25, 0), "")
			gui.set_font(text_node, "druid_text_bold")

			local input = druid:new_input(button_node, text_node)

			local on_input_text_calls = 0
			input.on_input_text:subscribe(function()
				on_input_text_calls = on_input_text_calls + 1
			end)

			-- Select input
			druid:on_input(mock_input.click_pressed(50, 25))
			druid:on_input(mock_input.click_released(50, 25))

			-- Simulate typing "Hello"
			local function trigger_text_input(text)
				return druid:on_input(hash("text"), {text = text})
			end

			-- Type "H"
			trigger_text_input("H")
			assert(input:get_text() == "H")
			assert(on_input_text_calls == 1)

			-- Type "e"
			trigger_text_input("e")
			assert(input:get_text() == "He")
			assert(on_input_text_calls == 2)

			-- Type "llo"
			trigger_text_input("l")
			trigger_text_input("l")
			trigger_text_input("o")

			assert(input:get_text() == "Hello")
			assert(on_input_text_calls == 5)

			druid:remove(input)
			gui.delete_node(button_node)
			gui.delete_node(text_node)
		end)

		it("Should handle backspace input", function()
			local button_node = gui.new_box_node(vmath.vector3(50, 25, 0), vmath.vector3(100, 50, 0))
			local text_node = gui.new_text_node(vmath.vector3(50, 25, 0), "Hello")
			gui.set_font(text_node, "druid_text_bold")

			local input = druid:new_input(button_node, text_node)

			-- Select input
			druid:on_input(mock_input.click_pressed(50, 25))
			druid:on_input(mock_input.click_released(50, 25))

			-- Simulate backspace key
			local function trigger_backspace()
				return druid:on_input(hash("key_backspace"), {pressed = true})
			end

			-- Delete one letter
			assert(trigger_backspace() == true)
			assert(input:get_text() == "Hell")

			-- Delete another letter
			assert(trigger_backspace() == true)
			assert(input:get_text() == "Hel")

			druid:remove(input)
			gui.delete_node(button_node)
			gui.delete_node(text_node)
		end)

		it("Should set max length", function()
			local button_node = gui.new_box_node(vmath.vector3(50, 25, 0), vmath.vector3(100, 50, 0))
			local text_node = gui.new_text_node(vmath.vector3(50, 25, 0), "")
			gui.set_font(text_node, "druid_text_bold")

			local input = druid:new_input(button_node, text_node)

			local on_input_full_calls = 0
			input.on_input_full:subscribe(function()
				on_input_full_calls = on_input_full_calls + 1
			end)

			-- Set max length to 5
			input:set_max_length(5)

			-- Select input
			druid:on_input(mock_input.click_pressed(50, 25))
			druid:on_input(mock_input.click_released(50, 25))

			-- Simulate typing text
			local function trigger_text_input(text)
				return druid:on_input(hash("text"), {text = text})
			end

			-- Type "Hello"
			assert(trigger_text_input("Hello") == true)
			assert(input:get_text() == "Hello")
			assert(on_input_full_calls == 1)

			-- Try to type "World" - should truncate
			assert(trigger_text_input("World") == true)
			assert(input:get_text() == "Hello")

			druid:remove(input)
			gui.delete_node(button_node)
			gui.delete_node(text_node)
		end)

		it("Should validate allowed characters", function()
			local button_node = gui.new_box_node(vmath.vector3(50, 25, 0), vmath.vector3(100, 50, 0))
			local text_node = gui.new_text_node(vmath.vector3(50, 25, 0), "")
			gui.set_font(text_node, "druid_text_bold")

			local input = druid:new_input(button_node, text_node)

			local on_input_wrong_calls = 0
			input.on_input_wrong:subscribe(function()
				on_input_wrong_calls = on_input_wrong_calls + 1
			end)

			-- Set allowed characters to only numbers
			input:set_allowed_characters("[0-9]")

			-- Select input
			druid:on_input(mock_input.click_pressed(50, 25))
			druid:on_input(mock_input.click_released(50, 25))

			-- Simulate typing text
			local function trigger_text_input(text)
				return druid:on_input(hash("text"), {text = text})
			end

			-- Type valid input "123"
			assert(trigger_text_input("123") == true)
			assert(input:get_text() == "123")
			assert(on_input_wrong_calls == 0)

			-- Type invalid input "abc" - should be rejected
			assert(trigger_text_input("abc") == true)
			assert(input:get_text() == "123")
			assert(on_input_wrong_calls == 1)

			druid:remove(input)
			gui.delete_node(button_node)
			gui.delete_node(text_node)
		end)

		it("Should handle password input", function()
			local button_node = gui.new_box_node(vmath.vector3(50, 25, 0), vmath.vector3(100, 50, 0))
			local text_node = gui.new_text_node(vmath.vector3(50, 25, 0), "")
			gui.set_font(text_node, "druid_text_bold")

			-- Create password input
			local input = druid:new_input(button_node, text_node, gui.KEYBOARD_TYPE_PASSWORD)

			-- Select input
			druid:on_input(mock_input.click_pressed(50, 25))
			druid:on_input(mock_input.click_released(50, 25))

			-- Simulate typing "Hello"
			local function trigger_text_input(text)
				return druid:on_input(hash("text"), {text = text})
			end

			assert(trigger_text_input("Hello") == true)

			-- Raw text should be "Hello"
			assert(input:get_text() == "Hello")

			-- But displayed text should be "*****"
			assert(gui.get_text(text_node) == "*****")

			druid:remove(input)
			gui.delete_node(button_node)
			gui.delete_node(text_node)
		end)

		it("Should handle enter key", function()
			local button_node = gui.new_box_node(vmath.vector3(50, 25, 0), vmath.vector3(100, 50, 0))
			local text_node = gui.new_text_node(vmath.vector3(50, 25, 0), "")
			gui.set_font(text_node, "druid_text_bold")

			local input = druid:new_input(button_node, text_node)

			-- Select input
			druid:on_input(mock_input.click_pressed(50, 25))
			druid:on_input(mock_input.click_released(50, 25))

			-- Verify input is selected
			assert(input.is_selected == true)

			-- Simulate enter key press to unselect
			assert(druid:on_input(hash("key_enter"), {released = true}) == true)

			-- Verify input is unselected
			assert(input.is_selected == false)

			druid:remove(input)
			gui.delete_node(button_node)
			gui.delete_node(text_node)
		end)

		it("Should reset changes", function()
			local button_node = gui.new_box_node(vmath.vector3(50, 25, 0), vmath.vector3(100, 50, 0))
			local text_node = gui.new_text_node(vmath.vector3(50, 25, 0), "Initial")
			gui.set_font(text_node, "druid_text_bold")

			local input = druid:new_input(button_node, text_node)

			-- Select input
			druid:on_input(mock_input.click_pressed(50, 25))
			druid:on_input(mock_input.click_released(50, 25))

			-- Type some text
			druid:on_input(hash("text"), {text = "M"})
			druid:on_input(hash("text"), {text = "o"})
			druid:on_input(hash("text"), {text = "d"})

			assert(input:get_text() == "InitialMod")

			-- Reset changes
			input:reset_changes()

			-- Verify text is reset to initial value
			assert(input:get_text() == "Initial")
			assert(input.is_selected == false)

			druid:remove(input)
			gui.delete_node(button_node)
			gui.delete_node(text_node)
		end)

		it("Should handle selection and cursor manipulation", function()
			local button_node = gui.new_box_node(vmath.vector3(50, 25, 0), vmath.vector3(100, 50, 0))
			local text_node = gui.new_text_node(vmath.vector3(50, 25, 0), "Hello World")
			gui.set_font(text_node, "druid_text_bold")

			local input = druid:new_input(button_node, text_node)

			local cursor_changes = 0
			input.on_select_cursor_change:subscribe(function()
				cursor_changes = cursor_changes + 1
			end)

			-- Select input
			druid:on_input(mock_input.click_pressed(50, 25))
			druid:on_input(mock_input.click_released(50, 25))
			assert(cursor_changes == 1)

			-- Default cursor should be at the end
			assert(input.cursor_index == 11) -- "Hello World" length

			-- Move cursor to position 5
			input:select_cursor(5)
			assert(input.cursor_index == 5)
			assert(cursor_changes == 2)

			-- Move selection to the left by 1
			input:move_selection(-1)
			assert(input.cursor_index == 4)
			assert(cursor_changes == 3)

			-- Move selection to the right by 2
			input:move_selection(2)
			assert(input.cursor_index == 6)
			assert(cursor_changes == 4)

			druid:remove(input)
			gui.delete_node(button_node)
			gui.delete_node(text_node)
		end)

		it("Should handle empty input event", function()
			local button_node = gui.new_box_node(vmath.vector3(50, 25, 0), vmath.vector3(100, 50, 0))
			local text_node = gui.new_text_node(vmath.vector3(50, 25, 0), "Text")
			gui.set_font(text_node, "druid_text_bold")

			local input = druid:new_input(button_node, text_node)

			local on_input_empty_calls = 0
			input.on_input_empty:subscribe(function()
				on_input_empty_calls = on_input_empty_calls + 1
			end)

			-- Select input
			druid:on_input(mock_input.click_pressed(50, 25))
			druid:on_input(mock_input.click_released(50, 25))

			-- Clear text
			input:set_text("")

			assert(on_input_empty_calls == 1)
			assert(input.is_empty == true)

			druid:remove(input)
			gui.delete_node(button_node)
			gui.delete_node(text_node)
		end)
	end)
end
