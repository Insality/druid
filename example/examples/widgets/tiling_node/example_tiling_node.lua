local tiling_node = require("druid.custom.tiling_node.tiling_node")

---@class examples.example_tiling_node: druid.widget
local M = {}


function M:init()
	self.tiling_node = self.druid:new(tiling_node, self:get_node("tiling_node"))
end


---@param properties_panel properties_panel
function M:properties_control(properties_panel)
	properties_panel:add_slider("Repeat X", 0, function(value)
		local repeat_x = math.floor(value * 10)
		self.tiling_node:set_repeat(repeat_x, nil)
	end)
	properties_panel:add_slider("Repeat Y", 0, function(value)
		local repeat_y = math.floor(value * 10)
		self.tiling_node:set_repeat(nil, repeat_y)
	end)
	properties_panel:add_slider("Offset X", 0, function(value)
		self.tiling_node:set_offset(value, nil)
	end)
	properties_panel:add_slider("Offset Y", 0, function(value)
		self.tiling_node:set_offset(nil, value)
	end)
	properties_panel:add_slider("Margin X", 0, function(value)
		self.tiling_node:set_margin(value, nil)
	end)
	properties_panel:add_slider("Margin Y", 0, function(value)
		self.tiling_node:set_margin(nil, value)
	end)
end


return M
