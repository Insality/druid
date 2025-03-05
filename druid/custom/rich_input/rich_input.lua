-- Copyright (c) 2022 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Druid Rich Input custom component.
-- It's wrapper on Input component with cursor and placeholder text
-- @module RichInput
-- @alias druid.rich_input

--- The component druid instance
-- @tfield DruidInstance druid DruidInstance

--- Root node
-- @tfield node root

--- On input field text change callback(self, input_text)
-- @tfield Input input Input

--- On input field text change to empty string callback(self, input_text)
-- @tfield node cursor

--- On input field text change to empty string callback(self, input_text)
-- @tfield node cursor_text

--- On input field text change to empty string callback(self, input_text)
-- @tfield vector3 cursor_position

--- On input field text change to empty string callback(self, input_text)
-- @tfield druid.text input_text

--- On input field text change to empty string callback(self, input_text)
-- @tfield druid.drag drag

--- On input field text change to empty string callback(self, input_text)
-- @tfield druid.text placeholder

--- On input field text change to empty string callback(self, input_text)
-- @tfield vector3 text_position

---

local component = require("druid.component")
local helper = require("druid.helper")
local const  = require("druid.const")
local utf8_lua = require("druid.system.utf8")
local utf8 = utf8 or utf8_lua

---@class druid.rich_input: druid.component
---@field root node
---@field input druid.input
---@field cursor node
---@field cursor_text node
---@field cursor_position vector3
local M = component.create("druid.rich_input")

--local SCHEME = {
--	ROOT = "root",
--	BUTTON = "button",
--	PLACEHOLDER = "placeholder_text",
--	INPUT = "input_text",
--	CURSOR = "cursor_node",
--	CURSOR_TEXT = "cursor_text",
--}

local DOUBLE_CLICK_TIME = 0.35

local function animate_cursor(self)
	gui.cancel_animation(self.cursor_text, "color.w")
	gui.set_alpha(self.cursor_text, 1)
	gui.animate(self.cursor_text, "color.w", 0, gui.EASING_INSINE, 0.8, 0, nil, gui.PLAYBACK_LOOP_PINGPONG)
end


local function set_selection_width(self, selection_width)
	gui.set_visible(self.cursor, selection_width > 0)

	local width = selection_width / self.input.text.scale.x
	local height = gui.get_size(self.cursor).y
	gui.set_size(self.cursor, vmath.vector3(width, height, 0))

	local is_selection_to_right = self.input.cursor_index == self.input.end_index
	gui.set_pivot(self.cursor, is_selection_to_right and gui.PIVOT_E or gui.PIVOT_W)
end


local function update_text(self)
	local left_text_part = utf8.sub(self.input:get_text(), 0, self.input.cursor_index)
	local selected_text_part = utf8.sub(self.input:get_text(), self.input.start_index + 1, self.input.end_index)

	local left_part_width = self.input.text:get_text_size(left_text_part)
	local selected_part_width = self.input.text:get_text_size(selected_text_part)

	local pivot_text = gui.get_pivot(self.input.text.node)
	local pivot_offset = helper.get_pivot_offset(pivot_text)

	self.cursor_position.x = self.text_position.x - self.input.total_width * (0.5 + pivot_offset.x) + left_part_width

	gui.set_position(self.cursor, self.cursor_position)
	gui.set_scale(self.cursor, self.input.text.scale)

	set_selection_width(self, selected_part_width)
end


local function on_select(self)
	gui.set_enabled(self.cursor, true)
	gui.set_enabled(self.placeholder.node, false)
	gui.set_enabled(self.input.button.node, true)

	animate_cursor(self)
	self.drag:set_enabled(true)
end


local function on_unselect(self)
	gui.cancel_animation(self.cursor, gui.PROP_COLOR)
	gui.set_enabled(self.cursor, false)
	gui.set_enabled(self.input.button.node, self.is_button_input_enabled)
	gui.set_enabled(self.placeholder.node, true and #self.input:get_text() == 0)

	self.drag:set_enabled(false)
end


--- Update selection
local function update_selection(self)
	update_text(self)
end


local TEMP_VECTOR = vmath.vector3(0)
local function get_index_by_touch(self, touch)
	local text_node = self.input.text.node
	TEMP_VECTOR.x = touch.screen_x
	TEMP_VECTOR.y = touch.screen_y

	-- Distance to the text node position
	local scene_scale = helper.get_scene_scale(text_node)
	local local_pos = gui.screen_to_local(text_node, TEMP_VECTOR)
	local_pos.x = local_pos.x / scene_scale.x

	-- Offset to the left side of the text node
	local pivot_offset = helper.get_pivot_offset(gui.get_pivot(text_node))
	local_pos.x = local_pos.x + self.input.total_width * (0.5 + pivot_offset.x)
	local_pos.x = local_pos.x - self.text_position.x

	local cursor_index = self.input.text:get_text_index_by_width(local_pos.x)
	return cursor_index
end


local function on_touch_start_callback(self, touch)
	local cursor_index = get_index_by_touch(self, touch)

	if self._last_touch_info.cursor_index == cursor_index then
		local time = socket.gettime()
		if time - self._last_touch_info.time < DOUBLE_CLICK_TIME then
			local len = utf8.len(self.input:get_text())
			self.input:select_cursor(len, 0, len)
			self._last_touch_info.cursor_index = nil

			return
		end
	end

	self._last_touch_info.cursor_index = cursor_index
	self._last_touch_info.time = socket.gettime()

	if self.input.is_lshift then
		local start_index = self.input.start_index
		local end_index = self.input.end_index

		if cursor_index < start_index then
			self.input:select_cursor(cursor_index, cursor_index, end_index)
		elseif cursor_index > end_index then
			self.input:select_cursor(cursor_index, start_index, cursor_index)
		end
	else
		self.input:select_cursor(cursor_index)
	end
end



local function on_drag_callback(self, dx, dy, x, y, touch)
	if not self._last_touch_info.cursor_index then
		return
	end

	local index = get_index_by_touch(self, touch)
	if self._last_touch_info.cursor_index <= index then
		self.input:select_cursor(index, self._last_touch_info.cursor_index, index)
	else
		self.input:select_cursor(index, index, self._last_touch_info.cursor_index)
	end
end


---@param template string The template string name
---@param nodes table Nodes table from gui.clone_tree
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)
	self.root = self:get_node("root")

	self._last_touch_info = {
		cursor_index = nil,
		time = 0,
	}
	self.is_lshift = false
	self.is_lctrl = false

	self.input = self.druid:new_input("button", "input_text")
	self.is_button_input_enabled = gui.is_enabled(self.input.button.node)

	self.cursor = self:get_node("cursor_node")
	self.cursor_position = gui.get_position(self.cursor)
	self.cursor_text = self:get_node("cursor_text")

	self.drag = self.druid:new_drag("button", on_drag_callback)
	self.drag.on_touch_start:subscribe(on_touch_start_callback)
	self.drag:set_input_priority(const.PRIORITY_INPUT_MAX + 1)
	self.drag:set_enabled(false)

	self.input:set_text("")
	self.placeholder = self.druid:new_text("placeholder_text")
	self.text_position = gui.get_position(self.input.text.node)

	self.input.on_input_text:subscribe(update_text)
	self.input.on_input_select:subscribe(on_select)
	self.input.on_input_unselect:subscribe(on_unselect)
	self.input.on_select_cursor_change:subscribe(update_selection)

	on_unselect(self)
	update_text(self)
end


function M:on_input(action_id, action)
	if action_id == const.ACTION_LSHIFT then
		if action.pressed then
			self.is_lshift = true
		elseif action.released then
			self.is_lshift = false
		end
	end

	if action_id == const.ACTION_LCTRL or action_id == const.ACTION_LCMD then
		if action.pressed then
			self.is_lctrl = true
		elseif action.released then
			self.is_lctrl = false
		end
	end

	if self.input.is_selected then
		if action_id == const.ACTION_LEFT and (action.pressed or action.repeated) then
			self.input:move_selection(-1, self.is_lshift, self.is_lctrl)
			return true
		end

		if action_id == const.ACTION_RIGHT and (action.pressed or action.repeated) then
			self.input:move_selection(1, self.is_lshift, self.is_lctrl)
			return true
		end
	end
end


--- Set placeholder text
---@param placeholder_text string The placeholder text
function M:set_placeholder(placeholder_text)
	self.placeholder:set_text(placeholder_text)
	return self
end


--- Select input field
function M:select()
	self.input:select()
end


--- Set input field text
---@param text string The input text
---@return druid.rich_input self Current instance
function M:set_text(text)
	self.input:set_text(text)
	gui.set_enabled(self.placeholder.node, true and #self.input:get_text() == 0)

	return self
end


--- Set input field font
---@param font hash The font hash
---@return druid.rich_input self Current instance
function M:set_font(font)
	gui.set_font(self.input.text.node, font)
	gui.set_font(self.placeholder.node, font)

	return self
end


--- Set input field text
function M:get_text()
	return self.input:get_text()
end


--- Set allowed charaters for input field.
-- See: https://defold.com/ref/stable/string/
-- ex: [%a%d] for alpha and numeric
---@param characters string Regulax exp. for validate user input
---@return druid.rich_input Current instance
function M:set_allowed_characters(characters)
	self.input:set_allowed_characters(characters)

	return self
end


return M
