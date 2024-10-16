local component = require("druid.component")
local lang_text = require("druid.extended.lang_text")

---@class property_button: druid.base_component
---@field root node
---@field text_name druid.lang_text
---@field button druid.button
---@field text_button druid.text
---@field druid druid_instance
local M = component.create("property_button")

---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.root = self:get_node("root")
	self.text_name = self.druid:new(lang_text, "text_name") --[[@as druid.lang_text]]
	self.selected = self:get_node("selected")
	gui.set_alpha(self.selected, 0)

	self.button = self.druid:new_button("button", self.on_click)
	self.text_button = self.druid:new_text("text_button")
end


function M:on_click()
	gui.set_alpha(self.selected, 1)
	gui.animate(self.selected, "color.w", 0, gui.EASING_INSINE, 0.16)
end


return M
