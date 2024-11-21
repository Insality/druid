local color = require("druid.color")

---@class widget.mini_graph: druid.widget
local M = {}

local SIZE_Y = hash("size.y")


function M:init()
	self.root = self:get_node("root")
	self.text_header = self.druid:new_text("text_header")

	self.druid:new_drag("header", self.on_drag_widget)
	self.druid:new_button("icon_drag", self.toggle_hide)
		:set_style(nil)

	self.content = self:get_node("content")
	self.layout = self.druid:new_layout(self.content, "horizontal")
		:set_margin(0, 0)
		:set_padding(0, 0, 0, 0)

	self.prefab_line = self:get_node("prefab_line")
	gui.set_enabled(self.prefab_line, false)

	local node_color_low = self:get_node("color_low")
	self.color_zero = gui.get_color(node_color_low)
	self.color_one = gui.get_color(self.prefab_line)
	gui.set_enabled(node_color_low, false)

	self.is_hidden = false
	self.max_value = 1 -- in this value line will be at max height
	self.lines = {}
	self.values = {}

	self.container = self.druid:new_container(self.root)
	self.container:add_container("header")
	self.default_size = self.container:get_size()
end


function M:on_remove()
	self:clear()
end


function M:clear()
	self.layout:clear_layout()
	for index = 1, #self.lines do
		gui.delete_node(self.lines[index])
	end

	self.lines = {}
end


function M:set_samples(samples)
	self.samples = samples
	self:clear()

	local line_width = self.layout:get_size().x / self.samples
	for index = 1, self.samples do
		local line = gui.clone(self.prefab_line)
		gui.set_enabled(line, true)
		gui.set(line, "size.x", line_width)
		self.layout:add(line)
		table.insert(self.lines, line)
	end
end


---@param index number
---@param value number The normalized value from 0 to 1
function M:set_line_value(index, value)
	local line = self.lines[index]
	if not line then
		return
	end

	self.values[index] = value

	local normalized = vmath.clamp(value/self.max_value, 0, 1)
	local target_color = color.lerp(normalized, self.color_zero, self.color_one)
	gui.set_color(line, target_color)
	self:set_line_height(index)

end


---@return number
function M:get_line_value(index)
	return self.values[index] or 0
end


function M:push_line_value(value)
	for index = 1, self.samples - 1 do
		self:set_line_value(index, self:get_line_value(index + 1))
	end

	self:set_line_value(self.samples, value)
end


function M:set_max_value(max_value)
	if self.max_value == max_value then
		return
	end

	self.max_value = max_value
	for index = 1, self.samples do
		self:set_line_height(index)
	end
end


function M:set_line_height(index)
	local value = self.values[index] or 0
	local normalized = vmath.clamp(value / self.max_value, 0, 1)
	local size_y = normalized * 70
	gui.set(self.lines[index], SIZE_Y, size_y)
end


function M:get_lowest_value()
	return math.min(unpack(self.values))
end


function M:get_highest_value()
	return math.max(unpack(self.values))
end


function M:on_drag_widget(dx, dy)
	local position = self.container:get_position()
	self.container:set_position(position.x + dx, position.y + dy)
end


function M:toggle_hide()
	self.is_hidden = not self.is_hidden
	local hidden_size = gui.get_size(self:get_node("header"))

	local new_size = self.is_hidden and hidden_size or self.default_size
	self.container:set_size(new_size.x, new_size.y, gui.PIVOT_N)

	gui.set_enabled(self.content, not self.is_hidden)

	return self
end


return M