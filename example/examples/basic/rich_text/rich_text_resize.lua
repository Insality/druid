local helper = require("druid.helper")

---@class examples.rich_text_resize: druid.widget
---@field rich_text druid.rich_text
---@field position vector3
local M = {}

local WIDTH_MIN = 80
local WIDTH_MAX = 600
local HEIGHT_MIN = 60
local HEIGHT_MAX = 520

local LONG_TEXT = "This is a <color=E48155>long rich text</color> example. You can resize the text area using the sliders on the right. "
	.. "The text will <font=text_bold>wrap and adjust</font> to fit within the new width and height. "
	.. "Try making the area smaller to see how <color=8ED59E>multiline rich text</color> scales and fits. "
	.. "The adjust_to_area feature will scale down the text if it does not fit in the available space."


function M:init()
	self.rich_text = self.druid:new_rich_text("text") --[[@as druid.rich_text]]
	self.rich_text:set_text(LONG_TEXT)

	self.node_text_area_debug = self:get_node("text_area_debug")
	gui.set_size(self.node_text_area_debug, vmath.vector3(gui.get_size(self.rich_text.root)))

	local pos = gui.get_position(self.rich_text.root)
	local size_x = gui.get(self.rich_text.root, "size.x")
	local size_y = gui.get(self.rich_text.root, "size.y")
	local parent_pivot = gui.get_pivot(self.rich_text.root)
	local pivot_offset = helper.get_pivot_offset(parent_pivot)
	self.position = vmath.vector3(
		pos.x - size_x * pivot_offset.x,
		pos.y - size_y * pivot_offset.y,
		pos.z
	)
end


function M:set_pivot(pivot)
	gui.set_pivot(self.rich_text.root, pivot)
	local size_x = gui.get(self.rich_text.root, "size.x")
	local size_y = gui.get(self.rich_text.root, "size.y")
	local pivot_offset = helper.get_pivot_offset(pivot)
	gui.set_position(self.rich_text.root, vmath.vector3(
		self.position.x + size_x * pivot_offset.x,
		self.position.y + size_y * pivot_offset.y,
		self.position.z
	))
	self.rich_text:set_text(self.rich_text:get_text())
end


---@param properties_panel properties_panel
function M:properties_control(properties_panel)
	local size = gui.get_size(self.rich_text.root)
	local width_norm = (size.x - WIDTH_MIN) / (WIDTH_MAX - WIDTH_MIN)
	local height_norm = (size.y - HEIGHT_MIN) / (HEIGHT_MAX - HEIGHT_MIN)

	properties_panel:add_slider("ui_width", width_norm, function(value)
		local w = math.floor(WIDTH_MIN + value * (WIDTH_MAX - WIDTH_MIN))
		local s = gui.get_size(self.rich_text.root)
		gui.set_size(self.rich_text.root, vmath.vector3(w, s.y, 0))
		self.rich_text:set_text(self.rich_text:get_text())
		gui.set_size(self.node_text_area_debug, vmath.vector3(w, s.y, 0))
	end)

	properties_panel:add_slider("ui_height", height_norm, function(value)
		local h = math.floor(HEIGHT_MIN + value * (HEIGHT_MAX - HEIGHT_MIN))
		local s = gui.get_size(self.rich_text.root)
		gui.set_size(self.rich_text.root, vmath.vector3(s.x, h, 0))
		self.rich_text:set_text(self.rich_text:get_text())
		gui.set_size(self.node_text_area_debug, vmath.vector3(s.x, h, 0))
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


return M
