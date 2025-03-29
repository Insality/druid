local helper = require("druid.helper")

---@class examples.multiline_text: druid.widget
---@field root node
local M = {}

function M:init()
	self.root = self:get_node("root")
	self.text = self.druid:new_text("text")

	-- This code is for adjustable text area with mouse
	self.container = self.druid:new_container("text_area", nil, function(_, size)
		self.text:set_size(size)
		self:refresh_text_position()
	end) --[[@as druid.container]]

	self.container:create_draggable_corners()
end


function M:set_pivot(pivot)
	self.text:set_pivot(pivot)
	self:refresh_text_position()
end


function M:refresh_text_position()
	-- Need to update text position with different pivot
	local pivot = gui.get_pivot(self.text.node)
	local pivot_offset = helper.get_pivot_offset(pivot)
	gui.set_position(self.text.node, vmath.vector3(pivot_offset.x * self.text.start_size.x, pivot_offset.y * self.text.start_size.y, 0))
end


---@param properties_panel properties_panel
function M:properties_control(properties_panel)
	local adjust_index = 1
	local adjust_types = {
		"downscale",
		"downscale_limited",
		--"scale_then_scroll", -- works bad with container for some reason
		--"scroll", -- works bad with container for some reason
		"trim",
	}
	properties_panel:add_button("ui_adjust_next", function()
		adjust_index = adjust_index + 1
		if adjust_index > #adjust_types then
			adjust_index = 1
		end
		self.text:set_text_adjust(adjust_types[adjust_index], 0.8)
	end)

	local pivot_index = 1
	local pivot_list = {
		gui.PIVOT_CENTER,
		gui.PIVOT_W,
		gui.PIVOT_SW,
		gui.PIVOT_S,
		gui.PIVOT_SE,
		gui.PIVOT_E,
		gui.PIVOT_NE,
		gui.PIVOT_N,
		gui.PIVOT_NW,
	}

	properties_panel:add_button("ui_pivot_next", function()
		pivot_index = pivot_index + 1
		if pivot_index > #pivot_list then
			pivot_index = 1
		end
		self:set_pivot(pivot_list[pivot_index])
	end)
end


---@return string
function M:get_debug_info()
	local info = ""

	info = info .. "Text Adjust: " .. self.text.adjust_type .. "\n"
	info = info .. "Pivot: " .. gui.get_pivot(self.text.node) .. "\n"

	return info
end


return M
