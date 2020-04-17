--- Druid input text component.
-- Carry on user text input
-- @author Part of code from Britzl gooey input component
-- @module druid.input

local Event = require("druid.event")
local const = require("druid.const")
local component = require("druid.component")
local utf8 = require("druid.system.utf8")

local M = component.create("input", { const.ON_INPUT, const.ON_FOCUS_LOST })


local function select(self)
	gui.reset_keyboard()
	self.marked_value = ""
	if not self.selected then
		self.previous_value = self.value
		self.selected = true
		gui.show_keyboard(self.keyboard_type, false)
		self.on_input_select:trigger(self:get_context())

		if self.style.on_select then
			self.style.on_select(self, self.button.node)
		end
	end
end


local function unselect(self)
	gui.reset_keyboard()
	self.marked_value = ""
	if self.selected then
		self.selected = false
		gui.hide_keyboard()
		self.on_input_unselect:trigger(self:get_context())

		if self.style.on_unselect then
			self.style.on_unselect(self, self.button.node)
		end
	end
end


local function clear_and_select(self)
	self:set_text("")
	select(self)
end


function M.init(self, click_node, text_node, keyboard_type)
	self.druid = self:get_druid(self)
	self.style = self:get_style(self)
	self.text = self.druid:new_text(text_node)

	self.selected = false
	self.previous_value = ""
	self.value = ""
	self.marked_value = ""
	self.current_value = ""
	self.is_empty = true

	self.text_width = 0
	self.market_text_width = 0
	self.total_width = 0

	self.max_length = nil
	self.allowed_characters = nil

	self.keyboard_type = keyboard_type or gui.KEYBOARD_TYPE_NUMBER_PAD

	self.button = self.druid:new_button(click_node, select)
	self.button:set_style(self.style)
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
					if self.style.on_input_wrong then
						self.style.on_input_wrong(self, self.button.node)
					end
				end
				self.marked_value = ""
			end
		end

		if action_id == const.ACTION_MARKED_TEXT then
			self.marked_value = action.text or ""
			if self.max_length then
				input_text = utf8.sub(self.marked_value, 1, self.max_length)
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

		if input_text then
			self:set_text(input_text)
			return true
		end
	end

	return self.selected
end


function M.on_focus_lost(self)
	unselect(self)
end


function M.set_text(self, input_text)
	self.value = input_text

	-- only update the text if it has changed
	local current_value = self.value .. self.marked_value

	if current_value ~= self.current_value then
		self.current_value = current_value

		-- mask text if password field
		local masked_value, masked_marked_value
		if self.keyboard_type == gui.KEYBOARD_TYPE_PASSWORD then
			masked_value = M.mask_text(self.text, "*")
			masked_marked_value = M.mask_text(self.marked_text, "*")
		end

		-- text + marked text
		local value = masked_value or self.value
		local marked_value = masked_marked_value or self.marked_value
		self.is_empty = #value == 0 and #marked_value == 0

		-- measure it
		self.text_width = self.text:get_text_width(value)
		self.marked_text_width = self.text:get_text_width(marked_value)
		self.total_width = self.text_width + self.marked_text_width

		local final_text = value .. marked_value
		self.text:set_to(final_text)

		self.on_input_text:trigger(self:get_context(), final_text)
		if #final_text == 0 then
			self.on_input_empty:trigger(self:get_context(), final_text)
		end
		if self.max_length and #final_text == self.max_length then
			self.on_input_full:trigger(self:get_context(), final_text)
		end
	end
end


function M.get_text(self)
	return self.value .. self.marked_value
end


function M.set_max_length(self, max_length)
	self.max_length = max_length
end


-- [%a%d] for alpha numeric
function M.set_allowed_characters(self, characters)
	self.allowed_characters = characters
end


function M.reset_changes(self)
	self:set_text(self.previous_value)
	unselect(self)
end


return M
