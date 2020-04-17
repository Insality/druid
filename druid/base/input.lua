--- Druid input text component.
-- Carry on user text input
-- @author Part of code from Britzl gooey input component
-- @module druid.input

local const = require("druid.const")
local component = require("druid.component")
local utf8 = require("druid.system.utf8")

local M = component.create("input", { const.ON_INPUT })


local function select(self)
	gui.reset_keyboard()
	if not self.selected then
		print("selected")
		self.selected = true
		gui.show_keyboard(gui.KEYBOARD_TYPE_DEFAULT, false)
	end
end


local function unselect(self)
	gui.reset_keyboard()
	if self.selected then
		self.selected = false
		print("unselected")
		gui.hide_keyboard()
	end
end


function M.init(self, click_node, text_node)
	self.druid = self:get_druid(self)
	self.text = self.druid:new_text(text_node)

	self.selected = false
	self.value = ""
	self.marked_value = ""
	self.current_value = ""
	self.is_empty = true

	self.text_width = 0
	self.market_text_width = 0
	self.total_width = 0

	self.max_width = 10

	self.keyboard_type = gui.KEYBOARD_TYPE_DEFAULT

	self.button = self.druid:new_button(click_node, select)
	self.button.on_click_outside:subscribe(unselect)
end


function M.on_input(self, action_id, action)
	if self.selected then
		local input_text = nil
		if action_id == const.ACTION_TEXT then
			print("usual", action.text)
			-- ignore return key
			if action.text == "\n" or action.text == "\r" then
				return true
			end

			local hex = string.gsub(action.text,"(.)", function (c)
				return string.format("%02X%s",string.byte(c), "")
			end)

			-- ignore arrow keys
			if not string.match(hex, "EF9C8[0-3]") then
				-- if not config or not config.allowed_characters or action.text:match(config.allowed_characters) then
				input_text = self.value .. action.text
				if self.max_length then
					input_text = utf8.sub(self.value, 1, self.max_length)
				end
				self.marked_value = ""
			end
		end

		if action_id == const.ACTION_MARKED_TEXT then
			print("marked")
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

		if input_text then
			print("set input_text", input_text)
			self:set_text(input_text)
			return true
		end
	end

	return self.selected
end


function M.set_text(self, input_text)
	self.value = input_text

	-- only update the text if it has changed
	local current_value = self.value .. self.marked_value

	print(self.value)
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

		self.text:set_to(value .. marked_value)
	end
end


function M.get_text(self)
	return self.value .. self.marked_value
end



return M
