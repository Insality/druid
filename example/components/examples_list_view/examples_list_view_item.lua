local component = require("druid.component")
local container = require("example.components.container.container")
local lang_text = require("druid.extended.lang_text")

---@class examples_list_view_item: druid.base_component
---@field root druid.container
---@field text druid.lang_text
---@field druid druid_instance
---@field on_click druid.event
local M = component.create("examples_list_view_item")

---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.root = self.druid:new(container, "root") --[[@as druid.container]]
	self.text = self.druid:new(lang_text, "text") --[[ @as druid.lang_text]]
	self.icon = self:get_node("icon")
	self.selected = self:get_node("panel_selected")
	self.highlight = self:get_node("panel_highlight")

	self.color_not_selected = gui.get_color(self.text.node)
	self.color_selected = gui.get_outline(self.text.node)
	self.color_selected.w = 1
	self._is_folded = true

	self.button = self.druid:new_button("root")
	self.button:set_style(nil)

	local hover = self.druid:new_hover("root")
	hover.on_mouse_hover:subscribe(self.on_hover)

	-- External Events
	self.on_click = self.button.on_click
end


---@param is_enabled boolean
function M:set_fold_icon_enabled(is_enabled)
	gui.set_enabled(self.icon, is_enabled)
end


---@param is_folded boolean
function M:set_fold_status(is_folded)
	self._is_folded = is_folded
	gui.animate(self.icon, "euler.z", is_folded and 0 or -90, gui.EASING_OUTQUAD, 0.2)
end


function M:is_folded()
	return self._is_folded
end


function M:set_selected(is_selected)
	gui.set_enabled(self.selected, is_selected)

	local color = is_selected and self.color_selected or self.color_not_selected
	gui.set_color(self.text.node, color)
end


function M:on_hover(is_hover)
	if is_hover then
		gui.animate(self.highlight, "color.w", 1, gui.EASING_OUTQUAD, 0.2)
	else
		gui.animate(self.highlight, "color.w", 0, gui.EASING_OUTQUAD, 0.1)
	end
end


return M
