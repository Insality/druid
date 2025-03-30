local helper = require("druid.helper")

---@class examples.rich_text_tags: druid.widget
---@field rich_text_color druid.rich_text
---@field rich_text_font druid.rich_text
---@field rich_text_size druid.rich_text
---@field rich_text_breaks druid.rich_text
---@field rich_text_image druid.rich_text
---@field position table
local M = {}


function M:init()
	self.rich_text_color = self.druid:new_rich_text("rich_text_color") --[[@as druid.rich_text]]
	self.rich_text_color:set_text("Hello, I'm a <color=E48155>Rich Text</color> and it's <color=8ED59E>nested <color=A1D7F5>color</color> tag</color>")

	self.rich_text_font = self.druid:new_rich_text("rich_text_font") --[[@as druid.rich_text]]
	self.rich_text_font:set_text("Hello, I'm a <font=text_bold>Rich Text</font> and this is <font=text_bold><color=8ED59E>bold text</color></font>")

	self.rich_text_size = self.druid:new_rich_text("rich_text_size") --[[@as druid.rich_text]]
	self.rich_text_size:set_text("Hello, I'm have <size=1.15><font=text_bold>East Pivot</font></size> and <size=0.85><font=text_bold>different text scale</font></size>")

	self.rich_text_breaks = self.druid:new_rich_text("rich_text_breaks") --[[@as druid.rich_text]]
	self.rich_text_breaks:set_text("Hello, I'm Rich Text<br/>With \"<color=E6DF9F>Line Breaks</color>\"\nEnabled in GUI")

	self.rich_text_image = self.druid:new_rich_text("rich_text_image") --[[@as druid.rich_text]]
	self.rich_text_image:set_text("Hello, I'm<img=druid_example:icon_cross,32/>Rich Text <img=druid_logo:icon_druid,48/> <color=8ED59E><img=druid_logo:icon_druid,48/></color> <color=F49B9B><img=druid_logo:icon_druid,48/></color>")

	self.position = {
		[self.rich_text_color] = gui.get_position(self.rich_text_color.root),
		[self.rich_text_font] = gui.get_position(self.rich_text_font.root),
		[self.rich_text_size] = gui.get_position(self.rich_text_size.root),
		[self.rich_text_breaks] = gui.get_position(self.rich_text_breaks.root),
		[self.rich_text_image] = gui.get_position(self.rich_text_image.root),
	}
	-- Adjust positions with pivots
	for rich_text, pos in pairs(self.position) do
		local size_x = gui.get(rich_text.root, "size.x")
		local size_y = gui.get(rich_text.root, "size.y")
		local parent_pivot = gui.get_pivot(rich_text.root)
		local pivot_offset = helper.get_pivot_offset(parent_pivot)
		local offset_x = size_x * pivot_offset.x
		local offset_y = size_y * pivot_offset.y
		pos.x = pos.x - offset_x
		pos.y = pos.y - offset_y
	end
end


function M:set_pivot(pivot)
	local rich_texts = {
		self.rich_text_color,
		self.rich_text_font,
		self.rich_text_size,
		self.rich_text_breaks,
		self.rich_text_image,
	}

	for _, rich_text in ipairs(rich_texts) do
		gui.set_pivot(rich_text.root, pivot)
		local pos = self.position[rich_text]
		local size_x = gui.get(rich_text.root, "size.x")
		local size_y = gui.get(rich_text.root, "size.y")
		local parent_pivot = gui.get_pivot(rich_text.root)
		local pivot_offset = helper.get_pivot_offset(parent_pivot)
		local offset_x = size_x * pivot_offset.x
		local offset_y = size_y * pivot_offset.y
		gui.set_position(rich_text.root, vmath.vector3(pos.x + offset_x, pos.y + offset_y, pos.z))
		rich_text:set_text(rich_text:get_text())
	end
end


---@param properties_panel properties_panel
function M:properties_control(properties_panel)
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
