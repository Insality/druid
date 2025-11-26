local helper = require("druid.helper")
local const  = require("druid.const")
local utf8_lua = require("druid.system.utf8")
local utf8 = utf8 or utf8_lua

---The widget that handles a rich text input field, it's a wrapper around the druid.input component
---@class widget.rich_input: druid.widget
---@field root node The root node of the rich input
---@field input druid.input The input component
---@field cursor node The cursor node
---@field cursor_text node The cursor text node
---@field cursor_position vector3 The position of the cursor
local M = {}

local DOUBLE_CLICK_TIME = 0.35
local TEMP_VECTOR = vmath.vector3(0)


function M:init()
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

	self.drag = self.druid:new_drag("button", function(...) return self:_on_drag_callback(...) end)
	self.drag.on_touch_start:subscribe(function(...) return self:_on_touch_start_callback(...) end)
	self.drag:set_input_priority(const.PRIORITY_INPUT_MAX + 1)
	self.drag:set_enabled(false)

	self.input:set_text("")
	self.placeholder = self.druid:new_text("placeholder_text")
	self.text_position = gui.get_position(self.input.text.node)

	self.input.on_input_text:subscribe(function() return self:_update_text() end)
	self.input.on_input_select:subscribe(function() return self:_on_select() end)
	self.input.on_input_unselect:subscribe(function() return self:_on_unselect() end)
	self.input.on_select_cursor_change:subscribe(function() return self:_update_selection() end)

	self:_on_unselect()
	self:_update_text()
end


---@private
---@param action_id hash Action id from on_input
---@param action table Action table from on_input
---@return boolean is_consumed True if input was consumed
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

	return false
end


---Set placeholder text
---@param placeholder_text string The placeholder text
---@return widget.rich_input self Current instance
function M:set_placeholder(placeholder_text)
	self.placeholder:set_text(placeholder_text)
	return self
end


---Select input field
---@return widget.rich_input self Current instance
function M:select()
	self.input:select()
	return self
end


---Set input field text
---@param text string The input text
---@return widget.rich_input self Current instance
function M:set_text(text)
	self.input:set_text(text)
	gui.set_enabled(self.placeholder.node, true and #self.input:get_text() == 0)

	return self
end


---Set input field font
---@param font hash The font hash
---@return widget.rich_input self Current instance
function M:set_font(font)
	gui.set_font(self.input.text.node, font)
	gui.set_font(self.placeholder.node, font)

	return self
end


---Set input field text
function M:get_text()
	return self.input:get_text()
end


---Set allowed charaters for input field.
-- See: https://defold.com/ref/stable/string/
-- ex: [%a%d] for alpha and numeric
---@param characters string Regular expression for validate user input
---@return widget.rich_input self Current instance
function M:set_allowed_characters(characters)
	self.input:set_allowed_characters(characters)

	return self
end


function M:_animate_cursor()
	gui.cancel_animation(self.cursor_text, "color.w")
	gui.set_alpha(self.cursor_text, 1)
	gui.animate(self.cursor_text, "color.w", 0, gui.EASING_INSINE, 0.8, 0, nil, gui.PLAYBACK_LOOP_PINGPONG)
end


function M:_set_selection_width(selection_width)
	gui.set_visible(self.cursor, selection_width > 0)

	local width = selection_width / self.input.text.scale.x
	local height = gui.get_size(self.cursor).y
	gui.set_size(self.cursor, vmath.vector3(width, height, 0))

	local is_selection_to_right = self.input.cursor_index == self.input.end_index
	gui.set_pivot(self.cursor, is_selection_to_right and gui.PIVOT_E or gui.PIVOT_W)
end


function M:_update_text()
	local full_text = self.input:get_text()
	local visible_text = self.input.text:get_text()

	local is_truncated = visible_text ~= full_text
	local cursor_index = self.input.cursor_index
	if is_truncated then
		-- If text is truncated, we need to adjust the cursor index
		-- to the last visible character
		cursor_index = utf8.len(visible_text)

	end

	local left_text_part = utf8.sub(self.input:get_text(), 0, cursor_index)
	local selected_text_part = utf8.sub(self.input:get_text(), self.input.start_index + 1, self.input.end_index)

	local left_part_width = self.input.text:get_text_size(left_text_part)
	local selected_part_width = self.input.text:get_text_size(selected_text_part)

	local pivot_text = gui.get_pivot(self.input.text.node)
	local pivot_offset = helper.get_pivot_offset(pivot_text)

	self.cursor_position.x = self.text_position.x - self.input.text_width * (0.5 + pivot_offset.x) + left_part_width

	gui.set_position(self.cursor, self.cursor_position)
	gui.set_scale(self.cursor, self.input.text.scale)

	self:_set_selection_width(selected_part_width)
end


function M:_on_select()
	gui.set_enabled(self.cursor, true)
	gui.set_enabled(self.placeholder.node, false)
	gui.set_enabled(self.input.button.node, true)

	self:_animate_cursor()
	self.drag:set_enabled(true)
end


function M:_on_unselect()
	gui.cancel_animation(self.cursor, gui.PROP_COLOR)
	gui.set_enabled(self.cursor, false)
	gui.set_enabled(self.input.button.node, self.is_button_input_enabled)
	gui.set_enabled(self.placeholder.node, true and #self.input:get_text() == 0)

	self.drag:set_enabled(false)
end


---Update selection
function M:_update_selection()
	self:_update_text()
end


function M:_get_index_by_touch(touch)
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


function M:_on_touch_start_callback(touch)
	local cursor_index = self:_get_index_by_touch(touch)

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


---@param dx number The delta x position
---@param dy number The delta y position
---@param x number The x position
---@param y number The y position
---@param touch table The touch table
function M:_on_drag_callback(dx, dy, x, y, touch)
	if not self._last_touch_info.cursor_index then
		return
	end

	local index = self:_get_index_by_touch(touch)
	if self._last_touch_info.cursor_index <= index then
		self.input:select_cursor(index, self._last_touch_info.cursor_index, index)
	else
		self.input:select_cursor(index, index, self._last_touch_info.cursor_index)
	end
end


return M
