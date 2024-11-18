local color = require("druid.color")

---@class widget.mini_graph: druid.widget
local M = {}

local SIZE_Y = hash("size.y")


function M:init()
	self.druid = self:get_druid()
	self.root = self:get_node("root")
	self.container = self.druid:new_container(self.root)
	self.text_header = self.druid:new_text("text_header")
	self.text_value = self.druid:new_text("text_value")
	self.drag_corner = self.druid:new_drag("icon_drag", self.on_drag_corner)
	self.layout = self.druid:new_layout("panel_diagram", "horizontal")
		:set_margin(0, 0)
		:set_padding(0, 0, 0, 0)

	self.prefab_line = self:get_node("prefab_line")
	gui.set_enabled(self.prefab_line, false)

	self.color_zero = color.hex2vector4("#8ED59E")
	self.color_one = color.hex2vector4("#F49B9B")

	self.lines = {}
	self.values = {}
	self.samples = 64
	local line_width = self.layout:get_size().x / self.samples
	for index = 1, self.samples do
		local line = gui.clone(self.prefab_line)
		gui.set_enabled(line, true)
		gui.set(line, "size.x", line_width)
		self.layout:add(line)
		table.insert(self.lines, line)
	end

	for index = 1, self.samples do
		local outsine = index/self.samples
		self:set_line_value(index, outsine)
	end
end


---@param index number
---@param value number The normalized value from 0 to 1
function M:set_line_value(index, value)
	local line = self.lines[index]
	if not line then
		return
	end

	local target_color = color.lerp(value * value, self.color_zero, self.color_one)
	gui.set(line, SIZE_Y, value * 70)
	gui.set_color(line, target_color)

	self.values[index] = value
end


---@return number
function M:get_line_value(index)
	return self.values[index]
end


function M:push_line_value(value)
	for index = 1, self.samples - 1 do
		self:set_line_value(index, self:get_line_value(index + 1), true)
	end

	self:set_line_value(self.samples, value, true)
end


---@param text string
function M:set_text(text)
	self.text_value:set_to(text)
end


function M:on_drag_corner(dx, dy)
	local position = self.container:get_position()
	self.container:set_position(position.x + dx, position.y + dy)
end


return M