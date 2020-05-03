local M = {}


function M.setup_page(self)
	local slider = self.druid:new_slider("slider_simple_pin", vmath.vector3(95, 0, 0), function(_, value)
		gui.set_text(gui.get_node("slider_simple_text"), math.ceil(value * 100) .. "%")
	end)

	slider:set(0.2)

	local slider_notched = self.druid:new_slider("slider_notched_pin", vmath.vector3(95, 0, 0), function(_, value)
		gui.set_text(gui.get_node("slider_notched_text"), math.ceil(value * 100) .. "%")
	end)

	slider_notched:set_steps({0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1})
	slider_notched:set(0.2)
end


return M
