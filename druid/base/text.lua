--- Component to handle all GUI texts.
-- Druid text can adjust itself for text node size
-- Text will never will be outside of his text size (even multiline)
-- @module druid.text

--- Component events
-- @table Events
-- @tfield druid_event on_set_text On set text callback
-- @tfield druid_event on_update_text_scale On adjust text size callback
-- @tfield druid_event on_set_pivot On change pivot callback

--- Component fields
-- @table Fields
-- @tfield node node Text node
-- @tfield vector3 pos Current text position
-- @tfield vector3 start_scale Initial text node scale
-- @tfield vector3 scale Current text node scale
-- @tfield vector3 start_size Initial text node size
-- @tfield vector3 text_area Current text node available are
-- @tfield bool is_no_adjust Current text size adjust settings
-- @tfield vector3 color Current text color

local Event = require("druid.event")
local const = require("druid.const")
local component = require("druid.component")

local M = component.create("text")


local function update_text_size(self)
	local size = vmath.vector3(
		self.start_size.x * (self.start_scale.x / self.scale.x),
		self.start_size.y * (self.start_scale.y / self.scale.y),
		self.start_size.z
	)
	gui.set_size(self.node, size)
end


--- Setup scale x, but can only be smaller, than start text scale
local function update_text_area_size(self)
	gui.set_scale(self.node, self.start_scale)
	gui.set_size(self.node, self.start_size)

	local max_width = self.text_area.x
	local max_height = self.text_area.y

	local metrics = gui.get_text_metrics_from_node(self.node)
	local cur_scale = gui.get_scale(self.node)

	local scale_modifier = max_width / metrics.width
	scale_modifier = math.min(scale_modifier, self.start_scale.x)

	local scale_modifier_height = max_height / metrics.height
	scale_modifier = math.min(scale_modifier, scale_modifier_height)

	local new_scale = vmath.vector3(scale_modifier, scale_modifier, cur_scale.z)
	gui.set_scale(self.node, new_scale)
	self.scale = new_scale

	update_text_size(self)

	self.on_update_text_scale:trigger(self:get_context(), new_scale)
end


-- calculate space width with font
local function get_space_width(self, font)
	if not self._space_width[font] then
		local no_space = gui.get_text_metrics(font, "1", 0, false, 0, 0).width
		local with_space = gui.get_text_metrics(font, " 1", 0, false, 0, 0).width
		self._space_width[font] = with_space - no_space
	end

	return self._space_width[font]
end


--- Component init function
-- @function text:init
-- @tparam node node Gui text node
-- @tparam[opt] string value Initial text. Default value is node text from GUI scene.
-- @tparam[opt] bool no_adjust If true, text will be not auto-adjust size
function M.init(self, node, value, no_adjust)
	self.node = self:get_node(node)
	self.pos = gui.get_position(self.node)

	self.start_scale = gui.get_scale(self.node)
	self.scale = gui.get_scale(self.node)

	self.start_size = gui.get_size(self.node)
	self.text_area = gui.get_size(self.node)
	self.text_area.x = self.text_area.x * self.start_scale.x
	self.text_area.y = self.text_area.y * self.start_scale.y

	self.is_no_adjust = no_adjust
	self.color = gui.get_color(self.node)

	self.on_set_text = Event()
	self.on_set_pivot = Event()
	self.on_update_text_scale = Event()

	self._space_width = {}

	self:set_to(value or gui.get_text(self.node))
	return self
end


--- Calculate text width with font with respect to trailing space
-- @function text:get_text_width
-- @tparam[opt] string text
function M.get_text_width(self, text)
	text = text or self.last_value
	local font = gui.get_font(self.node)
	local scale = gui.get_scale(self.node)
	local result = gui.get_text_metrics(font, text, 0, false, 0, 0).width
	for i = #text, 1, -1 do
		local c = string.sub(text, i, i)
		if c ~= ' ' then
			break
		end

		result = result + get_space_width(self, font)
	end

	return result * scale.x
end


--- Set text to text field
-- @function text:set_to
-- @tparam string set_to Text for node
function M.set_to(self, set_to)
	self.last_value = set_to
	gui.set_text(self.node, set_to)

	self.on_set_text:trigger(self:get_context(), set_to)

	if not self.is_no_adjust then
		update_text_area_size(self)
	end
end


--- Set color
-- @function text:set_color
-- @tparam vector4 color Color for node
function M.set_color(self, color)
	self.color = color
	gui.set_color(self.node, color)
end


--- Set alpha
-- @function text:set_alpha
-- @tparam number alpha Alpha for node
function M.set_alpha(self, alpha)
	self.color.w = alpha
	gui.set_color(self.node, self.color)
end


--- Set scale
-- @function text:set_scale
-- @tparam vector3 scale Scale for node
function M.set_scale(self, scale)
	self.last_scale = scale
	gui.set_scale(self.node, scale)
end


--- Set text pivot. Text will re-anchor inside
-- his text area
-- @function text:set_pivot
-- @tparam gui.pivot pivot Gui pivot constant
function M.set_pivot(self, pivot)
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
end


--- Return true, if text with line break
-- @function text:is_multiline
-- @treturn boolean Is text node with line break
function M.is_multiline(self)
	return gui.get_line_break(self.node)
end


return M
