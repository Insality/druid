-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Druid input text component.
-- Carry on user text input
--
-- <a href="https://insality.github.io/druid/druid/index.html?example=general_input" target="_blank"><b>Example Link</b></a>
-- @author Part of code from Britzl gooey input component
-- @module Input
-- @within BaseComponent
-- @alias druid.input

--- On input field select callback(self, button_node)
-- @tfield DruidEvent on_input_select @{DruidEvent}

--- On input field unselect callback(self, input_text)
-- @tfield DruidEvent on_input_unselect @{DruidEvent}

--- On input field text change callback(self, input_text)
-- @tfield DruidEvent on_input_text @{DruidEvent}

--- On input field text change to empty string callback(self, input_text)
-- @tfield DruidEvent on_input_empty @{DruidEvent}

--- On input field text change to max length string callback(self, input_text)
-- @tfield DruidEvent on_input_full @{DruidEvent}

--- On trying user input with not allowed character callback(self, params, button_instance)
-- @tfield DruidEvent on_input_wrong @{DruidEvent}

--- Text component
-- @tfield Text text @{Text}

--- Button component
-- @tfield Button button @{Button}

--- Is current input selected now
-- @tfield bool is_selected

--- Is current input is empty now
-- @tfield bool is_empty

--- Max length for input text
-- @tfield[opt] number max_length

--- Pattern matching for user input
-- @tfield[opt] string allowerd_characters

--- Gui keyboard type for input field
-- @tfield number keyboard_type

---

local Event = require("druid.event")
local const = require("druid.const")
local component = require("druid.component")
local utf8_lua = require("druid.system.utf8")
local utf8 = utf8 or utf8_lua

local Input = component.create("input")


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


local function clear_and_select(self)
	if self.style.IS_LONGTAP_ERASE then
		self:set_text("")
	end

	self:select()
end


--- Component style params.
-- You can override this component styles params in druid styles table
-- or create your own style
-- @table style
-- @tfield[opt=false] bool IS_LONGTAP_ERASE Is long tap will erase current input data
-- @tfield[opt=*] string MASK_DEFAULT_CHAR Default character mask for password input
-- @tfield[opt=false] bool IS_UNSELECT_ON_RESELECT If true, call unselect on select selected input
-- @tfield[opt=false] bool NO_CONSUME_INPUT_WHILE_SELECTED If true, will not consume input while input is selected. It's allow to interact with other components while input is selected (text input still captured)
-- @tfield function on_select (self, button_node) Callback on input field selecting
-- @tfield function on_unselect (self, button_node) Callback on input field unselecting
-- @tfield function on_input_wrong (self, button_node) Callback on wrong user input
-- @tfield table button_style Custom button style for input node
function Input.on_style_change(self, style)
	self.style = {}

	self.style.IS_LONGTAP_ERASE = style.IS_LONGTAP_ERASE or false
	self.style.MASK_DEFAULT_CHAR = style.MASK_DEFAULT_CHAR or "*"
	self.style.IS_UNSELECT_ON_RESELECT = style.IS_UNSELECT_ON_RESELECT or false
	self.style.NO_CONSUME_INPUT_WHILE_SELECTED = style.NO_CONSUME_INPUT_WHILE_SELECTED or false

	self.style.on_select = style.on_select or function(_, button_node) end
	self.style.on_unselect = style.on_unselect or function(_, button_node) end
	self.style.on_input_wrong = style.on_input_wrong or function(_, button_node) end

	self.style.button_style = style.button_style or {
		LONGTAP_TIME = 0.4,
		AUTOHOLD_TRIGGER = 0.8,
		DOUBLETAP_TIME = 0.4
	}
end


--- Component init function
-- @tparam Input self @{Input}
-- @tparam node click_node Node to enabled input component
-- @tparam node|Text text_node Text node what will be changed on user input. You can pass text component instead of text node name @{Text}
-- @tparam[opt] number keyboard_type Gui keyboard type for input field
function Input.init(self, click_node, text_node, keyboard_type)
	self.druid = self:get_druid(self)

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

	self.max_length = nil
	self.allowed_characters = nil

	self.keyboard_type = keyboard_type or gui.KEYBOARD_TYPE_DEFAULT

	self.button = self.druid:new_button(click_node, self.select)
	self.button:set_style(self.button_style)
	self.button.on_click_outside:subscribe(self.unselect)
	self.button.on_long_click:subscribe(clear_and_select)

	if html5 then
		self.button:set_web_user_interaction(true)
	end

	self.on_input_select = Event()
	self.on_input_unselect = Event()
	self.on_input_text = Event()
	self.on_input_empty = Event()
	self.on_input_full = Event()
	self.on_input_wrong = Event()
end


function Input.on_input(self, action_id, action)
	if self.is_selected then
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
			if not utf8.match(hex, "EF9C8[0-3]") then
				if not self.allowed_characters or utf8.match(action.text, self.allowed_characters) then
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

		if input_text or #self.marked_value > 0 then
			self:set_text(input_text)
			return true
		end
	end

	local is_consume_input = not self.style.NO_CONSUME_INPUT_WHILE_SELECTED and self.is_selected
	return is_consume_input
end


function Input.on_focus_lost(self)
	self:unselect()
end


function Input.on_input_interrupt(self)
	-- self:unselect()
end


--- Set text for input field
-- @tparam Input self @{Input}
-- @tparam string input_text The string to apply for input field
function Input.set_text(self, input_text)
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


--- Select input field. It will show the keyboard and trigger on_select events
-- @tparam Input self @{Input}
function Input.select(self)
	gui.reset_keyboard()
	self.marked_value = ""
	if not self.is_selected then
		self:set_input_priority(const.PRIORITY_INPUT_MAX, true)
		self.button:set_input_priority(const.PRIORITY_INPUT_MAX, true)
		self.previous_value = self.value
		self.is_selected = true

		gui.show_keyboard(self.keyboard_type, false)
		self.on_input_select:trigger(self:get_context())

		self.style.on_select(self, self.button.node)
	else
		if self.style.IS_UNSELECT_ON_RESELECT then
			self:unselect(self)
		end
	end
end


--- Remove selection from input. It will hide the keyboard and trigger on_unselect events
-- @tparam Input self @{Input}
function Input.unselect(self)
	gui.reset_keyboard()
	self.marked_value = ""
	self.value = self.current_value
	if self.is_selected then
		self:reset_input_priority()
		self.button:reset_input_priority()
		self.is_selected = false

		gui.hide_keyboard()
		self.on_input_unselect:trigger(self:get_context(), self:get_text())

		self.style.on_unselect(self, self.button.node)
	end
end


--- Return current input field text
-- @tparam Input self @{Input}
-- @treturn string The current input field text
function Input.get_text(self)
	return self.value .. self.marked_value
end


--- Set maximum length for input field.
-- Pass nil to make input field unliminted (by default)
-- @tparam Input self @{Input}
-- @tparam number max_length Maximum length for input text field
-- @treturn druid.input Current input instance
function Input.set_max_length(self, max_length)
	self.max_length = max_length
	return self
end


--- Set allowed charaters for input field.
-- See: https://defold.com/ref/stable/string/
-- ex: [%a%d] for alpha and numeric
-- @tparam Input self @{Input}
-- @tparam string characters Regulax exp. for validate user input
-- @treturn druid.input Current input instance
function Input.set_allowed_characters(self, characters)
	self.allowed_characters = characters
	return self
end


--- Reset current input selection and return previous value
-- @tparam Input self @{Input}
function Input.reset_changes(self)
	self:set_text(self.previous_value)
	self:unselect()
end


return Input
