local event = require("event.event")
local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")
local utf8_lua = require("druid.system.utf8")
local utf8 = utf8 or utf8_lua

---@class druid.input.style
---@field MASK_DEFAULT_CHAR string Default character mask for password input
---@field IS_LONGTAP_ERASE boolean Is long tap will erase current input data
---@field IS_UNSELECT_ON_RESELECT boolean If true, call unselect on select selected input
---@field on_select fun(self: druid.input, button_node: node) Callback on input field selecting
---@field on_unselect fun(self: druid.input, button_node: node) Callback on input field unselecting
---@field on_input_wrong fun(self: druid.input, button_node: node) Callback on wrong user input

---Basic Druid text input component. Handles user text input via component with button and text.
---
---### Setup
---Create input component with druid: `input = druid:new_input(button_node_name, text_node_name, keyboard_type)`
---
---### Notes
---- Input component handles user text input. Input contains button and text components
---- Button needed for selecting/unselecting input field
---- Click outside of button to unselect input field
---- On focus lost (game minimized) input field will be unselected
---- You can setup max length of the text
---- You can setup allowed characters. On add not allowed characters `on_input_wrong` will be called
---@class druid.input: druid.component
---@field on_input_select event fun(self: druid.input, input: druid.input) The event triggered when the input field is selected
---@field on_input_unselect event fun(self: druid.input, text: string, input: druid.input) The event triggered when the input field is unselected
---@field on_input_text event fun(self: druid.input) The event triggered when the input field is changed
---@field on_input_empty event fun(self: druid.input) The event triggered when the input field is empty
---@field on_input_full event fun(self: druid.input) The event triggered when the input field is full
---@field on_input_wrong event fun(self: druid.input) The event triggered when the input field is wrong
---@field on_select_cursor_change event fun(self: druid.input, cursor_index: number, start_index: number, end_index: number) The event triggered when the cursor index is changed
---@field style druid.input.style The style of the input component
local M = component.create("input")

---@private
M.ALLOWED_ACTIONS = {
	[const.ACTION_TOUCH] = true,
	[const.ACTION_TEXT] = true,
	[const.ACTION_MARKED_TEXT] = true,
	[const.ACTION_BACKSPACE] = true,
	[const.ACTION_ENTER] = true,
	[const.ACTION_ESC] = true,
}

---Mask text by replacing every character with a mask character
---@param text string
---@param mask string
---@return string Masked text
local function mask_text(text, mask)
	mask = mask or "*"
	local masked_text = ""
	for uchar in utf8.gmatch(text, ".") do
		masked_text = masked_text .. mask
	end

	return masked_text
end


local function clear_and_select(self)
	if self.style.IS_LONGTAP_ERASE then
		self:set_text("")
	end

	self:select()
end


---@param click_node node Node to enabled input component
---@param text_node node|druid.text Text node what will be changed on user input. You can pass text component instead of text node name Text
---@param keyboard_type constant|nil Gui keyboard type for input field
function M:init(click_node, text_node, keyboard_type)
	self.druid = self:get_druid()

	if type(text_node) == "table" then
		self.text = text_node
	else
		self.text = self.druid:new_text(text_node)
	end

	self.is_selected = false
	self.value = self.text.last_value
	self.previous_value = self.text.last_value
	self.current_value = self.text.last_value
	self.marked_value = ""
	self.is_empty = true

	self.text_width = 0
	self.market_text_width = 0
	self.total_width = 0
	self.cursor_index = utf8.len(self.value)
	self.start_index = self.cursor_index
	self.end_index = self.cursor_index

	self.max_length = nil
	self.allowed_characters = nil

	self.keyboard_type = keyboard_type or gui.KEYBOARD_TYPE_DEFAULT

	self.button = self.druid:new_button(click_node, self.select)
	self.button.on_click_outside:subscribe(self.unselect)
	self.button.on_long_click:subscribe(clear_and_select)

	if defos then
		self.button.hover.style.ON_HOVER_CURSOR = defos.CURSOR_IBEAM
		self.button.hover.style.ON_MOUSE_HOVER_CURSOR = defos.CURSOR_IBEAM
	end

	if html5 then
		self.button:set_web_user_interaction(true)
	end

	self.on_input_select = event.create()
	self.on_input_unselect = event.create()
	self.on_input_text = event.create()
	self.on_input_empty = event.create()
	self.on_input_full = event.create()
	self.on_input_wrong = event.create()
	self.on_select_cursor_change = event.create()
end


---@private
---@param style druid.input.style
function M:on_style_change(style)
	self.style = {
		IS_LONGTAP_ERASE = style.IS_LONGTAP_ERASE or false,
		MASK_DEFAULT_CHAR = style.MASK_DEFAULT_CHAR or "*",
		IS_UNSELECT_ON_RESELECT = style.IS_UNSELECT_ON_RESELECT or false,

		on_select = style.on_select or function(_, button_node) end,
		on_unselect = style.on_unselect or function(_, button_node) end,
		on_input_wrong = style.on_input_wrong or function(_, button_node) end,
	}
end


---@private
---@param action_id hash|nil The action id
---@param action action The action
---@return boolean is_consume True if the action is consumed
function M:on_input(action_id, action)
	if not (action_id == nil or M.ALLOWED_ACTIONS[action_id]) then
		return false
	end

	if self.is_selected then
		local input_text = nil
		local is_marked_text_changed = false
		local cursor_shift_indexes = nil

		if action_id == const.ACTION_TEXT then
			-- ignore return key
			if action.text == "\n" or action.text == "\r" then
				return true
			end

			local hex = string.gsub(action.text, "(.)", function(c)
				return string.format("%02X%s",string.byte(c), "")
			end)

			-- ignore arrow keys
			if not utf8.match(hex, "EF9C8[0-3]") then
				if not self.allowed_characters or utf8.match(action.text, self.allowed_characters) then
					local shift_offset = self.cursor_index - self.start_index
					input_text = self:get_text_selected_replaced(action.text)
					cursor_shift_indexes = utf8.len(action.text) - shift_offset
				else
					self.on_input_wrong:trigger(self:get_context(), action.text)
					self.style.on_input_wrong(self, self.button.node)
				end
				self.marked_value = ""
			end
		end

		if action_id == const.ACTION_MARKED_TEXT then
			self.marked_value = action.text or ""
			if self.max_length then
				self.marked_value = utf8.sub(self.marked_value, 1, self.max_length)
			end
			is_marked_text_changed = self.marked_value ~= ""
		end

		if action_id == const.ACTION_BACKSPACE and (action.pressed or action.repeated) then
			local start_index = self.start_index or utf8.len(self.value)
			local end_index = self.end_index or utf8.len(self.value)

			-- If start == end index, remove left of this selection letter, else delete all selection
			if start_index == end_index then
				local left_part = utf8.sub(self.value, 1, math.max(0, start_index - 1))
				local right_part = utf8.sub(self.value, end_index + 1, utf8.len(self.value))
				input_text = left_part .. right_part

				cursor_shift_indexes = -1
			else
				local left_part = utf8.sub(self.value, 1, start_index)
				local right_part = utf8.sub(self.value, end_index + 1, utf8.len(self.value))
				input_text = left_part .. right_part

				-- Calculate offsets from cursor pos to start index
				cursor_shift_indexes = start_index - self.cursor_index
			end
		end

		if action_id == const.ACTION_ENTER and action.released then
			self:unselect()
			return true
		end

		if action_id == const.ACTION_BACK and action.released then
			self:unselect()
			return true
		end

		if action_id == const.ACTION_ESC and action.released then
			self:unselect()
			return true
		end

		if input_text or is_marked_text_changed then
			self:set_text(input_text or self.value)

			if cursor_shift_indexes then
				self:select_cursor(self.cursor_index + cursor_shift_indexes)
			end

			return true
		end
	end

	local is_mouse_action = action_id == const.ACTION_TOUCH or not action_id
	if is_mouse_action then
		return false
	end

	return self.is_selected
end


---@private
function M:on_focus_lost()
	self:unselect()
end


function M:get_text_selected()
	if self.start_index == self.end_index then
		return self.value
	end

	return utf8.sub(self.value, self.start_index + 1, self.end_index)
end


---Replace selected text with new text
---@param text string The text to replace selected text
---@return string new_text New input text
function M:get_text_selected_replaced(text)
	local left_part = utf8.sub(self.value, 1, self.start_index)
	local right_part = utf8.sub(self.value, self.end_index + 1, utf8.len(self.value))
	local result = left_part .. text .. right_part


	if self.max_length then
		result = utf8.sub(result, 1, self.max_length)
	end

	return result
end


---Set text for input field
---@param input_text string? The string to apply for input field, if nil - will be set to empty string
function M:set_text(input_text)
	input_text = tostring(input_text or "")

	-- Case when update with marked text
	if input_text then
		self.value = input_text
	end

	-- Only update the text if it has changed
	local current_value = self.value .. self.marked_value

	if current_value ~= self.current_value then
		self.current_value = current_value

		-- mask text if password field
		local masked_value, masked_marked_value
		if self.keyboard_type == gui.KEYBOARD_TYPE_PASSWORD then
			local mask_char = self.style.MASK_DEFAULT_CHAR or "*"
			masked_value = mask_text(self.value, mask_char)
			masked_marked_value = mask_text(self.marked_value, mask_char)
		end

		-- text + marked text
		local value = masked_value or self.value
		local marked_value = masked_marked_value or self.marked_value
		self.is_empty = #value == 0 and #marked_value == 0

		local final_text = value .. marked_value
		self.text:set_text(final_text)

		-- measure it
		self.text_width = self.text:get_text_size(value)
		self.marked_text_width = self.text:get_text_size(marked_value)
		self.total_width = self.text_width + self.marked_text_width

		self.on_input_text:trigger(self:get_context(), final_text)
		if #final_text == 0 then
			self.on_input_empty:trigger(self:get_context(), final_text)
		end
		if self.max_length and #final_text == self.max_length then
			self.on_input_full:trigger(self:get_context(), final_text)
		end
	end
end


---Select input field. It will show the keyboard and trigger on_select events
function M:select()
	gui.reset_keyboard()
	self.marked_value = ""
	if not self.is_selected then
		self:set_input_priority(const.PRIORITY_INPUT_MAX, true)
		self.button:set_input_priority(const.PRIORITY_INPUT_MAX, true)
		self.previous_value = self.value
		self.is_selected = true

		gui.show_keyboard(self.keyboard_type, false)

		local len = utf8.len(self.value)
		self:select_cursor(len, len, len)
		self.on_input_select:trigger(self:get_context(), self)
		self.style.on_select(self, self.button.node)
	else
		if self.style.IS_UNSELECT_ON_RESELECT then
			self:unselect()
		end
	end
end


---Remove selection from input. It will hide the keyboard and trigger on_unselect events
function M:unselect()
	gui.reset_keyboard()
	self.marked_value = ""
	self.value = self.current_value
	if self.is_selected then
		self:reset_input_priority()
		self.button:reset_input_priority()
		self.is_selected = false

		gui.hide_keyboard()
		self.on_input_unselect:trigger(self:get_context(), self:get_text(), self)

		self.style.on_unselect(self, self.button.node)
	end
end


---Return current input field text
---@return string text The current input field text
function M:get_text()
	if self.marked_value ~= "" then
		return self.value .. self.marked_value
	end

	return self.value
end


---Set maximum length for input field.
---Pass nil to make input field unliminted (by default)
---@param max_length number Maximum length for input text field
---@return druid.input self Current input instance
function M:set_max_length(max_length)
	self.max_length = max_length
	return self
end


---Set allowed charaters for input field.
---See: https://defold.com/ref/stable/string/
---ex: [%a%d] for alpha and numeric
---ex: [abcdef] to allow only these characters
---ex: [^%s] to allow only non-space characters
---@param characters string Regular expression for validate user input
---@return druid.input self Current input instance
function M:set_allowed_characters(characters)
	self.allowed_characters = characters
	return self
end


---Reset current input selection and return previous value
---@return druid.input self Current input instance
function M:reset_changes()
	self:set_text(self.previous_value)
	self:unselect()
	return self
end


---Set cursor position in input field
---@param cursor_index number|nil Cursor index for cursor position, if nil - will be set to the end of the text
---@param start_index number|nil Start index for cursor position, if nil - will be set to the end of the text
---@param end_index number|nil End index for cursor position, if nil - will be set to the start_index
---@return druid.input self Current input instance
function M:select_cursor(cursor_index, start_index, end_index)
	local len = utf8.len(self.value)

	self.cursor_index = cursor_index or len
	self.start_index = start_index or self.cursor_index
	self.end_index = end_index or self.start_index

	self.cursor_index = helper.clamp(self.cursor_index, 0, len)
	self.start_index = helper.clamp(self.start_index, 0, len)
	self.end_index = helper.clamp(self.end_index, 0, len)

	self.on_select_cursor_change:trigger(self:get_context(), self.cursor_index, self.start_index, self.end_index)

	return self
end


---Change cursor position by delta
---@param delta number side for cursor position, -1 for left, 1 for right
---@param is_add_to_selection boolean (Shift key)
---@param is_move_to_end boolean (Ctrl key)
---@return druid.input self Current input instance
function M:move_selection(delta, is_add_to_selection, is_move_to_end)
	local len = utf8.len(self.value)
	local cursor_index = self.cursor_index
	local start_index, end_index -- if nil, the selection will be 0 at cursor position
	local is_right = delta > 0

	local target_index = cursor_index + delta
	if is_move_to_end then
		target_index = is_right and len or 0
	end

	-- The Shift is not pressed
	if not is_add_to_selection then
		cursor_index = target_index

		if self.start_index ~= self.end_index then
			-- Reset selection without moving cursor
			cursor_index = self.cursor_index
		end
	end

	-- The Shift is pressed
	if is_add_to_selection then
		cursor_index = target_index
		start_index = self.start_index
		end_index = self.end_index

		local is_cursor_extends_selection = (self.cursor_index == (is_right and end_index or start_index))

		if is_cursor_extends_selection then
			if is_right then
				end_index = cursor_index
			else
				start_index = cursor_index
			end
		else
			if is_right then
				start_index = cursor_index

				if is_move_to_end then
					start_index = end_index
					end_index = cursor_index
				end
			else
				end_index = cursor_index

				if is_move_to_end then
					end_index = start_index
					start_index = cursor_index
				end
			end
		end
	end

	self:select_cursor(cursor_index, start_index, end_index)

	return self
end


return M
