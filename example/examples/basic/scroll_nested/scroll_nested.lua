---@class examples.scroll_nested: druid.widget
---@field scroll_outer druid.scroll
---@field scroll_inner druid.scroll
local M = {}

local const = require("druid.const")

local INNER_CONTENT_SCROLLABLE = 700
local INNER_CONTENT_FIT = 200


function M:init()
	self.scroll_outer = self.druid:new_scroll("outer_view", "outer_content")
	self.scroll_inner = self.druid:new_scroll("inner_view", "inner_content")
	-- Prefer the nested scroll when the cursor is over it
	self.scroll_inner:set_input_priority(const.PRIORITY_INPUT_HIGH)

	self.inner_content = self:get_node("inner_content")
	self._inner_scrollable = true
end


---@param properties_panel properties_panel
function M:properties_control(properties_panel)
	local checkbox = properties_panel:add_checkbox("ui_inner_scrollable", true, function(value)
		self._inner_scrollable = value
		local size = gui.get_size(self.inner_content)
		size.y = value and INNER_CONTENT_SCROLLABLE or INNER_CONTENT_FIT
		self.scroll_inner:set_size(size)
	end)
	checkbox:set_value(true)
end


---@return string
function M:get_debug_info()
	local info = ""
	info = info .. "Outer can_y: " .. tostring(self.scroll_outer.drag.can_y) .. "\n"
	info = info .. "Inner can_y: " .. tostring(self.scroll_inner.drag.can_y) .. "\n"
	info = info .. "Inner scrollable: " .. tostring(self._inner_scrollable) .. "\n"
	info = info .. "Outer pos Y: " .. math.ceil(self.scroll_outer.position.y) .. "\n"
	info = info .. "Inner pos Y: " .. math.ceil(self.scroll_inner.position.y) .. "\n"
	return info
end


return M
