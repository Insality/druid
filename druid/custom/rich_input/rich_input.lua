-- Copyright (c) 2022 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Druid Rich Input custom component.
-- It's wrapper on Input component with cursor and placeholder text
-- @module RichInput
-- @within Input
-- @alias druid.rich_input

--- The component druid instance
-- @tfield DruidInstance druid @{DruidInstance}

--- On input field text change callback(self, input_text)
-- @tfield Input input @{Input}

--- On input field text change to empty string callback(self, input_text)
-- @tfield node cursor

--- On input field text change to max length string callback(self, input_text)
-- @tfield druid.text placeholder @{Text}

---
local const = require("druid.const")
local component = require("druid.component")
local utf8 = require("druid.system.utf8")

local RichInput = component.create("druid.rich_input")

local SCHEME = {
	ROOT = "root",
	BUTTON = "button",
	PLACEHOLDER = "placeholder_text",
	INPUT = "input_text",
	CURSOR = "cursor_node",
	HIGHLIGHT = "highlight_node",
}


local function set_cursor(self)
	if self.touch_pos_x then
		local text = self.input:get_text()
		local node_pos = gui.get_screen_position(self.highlight)
		local touch_delta_x = self.touch_pos_x - node_pos.x
		local letters_count = utf8.len(self.input:get_text())
		local cursor_delta = 0
		local gap = self.input.total_width/2 * -1

		for i = 1, letters_count do
			cursor_delta =  gap + self.text:get_text_size(string.sub(text, 1, i)) - self.half_cursor_width
			if cursor_delta <= touch_delta_x then
				gui.set_position(self.cursor, vmath.vector3(cursor_delta, 0, 0))
				self.cursor_letter_index = i
			end
		end
		
		self.touch_pos_x = nil
	else
		local text = self.input:get_text()
		local gap = self.input.total_width/2 * -1
		local cursor_delta =  gap + self.text:get_text_size(string.sub(text, 1, self.cursor_letter_index)) - self.half_cursor_width
		gui.set_position(self.cursor, vmath.vector3(cursor_delta, 0, 0))
	end
end


local function animate_cursor(self)
	gui.cancel_animation(self.cursor, gui.PROP_COLOR)
	gui.set_color(self.cursor, vmath.vector4(1))
	gui.animate(self.cursor, gui.PROP_COLOR, vmath.vector4(1,1,1,0), gui.EASING_INSINE, 0.8, 0, nil, gui.PLAYBACK_LOOP_PINGPONG)
end


local function update_text(self)
	local text_width = self.input.total_width
	local text_height = self.input.text_height
	animate_cursor(self)
	--gui.set_position(self.cursor, vmath.vector3(text_width/2, 0, 0))
	gui.set_scale(self.cursor, self.input.text.scale)
	gui.set_size(self.highlight, vmath.vector3(text_width, text_height, 0))
	set_cursor(self)
end


local function clear_text(self, replace_with_symbol)
	local spacer = replace_with_symbol or ""
	self.input:set_text(spacer)
	update_text(self)

	if replace_with_symbol then
		gui.set_position(self.cursor, vmath.vector3(self.input.total_width/2, 0, 0))
		self.cursor_letter_index = 1
	else
		gui.set_position(self.cursor, vmath.vector3(0, 0, 0))
		self.cursor_letter_index = 1
	end
	
	gui.set_enabled(self.highlight, false)
	gui.set_enabled(self.cursor, true)
end


local function on_select(self)
	self.cursor_letter_index = utf8.len(self.input:get_text()) or 0
	gui.set_enabled(self.cursor, true)
	gui.set_enabled(self.highlight, false)
	gui.set_enabled(self.placeholder.node, false)
	animate_cursor(self)
end


local function on_unselect(self)
	gui.set_enabled(self.cursor, false)
	gui.set_enabled(self.highlight, false)
	gui.set_enabled(self.placeholder.node, true and #self.input:get_text() == 0)
end


local function on_button_click(self)
	self.touch_pos_x = self.action_pos_x
	gui.set_enabled(self.highlight, false)
	gui.set_enabled(self.cursor, true)
	self.text:set_to(self.input:get_text())
	set_cursor(self)
end


local function on_button_double_click(self)
	if #self.input:get_text() > 0 then
		gui.set_enabled(self.highlight, true)
		gui.set_enabled(self.cursor, false)
	end
end

--- Component init function
-- @tparam RichInput self @{RichInput}
-- @tparam string template The template string name
-- @tparam table nodes Nodes table from gui.clone_tree
function RichInput.init(self, template, nodes)
	self:set_template(template)
	self:set_nodes(nodes)
	self.druid = self:get_druid()
	self.input = self.druid:new_input(self:get_node(SCHEME.BUTTON), self:get_node(SCHEME.INPUT))
	self.cursor = self:get_node(SCHEME.CURSOR)
	self.highlight = self:get_node(SCHEME.HIGHLIGHT) 
	
	self.placeholder = self.druid:new_text(self:get_node(SCHEME.PLACEHOLDER))
	self.text = self.druid:new_text(self:get_node(SCHEME.INPUT))

	self.input.on_input_text:subscribe(update_text)
	self.input.on_input_select:subscribe(on_select)
	self.input.on_input_unselect:subscribe(on_unselect)
	
	self.input.button.on_click:subscribe(on_button_click, self)
	self.input.button.on_double_click:subscribe(on_button_double_click, self)
	self.input.style.NO_CONSUME_INPUT_WHILE_SELECTED = true
	self.input.style.SKIP_INPUT_KEYS = true

	self.cursor_letter_index = 0
	self.action_pos_x = nil
	self.half_cursor_width = self.text:get_text_size("|")/2
	
	on_unselect(self)	
	clear_text(self)	
end


--- Set placeholder text
-- @tparam RichInput self @{RichInput}
-- @tparam string placeholder_text The placeholder text
function RichInput.set_placeholder(self, placeholder_text)
	self.placeholder:set_to(placeholder_text)
	return self
end


function RichInput.on_input(self, action_id, action)
	self.action_pos_x = action.screen_x
	
	if gui.is_enabled(self.highlight) then
		if action_id == const.ACTION_BACKSPACE or action_id == const.ACTION_DEL  then
			clear_text(self)
			on_select(self)
		elseif action_id == const.ACTION_TEXT then
			clear_text(self, action.text)
		end
	else
		if action_id == const.ACTION_DEL and action.pressed then
			local text = self.input:get_text()
			local new_text = utf8.sub(text, 1, self.cursor_letter_index) .. utf8.sub(text, self.cursor_letter_index +2 ) 
			self.input:set_text(new_text)
		end
		if action_id == const.ACTION_BACKSPACE and action.pressed then
			if self.cursor_letter_index > 0 then 
				local text = self.input:get_text()
				local new_text = utf8.sub(text, 1, self.cursor_letter_index-1) .. utf8.sub(text, self.cursor_letter_index +1 ) 
				self.cursor_letter_index = self.cursor_letter_index -1
				self.input:set_text(new_text)
			end
		end
		
		if action_id == const.ACTION_TEXT then
			self.cursor_letter_index = self.cursor_letter_index +1
		end

		if action_id == const.ACTION_LEFT and action.pressed then
			--print("left")
			if self.cursor_letter_index > 1 then
				self.cursor_letter_index = self.cursor_letter_index -1
			end
		elseif action_id == const.ACTION_RIGHT and action.pressed then
			--print("right")
			if self.cursor_letter_index <  utf8.len(self.input:get_text()) then
				self.cursor_letter_index = self.cursor_letter_index + 1
			end
		end
		
		update_text(self)
		self.touch_pos_x = nil
		
		if utf8.len(self.input:get_text()) <=0 then
			self.cursor_letter_index = 0
		end	
	end
	return true
end

return RichInput
