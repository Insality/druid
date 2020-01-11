--- Component to handle all GUI texts
-- Good working with localization system
-- @module base.text

local const = require("druid.const")
local settings = require("druid.settings")
local helper = require("druid.helper")

local M = {}
M.interest = {
	const.ON_CHANGE_LANGUAGE,
}


function M.init(self, node, value, is_locale, max_width)
	self.max_width = max_width
	self.node = helper.get_node(node)
	self.start_scale = gui.get_scale(self.node)
	self.scale = self.start_scale
	self.last_color = gui.get_color(self.node)

	if is_locale then
		self:translate(value)
	else
		self:set_to(value or 0)
	end

	return self
end


function M.translate(self, locale_id)
	self.last_locale = locale_id or self.last_locale
	self:set_to(settings.get_text(self.last_locale))
end


function M.on_change_language(self)
	if self.last_locale then
		M.translate(self)
	end
end


--- Setup scale x, but can only be smaller, than start text scale
local function setup_max_width(self)
	local metrics = gui.get_text_metrics_from_node(self.node)
	local cur_scale = gui.get_scale(self.node)

	local scale_modifier = self.max_width / metrics.width
	scale_modifier = math.min(scale_modifier, self.start_scale.x)
	local new_scale = vmath.vector3(scale_modifier, scale_modifier, cur_scale.z)
	gui.set_scale(self.node, new_scale)
	self.scale = new_scale
end


--- Set text to text field
-- @param set_to - set value to text field
function M.set_to(self, set_to)
	self.last_value = set_to
	gui.set_text(self.node, set_to)

	if self.max_width then
		setup_max_width(self)
	end
end


--- Set color
-- @param color
function M.set_color(self, color)
	self.last_color = color
	gui.set_color(self.node, color)
end


--- Set alpha
-- @param alpha, number [0-1]
function M.set_alpha(self, alpha)
	self.last_color.w = alpha
	gui.set_color(self.node, self.last_color)
end


--- Set scale
-- @param scale
function M.set_scale(self, scale)
	self.last_scale = scale
	gui.set_scale(self.node, scale)
end


return M
