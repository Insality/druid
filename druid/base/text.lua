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
-- @tfield DruidEvent on_set_text @{DruidEvent}

--- On adjust text size callback(self, new_scale, text_metrics)
-- @tfield DruidEvent on_update_text_scale @{DruidEvent}

--- On change pivot callback(self, pivot)
-- @tfield DruidEvent on_set_pivot @{DruidEvent}

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
local utf8 = utf8 or utf8_lua

local Text = component.create("text")


local function update_text_size(self)
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

	local max_width = self.text_area.x
	local max_height = self.text_area.y

	local metrics = helper.get_text_metrics_from_node(self.node)

	if metrics.width == 0 then
		reset_default_scale(self)
		self.on_update_text_scale:trigger(self:get_context(), self.start_scale, metrics)
		return
	end

	local scale_modifier = max_width / metrics.width
	scale_modifier = math.min(scale_modifier, self.start_scale.x)

	if self:is_multiline() then
		local scale_modifier_by_height = math.sqrt(max_height / metrics.height)
		scale_modifier = math.min(self.start_scale.y, scale_modifier_by_height)

		if metrics.width * scale_modifier > max_width then
			scale_modifier = math.min(max_width / metrics.width, self.start_scale.x)
		end
	end

	if self._minimal_scale then
		scale_modifier = math.max(scale_modifier, self._minimal_scale)
	end

	local new_scale = vmath.vector3(scale_modifier, scale_modifier, self.start_scale.z)
	gui.set_scale(self.node, new_scale)
	self.scale = new_scale
	update_text_size(self)

	self.on_update_text_scale:trigger(self:get_context(), new_scale, metrics)
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
		end

		gui.set_text(self.node, new_text .. trim_postfix)
	end
end


local function update_text_with_anchor_shift(self)
	if self:get_text_size() >= self.text_area.x then
		self:set_pivot(const.REVERSE_PIVOTS[self.start_pivot])
	else
		self:set_pivot(self.start_pivot)
	end
end


-- calculate space width with font
local function get_space_width(self, font)
	if not self._space_width[font] then
		local no_space = resource.get_text_metrics(font, "1").width
		local with_space = resource.get_text_metrics(font, " 1").width
		self._space_width[font] = with_space - no_space
	end

	return self._space_width[font]
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
function Text.on_style_change(self, style)
	self.style = {}
	self.style.TRIM_POSTFIX = style.TRIM_POSTFIX or "..."
	self.style.DEFAULT_ADJUST = style.DEFAULT_ADJUST or const.TEXT_ADJUST.DOWNSCALE
end


--- The @{Text} constructor
-- @tparam Text self @{Text}
-- @tparam string|node node Node name or GUI Text Node itself
-- @tparam string|nil value Initial text. Default value is node text from GUI scene.
-- @tparam string|nil adjust_type Adjust type for text. By default is DOWNSCALE. Look const.TEXT_ADJUST for reference. Default: downscale
function Text.init(self, node, value, adjust_type)
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

	self._space_width = {}

	self:set_to(value or gui.get_text(self.node))
	return self
end


function Text.on_layout_change(self)
	self:set_to(self.last_value)
end


function Text.on_message_input(self, node_id, message)
	if node_id ~= self.node_id  then
		return false
	end

	if message.action == const.MESSAGE_INPUT.TEXT_SET then
		Text.set_to(self, message.value)
	end
end


--- Calculate text width with font with respect to trailing space
-- @tparam Text self @{Text}
-- @tparam string|nil text
-- @treturn number Width
-- @treturn number Height
function Text.get_text_size(self, text)
	text = text or self.last_value
	local font_name = gui.get_font(self.node)
	local font = gui.get_font_resource(font_name)
	local scale = gui.get_scale(self.node)
	local linebreak = gui.get_line_break(self.node)
	local metrics = resource.get_text_metrics(font, text, {
		line_break = linebreak,
		leading = 1,
		tracking = 0,
		width = self.start_size.x
	})
	local width = metrics.width
	for i = #text, 1, -1 do
		local c = string.sub(text, i, i)
		if c ~= ' ' then
			break
		end

		width = width + get_space_width(self, font)
	end

	return width * scale.x, metrics.height * scale.y
end


--- Set text to text field
-- @tparam Text self @{Text}
-- @tparam string|number|boolean set_to Text for node
-- @treturn Text Current text instance
function Text.set_to(self, set_to)
	set_to = set_to or ""

	self.last_value = set_to
	gui.set_text(self.node, set_to)

	self.on_set_text:trigger(self:get_context(), set_to)

	update_adjust(self)

	return self
end


--- Set text area size
-- @tparam Text self @{Text}
-- @tparam vector3 size The new text area size
-- @treturn Text Current text instance
function Text.set_size(self, size)
	self.start_size = size
	self.text_area = vmath.vector3(size)
	self.text_area.x = self.text_area.x * self.start_scale.x
	self.text_area.y = self.text_area.y * self.start_scale.y
	update_adjust(self)
end


--- Set color
-- @tparam Text self @{Text}
-- @tparam vector4 color Color for node
-- @treturn Text Current text instance
function Text.set_color(self, color)
	self.color = color
	gui.set_color(self.node, color)

	return self
end


--- Set alpha
-- @tparam Text self @{Text}
-- @tparam number alpha Alpha for node
-- @treturn Text Current text instance
function Text.set_alpha(self, alpha)
	self.color.w = alpha
	gui.set_color(self.node, self.color)

	return self
end


--- Set scale
-- @tparam Text self @{Text}
-- @tparam vector3 scale Scale for node
-- @treturn Text Current text instance
function Text.set_scale(self, scale)
	self.last_scale = scale
	gui.set_scale(self.node, scale)

	return self
end


--- Set text pivot. Text will re-anchor inside text area
-- @tparam Text self @{Text}
-- @tparam number pivot The gui.PIVOT_* constant
-- @treturn Text Current text instance
function Text.set_pivot(self, pivot)
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
-- @tparam Text self @{Text}
-- @treturn boolean Is text node with line break
function Text.is_multiline(self)
	return gui.get_line_break(self.node)
end


--- Set text adjust, refresh the current text visuals, if needed
-- @tparam Text self @{Text}
-- @tparam string|nil adjust_type See const.TEXT_ADJUST. If pass nil - use current adjust type
-- @tparam number|nil minimal_scale If pass nil - not use minimal scale
-- @treturn Text Current text instance
function Text.set_text_adjust(self, adjust_type, minimal_scale)
	self.adjust_type = adjust_type
	self._minimal_scale = minimal_scale
	self:set_to(self.last_value)

	return self
end


--- Set minimal scale for DOWNSCALE_LIMITED or SCALE_THEN_SCROLL adjust types
-- @tparam Text self @{Text}
-- @tparam number minimal_scale If pass nil - not use minimal scale
-- @treturn Text Current text instance
function Text.set_minimal_scale(self, minimal_scale)
	self._minimal_scale = minimal_scale

	return self
end


--- Return current text adjust type
-- @treturn number The current text adjust type
function Text.get_text_adjust(self, adjust_type)
	return self.adjust_type
end


return Text
