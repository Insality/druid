-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Component for Wrapping GUI Text Nodes: Druid Text
--
-- ## Overview ##
--
-- Druid Text is a component that provides various adjustment modes for text nodes. It allows text to be scaled down to fit within the size of the text node.
--
-- ## Notes ##
--
-- • The text pivot can be changed using the text:set_pivot method.
-- The anchoring will be inside the text node's area size.
--
-- • There are several text adjustment types available. The default is DOWNSCALE.
-- You can change the default adjustment type in the Text style. Refer to the example below to see all available adjustment types:
--
-- - const.TEXT_ADJUST.DOWNSCALE: Changes the text's scale to fit within the text node's size.
--
-- - const.TEXT_ADJUST.TRIM: Trims the text with a postfix (default: "...", can be overridden in styles)
-- to fit within the text node's size.
--
-- - const.TEXT_ADJUST.NO_ADJUST: No adjustment is applied, similar
-- to the default Defold Text Node behavior.
--
-- - const.TEXT_ADJUST.DOWNSCALE_LIMITED: Changes the text's scale
-- with a limited downscale. You can set the minimum scale using the text:set_minimal_scale() function.
--
-- - const.TEXT_ADJUST.SCROLL: Changes the text's pivot to imitate scrolling within the text box.
-- For better effect, use with a stencil node.
--
-- - const.TEXT_ADJUST.SCALE_THEN_SCROLL: Combines two modes: limited downscale first, then scroll.
--
-- <a href="https://insality.github.io/druid/druid/index.html?example=texts_general" target="_blank"><b>Example Link</b></a>
-- @module Text
-- @within BaseComponent
-- @alias druid.text

--- On set text callback(self, text)
-- @tfield druid.event on_set_text druid.event

--- On adjust text size callback(self, new_scale, text_metrics)
-- @tfield druid.event on_update_text_scale druid.event

--- On change pivot callback(self, pivot)
-- @tfield druid.event on_set_pivot druid.event

--- Text node
-- @tfield node node

--- The node id of text node
-- @tfield hash node_id

--- Current text position
-- @tfield vector3 pos

--- The last text value
-- @tfield string last_value

--- Initial text node scale
-- @tfield vector3 start_scale

--- Current text node scale
-- @tfield vector3 scale

--- Initial text node size
-- @tfield vector3 start_size

--- Current text node available are
-- @tfield vector3 text_area

--- Current text size adjust settings
-- @tfield number adjust_type

--- Current text color
-- @tfield vector3 color

---

local Event = require("druid.event")
local const = require("druid.const")
local helper = require("druid.helper")
local utf8_lua = require("druid.system.utf8")
local component = require("druid.component")
local utf8 = utf8 or utf8_lua --[[@as utf8]]

---@class druid.text: druid.base_component
---@field node node
---@field on_set_text druid.event
---@field on_update_text_scale druid.event
---@field on_set_pivot druid.event
---@field style table
---@field private start_pivot number
---@field private start_scale vector3
---@field private scale vector3
local M = component.create("text")

local function update_text_size(self)
	if self.scale.x == 0 or self.scale.y == 0 then
		return
	end
	if self.start_scale.x == 0 or self.start_scale.y == 0 then
		return
	end

	local size = vmath.vector3(
		self.start_size.x * (self.start_scale.x / self.scale.x),
		self.start_size.y * (self.start_scale.y / self.scale.y),
		self.start_size.z
	)
	gui.set_size(self.node, size)
end


--- Reset initial scale for text
local function reset_default_scale(self)
	self.scale.x = self.start_scale.x
	self.scale.y = self.start_scale.y
	self.scale.z = self.start_scale.z
	gui.set_scale(self.node, self.start_scale)
	gui.set_size(self.node, self.start_size)
end


local function is_fit_info_area(self, metrics)
	return metrics.width * self.scale.x <= self.text_area.x and
		   metrics.height * self.scale.y <= self.text_area.y
end


--- Setup scale x, but can only be smaller, than start text scale
local function update_text_area_size(self)
	reset_default_scale(self)

	local metrics = helper.get_text_metrics_from_node(self.node)

	if metrics.width == 0 then
		reset_default_scale(self)
		self.on_update_text_scale:trigger(self:get_context(), self.start_scale, metrics)
		return
	end

	local text_area_width = self.text_area.x
	local text_area_height = self.text_area.y

	-- Adjust by width
	local scale_modifier = text_area_width / metrics.width

	-- Adjust by height
	if self:is_multiline() then
		-- Approximate scale by height to start adjust scale
		scale_modifier = math.sqrt(text_area_height / metrics.height)
		if metrics.width * scale_modifier > text_area_width then
			scale_modifier = text_area_width / metrics.width
		end

		-- #RMME
		if self._minimal_scale then
			scale_modifier = math.max(scale_modifier, self._minimal_scale)
		end
		-- Limit max scale by initial scale
		scale_modifier = math.min(scale_modifier, self.start_scale.x)
		-- #RMME

		local is_fit = is_fit_info_area(self, metrics)
		local step = is_fit and self.style.ADJUST_SCALE_DELTA or -self.style.ADJUST_SCALE_DELTA

		for i = 1, self.style.ADJUST_STEPS do
			-- Grow down to check if we fit
			if step < 0 and is_fit then
				break
			end
			-- Grow up to check if we still fit
			if step > 0 and not is_fit then
				break
			end

			scale_modifier = scale_modifier + step

			if self._minimal_scale then
				scale_modifier = math.max(scale_modifier, self._minimal_scale)
			end
			-- Limit max scale by initial scale
			scale_modifier = math.min(scale_modifier, self.start_scale.x)

			self.scale.x = scale_modifier
			self.scale.y = scale_modifier
			self.scale.z = self.start_scale.z
			gui.set_scale(self.node, self.scale)
			update_text_size(self)
			metrics = helper.get_text_metrics_from_node(self.node)
			is_fit = is_fit_info_area(self, metrics)
		end
	end

	if self._minimal_scale then
		scale_modifier = math.max(scale_modifier, self._minimal_scale)
	end

	-- Limit max scale by initial scale
	scale_modifier = math.min(scale_modifier, self.start_scale.x)

	self.scale.x = scale_modifier
	self.scale.y = scale_modifier
	self.scale.z = self.start_scale.z
	gui.set_scale(self.node, self.scale)
	update_text_size(self)

	self.on_update_text_scale:trigger(self:get_context(), self.scale, metrics)
end


local function update_text_with_trim(self, trim_postfix)
	local max_width = self.text_area.x
	local text_width = self:get_text_size()

	if text_width > max_width then
		local text_length = utf8.len(self.last_value)
		local new_text = self.last_value
		while text_width > max_width do
			text_length = text_length - 1
			new_text = utf8.sub(self.last_value, 1, text_length)
			text_width = self:get_text_size(new_text .. trim_postfix)
			if text_length == 0 then
				break
			end
		end

		gui.set_text(self.node, new_text .. trim_postfix)
	else
		gui.set_text(self.node, self.last_value)
	end
end


local function update_text_with_anchor_shift(self)
	if self:get_text_size() >= self.text_area.x then
		self:set_pivot(const.REVERSE_PIVOTS[self.start_pivot])
	else
		self:set_pivot(self.start_pivot)
	end
end


local function update_adjust(self)
	if not self.adjust_type or self.adjust_type == const.TEXT_ADJUST.NO_ADJUST then
		reset_default_scale(self)
		return
	end

	if self.adjust_type == const.TEXT_ADJUST.DOWNSCALE then
		update_text_area_size(self)
	end

	if self.adjust_type == const.TEXT_ADJUST.TRIM then
		update_text_with_trim(self, self.style.TRIM_POSTFIX)
	end

	if self.adjust_type == const.TEXT_ADJUST.DOWNSCALE_LIMITED then
		update_text_area_size(self)
	end

	if self.adjust_type == const.TEXT_ADJUST.SCROLL then
		update_text_with_anchor_shift(self)
	end

	if self.adjust_type == const.TEXT_ADJUST.SCALE_THEN_SCROLL then
		update_text_area_size(self)
		update_text_with_anchor_shift(self)
	end
end


--- Component style params.
-- You can override this component styles params in druid styles table
-- or create your own style
-- @table style
-- @tfield string|nil TRIM_POSTFIX The postfix for TRIM adjust type. Default: ...
-- @tfield string|nil DEFAULT_ADJUST The default adjust type for any text component. Default: DOWNSCALE
-- @tfield string|nil ADJUST_STEPS Amount of iterations for text adjust by height. Default: 20
-- @tfield string|nil ADJUST_SCALE_DELTA Scale step on each height adjust step. Default: 0.02
function M:on_style_change(style)
	self.style = {}
	self.style.TRIM_POSTFIX = style.TRIM_POSTFIX or "..."
	self.style.DEFAULT_ADJUST = style.DEFAULT_ADJUST or const.TEXT_ADJUST.DOWNSCALE
	self.style.ADJUST_STEPS = style.ADJUST_STEPS or 20
	self.style.ADJUST_SCALE_DELTA = style.ADJUST_SCALE_DELTA or 0.02
end


--- The Text constructor
---@param node string|node Node name or GUI Text Node itself
---@param value string|nil Initial text. Default value is node text from GUI scene. Default: nil
---@param adjust_type string|nil Adjust type for text. By default is DOWNSCALE. Look const.TEXT_ADJUST for reference. Default: DOWNSCALE
function M:init(node, value, adjust_type)
	self.node = self:get_node(node)
	self.pos = gui.get_position(self.node)
	self.node_id = gui.get_id(self.node)

	self.start_pivot = gui.get_pivot(self.node)
	self.start_scale = gui.get_scale(self.node)
	self.scale = gui.get_scale(self.node)

	self.start_size = gui.get_size(self.node)
	self.text_area = gui.get_size(self.node)
	self.text_area.x = self.text_area.x * self.start_scale.x
	self.text_area.y = self.text_area.y * self.start_scale.y

	self.adjust_type = adjust_type or self.style.DEFAULT_ADJUST
	self.color = gui.get_color(self.node)

	self.on_set_text = Event()
	self.on_set_pivot = Event()
	self.on_update_text_scale = Event()

	self:set_to(value or gui.get_text(self.node))
	return self
end


function M:on_layout_change()
	self:set_to(self.last_value)
end


function M:on_message_input(node_id, message)
	if node_id ~= self.node_id  then
		return false
	end

	if message.action == const.MESSAGE_INPUT.TEXT_SET then
		Text.set_to(self, message.value)
	end
end


--- Calculate text width with font with respect to trailing space
---@param text|nil string
---@return number Width
---@return number Height
function M:get_text_size(text)
	text = text or self.last_value
	local font_name = gui.get_font(self.node)
	local font = gui.get_font_resource(font_name)
	local scale = self.last_scale or gui.get_scale(self.node)
	local linebreak = gui.get_line_break(self.node)
	local dot_width = resource.get_text_metrics(font, ".").width

	local metrics = resource.get_text_metrics(font, text .. ".", {
		line_break = linebreak,
		leading = 1,
		tracking = 0,
		width = self.start_size.x
	})

	local width = metrics.width - dot_width
	return width * scale.x, metrics.height * scale.y
end


--- Get chars count by width
---@param width number
---@return number Chars count
function M:get_text_index_by_width(width)
	local text = self.last_value
	local font_name = gui.get_font(self.node)
	local font = gui.get_font_resource(font_name)
	local scale = self.last_scale or gui.get_scale(self.node)

	local text_index = 0
	local text_width = 0
	local text_length = utf8.len(text)
	local dot_width = resource.get_text_metrics(font, ".").width
	local previous_width = 0
	for i = 1, text_length do
		local subtext = utf8.sub(text, 1, i) .. "."
		local subtext_width = resource.get_text_metrics(font, subtext).width
		subtext_width = subtext_width - dot_width
		text_width = subtext_width * scale.x
		local width_delta = text_width - previous_width
		previous_width = text_width

		if (text_width - width_delta/2) < width then
			text_index = i
		else
			break
		end
	end

	return text_index
end


--- Set text to text field
---@deprecated
---@param set_to string Text for node
---@return druid.text Current text instance
function M:set_to(set_to)
	set_to = tostring(set_to or "")

	self.last_value = set_to
	gui.set_text(self.node, set_to)

	self.on_set_text:trigger(self:get_context(), set_to)

	update_adjust(self)

	return self
end


function M:set_text(new_text)
---@diagnostic disable-next-line: deprecated
	return self:set_to(new_text)
end


function M:get_text()
	return self.last_value
end


--- Set text area size
---@param size vector3 The new text area size
---@return druid.text Current text instance
function M:set_size(size)
	self.start_size = size
	self.text_area = vmath.vector3(size)
	self.text_area.x = self.text_area.x * self.start_scale.x
	self.text_area.y = self.text_area.y * self.start_scale.y
	update_adjust(self)
end


--- Set color
---@param color vector4 Color for node
---@return druid.text Current text instance
function M:set_color(color)
	self.color = color
	gui.set_color(self.node, color)

	return self
end


--- Set alpha
---@param alpha number Alpha for node
---@return druid.text Current text instance
function M:set_alpha(alpha)
	self.color.w = alpha
	gui.set_color(self.node, self.color)

	return self
end


--- Set scale
---@param scale vector3 Scale for node
---@return druid.text Current text instance
function M:set_scale(scale)
	self.last_scale = scale
	gui.set_scale(self.node, scale)

	return self
end


--- Set text pivot. Text will re-anchor inside text area
---@param pivot number The gui.PIVOT_* constant
---@return druid.text Current text instance
function M:set_pivot(pivot)
	local prev_pivot = gui.get_pivot(self.node)
	local prev_offset = const.PIVOTS[prev_pivot]

	gui.set_pivot(self.node, pivot)
	local cur_offset = const.PIVOTS[pivot]

	local pos_offset = vmath.vector3(
		self.text_area.x * (cur_offset.x - prev_offset.x),
		self.text_area.y * (cur_offset.y - prev_offset.y),
		0
	)

	self.pos = self.pos + pos_offset
	gui.set_position(self.node, self.pos)

	self.on_set_pivot:trigger(self:get_context(), pivot)

	return self
end


--- Return true, if text with line break
---@return boolean Is text node with line break
function M:is_multiline()
	return gui.get_line_break(self.node)
end


--- Set text adjust, refresh the current text visuals, if needed
---@param adjust_type string|nil See const.TEXT_ADJUST. If pass nil - use current adjust type
---@param minimal_scale number|nil If pass nil - not use minimal scale
---@return druid.text Current text instance
function M:set_text_adjust(adjust_type, minimal_scale)
	self.adjust_type = adjust_type
	self._minimal_scale = minimal_scale
	self:set_to(self.last_value)

	return self
end


--- Set minimal scale for DOWNSCALE_LIMITED or SCALE_THEN_SCROLL adjust types
---@param minimal_scale number If pass nil - not use minimal scale
---@return druid.text Current text instance
function M:set_minimal_scale(minimal_scale)
	self._minimal_scale = minimal_scale

	return self
end


--- Return current text adjust type
---@return number The current text adjust type
function M:get_text_adjust(adjust_type)
	return self.adjust_type
end


return M
