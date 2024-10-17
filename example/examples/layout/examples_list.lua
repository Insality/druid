local M = {}

---@return druid.example.data[]
function M.get_examples()
	---@type druid.example.data[]
	return {
		{
			name_id = "ui_example_layout_basic",
			information_text_id = "ui_example_layout_basic_description",
			template = "basic_layout",
			root = "basic_layout/root",
			code_url = "example/examples/layout/basic/basic_layout.lua",
			component_class = require("example.examples.layout.basic.basic_layout"),
			properties_control = function(instance, properties_panel)
				---@cast instance basic_layout

				properties_panel:add_slider("ui_padding", 0, function(value)
					local padding = math.floor((value * 64) * 100) / 100
					instance.layout:set_padding(vmath.vector4(padding))
				end)

				properties_panel:add_slider("ui_margin_x", 0, function(value)
					local margin = math.floor((value * 64) * 100) / 100
					instance.layout:set_margin(margin, nil)
				end)

				properties_panel:add_slider("ui_margin_y", 0, function(value)
					local margin = math.floor((value * 64) * 100) / 100
					instance.layout:set_margin(nil, margin)
				end)

				properties_panel:add_checkbox("ui_justify", false, function(value)
					instance.layout:set_justify(value)
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
					instance:set_pivot(pivot_list[pivot_index])
				end)


				local type_index = 1
				local type_list = {
					"horizontal_wrap",
					"horizontal",
					"vertical",
				}

				properties_panel:add_button("ui_type_next", function()
					type_index = type_index + 1
					if type_index > #type_list then
						type_index = 1
					end
					instance.layout:set_type(type_list[type_index])
				end)
			end,
			get_debug_info = function(instance)
				---@cast instance basic_layout
				local layout = instance.layout
				local p = layout.padding
				local info = ""
				info = info .. "Layout: " .. layout.type .. "\n"
				info = info .. "Padding: " .. math.floor(p.x) .. " " .. math.floor(p.y) .. " " .. math.floor(p.z) .. " " .. math.floor(p.w) .. "\n"
				info = info .. "Margin: " .. layout.margin.x .. " " .. layout.margin.y .. "\n"
				info = info .. "Justify: " .. tostring(layout.is_justify) .. "\n"
				info = info .. "Pivot: " .. tostring(gui.get_pivot(layout.node)) .. "\n"

				return info
			end
		}
	}
end


return M