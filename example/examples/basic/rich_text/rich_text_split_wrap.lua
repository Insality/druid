---@class examples.rich_text_split_wrap: druid.widget
---@field rich_text druid.rich_text
local M = {}

local WIDTH_MIN = 220
local WIDTH_MAX = 600

local RICH_TEXT = "Each letter is a node, but words still wrap as a whole. "
	.. "<img=druid_logo:icon_druid,32/> Space after an image stays.\n"
	.. "   Indent after a line break stays.\n"
	.. "This <nobr><color=8ED59E>part never breaks</color></nobr> and the rest wraps."


function M:init()
	self.rich_text = self.druid:new_rich_text("text") --[[@as druid.rich_text]]
	self.rich_text:set_split_to_characters(true)
	self.rich_text:set_text(RICH_TEXT)

	self.text_area_debug = self:get_node("text_area_debug")
	gui.set_size(self.text_area_debug, gui.get_size(self.rich_text.root))
end


---@param width number
function M:set_width(width)
	local size = gui.get_size(self.rich_text.root)
	size.x = width
	gui.set_size(self.rich_text.root, size)
	gui.set_size(self.text_area_debug, size)
	self.rich_text:set_text(RICH_TEXT)
end


---@param properties_panel properties_panel
function M:properties_control(properties_panel)
	local width = gui.get_size(self.rich_text.root).x
	properties_panel:add_slider("ui_width", (width - WIDTH_MIN) / (WIDTH_MAX - WIDTH_MIN), function(value)
		self:set_width(math.floor(WIDTH_MIN + value * (WIDTH_MAX - WIDTH_MIN)))
	end)

	properties_panel:add_checkbox("ui_split_to_characters", true, function(value)
		self.rich_text:set_split_to_characters(value)
		self.rich_text:set_text(RICH_TEXT)
	end)
end


return M
