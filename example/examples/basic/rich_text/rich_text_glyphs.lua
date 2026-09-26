---@class examples.rich_text_glyphs: druid.widget
---@field rich_text druid.rich_text
---@field is_rich_text_visible boolean
local M = {}

-- Colors only split the text into words, the layout should stay the same
local RICH_TEXT = "Hello, <color=A1D7F5>World</color>! AVA WAY\n«Привет, <color=8ED59E>мир</color>!» 1 234.56\n(a) [b] {c}, x.y; <color=E6DF9F>i</color>l|il"


function M:init()
	self.is_rich_text_visible = true
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
	self:set_rich_text_visible(self.is_rich_text_visible)
end


---Hide the rich text words to see the regular text node below.
---The reference node is a child of the rich text root, so the root stays enabled
---@param is_visible boolean
function M:set_rich_text_visible(is_visible)
	self.is_rich_text_visible = is_visible
	local words = self.rich_text:get_words() or {}
	for index = 1, #words do
		gui.set_enabled(words[index].node, is_visible)
	end
end


---@param properties_panel properties_panel
function M:properties_control(properties_panel)
	properties_panel:add_checkbox("ui_show_rich_text", true, function(value)
		self:set_rich_text_visible(value)
	end)

	properties_panel:add_checkbox("ui_split_to_characters", false, function(value)
		self.rich_text:set_split_to_characters(value)
		self.rich_text:set_text(RICH_TEXT)
		self:set_rich_text_visible(self.is_rich_text_visible)
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
