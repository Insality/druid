--- Component to handle all GUI texts
-- Good working with localization system
-- @module base.text

local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.system.component")

local M = component.new("text")


function M.init(self, node, value, no_adjust)
	self.node = helper.get_node(node)
	self.start_pivot = gui.get_pivot(self.node)

	self.start_pos = gui.get_position(self.node)
	self.pos = gui.get_position(self.node)

	self.start_scale = gui.get_scale(self.node)
	self.scale = gui.get_scale(self.node)

	self.text_area = gui.get_size(self.node)
	self.text_area.x = self.text_area.x * self.start_scale.x
	self.text_area.y = self.text_area.y * self.start_scale.y

	self.is_no_adjust = no_adjust
	self.last_color = gui.get_color(self.node)

	self:set_to(value or 0)
	return self
end


--- Setup scale x, but can only be smaller, than start text scale
local function update_text_area_size(self)
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
end


--- Set text to text field
-- @function text:set_to
-- @tparam table self Component instance
-- @tparam string set_to Text for node
function M.set_to(self, set_to)
	self.last_value = set_to
	gui.set_text(self.node, set_to)

	if not self.is_no_adjust then
		update_text_area_size(self)
	end
end


--- Set color
-- @function text:set_color
-- @tparam table self Component instance
-- @tparam vmath.vector4 color Color for node
function M.set_color(self, color)
	self.last_color = color
	gui.set_color(self.node, color)
end


--- Set alpha
-- @function text:set_alpha
-- @tparam table self Component instance
-- @tparam number alpha Alpha for node
function M.set_alpha(self, alpha)
	self.last_color.w = alpha
	gui.set_color(self.node, self.last_color)
end


--- Set scale
-- @function text:set_scale
-- @tparam table self Component instance
-- @tparam vmath.vector3 scale Scale for node
function M.set_scale(self, scale)
	self.last_scale = scale
	gui.set_scale(self.node, scale)
end


--- Set text pivot. Text will re-anchor inside
-- his text area
-- @function text:set_pivot
-- @tparam table self Component instance
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
end


return M
