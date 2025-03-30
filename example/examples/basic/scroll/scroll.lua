local component = require("druid.component")

---@class examples.scroll: druid.widget
---@field root node
---@field scroll druid.scroll
local M = {}

function M:init()
	self.scroll = self.druid:new_scroll("scroll_view", "scroll_content")

	self.button_tutorial = self.druid:new_button("button_tutorial/root")
	self.button_stencil = self.druid:new_button("button_stencil/root")
end


---@param output_log output_list
function M:on_example_created(output_log)
	self.button_tutorial.on_click:subscribe(function()
		output_log:add_log_text("Button Tutorial Clicked")
	end)
	self.button_stencil.on_click:subscribe(function()
		output_log:add_log_text("Button Stencil Clicked")
	end)
end


---@param properties_panel properties_panel
function M:properties_control(properties_panel)
	local scroll = self.scroll
	local is_stretch = self.scroll.style.EXTRA_STRETCH_SIZE > 0
	properties_panel:add_checkbox("ui_elastic_scroll", is_stretch, function(value)
		self.scroll:set_extra_stretch_size(value and 100 or 0)
	end)

	local view_node = self.scroll.view_node
	local is_stencil = gui.get_clipping_mode(view_node) == gui.CLIPPING_MODE_STENCIL
	properties_panel:add_checkbox("ui_clipping", is_stencil, function(value)
		gui.set_clipping_mode(view_node, value and gui.CLIPPING_MODE_STENCIL or gui.CLIPPING_MODE_NONE)
	end)

	local slider_frict = properties_panel:add_slider("ui_slider_friction", 0, function(value)
		scroll.style.FRICT = 1 - ((1 - value) * 0.1)
	end)
	slider_frict:set_text_function(function(value)
		return string.format("%.2f", 1 - ((1 - value) * 0.1))
	end)
	slider_frict:set_value(1 - (1 - scroll.style.FRICT) / 0.1)

	local slider_speed = properties_panel:add_slider("ui_slider_speed", 0, function(value)
		scroll.style.INERT_SPEED = value * 50
	end)
	slider_speed:set_value(scroll.style.INERT_SPEED / 50)
	slider_speed:set_text_function(function(value)
		return string.format("%.1f", value * 50)
	end)

	local slider_wheel_speed = properties_panel:add_slider("ui_slider_wheel_speed", 0, function(value)
		scroll.style.WHEEL_SCROLL_SPEED = value * 30
	end)
	slider_wheel_speed:set_value(scroll.style.WHEEL_SCROLL_SPEED / 30)
	slider_wheel_speed:set_text_function(function(value)
		return string.format("%.1f", value * 30)
	end)

	local wheel_by_inertion = properties_panel:add_checkbox("ui_wheel_by_inertion", scroll.style.WHEEL_SCROLL_BY_INERTION, function(value)
		scroll.style.WHEEL_SCROLL_BY_INERTION = value
	end)
	wheel_by_inertion:set_value(scroll.style.WHEEL_SCROLL_BY_INERTION)
end


---@return string
function M:get_debug_info()
	local info = ""

	local s = self.scroll
	info = info .. "View Size Y: " .. gui.get(s.view_node, "size.y") .. "\n"
	info = info .. "Content Size Y: " .. gui.get(s.content_node, "size.y") .. "\n"
	info = info .. "Content position Y: " .. math.ceil(s.position.y) .. "\n"
	info = info .. "Content Range Y: " .. s.available_pos.y .. " - " .. s.available_pos.w .. "\n"

	return info
end


return M
