-- Copyright (c) 2023. This code is licensed under MIT license

--- Druid Upgraded Rich Input custom component.
-- It's wrapper on Input component with cursor and placeholder text
-- @author Part of code from Britzl gooey input component /  Druid Rich Input custom component / Druid input text component
-- @module UpgradedRichInput
-- @within Input
-- @alias druid.upgraded_rich_input

--- The component druid instance
-- @tfield DruidInstance druid @{DruidInstance}

--- On input field select callback(self, button_node)
-- @tfield DruidEvent on_input_select @{DruidEvent}

--- On input field unselect callback(self, input_text)
-- @tfield DruidEvent on_input_unselect @{DruidEvent}

--- On input field enter callback(self, input_text)
-- @tfield DruidEvent on_input_enter @{DruidEvent}

--- On input field text change callback(self, input_text)
-- @tfield DruidEvent on_input_text @{DruidEvent}

--- On input field text change to empty string callback(self, input_text)
-- @tfield DruidEvent on_input_empty @{DruidEvent}

--- On input field text change to max length string callback(self, input_text)
-- @tfield DruidEvent on_input_full @{DruidEvent}

--- On trying user input with not allowed character callback(self, params, button_instance)
-- @tfield DruidEvent on_input_wrong @{DruidEvent}

--- Text component
-- @tfield druid.text text @{Text}

--- Button component
-- @tfield druid.button button @{Button}

--- Cursor node
-- @tfield node cursor

--- Outline node
-- @tfield node outline

--- Placeholder text
-- @tfield druid.text placeholder @{Text}

--- Is current input selected now
-- @tfield bool is_selected

--- Is current input is empty now
-- @tfield bool is_empty

--- Is some text outlined
-- @tfield bool outlined

--- Is all text outlined
-- @tfield bool outlined_all

--- Position of first outlined symbol
-- @tfield number outline_from

--- Position of last outlined symbol
-- @tfield number outline_to

--- Number to identify text split by cursor
-- @tfield number cursor_shift

--- Last recieved action
-- @tfield table last_touch

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
local utf8 = require("druid.system.utf8")

local UpgradedRichInput = component.create("druid.upgraded_rich_input")


local SCHEME = {
	ROOT = "root",
	BUTTON = "button",
	INPUT = "input_text",
	CURSOR = "cursor_node",
	PLACEHOLDER = "placeholder_text",
	OUTLINE = "outline_node",
}

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

--- Delete all text in input field
-- @tparam UpgradedRichInput self @{UpgradedRichInput}
local function clear_text(self)
	self.cursor_shift = -1
	self:set_text("")
end

--- on_long_click callback
-- @tparam UpgradedRichInput self @{UpgradedRichInput}
local function clear_and_select(self)
	if self.style.IS_LONGTAP_ERASE then
		clear_text(self)
	end
	self:select()
end

--- Animate Cursor
-- @tparam UpgradedRichInput self @{UpgradedRichInput}
local function animate_cursor(self)
	gui.cancel_animation(self.cursor, gui.PROP_COLOR)
	gui.set_color(self.cursor, vmath.vector4(1))
	gui.animate(self.cursor, gui.PROP_COLOR, vmath.vector4(1,1,1,0), gui.EASING_INSINE, 0.8, 0, nil, gui.PLAYBACK_LOOP_PINGPONG)
end

--- Calculates text width in case it is masked
-- @tparam UpgradedRichInput self @{UpgradedRichInput}
-- @tparam string text
-- @treturn number text width
local function visible_text_size(self, text)
	-- mask text if password field
	local masked_value
	if self.keyboard_type == gui.KEYBOARD_TYPE_PASSWORD then
		local mask_char = self.style.MASK_DEFAULT_CHAR or "*"
		masked_value = mask_text(text, mask_char)
	end

	local value = masked_value or text

	local text_width = self.text:get_text_size(value.."|") -  self.text:get_text_size("|")
	return text_width
end

--- Move cursor
-- @tparam UpgradedRichInput self @{UpgradedRichInput}
local function position_cursor(self)
	local before_cursor_text_size = visible_text_size(self, utf8.sub(self:get_text(), 1, self.cursor_shift))
	gui.set_position(self.cursor, vmath.vector3(self.total_width/2 - (self.total_width - before_cursor_text_size), 0, 0))
end

--- If required resize and make visible outline node, make cursor node invisible
-- @tparam UpgradedRichInput self @{UpgradedRichInput}
local function outline_text(self)
	if self.style.IS_DOUBLETAP_OUTLINE and self.is_selected then
		if self.button.click_in_row == 2 and self.keyboard_type ~= gui.KEYBOARD_TYPE_PASSWORD then
			self.marked_value = ""
			self:update_text()
			
			local text = self:get_text()
			self.outline_from = utf8.len(text) + self.cursor_shift + 2
			self.outline_to = utf8.len(text) + self.cursor_shift + 1
			
			while self.outline_from > 1 and utf8.sub(text, self.outline_from - 1, self.outline_from - 1) ~= " " do
				self.outline_from = self.outline_from - 1
			end
			while self.outline_to < utf8.len(text) and utf8.sub(text, self.outline_to + 1, self.outline_to + 1) ~= " " do
				self.outline_to = self.outline_to + 1
			end
			
			if self.outline_from <= self.outline_to then
				local size_x = visible_text_size(self, utf8.sub(text, self.outline_from, self.outline_to))
				local before_from_text_size = visible_text_size(self, utf8.sub(self:get_text(), 1, self.outline_from - utf8.len(text) - 2))
				self.outlined = true
				
				gui.set_position(self.outline_node, vmath.vector3(self.total_width/2 - (self.total_width - before_from_text_size) + size_x / 2, 0, 0))
				gui.set_size(self.outline_node, vmath.vector3(size_x, gui.get_size(self.text_node).y * gui.get_scale(self.text_node).y / 0.75 * gui.get_scale(self.text_node).y / 0.75, 0))
				gui.set_enabled(self.outline_node, true)
			end
		elseif (self.style.IS_TRIPLETAP_OUTLINE_ALL and self.button.click_in_row == 3) or (self.style.IS_DOUBLETAP_OUTLINE and self.button.click_in_row == 2 and self.keyboard_type == gui.KEYBOARD_TYPE_PASSWORD) then
			self.marked_value = ""
			self:update_text()
			self.outlined = true
			self.outlined_all = true
			gui.set_position(self.outline_node, vmath.vector3(0, 0, 0))
			gui.set_size(self.outline_node, vmath.vector3(self.total_width, gui.get_size(self.text_node).y * gui.get_scale(self.text_node).y / 0.75 * gui.get_scale(self.text_node).y / 0.75, 0))
			gui.set_enabled(self.outline_node, true)
		end
		gui.set_enabled(self.cursor, false)
	end
end

--- Make outline node invisible, make cursor node visible
-- @tparam UpgradedRichInput self @{UpgradedRichInput}
local function cancel_outline(self)
	self.outlined = false
	self.outlined_all = false
	gui.set_enabled(self.outline_node, false)
	gui.set_enabled(self.cursor, true)
	animate_cursor(self)
end

--- Calculate cursor position from mouse touch coordinates
-- @tparam UpgradedRichInput self @{UpgradedRichInput}
local function find_cursor_shift(self)
	if self.last_touch then
		touch_x = self.last_touch.screen_x
		min_distance = nil
		for tmp_cursor_shift = -1 - utf8.len(self.value), -1, 1 do
			test_before_cursor_text_size = self.text:get_text_size(utf8.sub(self:get_text(), 1, tmp_cursor_shift).."|") - self.text:get_text_size("|")
			cursor_x = self.total_width/2 - (self.total_width - test_before_cursor_text_size)
			gui.set_position(self.cursor, vmath.vector3(cursor_x, 0, 0))
			test_x = gui.get_screen_position(self.cursor).x
			test_dist = math.abs(test_x - touch_x)
			if min_distance == nil or test_dist < min_distance then
				min_distance = test_dist
				self.cursor_shift = tmp_cursor_shift
			end
		end
	end
end

--- Component style params.
-- You can override this component styles params in druid styles table
-- or create your own style
-- @tparam UpgradedRichInput self @{UpgradedRichInput}
-- @table style
-- @tfield[opt=false] bool IS_LONGTAP_ERASE Is long tap will erase current input data
-- @tfield[opt=*] string MASK_DEFAULT_CHAR Default character mask for password input
-- @tfield[opt=false] bool IS_UNSELECT_ON_RESELECT If true, call unselect on select selected input
-- @tfield[opt=false] bool IS_DOUBLETAP_OUTLINE If true, call outline_text on double tap
-- @tfield[opt=false] bool IS_TRIPLETAP_OUTLINE_ALL If true, outline_text checks for third consecutive tap
-- @tfield[opt=false] bool UNSELECT_IS_ENTER If true, call on_input_enter on unselect input
-- @tfield function on_select (self, button_node) Callback on input field selecting
-- @tfield function on_unselect (self, button_node) Callback on input field unselecting
-- @tfield function on_input_wrong (self, button_node) Callback on wrong user input
-- @tfield table button_style Custom button style for input node
function UpgradedRichInput.on_style_change(self, style)
	self.style = {}

	self.style.IS_LONGTAP_ERASE = style.IS_LONGTAP_ERASE or false
	self.style.IS_DOUBLETAP_OUTLINE = style.IS_DOUBLETAP_OUTLINE or false
	self.style.IS_TRIPLETAP_OUTLINE_ALL = style.IS_TRIPLETAP_OUTLINE_ALL or false
	self.style.MASK_DEFAULT_CHAR = style.MASK_DEFAULT_CHAR or "*"
	self.style.IS_UNSELECT_ON_RESELECT = style.IS_UNSELECT_ON_RESELECT or false
	self.style.UNSELECT_IS_ENTER = style.UNSELECT_IS_ENTER or false

	self.style.on_select = style.on_select or function(_, button_node) end
	self.style.on_unselect = style.on_unselect or function(_, button_node) end
	self.style.on_input_wrong = style.on_input_wrong or function(_, button_node) end

	self.style.button = style.button or {
		LONGTAP_TIME = 0.4,
		AUTOHOLD_TRIGGER = 0.8,
		DOUBLETAP_TIME = 0.4
	}
end


--- Component init function
-- @tparam UpgradedRichInput self @{UpgradedRichInput}
-- @tparam string template The template string name
-- @tparam table nodes Nodes table from gui.clone_tree
-- @tparam[opt] number keyboard_type Gui keyboard type for input field
function UpgradedRichInput.init(self, template, nodes, keyboard_type)
	self:set_template(template)
	self:set_nodes(nodes)
	self.druid = self:get_druid(self)

	if type(text_node) == const.TABLE then
		self.text = self:get_node(SCHEME.INPUT)
	else
		self.text = self.druid:new_text(self:get_node(SCHEME.INPUT))
	end

	self.cursor = self:get_node(SCHEME.CURSOR)
	self.outline_node = self:get_node(SCHEME.OUTLINE)
	self.text_node = self:get_node(SCHEME.INPUT)
	self.placeholder = self.druid:new_text(self:get_node(SCHEME.PLACEHOLDER))

	self.is_selected = false
	self.value = self.text.last_value
	self.previous_value = self.text.last_value
	self.current_value = self.text.last_value
	self.marked_value = ""
	self.is_empty = true
	self.outlined = false
	self.outlined_all = false
	self.outline_from = 1
	self.outline_to = 1

	self.text_width = 0
	self.market_text_width = 0
	self.total_width = 0

	self.max_length = nil
	self.allowed_characters = nil

	self.cursor_shift = -1

	self.keyboard_type = keyboard_type or gui.KEYBOARD_TYPE_DEFAULT

	self.button = self.druid:new_button(self:get_node(SCHEME.BUTTON), self.select)
	self.button:set_style(self.style)
	self.button.on_click_outside:subscribe(self.unselect)
	self.button.on_long_click:subscribe(clear_and_select)
	self.button.on_double_click:subscribe(outline_text)

	self.on_input_select = Event()
	self.on_input_unselect = Event()
	self.on_input_enter = Event()
	self.on_input_text = Event()
	self.on_input_empty = Event()
	self.on_input_full = Event()
	self.on_input_wrong = Event()

	self.last_touch = nil

	self.text_width = self.text:get_text_size(self.value.."|")
	self.total_width = self.text_width - self.text:get_text_size("|")
	self:set_text(self.value)
end

--- Component on_input function
function UpgradedRichInput.on_input(self, action_id, action)
	self.last_touch = action
	if self.is_selected then
		if not self.blocked_keyboard_input then
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
						if self.outlined then
							if self.outlined_all then
								clear_text(self)
								input_text = action.text
							else
								self.cursor_shift = self.outline_to - utf8.len(self.value) - 1
								input_text = utf8.sub(self.value, 1, self.outline_from - 1) .. action.text .. utf8.sub(self.value, self.outline_to + 1, -1)
							end
							cancel_outline(self)
						else
							input_text = utf8.sub(self.value, 1, self.cursor_shift) .. action.text .. utf8.sub(self.value, utf8.len(self.value) + self.cursor_shift + 2, -1)
						end
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
		
			if action.pressed or action.repeated then
				if action_id == const.ACTION_LEFT then
					if self.outlined then
						cancel_outline(self)
					end
					if self.cursor_shift ~= math.max(-1 - utf8.len(self.value), self.cursor_shift - 1) then
						self.cursor_shift = math.max(-1 - utf8.len(self.value), self.cursor_shift - 1)
						self.marked_value = ""
						self:update_text()
						position_cursor(self)
					end
				elseif action_id == const.ACTION_RIGHT then
					if self.outlined then
						cancel_outline(self)
					end
					if self.cursor_shift ~= math.min(-1, self.cursor_shift + 1) then
						self.cursor_shift = math.min(-1, self.cursor_shift + 1)
						self.marked_value = ""
						self:update_text()
						position_cursor(self)
					end
				end
			end

			if action_id == const.ACTION_MARKED_TEXT then
				self.marked_value = action.text or ""
				if self.max_length then
					self.marked_value = utf8.sub(self.marked_value, 1, self.max_length)
				end
			end

			if action_id == const.ACTION_BACKSPACE and (action.pressed or action.repeated) then
				if self.outlined then
					if self.outlined_all then
						clear_text(self)
					else
						self.cursor_shift = self.outline_to - utf8.len(self.value) - 1
						input_text = utf8.sub(self.value, 1, self.outline_from - 1) .. utf8.sub(self.value, self.outline_to + 1, -1)
					end
					cancel_outline(self)
				else
					input_text = utf8.sub(self.value, 1, self.cursor_shift - 1) .. utf8.sub(self.value, utf8.len(self.value) + self.cursor_shift + 2, -1)
				end
			end

			if action_id == const.ACTION_ENTER and action.released then
				if not self.style.UNSELECT_IS_ENTER then
					self.on_input_enter:trigger(self:get_context(), self:get_text())
				end
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

			if input_text or utf8.len(self.marked_value) > 0 then
				self:set_text(input_text)
				return true
			end
		end
	end
	return self.is_selected
end


function UpgradedRichInput.on_focus_lost(self)
	self:unselect()
end

function UpgradedRichInput.on_freeze_keyboard_input(self)
	self.blocked_keyboard_input = true
end

function UpgradedRichInput.on_unfreeze_keyboard_input(self)
	self.blocked_keyboard_input = false
end

function UpgradedRichInput.on_input_interrupt(self)
	-- self:unselect()
end

--- Update visible text
-- @tparam UpgradedRichInput self @{UpgradedRichInput}
function UpgradedRichInput.update_text(self)
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
	self.is_empty = utf8.len(value) == 0 and utf8.len(marked_value) == 0

	local final_text = utf8.sub(value, 1, self.cursor_shift) .. marked_value .. utf8.sub(value, utf8.len(value) + self.cursor_shift + 2, -1)
	self.text:set_to(final_text)

	self.text_width = self.text:get_text_size(value.."|")
	self.marked_text_width = self.text:get_text_size(marked_value.."|")
	self.total_width = self.text_width + self.marked_text_width - 2 * self.text:get_text_size("|")
end

--- Set text for input field
-- @tparam UpgradedRichInput self @{UpgradedRichInput}
-- @tparam string input_text The string to apply for input field
function UpgradedRichInput.set_text(self, input_text)
	-- Case when update with marked text
	if input_text then
		self.value = input_text
	end

	-- Only update the text if it has changed
	local current_value = utf8.sub(self.value, 1, self.cursor_shift) .. self.marked_value .. utf8.sub(self.value, utf8.len(self.value) + self.cursor_shift + 2, -1)

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
		self.is_empty = utf8.len(value) == 0 and utf8.len(marked_value) == 0

		local final_text = utf8.sub(value, 1, self.cursor_shift) .. marked_value .. utf8.sub(value, utf8.len(value) + self.cursor_shift + 2, -1)
		self.text:set_to(final_text)

		-- measure it
		self.text_width = self.text:get_text_size(value.."|")
		self.marked_text_width = self.text:get_text_size(marked_value.."|")
		self.total_width = self.text_width + self.marked_text_width - 2 * self.text:get_text_size("|")

		self.on_input_text:trigger(self:get_context(), final_text)
		if utf8.len(final_text) == 0 then
			self.on_input_empty:trigger(self:get_context(), final_text)
		end
		if self.max_length and utf8.len(final_text) == self.max_length then
			self.on_input_full:trigger(self:get_context(), final_text)
		end
	end

	animate_cursor(self)
	position_cursor(self)
	gui.set_scale(self.cursor, self.text.scale)
end


--- Select input field. It will show the keyboard and trigger on_select events
-- @tparam UpgradedRichInput self @{UpgradedRichInput}
function UpgradedRichInput.select(self)
	gui.reset_keyboard()
	self.marked_value = ""
	find_cursor_shift(self)
	position_cursor(self)
	
	if not self.is_selected then
		print("select")
		self.druid:set_priority(0, "freeze")
		self:set_input_priority(0, true)
		self.button:set_input_priority(100, true)
		
		self.previous_value = self.value
		self.is_selected = true

		gui.show_keyboard(self.keyboard_type, false)
		self.on_input_select:trigger(self:get_context())

		self.style.on_select(self, self.button.node)

		gui.set_enabled(self.placeholder.node, false)
		gui.set_enabled(self.cursor, true)
		animate_cursor(self)
	else
		cancel_outline(self)
		if self.style.IS_UNSELECT_ON_RESELECT then
			self:unselect(self)
		end
	end
end


--- Remove selection from input. It will hide the keyboard and trigger on_unselect events
-- @tparam UpgradedRichInput self @{UpgradedRichInput}
function UpgradedRichInput.unselect(self)
	gui.reset_keyboard()
	self.marked_value = ""
	if self.is_selected then
		print("unselect")
		self.druid:set_priority(10, "unfreeze")
		self:set_input_priority(10, true)
		self.button:set_input_priority(10, true)
		
		self.is_selected = false
		cancel_outline(self)

		gui.hide_keyboard()
		self.on_input_unselect:trigger(self:get_context(), self:get_text())

		if self.style.UNSELECT_IS_ENTER then
			self.on_input_enter:trigger(self:get_context(), self:get_text())
		end
			
		self.style.on_unselect(self, self.button.node)

		gui.set_enabled(self.placeholder.node, true and utf8.len(self.value .. self.marked_value) == 0)
		gui.set_enabled(self.cursor, false)
	end
end


--- Return current input field text
-- @tparam UpgradedRichInput self @{UpgradedRichInput}
-- @treturn string The current input field text
function UpgradedRichInput.get_text(self)
	return utf8.sub(self.value, 1, self.cursor_shift) .. self.marked_value .. utf8.sub(self.value, utf8.len(self.value) + self.cursor_shift + 2, -1)
end


--- Set maximum length for input field.
-- Pass nil to make input field unliminted (by default)
-- @tparam UpgradedRichInput self @{UpgradedRichInput}
-- @tparam number max_length Maximum length for input text field
-- @treturn druid.upgraded_rich_input Current input instance
function UpgradedRichInput.set_max_length(self, max_length)
	self.max_length = max_length
	return self
end


--- Set allowed charaters for input field.
-- See: https://defold.com/ref/stable/string/
-- ex: [%a%d] for alpha and numeric
-- @tparam UpgradedRichInput self @{UpgradedRichInput}
-- @tparam string characters Regulax exp. for validate user input
-- @treturn druid.upgraded_rich_input Current input instance
function UpgradedRichInput.set_allowed_characters(self, characters)
	self.allowed_characters = characters
	return self
end


--- Reset current input selection and return previous value
-- @tparam UpgradedRichInput self @{UpgradedRichInput}
function UpgradedRichInput.reset_changes(self)
	self:set_text(self.previous_value)
	self:unselect()
end

--- Set placeholder text
-- @tparam UpgradedRichInput self @{UpgradedRichInput}
function UpgradedRichInput.set_placeholder(self, placeholder_text)
	self.placeholder:set_to(placeholder_text)
	return self
end


return UpgradedRichInput