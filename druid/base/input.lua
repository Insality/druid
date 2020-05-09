--- Druid input text component.
-- Carry on user text input
-- @author Part of code from Britzl gooey input component
-- @module druid.input

--- Component events
-- @table Events
-- @tfield druid_event on_input_select (self, button_node) On input field select callback
-- @tfield druid_event on_input_unselect (self, button_node) On input field unselect callback
-- @tfield druid_event on_input_text (self, input_text) On input field text change callback
-- @tfield druid_event on_input_empty (self, input_text) On input field text change to empty string callback
-- @tfield druid_event on_input_full (self, input_text) On input field text change to max length string callback
-- @tfield druid_event on_input_wrong (self, params, button_instance) On trying user input with not allowed character callback

--- Component fields
-- @table Fields
-- @tfield druid.text text Text component
-- @tfield druid.button button Button component
-- @tfield bool is_selected Is current input selected now
-- @tfield bool is_empty Is current input is empty now
-- @tfield[opt] number max_length Max length for input text
-- @tfield[opt] string allowerd_characters Pattern matching for user input
-- @tfield number keyboard_type Gui keyboard type for input field

local Event = require("druid.event")
local const = require("druid.const")
local component = require("druid.component")
local utf8 = require("druid.system.utf8")

local M = component.create("input", { const.ON_INPUT, const.ON_FOCUS_LOST })


--- Mask text by replacing every character with a mask character
-- @tparam string text
-- @tparam string mask
-- @treturn string Masked text
local function mask_text(text, mask)
	mask = mask or "*"
	local masked_text = ""
	for uchar in utf8.gmatch(text, ".") do
		masked_text = masked_text .. mask
	end

	return masked_text
end


local function select(self)
	gui.reset_keyboard()
	self.marked_value = ""
	if not self.selected then
		self:increase_input_priority()
		self.button:increase_input_priority()
		self.previous_value = self.value
		self.selected = true

		gui.show_keyboard(self.keyboard_type, false)
		self.on_input_select:trigger(self:get_context())

		self.style.on_select(self, self.button.node)
	end
end


local function unselect(self)
	gui.reset_keyboard()
	self.marked_value = ""
	if self.selected then
		self:reset_input_priority()
		self.button:reset_input_priority()
		self.selected = false

		gui.hide_keyboard()
		self.on_input_unselect:trigger(self:get_context())

		self.style.on_unselect(self, self.button.node)
	end
end


local function clear_and_select(self)
	if self.style.IS_LONGTAP_ERASE then
		self:set_text("")
	end

	select(self)
end


--- Component style params.
-- You can override this component styles params in druid styles table
-- or create your own style
-- @table Style
-- @tfield[opt=false] bool IS_LONGTAP_ERASE Is long tap will erase current input data
-- @tfield[opt=*] string MASK_DEFAULT_CHAR Default character mask for password input
-- @tfield function on_select (self, button_node) Callback on input field selecting
-- @tfield function on_unselect (self, button_node) Callback on input field unselecting
-- @tfield function on_input_wrong (self, button_node) Callback on wrong user input
-- @tfield table button_style Custom button style for input node
function M.on_style_change(self, style)
	self.style = {}

	self.style.IS_LONGTAP_ERASE = style.IS_LONGTAP_ERASE or false
	self.style.MASK_DEFAULT_CHAR = style.MASK_DEFAULT_CHAR or "*"

	self.style.on_select = style.on_select or function(self, button_node) end
	self.style.on_unselect = style.on_unselect or function(self, button_node) end
	self.style.on_input_wrong = style.on_input_wrong or function(self, button_node) end

	self.style.button_style = style.button_style or {
		LONGTAP_TIME = 0.4,
		AUTOHOLD_TRIGGER = 0.8,
		DOUBLETAP_TIME = 0.4
	}
end


function M.init(self, click_node, text_node, keyboard_type)
	self.druid = self:get_druid(self)
	self.text = self.druid:new_text(text_node)

	self.selected = false
	self.value = self.text.last_value
	self.previous_value = self.text.last_value
	self.current_value = self.text.last_value
	self.marked_value = ""
	self.is_empty = true

	self.text_width = 0
	self.market_text_width = 0
	self.total_width = 0

	self.max_length = nil
	self.allowed_characters = nil

	self.keyboard_type = keyboard_type or gui.KEYBOARD_TYPE_DEFAULT

	self.button = self.druid:new_button(click_node, select)
	self.button:set_style(self.button_style)
	self.button.on_click_outside:subscribe(unselect)
	self.button.on_long_click:subscribe(clear_and_select)

	self.on_input_select = Event()
	self.on_input_unselect = Event()
	self.on_input_text = Event()
	self.on_input_empty = Event()
	self.on_input_full = Event()
	self.on_input_wrong = Event()
end


function M.on_input(self, action_id, action)
	if self.selected then
		local input_text = nil
		if action_id == const.ACTION_TEXT then
			-- ignore return key
			if action.text == "\n" or action.text == "\r" then
				return true
			end

			local hex = string.gsub(action.text,"(.)", function (c)
				return string.format("%02X%s",string.byte(c), "")
			end)

			-- ignore arrow keys
			if not string.match(hex, "EF9C8[0-3]") then
				if not self.allowed_characters or action.text:match(self.allowed_characters) then
					input_text = self.value .. action.text
					if self.max_length then
						input_text = utf8.sub(input_text, 1, self.max_length)
					end
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
		end

		if action_id == const.ACTION_BACKSPACE and (action.pressed or action.repeated) then
			input_text = utf8.sub(self.value, 1, -2)
		end

		if action_id == const.ACTION_ENTER and action.released then
			unselect(self)
			return true
		end

		if action_id == const.ACTION_BACK and action.released then
			unselect(self)
			return true
		end

		if action_id == const.ACTION_ESC and action.released then
			unselect(self)
			return true
		end

		if input_text or #self.marked_value > 0 then
			self:set_text(input_text)
			return true
		end
	end

	return self.selected
end


function M.on_focus_lost(self)
	unselect(self)
end


function M.on_input_interrupt(self)
	-- unselect(self)
end


--- Set text for input field
-- @function input:set_text
-- @tparam string input_text The string to apply for input field
function M.set_text(self, input_text)
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
		self.text:set_to(final_text)

		-- measure it
		self.text_width = self.text:get_text_width(value)
		self.marked_text_width = self.text:get_text_width(marked_value)
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


--- Return current input field text
-- @function input:get_text
-- @treturn string The current input field text
function M.get_text(self)
	return self.value .. self.marked_value
end


--- Set maximum length for input field.
-- Pass nil to make input field unliminted (by default)
-- @function input:set_max_length
-- @tparam number max_length Maximum length for input text field
-- @treturn druid.input Self instance to make chain calls
function M.set_max_length(self, max_length)
	self.max_length = max_length
	return self
end


--- Set allowed charaters for input field.
-- See: https://defold.com/ref/stable/string/
-- ex: [%a%d] for alpha and numeric
-- @function input:set_allowerd_characters
-- @tparam string characters Regulax exp. for validate user input
-- @treturn druid.input Self instance to make chain calls
function M.set_allowed_characters(self, characters)
	self.allowed_characters = characters
	return self
end


--- Reset current input selection and return previous value
-- @function input:reset_changes
function M.reset_changes(self)
	self:set_text(self.previous_value)
	unselect(self)
end


return M
