---@class examples.rich_text_glyphs: druid.widget
---@field rich_text druid.rich_text
local M = {}

-- Colors only split the text into words, the layout should stay the same
local RICH_TEXT = "Hello, <color=A1D7F5>World</color>! AVA WAY\n«Привет, <color=8ED59E>мир</color>!» 1 234.56\n(a) [b] {c}, x.y; <color=E6DF9F>i</color>l|il"


function M:init()
	self.rich_text = self.druid:new_rich_text("text") --[[@as druid.rich_text]]
	self.rich_text:set_text(RICH_TEXT)

	-- Same text in a regular text node below: glyphs should cover it exactly
	self.text_reference = self:get_node("text_reference")
	gui.set_text(self.text_reference, (RICH_TEXT:gsub("<.->", "")))
end


---@param pivot constant
function M:set_pivot(pivot)
	self.rich_text:set_pivot(pivot)
	gui.set_pivot(self.text_reference, pivot)
end


---@param properties_panel properties_panel
function M:properties_control(properties_panel)
	properties_panel:add_checkbox("ui_split_to_characters", false, function(value)
		self.rich_text:set_split_to_characters(value)
		self.rich_text:set_text(RICH_TEXT)
	end)

	local pivot_index = 1
	local pivot_list = {
		gui.PIVOT_CENTER,
		gui.PIVOT_W,
		gui.PIVOT_E,
	}
	properties_panel:add_button("ui_pivot_next", function()
		pivot_index = pivot_index % #pivot_list + 1
		self:set_pivot(pivot_list[pivot_index])
	end)
end


return M
