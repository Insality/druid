local component = require("druid.component")

---@class examples.scroll_slider: druid.component
---@field root node
---@field scroll druid.scroll
---@field slider druid.slider
---@field druid druid.instance
local M = component.create("scroll_slider")

---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.scroll = self.druid:new_scroll("scroll_view", "scroll_content")
	self.scroll.on_scroll:subscribe(self.on_scroll)

	self.slider = self.druid:new_slider("slider_pin", vmath.vector3(-8, -976, 0), self.on_slider) --[[@as druid.slider]]
	self.slider:set_input_node("slider_back")

	self.druid:new_hover("slider_back", nil, self.on_slider_back_hover)

	for index = 1, 13 do
		self.druid:new_button("button" .. index .. "/root", self.on_button_click)
	end
end


function M:on_scroll()
	local scroll_percent = self.scroll:get_percent()
	self.slider:set(1 - scroll_percent.y, true)
end


function M:on_slider(value)
	self.scroll:scroll_to_percent(vmath.vector3(0, 1 - value, 0), true)
end


---@param button druid.button
function M:on_button_click(_, button)
	local node = button.node
	self.scroll:scroll_to(gui.get_position(node))
end


function M:on_slider_back_hover(is_hover)
	local node = self:get_node("slider_pin")
	gui.animate(node, "color.w", is_hover and 1.5 or 1, gui.EASING_OUTSINE, 0.2)
end


return M
